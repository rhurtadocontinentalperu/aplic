&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
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

DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR PV-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.

DEFINE VAR RUTA AS CHAR NO-UNDO.
GET-KEY-VALUE SECTION "STARTUP" KEY "BASE" VALUE RUTA.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
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


/* Local Variable Definitions ---                                       */

DEFINE VAR t-soles AS decimal.
DEFINE VAR t-dolar AS decimal.
DEF VAR I-NroItm AS INTEGER.
DEF VAR TITU AS CHAR.
DEF VAR TITU2 AS CHAR.
DEF VAR X-NOMBRE AS CHAR.
DEF VAR X-MONEDA AS CHAR.
DEFINE VAR X-SOL AS decimal.
DEFINE VAR X-DOL AS decimal.
DEF VAR X-CONDI AS CHAR.
DEF VAR x-situacion AS CHAR INIT "G,P,A,T,V".
DEF VAR F-sitdoc    AS CHAR INIT "".

DEF TEMP-TABLE T-COCMP LIKE LG-COCMP.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-59 RECT-58 fechaD fechaH x-proveedor ~
CB-FlgSit COMBO-BOX-ModAdq F-Almacen f-CndCmp tg-detalle x-CodMaq ~
x-Userid-com Btn_OK Btn_OK-2 Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS fechaD fechaH x-proveedor x-nompro ~
CB-FlgSit COMBO-BOX-ModAdq F-Almacen F-DirEnt f-CndCmp tg-detalle x-CodMaq ~
x-Userid-com 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 12 BY 1.46
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.42
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK-2 AUTO-GO 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.42
     BGCOLOR 8 .

DEFINE VARIABLE CB-FlgSit AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Situacion" 
     VIEW-AS COMBO-BOX INNER-LINES 7
     LIST-ITEMS "Todos","Emitidos","Pendientes","Aten.Total","Anulados","Vencidas","Atencion Parcial","En Revision" 
     DROP-DOWN-LIST
     SIZE 15 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE COMBO-BOX-ModAdq AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Modalidad" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE F-Almacen AS CHARACTER FORMAT "XXX":U 
     LABEL "Alm. Despacho" 
     VIEW-AS FILL-IN 
     SIZE 5.29 BY .81 NO-UNDO.

DEFINE VARIABLE f-CndCmp AS CHARACTER FORMAT "X(10)":U 
     LABEL "Forma de Pago" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE F-DirEnt AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38.14 BY .81 NO-UNDO.

DEFINE VARIABLE fechaD AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10.86 BY .81 NO-UNDO.

DEFINE VARIABLE fechaH AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE x-CodMaq AS CHARACTER FORMAT "X(4)":U 
     LABEL "Maquina" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-nompro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31.14 BY .81 NO-UNDO.

DEFINE VARIABLE x-proveedor AS CHARACTER FORMAT "X(256)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 12.14 BY .81 NO-UNDO.

DEFINE VARIABLE x-Userid-com AS CHARACTER FORMAT "X(10)":U 
     LABEL "Usuario" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-58
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 61 BY 8.69.

DEFINE RECTANGLE RECT-59
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 61 BY 2.12.

DEFINE VARIABLE tg-detalle AS LOGICAL INITIAL no 
     LABEL "Detallado para Excel" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     fechaD AT ROW 1.77 COL 13 COLON-ALIGNED
     fechaH AT ROW 1.77 COL 30 COLON-ALIGNED
     x-proveedor AT ROW 2.73 COL 13 COLON-ALIGNED
     x-nompro AT ROW 2.73 COL 26 COLON-ALIGNED NO-LABEL
     CB-FlgSit AT ROW 3.69 COL 13 COLON-ALIGNED
     COMBO-BOX-ModAdq AT ROW 4.65 COL 13 COLON-ALIGNED
     F-Almacen AT ROW 5.62 COL 13 COLON-ALIGNED
     F-DirEnt AT ROW 5.62 COL 19 COLON-ALIGNED NO-LABEL
     f-CndCmp AT ROW 6.58 COL 13 COLON-ALIGNED
     tg-detalle AT ROW 6.65 COL 38 WIDGET-ID 4
     x-CodMaq AT ROW 7.54 COL 13 COLON-ALIGNED
     x-Userid-com AT ROW 8.5 COL 13 COLON-ALIGNED WIDGET-ID 6
     Btn_OK AT ROW 10.23 COL 10
     Btn_OK-2 AT ROW 10.23 COL 23 WIDGET-ID 2
     Btn_Cancel AT ROW 10.23 COL 36
     RECT-59 AT ROW 9.85 COL 2
     RECT-58 AT ROW 1.15 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 1
         SIZE 63.86 BY 11.15
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Ordenes de Compra"
         HEIGHT             = 11.15
         WIDTH              = 64
         MAX-HEIGHT         = 21.27
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 21.27
         VIRTUAL-WIDTH      = 114.29
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT W-Win:LOAD-ICON("img\climnu3":U) THEN
    MESSAGE "Unable to load icon: img\climnu3"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME UNDERLINE L-To-R                                          */
/* SETTINGS FOR FILL-IN F-DirEnt IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-nompro IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Ordenes de Compra */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Ordenes de Compra */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel W-Win
ON CHOOSE OF Btn_Cancel IN FRAME F-Main /* Cancelar */
DO:
  RUN dispatch IN THIS-PROCEDURE ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:
  RUN Asigna-Variables.
  RUN Inhabilita.
  RUN Imprime.
  RUN Habilita.
  RUN Inicializa-Variables.
  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK-2 W-Win
ON CHOOSE OF Btn_OK-2 IN FRAME F-Main /* Aceptar */
DO:
  RUN Asigna-Variables.
  RUN Inhabilita.
  IF NOT tg-detalle THEN RUN Excel.
  ELSE RUN Excel-Detalle.
  RUN Habilita.
  RUN Inicializa-Variables.
  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CB-FlgSit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CB-FlgSit W-Win
ON VALUE-CHANGED OF CB-FlgSit IN FRAME F-Main /* Situacion */
DO:
   ASSIGN CB-FlgSit.
   x-situacion = (ENTRY(LOOKUP(CB-FlgSit,CB-FlgSit:LIST-ITEMS)," ,G,P,T,A,V,X,R")).
   if x-situacion = "" THEN x-situacion = "G,P,T,A,V,R".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Almacen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Almacen W-Win
ON LEAVE OF F-Almacen IN FRAME F-Main /* Alm. Despacho */
DO:
  Assign F-Almacen.
  IF F-Almacen = "" THEN DO:
     F-DirEnt:SCREEN-VALUE = "".
     RETURN.
  END.
  FIND Almacen WHERE Almacen.CodCia = S-CODCIA  AND
                     Almacen.CodAlm = F-Almacen NO-LOCK NO-ERROR.
  IF AVAILABLE Almacen THEN
     DISPLAY Almacen.DirAlm @ F-DirEnt .
  ELSE DO:       
       MESSAGE "Almacen no Registrado" VIEW-AS ALERT-BOX.
       RETURN NO-APPLY.
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-proveedor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-proveedor W-Win
ON LEAVE OF x-proveedor IN FRAME F-Main /* Proveedor */
DO:
  IF x-proveedor:screen-value = "" THEN DO:
     X-NOMPRO:SCREEN-VALUE = "".
     RETURN.
  END.
  FIND GN-PROV WHERE GN-PROV.CODCIA = PV-CODCIA AND
                GN-PROV.CODPRO = x-proveedor:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE GN-PROV THEN DO:
    MESSAGE "Codigo de proveedor no existe" VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY":U TO x-proveedor.
    RETURN NO-APPLY.
  END.  
  X-NOMPRO:SCREEN-VALUE = GN-PROV.NOMPRO.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
{src/adm/template/cntnrwin.i}

/* Include custom  Main Block code for SmartWindows. */

{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Variables W-Win 
PROCEDURE Asigna-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
  Assign fechaD fechaH x-proveedor x-nompro F-Almacen COMBO-BOX-ModAdq f-CndCmp
    x-CodMaq tg-detalle x-Userid-com.
  Titu2 = "Del " + STRING(FechaD,"99/99/9999") + " Al " + STRING(FechaH,"99/99/9999").   
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-ImpTot  AS DEC NO-UNDO.
  DEF VAR x-CanAten AS DEC NO-UNDO.
  
  EMPTY TEMP-TABLE T-COCMP.

  ORDENES:
  FOR EACH LG-COCMP WHERE LG-COCMP.codcia = s-codcia 
      /*AND LG-COCMP.CodDiv = s-coddiv*/
      AND LG-COCMP.CodDiv = "00000"
      AND LG-COCMP.Fchdoc >= fechad 
      AND LG-COCMP.fchdoc <= fechah 
      AND (x-proveedor = '' OR LG-COCMP.codpro BEGINS x-proveedor)
      AND (F-Almacen = '' OR LG-COCMP.CodAlm BEGINS F-Almacen)
      AND (f-CndCmp = '' OR LG-COCMP.CndCmp BEGINS f-CndCmp)
      AND (x-CodMaq = '' OR LG-COCMP.CodMaq BEGINS x-CodMaq)
      AND (x-Userid-com = "" OR LG-COCmp.Userid-com BEGINS x-Userid-com)
      NO-LOCK:
    IF COMBO-BOX-ModAdq <> 'Todos' AND LG-COCMP.modadq <> COMBO-BOX-ModAdq THEN NEXT.
    IF x-Situacion <> 'X' AND LOOKUP(LG-COCMP.flgsit,x-situacion) = 0 THEN NEXT.
    IF x-Situacion = 'X'  AND LG-COCMP.FlgSit <> 'P' THEN NEXT.
    ASSIGN
        x-CanAten = 0
        x-ImpTot  = 0.

    /*** RDP - Muestra Importe Total***
    FOR EACH LG-DOCMP OF LG-COCMP NO-LOCK:
        x-CanAten = x-CanAten + LG-DOCMP.CanAten.
        x-ImpTot = x-ImpTot + ROUND((LG-DOCMP.CanPedi - LG-DOCMP.CanAten) * ROUND(LG-DOCMP.PreUni * 
                            (1 - (LG-DOCMP.Dsctos[1] / 100)) *
                            (1 - (LG-DOCMP.Dsctos[2] / 100)) *
                            (1 - (LG-DOCMP.Dsctos[3] / 100)) *
                            (1 + (LG-DOCMP.IgvMat / 100)) , 4),2).
    END.
    
    IF x-Situacion = 'X' AND x-CanAten = 0  THEN NEXT.
    IF x-Situacion = 'P' AND x-CanAten <> 0 THEN NEXT.
    
    ******************************************/
    DISPLAY Lg-Cocmp.Nrodoc @ Fi-Mensaje LABEL "Orden De Compra "
            FORMAT "X(11)" 
            WITH FRAME F-Proceso.    

    /****
    CREATE T-COCMP.
    RAW-TRANSFER LG-COCMP TO T-COCMP.
    IF T-COCMP.FlgSit = 'P' AND x-CanAten <> 0
    THEN ASSIGN
            T-COCMP.FlgSit = 'X'
            T-COCMP.ImpTot = x-ImpTot.
    *********/

    CREATE T-COCMP.
    BUFFER-COPY LG-COCMP TO T-COCMP.
    /***RDP - Muestra Importes Totales***
    IF T-COCMP.FlgSit = 'P' AND x-CanAten <> 0
    THEN ASSIGN
            T-COCMP.FlgSit = 'X'
            T-COCMP.ImpTot = x-ImpTot.
    *********/        
  END.
  HIDE FRAME F-PROCESO.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win  _DEFAULT-ENABLE
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
  DISPLAY fechaD fechaH x-proveedor x-nompro CB-FlgSit COMBO-BOX-ModAdq 
          F-Almacen F-DirEnt f-CndCmp tg-detalle x-CodMaq x-Userid-com 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-59 RECT-58 fechaD fechaH x-proveedor CB-FlgSit COMBO-BOX-ModAdq 
         F-Almacen f-CndCmp tg-detalle x-CodMaq x-Userid-com Btn_OK Btn_OK-2 
         Btn_Cancel 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel W-Win 
PROCEDURE Excel :
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
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE cFila1 AS CHAR FORMAT 'X' INIT ''.
DEFINE VARIABLE cFila2 AS CHAR FORMAT 'X' INIT ''.

DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE t-Row                   AS INTEGER INIT 2.

RUN Carga-Temporal.

DEF VAR x-TITU3 AS CHAR FORMAT 'x(50)'.
DEF VAR x-TITU4 AS CHAR FORMAT 'x(50)'.
DEF VAR x-NomMaq AS CHAR FORMAT 'x(20)'.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:Range("D1"):VALUE = "RELACIONES DE ORDENDES DE COMPRA DESDE " + STRING(fechaD,"99/99/9999") + " HASTA " + STRING(FechaH,"99/99/9999").

chWorkSheet:Range("A2"):VALUE = "NRO. ORDEN".
chWorkSheet:Range("B2"):VALUE = "ALM. DESP".
chWorkSheet:Range("C2"):VALUE = "R.U.C".
chWorkSheet:Range("D2"):VALUE = "NOMBRE O RAZON SOCIAL".
chWorkSheet:Range("E2"):VALUE = "FECHA DOC".
chWorkSheet:Range("F2"):VALUE = "FECHA ENTREGA".
chWorkSheet:Range("G2"):VALUE = "FECHA MAXIMA".
chWorkSheet:Range("H2"):VALUE = "FORMA PAGO".
chWorkSheet:Range("I2"):VALUE = "OBSERVACION".
chWorkSheet:Range("J2"):VALUE = "SOLES (S/.)".
chWorkSheet:Range("K2"):VALUE = "DOLARES ($)".

chWorkSheet:Range("L2"):VALUE = "SITUACION".
chWorkSheet:Range("M2"):VALUE = "USUARIO".
chWorkSheet:Range("N2"):VALUE = "MAQUINA".

FOR EACH T-COCMP BREAK BY T-COCMP.codcia BY T-COCMP.nrodoc :
    ASSIGN 
        x-sol = 0.00
        x-dol = 0.00
        x-nommaq = ''.

    IF CODMON = 1 THEN 
        ASSIGN 
            X-SOL = T-COCMP.IMPTOT
            X-DOL = 0.00 
            t-soles = t-soles + T-COCMP.imptot.
    
    IF CODMON = 2 THEN 
        ASSIGN 
            X-DOL = T-COCMP.IMPTOT
            X-SOL = 0.00 
            t-dolar = t-dolar + T-COCMP.imptot.

    FIND GN-PROV WHERE GN-PROV.CODPRO = T-COCMP.CODPRO NO-LOCK NO-ERROR.  
    IF AVAILABLE GN-PROV THEN X-NOMBRE = GN-PROV.NOMPRO.
    ELSE X-NOMBRE = STRING(T-COCMP.CODPRO).

    FIND gn-concp WHERE gn-concp.CODIG = T-COCMP.CNDCMP NO-LOCK NO-ERROR.  
    IF AVAILABLE gn-concp THEN X-CONDI = gn-concp.NOMBR.
    
    ASSIGN 
        F-SitDoc = ''
        F-SitDoc = ENTRY(LOOKUP(TRIM(T-COCMP.FlgSit),"G,P,A,T,V,X,R"),"Emitido,Pendiente,Anulado,Aten.Total,Vencida,Aten.Parcial,En Revision").

    /* MAQUINA */
    FIND AlmTabla WHERE AlmTabla.Tabla = 'MQ'
        AND AlmTabla.Codigo = T-COCmp.CodMaq NO-LOCK NO-ERROR.
    IF AVAILABLE AlmTabla THEN x-NomMaq = almtabla.Nombre.

    /***************************/
    t-Row = t-Row + 1.

    t-Column = 1.
    chWorkSheet:Cells(t-Row, t-Column) = "'" + STRING(T-COCMP.nrodoc).
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = "'" + T-COCMP.CodAlm .
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = "'" + T-COCMP.Codpro.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = X-NOMBRE.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = T-COCMP.fchdoc.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = T-COCMP.fchent.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = T-COCMP.fchvto.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = X-CONDI.
    
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = T-COCMP.observaciones.
    
    t-column = t-column + 1.
    IF X-SOL > 0 THEN chWorkSheet:Cells(t-Row, t-Column) = X-SOL.
    
    t-column = t-column + 1.
    IF X-DOL > 0 THEN chWorkSheet:Cells(t-Row, t-Column) = X-DOL.
    
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = F-Sitdoc.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = T-COCMP.Userid-com.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = x-NomMaq.

/*     IF LAST-OF(T-COCMP.Codcia) THEN DO:            */
/*         t-column = t-column + 1.                   */
/*         cColumn = STRING(t-Column).                */
/*         cRange = "J" + cColumn.                    */
/*         chWorkSheet:Range(cRange):Value = T-soles. */
/*         cRange = "K" + cColumn.                    */
/*         chWorkSheet:Range(cRange):Value = T-Dolar. */
/*     END.                                           */
 END.

 /*
f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.
*/
/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-Detalle W-Win 
PROCEDURE Excel-Detalle :
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
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE t-Row                   AS INTEGER INIT 2.
DEFINE VARIABLE cFila1 AS CHAR FORMAT 'X' INIT ''.
DEFINE VARIABLE cFila2 AS CHAR FORMAT 'X' INIT ''.

DEFINE VARIABLE dCanPen AS DECIMAL     NO-UNDO.
DEFINE VARIABLE dImpLin AS DECIMAL     NO-UNDO.

RUN Carga-Temporal.

DEF VAR x-TITU3 AS CHAR FORMAT 'x(50)'.
DEF VAR x-TITU4 AS CHAR FORMAT 'x(50)'.
DEF VAR x-NomMaq AS CHAR FORMAT 'x(20)'.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* Titulos */
chWorkSheet:Range("D1"):VALUE = "RELACIONES DE ORDENDES DE COMPRA DESDE " + STRING(fechaD,"99/99/9999") + " HASTA " + STRING(FechaH,"99/99/9999").

chWorkSheet:Range("A2"):VALUE = "NRO. ORDEN".
chWorkSheet:Range("B2"):VALUE = "ALM. DESP".
chWorkSheet:Range("C2"):VALUE = "R.U.C".
chWorkSheet:Range("D2"):VALUE = "NOMBRE O RAZON SOCIAL".
chWorkSheet:Range("E2"):VALUE = "FECHA DOC".
chWorkSheet:Range("F2"):VALUE = "FECHA ENTREGA".
chWorkSheet:Range("G2"):VALUE = "FECHA MAXIMA".
chWorkSheet:Range("H2"):VALUE = "FORMA PAGO".
chWorkSheet:Range("I2"):VALUE = "ARTICULO".
chWorkSheet:Range("J2"):VALUE = "UNIDAD".
chWorkSheet:Range("K2"):VALUE = "CANTIDAD PEDIDA".
chWorkSheet:Range("L2"):VALUE = "CANTIDAD ATENDIDA".
chWorkSheet:Range("M2"):VALUE = "OBSERVACION".
chWorkSheet:Range("N2"):VALUE = "SOLES (S/.)".
chWorkSheet:Range("O2"):VALUE = "DOLARES ($)".

chWorkSheet:Range("P2"):VALUE = "SITUACION".
chWorkSheet:Range("Q2"):VALUE = "USUARIO".
chWorkSheet:Range("R2"):VALUE = "MAQUINA".

FOR EACH T-COCMP,
    EACH lg-docmp OF t-cocmp NO-LOCK,
    FIRST Almmmatg OF lg-docmp NO-LOCK
    BREAK BY T-COCMP.codcia BY T-COCMP.nrodoc :

/*     ASSIGN                                                                              */
/*         dCanPen = (LG-DOCmp.CanPedi - LG-DOCmp.CanAten)                                 */
/*         dImpLin = ROUND((LG-DOCMP.CanPedi - LG-DOCMP.CanAten) * ROUND(LG-DOCMP.PreUni * */
/*                             (1 - (LG-DOCMP.Dsctos[1] / 100)) *                          */
/*                             (1 - (LG-DOCMP.Dsctos[2] / 100)) *                          */
/*                             (1 - (LG-DOCMP.Dsctos[3] / 100)) *                          */
/*                             (1 + (LG-DOCMP.IgvMat / 100)) , 4),2).                      */
/*     IF dCanPen = 0 THEN NEXT.                                                           */

    ASSIGN 
        x-sol = 0.00
        x-dol = 0.00
        x-nommaq = ''.

    IF CODMON = 1 THEN 
        ASSIGN 
            /*X-SOL = T-COCMP.IMPTOT*/
            X-SOL = lg-docmp.imptot
            X-DOL = 0.00 
            /*t-soles = t-soles + T-COCMP.imptot.*/
            t-soles = t-soles + lg-docmp.imptot.
   
    IF CODMON = 2 THEN 
        ASSIGN 
            /*X-DOL = T-COCMP.IMPTOT*/
            X-DOL = lg-docmp.imptot
            X-SOL = 0.00 
            /*t-dolar = t-dolar + T-COCMP.imptot.*/
            t-dolar = t-dolar + lg-docmp.imptot.

    FIND GN-PROV WHERE GN-PROV.CODPRO = T-COCMP.CODPRO NO-LOCK NO-ERROR.  
    IF AVAILABLE GN-PROV THEN X-NOMBRE = GN-PROV.NOMPRO.
    ELSE X-NOMBRE = STRING(T-COCMP.CODPRO).

    FIND gn-concp WHERE gn-concp.CODIG = T-COCMP.CNDCMP NO-LOCK NO-ERROR.  
    IF AVAILABLE gn-concp THEN X-CONDI = gn-concp.NOMBR.
    
    ASSIGN 
        F-SitDoc = ''
        F-SitDoc = ENTRY(LOOKUP(TRIM(T-COCMP.FlgSit),"G,P,A,T,V,X,R"),"Emitido,Pendiente,Anulado,Aten.Total,Vencida,Aten.Parcial,En Revision").

    /* MAQUINA */
    FIND AlmTabla WHERE AlmTabla.Tabla = 'MQ'
        AND AlmTabla.Codigo = T-COCmp.CodMaq NO-LOCK NO-ERROR.
    IF AVAILABLE AlmTabla THEN x-NomMaq = almtabla.Nombre.

    t-Row = t-Row + 1.

    t-Column = 1.
    chWorkSheet:Cells(t-Row, t-Column) = "'" + STRING(T-COCMP.nrodoc).
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = "'" + T-COCMP.CodAlm .
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = "'" + T-COCMP.Codpro.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = X-NOMBRE.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = T-COCMP.fchdoc.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = T-COCMP.fchent.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = T-COCMP.fchvto.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = X-CONDI.

    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = lg-docmp.codmat + "-" + almmmatg.desmat.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = lg-docmp.UndCmp.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = lg-docmp.CanPedi.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = lg-docmp.CanAten.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = T-COCMP.observaciones.

    t-column = t-column + 1.
    IF X-SOL > 0 THEN chWorkSheet:Cells(t-Row, t-Column) = X-SOL.
    
    t-column = t-column + 1.
    IF X-DOL > 0 THEN chWorkSheet:Cells(t-Row, t-Column) = X-DOL.
    
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = F-Sitdoc.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = T-COCMP.Userid-com.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = x-NomMaq.

             
/*    IF LAST-OF(T-COCMP.Codcia) THEN DO:            */
/*        t-column = t-column + 1.                   */
/*        cColumn = STRING(t-Column).                */
/*        cRange = "J" + cColumn.                    */
/*        chWorkSheet:Range(cRange):Value = T-soles. */
/*        cRange = "K" + cColumn.                    */
/*        chWorkSheet:Range(cRange):Value = T-Dolar. */
/*     END.                                          */
 END.

 /*
f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.
*/
/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato W-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-TITU3 AS CHAR FORMAT 'x(50)'.
  DEF VAR x-TITU4 AS CHAR FORMAT 'x(50)'.
  DEF VAR x-NomMaq AS CHAR FORMAT 'x(20)'.

  T-soles = 0.
  T-Dolar = 0.
  IF f-CndCmp <> ''
  THEN DO:
    FIND gn-concp WHERE gn-concp.Codig = f-cndcmp NO-LOCK NO-ERROR.
    IF AVAILABLE gn-concp 
    THEN x-TITU3 = 'FORMA DE PAGO: ' + f-CndCmp + ' ' + gn-concp.Nombr.
  END.
  IF x-CodMaq <> '' THEN DO:
    FIND Almtabla WHERE Almtabla.tabla = 'MQ'
        AND Almtabla.codigo = x-CodMaq NO-LOCK NO-ERROR.
    IF AVAILABLE Almtabla 
    THEN x-TITU4 = 'MAQUINA : ' + x-CodMaq + ' ' + almtabla.Nombre.
  END.

  DEFINE FRAME F-HdrREQ
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP
         "RELACION  DE  ORDENES  DE  COMPRA" AT 50
         "Pagina :" TO 130 PAGE-NUMBER(REPORT) TO 142 FORMAT "ZZZZZ9" SKIP
         TITU2 FORMAT "X(40)" AT 52 
         "Fecha  :" TO 130 TODAY TO 142 FORMAT "99/99/9999" SKIP
         x-TITU3
         "Hora   :" TO 130 STRING(TIME,"HH:MM") TO 142 SKIP
         x-TITU4 SKIP
        "-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" skip
        " Nro.  Alm                                                Fecha       Fecha      Fecha    Forma           Observacion                I m p o r t e                                             "  SKIP
        " Orden Desp R.U.C      Nombre o Razon Social          Documento     Entrega      Maxima    Pago                                   Soles      Dolares Situacion  Usuario         Maquina        "  skip
        "-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" skip
  WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  
  DEFINE FRAME F-DetaREQ
    T-COCMP.nrodoc 
    T-COCMP.CodAlm
    T-COCMP.CodPro FORMAT "X(11)"
    X-NOMBRE FORMAT "x(30)" 
    T-COCMP.fchdoc space(2) 
    T-COCMP.fchent space(2)
    T-COCMP.fchvto space(2)
    X-CONDI FORMAT "X(13)"
    T-COCMP.observaciones format "x(20)"
    x-sol FORMAT ">,>>>,>>9.99" 
    x-dol FORMAT ">,>>>,>>9.99"
    F-Sitdoc
    T-COCMP.Userid-com
    x-NomMaq
  WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

 FOR EACH T-COCMP BREAK BY T-COCMP.codcia BY T-COCMP.nrodoc :
    VIEW STREAM REPORT FRAME F-HdrREQ.                      
    x-sol = 0.00 .
    x-dol = 0.00 .
    x-nommaq = ''.
    IF CODMON = 1 THEN DO:
        X-SOL = T-COCMP.IMPTOT.
        X-DOL = 0.00 .
        t-soles = t-soles + T-COCMP.imptot.
    END.
    IF CODMON = 2 THEN DO:
        X-DOL = T-COCMP.IMPTOT.
        X-SOL = 0.00 .
        t-dolar = t-dolar + T-COCMP.imptot.
    END.
    FIND GN-PROV WHERE GN-PROV.CODPRO = T-COCMP.CODPRO NO-LOCK NO-ERROR.  
    IF AVAILABLE GN-PROV THEN DO:
      X-NOMBRE = GN-PROV.NOMPRO.
    END.    
    ELSE     
      X-NOMBRE = STRING(T-COCMP.CODPRO).
      
    FIND gn-concp WHERE gn-concp.CODIG = T-COCMP.CNDCMP NO-LOCK NO-ERROR.  
    IF AVAILABLE gn-concp THEN DO:
      X-CONDI = gn-concp.NOMBR.
    END.           
  
    F-SitDoc = ''.
    F-SitDoc = ENTRY(LOOKUP(TRIM(T-COCMP.FlgSit),"G,P,A,T,V,X,R"),"Emitido,Pendiente,Anulado,Aten.Total,Vencida,Aten.Parcial,En Revision").

    /* MAQUINA */
    FIND AlmTabla WHERE AlmTabla.Tabla = 'MQ'
        AND AlmTabla.Codigo = T-COCmp.CodMaq
        NO-LOCK NO-ERROR.
    IF AVAILABLE AlmTabla THEN x-NomMaq = almtabla.Nombre.
  
    DISPLAY  STREAM REPORT 
            T-COCMP.nrodoc 
            T-COCMP.CodAlm
            T-COCMP.Codpro
            X-NOMBRE
            T-COCMP.fchdoc
            T-COCMP.fchent 
            T-COCMP.fchvto
            X-CONDI
            T-COCMP.observaciones 
            X-SOL WHEN X-SOL > 0
            X-DOL WHEN X-DOL > 0
            F-Sitdoc
            T-COCMP.Userid-com
            x-NomMaq
          WITH FRAME F-DetaREQ.

   IF LAST-OF(T-COCMP.Codcia) THEN DO:
         UNDERLINE STREAM REPORT 
                X-SOL
                X-DOL
                WITH FRAME F-DetaREQ.      
         DISPLAY STREAM  REPORT 
                 T-soles @ x-sol
                 T-Dolar @ x-dol
                 WITH FRAME F-DetaREQ.
    END.                           
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Habilita W-Win 
PROCEDURE Habilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    ENABLE ALL EXCEPT x-nompro F-dirent.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime W-Win 
PROCEDURE Imprime :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   
    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    RUN Carga-Temporal.

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
        RUN Formato.
        PAGE STREAM REPORT.
        OUTPUT STREAM REPORT CLOSE.
    END.
    OUTPUT CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            RUN LIB/W-README.R(s-print-file).
            IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Inhabilita W-Win 
PROCEDURE Inhabilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    DISABLE ALL.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Inicializa-Variables W-Win 
PROCEDURE Inicializa-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
  Assign fechaD fechaH x-proveedor x-nompro .

  IF x-proveedor <> "" THEN DO:
     x-proveedor = "".
     x-nompro    = "".
  END.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
     ASSIGN FechaD = TODAY
            FechaH = TODAY
            F-almacen = "".
     DISPLAY FechaD FechaH F-almacen.
     FOR EACH almtabla WHERE tabla = 'CC' NO-LOCK:
        COMBO-BOX-ModAdq:ADD-LAST(almtabla.codigo).
     END.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros W-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros W-Win 
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

    CASE HANDLE-CAMPO:name:
        WHEN "x-CodMaq" THEN 
            ASSIGN 
                input-var-1 = "MQ"
                input-var-2 = ""
                input-var-3 = "".
    END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
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

