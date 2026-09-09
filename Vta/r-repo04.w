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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-nomcia AS CHAR.

DEF TEMP-TABLE DETALLE LIKE CcbCDocu
    FIELD Fotocopia AS DEC FORMAT '->>>,>>>,>>9.99'.
    
DEF BUFFER B-CDOCU FOR CcbCDocu.
DEF BUFFER B-DDOCU FOR CcbDDocu.

DEF VAR s-CliCia AS INT INIT 0.

FIND Empresas WHERE Empresas.codcia = s-codcia NO-LOCK.
IF NOT Empresas.Campo-CodCli THEN s-CliCia = s-CodCia.

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
&Scoped-Define ENABLED-OBJECTS x-NroCard x-Fecha-1 x-Fecha-2 RADIO-SET-1 ~
Btn_OK Btn_Done 
&Scoped-Define DISPLAYED-OBJECTS x-NroCard x-NomCli x-Fecha-1 x-Fecha-2 ~
RADIO-SET-1 x-mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Done DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Salir" 
     SIZE 7 BY 1.62 TOOLTIP "salir"
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO DEFAULT 
     IMAGE-UP FILE "img/print.ico":U
     LABEL "Imprimir" 
     SIZE 7 BY 1.62 TOOLTIP "imprimir"
     BGCOLOR 8 .

DEFINE VARIABLE x-Fecha-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-Fecha-2 AS DATE FORMAT "99/99/99":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81 NO-UNDO.

DEFINE VARIABLE x-NroCard AS CHARACTER FORMAT "x(6)":U 
     LABEL "Tarjeta" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Resumido", 1,
"Detallado", 2
     SIZE 12 BY 2.12 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-NroCard AT ROW 1.38 COL 8 COLON-ALIGNED
     x-NomCli AT ROW 1.38 COL 20 COLON-ALIGNED NO-LABEL
     x-Fecha-1 AT ROW 2.35 COL 8 COLON-ALIGNED
     x-Fecha-2 AT ROW 3.31 COL 8 COLON-ALIGNED
     RADIO-SET-1 AT ROW 4.27 COL 10 NO-LABEL
     x-mensaje AT ROW 5.58 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     Btn_OK AT ROW 6.65 COL 9
     Btn_Done AT ROW 6.65 COL 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 74.43 BY 8.58
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
         TITLE              = "REPORTE DE CONTIPUNTOS"
         HEIGHT             = 8.58
         WIDTH              = 74.43
         MAX-HEIGHT         = 8.58
         MAX-WIDTH          = 74.43
         VIRTUAL-HEIGHT     = 8.58
         VIRTUAL-WIDTH      = 74.43
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

{src/adm-vm/method/vmviewer.i}
{src/bin/_prns.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME L-To-R                                                    */
/* SETTINGS FOR FILL-IN x-mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REPORTE DE CONTIPUNTOS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REPORTE DE CONTIPUNTOS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Done
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Done W-Win
ON CHOOSE OF Btn_Done IN FRAME F-Main /* Salir */
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Imprimir */
DO:
  ASSIGN
    RADIO-SET-1 x-NroCard x-Fecha-1 x-Fecha-2.
  RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-NroCard
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-NroCard W-Win
ON LEAVE OF x-NroCard IN FRAME F-Main /* Tarjeta */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  ASSIGN
    SELF:SCREEN-VALUE = STRING(DECIMAL(SELF:SCREEN-VALUE), '999999')
    NO-ERROR.
  FIND GN-CARD WHERE gn-card.NroCard = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE GN-CARD THEN x-NomCli:SCREEN-VALUE = GN-CARD.nomcli[1].
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF FRAME f-Mensaje
    SPACE(1) SKIP
    ccbcdocu.codcli ccbcdocu.coddoc ccbcdocu.nrodoc SKIP
    'Un momento por favor....' SKIP(1)
    SPACE(1) SKIP
    WITH NO-LABELS CENTERED OVERLAY VIEW-AS DIALOG-BOX TITLE 'PROCESANDO'.

  FOR EACH DETALLE:
    DELETE DETALLE.
  END.
  FOR EACH Ccbcdocu WHERE ccbcdocu.codcia = s-codcia
        AND LOOKUP(TRIM(ccbcdocu.coddoc), 'FAC,BOL,TCK') > 0
        AND ccbcdocu.nrocard <> ''
        AND ccbcdocu.nrocard BEGINS x-nrocard
        AND ccbcdocu.fchdoc >= x-fecha-1
        AND ccbcdocu.fchdoc <= x-fecha-2
        AND ccbcdocu.flgest <> 'A' NO-LOCK,
        FIRST GN-CARD WHERE gn-card.NroCard = ccbcdocu.nrocard NO-LOCK:
    IF ccbcdocu.puntos <= 0 THEN NEXT.

    /*
    DISPLAY ccbcdocu.codcli ccbcdocu.coddoc ccbcdocu.nrodoc
        WITH FRAME F-mensaje.
    */
    DISPLAY ccbcdocu.codcli + " " + ccbcdocu.coddoc + "-" + ccbcdocu.nrodoc @ x-mensaje
        WITH FRAME {&FRAME-NAME}.

    CREATE DETALLE.
    BUFFER-COPY Ccbcdocu TO DETALLE.
    /* Fotocopias */
    FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK WHERE Ccbddocu.codmat = '005206':
        ASSIGN
            Detalle.Fotocopia = Detalle.Fotocopia + Ccbddocu.implin.
    END.
    /* buscamos la nota de credito por devolucion */
    FOR EACH B-CDOCU WHERE B-CDOCU.codcia = s-codcia
            AND B-CDOCU.coddoc = 'N/C'
            AND B-CDOCU.codref = Ccbcdocu.coddoc
            AND B-CDOCU.nroref = Ccbcdocu.nrodoc
            AND B-CDOCU.flgest <> 'A'
            AND B-CDOCU.CndCre <> 'N'       /* NO por Otros conceptos */
            NO-LOCK:
        CREATE DETALLE.
        BUFFER-COPY B-CDOCU TO DETALLE
            ASSIGN
                DETALLE.NroCard = Ccbcdocu.nrocard
                DETALLE.Puntos = B-CDOCU.Puntos * -1
                DETALLE.Imptot = B-CDOCU.ImpTot * -1.
        FOR EACH B-DDOCU OF B-CDOCU NO-LOCK WHERE B-DDOCU.codmat = '005206':
            ASSIGN
                Detalle.Fotocopia = Detalle.Fotocopia - B-DDOCU.implin.
        END.
    END.        
  END.
  /*
  HIDE FRAME F-Mensaje.
  */
  DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.

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
  DISPLAY x-NroCard x-NomCli x-Fecha-1 x-Fecha-2 RADIO-SET-1 x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE x-NroCard x-Fecha-1 x-Fecha-2 RADIO-SET-1 Btn_OK Btn_Done 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-1 W-Win 
PROCEDURE Formato-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-ImpNac AS DEC FORMAT '>>>,>>>,>>9.99'.
  DEF VAR x-ImpUsa AS DEC FORMAT '>>>,>>>,>>9.99'.
  DEF VAR x-FotNac AS DEC FORMAT '>>>,>>>,>>9.99'.
  DEF VAR x-FotUsa AS DEC FORMAT '>>>,>>>,>>9.99'.
  DEF VAR x-NomCli AS CHAR.
  
  DEFINE FRAME F-REPORTE
    DETALLE.nrocard                             COLUMN-LABEL 'Cliente'
    x-nomcli            FORMAT 'x(45)'          COLUMN-LABEL 'Nombre'
    DETALLE.coddiv      FORMAT 'x(5)'           COLUMN-LABEL 'Division'
    x-ImpNac            FORMAT '->,>>>,>>9.99'  COLUMN-LABEL 'Importe S/.'
    x-ImpUsa            FORMAT '->,>>>,>>9.99'  COLUMN-LABEL 'Importe US$'
    x-FotNac            FORMAT '->,>>>,>>9.99'  COLUMN-LABEL 'Fotocopia!Importe S/.'
    x-FotUsa            FORMAT '->,>>>,>>9.99'  COLUMN-LABEL 'Fotocopia!Importe US$'
    DETALLE.Puntos      FORMAT '->>>,>>9'       COLUMN-LABEL 'ContiPuntos'
    DETALLE.codcli      FORMAT 'x(11)'          COLUMN-LABEL 'RUC'
    HEADER
         S-NOMCIA FORMAT "X(50)" SKIP
         "Pagina : " TO 90 PAGE-NUMBER(REPORT) TO 100 FORMAT "ZZZZZ9" SKIP
         "CONTIPUNTOS" AT 30
         " Fecha : " TO 90 TODAY TO 100 FORMAT "99/99/9999" SKIP
         "  Hora : " TO 90 STRING(TIME,"HH:MM:SS") TO 100 SKIP
         "DESDE EL" x-Fecha-1 "HASTA EL" x-Fecha-2 SKIP(1)
  WITH WIDTH 200 NO-BOX STREAM-IO DOWN.

  FOR EACH DETALLE BREAK BY DETALLE.CodCia BY DETALLE.NroCard BY DETALLE.CodDiv:
    ASSIGN
        x-Impnac = 0
        x-ImpUsa = 0
        x-Fotnac = 0
        x-FotUsa = 0.
    IF DETALLE.CodMon = 1
    THEN ASSIGN
            x-Impnac = DETALLE.Imptot
            x-Fotnac = DETALLE.Fotocopia.
    ELSE ASSIGN
            x-Impusa = DETALLE.Imptot
            x-Fotusa = DETALLE.Fotocopia.
    ACCUMULATE x-ImpNac (TOTAL BY DETALLE.NroCard BY DETALLE.CodDiv).
    ACCUMULATE x-ImpUsa (TOTAL BY DETALLE.NroCard BY DETALLE.CodDiv).
    ACCUMULATE x-FotNac (TOTAL BY DETALLE.NroCard BY DETALLE.CodDiv).
    ACCUMULATE x-FotUsa (TOTAL BY DETALLE.NroCard BY DETALLE.CodDiv).
    ACCUMULATE DETALLE.Puntos (TOTAL BY DETALLE.NroCard BY DETALLE.CodDiv).
    IF LAST-OF(DETALLE.CodDiv) THEN DO:
        x-NomCli = ''.
        FIND GN-CARD WHERE GN-CARD.NroCard = DETALLE.NroCard NO-LOCK NO-ERROR.
        IF AVAILABLE GN-CARD THEN x-NomCli = GN-CARD.NomCli[1].
        DISPLAY STREAM REPORT
            DETALLE.nrocard
            x-NomCli
            DETALLE.CodDiv
            DETALLE.codcli
            ACCUM TOTAL BY DETALLE.CodDiv x-ImpNac @ x-ImpNac
            ACCUM TOTAL BY DETALLE.CodDiv x-ImpUsa @ x-ImpUsa
            ACCUM TOTAL BY DETALLE.CodDiv x-FotNac @ x-FotNac
            ACCUM TOTAL BY DETALLE.CodDiv x-FotUsa @ x-FotUsa
            ACCUM TOTAL BY DETALLE.CodDiv DETALLE.Puntos @ DETALLE.Puntos
            WITH FRAME F-REPORTE.
    END.
    IF LAST-OF(DETALLE.NroCard) THEN DO:
        UNDERLINE STREAM REPORT
            x-ImpNac
            x-ImpUsa
            x-FotNac
            x-FotUsa
            WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT
            ACCUM TOTAL BY DETALLE.NroCard x-ImpNac @ x-ImpNac
            ACCUM TOTAL BY DETALLE.NroCard x-ImpUsa @ x-ImpUsa
            ACCUM TOTAL BY DETALLE.NroCard x-FotNac @ x-FotNac
            ACCUM TOTAL BY DETALLE.NroCard x-FotUsa @ x-FotUsa
            ACCUM TOTAL BY DETALLE.NroCard DETALLE.Puntos @ DETALLE.Puntos
            WITH FRAME F-REPORTE.
        DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-2 W-Win 
PROCEDURE Formato-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-ImpNac AS DEC FORMAT '>>>,>>>,>>9.99'.
  DEF VAR x-ImpUsa AS DEC FORMAT '>>>,>>>,>>9.99'.
  DEF VAR x-FotNac AS DEC FORMAT '>>>,>>>,>>9.99'.
  DEF VAR x-FotUsa AS DEC FORMAT '>>>,>>>,>>9.99'.
  DEF VAR x-NomCli AS CHAR.
  
  FOR EACH DETALLE  BREAK BY DETALLE.CodCia BY DETALLE.NroCard BY DETALLE.CodDiv BY DETALLE.FchDoc:
    x-NomCli = ''.
    FIND GN-CARD WHERE GN-CARD.NroCard = DETALLE.NroCard NO-LOCK NO-ERROR.
    IF AVAILABLE GN-CARD THEN x-NomCli = GN-CARD.NomCli[1].
    DEFINE FRAME F-REPORTE
      DETALLE.fchdoc       FORMAT '99/99/99'  COLUMN-LABEL 'Fecha'
      DETALLE.CodCli       FORMAT 'x(11)'     COLUMN-LABEL 'Codigo'
      DETALLE.nomcli       FORMAT 'x(40)'     COLUMN-LABEL 'Cliente'
      DETALLE.coddiv       FORMAT 'x(5)'      COLUMN-LABEL 'Division'
      DETALLE.coddoc                          COLUMN-LABEL 'Doc'
      DETALLE.nrodoc                          COLUMN-LABEL 'Numero'
      x-ImpNac          FORMAT '->,>>>,>>9.99'    COLUMN-LABEL 'Importe S/.'
      x-ImpUsa          FORMAT '->,>>>,>>9.99'    COLUMN-LABEL 'Importe US$'
      x-FotNac          FORMAT '->,>>>,>>9.99'    COLUMN-LABEL 'Fotocopia!Importe S/.'
      x-FotUsa          FORMAT '->,>>>,>>9.99'    COLUMN-LABEL 'Fotocopia!Importe US$'
      DETALLE.Puntos  FORMAT '->>>,>>9'       COLUMN-LABEL 'ContiPuntos'
      HEADER
           S-NOMCIA FORMAT "X(50)" SKIP
           "Pagina : " TO 90 PAGE-NUMBER(REPORT) TO 100 FORMAT "ZZZZZ9" SKIP
           "CONTIPUNTOS" AT 30
           " Fecha : " TO 90 TODAY TO 100 FORMAT "99/99/9999" SKIP
           "  Hora : " TO 90 STRING(TIME,"HH:MM:SS") TO 100 SKIP
           /*"CLIENTE:" DETALLE.NroCard FORMAT 'x(11)' GN-CARD.NomCli[1] FORMAT 'x(50)' SKIP*/
           "CLIENTE:" DETALLE.NroCard FORMAT 'x(11)' x-NomCli FORMAT 'x(50)' SKIP
           "DESDE EL" x-Fecha-1 "HASTA EL" x-Fecha-2 SKIP(1)
    WITH WIDTH 200 NO-BOX STREAM-IO DOWN.

    ASSIGN
        x-Impnac = 0
        x-ImpUsa = 0
        x-Fotnac = 0
        x-FotUsa = 0.
    IF DETALLE.CodMon = 1
    THEN ASSIGN
            x-Impnac = DETALLE.Imptot
            x-Fotnac = DETALLE.Fotocopia.
    ELSE ASSIGN
            x-Impusa = DETALLE.Imptot
            x-Fotusa = DETALLE.Fotocopia.
    ACCUMULATE x-ImpNac (TOTAL BY DETALLE.NroCard BY DETALLE.CodDiv).
    ACCUMULATE x-ImpUsa (TOTAL BY DETALLE.NroCard BY DETALLE.CodDiv).
    ACCUMULATE x-FotNac (TOTAL BY DETALLE.NroCard BY DETALLE.CodDiv).
    ACCUMULATE x-FotUsa (TOTAL BY DETALLE.NroCard BY DETALLE.CodDiv).
    ACCUMULATE DETALLE.Puntos (TOTAL BY DETALLE.NroCard BY DETALLE.CodDiv).
    DISPLAY STREAM REPORT
        DETALLE.fchdoc                          
        DETALLE.codcli
        DETALLE.nomcli
        DETALLE.coddiv
        DETALLE.coddoc                          
        DETALLE.nrodoc                          
        x-ImpNac WHEN x-ImpNac <> 0
        x-ImpUsa WHEN x-ImpUsa <> 0
        x-FotNac WHEN x-FotNac <> 0
        x-FotUsa WHEN x-FotUsa <> 0
        DETALLE.Puntos  
        WITH FRAME F-REPORTE.
    IF LAST-OF(DETALLE.CodDiv) THEN DO:
        UNDERLINE STREAM REPORT
            x-ImpNac
            x-ImpUsa
            x-FotNac
            x-FotUsa
            DETALLE.Puntos
            WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT
            'TOTAL DIVISION >>>' @ DETALLE.nomcli
            ACCUM TOTAL BY DETALLE.CodDiv x-ImpNac @ x-ImpNac
            ACCUM TOTAL BY DETALLE.CodDiv x-ImpUsa @ x-ImpUsa
            ACCUM TOTAL BY DETALLE.CodDiv x-FotNac @ x-FotNac
            ACCUM TOTAL BY DETALLE.CodDiv x-FotUsa @ x-FotUsa
            ACCUM TOTAL BY DETALLE.CodDiv DETALLE.Puntos @ DETALLE.Puntos
            WITH FRAME F-REPORTE.
    END.
    IF LAST-OF(DETALLE.NroCard) THEN DO:
        UNDERLINE STREAM REPORT
            x-ImpNac
            x-ImpUsa
            x-FotNac
            x-FotUsa
            DETALLE.Puntos
            WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT
            'TOTAL GENERAL >>>' @ DETALLE.nomcli
            ACCUM TOTAL BY DETALLE.NroCard x-ImpNac @ x-ImpNac
            ACCUM TOTAL BY DETALLE.NroCard x-ImpUsa @ x-ImpUsa
            ACCUM TOTAL BY DETALLE.NroCard x-FotNac @ x-FotNac
            ACCUM TOTAL BY DETALLE.NroCard x-FotUsa @ x-FotUsa
            ACCUM TOTAL BY DETALLE.NroCard DETALLE.Puntos @ DETALLE.Puntos
            WITH FRAME F-REPORTE.
        PAGE STREAM REPORT.
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
  DEF VAR x-Copias AS INT.
  
/*  RUN bin/_prnctr.p.*/
  RUN lib/imprimir2.
  IF s-salida-impresion = 0 THEN RETURN.
   
  /* Captura parametros de impresion */
  /* s-pagina-inicial,  s-pagina-final,  s-printer-name,  s-print-file,  s-nro-copias */
  
  RUN Carga-Temporal.
  FIND FIRST DETALLE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE DETALLE
  THEN DO:
    MESSAGE 'NO hay información a imprimir'
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
  END.
  
/*  RUN aderb/_prlist.p(
 *       OUTPUT s-printer-list,
 *       OUTPUT s-port-list,
 *       OUTPUT s-printer-count).
 *   s-port-name = ENTRY(LOOKUP(s-printer-name, s-printer-list), s-port-list).
 *   s-port-name = REPLACE(S-PORT-NAME, ":", "").*/

  IF s-salida-impresion = 1 THEN 
     s-print-file = SESSION:TEMP-DIRECTORY +
     STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".
  
  DO x-Copias = 1 TO s-nro-copias:
    CASE s-salida-impresion:
          WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
/*          WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */*/
          WHEN 2 THEN OUTPUT STREAM REPORT TO PRINTER             PAGED PAGE-SIZE 62. /* Impresora */
          WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
    END CASE.
    
    PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
    
    CASE RADIO-SET-1:
        WHEN 1 THEN RUN Formato-1.
        WHEN 2 THEN RUN Formato-2.
    END CASE.
    
    PAGE STREAM REPORT.
    OUTPUT STREAM REPORT CLOSE.
  END.
  CASE s-salida-impresion:
       WHEN 1 OR WHEN 3 THEN RUN LIB/W-README.R(s-print-file).
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
  ASSIGN
    x-Fecha-2 = TODAY
    x-Fecha-1 = TODAY - DAY(TODAY) + 1.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros W-Win 
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
        WHEN "" THEN .
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

