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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-nomcia AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.

/* Local Variable Definitions ---                                       */
DEF TEMP-TABLE DETALLE
    FIELD Codig  LIKE gn-ConVt.Codig 
    FIELD Nombr  LIKE gn-ConVt.Nombr
    FIELD ImpTot AS DEC EXTENT 12.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-4 x-CodMon COMBO-BOX-Periodo ~
COMBO-BOX-Mes-1 COMBO-BOX-Mes-2 BUTTON-2 BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS F-Division txt-msj x-CodMon ~
COMBO-BOX-Periodo COMBO-BOX-Mes-1 COMBO-BOX-Mes-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\print1":U
     LABEL "Button 1" 
     SIZE 7 BY 1.73.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img\exit":U
     LABEL "Button 2" 
     SIZE 7 BY 1.73.

DEFINE BUTTON BUTTON-4 
     LABEL "..." 
     SIZE 3 BY .77.

DEFINE VARIABLE COMBO-BOX-Mes-1 AS CHARACTER FORMAT "X(256)":U INITIAL "Enero" 
     LABEL "Desde el mes" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEMS "Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Setiembre","Octubre","Noviembre","Diciembre" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Mes-2 AS CHARACTER FORMAT "X(256)":U INITIAL "Diciembre" 
     LABEL "Hasta el mes" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEMS "Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Setiembre","Octubre","Noviembre","Diciembre" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE F-Division AS CHARACTER FORMAT "X(60)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE txt-msj AS CHARACTER FORMAT "X(256)":U INITIAL "Cargando Informacion....." 
     VIEW-AS FILL-IN 
     SIZE 34.29 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-CodMon AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles", 1,
"Dolares", 2
     SIZE 18 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-4 AT ROW 1.58 COL 60
     F-Division AT ROW 1.58 COL 14 COLON-ALIGNED
     txt-msj AT ROW 7.46 COL 24 NO-LABEL WIDGET-ID 4
     x-CodMon AT ROW 5.42 COL 16 NO-LABEL
     COMBO-BOX-Periodo AT ROW 2.54 COL 14 COLON-ALIGNED
     COMBO-BOX-Mes-1 AT ROW 3.5 COL 14 COLON-ALIGNED
     COMBO-BOX-Mes-2 AT ROW 4.46 COL 14 COLON-ALIGNED
     BUTTON-2 AT ROW 7.35 COL 15
     BUTTON-1 AT ROW 7.35 COL 6
     "Moneda:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 5.42 COL 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 71.86 BY 9.15
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
         TITLE              = "VENTAS POR CONDICION DE VENTA - MENSUAL"
         HEIGHT             = 9.15
         WIDTH              = 71.86
         MAX-HEIGHT         = 9.15
         MAX-WIDTH          = 71.86
         VIRTUAL-HEIGHT     = 9.15
         VIRTUAL-WIDTH      = 71.86
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
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
   R-To-L,COLUMNS                                                       */
/* SETTINGS FOR FILL-IN F-Division IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txt-msj IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       txt-msj:HIDDEN IN FRAME F-Main           = TRUE
       txt-msj:READ-ONLY IN FRAME F-Main        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* VENTAS POR CONDICION DE VENTA - MENSUAL */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* VENTAS POR CONDICION DE VENTA - MENSUAL */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
  ASSIGN
    COMBO-BOX-Mes-1 COMBO-BOX-Mes-2 COMBO-BOX-Periodo F-Division x-CodMon.
  RUN Imprimir.
  txt-msj:HIDDEN IN FRAME {&FRAME-NAME} = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  RUN dispatch IN THIS-PROCEDURE ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* ... */
DO:
  DEF VAR x-Divisiones AS CHAR.
  x-Divisiones = f-Division:SCREEN-VALUE.
  RUN vta/d-repo06 (INPUT-OUTPUT x-Divisiones).
  f-Division:SCREEN-VALUE = x-Divisiones.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Division W-Win
ON LEAVE OF F-Division IN FRAME F-Main /* Division */
DO:
    ASSIGN F-Division.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
/*{src/adm/template/cntnrwin.i}*/

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR i AS INT NO-UNDO.
  DEF VAR x-NroFch-1 AS INT NO-UNDO.
  DEF VAR x-NroFch-2 AS INT NO-UNDO.
    
  FOR EACH Detalle:
    DELETE Detalle.
  END.

  IF f-Division = '' THEN DO:
    FOR EACH GN-DIVI WHERE gn-divi.codcia = s-codcia NO-LOCK:
        IF f-Division = '' 
        THEN f-Division = TRIM(gn-divi.coddiv).
        ELSE f-Division = f-Division + ',' + TRIM(gn-divi.coddiv).
    END.
  END.

  x-NroFch-1 = COMBO-BOX-Periodo * 100 + LOOKUP(COMBO-BOX-Mes-1, COMBO-BOX-Mes-1:LIST-ITEMS IN FRAME {&FRAME-NAME}).
  x-NroFch-2 = COMBO-BOX-Periodo * 100 + LOOKUP(COMBO-BOX-Mes-2, COMBO-BOX-Mes-2:LIST-ITEMS IN FRAME {&FRAME-NAME}).

  DO i = 1 TO NUM-ENTRIES(f-Division):
    FOR EACH EvtFPgo WHERE EvtFPgo.codcia = s-codcia
            AND EvtFPgo.coddiv = ENTRY(i, f-Division)
             AND EvtFPgo.nrofch >= x-nrofch-1 
             AND EvtFPgo.nrofch <= x-nrofch-2 
             NO-LOCK:
        FIND DETALLE WHERE DETALLE.codig = EvtFPgo.FmaPgo EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE DETALLE THEN CREATE DETALLE.
        ASSIGN
            DETALLE.Codig = EvtFPgo.FmaPgo 
            DETALLE.ImpTot[EvtFPgo.Codmes] = DETALLE.ImpTot[EvtFPgo.Codmes] + 
                                                (IF x-CodMon = 2 THEN EvtFPgo.VtaxMesMe ELSE EvtFPgo.VtaxMesMn).
    END.               
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
  DISPLAY F-Division txt-msj x-CodMon COMBO-BOX-Periodo COMBO-BOX-Mes-1 
          COMBO-BOX-Mes-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-4 x-CodMon COMBO-BOX-Periodo COMBO-BOX-Mes-1 COMBO-BOX-Mes-2 
         BUTTON-2 BUTTON-1 
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
  DEF VAR x-Mes-1 AS CHAR FORMAT 'x(10)'.
  DEF VAR x-Mes-2 AS CHAR FORMAT 'x(10)'.
  DEF VAR x-Moneda AS CHAR FORMAT 'x(10)'.
  DEF VAR x-Nombre AS CHAR FORMAT 'x(30)'.
  
  ASSIGN
    x-Mes-1 = COMBO-BOX-Mes-1
    x-Mes-2 = COMBO-BOX-Mes-2
    x-Moneda = IF x-CodMon = 1 THEN 'NUEVOS SOLES' ELSE 'DOLARES'.
    
  DEFINE FRAME F-Cab
    detalle.codig       FORMAT 'x(3)'           COLUMN-LABEL 'Codigo'
    x-nombre            FORMAT 'x(30)'          COLUMN-LABEL 'Descripcion'
    detalle.imptot[1]   FORMAT '->,>>>,>>9.99'  COLUMN-LABEL 'Enero'
    detalle.imptot[2]   FORMAT '->,>>>,>>9.99'  COLUMN-LABEL 'Febrero'
    detalle.imptot[3]   FORMAT '->,>>>,>>9.99'  COLUMN-LABEL 'Marzo'
    detalle.imptot[4]   FORMAT '->,>>>,>>9.99'  COLUMN-LABEL 'Abril'
    detalle.imptot[5]   FORMAT '->,>>>,>>9.99'  COLUMN-LABEL 'Mayo'
    detalle.imptot[6]   FORMAT '->,>>>,>>9.99'  COLUMN-LABEL 'Junio'
    detalle.imptot[7]   FORMAT '->,>>>,>>9.99'  COLUMN-LABEL 'Julio'
    detalle.imptot[8]   FORMAT '->,>>>,>>9.99'  COLUMN-LABEL 'Agosto'
    detalle.imptot[9]   FORMAT '->,>>>,>>9.99'  COLUMN-LABEL 'Setiembre'
    detalle.imptot[10]  FORMAT '->,>>>,>>9.99'  COLUMN-LABEL 'Octubre'
    detalle.imptot[11]  FORMAT '->,>>>,>>9.99'  COLUMN-LABEL 'Noviembre'
    detalle.imptot[12]  FORMAT '->,>>>,>>9.99'  COLUMN-LABEL 'Diciembre'
    HEADER
        S-NOMCIA FORMAT 'X(50)' SKIP
        "VENTAS POR CONDICION DE VENTA - MENSUAL" AT 30
        "Pag.  : " AT 120 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "Fecha : " AT 120 STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
        "DIVISION(es):" f-Division FORMAT 'x(60)' SKIP
        "DESDE EL MES DE: " x-Mes-1 " HASTA EL MES DE: " x-Mes-2 " DEL PERIODO " STRING(COMBO-BOX-Periodo, '9999') SKIP
        "EXPRESADO EN " x-Moneda SKIP(1)
    WITH WIDTH 320 NO-BOX STREAM-IO DOWN.         

  FOR EACH DETALLE BY DETALLE.codig:
    x-Nombre = 'NO REGISTRADO'.
    FIND Gn-convt WHERE gn-ConVt.Codig = detalle.codig NO-LOCK NO-ERROR.
    IF AVAILABLE Gn-convt THEN x-Nombre = gn-ConVt.Nombr.
    DISPLAY STREAM REPORT
        detalle.codig       
        x-nombre
        detalle.imptot[1]   
        detalle.imptot[2]   
        detalle.imptot[3]   
        detalle.imptot[4]   
        detalle.imptot[5]   
        detalle.imptot[6]   
        detalle.imptot[7]   
        detalle.imptot[8]   
        detalle.imptot[9]   
        detalle.imptot[10]  
        detalle.imptot[11]  
        detalle.imptot[12]  
        WITH FRAME F-Cab.
        
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir W-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.   
    
    txt-msj:VISIBLE IN FRAME {&FRAME-NAME} = YES.
    RUN Carga-Temporal.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 60.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 60. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        RUN Formato.
        PAGE STREAM REPORT .
        OUTPUT STREAM REPORT CLOSE.
    END.
    OUTPUT STREAM REPORT CLOSE.

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
  txt-msj:HIDDEN IN FRAME {&FRAME-NAME} = YES.
  DO WITH FRAME {&FRAME-NAME}:
    FOR EACH Cb-Peri WHERE Cb-peri.codcia = s-codcia NO-LOCK:
        COMBO-BOX-Periodo:ADD-LAST(STRING(CB-PERI.Periodo)).
    END.
    COMBO-BOX-Periodo:DELETE(1).
    COMBO-BOX-Periodo:SCREEN-VALUE = COMBO-BOX-Periodo:ENTRY(COMBO-BOX-Periodo:NUM-ITEMS).
  END.

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

