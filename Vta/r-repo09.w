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

DEF TEMP-TABLE t-cdoc LIKE ccbcdocu.
DEF TEMP-TABLE t-ddoc LIKE ccbddocu.
DEF BUFFER b-cdoc FOR ccbcdocu.

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
&Scoped-Define ENABLED-OBJECTS x-CodDiv x-FchDoc-1 x-FchDoc-2 RADIO-SET-1 ~
RADIO-SET-Comision BUTTON-1 Btn_Done BUTTON-4 
&Scoped-Define DISPLAYED-OBJECTS x-CodDiv x-FchDoc-1 x-FchDoc-2 RADIO-SET-1 ~
RADIO-SET-Comision x-mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Done DEFAULT 
     IMAGE-UP FILE "img\exit":U
     LABEL "&Done" 
     SIZE 7 BY 1.73
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\print1":U
     LABEL "Button 1" 
     SIZE 7 BY 1.73.

DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 4" 
     SIZE 7 BY 1.73.

DEFINE VARIABLE x-CodDiv AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Division" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todas" 
     DROP-DOWN-LIST
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE x-FchDoc-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Emitidos desde" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc-2 AS DATE FORMAT "99/99/99":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Vendedor", 1,
"Categoria", 2
     SIZE 10 BY 1.92 NO-UNDO.

DEFINE VARIABLE RADIO-SET-Comision AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Campaña", 1,
"No Campaña", 2
     SIZE 12 BY 1.62 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-CodDiv AT ROW 1.38 COL 15 COLON-ALIGNED
     x-FchDoc-1 AT ROW 2.35 COL 15 COLON-ALIGNED
     x-FchDoc-2 AT ROW 2.35 COL 33 COLON-ALIGNED
     RADIO-SET-1 AT ROW 3.31 COL 17 NO-LABEL
     RADIO-SET-Comision AT ROW 3.42 COL 41 NO-LABEL WIDGET-ID 4
     BUTTON-1 AT ROW 6.31 COL 4
     Btn_Done AT ROW 6.31 COL 13
     BUTTON-4 AT ROW 6.31 COL 22 WIDGET-ID 10
     x-mensaje AT ROW 6.65 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     "Periodo:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 3.69 COL 34 WIDGET-ID 8
     "Resumido por:" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 3.5 COL 7
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 69.86 BY 8.58
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
         TITLE              = "REPORTE DE COMISIONES"
         HEIGHT             = 8.58
         WIDTH              = 69.86
         MAX-HEIGHT         = 8.58
         MAX-WIDTH          = 69.86
         VIRTUAL-HEIGHT     = 8.58
         VIRTUAL-WIDTH      = 69.86
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REPORTE DE COMISIONES */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REPORTE DE COMISIONES */
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
ON CHOOSE OF Btn_Done IN FRAME F-Main /* Done */
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
  ASSIGN
    x-CodDiv x-FchDoc-1 x-FchDoc-2 RADIO-SET-1 RADIO-SET-Comision .
  RUN Imprimir.
  DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Button 4 */
DO:
    ASSIGN
        x-CodDiv x-FchDoc-1 x-FchDoc-2 RADIO-SET-1 RADIO-SET-Comision .

    CASE RADIO-SET-1:
        WHEN 1 THEN RUN Genera-Excel.
        WHEN 2 THEN RUN Genera-Excel-2.
    END CASE.
    
    DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.
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
  DEF VAR x-FchCan AS DATE NO-UNDO.
  DEF VAR x-ImpTot AS DEC NO-UNDO.

  FOR EACH T-CDOC:
    DELETE T-CDOC.
  END.
  FOR EACH T-DDOC:
    DELETE T-DDOC.
  END.
  
  /* PRIMERO: LOS COMPROBANTES DE VENTAS */
  /*
  DISPLAY 
    'Acumulando comprobantes' SKIP
    WITH FRAME f-Mensaje CENTERED OVERLAY VIEW-AS DIALOG-BOX.
  */
  DISPLAY 'Acumulando comprobantes' @ x-mensaje WITH FRAME {&FRAME-NAME}.

  FOR EACH GN-DIVI NO-LOCK WHERE GN-DIVI.codcia = s-codcia
      AND (x-CodDiv = 'Todas' OR GN-DIVI.coddiv = x-CodDiv):
      FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia
            AND LOOKUP(ccbcdocu.coddoc, 'FAC,BOL,TCK') > 0 
            AND ccbcdocu.coddiv = GN-DIVI.coddiv
            AND ccbcdocu.fchdoc >= x-FchDoc-1
            AND ccbcdocu.fchdoc <= x-FchDoc-2
            AND LOOKUP (ccbcdocu.tpofac, 'A,S') = 0     /* NO Facturas adelantadas ni servicios */
            AND ccbcdocu.flgest <> 'A':
        FIND t-cdoc of ccbcdocu no-lock no-error.
        IF NOT AVAILABLE t-cdoc THEN DO:
            CREATE t-cdoc.
            BUFFER-COPY ccbcdocu TO t-cdoc.
            FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK WHERE Ccbddocu.implin > 0:
                CREATE t-ddoc.
                BUFFER-COPY Ccbddocu TO t-ddoc
                    ASSIGN t-ddoc.implin = (Ccbddocu.implin - Ccbddocu.impigv) * (1 - Ccbcdocu.pordto / 100).
            END.
        END.        
      END.
  END.

  /* SEGUNDO: LAS NOTAS DE ABONO */
  /*
  DISPLAY 
    'Acumulando Notas de Abono' SKIP
    WITH FRAME f-Mensaje CENTERED OVERLAY VIEW-AS DIALOG-BOX.
  */
  DISPLAY 'Acumulando Notas de Abono' @ x-mensaje WITH FRAME {&FRAME-NAME}.

  DEFINE VAR x-Factor AS DEC NO-UNDO.
  DEFINE BUFFER b-cdocu FOR Ccbcdocu.
  DEFINE BUFFER b-ddocu FOR Ccbddocu.
  
  FOR EACH GN-DIVI NO-LOCK WHERE GN-DIVI.codcia = s-codcia
          AND (x-CodDiv = 'Todas' OR GN-DIVI.coddiv = x-CodDiv):
      FOR EACH CcbCdocu NO-LOCK WHERE CcbCdocu.CodCia = S-CODCIA 
            AND ccbcdocu.coddiv = GN-DIVI.coddiv
            AND CCbCdocu.FchDoc >= x-FchDoc-1
            AND CcbCdocu.FchDoc <= x-FchDoc-2
            AND CcbCdocu.CodDoc = "N/C" 
            AND CcbCDocu.FlgEst <> 'A'
            USE-INDEX LLAVE10:
        FIND B-CDOCU WHERE B-CDOCU.CODCIA = CCBCDOCU.CODCIA 
            AND B-CDOCU.CODDOC = CCBCDOCU.CODREF 
            AND B-CDOCU.NRODOC = CCBCDOCU.NROREF
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-CDOCU THEN NEXT.
        /* caso de factura adelantada */
        x-ImpTot = B-CDOCU.ImpTot.
        FIND FIRST Ccbddocu OF B-CDOCU WHERE Ccbddocu.implin < 0 NO-LOCK NO-ERROR.
        IF AVAILABLE Ccbddocu THEN x-ImpTot = x-ImpTot + ABSOLUTE(Ccbddocu.implin).
        /* ************************** */
        CREATE t-cdoc.
        BUFFER-COPY Ccbcdocu TO t-cdoc
            ASSIGN
                t-cdoc.codven = B-CDOCU.codven
                t-cdoc.fmapgo = B-CDOCU.fmapgo
                t-cdoc.pordto = B-CDOCU.pordto.
        CASE Ccbcdocu.cndcre:
            WHEN 'D' THEN DO:   /* Por devolucion */
                FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK:
                    CREATE t-ddoc.
                    BUFFER-COPY Ccbddocu TO t-ddoc
                        ASSIGN
                            t-ddoc.implin = (Ccbddocu.implin - Ccbddocu.impigv).
                END.
            END.
            OTHERWISE DO:
                IF B-CDOCU.codmon = Ccbcdocu.codmon
                THEN x-Factor = Ccbcdocu.imptot / x-imptot.
                ELSE IF B-CDOCU.codmon = 1
                    THEN x-Factor = (Ccbcdocu.imptot * Ccbcdocu.tpocmb) / x-imptot.
                    ELSE x-Factor = (Ccbcdocu.imptot / Ccbcdocu.tpocmb) / x-imptot.
                ASSIGN
                    t-cdoc.codmon = B-CDOCU.codmon.
                FOR EACH B-DDOCU OF B-CDOCU NO-LOCK WHERE B-DDOCU.implin > 0:
                    CREATE t-ddoc.
                    BUFFER-COPY B-DDOCU TO t-ddoc
                        ASSIGN
                            t-ddoc.coddoc = t-cdoc.coddoc
                            t-ddoc.nrodoc = t-cdoc.nrodoc
                            t-ddoc.implin = (B-DDOCU.implin - B-DDOCU.impigv) * x-Factor * (1 - B-CDOCU.PorDto / 100).
                END.
            END.
        END CASE.
      END.
  END.

  /*
  DISPLAY 
    'Calculando Comisiones' SKIP
    WITH FRAME f-Mensaje CENTERED OVERLAY VIEW-AS DIALOG-BOX.
  */
  DISPLAY 'Calculando Comisiones' @ x-mensaje WITH FRAME {&FRAME-NAME}.

  DEF VAR x-Signo AS INT NO-UNDO.
  
  /* TODAS LAS COMISIONES EN SOLES */
  FOR EACH t-cdoc:
    ASSIGN
        t-cdoc.imptot2 = 0.
    x-Signo = IF t-cdoc.coddoc = 'N/C' THEN -1 ELSE 1.
    DETALLE:
    FOR EACH t-ddoc OF t-cdoc, FIRST Almmmatg OF t-ddoc NO-LOCK WHERE Almmmatg.codfam <> '009':
        IF t-cdoc.codmon = 2 THEN t-ddoc.implin = t-ddoc.implin * t-cdoc.tpocmb.
        ASSIGN
            t-ddoc.Flg_Factor = Almmmatg.TipArt
            t-ddoc.ImpCto = 0.
        /* comisiones por rotacion */
        IF LOOKUP(TRIM(Almmmatg.Clase), 'A,B,C,D,E') > 0 THEN DO:
            FIND PorComi WHERE PorComi.CodCia = s-codcia AND PorComi.Catego = Almmmatg.Clase NO-LOCK NO-ERROR.
            IF AVAILABLE PorComi THEN DO:
                ASSIGN
                    t-ddoc.impcto = x-Signo * t-ddoc.implin * PorComi.Porcom / 100
                    t-cdoc.imptot2 = t-cdoc.imptot2 + t-ddoc.impcto.
                NEXT DETALLE.
            END.
        END.
        /* comisiones por linea */
        FIND FacTabla WHERE FacTabla.codcia = s-codcia
            AND FacTabla.Tabla = 'CV'
            AND FacTabla.Codigo = TRIM(Almmmatg.codfam) + t-cdoc.coddiv
            NO-LOCK NO-ERROR.
        IF AVAILABLE FacTabla THEN DO:
            IF RADIO-SET-Comision = 1 
                THEN ASSIGN
                        t-ddoc.impcto = x-Signo * t-ddoc.implin * FacTabla.Valor[1] / 100
                        t-cdoc.imptot2 = t-cdoc.imptot2 + t-ddoc.impcto.
            IF RADIO-SET-Comision = 2 
                THEN ASSIGN
                        t-ddoc.impcto = x-Signo * t-ddoc.implin * FacTabla.Valor[2] / 100
                        t-cdoc.imptot2 = t-cdoc.imptot2 + t-ddoc.impcto.
        END.            
        ASSIGN
            t-ddoc.implin = x-Signo * t-ddoc.implin.
    END.
  END.
  
  HIDE FRAME f-Mensaje.
      
END PROCEDURE.

/*
  /* SEGUNDO: LAS NOTAS DE ABONO */
  DISPLAY 
    'Acumulando Notas de Abono' SKIP
    WITH FRAME f-Mensaje CENTERED OVERLAY VIEW-AS DIALOG-BOX.
  DEFINE BUFFER bt-cdoc FOR t-cdoc.
  DEFINE BUFFER bt-ddoc FOR t-ddoc.
  DEFINE VAR x-Factor AS DEC NO-UNDO.
  
  FOR EACH t-cdoc:
    FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
            AND Ccbcdocu.coddoc = 'N/C'
            AND Ccbcdocu.codref = t-cdoc.coddoc
            AND Ccbcdocu.nroref = t-cdoc.nrodoc
            AND Ccbcdocu.flgest <> 'A':
        CREATE bt-cdoc.
        BUFFER-COPY Ccbcdocu TO bt-cdoc
            ASSIGN
                bt-cdoc.coddiv = t-cdoc.coddiv
                bt-cdoc.codven = t-cdoc.codven
                bt-cdoc.fmapgo = t-cdoc.fmapgo
                bt-cdoc.pordto = t-cdoc.pordto.
        CASE Ccbcdocu.cndcre:
            WHEN 'D' THEN DO:   /* Por devolucion */
                FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK:
                    CREATE t-ddoc.
                    BUFFER-COPY Ccbddocu TO t-ddoc
                        ASSIGN
                            t-ddoc.implin = Ccbddocu.implin - Ccbddocu.impigv.
                END.
            END.
            OTHERWISE DO:
                IF t-cdoc.codmon = Ccbcdocu.codmon
                THEN x-Factor = Ccbcdocu.imptot / t-cdoc.imptot.
                ELSE IF t-cdoc.codmon = 1
                    THEN x-Factor = (Ccbcdocu.imptot / Ccbcdocu.tpocmb) / t-cdoc.imptot.
                    ELSE x-Factor = (Ccbcdocu.imptot * Ccbcdocu.tpocmb) / t-cdoc.imptot.
                ASSIGN
                    bt-cdoc.codmon = t-cdoc.codmon.
                FOR EACH t-ddoc OF t-cdoc:
                    CREATE bt-ddoc.
                    BUFFER-COPY t-ddoc TO bt-ddoc
                        ASSIGN
                            bt-ddoc.coddoc = Ccbcdocu.coddoc
                            bt-ddoc.nrodoc = Ccbcdocu.nrodoc
                            bt-ddoc.implin = (t-ddoc.implin - t-ddoc.impigv) * x-Factor.
                END.
            END.
        END CASE.
    END.            
  END.
*/

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
  DISPLAY x-CodDiv x-FchDoc-1 x-FchDoc-2 RADIO-SET-1 RADIO-SET-Comision 
          x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE x-CodDiv x-FchDoc-1 x-FchDoc-2 RADIO-SET-1 RADIO-SET-Comision BUTTON-1 
         Btn_Done BUTTON-4 
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
  DEF VAR x-NomVen LIKE Gn-Ven.NomVen NO-UNDO.
  DEF VAR x-ImpLin1 AS DEC NO-UNDO.
  DEF VAR x-ImpLin2 AS DEC NO-UNDO.
  DEF VAR x-ImpCom1 AS DEC NO-UNDO.
  DEF VAR x-ImpCom2 AS DEC NO-UNDO.
  
  DEFINE FRAME FC-REP
      t-cdoc.codven       COLUMN-LABEL "Vendedor"      
      almmmatg.codfam   COLUMN-LABEL "Familia"
      almtfami.desfam   COLUMN-LABEL "Descripción" FORMAT "x(15)"
      t-ddoc.implin       COLUMN-LABEL "Importe Total S/."    FORMAT "(>>>,>>>,>>9.99)"
      x-implin1           COLUMN-LABEL "Importe Total Contado S/."    FORMAT "(>>>,>>>,>>9.99)"
      x-implin2           COLUMN-LABEL "Importe Total Crédito S/."    FORMAT "(>>>,>>>,>>9.99)"
      x-impcom1           COLUMN-LABEL "Comision Contado S/." FORMAT "(>>>,>>>,>>9.99)"
      x-impcom2           COLUMN-LABEL "Comision Crédito S/." FORMAT "(>>>,>>>,>>9.99)"
    WITH WIDTH 160 NO-BOX STREAM-IO DOWN. 

  DEFINE FRAME H-REP
    HEADER
    S-NOMCIA FORMAT "X(45)" SKIP
    "( " + x-CODDIV + ")"  FORMAT "X(15)"
    "REPORTE DE COMISIONES" AT 40
    "Pag.  : " AT 100 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
    "Fecha : " AT 100 STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
    "Division(es):" x-CodDiv:SCREEN-VALUE IN FRAME {&FRAME-NAME} SKIP
    "Emitidos desde:" x-FchDoc-1
    "hasta:" x-FchDoc-2 SKIP
    "IMPORTES SIN IGV" SKIP(1)
    WITH PAGE-TOP WIDTH 160 NO-BOX NO-LABELS STREAM-IO /*CENTERED*/ NO-UNDERLINE DOWN. 

  FOR EACH t-cdoc, each t-ddoc of t-cdoc, 
      first almmmatg of t-ddoc no-lock,
      FIRST almtfami OF almmmatg NO-LOCK
        BREAK BY t-cdoc.codcia BY t-cdoc.codven BY almmmatg.codfam:
    VIEW STREAM REPORT FRAME H-REP.
    IF FIRST-OF(t-cdoc.codven)
    THEN DO:
        x-NomVen = "".
        FIND gn-ven WHERE gn-ven.codcia = s-codcia
            AND gn-ven.codven = t-cdoc.codven
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-ven THEN x-nomven = gn-ven.nomven.
        DISPLAY STREAM REPORT 
            t-cdoc.codven 
            x-nomven @ almtfami.desfam
            WITH FRAME FC-REP.
        UNDERLINE STREAM REPORT
            t-cdoc.codven
            almtfami.desfam
            WITH FRAME FC-REP.
    END.
    ASSIGN
        x-implin1 = 0
        x-implin2 = 0
        x-impcom1 = 0
        x-impcom2 = 0.
    IF LOOKUP(t-cdoc.fmapgo, '000,001,002') > 0 
        THEN ASSIGN
                x-implin1 = t-ddoc.implin
                x-impcom1 = t-ddoc.impcto.
        ELSE ASSIGN 
                x-implin2 = t-ddoc.implin
                x-impcom2 = t-ddoc.impcto.
    ACCUMULATE t-ddoc.implin (SUB-TOTAL BY almmmatg.codfam).
    ACCUMULATE x-implin1     (SUB-TOTAL BY almmmatg.codfam).
    ACCUMULATE x-implin2     (SUB-TOTAL BY almmmatg.codfam).
    ACCUMULATE x-impcom1     (SUB-TOTAL BY almmmatg.codfam).
    ACCUMULATE x-impcom2     (SUB-TOTAL BY almmmatg.codfam).
    ACCUMULATE t-ddoc.implin (SUB-TOTAL BY t-cdoc.codven).
    ACCUMULATE x-implin1     (SUB-TOTAL BY t-cdoc.codven).
    ACCUMULATE x-implin2     (SUB-TOTAL BY t-cdoc.codven).
    ACCUMULATE x-impcom1     (SUB-TOTAL BY t-cdoc.codven).
    ACCUMULATE x-impcom2     (SUB-TOTAL BY t-cdoc.codven).
    ACCUMULATE t-ddoc.implin (SUB-TOTAL BY t-cdoc.codcia).
    ACCUMULATE x-implin1     (SUB-TOTAL BY t-cdoc.codcia).
    ACCUMULATE x-implin2     (SUB-TOTAL BY t-cdoc.codcia).
    ACCUMULATE x-impcom1     (SUB-TOTAL BY t-cdoc.codcia).
    ACCUMULATE x-impcom2     (SUB-TOTAL BY t-cdoc.codcia).
    IF LAST-OF(Almmmatg.codfam) 
    THEN DO:
        DISPLAY STREAM REPORT
            Almmmatg.codfam
            Almtfami.desfam
            ACCUM SUB-TOTAL BY Almmmatg.codfam t-ddoc.implin @ t-ddoc.implin
            ACCUM SUB-TOTAL BY Almmmatg.codfam x-implin1 @ x-implin1
            ACCUM SUB-TOTAL BY Almmmatg.codfam x-implin2 @ x-implin2
            ACCUM SUB-TOTAL BY Almmmatg.codfam x-impcom1 @ x-impcom1
            ACCUM SUB-TOTAL BY Almmmatg.codfam x-impcom2 @ x-impcom2
            WITH FRAME FC-REP.
    END.
    IF LAST-OF(t-cdoc.codven)
    THEN DO:
        UNDERLINE STREAM REPORT
            x-implin1
            x-implin2
            x-impcom1
            x-impcom2
            WITH FRAME FC-REP.
        DISPLAY STREAM REPORT
            ACCUM SUB-TOTAL BY t-cdoc.codven t-ddoc.implin @ t-ddoc.implin
            ACCUM SUB-TOTAL BY t-cdoc.codven x-implin1 @ x-implin1
            ACCUM SUB-TOTAL BY t-cdoc.codven x-implin2 @ x-implin2
            ACCUM SUB-TOTAL BY t-cdoc.codven x-impcom1 @ x-impcom1
            ACCUM SUB-TOTAL BY t-cdoc.codven x-impcom2 @ x-impcom2
            WITH FRAME FC-REP.
    END.
  END.  

END PROCEDURE.

/*
  DEF VAR x-ImpNac AS DEC NO-UNDO.
  DEF VAR x-ImpUsa AS DEC NO-UNDO.
  DEF VAR x-CtoNac AS DEC NO-UNDO.
  DEF VAR x-CtoUsa AS DEC NO-UNDO.
  DEF VAR x-NomVen LIKE Gn-Ven.NomVen NO-UNDO.
  
  DEFINE FRAME FC-REP
    t-cdoc.codven       COLUMN-LABEL "Vendedor"      
    x-nomven            COLUMN-LABEL "Nombre"
    t-cdoc.imptot2      COLUMN-LABEL "Comision S/."  FORMAT "(>>>,>>>,>>9.99)"
    WITH WIDTH 80 NO-BOX STREAM-IO DOWN. 

  DEFINE FRAME H-REP
    HEADER
    S-NOMCIA FORMAT "X(45)" SKIP
    "( " + x-CODDIV + ")"  FORMAT "X(15)"
    "REPORTE DE COMISIONES" AT 20
    "Pag.  : " AT 60 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
    "Fecha : " AT 60 STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
    "Division(es):" x-CodDiv:SCREEN-VALUE IN FRAME {&FRAME-NAME} SKIP
    "Emitidos desde:" x-FchDoc-1
    "hasta:" x-FchDoc-2 SKIP(1)
    WITH PAGE-TOP WIDTH 80 NO-BOX NO-LABELS STREAM-IO CENTERED DOWN. 

  FOR EACH t-cdoc
        BREAK BY t-cdoc.codcia BY t-cdoc.codven BY t-cdoc.coddoc:
    VIEW STREAM REPORT FRAME H-REP.
    ACCUMULATE t-cdoc.imptot2 (SUB-TOTAL BY t-cdoc.codven).
    IF LAST-OF(t-cdoc.codven)
    THEN DO:
        x-NomVen = ''.
        FIND Gn-Ven WHERE Gn-Ven.codcia = t-cdoc.codcia
            AND Gn-Ven.codven = t-cdoc.codven
            NO-LOCK NO-ERROR.
        IF AVAILABLE Gn-Ven THEN x-NomVen = Gn-Ven.NomVen.
        DISPLAY STREAM REPORT
            t-cdoc.codven 
            x-NomVen 
            ACCUM SUB-TOTAL BY t-cdoc.codven t-cdoc.imptot2 @ t-cdoc.imptot2
            WITH FRAME FC-REP.
    END.
  END.  
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-2 W-Win 
PROCEDURE Formato-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-ImpNac AS DEC NO-UNDO.
  DEF VAR x-ImpUsa AS DEC NO-UNDO.
  DEF VAR x-ImpCto1 AS DEC NO-UNDO.
  DEF VAR x-ImpCto2 AS DEC NO-UNDO.
  
  DEFINE FRAME FC-REP
    t-cdoc.codven       COLUMN-LABEL "Vendedor"      
    gn-ven.nomven       COLUMN-LABEL "Nombre"
    t-ddoc.Flg_Factor   COLUMN-LABEL 'Clase'
    x-impcto1           COLUMN-LABEL "Comision Contado S/."  FORMAT "(>>>,>>>,>>9.99)"
    x-impcto2           COLUMN-LABEL "Comision Crédito S/."  FORMAT "(>>>,>>>,>>9.99)"
    WITH WIDTH 160 NO-BOX STREAM-IO DOWN. 

  DEFINE FRAME H-REP
    HEADER
    S-NOMCIA FORMAT "X(45)" SKIP
    "( " + x-CODDIV + ")"  FORMAT "X(15)"
    "REPORTE DE COMISIONES" AT 40
    "Pag.  : " AT 100 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
    "Fecha : " AT 100 STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
    "Division(es):" x-CodDiv:SCREEN-VALUE IN FRAME {&FRAME-NAME} SKIP
    "Emitidos desde:" x-FchDoc-1
    "hasta:" x-FchDoc-2 SKIP
    "IMPORTES SIN IGV" SKIP(1)
    WITH PAGE-TOP WIDTH 160 NO-BOX NO-LABELS STREAM-IO /*CENTERED*/ NO-UNDERLINE DOWN. 

  FOR EACH t-cdoc,
         EACH t-ddoc OF t-cdoc,
        FIRST gn-ven OF t-cdoc NO-LOCK
        BREAK BY t-cdoc.codcia BY t-cdoc.codven BY t-ddoc.flg_factor:
    VIEW STREAM REPORT FRAME H-REP.
    IF FIRST-OF(t-cdoc.codven)
    THEN DO:
        DISPLAY STREAM REPORT
            t-cdoc.codven 
            gn-ven.NomVen 
            WITH FRAME FC-REP.
    END.
    ASSIGN
        x-impcto1 = 0
        x-impcto2 = 0.
    IF LOOKUP(t-cdoc.fmapgo, '000,001,002') > 0 
        THEN ASSIGN
                x-impcto1 = t-ddoc.impcto.
        ELSE ASSIGN 
                x-impcto2 = t-ddoc.impcto.
    ACCUMULATE x-impcto1     (SUB-TOTAL BY t-ddoc.flg_factor).
    ACCUMULATE x-impcto2     (SUB-TOTAL BY t-ddoc.flg_factor).
    ACCUMULATE x-impcto1     (SUB-TOTAL BY t-cdoc.codven).
    ACCUMULATE x-impcto2     (SUB-TOTAL BY t-cdoc.codven).
    IF LAST-OF(t-ddoc.flg_factor)
    THEN DO:
        DISPLAY STREAM REPORT
            t-ddoc.flg_factor
            ACCUM SUB-TOTAL BY t-ddoc.flg_factor x-impcto1 @ x-impcto1
            ACCUM SUB-TOTAL BY t-ddoc.flg_factor x-impcto2 @ x-impcto2
            WITH FRAME FC-REP.
    END.
    IF LAST-OF(t-cdoc.codven)
    THEN DO:
        UNDERLINE STREAM REPORT
            x-impcto1
            x-impcto2
            WITH FRAME FC-REP.
        DISPLAY STREAM REPORT
            ACCUM SUB-TOTAL BY t-cdoc.codven x-impcto1 @ x-impcto1
            ACCUM SUB-TOTAL BY t-cdoc.codven x-impcto2 @ x-impcto2
            WITH FRAME FC-REP.
    END.
  END.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Excel W-Win 
PROCEDURE Genera-Excel :
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
DEFINE VARIABLE t-Column                AS INTEGER INIT 2.

DEFINE VAR x-NomVen LIKE Gn-Ven.NomVen NO-UNDO.
DEFINE VAR x-ImpLin1 AS DEC NO-UNDO.
DEFINE VAR x-ImpLin2 AS DEC NO-UNDO.
DEFINE VAR x-ImpCom1 AS DEC NO-UNDO.
DEFINE VAR x-ImpCom2 AS DEC NO-UNDO.
  
RUN Carga-Temporal.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:COLUMNS("A"):ColumnWidth = 14.
chWorkSheet:COLUMNS("B"):ColumnWidth = 30.
chWorkSheet:COLUMNS("C"):ColumnWidth = 30.
chWorkSheet:COLUMNS("D"):ColumnWidth = 30.
chWorkSheet:COLUMNS("E"):ColumnWidth = 30.
chWorkSheet:COLUMNS("F"):ColumnWidth = 30.
chWorkSheet:COLUMNS("G"):ColumnWidth = 30.

chWorkSheet:Range("A1: M2"):FONT:Bold = TRUE.
chWorkSheet:Range("A2"):VALUE = "Division".
chWorkSheet:Range("B2"):VALUE = "Vendedor".
chWorkSheet:Range("C2"):VALUE = "Familia".
chWorkSheet:Range("D2"):VALUE = "Importe Total S/.".
chWorkSheet:Range("E2"):VALUE = "Importe Total Contado S/.".
chWorkSheet:Range("F2"):VALUE = "Importe Total Crédito S/.".
chWorkSheet:Range("G2"):VALUE = "Comision Contado S/.".
chWorkSheet:Range("H2"):VALUE = "Comisión Crédito S/.".

chWorkSheet:COLUMNS("A"):NumberFormat = "@".


chWorkSheet = chExcelApplication:Sheets:Item(1).

RUN Carga-Temporal.

FOR EACH t-cdoc, each t-ddoc of t-cdoc, 
    FIRST almmmatg of t-ddoc NO-LOCK,
        FIRST almtfami OF almmmatg NO-LOCK
    BREAK BY t-cdoc.codcia 
          BY t-cdoc.coddiv
          BY t-cdoc.codven 
          BY almmmatg.codfam:

    IF FIRST-OF(t-cdoc.codven) THEN DO:
        x-NomVen = "".
        FIND gn-ven WHERE gn-ven.codcia = s-codcia
            AND gn-ven.codven = t-cdoc.codven NO-LOCK NO-ERROR.
        IF AVAILABLE gn-ven THEN x-nomven = gn-ven.nomven.
    END.
    ASSIGN
        x-implin1 = 0
        x-implin2 = 0
        x-impcom1 = 0
        x-impcom2 = 0.
    IF LOOKUP(t-cdoc.fmapgo, '000,001,002') > 0 
        THEN ASSIGN
                x-implin1 = t-ddoc.implin
                x-impcom1 = t-ddoc.impcto.
        ELSE ASSIGN 
                x-implin2 = t-ddoc.implin
                x-impcom2 = t-ddoc.impcto.
    ACCUMULATE t-ddoc.implin (SUB-TOTAL BY almmmatg.codfam).
    ACCUMULATE x-implin1     (SUB-TOTAL BY almmmatg.codfam).
    ACCUMULATE x-implin2     (SUB-TOTAL BY almmmatg.codfam).
    ACCUMULATE x-impcom1     (SUB-TOTAL BY almmmatg.codfam).
    ACCUMULATE x-impcom2     (SUB-TOTAL BY almmmatg.codfam).
    ACCUMULATE t-ddoc.implin (SUB-TOTAL BY t-cdoc.codven).
    ACCUMULATE x-implin1     (SUB-TOTAL BY t-cdoc.codven).
    ACCUMULATE x-implin2     (SUB-TOTAL BY t-cdoc.codven).
    ACCUMULATE x-impcom1     (SUB-TOTAL BY t-cdoc.codven).
    ACCUMULATE x-impcom2     (SUB-TOTAL BY t-cdoc.codven).
    ACCUMULATE t-ddoc.implin (SUB-TOTAL BY t-cdoc.codcia).
    ACCUMULATE x-implin1     (SUB-TOTAL BY t-cdoc.codcia).
    ACCUMULATE x-implin2     (SUB-TOTAL BY t-cdoc.codcia).
    ACCUMULATE x-impcom1     (SUB-TOTAL BY t-cdoc.codcia).
    ACCUMULATE x-impcom2     (SUB-TOTAL BY t-cdoc.codcia).
    IF LAST-OF(Almmmatg.codfam) 
    THEN DO:
        t-column = t-column + 1.
        cColumn = STRING(t-Column).      
        cRange = "A" + cColumn.   
        chWorkSheet:Range(cRange):Value = t-cdoc.coddiv.
        cRange = "B" + cColumn.   
        chWorkSheet:Range(cRange):Value = t-cdoc.codven + '-' + x-nomven.
        cRange = "C" + cColumn.   
        chWorkSheet:Range(cRange):Value = Almmmatg.codfam + '-' + Almtfami.desfam.
        cRange = "D" + cColumn.   
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY Almmmatg.codfam t-ddoc.implin.
        cRange = "E" + cColumn.   
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY Almmmatg.codfam x-implin1.
        cRange = "F" + cColumn.   
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY Almmmatg.codfam x-implin2.
        cRange = "G" + cColumn.   
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY Almmmatg.codfam x-impcom1.
        cRange = "H" + cColumn.   
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY Almmmatg.codfam x-impcom2.
    END.
    /***
    IF LAST-OF(t-cdoc.codven) THEN DO:

        UNDERLINE STREAM REPORT
            x-implin1
            x-implin2
            x-impcom1
            x-impcom2
            WITH FRAME FC-REP.
        DISPLAY STREAM REPORT
            ACCUM SUB-TOTAL BY t-cdoc.codven t-ddoc.implin @ t-ddoc.implin
            ACCUM SUB-TOTAL BY t-cdoc.codven x-implin1 @ x-implin1
            ACCUM SUB-TOTAL BY t-cdoc.codven x-implin2 @ x-implin2
            ACCUM SUB-TOTAL BY t-cdoc.codven x-impcom1 @ x-impcom1
            ACCUM SUB-TOTAL BY t-cdoc.codven x-impcom2 @ x-impcom2
            WITH FRAME FC-REP.
    END.
    */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Excel-2 W-Win 
PROCEDURE Genera-Excel-2 :
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
DEFINE VARIABLE t-Column                AS INTEGER INIT 2.

DEFINE VAR x-NomVen LIKE Gn-Ven.NomVen NO-UNDO.
 
DEF VAR x-ImpNac AS DEC NO-UNDO.
DEF VAR x-ImpUsa AS DEC NO-UNDO.
DEF VAR x-ImpCto1 AS DEC NO-UNDO.
DEF VAR x-ImpCto2 AS DEC NO-UNDO.

RUN Carga-Temporal.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:COLUMNS("A"):ColumnWidth = 14.
chWorkSheet:COLUMNS("B"):ColumnWidth = 30.
chWorkSheet:COLUMNS("C"):ColumnWidth = 30.
chWorkSheet:COLUMNS("D"):ColumnWidth = 30.
chWorkSheet:COLUMNS("E"):ColumnWidth = 30.
chWorkSheet:COLUMNS("F"):ColumnWidth = 30.
chWorkSheet:COLUMNS("G"):ColumnWidth = 30.

chWorkSheet:Range("A1: M2"):FONT:Bold = TRUE.
chWorkSheet:Range("A2"):VALUE = "Division".
chWorkSheet:Range("B2"):VALUE = "Vendedor".
chWorkSheet:Range("C2"):VALUE = "Clase".
chWorkSheet:Range("D2"):VALUE = "Comisión Contado S/.".
chWorkSheet:Range("E2"):VALUE = "Comisión Crédito S/.".

chWorkSheet:COLUMNS("A"):NumberFormat = "@".

chWorkSheet = chExcelApplication:Sheets:Item(1).

RUN Carga-Temporal.

FOR EACH t-cdoc,
    EACH t-ddoc OF t-cdoc NO-LOCK
        BREAK BY t-cdoc.codcia 
              BY t-cdoc.coddiv 
              BY t-cdoc.codven 
              BY t-ddoc.flg_factor:

    IF FIRST-OF(t-cdoc.codven) THEN DO:
/*         DISPLAY STREAM REPORT  */
/*             t-cdoc.codven      */
/*             gn-ven.NomVen      */
/*             WITH FRAME FC-REP. */
        x-NomVen = "".
        FIND gn-ven WHERE gn-ven.codcia = s-codcia
            AND gn-ven.codven = t-cdoc.codven NO-LOCK NO-ERROR.
        IF AVAILABLE gn-ven THEN x-nomven = gn-ven.nomven.
    END.
    ASSIGN
        x-impcto1 = 0
        x-impcto2 = 0.
    IF LOOKUP(t-cdoc.fmapgo, '000,001,002') > 0 
        THEN ASSIGN
                x-impcto1 = t-ddoc.impcto.
        ELSE ASSIGN 
                x-impcto2 = t-ddoc.impcto.
    ACCUMULATE x-impcto1     (SUB-TOTAL BY t-ddoc.flg_factor).
    ACCUMULATE x-impcto2     (SUB-TOTAL BY t-ddoc.flg_factor).
    ACCUMULATE x-impcto1     (SUB-TOTAL BY t-cdoc.codven).
    ACCUMULATE x-impcto2     (SUB-TOTAL BY t-cdoc.codven).
    
    IF LAST-OF(t-ddoc.flg_factor) THEN DO:
/*         DISPLAY STREAM REPORT                                          */
/*             t-ddoc.flg_factor                                          */
/*             ACCUM SUB-TOTAL BY t-ddoc.flg_factor x-impcto1 @ x-impcto1 */
/*             ACCUM SUB-TOTAL BY t-ddoc.flg_factor x-impcto2 @ x-impcto2 */
/*             WITH FRAME FC-REP.                                         */

        t-column = t-column + 1.
        cColumn = STRING(t-Column).      
        cRange = "A" + cColumn.   
        chWorkSheet:Range(cRange):Value = t-cdoc.coddiv.
        cRange = "B" + cColumn.   
        chWorkSheet:Range(cRange):Value = t-cdoc.codven + '-' + x-nomven.
        cRange = "C" + cColumn.   
        chWorkSheet:Range(cRange):Value = t-ddoc.flg_factor.
        cRange = "D" + cColumn.   
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY t-ddoc.flg_factor x-impcto1.
        cRange = "E" + cColumn.   
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY t-ddoc.flg_factor x-impcto2.


    END.

/*    IF LAST-OF(t-cdoc.codven) THEN DO:                                  */

/*         UNDERLINE STREAM REPORT                                    */
/*             x-impcto1                                              */
/*             x-impcto2                                              */
/*             WITH FRAME FC-REP.                                     */
/*         DISPLAY STREAM REPORT                                      */
/*             ACCUM SUB-TOTAL BY t-cdoc.codven x-impcto1 @ x-impcto1 */
/*             ACCUM SUB-TOTAL BY t-cdoc.codven x-impcto2 @ x-impcto2 */
/*             WITH FRAME FC-REP.                                     */


/*    END.*/
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir W-Win 
PROCEDURE Imprimir :
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
        CASE RADIO-SET-1:
            WHEN 1 THEN RUN Formato.
            WHEN 2 THEN RUN Formato-2.
        END CASE.
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
    FOR EACH Gn-divi NO-LOCK WHERE Gn-divi.codcia = s-codcia:
        x-CodDiv:ADD-LAST(Gn-divi.coddiv).
    END.
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

