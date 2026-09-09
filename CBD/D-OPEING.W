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
DEFINE STREAM Report.
/*DEFINE VARIABLE x-Raya     AS CHARACTER FORMAT "X(145)".
DEFINE {&NEW} SHARED VARIABLE xTerm       AS CHARACTER INITIAL "".
DEFINE {&NEW} SHARED VARIABLE s-aplic-id  LIKE Modulos.Modulo.
DEFINE {&NEW} SHARED VARIABLE s-user-id   LIKE _user._userid.*/

DEFINE NEW SHARED VARIABLE xTerm       AS CHARACTER INITIAL "".
DEFINE NEW SHARED VARIABLE s-aplic-id  LIKE Modulos.Modulo.
DEFINE NEW SHARED VARIABLE s-user-id   LIKE _user._userid.

DEF VAR l-immediate-display  AS LOGICAL.

DEFINE SHARED VARIABLE cb-codcia AS INTEGER.
DEFINE SHARED VARIABLE pv-codcia AS INTEGER.
DEFINE SHARED VARIABLE cl-codcia AS INTEGER.
DEFINE VARIABLE PTO       AS LOGICAL.

DEFINE VARIABLE T-VENDE  AS CHAR INIT "".
DEFINE VARIABLE X-MON    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-EST    AS CHAR FORMAT "X(3)".

/*VARIABLES GLOBALES */

DEFINE SHARED VAR S-CODCIA AS INTEGER.

/*DEFINE SHARED VAR S-CODDIV AS CHAR.*/
DEFINE SHARED VAR S-NOMCIA AS CHAR.
/*DEFINE SHARED VAR S-CODALM AS CHAR.*/

DEFINE VAR S-Moneda      AS CHAR FORMAT "X(32)" INIT "".
DEFINE VAR S-Mon         AS CHAR FORMAT "X(4)"  INIT "".
DEFINE VAR S-Encargado   AS CHAR FORMAT "X(32)" INIT "".
DEFINE VAR S-Procedencia AS CHAR FORMAT "X(55)" INIT "".
DEFINE VAR S-RUC         AS CHAR FORMAT "X(32)" INIT "".
DEFINE VAR S-Movimiento  LIKE Almtmovm.Desmov INIT "".
DEFINE VAR S-Referencia2 AS CHAR FORMAT "X(16)" INIT "".
DEFINE VAR S-Referencia1 AS CHAR FORMAT "X(16)" INIT "".
DEFINE VAR S-TOTAL       AS DECIMAL INIT 0.
DEFINE VAR S-SUBTO       AS DECIMAL INIT 0.
DEFINE VAR W-VTA0        AS DECIMAL INIT 0.
DEFINE VAR W-VTA1        AS DECIMAL INIT 0.
DEFINE VAR W-VTA2        AS DECIMAL INIT 0.
DEFINE VAR S-SOLES       AS DECIMAL INIT 0.
DEFINE VAR SW            AS INTEGER INIT 0.
DEFINE VAR S-Item        AS INTEGER INIT 0.
DEFINE VAR S-TIPO        AS CHAR FORMAT "X(14)".

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
&Scoped-Define ENABLED-OBJECTS f-almacen F-TIPO F-CODMOV f-provee f-desde ~
f-hasta f-elige RADIO-SET-1 B-impresoras RB-NUMBER-COPIES Btn_OK Btn_Cancel ~
RB-BEGIN-PAGE RB-END-PAGE RECT-49 RECT-5 RECT-50 
&Scoped-Define DISPLAYED-OBJECTS f-almacen F-TIPO F-CODMOV f-provee f-desde ~
f-hasta f-elige RADIO-SET-1 RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 

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

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE f-almacen AS CHARACTER FORMAT "XXX":U 
     LABEL "Almacen" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .69 NO-UNDO.

DEFINE VARIABLE F-CODMOV AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Movimiento" 
     VIEW-AS FILL-IN 
     SIZE 4.14 BY .69 NO-UNDO.

DEFINE VARIABLE f-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE f-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE f-numord AS INTEGER FORMAT "999999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .73 NO-UNDO.

DEFINE VARIABLE f-provee AS CHARACTER FORMAT "X(256)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .73 NO-UNDO.

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

DEFINE VARIABLE f-elige AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "General", 1,
"Documento", 2
     SIZE 29.29 BY .85
     FONT 7 NO-UNDO.

DEFINE VARIABLE F-TIPO AS CHARACTER INITIAL "I" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "I", "I",
"S", "S"
     SIZE 8 BY .77 NO-UNDO.

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
     SIZE 49.14 BY 5.15.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 4 GRAPHIC-EDGE  NO-FILL   
     SIZE 49.14 BY 5.96.

DEFINE RECTANGLE RECT-50
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 15.57 BY 11.15.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     f-almacen AT ROW 1.38 COL 2.85
     F-TIPO AT ROW 2.88 COL 3.14 NO-LABEL
     F-CODMOV AT ROW 2.92 COL 18.72 COLON-ALIGNED
     f-numord AT ROW 2.92 COL 37 COLON-ALIGNED
     f-provee AT ROW 2.92 COL 37 COLON-ALIGNED
     f-desde AT ROW 5 COL 13.43 COLON-ALIGNED
     f-hasta AT ROW 5 COL 31.43 COLON-ALIGNED
     f-elige AT ROW 1.31 COL 19.86 NO-LABEL
     RADIO-SET-1 AT ROW 7.23 COL 2.72 NO-LABEL
     B-impresoras AT ROW 8.19 COL 16
     b-archivo AT ROW 9.19 COL 16.14
     RB-OUTPUT-FILE AT ROW 9.35 COL 20 COLON-ALIGNED NO-LABEL
     RB-NUMBER-COPIES AT ROW 10.92 COL 10.57 COLON-ALIGNED
     Btn_OK AT ROW 2.54 COL 52.57
     Btn_Cancel AT ROW 5.38 COL 52.57
     RB-BEGIN-PAGE AT ROW 10.92 COL 25.29 COLON-ALIGNED
     RB-END-PAGE AT ROW 10.92 COL 39.43 COLON-ALIGNED
     "Rango de Fechas :" VIEW-AS TEXT
          SIZE 15.86 BY .54 AT ROW 4.15 COL 21.14
          FONT 6
     " Configuración de Impresión" VIEW-AS TEXT
          SIZE 47.86 BY .62 AT ROW 6.38 COL 1.72
          BGCOLOR 1 FGCOLOR 15 FONT 6
     "Páginas" VIEW-AS TEXT
          SIZE 7.72 BY .54 AT ROW 10.31 COL 33.72
          FONT 6
     RECT-49 AT ROW 1 COL 1
     RECT-5 AT ROW 6.19 COL 1
     RECT-50 AT ROW 1 COL 50.29
     SPACE(0.56) SKIP(0.26)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Ingresos Valorizados".


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

/* SETTINGS FOR FILL-IN f-almacen IN FRAME D-Dialog
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN f-numord IN FRAME D-Dialog
   NO-DISPLAY NO-ENABLE                                                 */
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Ingresos Valorizados */
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


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Aceptar */
DO:
 
  ASSIGN f-Desde f-hasta f-numord f-almacen f-elige 
         f-provee f-tipo f-codmov .

  IF f-almacen = "" then do:
     MESSAGE "Ingrese Almacen  ... " VIEW-AS ALERT-BOX.
     APPLY "ENTRY":U to f-almacen.
     RETURN NO-APPLY.   
  END.
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
  
  IF F-TIPO = "I" THEN S-TIPO = "INGRESO No. : ".
  IF F-TIPO = "S" THEN S-TIPO = "SALIDA  No. : ".
  IF f-almacen <> "" THEN DO:
     FIND Almacen WHERE Almacen.CodCia = S-CODCIA AND
          Almacen.CodAlm = F-ALMACEN NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Almacen THEN DO:     
             MESSAGE "Codigo de Almacen No Existe " VIEW-AS ALERT-BOX.
             APPLY "ENTRY":U to f-almacen.
             RETURN NO-APPLY.   
          END.
          S-Encargado = Almacen.EncAlm.
  END.        
  ELSE DO: 
     SW = 1.        
  END.        
 
  P-largo   = 33.
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


&Scoped-define SELF-NAME f-elige
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-elige D-Dialog
ON VALUE-CHANGED OF f-elige IN FRAME D-Dialog
DO:
  ASSIGN F-ELIGE. 
  f-provee:Visible   = (F-ELIGE = 1).
  f-provee:sensitive = (F-ELIGE = 1).
  f-numord:visible   = (F-ELIGE = 2).
  f-numord:sensitive = (F-ELIGE = 2).
  f-desde:sensitive  = (F-ELIGE = 1).
  f-hasta:sensitive  = (F-ELIGE = 1).
  f-numord:LABEL     = "Documento".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-TIPO
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-TIPO D-Dialog
ON VALUE-CHANGED OF F-TIPO IN FRAME D-Dialog
DO:
  ASSIGN F-tipo. 

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

ASSIGN F-DESDE   = TODAY
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE conta-tesoreria D-Dialog 
PROCEDURE conta-tesoreria :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  S-SUBTO = 0.
  S-SOLES = 0.
  S-TOTAL = 0.
  W-VTA0  = 0.
  W-VTA1  = 0.
  W-VTA2  = 0.
  
  DEFINE FRAME F-FMT
         Almdmov.CodMat     FORMAT "X(6)"
         Almdmov.CanDes     FORMAT ">>>,>>9.99" 
         Almdmov.CodUnd     FORMAT "X(4)" 
         Almmmatg.DesMat    FORMAT "X(35)"
         Almmmatg.Desmar    FORMAT "X(10)"
         Almdmov.Prelis     FORMAT ">,>>>.9999"
         Almdmov.Dsctos[1]  FORMAT ">>>.99"
         Almdmov.Dsctos[2]  FORMAT ">>.99"
         Almdmov.Dsctos[3]  FORMAT ">>.99"  
         Almdmov.Igvmat     FORMAT ">>.99" 
         Almdmov.ImpMn1     FORMAT ">,>>>,>>9.99"
         S-SUBTO            FORMAT ">,>>>,>>9.99"
         HEADER
         {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" 
         S-TIPO AT 96 Almcmov.NroDoc AT 114 SKIP
         {&PRN2} + {&PRN7A} + {&PRN6A} + "( " + F-ALMACEN + " )" + {&PRN6B} + {&PRN7B} + {&PRN3} AT 5 FORMAT "X(20)" 
         S-Movimiento  AT 52  "Pag. " AT 108 PAGE-NUMBER(Report) FORMAT ">>9" SKIP(1)
         S-PROCEDENCIA AT 1 FORMAT "X(70)" S-RUC AT 79 "Fecha : " AT 113 Almcmov.FchDoc AT 121 SKIP
         S-Referencia2 AT 1 ": " Almcmov.NroRf2  AT 20 "Almacen Ingreso : " AT 79 F-ALMACEN AT 99       "Hora  : " AT 113 Almcmov.HorRcp AT 121 SKIP 
         S-Referencia1 AT 1 ": " Almcmov.NroRf1  AT 20 S-MONEDA AT 79 "Tpo.Cam : " AT 113 Almdmov.TpoCmb AT 123 FORMAT ">>9.9999" SKIP         
         "Observaciones    : " AT 1 Almcmov.Observ  AT 20 "Responsable     : " AT 79 S-Encargado AT 99 SKIP
         "-----------------------------------------------------------------------------------------------------------------------------------" SKIP
         "CODIGO  CANTIDAD  UND.            DESCRIPCION              MARCA     VALOR VENTA  DSCT1 DSCT2 DSCT3 I.G.V.  VALOR S/.  P.NETO " AT 1 FORMAT "X(126)" S-MON SKIP
         "-----------------------------------------------------------------------------------------------------------------------------------" SKIP        
/***      999999 >>>,>>9.99 9999 12345678901234567890123456789012345 1234567890 >,>>>.9999 >>>.99 >>.99 >>.99 >>.99 >,>>>,>>9.99 >,>>>,>>9.99" ****/
         WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.         
         
  FIND FIRST Almdmov WHERE Almdmov.CodCia = Almcmov.CodCia AND
             Almdmov.CodAlm = Almcmov.CodAlm AND
             Almdmov.TipMov = Almcmov.TipMov AND
             Almdmov.CodMov = Almcmov.CodMov AND
             Almdmov.NroDoc = Almcmov.NroDoc USE-INDEX Almd01 NO-LOCK NO-ERROR.
  {&new-page}.
  IF AVAILABLE Almdmov THEN DO:  
     REPEAT WHILE  AVAILABLE  AlmDMov      AND Almdmov.CodAlm = Almcmov.CodAlm AND
            Almdmov.TipMov = Almcmov.TipMov AND Almdmov.CodMov = Almcmov.CodMov AND
            Almdmov.NroDoc = Almcmov.NroDoc:
            FIND Almmmatg WHERE Almmmatg.CodCia = Almdmov.CodCia AND
                 Almmmatg.CodMat = Almdmov.CodMat NO-LOCK NO-ERROR.
                 
            S-SOLES = S-SOLES + Almdmov.ImpMn1.                 
            W-VTA0 = almdmov.prelis * (1 - (Almdmov.dsctos[1] / 100)).
            W-VTA1 = w-vta0  * (1 - (Almdmov.dsctos[2] / 100)).
            W-VTA2 = w-vta1  * (1 - (Almdmov.dsctos[3] / 100)).
            IF Almmmatg.AftIgv THEN    
                S-SUBTO = ROUND(( W-VTA2 + ( W-VTA2 * (Almdmov.IgvMat / 100 ))) * ALMDMOV.CANDES,2).
            ELSE 
                S-SUBTO = ROUND( W-VTA2  * ALMDMOV.CANDES,2).
            S-TOTAL = S-TOTAL + S-SUBTO.
            DISPLAY STREAM Report 
                    Almdmov.CodMat 
                    Almdmov.CanDes 
                    Almdmov.CodUnd 
                    Almmmatg.DesMat 
                    Almmmatg.Desmar
                    Almdmov.Prelis  
                    Almdmov.Dsctos[1]
                    Almdmov.Dsctos[2]
                    Almdmov.Dsctos[3]
                    Almdmov.Igvmat
                    Almdmov.ImpMn1                    
                    S-SUBTO WITH FRAME F-FMT.
                    
            DOWN STREAM Report WITH FRAME F-FMT.
            FIND NEXT Almdmov USE-INDEX Almd01.
     END.
     PUT STREAM Report "------------ ------------" AT 107 skip.
     PUT STREAM Report S-SOLES FORMAT ">,>>>,>>9.99" AT 107 S-TOTAL FORMAT ">,>>>,>>9.99" AT 120 SKIP.
  END.
  DO WHILE LINE-COUNTER(Report) < PAGE-SIZE(Report) - 4 :
     PUT STREAM Report "" skip.
  END.
  PUT STREAM Report "    -----------------       -----------------       -----------------      -----------------"  AT 10 SKIP.
  PUT STREAM Report "        Recepcion                Vo. Bo.                  Vo. Bo.               Vo. Bo.     "  AT 10 SKIP.
  PUT STREAM Report "                                COMERCIAL              CONTABILIDAD            GERENCIA     "  AT 10 SKIP.  
/*PUT STREAM Report " ** CONTABILIDAD / TESORERIA ** " AT 119 SKIP.*/
  PUT STREAM Report " ** CONTABILIDAD / TESORERIA ** " AT 109 SKIP.  

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
  DISPLAY f-almacen F-TIPO F-CODMOV f-provee f-desde f-hasta f-elige RADIO-SET-1 
          RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 
      WITH FRAME D-Dialog.
  ENABLE f-almacen F-TIPO F-CODMOV f-provee f-desde f-hasta f-elige RADIO-SET-1 
         B-impresoras RB-NUMBER-COPIES Btn_OK Btn_Cancel RB-BEGIN-PAGE 
         RB-END-PAGE RECT-49 RECT-5 RECT-50 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE formato D-Dialog 
PROCEDURE formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  S-SUBTO = 0.  
  S-TOTAL = 0.
  W-VTA0  = 0.
  W-VTA1  = 0.
  W-VTA2  = 0.
  DEFINE VAR F-MONEDA AS CHAR FORMAT "X(4)".
  
  DEFINE FRAME F-FMT
         Almmmatg.Artpro FORMAT "X(09)"
         Almdmov.CodMat  FORMAT "X(6)"
         Almdmov.CanDes  FORMAT ">>>,>>9.99" 
         Almdmov.CodUnd  FORMAT "X(4)" 
         Almmmatg.DesMat FORMAT "X(47)"
         Almmmatg.Desmar FORMAT "X(20)"
         F-MONEDA        FORMAT "X(4)" 
         Almdmov.Prelis  FORMAT ">>,>>>.9999"
         Almdmov.ImpMn1  FORMAT ">,>>>,>>9.99"
         HEADER
         {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" 
         S-TIPO AT 96 Almcmov.NroDoc AT 114 SKIP
         {&PRN2} + {&PRN7A} + {&PRN6A} + "( " + F-ALMACEN + " )" + {&PRN6B} + {&PRN7B} + {&PRN3} AT 5 FORMAT "X(20)" 
         S-Movimiento  AT 52  "Pag. " AT 108 PAGE-NUMBER(Report) FORMAT ">>9" SKIP(1)
         S-PROCEDENCIA AT 1 FORMAT "X(70)" S-RUC AT 79 "Fecha : " AT 113 Almcmov.FchDoc AT 121 SKIP
         S-Referencia2 AT 1 ": " Almcmov.NroRf2  AT 20 "Almacen Ingreso : " AT 79 F-ALMACEN AT 99       "Hora  : " AT 113 Almcmov.HorRcp AT 121 SKIP 
         S-Referencia1 AT 1 ": " Almcmov.NroRf1  AT 20 S-MONEDA AT 79 "Tpo.Cam : " AT 113 Almdmov.TpoCmb AT 123 FORMAT ">>9.9999" SKIP
         "Observaciones    : " AT 1 Almcmov.Observ  AT 20 "Responsable     : " AT 79 S-Encargado AT 99 SKIP
         "-----------------------------------------------------------------------------------------------------------------------------------" SKIP
         "Cod.Pro.  CODIGO  CANTIDAD  UND.              DESCRIPCION                        M A R C A            MON  VALOR VENTA  IMPORTE S/." SKIP
         "-----------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.

  FIND FIRST Almdmov WHERE Almdmov.CodCia = Almcmov.CodCia AND
                           Almdmov.CodAlm = Almcmov.CodAlm AND
                           Almdmov.TipMov = Almcmov.TipMov AND
                           Almdmov.CodMov = Almcmov.CodMov AND
                           Almdmov.NroDoc = Almcmov.NroDoc USE-INDEX Almd01 NO-LOCK NO-ERROR.
  {&NEW-PAGE}.

  IF AVAILABLE Almdmov THEN DO:  
     FOR EACH AlmDMov OF AlmCMov NO-LOCK :
         FIND FIRST Almmmatg WHERE Almmmatg.CodCia = Almdmov.CodCia AND
                    Almmmatg.CodMat = Almdmov.CodMat NO-LOCK NO-ERROR.
         S-TOTAL = S-TOTAL + Almdmov.ImpMn1.
         
         IF ALMDMOV.CODMON = 1 THEN F-MONEDA = "S/.".
         ELSE F-MONEDA = "US$.".                 
         DISPLAY stream Report
                 Almdmov.CodMat 
                 Almdmov.CanDes 
                 Almdmov.CodUnd 
                 Almmmatg.ArtPro 
                 Almmmatg.DesMat 
                 Almmmatg.Desmar
                 F-MONEDA
                 Almdmov.Prelis
                 Almdmov.ImpMn1
                 WITH FRAME F-FMT.
     END.
     PUT STREAM Report "------------" AT 120 skip.
     PUT STREAM Report S-TOTAL FORMAT ">,>>>,>>9.99" AT 120 SKIP.     
  END.
  DO WHILE LINE-COUNTER(Report) < PAGE-SIZE(Report) - 4 :
     PUT STREAM Report "" skip.
  END.
  PUT STREAM Report "    -----------------       -----------------       -----------------      -----------------"  AT 10 SKIP.
  PUT STREAM Report "        Operador                 Vo. Bo.                  Vo. Bo.               Vo. Bo.     "  AT 10 SKIP.
  PUT STREAM Report Almcmov.usuario AT 18 "JEFE ALMACEN             CONTABILIDAD            GERENCIA     "  AT 40 SKIP.
  PUT STREAM Report " ** CONTABILIDAD ** " AT 119 SKIP.

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
  
  CASE F-ELIGE:
       WHEN 1 THEN
            RUN proce-01.
       WHEN 2 THEN
            RUN proce-02.
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
                    PAGED PAGE-SIZE 30.
               PUT STREAM report CONTROL P-reset NULL P-flen NULL P-config NULL.
        END.
        ELSE DO:
            OUTPUT STREAM report TO VALUE ( P-archivo ) NO-MAP NO-CONVERT UNBUFFERED
                 PAGED PAGE-SIZE 30.
            IF P-select = 3 THEN
                PUT STREAM report CONTROL P-reset P-flen P-config.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proce-01 D-Dialog 
PROCEDURE proce-01 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH ALMCMOV NO-LOCK WHERE 
         ALMCMOV.CodCia = S-CODCIA AND
         ALMCMOV.CodAlm = f-almacen AND
         ALMCMOV.TipMov = f-tipo     AND
         ALMCMOV.CodMov = f-codmov AND
         ALMCMOV.FchDoc >= f-desde AND
         ALMCMOV.FchDoc <= f-hasta AND
         ALMCMOV.CodPro BEGINS f-provee USE-INDEX almc04 :
                    
    IF almcmov.Codmon = 1 THEN DO:
       S-Moneda = "Compra en       :   SOLES".
       S-Mon    = "S/.".
    END.
    ELSE DO:
       S-Moneda = "Compra en       :   DOLARES".
       S-Mon    = "US$.".
    END.
    
    IF SW = 1 THEN DO:
       FIND Almacen WHERE Almacen.CodCia = S-CODCIA AND
            Almacen.CodAlm = ALMCMOV.CodAlm NO-LOCK NO-ERROR.
            S-Encargado = Almacen.EncAlm.
            F-Almacen   = Almcmov.CodAlm.
    END.            
    
    FIND FIRST Almtmovm WHERE  Almtmovm.CodCia = Almcmov.CodCia AND
               Almtmovm.Tipmov = Almcmov.TipMov AND 
               Almtmovm.Codmov = Almcmov.CodMov NO-LOCK NO-ERROR.
    IF AVAILABLE Almtmovm THEN DO:
       S-MOVIMIENTO = Almtmovm.Desmov.
       IF Almtmovm.PidPro THEN DO:
          FIND gn-prov WHERE gn-prov.CodCia = pv-codcia AND 
               gn-prov.CodPro = Almcmov.CodPro NO-LOCK NO-ERROR.
          IF NOT AVAILABLE gn-prov THEN 
             FIND gn-prov WHERE gn-prov.CodCia = Almcmov.CodCia AND 
                  gn-prov.CodPro = Almcmov.CodPro NO-LOCK NO-ERROR.
          IF AVAILABLE gn-prov THEN S-Procedencia = "Proveedor        : " + gn-prov.NomPro.
             S-RUC = "R.U.C.          :   " + Almcmov.CodPro.
       END.
       IF Almtmovm.PidRef1 THEN ASSIGN S-Referencia1 = Almtmovm.GloRf1.
       IF Almtmovm.PidRef2 THEN ASSIGN S-Referencia2 = Almtmovm.GloRf2.
    END.

    /***** Envia a Impresion *****/
    RUN conta-tesoreria.

END.
OUTPUT STREAM Report CLOSE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proce-02 D-Dialog 
PROCEDURE proce-02 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND FIRST ALMCMOV WHERE 
           ALMCMOV.CodCia = S-CODCIA  AND
           ALMCMOV.CodAlm = f-almacen AND
           ALMCMOV.TipMov = f-tipo    AND
           ALMCMOV.CodMov = f-codmov  AND
           ALMCMOV.NroDoc = f-numord USE-INDEX almc01
           NO-LOCK NO-ERROR.
                    
    IF almcmov.Codmon = 1 THEN DO:
       S-Moneda = "Compra en       :   SOLES".
       S-Mon    = "S/.".
    END.
    ELSE DO:
       S-Moneda = "Compra en       :   DOLARES".
       S-Mon    = "US$.".
    END.
    
    IF SW = 1 THEN DO:
       FIND Almacen WHERE Almacen.CodCia = S-CODCIA AND
            Almacen.CodAlm = ALMCMOV.CodAlm NO-LOCK NO-ERROR.
            S-Encargado = Almacen.EncAlm.
            F-Almacen   = Almcmov.CodAlm.
    END.                
    
    
    FIND FIRST Almtmovm WHERE  Almtmovm.CodCia = Almcmov.CodCia AND
               Almtmovm.Tipmov = Almcmov.TipMov AND 
               Almtmovm.Codmov = Almcmov.CodMov NO-LOCK NO-ERROR.
    IF AVAILABLE Almtmovm THEN DO:
       S-MOVIMIENTO = Almtmovm.Desmov.    
       IF Almtmovm.PidPro THEN DO:
          FIND gn-prov WHERE gn-prov.CodCia = pv-codcia AND 
               gn-prov.CodPro = Almcmov.CodPro NO-LOCK NO-ERROR.
          IF NOT AVAILABLE gn-prov THEN 
             FIND gn-prov WHERE gn-prov.CodCia = Almcmov.CodCia AND 
                  gn-prov.CodPro = Almcmov.CodPro NO-LOCK NO-ERROR.
          IF AVAILABLE gn-prov THEN S-Procedencia = "Proveedor        : " + gn-prov.NomPro.
             S-RUC = "R.U.C.          :   " + Almcmov.CodPro.
       END.
       IF Almtmovm.PidRef1 THEN ASSIGN S-Referencia1 = Almtmovm.GloRf1.
       IF Almtmovm.PidRef2 THEN ASSIGN S-Referencia2 = Almtmovm.GloRf2.       
    END.

    /***** Envia a Impresion *****/
    RUN conta-tesoreria.

OUTPUT STREAM Report CLOSE.
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
     
        WHEN "F-CODMOV" THEN 
             ASSIGN input-var-1 = f-tipo.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valoriza D-Dialog 
PROCEDURE valoriza :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  S-SUBTO = 0.  
  S-TOTAL = 0.
  W-VTA0  = 0.
  W-VTA1  = 0.
  W-VTA2  = 0.
  
  DEFINE FRAME F-FMT
         Almmmatg.Artpro FORMAT "X(10)"         
         Almdmov.CodMat     AT  11 FORMAT "X(6)"
         Almdmov.CanDes     AT  18 FORMAT ">>>,>>9.99" 
         Almdmov.CodUnd     AT  29 FORMAT "X(4)" 
         Almmmatg.DesMat    AT  34 FORMAT "X(35)"
         Almmmatg.Desmar    AT  71 FORMAT "X(10)"
         Almdmov.Prelis     AT  83 FORMAT ">,>>>.9999"
         Almdmov.Dsctos[1]  AT  95 FORMAT ">>.99"
         Almdmov.Dsctos[2]  AT 101 FORMAT ">>.99"
         Almdmov.Dsctos[3]  AT 107 FORMAT ">>.99"  
         Almdmov.Igvmat     AT 114 FORMAT ">>.99" 
/*       Almdmov.ImpCto     AT 120 FORMAT ">,>>>,>>9.99"*/
         S-SUBTO            AT 120 FORMAT ">,>>>,>>9.99"
         HEADER
         {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" 
         "INGRESO No. : " AT 96 Almcmov.NroDoc AT 114 SKIP
         {&PRN2} + {&PRN7A} + {&PRN6A} + "( " + F-ALMACEN + " )" + {&PRN6B} + {&PRN7B} + {&PRN3} AT 5 FORMAT "X(20)" 
         S-Movimiento  AT 52  "Pag. " AT 108 PAGE-NUMBER(Report) FORMAT ">>9" SKIP(1)
         S-PROCEDENCIA AT 1 FORMAT "X(70)" S-RUC AT 79 "Fecha : " AT 113 Almcmov.FchDoc AT 121 SKIP
         S-Referencia2 AT 1 ": " Almcmov.NroRf2  AT 20 "Almacen Ingreso : " AT 79 F-ALMACEN AT 99       "Hora  : " AT 113 Almcmov.HorRcp AT 121 SKIP 
         S-Referencia1 AT 1 ": " Almcmov.NroRf1  AT 20 S-MONEDA AT 79 SKIP
         "Observaciones    : " AT 1 Almcmov.Observ  AT 20 "Responsable     : " AT 79 S-Encargado AT 99 SKIP
         "-----------------------------------------------------------------------------------------------------------------------------------" SKIP
         "Cod.Pro. CODIGO  CANTIDAD  UND.            DESCRIPCION                  MARCA    VALOR VENTA DSCT1 DSCT2 DSCT3  I.G.V.   TOTAL NETO" SKIP
         "-----------------------------------------------------------------------------------------------------------------------------------" SKIP        
         WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.         
         
/*OUTPUT STREAM Report TO PRINTER PAGED PAGE-SIZE 30.*/
  FIND FIRST Almdmov WHERE Almdmov.CodCia = Almcmov.CodCia AND
             Almdmov.CodAlm = Almcmov.CodAlm AND
             Almdmov.TipMov = Almcmov.TipMov AND
             Almdmov.CodMov = Almcmov.CodMov AND
             Almdmov.NroDoc = Almcmov.NroDoc USE-INDEX Almd01 NO-LOCK NO-ERROR.
  {&new-page}.
  IF AVAILABLE Almdmov THEN DO:  
/*   PUT STREAM Report CONTROL {&PRN0} + {&PRN5A} + CHR(33) + {&PRN3}.     */
     REPEAT WHILE  AVAILABLE  AlmDMov      AND Almdmov.CodAlm = Almcmov.CodAlm AND
            Almdmov.TipMov = Almcmov.TipMov AND Almdmov.CodMov = Almcmov.CodMov AND
            Almdmov.NroDoc = Almcmov.NroDoc:
            FIND Almmmatg WHERE Almmmatg.CodCia = Almdmov.CodCia AND
                 Almmmatg.CodMat = Almdmov.CodMat NO-LOCK NO-ERROR.
/*              S-TOTAL = S-TOTAL + Almdmov.ImpCto.*/                
            W-VTA0 = almdmov.prelis * (1 - (Almdmov.dsctos[1] / 100)).
            W-VTA1 = w-vta0  * (1 - (Almdmov.dsctos[2] / 100)).
            W-VTA2 = w-vta1  * (1 - (Almdmov.dsctos[3] / 100)).
            IF Almmmatg.AftIgv THEN    
                S-SUBTO = ROUND(( W-VTA2 + ( W-VTA2 * (Almdmov.IgvMat / 100 ))) * ALMDMOV.CANDES,2).
            ELSE 
                S-SUBTO = ROUND( W-VTA2  * ALMDMOV.CANDES,2).
            S-TOTAL = S-TOTAL + S-SUBTO.
            DISPLAY STREAM Report 
                    Almdmov.CodMat 
                    Almdmov.CanDes 
                    Almdmov.CodUnd 
                    Almmmatg.ArtPro 
                    Almmmatg.DesMat 
                    Almmmatg.Desmar
                    Almdmov.Prelis  
                    Almdmov.Dsctos[1]
                    Almdmov.Dsctos[2]
                    Almdmov.Dsctos[3]
                    Almdmov.Igvmat
/*                  Almdmov.ImpCto */
                    S-SUBTO WITH FRAME F-FMT.
            DOWN STREAM Report WITH FRAME F-FMT.
            FIND NEXT Almdmov USE-INDEX Almd01.
     END.
     PUT STREAM Report "------------" AT 120 skip.
     PUT STREAM Report S-MON AT 115 S-TOTAL FORMAT ">,>>>,>>9.99" AT 120 SKIP.
  END.
  DO WHILE LINE-COUNTER(Report) < PAGE-SIZE(Report) - 4 :
     PUT STREAM Report "" skip.
  END.
  PUT STREAM Report "    -----------------       -----------------       -----------------      -----------------"  AT 10 SKIP.
  PUT STREAM Report "        Operador                 Vo. Bo.                  Vo. Bo.               Vo. Bo.     "  AT 10 SKIP.
  PUT STREAM Report Almcmov.usuario AT 18 "JEFE ALMACEN             CONTABILIDAD            GERENCIA     "  AT 40 SKIP.
  PUT STREAM Report " ** TESORERIA ** " AT 119 SKIP.
/*  OUTPUT STREAM Report CLOSE.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

