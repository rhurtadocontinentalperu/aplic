&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-nomcia AS CHAR.
{cbd/CbGlobal.i}

DEF TEMP-TABLE DETALLE LIKE AlmMMatg
    FIELD VtaxMesMn AS DEC
    FIELD VtaxMesMe AS DEC
    FIELD Cco       AS CHAR
    FIELD CanxMes   AS DEC
    INDEX INDICE01 IS PRIMARY codcia codmat.

DEF VAR x-Mensaje AS CHAR FORMAT 'x(50)'.
DEF FRAME F-MENSAJE
    x-Mensaje
    WITH CENTERED OVERLAY NO-LABELS VIEW-AS DIALOG-BOX.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-7 COMBO-BOX-CodDiv COMBO-BOX-Periodo ~
COMBO-BOX-NroMes COMBO-BOX-Licencia BUTTON-8 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-CodDiv COMBO-BOX-Periodo ~
COMBO-BOX-NroMes COMBO-BOX-Licencia 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-7 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Button 7" 
     SIZE 15 BY 1.54.

DEFINE BUTTON BUTTON-8 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Button 8" 
     SIZE 15 BY 1.54.

DEFINE VARIABLE COMBO-BOX-CodDiv AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Divisiones" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todas" 
     SIZE 11 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Licencia AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Licenciatarios" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todas" 
     SIZE 42 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-NroMes AS INTEGER FORMAT "99":U INITIAL 1 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEMS "01","02","03","04","05","06","07","08","09","10","11","12" 
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0000" 
     SIZE 8 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-7 AT ROW 7.35 COL 7
     COMBO-BOX-CodDiv AT ROW 1.77 COL 19 COLON-ALIGNED
     COMBO-BOX-Periodo AT ROW 2.73 COL 19 COLON-ALIGNED
     COMBO-BOX-NroMes AT ROW 3.69 COL 19 COLON-ALIGNED
     COMBO-BOX-Licencia AT ROW 4.65 COL 19 COLON-ALIGNED
     BUTTON-8 AT ROW 7.35 COL 24
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 17
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
         TITLE              = "REPORTE DE LICENCIATARIOS POR CENTRO DE COSTO"
         HEIGHT             = 8.69
         WIDTH              = 71.72
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 80
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


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REPORTE DE LICENCIATARIOS POR CENTRO DE COSTO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REPORTE DE LICENCIATARIOS POR CENTRO DE COSTO */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-7 W-Win
ON CHOOSE OF BUTTON-7 IN FRAME F-Main /* Button 7 */
DO:
  ASSIGN
    COMBO-BOX-CodDiv COMBO-BOX-Licencia COMBO-BOX-NroMes COMBO-BOX-Periodo.
  RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-8 W-Win
ON CHOOSE OF BUTTON-8 IN FRAME F-Main /* Button 8 */
DO:
  RUN dispatch IN THIS-PROCEDURE ('exit':U).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win _ADM-ROW-AVAILABLE
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
  DEF VAR x-Signo AS INT INIT 1 NO-UNDO.
  DEF VAR x-CodFchI AS DATE NO-UNDO.
  DEF VAR x-CodFchF AS DATE NO-UNDO.
  DEF VAR x-TpoCmbCmp AS DEC NO-UNDO.
  DEF VAR x-TpoCmbVta AS DEC NO-UNDO.
  DEF VAR x-Cco       AS CHAR NO-UNDO.
  DEF VAR x-Licencia  AS CHAR NO-UNDO.
  DEF VAR f-Factor    AS DECI NO-UNDO.
  
  FOR EACH DETALLE:
    DELETE DETALLE.
  END.
  x-Licencia = TRIM(SUBSTRING(COMBO-BOX-Licencia,1,8)).
  RUN bin/_dateif (COMBO-BOX-NroMes,
                    COMBO-BOX-Periodo,
                    OUTPUT x-CodFchI,
                    OUTPUT x-CodFchF).
  FOR EACH GN-DIVI WHERE gn-divi.codcia = s-codcia
        AND (COMBO-BOX-CodDiv = 'Todas' OR gn-divi.coddiv = COMBO-BOX-CodDiv)
        NO-LOCK:
    x-Mensaje = 'Procesando Informacion, un momento por favor...'.
    DISPLAY x-Mensaje WITH FRAME F-MENSAJE.
    FOR EACH CcbCdocu WHERE CcbCdocu.CodCia = s-codcia
            AND CcbCdocu.CodDiv = Gn-Divi.CodDiv
            AND CcbCdocu.FchDoc >= x-CodFchI
            AND CcbCdocu.FchDoc <= x-CodFchF
            USE-INDEX llave10
            NO-LOCK:
        IF LOOKUP(CcbCDocu.CodDoc,"TCK,FAC,BOL,N/C,N/D") = 0 THEN NEXT.
        IF CcbCDocu.FlgEst = "A"  THEN NEXT.
        x-Signo = IF CcbCdocu.Coddoc = "N/C" THEN -1 ELSE 1.
        ASSIGN
            x-TpoCmbCmp = 1
            x-TpoCmbVta = 1
            x-Cco       = CcbCDocu.Cco.
        FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= CcbCdocu.FchDoc
            USE-INDEX Cmb01 NO-LOCK NO-ERROR.
        IF NOT AVAIL Gn-Tcmb 
        THEN FIND FIRST Gn-Tcmb WHERE Gn-Tcmb.Fecha >= CcbCdocu.FchDoc
                USE-INDEX Cmb01 NO-LOCK NO-ERROR.
        IF AVAIL Gn-Tcmb 
        THEN ASSIGN
                x-TpoCmbCmp = Gn-Tcmb.Compra
                x-TpoCmbVta = Gn-Tcmb.Venta.
        IF x-Cco = ''
        THEN DO:        /* Buscamos por el vendedor */
            FIND GN-VEN OF CcbCDocu NO-LOCK NO-ERROR.
            IF AVAILABLE gn-ven THEN x-Cco = gn-ven.cco.
        END.
        FOR EACH CcbDDocu OF CcbCDocu NO-LOCK,
                FIRST AlmMMatg OF CcbDDocu NO-LOCK WHERE 
                    (x-Licencia = 'Todas' OR almmmatg.licencia[1] = x-Licencia)
                    AND almmmatg.licencia[1] <> '':
            FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
                    AND Almtconv.Codalter = Ccbddocu.UndVta
                    NO-LOCK NO-ERROR.
            F-FACTOR  = 1.
            IF AVAILABLE Almtconv THEN DO:
                F-FACTOR = Almtconv.Equival.
                IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
            END.

            FIND DETALLE WHERE detalle.codcia = almmmatg.codcia
                AND detalle.codmat = almmmatg.codmat
                AND detalle.licencia[1] = almmmatg.licencia[1]
                AND detalle.cco         = x-cco
                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE DETALLE
            THEN DO:
                CREATE DETALLE.
                BUFFER-COPY Almmmatg TO DETALLE
                    ASSIGN detalle.cco = x-cco.
            END.
            IF Ccbcdocu.CodMon = 1 
            THEN ASSIGN
                    DETALLE.VtaxMesMn = DETALLE.VtaxMesMn + x-signo * CcbDdocu.ImpLin
                    DETALLE.VtaxMesMe = DETALLE.VtaxMesMe + x-signo * CcbDdocu.ImpLin / x-TpoCmbCmp.
            IF Ccbcdocu.CodMon = 2 
            THEN ASSIGN
                    DETALLE.VtaxMesMn = DETALLE.VtaxMesMn + x-signo * CcbDdocu.ImpLin * x-TpoCmbVta
                    DETALLE.VtaxMesMe = DETALLE.VtaxMesMe + x-signo * CcbDdocu.ImpLin.
            DETALLE.CanxMes = DETALLE.CanxMes + 
                                    ( x-Signo * CcbDdocu.CanDes * f-Factor ).
        END.                
    END.    
  END.
  HIDE FRAME F-MENSAJE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win _DEFAULT-ENABLE
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
  DISPLAY COMBO-BOX-CodDiv COMBO-BOX-Periodo COMBO-BOX-NroMes COMBO-BOX-Licencia 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-7 COMBO-BOX-CodDiv COMBO-BOX-Periodo COMBO-BOX-NroMes 
         COMBO-BOX-Licencia BUTTON-8 
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
  DEF VAR x-Licencia AS CHAR.
  DEF VAR x-Cco      AS CHAR.
  DEF VAR x-Titulo   AS CHAR FORMAT 'x(80)'.
  DEF VAR x-Mes      AS CHAR.
  
  IF COMBO-BOX-CodDiv = 'Todas'
  THEN x-Titulo = "Todas las Divisiones".
  ELSE x-Titulo = "Division " + COMBO-BOX-CodDiv.
  x-Titulo = x-Titulo + ' ' + "Periodo " + STRING(COMBO-BOX-Periodo, '9999').
  RUN bin/_mes (COMBO-BOX-NroMes, 3, OUTPUT x-Mes).
  x-Titulo = x-Titulo + ' ' + "Mes de " + x-Mes.
  IF COMBO-BOX-Licencia = 'Todas'
  THEN x-Titulo = x-Titulo + ' ' + 'Todas las licencias'.
  ELSE x-Titulo = x-Titulo + ' Licencia ' + COMBO-BOX-Licencia.

  DEFINE FRAME F-DETALLE
    DETALLE.codmat      COLUMN-LABEL "Codigo"
    DETALLE.desmat      COLUMN-LABEL "Descripcion"
    DETALLE.desmar      COLUMN-LABEL "Marca"
    DETALLE.undbas      COLUMN-LABEL "Und"
    DETALLE.canxmes     COLUMN-LABEL "Cantidad"
    DETALLE.vtaxmesmn   COLUMN-LABEL "Total S/." FORMAT "->>>,>>>,>>9.99"
    DETALLE.vtaxmesme   COLUMN-LABEL "Total US$" FORMAT "->>>,>>>,>>9.99"
  WITH WIDTH 210 NO-BOX STREAM-IO DOWN. 

  DEFINE FRAME F-HEADER
    HEADER
    S-NOMCIA FORMAT 'x(50)' AT 1 SKIP
    "REPORTE DE VENTAS POR LICENCIATARIOS POR CENTRO DE COSTO" AT 20 
    "Pagina :" TO 140 PAGE-NUMBER(REPORT) FORMAT "ZZZZZ9" SKIP
    "Fecha :" TO 140 TODAY FORMAT "99/99/9999" SKIP
    "Hora :"  TO 140 STRING(TIME,"HH:MM") SKIP
    x-Titulo   SKIP(1)
  WITH PAGE-TOP WIDTH 210 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

  FOR EACH DETALLE BREAK BY DETALLE.codcia BY DETALLE.Licencia[1] BY DETALLE.Cco:
    VIEW STREAM REPORT FRAME F-HEADER.
    IF FIRST-OF(detalle.licencia[1])
    THEN DO:
        x-Licencia = ''.
        FIND Almtabla WHERE almtabla.tabla = 'LC'
            AND almtabla.codigo = detalle.licencia[1]
            NO-LOCK NO-ERROR.
        IF AVAILABLE almtabla THEN x-Licencia = almtabla.Nombre.
        DISPLAY STREAM REPORT
            "LICENCIA:" @ detalle.codmat
            detalle.licencia[1] + ' ' + x-licencia  @ detalle.desmat
            WITH FRAME F-DETALLE.
        UNDERLINE STREAM REPORT
            detalle.codmat
            detalle.desmat
            WITH FRAME F-DETALLE.
        DOWN STREAM REPORT WITH FRAME F-DETALLE.
    END.
    IF FIRST-OF(detalle.cco)
    THEN DO:
        x-Cco = ''.
        FIND cb-auxi WHERE cb-auxi.codcia = cb-codcia
            AND cb-auxi.clfaux = 'CCO'
            AND cb-auxi.codaux = detalle.cco
            NO-LOCK NO-ERROR.
        IF AVAILABLE cb-auxi THEN x-Cco = cb-auxi.nomaux.
        DISPLAY STREAM REPORT
            "CCO:" @ detalle.codmat
            detalle.cco + ' ' + x-cco  @ detalle.desmat
            WITH FRAME F-DETALLE.
        UNDERLINE STREAM REPORT
            detalle.codmat
            detalle.desmat
            WITH FRAME F-DETALLE.
        DOWN STREAM REPORT WITH FRAME F-DETALLE.
    END.
    ACCUMULATE detalle.vtaxmesmn (TOTAL BY detalle.licencia[1] BY detalle.cco).
    ACCUMULATE detalle.vtaxmesme (TOTAL BY detalle.licencia[1] BY detalle.cco).
    DISPLAY STREAM REPORT 
        DETALLE.codmat      
        DETALLE.desmat      
        DETALLE.desmar
        DETALLE.undbas
        DETALLE.canxmes
        DETALLE.vtaxmesmn
        DETALLE.vtaxmesme
        WITH FRAME F-DETALLE.
    IF LAST-OF(detalle.cco)
    THEN DO:
        UNDERLINE STREAM REPORT
            detalle.vtaxmesmn
            detalle.vtaxmesme
            WITH FRAME F-DETALLE.
        DISPLAY STREAM REPORT
            "SUB-TOTAL POR CCO " + detalle.cco @ detalle.desmar
            ACCUM TOTAL BY detalle.cco detalle.vtaxmesmn @ detalle.vtaxmesmn
            ACCUM TOTAL BY detalle.cco detalle.vtaxmesme @ detalle.vtaxmesme
            WITH FRAME F-DETALLE.
        DOWN STREAM REPORT 2 WITH FRAME F-DETALLE.
    END.
    IF LAST-OF(detalle.licencia[1])
    THEN DO:
        UNDERLINE STREAM REPORT
            detalle.vtaxmesmn
            detalle.vtaxmesme
            WITH FRAME F-DETALLE.
        DISPLAY STREAM REPORT
            "TOTAL POR LICENCIA " + detalle.licencia[1] @ detalle.desmar
            ACCUM TOTAL BY detalle.licencia[1] detalle.vtaxmesmn @ detalle.vtaxmesmn
            ACCUM TOTAL BY detalle.licencia[1] detalle.vtaxmesme @ detalle.vtaxmesme
            WITH FRAME F-DETALLE.
        DOWN STREAM REPORT 2 WITH FRAME F-DETALLE.
    END.
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

    RUN Carga-Temporal.

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
            FRAME {&FRAME-NAME}:SENSITIVE = FALSE.
            RUN LIB/W-README.R(s-print-file).
            FRAME {&FRAME-NAME}:SENSITIVE = TRUE.
            IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
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
  DO WITH FRAME {&FRAME-NAME}:
    FOR EACH GN-DIVI WHERE gn-divi.codcia = s-codcia NO-LOCK:
        COMBO-BOX-CodDiv:ADD-LAST(gn-divi.coddiv).
    END.
    FOR EACH CB-PERI WHERE cb-peri.codcia = s-codcia NO-LOCK:
        COMBO-BOX-Periodo:ADD-LAST(STRING(cb-peri.periodo, '9999')).
    END.
    COMBO-BOX-Periodo:DELETE('0000').
    COMBO-BOX-Periodo:SCREEN-VALUE = STRING(s-Periodo, '9999').
    COMBO-BOX-NroMes:SCREEN-VALUE = STRING(s-NroMes, '99').
    FOR EACH AlmTabla WHERE AlmTabla.Tabla = 'LC' NO-LOCK:
        COMBO-BOX-Licencia:ADD-LAST(STRING(almtabla.codigo, 'x(8)') +
               ' - ' + almtabla.nombre).
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win _ADM-SEND-RECORDS
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


