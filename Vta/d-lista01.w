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

DEFINE        VAR C-OP      AS CHAR.
DEFINE SHARED VAR S-CODCIA  AS INTEGER.
DEFINE SHARED VAR PV-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA  AS CHARACTER.
DEFINE        VAR F-PESALM  AS DECIMAL NO-UNDO.

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

/*******/
DEFINE SHARED VAR S-DESALM AS CHARACTER.
DEFINE SHARED VAR S-CODALM AS CHARACTER.

/* Local Variable Definitions ---                                       */
DEFINE VAR S-MONEDA AS CHAR FORMAT 'x(3)'.

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
&Scoped-Define ENABLED-OBJECTS RECT-45 RECT-72 FILL-IN-CodFam ~
FILL-IN-SubFam FILL-IN-CodPr1 RADIO-SET-Orden Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-CodFam FILL-IN-DesFam ~
FILL-IN-SubFam FILL-IN-DesSUb FILL-IN-CodPr1 FILL-IN-NomPro RADIO-SET-Orden ~
x-mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 13 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 13 BY 1.54
     BGCOLOR 8 .

DEFINE VARIABLE FILL-IN-CodFam AS CHARACTER FORMAT "X(256)":U 
     LABEL "Familia" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodPr1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-DesFam AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-DesSUb AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-SubFam AS CHARACTER FORMAT "X(256)":U 
     LABEL "Sub-Familia" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 66 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE RADIO-SET-Orden AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Proveedor y Descripción", 1,
"Familias y Sub-familias", 2
     SIZE 20 BY 1.92 NO-UNDO.

DEFINE RECTANGLE RECT-45
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 68 BY 7.

DEFINE RECTANGLE RECT-72
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 68 BY 2.08.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-CodFam AT ROW 2.15 COL 12.29 COLON-ALIGNED
     FILL-IN-DesFam AT ROW 2.15 COL 18.29 COLON-ALIGNED NO-LABEL
     FILL-IN-SubFam AT ROW 3.12 COL 12.29 COLON-ALIGNED
     FILL-IN-DesSUb AT ROW 3.12 COL 18.29 COLON-ALIGNED NO-LABEL
     FILL-IN-CodPr1 AT ROW 4.08 COL 12.29 COLON-ALIGNED
     FILL-IN-NomPro AT ROW 4.08 COL 22.29 COLON-ALIGNED NO-LABEL
     RADIO-SET-Orden AT ROW 5.04 COL 14.29 NO-LABEL
     x-mensaje AT ROW 7.46 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     Btn_OK AT ROW 8.81 COL 3
     Btn_Cancel AT ROW 8.81 COL 17
     "Ordenado por:" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 5.23 COL 4.29
     "Criterio de selección" VIEW-AS TEXT
          SIZE 18 BY .81 AT ROW 1.15 COL 5 WIDGET-ID 2
          FONT 6
     RECT-45 AT ROW 1.54 COL 2
     RECT-72 AT ROW 8.62 COL 2 WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 71.57 BY 10.35
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
         TITLE              = "Margenes de Precios por Menor"
         HEIGHT             = 10.35
         WIDTH              = 71.57
         MAX-HEIGHT         = 10.35
         MAX-WIDTH          = 71.57
         VIRTUAL-HEIGHT     = 10.35
         VIRTUAL-WIDTH      = 71.57
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
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN FILL-IN-DesFam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DesSUb IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Margenes de Precios por Menor */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Margenes de Precios por Menor */
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
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
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


&Scoped-define SELF-NAME FILL-IN-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodFam W-Win
ON LEAVE OF FILL-IN-CodFam IN FRAME F-Main /* Familia */
DO:
  FIND almtfami WHERE almtfami.codcia = s-codcia
    AND almtfami.codfam = INPUT {&SELF-NAME}
    NO-LOCK NO-ERROR.
  IF AVAILABLE almtfami
  THEN FILL-IN-DesFam:SCREEN-VALUE = almtfami.desfam.
  ELSE FILL-IN-DesFam:SCREEN-VALUE = ''.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodPr1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodPr1 W-Win
ON LEAVE OF FILL-IN-CodPr1 IN FRAME F-Main /* Proveedor */
DO:
  FIND gn-prov WHERE gn-prov.codcia = pv-codcia
    AND gn-prov.codpro = INPUT {&SELF-NAME}
    NO-LOCK NO-ERROR.
  IF AVAILABLE gn-prov
  THEN FILL-IN-NomPro:SCREEN-VALUE = gn-prov.nompro.
  ELSE FILL-IN-NomPro:SCREEN-VALUE = ''.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-SubFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-SubFam W-Win
ON LEAVE OF FILL-IN-SubFam IN FRAME F-Main /* Sub-Familia */
DO:
  FIND almsfami WHERE almsfami.codcia = s-codcia
    AND almsfami.codfam = FILL-IN-CodFam:SCREEN-VALUE
    AND almsfami.subfam = INPUT {&SELF-NAME}
    NO-LOCK NO-ERROR.
  IF AVAILABLE almsfami
  THEN FILL-IN-DesSub:SCREEN-VALUE = almsfami.dessub.
  ELSE FILL-IN-DesSub:SCREEN-VALUE = ''.
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
  ASSIGN
    FILL-IN-CodFam FILL-IN-CodPr1 FILL-IN-SubFam RADIO-SET-Orden.
END.

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
  DISPLAY FILL-IN-CodFam FILL-IN-DesFam FILL-IN-SubFam FILL-IN-DesSUb 
          FILL-IN-CodPr1 FILL-IN-NomPro RADIO-SET-Orden x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-45 RECT-72 FILL-IN-CodFam FILL-IN-SubFam FILL-IN-CodPr1 
         RADIO-SET-Orden Btn_OK Btn_Cancel 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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
  
  CASE RADIO-SET-Orden:
  WHEN 1 THEN RUN Por-Proveedor.
  WHEN 2 THEN RUN Por-Familia.
  END CASE.  

  HIDE FRAME F-PROCESO.

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
    ENABLE ALL EXCEPT FILL-IN-DesFam FILL-IN-DesSUb FILL-IN-NomPro x-mensaje.
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
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

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
  ASSIGN FILL-IN-CodFam FILL-IN-CodPr1 FILL-IN-DesFam FILL-IN-DesSUb FILL-IN-NomPro FILL-IN-SubFam RADIO-SET-Orden.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Por-Familia W-Win 
PROCEDURE Por-Familia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE FRAME F-REPORTE
    almmmatg.codmat
    almmmatg.desmat FORMAT 'x(35)'
    almmmatg.desmar FORMAT 'x(20)'
    almmmatg.undstk FORMAT 'x(6)'
    s-moneda
    almmmatg.tpocmb FORMAT '>,>>9.9999'
    almmmatg.undbas FORMAT 'x(6)'
    almmmatg.ctolis FORMAT '>>,>>9.9999'
    almmmatg.ctotot FORMAT '>>,>>9.9999'
    almmmatg.undalt[1] FORMAT 'x(6)'
    almmmatg.mrgalt[1] FORMAT '->,>>9.99'
    almmmatg.prealt[1] FORMAT '>>,>>9.99' SKIP
    WITH WIDTH 145 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
 
  DEFINE FRAME F-HEADER       
    HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN6A} + "MARGENES DE PRECIOS POR MENOR"  AT 50 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 96 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN4} + "Fecha : " AT 109 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        "Hora  : " AT 124 STRING(TIME,"HH:MM:SS") SKIP
        "-----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                Und    Mon            Und    Costo Lista Costo Lista Und       Margen          " SKIP
        "Codigo Descripcion                         Marca                Stk    Vta  Tpo Cmb   Base       Sin IGV    Con IGV  Vta          %     Precio " SKIP
        "-----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*
                  1         2         3         4         5         6         7         8         9        10         11       12        13        14
         123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
         123456 12345678901234567890123456789012345 12345678901234567890 123456 S/. >,>>9.9999 123456 >>,>>9.9999 >>,>>9.9999 123456 ->,>>9.99 >>,>>9.99

*/
    WITH PAGE-TOP WIDTH 145 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
 
  FOR EACH Almmmatg WHERE almmmatg.codcia = s-codcia
        AND almmmatg.tpoart <> 'D'
        AND (FILL-IN-CodFam = '' OR almmmatg.codfam = FILL-IN-CodFam)
        AND (FILL-IN-SubFam = '' OR almmmatg.subfam = FILL-IN-SubFam)
        AND (FILL-IN-CodPr1 = '' OR almmmatg.codpr1 = FILL-IN-CodPr1)
        NO-LOCK,
        FIRST almtfami OF almmmatg NO-LOCK,
        FIRST almsfami OF almmmatg NO-LOCK
        BREAK BY almmmatg.codfam BY almmmatg.subfam:
     /*
     DISPLAY Almmmatg.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
             FORMAT "X(11)" 
             WITH FRAME F-Proceso.
     */

     DISPLAY "Codigo de Articulo: " + Almmmatg.CodMat @ x-mensaje WITH FRAME {&FRAME-NAME}.
  
    VIEW STREAM REPORT FRAME F-HEADER.
     
    IF FIRST-OF(almmmatg.codfam)
    THEN DO:
        PUT STREAM REPORT
            ' ' SKIP
            "FAMILIA: " almtfami.desfam SKIP(1).
    END.
    IF FIRST-OF(almmmatg.subfam)
    THEN DO:
        PUT STREAM REPORT
            ' ' SKIP
            "SUB-FAMILIA: " almsfami.dessub SKIP(1).
    END.
    CASE almmmatg.monvta:
    WHEN 1 THEN s-Moneda = 'S/.'.
    WHEN 2 THEN s-Moneda = 'US$'.
    OTHERWISE s-Moneda = '???'.
    END CASE.
    DISPLAY STREAM REPORT
        almmmatg.codmat
        almmmatg.desmat 
        almmmatg.desmar 
        almmmatg.undstk 
        s-moneda
        almmmatg.tpocmb 
        almmmatg.undbas 
        almmmatg.tpocmb 
        almmmatg.ctolis
        almmmatg.ctotot
        almmmatg.undalt[1]
        almmmatg.mrgalt[1]
        almmmatg.prealt[1]
        WITH FRAME F-REPORTE.
  END.
DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Por-Proveedor W-Win 
PROCEDURE Por-Proveedor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE FRAME F-REPORTE
    almmmatg.codmat
    almmmatg.desmat FORMAT 'x(35)'
    almmmatg.desmar FORMAT 'x(20)'
    almmmatg.undstk FORMAT 'x(6)'
    s-moneda
    almmmatg.tpocmb FORMAT '>,>>9.9999'
    almmmatg.undbas FORMAT 'x(6)'
    almmmatg.ctolis FORMAT '>>,>>9.9999'
    almmmatg.ctotot FORMAT '>>,>>9.9999'
    almmmatg.undalt[1] FORMAT 'x(6)'
    almmmatg.mrgalt[1] FORMAT '->,>>9.99'
    almmmatg.prealt[1] FORMAT '>>,>>9.99' SKIP
    WITH WIDTH 145 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
 
  DEFINE FRAME F-HEADER       
    HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN6A} + "MARGENES DE PRECIOS POR MENOR"  AT 50 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 96 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN4} + "Fecha : " AT 109 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        "Hora  : " AT 124 STRING(TIME,"HH:MM:SS") SKIP
        "-----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                Und    Mon            Und    Costo Lista Costo Lista Und       Margen          " SKIP
        "Codigo Descripcion                         Marca                Stk    Vta  Tpo Cmb   Base       Sin IGV    Con IGV  Vta          %     Precio " SKIP
        "-----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*
                  1         2         3         4         5         6         7         8         9        10         11       12        13        14
         123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
         123456 12345678901234567890123456789012345 12345678901234567890 123456 S/. >,>>9.9999 123456 >>,>>9.9999 >>,>>9.9999 123456 ->,>>9.99 >>,>>9.99

*/
    WITH PAGE-TOP WIDTH 145 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
 
  FOR EACH Almmmatg WHERE almmmatg.codcia = s-codcia
        AND almmmatg.tpoart <> 'D'
        AND (FILL-IN-CodFam = '' OR almmmatg.codfam = FILL-IN-CodFam)
        AND (FILL-IN-SubFam = '' OR almmmatg.subfam = FILL-IN-SubFam)
        AND (FILL-IN-CodPr1 = '' OR almmmatg.codpr1 = FILL-IN-CodPr1)
        NO-LOCK,
        FIRST gn-prov WHERE gn-prov.codcia = pv-codcia AND gn-prov.codpro = almmmatg.codpr1 NO-LOCK
        BREAK BY almmmatg.codpr1 BY almmmatg.desmat:
    /*
    DISPLAY Almmmatg.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
             FORMAT "X(11)" 
             WITH FRAME F-Proceso.
    */

    DISPLAY "Codigo de Articulo: " + Almmmatg.CodMat @ x-mensaje WITH FRAME {&FRAME-NAME}.

    VIEW STREAM REPORT FRAME F-HEADER.
    IF FIRST-OF(almmmatg.codpr1)
    THEN DO:
        PUT STREAM REPORT
            ' ' SKIP
            'PROVEEDOR: ' gn-prov.nompro SKIP(1).
    END.     
    CASE almmmatg.monvta:
    WHEN 1 THEN s-Moneda = 'S/.'.
    WHEN 2 THEN s-Moneda = 'US$'.
    OTHERWISE s-Moneda = '???'.
    END CASE.
    DISPLAY STREAM REPORT
        almmmatg.codmat
        almmmatg.desmat 
        almmmatg.desmar 
        almmmatg.undstk 
        s-moneda
        almmmatg.tpocmb 
        almmmatg.undbas 
        almmmatg.tpocmb 
        almmmatg.ctolis
        almmmatg.ctotot
        almmmatg.undalt[1]
        almmmatg.mrgalt[1]
        almmmatg.prealt[1]
        WITH FRAME F-REPORTE.
  END.

  DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.

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
    
    /*Variables a usar:
    output-var-1 como ROWID
    output-var-2 como CHARACTER
    output-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "F-marca" THEN input-var-1 = "MK".
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
        WHEN "FILL-IN-SubFam" THEN ASSIGN input-var-1 = FILL-IN-CodFam:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
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

