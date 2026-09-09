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
/* DEFINE        VARIABLE cb-codcia AS INTEGER INITIAL 0. */
/* DEFINE        VARIABLE pv-codcia AS INTEGER INITIAL 0. */
/* DEFINE        VARIABLE cl-codcia AS INTEGER INITIAL 0. */
DEFINE        VARIABLE PTO        AS LOGICAL.

DEFINE VARIABLE T-CLIEN AS CHAR INIT "" NO-UNDO.
DEFINE VARIABLE T-VENDE  AS CHAR INIT "".
DEFINE VARIABLE X-MON    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-EST    AS CHAR FORMAT "X(3)".

/*VARIABLES GLOBALES */
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR CL-CODCIA AS INTEGER.
DEFINE SHARED VAR PV-CODCIA AS INTEGER.
DEFINE SHARED VAR CB-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE SHARED VAR S-NOMCIA AS CHAR.
DEFINE SHARED VAR S-CODALM AS CHAR.

DEFINE TEMP-TABLE   tmp-tempo 
    FIELD t-codpro  LIKE Almmmatg.Codpr1
    FIELD t-nompro  LIKE Gn-Prov.Nompro 
    FIELD t-codalm  LIKE FacCpedi.Codalm
    FIELD t-codcli  LIKE FacCpedi.Codcli
    FIELD t-nomcli  LIKE FacCpedi.Nomcli
    FIELD t-codmat  LIKE FacDpedi.codmat
    FIELD t-desmat  LIKE Almmmatg.DesMat    FORMAT "X(40)"
    FIELD t-desmar  LIKE Almmmatg.DesMar    FORMAT "X(8)"
    FIELD t-undbas  LIKE Almmmatg.UndBas    FORMAT "X(8)"
    FIELD t-glosa   AS CHAR          FORMAT "X(30)"
    FIELD t-stkact  LIKE Almmmate.StkAct    FORMAT "->>>>>,>>9.99"
    FIELD t-compro  AS DEC           FORMAT "->>>,>>>,>>9.99"
    FIELD t-solici  AS DEC           FORMAT "->>>,>>>,>>9.99"
    FIELD t-atendi  AS DEC           FORMAT "->>>,>>>,>>9.99"
    FIELD t-pendie  AS DEC           FORMAT "->,>>>,>>9.99"
    FIELD t-totsol  AS DEC           FORMAT "->>>,>>>,>>>,>>9.99"
    FIELD t-totdol  AS DEC           FORMAT "->>>,>>>,>>>,>>9.99"
    FIELD t-codfam  LIKE Almmmatg.codfam
    INDEX Llave01   AS PRIMARY t-CodMat
    INDEX Llave02   t-CodCli t-CodMat
    INDEX Llave03   t-DesMar
    Index Llave04   t-CodPro.

DEF BUFFER B-FacCPedi FOR FacCPedi.
DEF BUFFER B-Almmmatg FOR Almmmatg.

DEF VAR chtpodocu AS CHARACTER NO-UNDO.
DEF VAR x-fentdesde AS DATE NO-UNDO.
DEF VAR x-fenthasta AS DATE NO-UNDO.

/*Variables Excel*/

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 3.

DEFINE VAR W-TOTBRU AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
DEFINE VAR W-TOTDSC AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
DEFINE VAR W-TOTVAL AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.  
DEFINE VAR W-TOTIGV AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
DEFINE VAR W-TOTVEN AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
DEFINE VAR X-PENDIENTE AS DECIMAL INIT 0.   
DEFINE VAR X-STOCK     AS DECIMAL INIT 0.   
DEFINE VAR F-FACTOR    AS DECIMAL INIT 0.   

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
&Scoped-Define ENABLED-OBJECTS RECT-41 RECT-43 f-clien FILL-IN-Marca ~
cb-almac R-Tipo f-desde f-hasta FILL-IN-FchPed-1 FILL-IN-FchPed-2 ~
F-entrega1 F-entrega2 Btn_OK-2 Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-3 f-clien f-nomcli FILL-IN-Marca ~
cb-almac txt-desalm R-Tipo f-desde f-hasta FILL-IN-FchPed-1 ~
FILL-IN-FchPed-2 F-entrega1 F-entrega2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel DEFAULT 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK-2 AUTO-GO 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE cb-almac AS CHARACTER FORMAT "X(3)":U INITIAL "35" 
     LABEL "Almacen" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "45","35" 
     DROP-DOWN-LIST
     SIZE 11.86 BY .81 NO-UNDO.

DEFINE VARIABLE f-clien AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE f-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Cotizaciones Emitidas Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-entrega1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Con Cotizaciones a Entregar Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-entrega2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE f-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE f-nomcli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .81
     BGCOLOR 8  NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(256)":U 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81
     FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchPed-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Con Pedidos Emitidos Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchPed-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Marca AS CHARACTER FORMAT "X(256)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE txt-desalm AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .81
     BGCOLOR 8  NO-UNDO.

DEFINE VARIABLE R-Tipo AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Cliente", 1,
"Resumen Proveedor", 2,
"Resumen por Marca", 3,
"Familia", 4
     SIZE 53 BY .77 NO-UNDO.

DEFINE RECTANGLE RECT-41
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 71.72 BY 8.

DEFINE RECTANGLE RECT-43
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 71.57 BY 2.96.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     FILL-IN-3 AT ROW 1.27 COL 3.86
     f-clien AT ROW 2.08 COL 8 COLON-ALIGNED
     f-nomcli AT ROW 2.15 COL 20.29 COLON-ALIGNED NO-LABEL
     FILL-IN-Marca AT ROW 2.88 COL 8 COLON-ALIGNED
     cb-almac AT ROW 3.69 COL 8.14 COLON-ALIGNED WIDGET-ID 10
     txt-desalm AT ROW 3.69 COL 20.43 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     R-Tipo AT ROW 4.81 COL 10 NO-LABEL
     f-desde AT ROW 5.85 COL 30 COLON-ALIGNED
     f-hasta AT ROW 5.85 COL 48 COLON-ALIGNED
     FILL-IN-FchPed-1 AT ROW 6.65 COL 30 COLON-ALIGNED
     FILL-IN-FchPed-2 AT ROW 6.65 COL 48 COLON-ALIGNED
     F-entrega1 AT ROW 7.46 COL 30 COLON-ALIGNED WIDGET-ID 2
     F-entrega2 AT ROW 7.46 COL 48 COLON-ALIGNED WIDGET-ID 4
     Btn_OK-2 AT ROW 10.15 COL 35 WIDGET-ID 6
     Btn_OK AT ROW 10.15 COL 47.57
     Btn_Cancel AT ROW 10.15 COL 60
     " Configuración de Impresión" VIEW-AS TEXT
          SIZE 69.57 BY .62 AT ROW 9.35 COL 2.43
          BGCOLOR 1 FGCOLOR 1 FONT 6
     RECT-41 AT ROW 1.08 COL 1.29
     RECT-43 AT ROW 9.08 COL 1.43
     SPACE(0.85) SKIP(0.22)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Cotizaciones Por Atender Oficina".


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
   FRAME-NAME L-To-R                                                    */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN f-nomcli IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-3 IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN txt-desalm IN FRAME D-Dialog
   NO-ENABLE                                                            */
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Cotizaciones Por Atender Oficina */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel D-Dialog
ON CHOOSE OF Btn_Cancel IN FRAME D-Dialog /* Cancelar */
DO:
  &IF "{&PROCEDURE-TYPE}" EQ "SmartPanel" &THEN
    &IF "{&ADM-VERSION}" EQ "ADM1.1" &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
    &ELSE
      RUN exitObject.
    &ENDIF
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Aceptar */
DO:
  ASSIGN 
      f-Desde f-hasta f-clien R-tipo 
      FILL-IN-Marca FILL-IN-FchPed-1 FILL-IN-FchPed-2 
      F-entrega1 F-entrega2 cb-almac.

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

  /******/
  IF F-entrega1 = ? THEN ASSIGN x-fentdesde = 01/01/2000. ELSE ASSIGN x-fentdesde = F-entrega1. 
  IF F-entrega2 = ? THEN ASSIGN x-fenthasta = 12/31/3000. ELSE ASSIGN x-fenthasta = F-entrega2. 
  
  IF f-clien <> "" THEN T-clien = "Cliente :  " + f-clien.
/*
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
*/


  RUN Imprime.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK-2 D-Dialog
ON CHOOSE OF Btn_OK-2 IN FRAME D-Dialog /* Aceptar */
DO:
  ASSIGN 
      f-Desde f-hasta f-clien 
      R-tipo FILL-IN-Marca FILL-IN-FchPed-1 FILL-IN-FchPed-2 
      F-entrega1 F-entrega2 cb-almac.

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

  /******/
  IF F-entrega1 = ? THEN ASSIGN x-fentdesde = 01/01/2000. ELSE ASSIGN x-fentdesde = F-entrega1. 
  IF F-entrega2 = ? THEN ASSIGN x-fenthasta = 12/31/3000. ELSE ASSIGN x-fenthasta = F-entrega2. 
  
  IF f-clien <> "" THEN T-clien = "Cliente :  " + f-clien.
  
  CASE R-tipo:
      WHEN 1 THEN RUN Excel-prnofi.
      WHEN 2 THEN RUN Excel-proveedor.
      WHEN 3 THEN RUN Excel-marca.
      WHEN 4 THEN RUN Excel-familia.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-almac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-almac D-Dialog
ON VALUE-CHANGED OF cb-almac IN FRAME D-Dialog /* Almacen */
DO:
    FIND FIRST almacen WHERE almacen.codcia = s-codcia
      AND almacen.codalm = cb-almac:SCREEN-VALUE IN FRAME {&FRAME-NAME} 
        NO-LOCK NO-ERROR.
    IF AVAIL almacen THEN 
        DISPLAY almacen.descripcion @ txt-desalm
            WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-clien
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-clien D-Dialog
ON LEAVE OF f-clien IN FRAME D-Dialog /* Cliente */
DO:
  F-clien = "".
  IF F-clien:SCREEN-VALUE <> "" THEN DO: 
     FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA AND 
          gn-clie.Codcli = F-clien:screen-value NO-LOCK NO-ERROR.
     IF AVAILABLE gn-clie THEN F-Nomcli = gn-clie.Nomcli.
  END.
  DISPLAY F-NomCli WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-clien D-Dialog
ON MOUSE-SELECT-DBLCLICK OF f-clien IN FRAME D-Dialog /* Cliente */
OR f8 OF f-Clien
DO:
  RUN LKUP\C-CLIENT("Cliente").
  IF output-var-1 = ? THEN RETURN NO-APPLY.
  SELF:SCREEN-VALUE = output-var-2.
  F-clien = "".
  IF F-clien:SCREEN-VALUE <> "" THEN DO: 
     FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA AND 
          gn-clie.Codcli = F-clien:screen-value NO-LOCK NO-ERROR.
     IF AVAILABLE gn-clie THEN F-Nomcli = gn-clie.Nomcli.
  END.
  DISPLAY F-NomCli WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */
/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */

ASSIGN FILL-IN-3 = S-CODDIV
       F-DESDE   = TODAY
       F-HASTA   = TODAY.
/*       
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

*/

{src/adm/template/windowmn.i}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-temporal D-Dialog 
PROCEDURE carga-temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
 DEFINE VAR X-PENDIENTE AS DECIMAL INIT 0.   
 DEFINE VAR F-FACTOR    AS DECIMAL INIT 0.  
 DEFINE VAR x-StkCom    AS DECIMAL INIT 0.

 FOR EACH TMP-TEMPO:
     DELETE tmp-tempo.
 END.

 INICIO:
 FOR EACH FacCpedi NO-LOCK WHERE
     FacCpedi.CodCia = S-CODCIA     AND
     FacCpedi.CodDiv = S-CODDIV     AND
     FacCpedi.CodDoc = "COT"        AND
     FacCpedi.FlgEst = "P"          AND
     FacCpedi.Codcli BEGINS f-clien AND
     FacCpedi.FchPed >= F-desde     AND
     FacCpedi.FchPed <= F-hasta:
     /* Filtro por Fecha de Entrega */
     IF f-Entrega1 <> ? AND FacCpedi.FchEnt < f-Entrega1 THEN NEXT INICIO.
     IF f-Entrega2 <> ? AND FacCpedi.FchEnt > f-Entrega2 THEN NEXT INICIO.
     /* Filtro por fecha de pedido */
     IF FILL-IN-FchPed-1 <> ? OR FILL-IN-FchPed-2 <> ? THEN DO:
         FIND FIRST B-FacCPedi USE-INDEX Llave03 WHERE B-FacCPedi.CodCia = s-CodCia
             AND B-FacCPedi.CodDiv = s-CodDiv
             AND B-FacCPedi.CodDoc = 'PED'
             AND B-FacCPedi.NroRef = FacCPedi.NroPed
             AND B-FacCPedi.FlgEst <> 'A'
             AND (FILL-IN-FchPed-1 = ? OR B-FacCPedi.FchPed >= FILL-IN-FchPed-1)
             AND (FILL-IN-FchPed-2 = ? OR B-FacCPedi.FchPed <= FILL-IN-FchPed-2) NO-LOCK NO-ERROR.
         IF NOT AVAILABLE B-FacCPedi THEN NEXT INICIO.
     END.

     FOR EACH Facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.canped - Facdpedi.canate > 0:
         FIND FIRST B-Almmmatg WHERE B-Almmmatg.CodCia = S-CODCIA 
             AND B-Almmmatg.CodmAT = FacDpedi.CodMat NO-LOCK NO-ERROR. 
         FIND FIRST Almtconv WHERE Almtconv.CodUnid  = B-Almmmatg.UndBas 
             AND Almtconv.Codalter = FacDpedi.UndVta NO-LOCK NO-ERROR.
         F-FACTOR  = 1. 
         IF NOT AVAILABLE B-Almmmatg THEN RETURN "ADM-ERROR".
         IF AVAILABLE Almtconv THEN DO:
             F-FACTOR = Almtconv.Equival.
             IF B-Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / B-Almmmatg.FacEqu.
         END.

         FIND Tmp-tempo WHERE Tmp-Tempo.t-Codcli = Faccpedi.Codcli AND
             Tmp-Tempo.t-Codmat = FacdPedi.Codmat NO-LOCK NO-ERROR.
         
         IF NOT AVAILABLE Tmp-Tempo THEN DO: 
             CREATE Tmp-Tempo.
             ASSIGN   
                 /*Tmp-Tempo.t-CodAlm = Faccpedi.CodAlm*/
                 Tmp-Tempo.t-CodAlm = cb-almac
                 Tmp-Tempo.t-Codcli = Faccpedi.Codcli 
                 Tmp-Tempo.t-Nomcli = Faccpedi.Nomcli 
                 Tmp-Tempo.t-Codmat = FacdPedi.Codmat
                 Tmp-Tempo.t-DesMat = B-Almmmatg.DesMat
                 Tmp-Tempo.t-DesMar = B-Almmmatg.DesMar
                 Tmp-Tempo.t-UndBas = B-Almmmatg.UndBas.
         END.  

         Tmp-Tempo.t-glosa  = Tmp-Tempo.t-glosa + substring(string(FaccPedi.FchPed),1,5) + "-" + SUBSTRING(FaccPedi.Nroped,4,6) + '/'.
         Tmp-Tempo.t-solici = Tmp-Tempo.t-solici + FacdPedi.Canped * F-FACTOR.
         Tmp-Tempo.t-atendi = Tmp-Tempo.t-atendi + FacdPedi.Canate * F-FACTOR.
         Tmp-Tempo.t-pendie = Tmp-Tempo.t-pendie + (FacdPedi.Canped - FacdPedi.CanAte) * F-FACTOR.
         If FaccPedi.Codmon = 1 THEN Tmp-Tempo.t-totsol = Tmp-Tempo.t-totsol + (FacdPedi.Canped - FacdPedi.CanAte) * ( FacdPedi.ImpLin / FacdPedi.CanPed ).
         If FaccPedi.Codmon = 2 THEN Tmp-Tempo.t-totdol = Tmp-Tempo.t-totdol + (FacdPedi.Canped - FacdPedi.CanAte) * ( FacdPedi.ImpLin / FacdPedi.CanPed ).
     END.    
     DISPLAY Fi-Mensaje WITH FRAME F-Proceso.
END.

FOR EACH Tmp-Tempo:
    /* STOCK COMPROMETIDO */
    x-StkCom = 0.
    RUN Stock-Comprometid (Tmp-Tempo.t-CodMat, OUTPUT x-StkCom).
    /* ****************** */
    ASSIGN Tmp-Tempo.t-Compro = x-StkCom.
END.

HIDE FRAME F-Proceso NO-PAUSE.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-temporal-prove D-Dialog 
PROCEDURE carga-temporal-prove :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 DEFINE VAR X-PENDIENTE AS DECIMAL INIT 0.   
 DEFINE VAR F-FACTOR    AS DECIMAL INIT 0.  
 DEFINE VAR x-nompro AS CHAR.
 
 FOR EACH TMP-TEMPO:
     DELETE tmp-tempo.
 END.

 INICIO:
 FOR EACH FacCpedi NO-LOCK WHERE
     FacCpedi.CodCia = S-CODCIA AND
     FacCpedi.CodDiv = S-CODDIV AND
     FacCpedi.CodDoc = "COT"    AND
     FacCpedi.FlgEst = "P"      AND
     FacCpedi.Codcli BEGINS f-clien AND
     FacCpedi.FchPed >= F-desde AND
     FacCpedi.FchPed <= F-hasta AND
     FacCpedi.FchEnt >= x-fentdesde AND
     FacCPedi.FchEnt <= x-fenthasta ,
     EACH FacDpedi OF FacCpedi NO-LOCK:
     IF CANPED - CANATE = 0 THEN NEXT.
     /* Filtro por fecha de pedido */
     IF FILL-IN-FchPed-1 <> ? THEN DO:
         FIND FIRST B-FacCPedi WHERE B-FacCPedi.CodCia = s-CodCia
             AND B-FacCPedi.CodDiv = s-CodDiv
             AND B-FacCPedi.CodDoc = 'PED'
             AND B-FacCPedi.FlgEst <> 'A'
             AND B-FacCPedi.FchPed >= FILL-IN-FchPed-1
             AND B-FacCPedi.FchPed <= FILL-IN-FchPed-2
             AND B-FacCPedi.NroRef = FacCPedi.NroPed NO-LOCK NO-ERROR.
         IF NOT AVAILABLE B-FacCPedi THEN NEXT INICIO.
     END.
     
     FIND FIRST B-Almmmatg WHERE B-Almmmatg.CodCia = S-CODCIA AND
         B-Almmmatg.CodmAT = FacDpedi.CodMat NO-LOCK NO-ERROR. 

     FIND FIRST Almtconv WHERE Almtconv.CodUnid  = B-Almmmatg.UndBas AND  
         Almtconv.Codalter = FacDpedi.UndVta NO-LOCK NO-ERROR.

     F-FACTOR  = 1. 
     IF NOT AVAILABLE B-Almmmatg THEN RETURN "ADM-ERROR".    
     IF AVAILABLE Almtconv THEN DO:
         F-FACTOR = Almtconv.Equival.
         IF B-Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / B-Almmmatg.FacEqu.
     END.
     
     FIND Tmp-tempo WHERE Tmp-Tempo.t-Codmat = FacdPedi.Codmat NO-LOCK NO-ERROR.

     IF NOT AVAILABLE Tmp-Tempo THEN DO: 
         FIND Gn-Prov WHERE Gn-Prov.Codcia = PV-CODCIA AND
             Gn-Prov.Codpro = B-Almmmatg.Codpr1 NO-LOCK NO-ERROR.
         x-nompro = "".                   
         IF AVAILABLE Gn-Prov THEN x-nompro = Gn-prov.NomPro.                   
         CREATE Tmp-Tempo.
         ASSIGN   
             /*Tmp-Tempo.t-CodAlm = Faccpedi.CodAlm*/
             Tmp-Tempo.t-CodAlm = cb-almac
             Tmp-Tempo.t-Codcli = Faccpedi.Codcli 
             Tmp-Tempo.t-Nomcli = Faccpedi.Nomcli 
             Tmp-Tempo.t-Codmat = FacdPedi.Codmat
             Tmp-Tempo.t-DesMat = B-Almmmatg.DesMat
             Tmp-Tempo.t-DesMar = B-Almmmatg.DesMar
             Tmp-Tempo.t-UndBas = B-Almmmatg.UndBas
             Tmp-Tempo.t-Codpro = B-Almmmatg.Codpr1 
             Tmp-Tempo.t-Nompro = x-nompro
             Tmp-Tempo.t-CodFam = B-Almmmatg.CodFam.
     END.  

     Tmp-Tempo.t-glosa  = Tmp-Tempo.t-glosa + substring(string(FaccPedi.FchPed),1,5) + "-" + SUBSTRING(FaccPedi.Nroped,4,6) + '/'.
     Tmp-Tempo.t-solici = Tmp-Tempo.t-solici + FacdPedi.Canped * F-FACTOR.
     Tmp-Tempo.t-atendi = Tmp-Tempo.t-atendi + FacdPedi.Canate * F-FACTOR.
     Tmp-Tempo.t-pendie = Tmp-Tempo.t-pendie + (FacdPedi.Canped - FacdPedi.CanAte) * F-FACTOR.
     If FaccPedi.Codmon = 1 THEN Tmp-Tempo.t-totsol = Tmp-Tempo.t-totsol + (FacdPedi.Canped - FacdPedi.CanAte) * ( FacdPedi.ImpLin / FacdPedi.CanPed ).
     If FaccPedi.Codmon = 2 THEN Tmp-Tempo.t-totdol = Tmp-Tempo.t-totdol + (FacdPedi.Canped - FacdPedi.CanAte) * ( FacdPedi.ImpLin / FacdPedi.CanPed ).

     DISPLAY Fi-Mensaje WITH FRAME F-Proceso.    
END.
FOR EACH Tmp-Tempo:
    IF FILL-IN-Marca <> '' THEN DO:
        IF NOT tmp-tempo.t-desmar BEGINS TRIM(FILL-IN-Marca) THEN DELETE tmp-tempo.
    END.
    /*
     FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA AND
                         Almmmate.CodAlm = tmp-tempo.t-CodAlm AND
                         Almmmate.CodmAT = tmp-tempo.t-CodMat
                         NO-LOCK NO-ERROR. 
     IF AVAILABLE Almmmate THEN DO:
        IF Almmmate.stkact >= tmp-tempo.t-pendie THEN DELETE Tmp-Tempo.
     End.
    */
END.
HIDE FRAME F-Proceso NO-PAUSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal2 D-Dialog 
PROCEDURE Carga-Temporal2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR X-PENDIENTE AS DECIMAL INIT 0.   
 DEFINE VAR F-FACTOR    AS DECIMAL INIT 0.  
 DEFINE VAR x-StkCom    AS DECIMAL INIT 0.

  FOR EACH TMP-TEMPO:
    DELETE tmp-tempo.
  END.
  MESSAGE "fecha Ped 1: " FILL-IN-FchPed-1  SKIP
          "fecha Ped 2: " FILL-IN-FchPed-2. 
  INICIO:
  FOR EACH FacCpedi NO-LOCK WHERE
        FacCpedi.CodCia = S-CODCIA AND
        FacCpedi.CodDiv = S-CODDIV AND
        FacCpedi.CodDoc = "COT"    AND
       /* FacCpedi.FlgEst = "P"      AND*/
        FacCpedi.FchPed >= F-desde AND
        FacCpedi.FchPed <= F-hasta AND 
        FacCpedi.FchEnt >= F-entrega1 AND
        FacCPedi.FchEnt <= F-entrega2 AND 
        FacCpedi.Codcli BEGINS f-clien ,
        EACH FacDpedi OF FacCpedi NO-LOCK:
    /*IF CANPED - CANATE <= 0 THEN NEXT.*/
        
    /* Filtro por fecha de pedido */
    IF FILL-IN-FchPed-1 <> ?
    THEN DO:
        MESSAGE "FECHAS".
        FIND FIRST B-FacCPedi WHERE B-FacCPedi.CodCia = s-CodCia
            AND B-FacCPedi.CodDiv = s-CodDiv
            AND B-FacCPedi.CodDoc = 'PED'
            AND B-FacCPedi.FlgEst <> 'A'
            AND B-FacCPedi.FchPed >= FILL-IN-FchPed-1
            AND B-FacCPedi.FchPed <= FILL-IN-FchPed-2
            AND B-FacCPedi.NroRef = FacCPedi.NroPed
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-FacCPedi THEN NEXT INICIO.
    END.
    FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
        AND Almmmatg.CodmAT = FacDpedi.CodMat
        NO-LOCK NO-ERROR. 
    FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
        AND Almtconv.Codalter = FacDpedi.UndVta
        NO-LOCK NO-ERROR.
    F-FACTOR  = 1. 
    IF AVAILABLE Almtconv THEN DO:
        F-FACTOR = Almtconv.Equival.
        IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
    END.
      
      FIND Tmp-tempo WHERE Tmp-Tempo.t-Codcli = Faccpedi.Codcli AND
                           Tmp-Tempo.t-Codmat = FacdPedi.Codmat 
                           NO-LOCK NO-ERROR.
                           
      IF NOT AVAILABLE Tmp-Tempo THEN DO: 
         CREATE Tmp-Tempo.
         ASSIGN   /*Tmp-Tempo.t-CodAlm = Faccpedi.CodAlm*/
                  Tmp-Tempo.t-CodAlm = cb-almac      
                  Tmp-Tempo.t-Codcli = Faccpedi.Codcli 
                  Tmp-Tempo.t-Nomcli = Faccpedi.Nomcli 
                  Tmp-Tempo.t-Codmat = FacdPedi.Codmat
                  Tmp-Tempo.t-DesMat = Almmmatg.DesMat
                  Tmp-Tempo.t-DesMar = Almmmatg.DesMar
                  Tmp-Tempo.t-UndBas = Almmmatg.UndBas.
       END.  
         Tmp-Tempo.t-glosa  = Tmp-Tempo.t-glosa + substring(string(FaccPedi.FchPed),1,5) + "-" + SUBSTRING(FaccPedi.Nroped,4,6) + '/'.
         Tmp-Tempo.t-solici = Tmp-Tempo.t-solici + FacdPedi.Canped * F-FACTOR.
         Tmp-Tempo.t-atendi = Tmp-Tempo.t-atendi + FacdPedi.Canate * F-FACTOR.
         Tmp-Tempo.t-pendie = Tmp-Tempo.t-pendie + (FacdPedi.Canped - FacdPedi.CanAte) * F-FACTOR.
         If FaccPedi.Codmon = 1 THEN Tmp-Tempo.t-totsol = Tmp-Tempo.t-totsol + (FacdPedi.Canped - FacdPedi.CanAte) * ( FacdPedi.ImpLin / FacdPedi.CanPed ).
         If FaccPedi.Codmon = 2 THEN Tmp-Tempo.t-totdol = Tmp-Tempo.t-totdol + (FacdPedi.Canped - FacdPedi.CanAte) * ( FacdPedi.ImpLin / FacdPedi.CanPed ).
  END.


  FOR EACH Tmp-Tempo:
    /* STOCK COMPROMETIDO */
    x-StkCom = 0.
    RUN Stock-Comprometido (Tmp-Tempo.t-CodMat, OUTPUT x-StkCom).
    /* ****************** */
    ASSIGN
        Tmp-Tempo.t-Compro = x-StkCom.
  END.
 
END PROCEDURE.


/* FILL-IN-FchPed-1:VISIBLE IN FRAME {&FRAME-NAME} = TRUE.
  FILL-IN-FchPed-2:VISIBLE IN FRAME {&FRAME-NAME} = TRUE.
  IF INPUT d-tpodoc = 1 THEN DO:

      /*dfchini = F-Desde.
      dfchfin = F-Hasta.*/
          
          FILL-IN-FchPed-1:HIDDEN IN FRAME {&FRAME-NAME} = TRUE.
          FILL-IN-FchPed-2:HIDDEN IN FRAME {&FRAME-NAME} = TRUE.
          FILL-IN-FchPed-1:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE.
          FILL-IN-FchPed-2:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE.
          
          f-desde:HIDDEN IN FRAME {&FRAME-NAME} = FALSE.
          f-hasta:HIDDEN IN FRAME {&FRAME-NAME} = FALSE.
          f-desde:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE.
          f-hasta:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE.

          F-entrega1:HIDDEN IN FRAME {&FRAME-NAME} = FALSE.
          F-entrega2:HIDDEN IN FRAME {&FRAME-NAME} = FALSE.
          F-entrega1:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE.
          F-entrega2:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE.
      
  END.
  ELSE DO:
      /*IF INPUT d-tpodoc = 2 THEN DO:*/
         /* dfchini = FILL-IN-FchPed-1.
          dfchfin = FILL-IN-FchPed-2.*/

          FILL-IN-FchPed-1:HIDDEN IN FRAME {&FRAME-NAME} = FALSE.
          FILL-IN-FchPed-2:HIDDEN IN FRAME {&FRAME-NAME} = FALSE.
          FILL-IN-FchPed-1:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE.
          FILL-IN-FchPed-2:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE.
          
          f-desde:HIDDEN IN FRAME {&FRAME-NAME} = TRUE.
          f-hasta:HIDDEN IN FRAME {&FRAME-NAME} = TRUE.
          f-desde:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE.
          f-hasta:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE.

          F-entrega1:HIDDEN IN FRAME {&FRAME-NAME} = TRUE.
          F-entrega2:HIDDEN IN FRAME {&FRAME-NAME} = TRUE.
          F-entrega1:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE.
          F-entrega2:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE.
  
     /* END.*/
  END.
END.*/

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
  DISPLAY FILL-IN-3 f-clien f-nomcli FILL-IN-Marca cb-almac txt-desalm R-Tipo 
          f-desde f-hasta FILL-IN-FchPed-1 FILL-IN-FchPed-2 F-entrega1 
          F-entrega2 
      WITH FRAME D-Dialog.
  ENABLE RECT-41 RECT-43 f-clien FILL-IN-Marca cb-almac R-Tipo f-desde f-hasta 
         FILL-IN-FchPed-1 FILL-IN-FchPed-2 F-entrega1 F-entrega2 Btn_OK-2 
         Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-Familia D-Dialog 
PROCEDURE Excel-Familia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
W-TOTBRU    = 0. 
W-TOTDSC    = 0.
W-TOTVAL    = 0. 
W-TOTIGV    = 0.
W-TOTVEN    = 0.
X-PENDIENTE = 0.
X-STOCK     = 0.
F-FACTOR    = 0.

RUN CARGA-TEMPORAL-PROVE.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:Range("A1: K2"):FONT:Bold = TRUE.
chWorkSheet:Range("A1"):VALUE =
    "COTIZACIONES POR ATENDER OFICINA" +
    " DESDE " + STRING(f-desde) + " AL " + STRING(f-hasta).
chWorkSheet:Range("A3"):VALUE = "Código".
chWorkSheet:Range("B3"):VALUE = "Descripcion".
chWorkSheet:Range("C3"):VALUE = "Marca".
chWorkSheet:Range("D3"):VALUE = "Pedidos".
chWorkSheet:Range("E3"):VALUE = "U.M".
chWorkSheet:Range("F3"):VALUE = "Stock Alm " + cb-almac.
chWorkSheet:Range("G3"):VALUE = "Cant.Solicitado".
chWorkSheet:Range("H3"):VALUE = "Cant.Atendido".
chWorkSheet:Range("I3"):VALUE = "Cant.Pendiente".

chWorkSheet:COLUMNS("A"):NumberFormat = "@".
t-column = 3.

FOR EACH TMP-TEMPO BREAK BY tmp-tempo.t-codfam BY tmp-tempo.t-codmat:
    
    IF FIRST-OF(tmp-tempo.t-codfam) THEN DO:
        t-column = t-column + 1.
        cColumn = STRING(t-Column).      
        cRange = "A" + cColumn.   
        chWorkSheet:Range(cRange):Value = 'FAMILIA: '.                      
        cRange = "B" + cColumn.                                                
        chWorkSheet:Range(cRange):Value = tmp-tempo.t-codfam.
    END.

    FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA AND
        Almmmate.CodAlm = tmp-tempo.t-CodAlm AND
        Almmmate.CodmAT = tmp-tempo.t-CodMat NO-LOCK NO-ERROR. 
    X-STOCK = 0.
    IF AVAILABLE Almmmate THEN X-STOCK = Almmmate.StkAct.
    
    ACCUM  t-totsol  (SUB-TOTAL BY t-codfam) .
    ACCUM  t-totdol  (SUB-TOTAL BY t-codfam) .

     t-column = t-column + 1.
     cColumn = STRING(t-Column).      
     cRange = "A" + cColumn.   
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-codmat.
     cRange = "B" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-Desmat.                      
     cRange = "C" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-Desmar.   
     cRange = "D" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-Glosa.                      
     cRange = "E" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-UndBas. 
     cRange = "F" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = X-Stock. 
     cRange = "G" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-solici.
     cRange = "H" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-atendi.
     cRange = "I" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-pendie.

     IF LAST-OF(tmp-tempo.t-codfam) THEN DO:
         t-column = t-column + 1.
         cColumn = STRING(t-Column).      
         cRange = "E" + cColumn.                                                
         chWorkSheet:Range(cRange):Value = 'TOTAL SOLES: '. 
         cRange = "F" + cColumn.                                                
         chWorkSheet:Range(cRange):Value = (ACCUM SUB-TOTAL BY t-codfam t-totsol).
         cRange = "H" + cColumn.                                                
         chWorkSheet:Range(cRange):Value = 'TOTAL DOLARES'.
         cRange = "I" + cColumn.                                                
         chWorkSheet:Range(cRange):Value = (ACCUM SUB-TOTAL BY t-codfam t-totdol).
     END.
END.

/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-Marca D-Dialog 
PROCEDURE Excel-Marca :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
W-TOTBRU    = 0. 
W-TOTDSC    = 0.
W-TOTVAL    = 0. 
W-TOTIGV    = 0.
W-TOTVEN    = 0.
X-PENDIENTE = 0.
X-STOCK     = 0.
F-FACTOR    = 0.

RUN CARGA-TEMPORAL-PROVE.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:Range("A1: K2"):FONT:Bold = TRUE.
chWorkSheet:Range("A1"):VALUE =
    "COTIZACIONES POR ATENDER OFICINA" +
    " DESDE " + STRING(f-desde) + " AL " + STRING(f-hasta).
chWorkSheet:Range("A3"):VALUE = "Código".
chWorkSheet:Range("B3"):VALUE = "Descripcion".
chWorkSheet:Range("C3"):VALUE = "Marca".
chWorkSheet:Range("D3"):VALUE = "Pedidos".
chWorkSheet:Range("E3"):VALUE = "U.M".
chWorkSheet:Range("F3"):VALUE = "Stock Alm " + cb-almac.
chWorkSheet:Range("G3"):VALUE = "Cant.Solicitado".
chWorkSheet:Range("H3"):VALUE = "Cant.Atendido".
chWorkSheet:Range("I3"):VALUE = "Cant.Pendiente".

chWorkSheet:COLUMNS("A"):NumberFormat = "@".
t-column = 3.

FOR EACH TMP-TEMPO BREAK BY tmp-tempo.t-desmar BY tmp-tempo.t-codmat:
    
    IF FIRST-OF(tmp-tempo.t-desmar) THEN DO:
        t-column = t-column + 1.
        cColumn = STRING(t-Column).      
        cRange = "A" + cColumn.   
        chWorkSheet:Range(cRange):Value = 'MARCA: '.                      
        cRange = "B" + cColumn.                                                
        chWorkSheet:Range(cRange):Value = tmp-tempo.t-desmar.
    END.

    FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA AND
        Almmmate.CodAlm = tmp-tempo.t-CodAlm AND
        Almmmate.CodmAT = tmp-tempo.t-CodMat NO-LOCK NO-ERROR. 
    X-STOCK = 0.
    IF AVAILABLE Almmmate Then X-STOCK = Almmmate.StkAct.

    ACCUM  t-totsol  (SUB-TOTAL BY t-desmar) .
    ACCUM  t-totdol  (SUB-TOTAL BY t-desmar) .

     t-column = t-column + 1.
     cColumn = STRING(t-Column).      
     cRange = "A" + cColumn.   
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-codmat.
     cRange = "B" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-Desmat.                      
     cRange = "C" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-Desmar.   
     cRange = "D" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-Glosa.                      
     cRange = "E" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-UndBas. 
     cRange = "F" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = X-Stock. 
     cRange = "G" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-solici.
     cRange = "H" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-atendi.
     cRange = "I" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-pendie.

     IF LAST-OF(tmp-tempo.t-desmar) THEN DO:
         t-column = t-column + 1.
         cColumn = STRING(t-Column).      
         cRange = "E" + cColumn.                                                
         chWorkSheet:Range(cRange):Value = 'TOTAL SOLES: '. 
         cRange = "F" + cColumn.                                                
         chWorkSheet:Range(cRange):Value = (ACCUM SUB-TOTAL BY t-desmar t-totsol).
         cRange = "H" + cColumn.                                                
         chWorkSheet:Range(cRange):Value = 'TOTAL DOLARES'.
         cRange = "I" + cColumn.                                                
         chWorkSheet:Range(cRange):Value = (ACCUM SUB-TOTAL BY t-desmar t-totdol).
     END.
END.


/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-prnofi D-Dialog 
PROCEDURE Excel-prnofi :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
W-TOTBRU    = 0. 
W-TOTDSC    = 0.
W-TOTVAL    = 0. 
W-TOTIGV    = 0.
W-TOTVEN    = 0.
X-PENDIENTE = 0.
X-STOCK     = 0.
F-FACTOR    = 0.

RUN CARGA-TEMPORAL.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).


chWorkSheet:Range("A1: K2"):FONT:Bold = TRUE.
chWorkSheet:Range("A1"):VALUE =
    "COTIZACIONES POR ATENDER OFICINA" +
    " DESDE " + STRING(f-desde) + " AL " + STRING(f-hasta).
chWorkSheet:Range("A3"):VALUE = "Código".
chWorkSheet:Range("B3"):VALUE = "Descripcion".
chWorkSheet:Range("C3"):VALUE = "Marca".
chWorkSheet:Range("D3"):VALUE = "Pedidos".
chWorkSheet:Range("E3"):VALUE = "U.M".
chWorkSheet:Range("F3"):VALUE = "Stock Alm " + cb-almac.
chWorkSheet:Range("G3"):VALUE = "Cant.Comprometido".
chWorkSheet:Range("H3"):VALUE = "Cant.Solicitado".
chWorkSheet:Range("I3"):VALUE = "Cant.Atendido".
chWorkSheet:Range("J3"):VALUE = "Cant.Pendiente".

chWorkSheet:COLUMNS("A"):NumberFormat = "@".
t-column = 3.

FOR EACH TMP-TEMPO BREAK BY tmp-tempo.t-codcli BY tmp-tempo.t-codmat:

    IF FIRST-OF(tmp-tempo.t-Codcli) THEN DO:
        t-column = t-column + 1.
        cColumn = STRING(t-Column).      
        cRange = "A" + cColumn.   
        chWorkSheet:Range(cRange):Value = 'CLIENTE: '.                      
        cRange = "B" + cColumn.                                                
        chWorkSheet:Range(cRange):Value = "'" + tmp-tempo.t-Codcli + "  " + tmp-tempo.t-NomCli.                      
    END.

     FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA AND
                         Almmmate.CodAlm = tmp-tempo.t-CodAlm AND
                         Almmmate.CodmAT = tmp-tempo.t-CodMat
                         NO-LOCK NO-ERROR. 
     X-STOCK = 0.
     If Available Almmmate Then X-STOCK = Almmmate.StkAct.
     ACCUM  t-totsol  (SUB-TOTAL BY t-codcli) .
     ACCUM  t-totdol  (SUB-TOTAL BY t-codcli) .

     t-column = t-column + 1.
     cColumn = STRING(t-Column).      
     cRange = "A" + cColumn.   
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-codmat.
     cRange = "B" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-Desmat.                      
     cRange = "C" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-Desmar.   
     cRange = "D" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-Glosa.                      
     cRange = "E" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-UndBas. 
     cRange = "F" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = X-Stock. 
     cRange = "G" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-compro.
     cRange = "H" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-solici.
     cRange = "I" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-atendi.
     cRange = "J" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-pendie.

     IF LAST-OF(tmp-tempo.t-CodCli) THEN DO:
         t-column = t-column + 1.
         cColumn = STRING(t-Column).      
         cRange = "F" + cColumn.                                                
         chWorkSheet:Range(cRange):Value = 'TOTAL SOLES: '. 
         cRange = "G" + cColumn.                                                
         chWorkSheet:Range(cRange):Value = (ACCUM SUB-TOTAL BY t-codcli t-totsol).
         cRange = "I" + cColumn.                                                
         chWorkSheet:Range(cRange):Value = 'TOTAL DOLARES'.
         cRange = "J" + cColumn.                                                
         chWorkSheet:Range(cRange):Value = (ACCUM SUB-TOTAL BY t-codcli t-totdol).
     END.
END.


/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-Proveedor D-Dialog 
PROCEDURE Excel-Proveedor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
W-TOTBRU    = 0. 
W-TOTDSC    = 0.
W-TOTVAL    = 0. 
W-TOTIGV    = 0.
W-TOTVEN    = 0.
X-PENDIENTE = 0.
X-STOCK     = 0.
F-FACTOR    = 0.

RUN CARGA-TEMPORAL-PROVE.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).


chWorkSheet:Range("A1: K2"):FONT:Bold = TRUE.
chWorkSheet:Range("A1"):VALUE =
    "COTIZACIONES POR ATENDER OFICINA" +
    " DESDE " + STRING(f-desde) + " AL " + STRING(f-hasta).
chWorkSheet:Range("A3"):VALUE = "Código".
chWorkSheet:Range("B3"):VALUE = "Descripcion".
chWorkSheet:Range("C3"):VALUE = "Marca".
chWorkSheet:Range("D3"):VALUE = "Pedidos".
chWorkSheet:Range("E3"):VALUE = "U.M".
chWorkSheet:Range("F3"):VALUE = "Stock Alm " + cb-almac.
chWorkSheet:Range("G3"):VALUE = "Cant.Solicitado".
chWorkSheet:Range("H3"):VALUE = "Cant.Atendido".
chWorkSheet:Range("I3"):VALUE = "Cant.Pendiente".

chWorkSheet:COLUMNS("A"):NumberFormat = "@".
t-column = 3.

FOR EACH TMP-TEMPO BREAK BY tmp-tempo.t-codpro BY tmp-tempo.t-codmat:
    IF FIRST-OF(tmp-tempo.t-Codpro) THEN DO:
        t-column = t-column + 1.
        cColumn = STRING(t-Column).      
        cRange = "A" + cColumn.   
        chWorkSheet:Range(cRange):Value = 'PROVEEDOR: '.                      
        cRange = "B" + cColumn.                                                
        chWorkSheet:Range(cRange):Value = "'" + tmp-tempo.t-Codpro + "  " + tmp-tempo.t-Nompro.
    END.

     FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA AND
                         Almmmate.CodAlm = tmp-tempo.t-CodAlm AND
                         Almmmate.CodmAT = tmp-tempo.t-CodMat
                         NO-LOCK NO-ERROR. 
     X-STOCK = 0.
     If Available Almmmate Then X-STOCK = Almmmate.StkAct.

     ACCUM  t-totsol  (SUB-TOTAL BY t-codpro) .
     ACCUM  t-totdol  (SUB-TOTAL BY t-codpro) .

     t-column = t-column + 1.
     cColumn = STRING(t-Column).      
     cRange = "A" + cColumn.   
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-codmat.
     cRange = "B" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-Desmat.                      
     cRange = "C" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-Desmar.   
     cRange = "D" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-Glosa.                      
     cRange = "E" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-UndBas. 
     cRange = "F" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = X-Stock. 
     cRange = "G" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-solici.
     cRange = "H" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-atendi.
     cRange = "I" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-pendie.

     IF LAST-OF(tmp-tempo.t-Codpro) THEN DO:
         t-column = t-column + 1.
         cColumn = STRING(t-Column).      
         cRange = "E" + cColumn.                                                
         chWorkSheet:Range(cRange):Value = 'TOTAL SOLES: '. 
         cRange = "F" + cColumn.                                                
         chWorkSheet:Range(cRange):Value = (ACCUM SUB-TOTAL BY t-codpro t-totsol).
         cRange = "H" + cColumn.                                                
         chWorkSheet:Range(cRange):Value = 'TOTAL DOLARES'.
         cRange = "I" + cColumn.                                                
         chWorkSheet:Range(cRange):Value = (ACCUM SUB-TOTAL BY t-codpro t-totdol).
     END.
END.


/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Familia D-Dialog 
PROCEDURE Familia :
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
 DEFINE VAR X-PENDIENTE AS DECIMAL INIT 0.   
 DEFINE VAR X-STOCK     AS DECIMAL INIT 0.   
 DEFINE VAR F-FACTOR    AS DECIMAL INIT 0.   
 
 RUN CARGA-TEMPORAL-PROVE.
 
 DEFINE FRAME f-cab
        tmp-tempo.t-codmat 
        tmp-tempo.t-DesMat FORMAT "X(35)"
        tmp-tempo.t-DesMar FORMAT "X(10)"
        tmp-tempo.t-glosa  FORMAT "X(30)"
        tmp-tempo.t-undbas FORMAT "X(4)"
        x-stock            FORMAT "->>>,>>9.99"
        tmp-tempo.t-solici FORMAT "->>>,>>9.99"
        tmp-tempo.t-atendi FORMAT "->>>,>>9.99"
        tmp-tempo.t-pendie FORMAT "->>>,>>9.99"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + S-CODDIV + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + "COTIZACIONES POR ATENDER OFICINA"  AT 43 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Emitidas Desde : " AT 50 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)" SKIP
        {&PRN2} + {&PRN6A} + "Pedidos Desde : " AT 50 FORMAT "X(10)" STRING(FILL-IN-FchPed-1,"99/99/9999") FORMAT "X(10)" "Al" STRING(FILL-IN-FchPed-2,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)" SKIP
        {&PRN2} + {&PRN6A} + "Entrega Desde : " AT 50 FORMAT "X(10)" STRING(F-entrega1,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-entrega2,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)" SKIP
        {&PRN3} + "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        T-VENDE AT 1 FORMAT "X(45)" T-CLIEN AT 60 FORMAT "X(20)" "Hora  : " AT 119 STRING(TIME,"HH:MM:SS") SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                                                 C    A    N    T    I    D    A    D   " SKIP
        " Codigos      Descripcion              Marca          Pedidos                         U.M.    Stock   Solicitado   Atendido  Pendiente  " 
        "----------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
 
    /*PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .*/

    FOR EACH TMP-TEMPO BREAK
                     BY tmp-tempo.t-codfam
                     BY tmp-tempo.t-codmat:

     /*{&new-page}.*/
     
     DISPLAY STREAM REPORT WITH FRAME F-CAB.
    

     IF FIRST-OF(tmp-tempo.t-codfam) THEN DO:
       PUT STREAM REPORT "FAMILIA: "  tmp-tempo.t-codfam SKIP.
       PUT STREAM REPORT '------------------------------------------' SKIP.
     END.

     FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA AND
                         Almmmate.CodAlm = tmp-tempo.t-CodAlm AND
                         Almmmate.CodmAT = tmp-tempo.t-CodMat
                         NO-LOCK NO-ERROR. 
     X-STOCK = 0.
     If Available Almmmate Then X-STOCK = Almmmate.StkAct.

     ACCUM  t-totsol  (SUB-TOTAL BY t-codfam) .
     ACCUM  t-totdol  (SUB-TOTAL BY t-codfam) .

     DISPLAY STREAM REPORT 
        tmp-tempo.t-codmat
        tmp-tempo.t-Desmat
        tmp-tempo.t-Desmar
        tmp-tempo.t-Glosa
        tmp-tempo.t-UndBas
        X-Stock 
        tmp-tempo.t-solici
        tmp-tempo.t-atendi
        tmp-tempo.t-pendie

        WITH FRAME F-Cab.
        
     IF LAST-OF(tmp-tempo.t-codfam) THEN DO:
       PUT STREAM REPORT ' ' SKIP.
       PUT STREAM REPORT  "TOTAL SOLES   : " AT 40. 
       PUT STREAM REPORT (ACCUM SUB-TOTAL BY t-codfam t-totsol) FORMAT '>>>,>>>,>>>,>>>.99' AT 60 .
       PUT STREAM REPORT  "TOTAL DOLARES : " AT 90. 
       PUT STREAM REPORT (ACCUM SUB-TOTAL BY t-codfam t-totdol) FORMAT '>>>,>>>,>>>,>>>.99' AT 110  SKIP.

     END.

 END.
 

/*
 CASE s-salida-impresion:
      WHEN 1 OR WHEN 3 THEN RUN LIB/d-README.R(s-print-file). 
 END CASE.                                             
 OUTPUT STREAM REPORT CLOSE.
*/ 

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
        FacCpedi.ImpDto FORMAT "->,>>>,>>9.99"
        FacCpedi.ImpVta FORMAT "->,>>>,>>9.99"
        FacCpedi.ImpIgv FORMAT "->,>>>,>>9.99"
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
         
         WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
 
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
          FacCpedi.Codcli BEGINS f-clien 
          
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime D-Dialog 
PROCEDURE Imprime :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.
/*
    CASE R-tipo:
        WHEN 1 THEN RUN CARGA-TEMPORAL.
        WHEN 2 THEN RUN CARGA-TEMPORAL-PROVEEDOR.
        WHEN 3 THEN RUN Carga-temporal-ubicacion.
    END.
*/
    
    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.        
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.        
        CASE R-tipo:
            WHEN 1 THEN RUN prn-ofi.
            WHEN 2 THEN RUN proveedor.
            WHEN 3 THEN RUN marca.
            WHEN 4 THEN RUN familia.
        END.
        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            FRAME {&FRAME-NAME}:SENSITIVE = FALSE.
            RUN LIB/W-README.R(s-print-file).
            FRAME {&FRAME-NAME}:SENSITIVE = TRUE.
            IF s-salida-impresion = 1 THEN
                OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

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
 CASE R-tipo:
   WHEN 1 THEN RUN prn-ofi.
   WHEN 2 THEN RUN proveedor.
   WHEN 3 THEN RUN marca.
   WHEN 4 THEN RUN familia.
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  FIND FIRST almacen WHERE almacen.codcia = s-codcia
    AND almacen.codalm = cb-almac:SCREEN-VALUE IN FRAME {&FRAME-NAME} 
      NO-LOCK NO-ERROR.
  IF AVAIL almacen THEN 
      DISPLAY almacen.descripcion @ txt-desalm
          WITH FRAME {&FRAME-NAME}.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Marca D-Dialog 
PROCEDURE Marca :
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
 DEFINE VAR X-PENDIENTE AS DECIMAL INIT 0.   
 DEFINE VAR X-STOCK     AS DECIMAL INIT 0.   
 DEFINE VAR F-FACTOR    AS DECIMAL INIT 0.   
 
 RUN CARGA-TEMPORAL-PROVE.
 
 DEFINE FRAME f-cab
        tmp-tempo.t-codmat 
        tmp-tempo.t-DesMat FORMAT "X(35)"
        tmp-tempo.t-DesMar FORMAT "X(10)"
        tmp-tempo.t-glosa  FORMAT "X(30)"
        tmp-tempo.t-undbas FORMAT "X(4)"
        x-stock            FORMAT "->>>,>>9.99"
        tmp-tempo.t-solici FORMAT "->>>,>>9.99"
        tmp-tempo.t-atendi FORMAT "->>>,>>9.99"
        tmp-tempo.t-pendie FORMAT "->>>,>>9.99"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + S-CODDIV + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + "COTIZACIONES POR ATENDER OFICINA"  AT 43 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Emitidas Desde : " AT 50 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)" SKIP
        {&PRN2} + {&PRN6A} + "Pedidos Desde : " AT 50 FORMAT "X(10)" STRING(FILL-IN-FchPed-1,"99/99/9999") FORMAT "X(10)" "Al" STRING(FILL-IN-FchPed-2,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)" SKIP
        {&PRN2} + {&PRN6A} + "Entrega Desde : " AT 50 FORMAT "X(10)" STRING(F-entrega1,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-entrega2,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)" SKIP
        {&PRN3} + "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        T-VENDE AT 1 FORMAT "X(45)" T-CLIEN AT 60 FORMAT "X(20)" "Hora  : " AT 119 STRING(TIME,"HH:MM:SS") SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                                                 C    A    N    T    I    D    A    D   " SKIP
        " Codigos      Descripcion              Marca          Pedidos                         U.M.    Stock   Solicitado   Atendido  Pendiente  " 
        "----------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
 
    /*PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .*/

    FOR EACH TMP-TEMPO BREAK
                     BY tmp-tempo.t-desmar
                     BY tmp-tempo.t-codmat:

    /* {&new-page}.*/
     
     DISPLAY STREAM REPORT WITH FRAME F-CAB.
    

     IF FIRST-OF(tmp-tempo.t-desmar) THEN DO:
       PUT STREAM REPORT "MARCA  : "  tmp-tempo.t-desmar SKIP.
       PUT STREAM REPORT '------------------------------------------' SKIP.
     END.

     FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA AND
                         Almmmate.CodAlm = tmp-tempo.t-CodAlm AND
                         Almmmate.CodmAT = tmp-tempo.t-CodMat
                         NO-LOCK NO-ERROR. 
     X-STOCK = 0.
     If Available Almmmate Then X-STOCK = Almmmate.StkAct.

     ACCUM  t-totsol  (SUB-TOTAL BY t-desmar) .
     ACCUM  t-totdol  (SUB-TOTAL BY t-desmar) .

     DISPLAY STREAM REPORT 
        tmp-tempo.t-codmat
        tmp-tempo.t-Desmat
        tmp-tempo.t-Desmar
        tmp-tempo.t-Glosa
        tmp-tempo.t-UndBas
        X-Stock 
        tmp-tempo.t-solici
        tmp-tempo.t-atendi
        tmp-tempo.t-pendie

        WITH FRAME F-Cab.
        
     IF LAST-OF(tmp-tempo.t-desmar) THEN DO:
       PUT STREAM REPORT ' ' SKIP.
       PUT STREAM REPORT  "TOTAL SOLES   : " AT 40. 
       PUT STREAM REPORT (ACCUM SUB-TOTAL BY t-desmar t-totsol) FORMAT '>>>,>>>,>>>,>>>.99' AT 60 .
       PUT STREAM REPORT  "TOTAL DOLARES : " AT 90. 
       PUT STREAM REPORT (ACCUM SUB-TOTAL BY t-desmar t-totdol) FORMAT '>>>,>>>,>>>,>>>.99' AT 110  SKIP.

     END.

 END.
 
/*

 CASE s-salida-impresion:
      WHEN 1 OR WHEN 3 THEN RUN LIB/d-README.R(s-print-file). 
 END CASE.                                             
 OUTPUT STREAM REPORT CLOSE.
*/ 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prn-ofi D-Dialog 
PROCEDURE prn-ofi :
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
 DEFINE VAR X-PENDIENTE AS DECIMAL INIT 0.   
 DEFINE VAR X-STOCK     AS DECIMAL INIT 0.   
 DEFINE VAR F-FACTOR    AS DECIMAL INIT 0.   
 
 RUN CARGA-TEMPORAL.
 
 DEFINE FRAME f-cab
        tmp-tempo.t-codmat 
        tmp-tempo.t-DesMat FORMAT "X(35)"
        tmp-tempo.t-DesMar FORMAT "X(10)"
        tmp-tempo.t-glosa  FORMAT "X(20)"
        tmp-tempo.t-undbas FORMAT "X(4)"
        x-stock            FORMAT "->>>,>>9.99"
        tmp-tempo.t-compro FORMAT "->>>,>>9.99"
        tmp-tempo.t-solici FORMAT ">>>,>>9.99"
        tmp-tempo.t-atendi FORMAT ">>>,>>9.99"
        tmp-tempo.t-pendie FORMAT "->>>,>>9.99"
        HEADER
        S-NOMCIA FORMAT "X(45)" SKIP
        "( " + S-CODDIV + ")" AT 1 FORMAT "X(15)"
        "COTIZACIONES POR ATENDER OFICINA"  AT 43 FORMAT "X(35)"
        "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "Emitidas Desde : " AT 50 FORMAT "X(20)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") FORMAT "X(12)" SKIP
        "Pedidos  Desde : "  AT 50 FORMAT "X(20)" STRING(FILL-IN-FchPed-1,"99/99/9999") FORMAT "X(10)" "Al" STRING(FILL-IN-FchPed-2,"99/99/9999") FORMAT "X(12)" SKIP
        "Entrega  Desde : "  AT 50 FORMAT "X(20)" STRING(F-entrega1,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-entrega2,"99/99/9999") FORMAT "X(12)" SKIP
        "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" 
        T-VENDE AT 1 FORMAT "X(45)" T-CLIEN AT 60 FORMAT "X(20)" "Hora  : " AT 119 STRING(TIME,"HH:MM:SS") SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                                             C    A    N    T    I    D    A    D      " SKIP
        " Codigos      Descripcion              Marca          Pedidos                  U.M.    Stock Comprometido Solicitado Atendido Pendiente" 
        "---------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*                1         2         3         4         5         6         7         8         9        10        11        12        13        14
         1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
         123456 12345678980123456789801234567898012345 1234567890 12345678901234567890 1234 ->>,>>9.99 ->>,>>9.99 >>,>>9.99 >>,>>9.99 ->>,>>9.99 
*/         
         WITH WIDTH 160 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
 
/*    PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .*/

    FOR EACH TMP-TEMPO BREAK
                     BY tmp-tempo.t-codcli
                     BY tmp-tempo.t-codmat:

     /*{&new-page}.*/
     
     DISPLAY STREAM REPORT WITH FRAME F-CAB.
    

     IF FIRST-OF(tmp-tempo.t-Codcli) THEN DO:
       PUT STREAM REPORT "CLIENTE  : "  tmp-tempo.t-Codcli  "  " tmp-tempo.t-NomCli SKIP.
       PUT STREAM REPORT '------------------------------------------' SKIP.
     END.
     MESSAGE tmp-tempo.t-CodAlm.
     FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA AND
                         Almmmate.CodAlm = tmp-tempo.t-CodAlm AND
                         Almmmate.CodmAT = tmp-tempo.t-CodMat
                         NO-LOCK NO-ERROR. 
     X-STOCK = 0.
     If Available Almmmate Then X-STOCK = Almmmate.StkAct.

     ACCUM  t-totsol  (SUB-TOTAL BY t-codcli) .
     ACCUM  t-totdol  (SUB-TOTAL BY t-codcli) .

     DISPLAY STREAM REPORT 
        tmp-tempo.t-codmat
        tmp-tempo.t-Desmat
        tmp-tempo.t-Desmar
        tmp-tempo.t-Glosa
        tmp-tempo.t-UndBas
        X-Stock 
        tmp-tempo.t-solici
        tmp-tempo.t-compro
        tmp-tempo.t-atendi
        tmp-tempo.t-pendie

        WITH FRAME F-Cab.
        
     IF LAST-OF(tmp-tempo.t-CodCli) THEN DO:
       PUT STREAM REPORT ' ' SKIP.
       PUT STREAM REPORT  "TOTAL SOLES   : " AT 40. 
       PUT STREAM REPORT (ACCUM SUB-TOTAL BY t-codcli t-totsol) FORMAT '>>>,>>>,>>>,>>>.99' AT 60 .
       PUT STREAM REPORT  "TOTAL DOLARES : " AT 90. 
       PUT STREAM REPORT (ACCUM SUB-TOTAL BY t-codcli t-totdol) FORMAT '>>>,>>>,>>>,>>>.99' AT 110  SKIP.
     END.
END.
 
/*

 CASE s-salida-impresion:
      WHEN 1 OR WHEN 3 THEN RUN LIB/d-README.R(s-print-file). 
 END CASE.                                             
 OUTPUT STREAM REPORT CLOSE.
*/

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Proveedor D-Dialog 
PROCEDURE Proveedor :
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
 DEFINE VAR X-PENDIENTE AS DECIMAL INIT 0.   
 DEFINE VAR X-STOCK     AS DECIMAL INIT 0.   
 DEFINE VAR F-FACTOR    AS DECIMAL INIT 0.   
 
 RUN CARGA-TEMPORAL-PROVE.
 
 DEFINE FRAME f-cab
        tmp-tempo.t-codmat 
        tmp-tempo.t-DesMat FORMAT "X(35)"
        tmp-tempo.t-DesMar FORMAT "X(10)"
        tmp-tempo.t-glosa  FORMAT "X(30)"
        tmp-tempo.t-undbas FORMAT "X(4)"
        x-stock            FORMAT "->>>,>>9.99"
        tmp-tempo.t-solici FORMAT "->>>,>>9.99"
        tmp-tempo.t-atendi FORMAT "->>>,>>9.99"
        tmp-tempo.t-pendie FORMAT "->>>,>>9.99"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + S-CODDIV + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + "COTIZACIONES POR ATENDER OFICINA"  AT 43 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Emitidas Desde : " AT 50 FORMAT "X(20)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)" SKIP
        {&PRN2} + {&PRN6A} + "Pedidos  Desde : " AT 50 FORMAT "X(20)" STRING(FILL-IN-FchPed-1,"99/99/9999") FORMAT "X(10)" "Al" STRING(FILL-IN-FchPed-2,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)" SKIP
        {&PRN2} + {&PRN6A} + "Entrega  Desde : " AT 50 FORMAT "X(20)" STRING(F-entrega1,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-entrega2,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)" SKIP
        {&PRN3} + "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        T-VENDE AT 1 FORMAT "X(45)" T-CLIEN AT 60 FORMAT "X(20)" "Hora  : " AT 119 STRING(TIME,"HH:MM:SS") SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                                                 C    A    N    T    I    D    A    D   " SKIP
        " Codigos      Descripcion              Marca          Pedidos                         U.M.    Stock   Solicitado   Atendido  Pendiente  " 
        "----------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
 
    /*PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .*/

    FOR EACH TMP-TEMPO BREAK
                     BY tmp-tempo.t-codpro
                     BY tmp-tempo.t-codmat:

     /*{&new-page}.*/
     
     DISPLAY STREAM REPORT WITH FRAME F-CAB.

     IF FIRST-OF(tmp-tempo.t-Codpro) THEN DO:
       PUT STREAM REPORT "PROVEEDOR  : "  tmp-tempo.t-Codpro  "  " tmp-tempo.t-Nompro SKIP.
       PUT STREAM REPORT '------------------------------------------' SKIP.
     END.

     FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA AND
                         Almmmate.CodAlm = tmp-tempo.t-CodAlm AND
                         Almmmate.CodmAT = tmp-tempo.t-CodMat
                         NO-LOCK NO-ERROR. 
     X-STOCK = 0.
     If Available Almmmate Then X-STOCK = Almmmate.StkAct.

     ACCUM  t-totsol  (SUB-TOTAL BY t-codpro) .
     ACCUM  t-totdol  (SUB-TOTAL BY t-codpro) .

     DISPLAY STREAM REPORT 
        tmp-tempo.t-codmat
        tmp-tempo.t-Desmat
        tmp-tempo.t-Desmar
        tmp-tempo.t-Glosa
        tmp-tempo.t-UndBas
        X-Stock 
        tmp-tempo.t-solici
        tmp-tempo.t-atendi
        tmp-tempo.t-pendie

        WITH FRAME F-Cab.
        
     IF LAST-OF(tmp-tempo.t-Codpro) THEN DO:
       PUT STREAM REPORT ' ' SKIP.
       PUT STREAM REPORT  "TOTAL SOLES   : " AT 40. 
       PUT STREAM REPORT (ACCUM SUB-TOTAL BY t-codpro t-totsol) FORMAT '>>>,>>>,>>>,>>>.99' AT 60 .
       PUT STREAM REPORT  "TOTAL DOLARES : " AT 90. 
       PUT STREAM REPORT (ACCUM SUB-TOTAL BY t-codpro t-totdol) FORMAT '>>>,>>>,>>>,>>>.99' AT 110  SKIP.
     END.

 END.
 
/*
 CASE s-salida-impresion:
      WHEN 1 OR WHEN 3 THEN RUN LIB/d-README.R(s-print-file). 
 END CASE.                                             
 OUTPUT STREAM REPORT CLOSE.
*/ 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Stock-Comprometid D-Dialog 
PROCEDURE Stock-Comprometid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAMETER s-CodMat AS CHAR.
  DEF OUTPUT PARAMETER x-CanPed AS DEC.

FOR EACH FacDPedi WHERE FacDPedi.CodCia = s-codcia 
                   AND  FacDPedi.almdes = s-codalm
                   AND  FacDPedi.codmat = s-codmat 
                   AND  LOOKUP(FacDPedi.CodDoc,'PED') > 0 
                   AND  LOOKUP(FacDPedi.FlgEst, 'P,X,') > 0:
    FIND FIRST FacCPedi OF FacDPedi WHERE FacCPedi.codcia = FacDPedi.CodCia
                                     AND  FacCPedi.CodAlm = FacDPedi.almdes
                                     AND  Faccpedi.FlgEst = "P"
                                     AND  Faccpedi.TpoPed = "1"
                                    NO-LOCK NO-ERROR.
    IF NOT AVAIL Faccpedi THEN NEXT.
    x-CanPed = x-CanPed + FacDPedi.Factor * (FacDPedi.CanPed - FacDPedi.canate ).    
END.

/*********   Barremos las O/D que son parciales y totales    ****************/
FOR EACH FacDPedi WHERE FacDPedi.CodCia = s-codcia
                   AND  FacDPedi.almdes = s-codalm
                   AND  FacDPedi.codmat = s-codmat 
                   AND  LOOKUP(FacDPedi.CodDoc,'O/D') > 0 
                   AND  LOOKUP(FacDPedi.FlgEst, 'P,X,') > 0:
    FIND FIRST FacCPedi OF FacDPedi WHERE FacCPedi.codcia = FacDPedi.CodCia
                                     AND  FacCPedi.CodAlm = s-codalm 
                                     AND  Faccpedi.FlgEst = "P"
                                    NO-LOCK NO-ERROR.
    IF NOT AVAIL FacCPedi THEN NEXT.
    x-CanPed = x-CanPed + FacDPedi.Factor * (FacDPedi.CanPed - FacDPedi.canate ).
END.

/*******************************************************/

/* Segundo barremos los pedidos de mostrador de acuerdo a la vigencia */
DEF VAR TimeOut AS INTEGER NO-UNDO.
DEF VAR TimeNow AS INTEGER NO-UNDO.
FIND FacCfgGn WHERE faccfggn.codcia = s-codcia NO-LOCK.
TimeOut = (FacCfgGn.Dias-Res * 24 * 3600) +
          (FacCfgGn.Hora-Res * 3600) + 
          (FacCfgGn.Minu-Res * 60).
FOR EACH Facdpedm WHERE Facdpedm.CodCia = s-codcia 
                   AND  Facdpedm.AlmDes = S-CODALM
                   AND  Facdpedm.codmat = s-codmat 
                   AND  Facdpedm.FlgEst = "P" :
    FIND FIRST Faccpedm OF Facdpedm WHERE Faccpedm.CodCia = Facdpedm.CodCia 
                                     AND  Faccpedm.CodAlm = s-codalm 
                                     AND  Faccpedm.FlgEst = "P"  
                                    NO-LOCK NO-ERROR. 
    IF NOT AVAIL Faccpedm THEN NEXT.
    
    TimeNow = (TODAY - FacCPedm.FchPed) * 24 * 3600.
    TimeNow = TimeNow + TIME - ( (INTEGER(SUBSTRING(FacCPedm.Hora, 1, 2)) * 3600) +
              (INTEGER(SUBSTRING(FacCPedm.Hora, 4, 2)) * 60) ).
    IF TimeOut > 0 THEN DO:
        IF TimeNow <= TimeOut   /* Dentro de la valides */
        THEN DO:
            /* cantidad en reservacion */
            x-CanPed = x-CanPed + FacDPedm.Factor * FacDPedm.CanPed.
        END.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Stock-Comprometido D-Dialog 
PROCEDURE Stock-Comprometido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAMETER s-CodMat AS CHAR.
  DEF OUTPUT PARAMETER x-CanPed AS DEC.

  DEF VAR x-PedCon AS DEC INIT 0 NO-UNDO.
  
        /****/
        FOR EACH FacDPedi NO-LOCK WHERE FacDPedi.CodCia = s-codcia 
                           AND  FacDPedi.almdes = s-codalm
                           AND  FacDPedi.codmat = s-codmat 
                           AND  LOOKUP(FacDPedi.CodDoc,'PED') > 0 
                           AND  LOOKUP(FacDPedi.FlgEst, 'P,X,') > 0:
            FIND FIRST FacCPedi OF FacDPedi WHERE FacCPedi.codcia = FacDPedi.CodCia
                                             AND  FacCPedi.CodAlm = FacDPedi.almdes
                                             AND  Faccpedi.FlgEst = "P"
                                             AND  Faccpedi.TpoPed = "1"
                                            NO-LOCK NO-ERROR.
            IF NOT AVAIL Faccpedi THEN NEXT.
        
            X-CanPed = X-CanPed + FacDPedi.Factor * (FacDPedi.CanPed - FacDPedi.canate ).
        END.
        
        /*********   Barremos las O/D que son parciales y totales    ****************/
        FOR EACH FacDPedi NO-LOCK WHERE FacDPedi.CodCia = s-codcia
                           AND  FacDPedi.almdes = s-codalm
                           AND  FacDPedi.codmat = s-codmat 
                           AND  LOOKUP(FacDPedi.CodDoc,'O/D') > 0 
                           AND  LOOKUP(FacDPedi.FlgEst, 'P,X,') > 0:
            FIND FIRST FacCPedi OF FacDPedi WHERE FacCPedi.codcia = FacDPedi.CodCia
                                             AND  FacCPedi.CodAlm = s-codalm 
                                             AND  Faccpedi.FlgEst = "P"
                                            NO-LOCK NO-ERROR.
            IF NOT AVAIL FacCPedi THEN NEXT.
            X-CanPed = X-CanPed + FacDPedi.Factor * (FacDPedi.CanPed - FacDPedi.canate ).
        END.
        
        /*******************************************************/
        
        /* Segundo barremos los pedidos de mostrador de acuerdo a la vigencia */
        DEF VAR TimeOut AS INTEGER NO-UNDO.
        DEF VAR TimeNow AS INTEGER NO-UNDO.
        FIND FacCfgGn WHERE faccfggn.codcia = s-codcia NO-LOCK.
        TimeOut = (FacCfgGn.Dias-Res * 24 * 3600) +
                  (FacCfgGn.Hora-Res * 3600) + 
                  (FacCfgGn.Minu-Res * 60).
        FOR EACH Facdpedm NO-LOCK WHERE Facdpedm.CodCia = s-codcia 
                           AND  Facdpedm.AlmDes = S-CODALM
                           AND  Facdpedm.codmat = s-codmat 
                           AND  Facdpedm.FlgEst = "P" :
            FIND FIRST Faccpedm OF Facdpedm WHERE Faccpedm.CodCia = Facdpedm.CodCia 
                                             AND  Faccpedm.CodAlm = s-codalm 
                                             AND  Faccpedm.FlgEst = "P"  
                                            NO-LOCK NO-ERROR. 
            IF NOT AVAIL Faccpedm THEN NEXT.
            
            TimeNow = (TODAY - FacCPedm.FchPed) * 24 * 3600.
            TimeNow = TimeNow + TIME - ( (INTEGER(SUBSTRING(FacCPedm.Hora, 1, 2)) * 3600) +
                      (INTEGER(SUBSTRING(FacCPedm.Hora, 4, 2)) * 60) ).
            IF TimeOut > 0 THEN DO:
                IF TimeNow <= TimeOut   /* Dentro de la valides */
                THEN DO:
                    /* cantidad en reservacion */
                    X-CanPed = X-CanPed + FacDPedm.Factor * FacDPedm.CanPed.
                END.
            END.
        END.
        X-PedCon = X-CanPed.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

