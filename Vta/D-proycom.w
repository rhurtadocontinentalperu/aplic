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
/* DEFINE VARIABLE pv-codcia AS INTEGER INITIAL 0. */
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
DEFINE SHARED VAR S-CODCIA  AS INTEGER.
DEFINE SHARED VAR PV-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV  AS CHAR.
DEFINE SHARED VAR S-NOMCIA  AS CHAR.
DEFINE SHARED VAR S-CODALM  AS CHAR.
DEFINE VARIABLE F-DIRDIV    AS CHAR.
DEFINE VARIABLE F-PUNTO     AS CHAR.
DEFINE VARIABLE X-PUNTO     AS CHAR.
DEFINE VARIABLE X-DIVI      AS CHAR INIT "00000".
DEFINE VARIABLE X-CODALM    AS CHAR INIT "".
DEFINE VARIABLE X-CODDIV    AS CHAR INIT "".


DEFINE TEMP-TABLE Temporal 
       FIELD CODCIA    LIKE CcbcDocu.Codcia
       FIELD PERIODO   AS  INTEGER FORMAT "9999"
       FIELD CODMAT    LIKE Almmmatg.Codmat
       FIELD DESMAT    LIKE Almmmatg.DesMat
       FIELD DESMAR    LIKE Almmmatg.DesMar
       FIELD UNIDAD    LIKE Almmmatg.UndStk
       FIELD CLASE     AS   CHAR FORMAT "X(1)"
       FIELD ENE       AS   DECI EXTENT 2
       FIELD FEB       AS   DECI EXTENT 2
       FIELD MAR       AS   DECI EXTENT 2
       FIELD ABR       AS   DECI EXTENT 2
       FIELD MAY       AS   DECI EXTENT 2
       FIELD JUN       AS   DECI EXTENT 2
       FIELD JUL       AS   DECI EXTENT 2
       FIELD AGO       AS   DECI EXTENT 2
       FIELD SEP       AS   DECI EXTENT 2
       FIELD OCT       AS   DECI EXTENT 2
       FIELD NOV       AS   DECI EXTENT 2
       FIELD DIC       AS   DECI EXTENT 2
       FIELD TOT       AS   DECI EXTENT 2
       FIELD STK       AS   DECI EXTENT 2
       FIELD CodPr1    LIKE Almmmatg.CodPr1
       FIELD Nompro    LIKE GN-PROV.Nompro
       FIELD Ctotot    LIKE Almmmatg.Ctotot
       INDEX LLAVE01 CODCIA CODMAT PERIODO .

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
&Scoped-Define ENABLED-OBJECTS F-prov1 F-prov2 f-desde f-hasta f-cate ~
R-Zona R-Orden B-expor RADIO-SET-1 RB-NUMBER-COPIES B-impresoras B-imprime ~
RB-BEGIN-PAGE B-cancela RB-END-PAGE RECT-54 RECT-59 RECT-60 
&Scoped-Define DISPLAYED-OBJECTS F-prov1 F-prov2 f-desde f-hasta f-cate ~
R-Zona R-Orden FILL-IN-1 RADIO-SET-1 RB-NUMBER-COPIES RB-BEGIN-PAGE ~
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

DEFINE BUTTON B-expor 
     IMAGE-UP FILE "img\excel":U
     LABEL "Exportar" 
     SIZE 7.14 BY 1.23.

DEFINE BUTTON B-impresoras 
     IMAGE-UP FILE "IMG/pvprint":U
     IMAGE-DOWN FILE "IMG/pvprintd":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON B-imprime AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "&Imprimir" 
     SIZE 10.57 BY 1.5.

DEFINE VARIABLE f-cate AS CHARACTER FORMAT "X":U 
     LABEL "Categoria" 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .69 NO-UNDO.

DEFINE VARIABLE f-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE f-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-prov1 AS CHARACTER FORMAT "X(8)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-prov2 AS CHARACTER FORMAT "X(8)":U 
     LABEL "A" 
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

DEFINE VARIABLE R-Orden AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Codigo", 1,
"Descripcion", 2
     SIZE 10.86 BY 1.15 NO-UNDO.

DEFINE VARIABLE R-Zona AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Ate", 1,
"Lima", 2
     SIZE 8.57 BY 1.15 NO-UNDO.

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
     SIZE 47.29 BY 3.12.

DEFINE RECTANGLE RECT-60
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 47 BY 1.65.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     F-prov1 AT ROW 1.69 COL 9.29 COLON-ALIGNED
     F-prov2 AT ROW 1.69 COL 23.43 COLON-ALIGNED
     f-desde AT ROW 2.5 COL 9.29 COLON-ALIGNED
     f-hasta AT ROW 2.5 COL 23.57 COLON-ALIGNED
     f-cate AT ROW 3.35 COL 9.29 COLON-ALIGNED
     R-Zona AT ROW 4.77 COL 11.29 NO-LABEL
     R-Orden AT ROW 4.69 COL 29.14 NO-LABEL
     B-expor AT ROW 4.65 COL 42.14
     FILL-IN-1 AT ROW 6.12 COL 2.86 NO-LABEL
     RADIO-SET-1 AT ROW 8.04 COL 4.29 NO-LABEL
     RB-NUMBER-COPIES AT ROW 11.77 COL 10.86 COLON-ALIGNED
     B-impresoras AT ROW 9.15 COL 16.72
     b-archivo AT ROW 10.15 COL 16.86
     RB-OUTPUT-FILE AT ROW 10.27 COL 20.57 COLON-ALIGNED NO-LABEL
     B-imprime AT ROW 7.92 COL 27.72
     RB-BEGIN-PAGE AT ROW 11.77 COL 24.86 COLON-ALIGNED
     B-cancela AT ROW 7.92 COL 38.86
     RB-END-PAGE AT ROW 11.77 COL 40 COLON-ALIGNED
     " Configuracion de Impresion" VIEW-AS TEXT
          SIZE 47 BY .62 AT ROW 6.88 COL 2.86
          BGCOLOR 1 FGCOLOR 15 FONT 6
     "Paginas" VIEW-AS TEXT
          SIZE 8.14 BY .58 AT ROW 11.08 COL 33.43
          FONT 6
     "Zona" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 5 COL 5
          FONT 1
     "Orden" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 5.04 COL 22
          FONT 1
     RECT-54 AT ROW 1 COL 1.72
     RECT-59 AT ROW 1.23 COL 2.86
     RECT-60 AT ROW 4.42 COL 3.14
     SPACE(1.57) SKIP(7.46)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Reporte de Ventas(Proyeccion de Compra)".


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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Reporte de Ventas(Proyeccion de Compra) */
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


&Scoped-define SELF-NAME B-expor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-expor D-Dialog
ON CHOOSE OF B-expor IN FRAME D-Dialog /* Exportar */
DO:
  ASSIGN f-prov1 f-prov2 f-cate R-zona f-desde f-hasta R-Orden.
  
  IF F-prov2 = "" THEN F-prov2 = "ZZZZZZZZZZZZZ".

  RUN Carga-Tabla.
  
  CASE R-Orden :
     WHEN 1 THEN RUN Exporta.
     WHEN 2 THEN RUN Exporta2.
  END.


  

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

  ASSIGN f-prov1 f-prov2 f-cate R-zona f-desde f-hasta R-Orden.
  
  IF F-prov2 = "" THEN F-prov2 = "ZZZZZZZZZZZZZ".

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


&Scoped-define SELF-NAME f-cate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-cate D-Dialog
ON LEAVE OF f-cate IN FRAME D-Dialog /* Categoria */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND PORCOMI WHERE PORCOMI.CODCIA = S-CODCIA 
                AND  PORCOMI.CATEGO = SELF:SCREEN-VALUE 
               NO-LOCK NO-ERROR.
  IF NOT AVAILABLE PORCOMI THEN DO:
    MESSAGE "Categoria no Existe " VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY":U TO F-cate.
    RETURN NO-APPLY.
  END.  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-prov1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-prov1 D-Dialog
ON LEAVE OF F-prov1 IN FRAME D-Dialog /* Proveedor */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND GN-PROV WHERE GN-PROV.CODCIA = pv-codcia 
                AND  GN-PROV.CODPRO = SELF:SCREEN-VALUE 
               NO-LOCK NO-ERROR.
  IF NOT AVAILABLE GN-PROV THEN DO:
    MESSAGE "Codigo de proveedor no existe" VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY":U TO F-prov1.
    RETURN NO-APPLY.
  END.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-prov2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-prov2 D-Dialog
ON LEAVE OF F-prov2 IN FRAME D-Dialog /* A */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND GN-PROV WHERE GN-PROV.CODCIA = pv-codcia 
                AND  GN-PROV.CODPRO = SELF:SCREEN-VALUE 
               NO-LOCK NO-ERROR.
  IF NOT AVAILABLE GN-PROV THEN DO:
    MESSAGE "Codigo de proveedor no existe" VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY":U TO F-prov2.
    RETURN NO-APPLY.
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
DEFINE VAR F-FACTOR AS INTEGER .
DEFINE VAR X-TIPO AS INTEGER INIT 1.
def var j as integer init 0.

/*case R-Zona:
 *     when 1 then j = 2.
 *     when 2 then j = 1.
 * end case.*/
    
    
X-CODALM = "".
X-CODDIV = "".

FOR EACH Almacen WHERE Almacen.Codcia = S-CODCIA :
    IF R-Zona = 1 THEN DO:
     IF Almacen.Coddiv <> X-DIVI THEN NEXT.
    END. 
    ELSE DO:
     IF Almacen.Coddiv  = X-DIVI THEN NEXT.
    END.
    X-CODALM = X-CODALM + Almacen.CodAlm + "/" .
END.



FOR EACH Gn-Divi NO-LOCK WHERE Gn-Divi.Codcia = S-CODCIA:

 IF R-Zona = 1 THEN DO:
  IF Gn-Divi.Coddiv <> X-DIVI THEN NEXT.
 END. 
 ELSE DO:
  IF Gn-Divi.Coddiv  = X-DIVI THEN NEXT.
 END.
 
 X-CODDIV = X-CODDIV + Gn-Divi.Coddiv + "/" .
 
 FOR EACH CcbCdocu NO-LOCK WHERE NOT L-SALIR AND
          CcbCdocu.CodCia = S-CODCIA AND
          CcbCdocu.CodDiv = Gn-Divi.CodDiv AND
          CCbCdocu.FchDoc >= f-desde AND 
          CcbCdocu.FchDoc <= f-hasta AND
          LOOKUP(CcbCdocu.CodDoc,"FAC,BOL,N/C") > 0 AND
          CcbCDocu.FlgEst <> "A" 
          USE-INDEX LLAVE10 , 
          EACH CcbDdocu OF ccbCdocu NO-LOCK , 
 
          FIRST Almmmatg OF CcbDdocu NO-LOCK :
          
          IF NOT AVAILABLE Almmmatg THEN NEXT .
          
          IF (Almmmatg.CodPr1 > F-prov2 OR 
              Almmmatg.CodPr1 < F-prov1) THEN NEXT.

          IF TRIM(F-Cate) <> "" THEN DO:
             IF Almmmatg.tipart <> F-Cate THEN NEXT .
          END.

          IF Almmmatg.CodFam <> "001" THEN NEXT.
          
          F-FACTOR  = 1.
 
          X-TIPO    = IF LOOKUP(CcbdDocu.Coddoc,"N/C") > 0 THEN -1 ELSE 1.          
 

          ASSIGN 
              FILL-IN-1 = CcbDdocu.CodMat + " " + Almmmatg.DesMat.
              DISPLAY fill-in-1 WITH FRAME {&FRAME-NAME}.
            
                   
          FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas AND  
                              Almtconv.Codalter = Ccbddocu.UndVta
                              NO-LOCK NO-ERROR.
                
          IF AVAILABLE Almtconv THEN DO:
           F-FACTOR = Almtconv.Equival.
           IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
          END.

          FIND Temporal WHERE 
               Temporal.Codcia  = S-CODCIA AND
               Temporal.Codmat  = CcbDDocu.CodMat AND
               Temporal.Periodo = YEAR(CcbdDocu.FchDoc) 
               NO-ERROR .
                                         
          IF NOT AVAILABLE Temporal THEN DO:
             CREATE Temporal.
                 ASSIGN 
                 Temporal.Codcia   = S-CODCIA
                 Temporal.clase    = Almmmatg.tipart 
                 Temporal.Periodo  = YEAR(CcbdDocu.FchDoc)
                 Temporal.CodMat   = Almmmatg.Codmat
                 Temporal.DesMat   = Almmmatg.DesMat
                 Temporal.DesMar   = Almmmatg.DesMar
                 Temporal.Unidad   = Almmmatg.UndStk
                 Temporal.CodPr1   = Almmmatg.CodPr1
                 Temporal.Ctotot   = Almmmatg.Ctotot.
             
             FIND GN-PROV WHERE GN-PROV.CODCIA = pv-codcia 
                           AND  GN-PROV.CODPRO = Almmmatg.CodPr1 NO-LOCK NO-ERROR.
             IF AVAILABLE GN-PROV THEN Temporal.Nompro  = GN-PROV.Nompro.
    
             FOR EACH Almacen WHERE Almacen.Codcia = S-CODCIA :
                 IF R-Zona = 1 THEN DO:
                   IF Almacen.Coddiv <> X-DIVI THEN NEXT.
                 END. 
                 ELSE DO:
                   IF Almacen.Coddiv  = X-DIVI THEN NEXT.
                 END.
                
                 FIND FIRST Almmmate WHERE Almmmate.CodCia = S-CODCIA AND
                                           Almmmate.CodAlm = Almacen.CodAlm  AND
                                           Almmmate.CodMat = Almmmatg.CodMat
                                           NO-LOCK NO-ERROR.
                 IF AVAILABLE Almmmate THEN 
                    ASSIGN
                    Temporal.Stk[1]  = Temporal.Stk[1] + Almmmate.StkAct
                    Temporal.Stk[2]  = Temporal.Stk[2] + ( Almmmate.StkAct * Almmmatg.Ctotot ) / (If Almmmatg.MonVta = 2 THEN 1 ELSE Almmmatg.Tpocmb).
.
             END.   
                 
          END.       
          

          CASE MONTH(CcbdDocu.FchDoc) :
            WHEN 01 THEN ASSIGN
            Temporal.ENE[1] = Temporal.ENE[1] +  X-TIPO * ( CcbDdocu.CanDes * F-FACTOR )
            Temporal.ENE[2] = Temporal.ENE[2] +  X-TIPO * ( Ccbddocu.ImpLin ) / (If CcbcDocu.codmon = 2 THEN 1 ELSE Ccbcdocu.Tpocmb).
            WHEN 02 THEN ASSIGN
            Temporal.FEB[1] = Temporal.FEB[1] +  X-TIPO * ( CcbDdocu.CanDes * F-FACTOR )
            Temporal.FEB[2] = Temporal.FEB[2] +  X-TIPO * ( Ccbddocu.ImpLin ) / (If CcbcDocu.codmon = 2 THEN 1 ELSE Ccbcdocu.Tpocmb).
            WHEN 03 THEN ASSIGN
            Temporal.MAR[1] = Temporal.MAR[1] +  X-TIPO * ( CcbDdocu.CanDes * F-FACTOR )
            Temporal.MAR[2] = Temporal.MAR[2] +  X-TIPO * ( Ccbddocu.ImpLin ) / (If CcbcDocu.codmon = 2 THEN 1 ELSE Ccbcdocu.Tpocmb).
            WHEN 04 THEN ASSIGN
            Temporal.ABR[1] = Temporal.ABR[1] +  X-TIPO * ( CcbDdocu.CanDes * F-FACTOR )
            Temporal.ABR[2] = Temporal.ABR[2] +  X-TIPO * ( Ccbddocu.ImpLin ) / (If CcbcDocu.codmon = 2 THEN 1 ELSE Ccbcdocu.Tpocmb).
            WHEN 05 THEN ASSIGN
            Temporal.MAY[1] = Temporal.MAY[1] +  X-TIPO * ( CcbDdocu.CanDes * F-FACTOR )
            Temporal.MAY[2] = Temporal.MAY[2] +  X-TIPO * ( Ccbddocu.ImpLin ) / (If CcbcDocu.codmon = 2 THEN 1 ELSE Ccbcdocu.Tpocmb).
            WHEN 06 THEN ASSIGN
            Temporal.JUN[1] = Temporal.JUN[1] +  X-TIPO * ( CcbDdocu.CanDes * F-FACTOR )
            Temporal.JUN[2] = Temporal.JUN[2] +  X-TIPO * ( Ccbddocu.ImpLin ) / (If CcbcDocu.codmon = 2 THEN 1 ELSE Ccbcdocu.Tpocmb).
            WHEN 07 THEN ASSIGN
            Temporal.JUL[1] = Temporal.JUL[1] +  X-TIPO * ( CcbDdocu.CanDes * F-FACTOR )
            Temporal.JUL[2] = Temporal.JUL[2] +  X-TIPO * ( Ccbddocu.ImpLin ) / (If CcbcDocu.codmon = 2 THEN 1 ELSE Ccbcdocu.Tpocmb).
            WHEN 08 THEN ASSIGN
            Temporal.AGO[1] = Temporal.AGO[1] +  X-TIPO * ( CcbDdocu.CanDes * F-FACTOR )
            Temporal.AGO[2] = Temporal.AGO[2] +  X-TIPO * ( Ccbddocu.ImpLin ) / (If CcbcDocu.codmon = 2 THEN 1 ELSE Ccbcdocu.Tpocmb).
            WHEN 09 THEN ASSIGN
            Temporal.SEP[1] = Temporal.SEP[1] +  X-TIPO * ( CcbDdocu.CanDes * F-FACTOR )
            Temporal.SEP[2] = Temporal.SEP[2] +  X-TIPO * ( Ccbddocu.ImpLin ) / (If CcbcDocu.codmon = 2 THEN 1 ELSE Ccbcdocu.Tpocmb).
            WHEN 10 THEN ASSIGN
            Temporal.OCT[1] = Temporal.OCT[1] +  X-TIPO * ( CcbDdocu.CanDes * F-FACTOR )
            Temporal.OCT[2] = Temporal.OCT[2] +  X-TIPO * ( Ccbddocu.ImpLin ) / (If CcbcDocu.codmon = 2 THEN 1 ELSE Ccbcdocu.Tpocmb).
            WHEN 11 THEN ASSIGN
            Temporal.NOV[1] = Temporal.NOV[1] +  X-TIPO * ( CcbDdocu.CanDes * F-FACTOR )
            Temporal.NOV[2] = Temporal.NOV[2] +  X-TIPO * ( Ccbddocu.ImpLin ) / (If CcbcDocu.codmon = 2 THEN 1 ELSE Ccbcdocu.Tpocmb).
            WHEN 12 THEN ASSIGN
            Temporal.DIC[1] = Temporal.DIC[1] +  X-TIPO * ( CcbDdocu.CanDes * F-FACTOR )
            Temporal.DIC[2] = Temporal.DIC[2] +  X-TIPO * ( Ccbddocu.ImpLin ) / (If CcbcDocu.codmon = 2 THEN 1 ELSE Ccbcdocu.Tpocmb).
          END.
          ASSIGN 
          Temporal.TOT[1] = Temporal.TOT[1] +  X-TIPO * ( CcbDdocu.CanDes * F-FACTOR )
          Temporal.TOT[2] = Temporal.TOT[2] +  X-TIPO * ( Ccbddocu.ImpLin ) / (If CcbcDocu.codmon = 2 THEN 1 ELSE Ccbcdocu.Tpocmb).

          PROCESS EVENTS.
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
output to c:\loko.txt .
FOR EACH temporal BREAK BY Codcia
                        BY Clase 
                        BY Codmat 
                        BY Periodo 
                        :
 IF LAST-OF(CodMat) THEN DO:
 END.                       
 EXPORT DELIMITER "|" temporal.
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
  DISPLAY F-prov1 F-prov2 f-desde f-hasta f-cate R-Zona R-Orden FILL-IN-1 
          RADIO-SET-1 RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 
      WITH FRAME D-Dialog.
  ENABLE F-prov1 F-prov2 f-desde f-hasta f-cate R-Zona R-Orden B-expor 
         RADIO-SET-1 RB-NUMBER-COPIES B-impresoras B-imprime RB-BEGIN-PAGE 
         B-cancela RB-END-PAGE RECT-54 RECT-59 RECT-60 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Exporta D-Dialog 
PROCEDURE Exporta :
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
DEFINE VARIABLE t-Column                AS INTEGER INITIAL 5.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE f-Column                AS char INITIAL "".
DEFINE VARIABLE x-valor                 AS DECIMAL init 0.
DEFINE VARIABLE f-estado                AS char init "".


/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */

chWorkSheet:Columns("A"):ColumnWidth = 4.
chWorkSheet:Columns("B"):ColumnWidth = 6.
chWorkSheet:Columns("C"):ColumnWidth = 30.
chWorkSheet:Columns("D"):ColumnWidth = 10.
chWorkSheet:Columns("E"):ColumnWidth = 5.
chWorkSheet:Columns("F"):ColumnWidth = 2.

chWorkSheet:Columns("B"):NumberFormat = "@".
chWorkSheet:Columns("AG"):NumberFormat = "@".
chWorkSheet:Columns("G:AF"):NumberFormat = "#,##0.00".
chWorkSheet:Columns("AH"):NumberFormat = "#,##0.0000".

chWorkSheet:Range("A1:AE5"):Font:Bold = TRUE.
chWorkSheet:Cells:Font:Size = 8.
chWorkSheet:Range("A3"):Font:Size = 14.
chWorkSheet:Range("A1"):Value = "Almacenes Evaluados   :" + X-CODALM .
chWorkSheet:Range("A2"):Value = "Divisiones Evaluadas  :" + X-CODDIV .
chWorkSheet:Range("A3"):Value = "Proyeccion de Compras"  .
chWorkSheet:Range("G4"):Value = "Enero".
chWorkSheet:Range("I4"):Value = "Febrero".
chWorkSheet:Range("K4"):Value = "Marzo".
chWorkSheet:Range("M4"):Value = "Abril".
chWorkSheet:Range("O4"):Value = "Mayo".
chWorkSheet:Range("Q4"):Value = "Junio".
chWorkSheet:Range("S4"):Value = "Julio".
chWorkSheet:Range("U4"):Value = "Agosto".
chWorkSheet:Range("W4"):Value = "Septiembre".
chWorkSheet:Range("Y4"):Value = "Octubre".
chWorkSheet:Range("AA4"):Value = "Noviembre".
chWorkSheet:Range("AC4"):Value = "Diciembre".
chWorkSheet:Range("AE4"):Value = "Stock".
chWorkSheet:Range("A5"):Value = "Periodo".
chWorkSheet:Range("B5"):Value = "Codigo".
chWorkSheet:Range("C5"):Value = "Descripcion".
chWorkSheet:Range("D5"):Value = "Marca".
chWorkSheet:Range("E5"):Value = "U.M".
chWorkSheet:Range("F5"):Value = "Cate".
chWorkSheet:Range("G5"):Value = "Cant".
chWorkSheet:Range("H5"):Value = "Dolares".
chWorkSheet:Range("I5"):Value = "Cant".
chWorkSheet:Range("J5"):Value = "Dolares".
chWorkSheet:Range("K5"):Value = "Cant".
chWorkSheet:Range("L5"):Value = "Dolares".
chWorkSheet:Range("M5"):Value = "Cant".
chWorkSheet:Range("N5"):Value = "Dolares".
chWorkSheet:Range("O5"):Value = "Cant".
chWorkSheet:Range("P5"):Value = "Dolares".
chWorkSheet:Range("Q5"):Value = "Cant".
chWorkSheet:Range("R5"):Value = "Dolares".
chWorkSheet:Range("S5"):Value = "Cant".
chWorkSheet:Range("T5"):Value = "Dolares".
chWorkSheet:Range("U5"):Value = "Cant".
chWorkSheet:Range("V5"):Value = "Dolares".
chWorkSheet:Range("W5"):Value = "Cant".
chWorkSheet:Range("X5"):Value = "Dolares".
chWorkSheet:Range("Y5"):Value = "Cant".
chWorkSheet:Range("Z5"):Value = "Dolares".
chWorkSheet:Range("AA5"):Value = "Cant".
chWorkSheet:Range("AB5"):Value = "Dolares".
chWorkSheet:Range("AC5"):Value = "Cant".
chWorkSheet:Range("AD5"):Value = "Dolares".
chWorkSheet:Range("AE5"):Value = "Cant".
chWorkSheet:Range("AF5"):Value = "Dolares".
chWorkSheet:Range("AG5"):Value = "Proveedor".
chWorkSheet:Range("AH5"):Value = "Costo".


chWorkSheet = chExcelApplication:Sheets:Item(1).

/* Iterate through the salesrep table and populate
   the Worksheet appropriately */


for each temporal break by Codcia
                        by CodPr1
                        by Clase
                        by Codmat
                        by Periodo:
    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = periodo.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = codmat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = desmat.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = desmar.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = unidad.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = clase.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = ENE[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = ENE[2].
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = FEB[1].
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = FEB[2].

    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = MAR[1].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = MAR[2].
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = ABR[1].
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = ABR[2].
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = MAY[1].
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = MAY[2].
    cRange = "Q" + cColumn.
    chWorkSheet:Range(cRange):Value = JUN[1].
    cRange = "R" + cColumn.
    chWorkSheet:Range(cRange):Value = JUN[2].
    cRange = "S" + cColumn.
    chWorkSheet:Range(cRange):Value = JUL[1].
    cRange = "T" + cColumn.
    chWorkSheet:Range(cRange):Value = JUL[2].
    cRange = "U" + cColumn.
    chWorkSheet:Range(cRange):Value = AGO[1].
    cRange = "V" + cColumn.
    chWorkSheet:Range(cRange):Value = AGO[2].
    cRange = "W" + cColumn.
    chWorkSheet:Range(cRange):Value = SEP[1].
    cRange = "X" + cColumn.
    chWorkSheet:Range(cRange):Value = SEP[2].
    cRange = "Y" + cColumn.
    chWorkSheet:Range(cRange):Value = OCT[1].
    cRange = "Z" + cColumn.
    chWorkSheet:Range(cRange):Value = OCT[2].
    cRange = "AA" + cColumn.
    chWorkSheet:Range(cRange):Value = NOV[1].
    cRange = "AB" + cColumn.
    chWorkSheet:Range(cRange):Value = NOV[2].
    cRange = "AC" + cColumn.
    chWorkSheet:Range(cRange):Value = DIC[1].
    cRange = "AD" + cColumn.
    chWorkSheet:Range(cRange):Value = DIC[2].
    cRange = "AE" + cColumn.
    chWorkSheet:Range(cRange):Value = stk[1].
    cRange = "AF" + cColumn.
    chWorkSheet:Range(cRange):Value = stk[2].
    cRange = "AG" + cColumn.
    chWorkSheet:Range(cRange):Value = CodPr1.
    cRange = "AH" + cColumn.
    chWorkSheet:Range(cRange):Value = Ctotot.

END.



/*
f-Column = "H" + string(t-Column).
chWorkSheet:Range("A1:" + f-column):Select().
*/
/*chExcelApplication:Selection:Style = "Currency".*/


/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.
/*RELEASE OBJECT chWorksheetRange. */

FOR EACH temporal:
 DELETE temporal.
END.
HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Exporta2 D-Dialog 
PROCEDURE Exporta2 :
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
DEFINE VARIABLE t-Column                AS INTEGER INITIAL 5.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE f-Column                AS char INITIAL "".
DEFINE VARIABLE x-valor                 AS DECIMAL init 0.
DEFINE VARIABLE f-estado                AS char init "".


/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */

chWorkSheet:Columns("A"):ColumnWidth = 4.
chWorkSheet:Columns("B"):ColumnWidth = 6.
chWorkSheet:Columns("C"):ColumnWidth = 30.
chWorkSheet:Columns("D"):ColumnWidth = 10.
chWorkSheet:Columns("E"):ColumnWidth = 5.
chWorkSheet:Columns("F"):ColumnWidth = 2.

chWorkSheet:Columns("B"):NumberFormat = "@".
chWorkSheet:Columns("AG"):NumberFormat = "@".
chWorkSheet:Columns("G:AF"):NumberFormat = "#,##0.00".
chWorkSheet:Columns("AH"):NumberFormat = "#,##0.0000".

chWorkSheet:Range("A1:AE5"):Font:Bold = TRUE.
chWorkSheet:Cells:Font:Size = 8.
chWorkSheet:Range("A3"):Font:Size = 14.
chWorkSheet:Range("A1"):Value = "Almacenes Evaluados   :" + X-CODALM .
chWorkSheet:Range("A2"):Value = "Divisiones Evaluadas  :" + X-CODDIV .
chWorkSheet:Range("A3"):Value = "Proyeccion de Compras"  .
chWorkSheet:Range("G4"):Value = "Enero".
chWorkSheet:Range("I4"):Value = "Febrero".
chWorkSheet:Range("K4"):Value = "Marzo".
chWorkSheet:Range("M4"):Value = "Abril".
chWorkSheet:Range("O4"):Value = "Mayo".
chWorkSheet:Range("Q4"):Value = "Junio".
chWorkSheet:Range("S4"):Value = "Julio".
chWorkSheet:Range("U4"):Value = "Agosto".
chWorkSheet:Range("W4"):Value = "Septiembre".
chWorkSheet:Range("Y4"):Value = "Octubre".
chWorkSheet:Range("AA4"):Value = "Noviembre".
chWorkSheet:Range("AC4"):Value = "Diciembre".
chWorkSheet:Range("AE4"):Value = "Stock".
chWorkSheet:Range("A5"):Value = "Periodo".
chWorkSheet:Range("B5"):Value = "Codigo".
chWorkSheet:Range("C5"):Value = "Descripcion".
chWorkSheet:Range("D5"):Value = "Marca".
chWorkSheet:Range("E5"):Value = "U.M".
chWorkSheet:Range("F5"):Value = "Cate".
chWorkSheet:Range("G5"):Value = "Cant".
chWorkSheet:Range("H5"):Value = "Dolares".
chWorkSheet:Range("I5"):Value = "Cant".
chWorkSheet:Range("J5"):Value = "Dolares".
chWorkSheet:Range("K5"):Value = "Cant".
chWorkSheet:Range("L5"):Value = "Dolares".
chWorkSheet:Range("M5"):Value = "Cant".
chWorkSheet:Range("N5"):Value = "Dolares".
chWorkSheet:Range("O5"):Value = "Cant".
chWorkSheet:Range("P5"):Value = "Dolares".
chWorkSheet:Range("Q5"):Value = "Cant".
chWorkSheet:Range("R5"):Value = "Dolares".
chWorkSheet:Range("S5"):Value = "Cant".
chWorkSheet:Range("T5"):Value = "Dolares".
chWorkSheet:Range("U5"):Value = "Cant".
chWorkSheet:Range("V5"):Value = "Dolares".
chWorkSheet:Range("W5"):Value = "Cant".
chWorkSheet:Range("X5"):Value = "Dolares".
chWorkSheet:Range("Y5"):Value = "Cant".
chWorkSheet:Range("Z5"):Value = "Dolares".
chWorkSheet:Range("AA5"):Value = "Cant".
chWorkSheet:Range("AB5"):Value = "Dolares".
chWorkSheet:Range("AC5"):Value = "Cant".
chWorkSheet:Range("AD5"):Value = "Dolares".
chWorkSheet:Range("AE5"):Value = "Cant".
chWorkSheet:Range("AF5"):Value = "Dolares".
chWorkSheet:Range("AG5"):Value = "Proveedor".
chWorkSheet:Range("AH5"):Value = "Costo".


chWorkSheet = chExcelApplication:Sheets:Item(1).

/* Iterate through the salesrep table and populate
   the Worksheet appropriately */


for each temporal break by Codcia
                        by CodPr1
                        by Clase
                        by DesMat
                        by Periodo:
    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = periodo.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = codmat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = desmat.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = desmar.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = unidad.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = clase.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = ENE[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = ENE[2].
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = FEB[1].
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = FEB[2].

    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = MAR[1].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = MAR[2].
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = ABR[1].
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = ABR[2].
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = MAY[1].
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = MAY[2].
    cRange = "Q" + cColumn.
    chWorkSheet:Range(cRange):Value = JUN[1].
    cRange = "R" + cColumn.
    chWorkSheet:Range(cRange):Value = JUN[2].
    cRange = "S" + cColumn.
    chWorkSheet:Range(cRange):Value = JUL[1].
    cRange = "T" + cColumn.
    chWorkSheet:Range(cRange):Value = JUL[2].
    cRange = "U" + cColumn.
    chWorkSheet:Range(cRange):Value = AGO[1].
    cRange = "V" + cColumn.
    chWorkSheet:Range(cRange):Value = AGO[2].
    cRange = "W" + cColumn.
    chWorkSheet:Range(cRange):Value = SEP[1].
    cRange = "X" + cColumn.
    chWorkSheet:Range(cRange):Value = SEP[2].
    cRange = "Y" + cColumn.
    chWorkSheet:Range(cRange):Value = OCT[1].
    cRange = "Z" + cColumn.
    chWorkSheet:Range(cRange):Value = OCT[2].
    cRange = "AA" + cColumn.
    chWorkSheet:Range(cRange):Value = NOV[1].
    cRange = "AB" + cColumn.
    chWorkSheet:Range(cRange):Value = NOV[2].
    cRange = "AC" + cColumn.
    chWorkSheet:Range(cRange):Value = DIC[1].
    cRange = "AD" + cColumn.
    chWorkSheet:Range(cRange):Value = DIC[2].
    cRange = "AE" + cColumn.
    chWorkSheet:Range(cRange):Value = stk[1].
    cRange = "AF" + cColumn.
    chWorkSheet:Range(cRange):Value = stk[2].
    cRange = "AG" + cColumn.
    chWorkSheet:Range(cRange):Value = CodPr1.
    cRange = "AH" + cColumn.
    chWorkSheet:Range(cRange):Value = Ctotot.

END.



/*
f-Column = "H" + string(t-Column).
chWorkSheet:Range("A1:" + f-column):Select().
*/
/*chExcelApplication:Selection:Style = "Currency".*/


/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.
/*RELEASE OBJECT chWorksheetRange. */

FOR EACH temporal:
 DELETE temporal.
END.
HIDE FRAME F-PROCESO.

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
    IF MONTH(F-DESDE) > 5 OR MONTH(F-HASTA) > 5 THEN DO:
        MESSAGE "Solo Meses menores o iguales a Mayo " SKIP
                "Si quiere trabajar con todos los Meses " SKIP
                "Elija la Opcion por Excel    "  VIEW-AS ALERT-BOX ERROR.
        
        RETURN NO-APPLY.
    END.

    IF YEAR(F-DESDE) <> YEAR(F-HASTA) THEN DO:
        MESSAGE "Solo Para Fechas dentro del mismo Año " SKIP
                "Si quiere trabajar con Fechas en diferentes Años " SKIP
                "Elija la Opcion por Excel    "  VIEW-AS ALERT-BOX ERROR.
        
        RETURN NO-APPLY.
    END.

    RUN Carga-Tabla.
 /*  
    CASE R-Orden :
     WHEN 1 THEN RUN Reporte.
     WHEN 2 THEN RUN Reporte2.
    END.
 */
 
   CASE R-Orden :
     WHEN 1 THEN RUN XReporte.
     WHEN 2 THEN RUN XReporte2.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Reporte D-Dialog 
PROCEDURE Reporte :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR L-SW AS LOGICAL INIT NO.
 DEFINE VAR X-TITU AS CHAR.
 X-TITU = "VENTAS POR VENDEDOR - DETALLE PRODUCTO - " + X-PUNTO.
 DEFINE FRAME f-cab
        Temporal.Periodo FORMAT "9999"    
        Temporal.CodMat  FORMAT "x(6)"  
        Temporal.DesMat  FORMAT "x(35)"   
        Temporal.DesMar  FORMAT "x(10)"   
        Temporal.Unidad  FORMAT "x(5)"   
        Temporal.ENE[1]  FORMAT ">>>,>>9.99"
        Temporal.ENE[2]  FORMAT ">>>,>>9.99"
        Temporal.FEB[1]  FORMAT ">>>,>>9.99"
        Temporal.FEB[2]  FORMAT ">>>,>>9.99"
        Temporal.MAR[1]  FORMAT ">>>,>>9.99"
        Temporal.MAR[2]  FORMAT ">>>,>>9.99"
        Temporal.ABR[1]  FORMAT ">>>,>>9.99"
        Temporal.ABR[2]  FORMAT ">>>,>>9.99"
        Temporal.MAY[1]  FORMAT ">>>,>>9.99"
        Temporal.MAY[2]  FORMAT ">>>,>>9.99"
        Temporal.JUN[1]  FORMAT ">>>,>>9.99"
        Temporal.JUN[2]  FORMAT ">>>,>>9.99"
        Temporal.JUL[1]  FORMAT ">>>,>>9.99"
        Temporal.JUL[2]  FORMAT ">>>,>>9.99"
        Temporal.AGO[1]  FORMAT ">>>,>>9.99"
        Temporal.AGO[2]  FORMAT ">>>,>>9.99"
        Temporal.SEP[1]  FORMAT ">>>,>>9.99"
        Temporal.SEP[2]  FORMAT ">>>,>>9.99"
        Temporal.OCT[1]  FORMAT ">>>,>>9.99"
        Temporal.OCT[2]  FORMAT ">>>,>>9.99"
        Temporal.NOV[1]  FORMAT ">>>,>>9.99"
        Temporal.NOV[2]  FORMAT ">>>,>>9.99"
        Temporal.DIC[1]  FORMAT ">>>,>>9.99"
        Temporal.DIC[2]  FORMAT ">>>,>>9.99"
        Temporal.TOT[1]  FORMAT ">>>,>>9.99"
        Temporal.TOT[2]  FORMAT ">>>,>>9.99"
        Temporal.Stk[1]  FORMAT ">>>,>>9.99"
        Temporal.Stk[2]  FORMAT ">>>,>>9.99"

        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP(2)
        {&PRN2} + {&PRN6A} + X-TITU + {&PRN6B} + {&PRN3} AT 30 FORMAT "X(55)" SKIP
       /* {&PRN2} + {&PRN6A} + "DIVISION : " + f-punto AT 1 FORMAT "X(20)" F-DIRDIV AT 25 FORMAT "X(30)"  */
        {&PRN3} + {&PRN6B} + "Pagina: " AT 100 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "DESDE    : " + STRING(f-desde,"99/99/9999") + " HASTA :" + STRING(f-hasta,"99/99/9999") FORMAT "X(50)"
        {&PRN3} + {&PRN6B} + "Fecha : " AT 100 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)"
        {&PRN2} + {&PRN6A} + "MONEDA   : DOLARES AMERICANOS" At 1 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Hora  : " AT 100 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") + {&PRN6B} + {&PRND} SKIP
        "-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                         Enero           Febrero           Marzo             Abril            Mayo              Junio              Julio              Agosto          Septiembre         Octubre          Noviembre         Diciembre       Total               Stock        "                  
        " Periodo    Articulo        Descripcion           Marca     U.M.    Cant.   Dolares   Cant.   Dolares   Cant.   Dolares   Cant.   Dolares   Cant.   Dolares   Cant.   Dolares   Cant.   Dolares   Cant.   Dolares   Cant.   Dolares   Cant.   Dolares   Cant.   Dolares   Cant.   Dolares   Cant.   Dolares   Cant   Dolares " SKIP
        "-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/***      999  12345678901234567890123456789012345  999999  12345678901234567890123456789012345678901234567890 1234 99,999,999.99  999,999,999.99 ***/
         WITH WIDTH 600 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

  FOR EACH Temporal NO-LOCK
          BREAK BY Temporal.Codcia
                BY Temporal.CodPr1
                BY Temporal.Clase 
                BY Temporal.Codmat
                BY Temporal.Periodo:
                                 
     {&NEW-PAGE}.
     IF FIRST-OF ( Temporal.CodPr1) THEN DO:
        DISPLAY STREAM REPORT
          "PROVEEDOR : "   @ Temporal.Periodo            
           Temporal.CodPr1 @ Temporal.CodMat
           Temporal.NomPro @ Temporal.DesMat
           WITH FRAME F-CAB.               
        DOWN STREAM REPORT 1 WITH FRAME F-CAB.        

     END.

     
     IF FIRST-OF ( Temporal.Clase) THEN DO:
       DISPLAY STREAM REPORT
          "Categoria  : " @ Temporal.Periodo            
           Temporal.Clase @ Temporal.Clase
           WITH FRAME F-CAB.               
        DOWN STREAM REPORT 1 WITH FRAME F-CAB.        

     END.
      
      
      
      DISPLAY STREAM REPORT 
        Temporal.CodMat
        Temporal.DesMat
        Temporal.DesMar
        Temporal.Unidad
        Temporal.ENE[1]  FORMAT ">>>,>>9.99"
        Temporal.ENE[2]  FORMAT ">>>,>>9.99"
        Temporal.FEB[1]  FORMAT ">>>,>>9.99"
        Temporal.FEB[2]  FORMAT ">>>,>>9.99"
        Temporal.MAR[1]  FORMAT ">>>,>>9.99"
        Temporal.MAR[2]  FORMAT ">>>,>>9.99"
        Temporal.ABR[1]  FORMAT ">>>,>>9.99"
        Temporal.ABR[2]  FORMAT ">>>,>>9.99"
        Temporal.MAY[1]  FORMAT ">>>,>>9.99"
        Temporal.MAY[2]  FORMAT ">>>,>>9.99"
        Temporal.JUN[1]  FORMAT ">>>,>>9.99"
        Temporal.JUN[2]  FORMAT ">>>,>>9.99"
        Temporal.JUL[1]  FORMAT ">>>,>>9.99"
        Temporal.JUL[2]  FORMAT ">>>,>>9.99" 
        Temporal.AGO[1]  FORMAT ">>>,>>9.99"
        Temporal.AGO[2]  FORMAT ">>>,>>9.99"
        Temporal.SEP[1]  FORMAT ">>>,>>9.99"
        Temporal.SEP[2]  FORMAT ">>>,>>9.99"
        Temporal.OCT[1]  FORMAT ">>>,>>9.99"
        Temporal.OCT[2]  FORMAT ">>>,>>9.99"
        Temporal.NOV[1]  FORMAT ">>>,>>9.99"
        Temporal.NOV[2]  FORMAT ">>>,>>9.99"
        Temporal.DIC[1]  FORMAT ">>>,>>9.99"
        Temporal.DIC[2]  FORMAT ">>>,>>9.99"
        Temporal.TOT[1]  FORMAT ">>>,>>9.99"
        Temporal.TOT[2]  FORMAT ">>>,>>9.99"
        Temporal.Stk[1]  FORMAT ">>>,>>9.99"
        Temporal.Stk[2]  FORMAT ">>>,>>9.99"
        WITH FRAME F-Cab.
        ACCUMULATE Temporal.ENE[2] ( SUB-TOTAL BY Temporal.CodPr1 ).
        ACCUMULATE Temporal.ENE[2] ( SUB-TOTAL BY Temporal.Clase  ).
        ACCUMULATE Temporal.ENE[2] ( TOTAL     BY Temporal.Codcia ). 
                
        IF LAST-OF (Temporal.Clase) THEN DO:
           UNDERLINE STREAM REPORT Temporal.ENE[2] WITH FRAME F-CAB. 
           DISPLAY STREAM REPORT
                   "Total Categoria : " + Temporal.Clase @ Temporal.Desmat            
                   ACCUM SUB-TOTAL BY Temporal.Clase Temporal.ENE[2] @ Temporal.ENE[2] 
                   WITH FRAME F-CAB.               
           DOWN STREAM REPORT 2 WITH FRAME F-CAB.        
        END.

        IF LAST-OF (Temporal.CodPr1) THEN DO:
           UNDERLINE STREAM REPORT Temporal.ENE[2] WITH FRAME F-CAB. 
           DISPLAY STREAM REPORT
                   "Total Proveedor : " + Temporal.CodPr1 @ Temporal.Desmat            
                   ACCUM SUB-TOTAL BY Temporal.CodPr1 Temporal.ENE[2] @ Temporal.ENE[2] 
                   WITH FRAME F-CAB.               
           DOWN STREAM REPORT 2 WITH FRAME F-CAB.        
        END.

        
        IF LAST-OF (Temporal.Codcia) THEN DO:
           DOWN STREAM REPORT 2 WITH FRAME F-CAB.        
           UNDERLINE STREAM REPORT Temporal.ENE[2] WITH FRAME F-CAB. 
           DISPLAY STREAM REPORT
                   "TOTAL GENERAL   :  " @ Temporal.DESMAT
                   ACCUM TOTAL BY Temporal.CODCIA Temporal.ENE[2] @ Temporal.ENE[2] 
                   WITH FRAME F-CAB.
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
 X-TITU = "VENTAS POR VENDEDOR - DETALLE PRODUCTO - " + X-PUNTO.
 DEFINE FRAME f-cab
        Temporal.Periodo FORMAT "9999"    
        Temporal.CodMat  FORMAT "x(6)"  
        Temporal.DesMat  FORMAT "x(35)"   
        Temporal.DesMar  FORMAT "x(10)"   
        Temporal.Unidad  FORMAT "x(5)"   
        Temporal.ENE[1]  FORMAT ">>>,>>9.99"
        Temporal.ENE[2]  FORMAT ">>>,>>9.99"
        Temporal.FEB[1]  FORMAT ">>>,>>9.99"
        Temporal.FEB[2]  FORMAT ">>>,>>9.99"
        Temporal.MAR[1]  FORMAT ">>>,>>9.99"
        Temporal.MAR[2]  FORMAT ">>>,>>9.99"
        Temporal.ABR[1]  FORMAT ">>>,>>9.99"
        Temporal.ABR[2]  FORMAT ">>>,>>9.99"
        Temporal.MAY[1]  FORMAT ">>>,>>9.99"
        Temporal.MAY[2]  FORMAT ">>>,>>9.99"
        Temporal.JUN[1]  FORMAT ">>>,>>9.99"
        Temporal.JUN[2]  FORMAT ">>>,>>9.99"
        Temporal.JUL[1]  FORMAT ">>>,>>9.99"
        Temporal.JUL[2]  FORMAT ">>>,>>9.99"
        Temporal.AGO[1]  FORMAT ">>>,>>9.99"
        Temporal.AGO[2]  FORMAT ">>>,>>9.99"
        Temporal.SEP[1]  FORMAT ">>>,>>9.99"
        Temporal.SEP[2]  FORMAT ">>>,>>9.99"
        Temporal.OCT[1]  FORMAT ">>>,>>9.99"
        Temporal.OCT[2]  FORMAT ">>>,>>9.99"
        Temporal.NOV[1]  FORMAT ">>>,>>9.99"
        Temporal.NOV[2]  FORMAT ">>>,>>9.99"
        Temporal.DIC[1]  FORMAT ">>>,>>9.99"
        Temporal.DIC[2]  FORMAT ">>>,>>9.99"
        Temporal.TOT[1]  FORMAT ">>>,>>9.99"
        Temporal.TOT[2]  FORMAT ">>>,>>9.99"
        Temporal.Stk[1]  FORMAT ">>>,>>9.99"
        Temporal.Stk[2]  FORMAT ">>>,>>9.99"

        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP(2)
        {&PRN2} + {&PRN6A} + X-TITU + {&PRN6B} + {&PRN3} AT 30 FORMAT "X(55)" SKIP
       /* {&PRN2} + {&PRN6A} + "DIVISION : " + f-punto AT 1 FORMAT "X(20)" F-DIRDIV AT 25 FORMAT "X(30)"  */
        {&PRN3} + {&PRN6B} + "Pagina: " AT 100 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "DESDE    : " + STRING(f-desde,"99/99/9999") + " HASTA :" + STRING(f-hasta,"99/99/9999") FORMAT "X(50)"
        {&PRN3} + {&PRN6B} + "Fecha : " AT 100 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)"
        {&PRN2} + {&PRN6A} + "MONEDA   : DOLARES AMERICANOS" At 1 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Hora  : " AT 100 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") + {&PRN6B} + {&PRND} SKIP
        "-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                         Enero           Febrero           Marzo             Abril            Mayo              Junio              Julio              Agosto          Septiembre         Octubre          Noviembre         Diciembre       Total               Stock        "                  
        " Periodo    Articulo        Descripcion           Marca     U.M.    Cant.   Dolares   Cant.   Dolares   Cant.   Dolares   Cant.   Dolares   Cant.   Dolares   Cant.   Dolares   Cant.   Dolares   Cant.   Dolares   Cant.   Dolares   Cant.   Dolares   Cant.   Dolares   Cant.   Dolares   Cant.   Dolares   Cant   Dolares " SKIP
        "-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/***      999  12345678901234567890123456789012345  999999  12345678901234567890123456789012345678901234567890 1234 99,999,999.99  999,999,999.99 ***/
         WITH WIDTH 600 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

  FOR EACH Temporal NO-LOCK
          BREAK BY Temporal.Codcia
                BY Temporal.CodPr1
                BY Temporal.Clase 
                BY Temporal.Desmat
                BY Temporal.Periodo:
                                 
     {&NEW-PAGE}.
     IF FIRST-OF ( Temporal.CodPr1) THEN DO:
        DISPLAY STREAM REPORT
          "PROVEEDOR : "   @ Temporal.Periodo            
           Temporal.CodPr1 @ Temporal.CodMat
           Temporal.NomPro @ Temporal.DesMat
           WITH FRAME F-CAB.               
        DOWN STREAM REPORT 1 WITH FRAME F-CAB.        

     END.

     
     IF FIRST-OF ( Temporal.Clase) THEN DO:
       DISPLAY STREAM REPORT
          "Categoria  : " @ Temporal.Periodo            
           Temporal.Clase @ Temporal.Clase
           WITH FRAME F-CAB.               
        DOWN STREAM REPORT 1 WITH FRAME F-CAB.        

     END.
      
      
      
      DISPLAY STREAM REPORT 
        Temporal.CodMat
        Temporal.DesMat
        Temporal.DesMar
        Temporal.Unidad
        Temporal.ENE[1]  FORMAT ">>>,>>9.99"
        Temporal.ENE[2]  FORMAT ">>>,>>9.99"
        Temporal.FEB[1]  FORMAT ">>>,>>9.99"
        Temporal.FEB[2]  FORMAT ">>>,>>9.99"
        Temporal.MAR[1]  FORMAT ">>>,>>9.99"
        Temporal.MAR[2]  FORMAT ">>>,>>9.99"
        Temporal.ABR[1]  FORMAT ">>>,>>9.99"
        Temporal.ABR[2]  FORMAT ">>>,>>9.99"
        Temporal.MAY[1]  FORMAT ">>>,>>9.99"
        Temporal.MAY[2]  FORMAT ">>>,>>9.99"
        Temporal.JUN[1]  FORMAT ">>>,>>9.99"
        Temporal.JUN[2]  FORMAT ">>>,>>9.99"
        Temporal.JUL[1]  FORMAT ">>>,>>9.99"
        Temporal.JUL[2]  FORMAT ">>>,>>9.99" 
        Temporal.AGO[1]  FORMAT ">>>,>>9.99"
        Temporal.AGO[2]  FORMAT ">>>,>>9.99"
        Temporal.SEP[1]  FORMAT ">>>,>>9.99"
        Temporal.SEP[2]  FORMAT ">>>,>>9.99"
        Temporal.OCT[1]  FORMAT ">>>,>>9.99"
        Temporal.OCT[2]  FORMAT ">>>,>>9.99"
        Temporal.NOV[1]  FORMAT ">>>,>>9.99"
        Temporal.NOV[2]  FORMAT ">>>,>>9.99"
        Temporal.DIC[1]  FORMAT ">>>,>>9.99"
        Temporal.DIC[2]  FORMAT ">>>,>>9.99"
        Temporal.TOT[1]  FORMAT ">>>,>>9.99"
        Temporal.TOT[2]  FORMAT ">>>,>>9.99"
        Temporal.Stk[1]  FORMAT ">>>,>>9.99"
        Temporal.Stk[2]  FORMAT ">>>,>>9.99"
        WITH FRAME F-Cab.
        ACCUMULATE Temporal.ENE[2] ( SUB-TOTAL BY Temporal.CodPr1 ).
        ACCUMULATE Temporal.ENE[2] ( SUB-TOTAL BY Temporal.Clase  ).
        ACCUMULATE Temporal.ENE[2] ( TOTAL     BY Temporal.Codcia ). 
                
        IF LAST-OF (Temporal.Clase) THEN DO:
           UNDERLINE STREAM REPORT Temporal.ENE[2] WITH FRAME F-CAB. 
           DISPLAY STREAM REPORT
                   "Total Categoria : " + Temporal.Clase @ Temporal.Desmat            
                   ACCUM SUB-TOTAL BY Temporal.Clase Temporal.ENE[2] @ Temporal.ENE[2] 
                   WITH FRAME F-CAB.               
           DOWN STREAM REPORT 2 WITH FRAME F-CAB.        
        END.

        IF LAST-OF (Temporal.CodPr1) THEN DO:
           UNDERLINE STREAM REPORT Temporal.ENE[2] WITH FRAME F-CAB. 
           DISPLAY STREAM REPORT
                   "Total Proveedor : " + Temporal.CodPr1 @ Temporal.Desmat            
                   ACCUM SUB-TOTAL BY Temporal.CodPr1 Temporal.ENE[2] @ Temporal.ENE[2] 
                   WITH FRAME F-CAB.               
           DOWN STREAM REPORT 2 WITH FRAME F-CAB.        
        END.

        
        IF LAST-OF (Temporal.Codcia) THEN DO:
           DOWN STREAM REPORT 2 WITH FRAME F-CAB.        
           UNDERLINE STREAM REPORT Temporal.ENE[2] WITH FRAME F-CAB. 
           DISPLAY STREAM REPORT
                   "TOTAL GENERAL   :  " @ Temporal.DESMAT
                   ACCUM TOTAL BY Temporal.CODCIA Temporal.ENE[2] @ Temporal.ENE[2] 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE XReporte D-Dialog 
PROCEDURE XReporte :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR L-SW AS LOGICAL INIT NO.
 DEFINE VAR X-TITU AS CHAR.
 X-TITU = "REPORTE DE VENTAS - PROYECCION DE COMPRA".
 DEFINE FRAME f-cab
        Temporal.CodMat  FORMAT "x(6)"  
        Temporal.DesMat  FORMAT "x(35)"   
        Temporal.DesMar  FORMAT "x(10)"   
        Temporal.Unidad  FORMAT "x(5)"   
        Temporal.Ctotot  FORMAT "->>>>>9.9999"
        Temporal.ENE[1]  FORMAT "->>>>>9.99"
        Temporal.ENE[2]  FORMAT "->>>>>9.99"
        Temporal.FEB[1]  FORMAT "->>>>>9.99"
        Temporal.FEB[2]  FORMAT "->>>>>9.99"
        Temporal.MAR[1]  FORMAT "->>>>>9.99"
        Temporal.MAR[2]  FORMAT "->>>>>9.99"
        Temporal.ABR[1]  FORMAT "->>>>>9.99"
        Temporal.ABR[2]  FORMAT "->>>>>9.99"
        Temporal.MAY[1]  FORMAT "->>>>>9.99"
        Temporal.MAY[2]  FORMAT "->>>>>9.99"
        Temporal.TOT[1]  FORMAT "->>>>>9.99"
        Temporal.TOT[2]  FORMAT "->>>>>9.99"
        Temporal.Stk[1]  FORMAT "->>>>>9.99"
        Temporal.Stk[2]  FORMAT "->>>>>9.99"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP(2)
        {&PRN2} + {&PRN6A} + X-TITU + {&PRN6B} + {&PRN3} AT 40 FORMAT "X(60)" SKIP
        {&PRN3} + {&PRN6B} + "Pagina: " AT 150 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "DESDE    : " + STRING(f-desde,"99/99/9999") + " HASTA :" + STRING(f-hasta,"99/99/9999") FORMAT "X(50)"
        {&PRN3} + {&PRN6B} + "Fecha : " AT 120 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)"
        {&PRN2} + {&PRN6A} + "MONEDA   : DOLARES AMERICANOS" At 1 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Hora  : " AT 120 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") + {&PRN6B} + {&PRND} SKIP
        {&PRN2} + {&PRN6A} + "ALMACENES EVALUADOS   : " + X-CODALM  At 1 FORMAT "X(150)"  SKIP
        {&PRN2} + {&PRN6A} + "DIVISIONES EVALUADAS  : " + X-CODDIV  + {&PRN4} + {&PRN6B} At 1 FORMAT "X(150)" SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                              Enero               Febrero                Marzo                  Abril                  Mayo                 Total                   Stock      " SKIP             
        " Articulo        Descripcion                Marca     U.M.       Costo    Cant.   Dolares       Cant.   Dolares       Cant.   Dolares       Cant.   Dolares       Cant.   Dolares       Cant.   Dolares        Cant.   Dolares " SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 350 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

  FOR EACH Temporal NO-LOCK
          BREAK BY Temporal.Codcia
                BY Temporal.CodPr1
                BY Temporal.Clase 
                BY Temporal.Codmat :
                                 
     {&NEW-PAGE}.
     DISPLAY STREAM REPORT WITH FRAME F-CAB.
          
     IF FIRST-OF ( Temporal.CodPr1) THEN DO:
        PUT STREAM REPORT 
        {&PRN2} + {&PRN6A} +  "PROVEEDOR : "  + Temporal.CodPr1 + " " + Temporal.NomPro + {&PRN4} + {&PRN6B} AT 1 FORMAT "X(100)" SKIP(2).
     END.

     
     IF FIRST-OF ( Temporal.Clase) THEN DO:
      PUT STREAM REPORT 
      {&PRN6A} + "Categoria  : " + Temporal.Clase + {&PRN6B}  AT 10  FORMAT "X(30)" SKIP.
     END.
     
      
      
      DISPLAY STREAM REPORT 
        Temporal.CodMat  FORMAT "X(6)"
        Temporal.DesMat  FORMAT "X(35)"
        Temporal.DesMar  FORMAT "X(10)"
        Temporal.Unidad  FORMAT "X(5)"
        Temporal.Ctotot  FORMAT "->>>>>9.9999"
        Temporal.ENE[1]  FORMAT "->>>>>9.99"
        Temporal.ENE[2]  FORMAT "->>>>>9.99"
        Temporal.FEB[1]  FORMAT "->>>>>9.99"
        Temporal.FEB[2]  FORMAT "->>>>>9.99"
        Temporal.MAR[1]  FORMAT "->>>>>9.99"
        Temporal.MAR[2]  FORMAT "->>>>>9.99"
        Temporal.ABR[1]  FORMAT "->>>>>9.99"
        Temporal.ABR[2]  FORMAT "->>>>>9.99"
        Temporal.MAY[1]  FORMAT "->>>>>9.99"
        Temporal.MAY[2]  FORMAT "->>>>>9.99"
        Temporal.TOT[1]  FORMAT "->>>>>9.99"
        Temporal.TOT[2]  FORMAT "->>>>>9.99"
        Temporal.Stk[1]  FORMAT "->>>>>9.99"
        Temporal.Stk[2]  FORMAT "->>>>>9.99"    
        WITH FRAME F-Cab.
              
        ACCUMULATE Temporal.ENE[2] ( SUB-TOTAL BY Temporal.CodPr1 ).
        ACCUMULATE Temporal.ENE[2] ( SUB-TOTAL BY Temporal.Clase  ).
        ACCUMULATE Temporal.ENE[2] ( TOTAL     BY Temporal.Codcia ). 
        
        ACCUMULATE Temporal.FEB[2] ( SUB-TOTAL BY Temporal.CodPr1 ).
        ACCUMULATE Temporal.FEB[2] ( SUB-TOTAL BY Temporal.Clase  ).
        ACCUMULATE Temporal.FEB[2] ( TOTAL     BY Temporal.Codcia ). 

        ACCUMULATE Temporal.MAR[2] ( SUB-TOTAL BY Temporal.CodPr1 ).
        ACCUMULATE Temporal.MAR[2] ( SUB-TOTAL BY Temporal.Clase  ).
        ACCUMULATE Temporal.MAR[2] ( TOTAL     BY Temporal.Codcia ). 
        
        ACCUMULATE Temporal.ABR[2] ( SUB-TOTAL BY Temporal.CodPr1 ).
        ACCUMULATE Temporal.ABR[2] ( SUB-TOTAL BY Temporal.Clase  ).
        ACCUMULATE Temporal.ABR[2] ( TOTAL     BY Temporal.Codcia ). 
        
        ACCUMULATE Temporal.MAY[2] ( SUB-TOTAL BY Temporal.CodPr1 ).
        ACCUMULATE Temporal.MAY[2] ( SUB-TOTAL BY Temporal.Clase  ).
        ACCUMULATE Temporal.MAY[2] ( TOTAL     BY Temporal.Codcia ). 
        
                
        ACCUMULATE Temporal.TOT[2] ( SUB-TOTAL BY Temporal.CodPr1 ).
        ACCUMULATE Temporal.TOT[2] ( SUB-TOTAL BY Temporal.Clase  ).
        ACCUMULATE Temporal.TOT[2] ( TOTAL     BY Temporal.Codcia ). 
 
        ACCUMULATE Temporal.STK[2] ( SUB-TOTAL BY Temporal.CodPr1 ).
        ACCUMULATE Temporal.STK[2] ( SUB-TOTAL BY Temporal.Clase  ).
        ACCUMULATE Temporal.STK[2] ( TOTAL     BY Temporal.Codcia ). 
                
        IF LAST-OF (Temporal.Clase) THEN DO:
           
           UNDERLINE STREAM REPORT Temporal.ENE[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.FEB[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.MAR[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.ABR[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.MAY[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.TOT[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.STK[2] WITH FRAME F-CAB.
           
           DISPLAY STREAM REPORT
                   {&PRN6A} + "Total Categoria : " + Temporal.Clase + {&PRN6B}  @ Temporal.Desmat            
                   ACCUM SUB-TOTAL BY Temporal.Clase Temporal.ENE[2] @ Temporal.ENE[2] 
                   ACCUM SUB-TOTAL BY Temporal.Clase Temporal.FEB[2] @ Temporal.FEB[2] 
                   ACCUM SUB-TOTAL BY Temporal.Clase Temporal.MAR[2] @ Temporal.MAR[2] 
                   ACCUM SUB-TOTAL BY Temporal.Clase Temporal.ABR[2] @ Temporal.ABR[2] 
                   ACCUM SUB-TOTAL BY Temporal.Clase Temporal.MAY[2] @ Temporal.MAY[2] 
                   ACCUM SUB-TOTAL BY Temporal.Clase Temporal.TOT[2] @ Temporal.TOT[2] 
                   ACCUM SUB-TOTAL BY Temporal.Clase Temporal.STK[2] @ Temporal.STK[2] 
                   WITH FRAME F-CAB.               
           DOWN STREAM REPORT 1 WITH FRAME F-CAB.        
        END.

        IF LAST-OF (Temporal.CodPr1) THEN DO:
           
           UNDERLINE STREAM REPORT Temporal.ENE[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.FEB[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.MAR[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.ABR[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.MAY[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.TOT[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.STK[2] WITH FRAME F-CAB. 
           
           DISPLAY STREAM REPORT
                   {&PRN6A} + "Total Proveedor : " + Temporal.CodPr1 + {&PRN6B} @ Temporal.Desmat            
                   ACCUM SUB-TOTAL BY Temporal.CodPr1 Temporal.ENE[2] @ Temporal.ENE[2] 
                   ACCUM SUB-TOTAL BY Temporal.CodPr1 Temporal.FEB[2] @ Temporal.FEB[2] 
                   ACCUM SUB-TOTAL BY Temporal.CodPr1 Temporal.MAR[2] @ Temporal.MAR[2] 
                   ACCUM SUB-TOTAL BY Temporal.CodPr1 Temporal.ABR[2] @ Temporal.ABR[2] 
                   ACCUM SUB-TOTAL BY Temporal.CodPr1 Temporal.MAY[2] @ Temporal.MAY[2] 
                   ACCUM SUB-TOTAL BY Temporal.CodPr1 Temporal.TOT[2] @ Temporal.TOT[2] 
                   ACCUM SUB-TOTAL BY Temporal.CodPr1 Temporal.STK[2] @ Temporal.STK[2] 
                   WITH FRAME F-CAB.               
           DOWN STREAM REPORT 2 WITH FRAME F-CAB.        
        END.

        
        IF LAST-OF (Temporal.Codcia) THEN DO:
           DOWN STREAM REPORT 2 WITH FRAME F-CAB.        
           UNDERLINE STREAM REPORT Temporal.ENE[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.FEB[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.MAR[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.ABR[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.MAY[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.TOT[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.STK[2] WITH FRAME F-CAB. 
           
           DISPLAY STREAM REPORT
                   {&PRN6A} + "TOTAL GENERAL   :  " + {&PRN6B} @ Temporal.DESMAT
                   ACCUM TOTAL BY Temporal.Codcia Temporal.ENE[2] @ Temporal.ENE[2] 
                   ACCUM TOTAL BY Temporal.Codcia Temporal.FEB[2] @ Temporal.FEB[2] 
                   ACCUM TOTAL BY Temporal.Codcia Temporal.MAR[2] @ Temporal.MAR[2] 
                   ACCUM TOTAL BY Temporal.Codcia Temporal.ABR[2] @ Temporal.ABR[2] 
                   ACCUM TOTAL BY Temporal.Codcia Temporal.MAY[2] @ Temporal.MAY[2] 
                   ACCUM TOTAL BY Temporal.Codcia Temporal.TOT[2] @ Temporal.TOT[2] 
                   ACCUM TOTAL BY Temporal.Codcia Temporal.STK[2] @ Temporal.STK[2] 
                   WITH FRAME F-CAB.


        END.
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE XReporte2 D-Dialog 
PROCEDURE XReporte2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR L-SW AS LOGICAL INIT NO.
 DEFINE VAR X-TITU AS CHAR.
 X-TITU = "REPORTE DE VENTAS - PROYECCION DE COMPRA".
 DEFINE FRAME f-cab
        Temporal.CodMat  FORMAT "x(6)"  
        Temporal.DesMat  FORMAT "x(35)"   
        Temporal.DesMar  FORMAT "x(10)"   
        Temporal.Unidad  FORMAT "x(5)"   
        Temporal.Ctotot  FORMAT "->>>>>9.9999"
        Temporal.ENE[1]  FORMAT "->>>>>9.99"
        Temporal.ENE[2]  FORMAT "->>>>>9.99"
        Temporal.FEB[1]  FORMAT "->>>>>9.99"
        Temporal.FEB[2]  FORMAT "->>>>>9.99"
        Temporal.MAR[1]  FORMAT "->>>>>9.99"
        Temporal.MAR[2]  FORMAT "->>>>>9.99"
        Temporal.ABR[1]  FORMAT "->>>>>9.99"
        Temporal.ABR[2]  FORMAT "->>>>>9.99"
        Temporal.MAY[1]  FORMAT "->>>>>9.99"
        Temporal.MAY[2]  FORMAT "->>>>>9.99"
        Temporal.TOT[1]  FORMAT "->>>>>9.99"
        Temporal.TOT[2]  FORMAT "->>>>>9.99"
        Temporal.Stk[1]  FORMAT "->>>>>9.99"
        Temporal.Stk[2]  FORMAT "->>>>>9.99"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP(2)
        {&PRN2} + {&PRN6A} + X-TITU + {&PRN6B} + {&PRN3} AT 40 FORMAT "X(60)" SKIP
        {&PRN3} + {&PRN6B} + "Pagina: " AT 150 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "DESDE    : " + STRING(f-desde,"99/99/9999") + " HASTA :" + STRING(f-hasta,"99/99/9999") FORMAT "X(50)"
        {&PRN3} + {&PRN6B} + "Fecha : " AT 120 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)"
        {&PRN2} + {&PRN6A} + "MONEDA   : DOLARES AMERICANOS" At 1 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Hora  : " AT 120 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") + {&PRN6B} + {&PRND} SKIP
        {&PRN2} + {&PRN6A} + "ALMACENES EVALUADOS   : " + X-CODALM  At 1 FORMAT "X(150)"  SKIP
        {&PRN2} + {&PRN6A} + "DIVISIONES EVALUADAS  : " + X-CODDIV  + {&PRN4} + {&PRN6B} At 1 FORMAT "X(150)" SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                              Enero               Febrero                Marzo                  Abril                  Mayo                 Total                   Stock      " SKIP             
        " Articulo        Descripcion                Marca     U.M.        Costo   Cant.   Dolares       Cant.   Dolares       Cant.   Dolares       Cant.   Dolares       Cant.   Dolares       Cant.   Dolares        Cant.   Dolares " SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 350 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

  FOR EACH Temporal NO-LOCK
          BREAK BY Temporal.Codcia
                BY Temporal.CodPr1
                BY Temporal.Clase 
                BY Temporal.Desmat :
                                 
     {&NEW-PAGE}.
     DISPLAY STREAM REPORT WITH FRAME F-CAB.
          
     IF FIRST-OF ( Temporal.CodPr1) THEN DO:
        PUT STREAM REPORT 
        {&PRN2} + {&PRN6A} +  "PROVEEDOR : "  + Temporal.CodPr1 + " " + Temporal.NomPro + {&PRN4} + {&PRN6B} AT 1 FORMAT "X(100)" SKIP(2).
     END.

     
     IF FIRST-OF ( Temporal.Clase) THEN DO:
      PUT STREAM REPORT 
      {&PRN6A} + "Categoria  : " + Temporal.Clase + {&PRN6B}  AT 10  FORMAT "X(30)" SKIP.
     END.
     
      
      
      DISPLAY STREAM REPORT 
        Temporal.CodMat  FORMAT "X(6)"
        Temporal.DesMat  FORMAT "X(35)"
        Temporal.DesMar  FORMAT "X(10)"
        Temporal.Unidad  FORMAT "X(5)"
        Temporal.Ctotot  FORMAT "->>>>>9.9999"
        Temporal.ENE[1]  FORMAT "->>>>>9.99"
        Temporal.ENE[2]  FORMAT "->>>>>9.99"
        Temporal.FEB[1]  FORMAT "->>>>>9.99"
        Temporal.FEB[2]  FORMAT "->>>>>9.99"
        Temporal.MAR[1]  FORMAT "->>>>>9.99"
        Temporal.MAR[2]  FORMAT "->>>>>9.99"
        Temporal.ABR[1]  FORMAT "->>>>>9.99"
        Temporal.ABR[2]  FORMAT "->>>>>9.99"
        Temporal.MAY[1]  FORMAT "->>>>>9.99"
        Temporal.MAY[2]  FORMAT "->>>>>9.99"
        Temporal.TOT[1]  FORMAT "->>>>>9.99"
        Temporal.TOT[2]  FORMAT "->>>>>9.99"
        Temporal.Stk[1]  FORMAT "->>>>>9.99"
        Temporal.Stk[2]  FORMAT "->>>>>9.99"    
        WITH FRAME F-Cab.
              
        ACCUMULATE Temporal.ENE[2] ( SUB-TOTAL BY Temporal.CodPr1 ).
        ACCUMULATE Temporal.ENE[2] ( SUB-TOTAL BY Temporal.Clase  ).
        ACCUMULATE Temporal.ENE[2] ( TOTAL     BY Temporal.Codcia ). 
        
        ACCUMULATE Temporal.FEB[2] ( SUB-TOTAL BY Temporal.CodPr1 ).
        ACCUMULATE Temporal.FEB[2] ( SUB-TOTAL BY Temporal.Clase  ).
        ACCUMULATE Temporal.FEB[2] ( TOTAL     BY Temporal.Codcia ). 

        ACCUMULATE Temporal.MAR[2] ( SUB-TOTAL BY Temporal.CodPr1 ).
        ACCUMULATE Temporal.MAR[2] ( SUB-TOTAL BY Temporal.Clase  ).
        ACCUMULATE Temporal.MAR[2] ( TOTAL     BY Temporal.Codcia ). 
        
        ACCUMULATE Temporal.ABR[2] ( SUB-TOTAL BY Temporal.CodPr1 ).
        ACCUMULATE Temporal.ABR[2] ( SUB-TOTAL BY Temporal.Clase  ).
        ACCUMULATE Temporal.ABR[2] ( TOTAL     BY Temporal.Codcia ). 
        
        ACCUMULATE Temporal.MAY[2] ( SUB-TOTAL BY Temporal.CodPr1 ).
        ACCUMULATE Temporal.MAY[2] ( SUB-TOTAL BY Temporal.Clase  ).
        ACCUMULATE Temporal.MAY[2] ( TOTAL     BY Temporal.Codcia ). 
        
                
        ACCUMULATE Temporal.TOT[2] ( SUB-TOTAL BY Temporal.CodPr1 ).
        ACCUMULATE Temporal.TOT[2] ( SUB-TOTAL BY Temporal.Clase  ).
        ACCUMULATE Temporal.TOT[2] ( TOTAL     BY Temporal.Codcia ). 
 
        ACCUMULATE Temporal.STK[2] ( SUB-TOTAL BY Temporal.CodPr1 ).
        ACCUMULATE Temporal.STK[2] ( SUB-TOTAL BY Temporal.Clase  ).
        ACCUMULATE Temporal.STK[2] ( TOTAL     BY Temporal.Codcia ). 
                
        IF LAST-OF (Temporal.Clase) THEN DO:
           
           UNDERLINE STREAM REPORT Temporal.ENE[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.FEB[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.MAR[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.ABR[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.MAY[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.TOT[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.STK[2] WITH FRAME F-CAB.
           
           DISPLAY STREAM REPORT
                   {&PRN6A} + "Total Categoria : " + Temporal.Clase + {&PRN6B}  @ Temporal.Desmat            
                   ACCUM SUB-TOTAL BY Temporal.Clase Temporal.ENE[2] @ Temporal.ENE[2] 
                   ACCUM SUB-TOTAL BY Temporal.Clase Temporal.FEB[2] @ Temporal.FEB[2] 
                   ACCUM SUB-TOTAL BY Temporal.Clase Temporal.MAR[2] @ Temporal.MAR[2] 
                   ACCUM SUB-TOTAL BY Temporal.Clase Temporal.ABR[2] @ Temporal.ABR[2] 
                   ACCUM SUB-TOTAL BY Temporal.Clase Temporal.MAY[2] @ Temporal.MAY[2] 
                   ACCUM SUB-TOTAL BY Temporal.Clase Temporal.TOT[2] @ Temporal.TOT[2] 
                   ACCUM SUB-TOTAL BY Temporal.Clase Temporal.STK[2] @ Temporal.STK[2] 
                   WITH FRAME F-CAB.               
           DOWN STREAM REPORT 1 WITH FRAME F-CAB.        
        END.

        IF LAST-OF (Temporal.CodPr1) THEN DO:
           
           UNDERLINE STREAM REPORT Temporal.ENE[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.FEB[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.MAR[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.ABR[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.MAY[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.TOT[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.STK[2] WITH FRAME F-CAB. 
           
           DISPLAY STREAM REPORT
                   {&PRN6A} + "Total Proveedor : " + Temporal.CodPr1 + {&PRN6B} @ Temporal.Desmat            
                   ACCUM SUB-TOTAL BY Temporal.CodPr1 Temporal.ENE[2] @ Temporal.ENE[2] 
                   ACCUM SUB-TOTAL BY Temporal.CodPr1 Temporal.FEB[2] @ Temporal.FEB[2] 
                   ACCUM SUB-TOTAL BY Temporal.CodPr1 Temporal.MAR[2] @ Temporal.MAR[2] 
                   ACCUM SUB-TOTAL BY Temporal.CodPr1 Temporal.ABR[2] @ Temporal.ABR[2] 
                   ACCUM SUB-TOTAL BY Temporal.CodPr1 Temporal.MAY[2] @ Temporal.MAY[2] 
                   ACCUM SUB-TOTAL BY Temporal.CodPr1 Temporal.TOT[2] @ Temporal.TOT[2] 
                   ACCUM SUB-TOTAL BY Temporal.CodPr1 Temporal.STK[2] @ Temporal.STK[2] 
                   WITH FRAME F-CAB.               
           DOWN STREAM REPORT 2 WITH FRAME F-CAB.        
        END.

        
        IF LAST-OF (Temporal.Codcia) THEN DO:
           DOWN STREAM REPORT 2 WITH FRAME F-CAB.        
           UNDERLINE STREAM REPORT Temporal.ENE[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.FEB[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.MAR[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.ABR[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.MAY[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.TOT[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.STK[2] WITH FRAME F-CAB. 
           
           DISPLAY STREAM REPORT
                   {&PRN6A} + "TOTAL GENERAL   :  " + {&PRN6B} @ Temporal.DESMAT
                   ACCUM TOTAL BY Temporal.Codcia Temporal.ENE[2] @ Temporal.ENE[2] 
                   ACCUM TOTAL BY Temporal.Codcia Temporal.FEB[2] @ Temporal.FEB[2] 
                   ACCUM TOTAL BY Temporal.Codcia Temporal.MAR[2] @ Temporal.MAR[2] 
                   ACCUM TOTAL BY Temporal.Codcia Temporal.ABR[2] @ Temporal.ABR[2] 
                   ACCUM TOTAL BY Temporal.Codcia Temporal.MAY[2] @ Temporal.MAY[2] 
                   ACCUM TOTAL BY Temporal.Codcia Temporal.TOT[2] @ Temporal.TOT[2] 
                   ACCUM TOTAL BY Temporal.Codcia Temporal.STK[2] @ Temporal.STK[2] 
                   WITH FRAME F-CAB.


        END.
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

