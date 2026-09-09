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

DEF TEMP-TABLE t-cdoc LIKE ccbcdocu.
DEF TEMP-TABLE t-ddoc LIKE ccbddocu.
DEF BUFFER b-cdoc FOR ccbcdocu.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS x-CodDiv x-FchDoc-1 x-FchDoc-2 RADIO-SET-1 ~
BUTTON-1 Btn_Done 
&Scoped-Define DISPLAYED-OBJECTS x-CodDiv x-FchDoc-1 x-FchDoc-2 RADIO-SET-1 

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

DEFINE VARIABLE x-CodDiv AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Division" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todas" 
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE x-FchDoc-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Emitidos desde" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc-2 AS DATE FORMAT "99/99/99":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Vendedor", 1,
"Categoria", 2
     SIZE 10 BY 1.92 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-CodDiv AT ROW 1.38 COL 15 COLON-ALIGNED
     x-FchDoc-1 AT ROW 2.35 COL 15 COLON-ALIGNED
     x-FchDoc-2 AT ROW 2.35 COL 33 COLON-ALIGNED
     RADIO-SET-1 AT ROW 3.31 COL 17 NO-LABEL
     BUTTON-1 AT ROW 6 COL 4
     Btn_Done AT ROW 6 COL 13
     "Resumido por:" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 3.5 COL 7
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 69.86 BY 8.92
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
         HEIGHT             = 7.62
         WIDTH              = 69.86
         MAX-HEIGHT         = 18.81
         MAX-WIDTH          = 84.43
         VIRTUAL-HEIGHT     = 18.81
         VIRTUAL-WIDTH      = 84.43
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
   L-To-R                                                               */
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
    x-CodDiv x-FchDoc-1 x-FchDoc-2 RADIO-SET-1.
  RUN Imprimir.
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
  DEF VAR x-FchCan AS DATE NO-UNDO.

  FOR EACH T-CDOC:
    DELETE T-CDOC.
  END.
  FOR EACH T-DDOC:
    DELETE T-DDOC.
  END.
  
  /* PRIMERO: LOS COMPROBANTES DE VENTAS */
  DISPLAY 
    'Acumulando comprobantes' SKIP
    WITH FRAME f-Mensaje CENTERED OVERLAY VIEW-AS DIALOG-BOX.
  FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia
        AND LOOKUP(ccbcdocu.coddoc, 'FAC,BOL,TCK') > 0 
        AND (x-CodDiv = 'Todas' OR ccbcdocu.coddiv = x-CodDiv)
        AND ccbcdocu.fchdoc >= x-FchDoc-1
        AND ccbcdocu.fchdoc <= x-FchDoc-2
        AND ccbcdocu.flgest <> 'A':
    FIND t-cdoc of ccbcdocu no-lock no-error.
    IF NOT AVAILABLE t-cdoc THEN DO:
        CREATE t-cdoc.
        BUFFER-COPY ccbcdocu TO t-cdoc.
        FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK:
            CREATE t-ddoc.
            BUFFER-COPY Ccbddocu TO t-ddoc
                ASSIGN t-ddoc.implin = Ccbddocu.implin - Ccbddocu.impigv.
        END.
    END.        
  END.
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

  /* SEGUNDO: LAS NOTAS DE ABONO */
  DISPLAY 
    'Acumulando Notas de Abono' SKIP
    WITH FRAME f-Mensaje CENTERED OVERLAY VIEW-AS DIALOG-BOX.
  DEFINE VAR x-Factor AS DEC NO-UNDO.
  DEFINE BUFFER b-cdoc FOR Ccbcdocu.
  
  FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia
        AND ccbcdocu.coddoc = 'N/C'
        AND (x-CodDiv = 'Todas' OR ccbcdocu.coddiv = x-CodDiv)
        AND ccbcdocu.fchdoc >= x-FchDoc-1
        AND ccbcdocu.fchdoc <= x-FchDoc-2
        AND ccbcdocu.flgest <> 'A':
    FIND b-cdoc WHERE b-cdoc.codcia = ccbcdocu.codcia
        AND b-cdoc.coddoc = ccbcdocu.codref
        AND b-cdoc.nrodoc = ccbcdocu.nroref
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE b-cdoc THEN NEXT.    
    CREATE t-cdoc.
    BUFFER-COPY Ccbcdocu TO t-cdoc
        ASSIGN
            t-cdoc.coddiv = b-cdoc.coddiv
            t-cdoc.codven = b-cdoc.codven
            t-cdoc.fmapgo = b-cdoc.fmapgo
            t-cdoc.pordto = b-cdoc.pordto.
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
            IF t-cdoc.codmon = b-cdoc.codmon
            THEN x-Factor = t-cdoc.imptot / b-cdoc.imptot.
            ELSE IF t-cdoc.codmon = 1
                THEN x-Factor = (t-cdoc.imptot / t-cdoc.tpocmb) / b-cdoc.imptot.
                ELSE x-Factor = (t-cdoc.imptot * t-cdoc.tpocmb) / b-cdoc.imptot.
            FOR EACH ccbddocu OF b-cdoc:
                CREATE t-ddoc.
                BUFFER-COPY ccbddocu TO t-ddoc
                    ASSIGN
                        t-ddoc.coddoc = t-cdoc.coddoc
                        t-ddoc.nrodoc = t-cdoc.nrodoc
                        t-ddoc.implin = (ccbddocu.implin - ccbddocu.impigv) * x-Factor.
            END.
        END.
    END CASE.
  END.



  DISPLAY 
    'Calculando Comisiones' SKIP
    WITH FRAME f-Mensaje CENTERED OVERLAY VIEW-AS DIALOG-BOX.
  DEF VAR x-Signo AS INT NO-UNDO.
  
  /* TODAS LAS COMISIONES EN SOLES */
  FOR EACH t-cdoc:
    ASSIGN
        t-cdoc.imptot2 = 0.
    x-Signo = IF t-cdoc.coddoc = 'N/C' THEN -1 ELSE 1.
    FOR EACH t-ddoc OF t-cdoc, FIRST Almmmatg OF t-ddoc NO-LOCK:
        IF t-cdoc.codmon = 2 THEN t-ddoc.implin = t-ddoc.implin * t-cdoc.tpocmb.
        ASSIGN
            t-ddoc.Flg_Factor = Almmmatg.TipArt
            t-ddoc.ImpCto = 0.
        /* comisiones por rotacion */
        IF LOOKUP(TRIM(Almmmatg.TipArt), 'A,B,C,D,E') > 0 THEN DO:
            FIND PorComi WHERE PorComi.Catego = Almmmatg.TipArt NO-LOCK NO-ERROR.
            IF AVAILABLE PorComi THEN DO:
                ASSIGN
                    t-ddoc.impcto = x-Signo * t-ddoc.implin * PorComi.Porcom / 100
                    t-cdoc.imptot2 = t-cdoc.imptot2 + t-ddoc.impcto.
                NEXT.
            END.
        END.
        /* comisiones por linea */
        FIND FacTabla WHERE FacTabla.codcia = s-codcia
            AND FacTabla.Tabla = 'CV'
            AND FacTabla.Codigo = TRIM(Almmmatg.codfam) + t-cdoc.coddiv
            NO-LOCK NO-ERROR.
        IF AVAILABLE FacTabla THEN DO:
            ASSIGN
                t-ddoc.impcto = x-Signo * t-ddoc.implin * FacTabla.Valor[1] / 100
                t-cdoc.imptot2 = t-cdoc.imptot2 + t-ddoc.impcto.
        END.            
    END.
  END.
  
  HIDE FRAME f-Mensaje.
      
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
  DISPLAY x-CodDiv x-FchDoc-1 x-FchDoc-2 RADIO-SET-1 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE x-CodDiv x-FchDoc-1 x-FchDoc-2 RADIO-SET-1 BUTTON-1 Btn_Done 
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
  DEF VAR x-ImpNac AS DEC NO-UNDO.
  DEF VAR x-ImpUsa AS DEC NO-UNDO.
  DEF VAR x-CtoNac AS DEC NO-UNDO.
  DEF VAR x-CtoUsa AS DEC NO-UNDO.
  
  DEFINE FRAME FC-REP
    t-cdoc.codven       COLUMN-LABEL "Vendedor"      
    gn-ven.nomven       COLUMN-LABEL "Nombre"
    t-ddoc.Flg_Factor   COLUMN-LABEL 'Clase'
    t-ddoc.impcto       COLUMN-LABEL "Comision S/."  FORMAT "(>>>,>>>,>>9.99)"
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
    ACCUMULATE t-ddoc.impcto (SUB-TOTAL BY t-ddoc.flg_factor).
    ACCUMULATE t-ddoc.impcto (SUB-TOTAL BY t-cdoc.codven).
    IF LAST-OF(t-ddoc.flg_factor)
    THEN DO:
        DISPLAY STREAM REPORT
            t-ddoc.flg_factor
            ACCUM SUB-TOTAL BY t-ddoc.flg_factor t-ddoc.impcto @ t-ddoc.impcto
            WITH FRAME FC-REP.
    END.
    IF LAST-OF(t-cdoc.codven)
    THEN DO:
        UNDERLINE STREAM REPORT
            t-ddoc.impcto
            WITH FRAME FC-REP.
        DISPLAY STREAM REPORT
            ACCUM SUB-TOTAL BY t-cdoc.codven t-ddoc.impcto @ t-ddoc.impcto
            WITH FRAME FC-REP.
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
  DEF VAR cCopias AS INT NO-UNDO.
  
  RUN bin/_prnctr.p.
  IF s-salida-impresion = 0 THEN RETURN.
   
  RUN Carga-Temporal.

  /* Captura parametros de impresion */
  /* s-pagina-inicial,  s-pagina-final,  s-printer-name,  s-print-file,  s-nro-copias */
  RUN aderb/_prlist.p(
      OUTPUT s-printer-list,
      OUTPUT s-port-list,
      OUTPUT s-printer-count).
  s-port-name = ENTRY(LOOKUP(s-printer-name, s-printer-list), s-port-list).
  s-port-name = REPLACE(S-PORT-NAME, ":", "").

  IF s-salida-impresion = 1 THEN 
     s-print-file = SESSION:TEMP-DIRECTORY +
     STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".
  
  CASE s-salida-impresion:
        WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
        WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
        WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
  END CASE.

  DO cCopias = 1 TO s-Nro-Copias:
    PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn1}.
    CASE RADIO-SET-1:
        WHEN 1 THEN RUN Formato.
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


