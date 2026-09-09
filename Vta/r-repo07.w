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
&Scoped-Define ENABLED-OBJECTS BUTTON-1 Btn_Done x-CodDiv x-FchDoc-1 ~
x-FchDoc-2 
&Scoped-Define DISPLAYED-OBJECTS x-CodDiv x-FchDoc-1 x-FchDoc-2 

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

DEFINE VARIABLE x-CodDiv AS CHARACTER FORMAT "X(256)":U 
     LABEL "Division" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "00000","00001","00002","00003","00004","00005","00006","00009","00011","00013" 
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE x-FchDoc-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Cancelados desde" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc-2 AS DATE FORMAT "99/99/99":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-1 AT ROW 4.65 COL 6
     Btn_Done AT ROW 4.65 COL 15
     x-CodDiv AT ROW 1.38 COL 15 COLON-ALIGNED
     x-FchDoc-1 AT ROW 2.35 COL 15 COLON-ALIGNED
     x-FchDoc-2 AT ROW 2.35 COL 33 COLON-ALIGNED
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 69.86 BY 6.08
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
         HEIGHT             = 6.12
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
    x-CodDiv x-FchDoc-1 x-FchDoc-2.
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
  
  /* PRIMERO: LOS COMPROBANTES DE VENTAS */
  FOR EACH ccbccaja WHERE ccbccaja.codcia = s-codcia
        AND ccbccaja.coddoc = 'I/C'
        AND ccbccaja.coddiv = x-CodDiv
        AND ccbccaja.fchdoc >= x-FchDoc-1
        AND ccbccaja.fchdoc <= x-FchDoc-2
        AND ccbccaja.flgest <> 'A' no-lock,
        EACH ccbdcaja OF ccbccaja no-lock,
        FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia
            AND ccbcdocu.coddoc = ccbdcaja.codref
            AND ccbcdocu.nrodoc = ccbdcaja.nroref 
            AND ccbcdocu.flgest = 'C' 
            AND LOOKUP(TRIM(ccbcdocu.coddoc), 'FAC,BOL,TCK') > 0
            NO-LOCK:
    FIND t-cdoc of ccbcdocu no-lock no-error.
    IF NOT AVAILABLE t-cdoc THEN DO:
        CREATE t-cdoc.
        BUFFER-COPY ccbcdocu TO t-cdoc.
    END.        
  END.

  /* SEGUNDO: DEFINIMOS LAS QUE HAN SIDO CANCELADAS A ESTA FECHA */
  FOR EACH t-cdoc:
    x-FchCan = ?.
    FOR EACH ccbdcaja WHERE ccbdcaja.codcia = s-codcia
            AND ccbdcaja.coddoc = 'I/C'
            AND ccbdcaja.codref = t-cdoc.coddoc
            AND ccbdcaja.nroref = t-cdoc.nrodoc BY ccbdcaja.fchdoc:
        x-FchCan = ccbdcaja.fchdoc.
    END.            
    IF x-FchCan > x-FchDoc-2 THEN DELETE t-cdoc.
  END.
  
  /* TERCERO: LAS NOTAS DE ABONO */
  FOR EACH ccbcdocu WHERE ccbcdocu.codcia = s-codcia
        AND ccbcdocu.coddoc = 'N/C'
        AND ccbcdocu.fchdoc >= x-FchDoc-1
        AND ccbcdocu.fchdoc <= x-FchDoc-2
        AND ccbcdocu.flgest <> 'A' NO-LOCK:
    FIND b-cdoc WHERE b-cdoc.codcia = s-codcia
        AND b-cdoc.coddoc = ccbcdocu.codref
        AND b-cdoc.nrodoc = ccbcdocu.nroref NO-LOCK NO-ERROR.
    IF NOT AVAILABLE b-cdoc THEN NEXT.
    CREATE t-cdoc.
    BUFFER-COPY ccbcdocu TO t-cdoc
        ASSIGN 
            t-cdoc.codven = b-cdoc.codven
            t-cdoc.imptot = ccbcdocu.imptot * -1
            t-cdoc.impcto = ccbcdocu.impcto *  -1.
  END.
    
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
  DISPLAY x-CodDiv x-FchDoc-1 x-FchDoc-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-1 Btn_Done x-CodDiv x-FchDoc-1 x-FchDoc-2 
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
  
  DEFINE FRAME FC-REP
    t-cdoc.coddoc       COLUMN-LABEL "Doc"      
    t-cdoc.nrodoc       COLUMN-LABEL "Numero"
    t-cdoc.codcli       COLUMN-LABEL "Cliente"
    t-cdoc.nomcli       COLUMN-LABEL "Nombre o Razon Social"
    t-cdoc.fchdoc       COLUMN-LABEL "Emision"
    t-cdoc.fchcan       COLUMN-LABEL "Cancelacion"
    x-ImpNac            COLUMN-LABEL "Importe S/."  FORMAT "(>>>,>>>,>>9.99)"
    x-ImpUsa            COLUMN-LABEL "Importe US$"  FORMAT "(>>>,>>>,>>9.99)"
    x-CtoNac            COLUMN-LABEL "Costo S/."    FORMAT "(>>>,>>>,>>9.99)"
    x-CtoUsa            COLUMN-LABEL "Costo US$"    FORMAT "(>>>,>>>,>>9.99)"
    WITH WIDTH 200 NO-BOX STREAM-IO DOWN. 

  DEFINE FRAME H-REP
    HEADER
    S-NOMCIA FORMAT "X(45)" SKIP
    "( " + x-CODDIV + ")"  FORMAT "X(15)"
    "REPORTE DE COMISIONES" AT 20
    "Pag.  : " AT 70 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
    "Fecha : " AT 70 STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
    "Cancelados desde:" x-FchDoc-1
    "hasta:" x-FchDoc-2 SKIP
    WITH PAGE-TOP WIDTH 200 NO-BOX NO-LABELS STREAM-IO CENTERED DOWN. 

  FOR EACH t-cdoc,
        FIRST gn-ven OF t-cdoc NO-LOCK
        BREAK BY t-cdoc.codcia BY t-cdoc.codven BY t-cdoc.coddoc:
    VIEW STREAM REPORT FRAME H-REP.
    IF FIRST-OF(t-cdoc.codven)
    THEN DO:
        DISPLAY STREAM REPORT
            t-cdoc.codven @ t-cdoc.codcli
            gn-ven.NomVen @ t-cdoc.nomcli
            WITH FRAME FC-REP.
        UNDERLINE STREAM REPORT
            t-cdoc.codcli
            WITH FRAME FC-REP.            
    END.
    IF t-cdoc.codmon = 1
    THEN ASSIGN
            x-ImpNac = t-cdoc.imptot
            x-ImpUsa = 0
            x-CtoNac = t-cdoc.impcto
            x-CtoUsa = 0.
    ELSE ASSIGN
            x-ImpUsa = t-cdoc.imptot
            x-ImpNac = 0
            x-CtoUsa = t-cdoc.impcto
            x-CtoNac = 0.
    ACCUMULATE x-ImpNac (SUB-TOTAL BY t-cdoc.codven).
    ACCUMULATE x-ImpUsa (SUB-TOTAL BY t-cdoc.codven).
    ACCUMULATE x-CtoNac (SUB-TOTAL BY t-cdoc.codven).
    ACCUMULATE x-CtoUsa (SUB-TOTAL BY t-cdoc.codven).
    DISPLAY STREAM REPORT
        t-cdoc.coddoc       
        t-cdoc.nrodoc       
        t-cdoc.codcli       
        t-cdoc.nomcli       
        t-cdoc.fchdoc       
        t-cdoc.fchcan       
        x-ImpNac WHEN x-ImpNac <> 0
        x-ImpUsa WHEN x-ImpUsa <> 0
        x-CtoNac WHEN x-CtoNac <> 0
        x-CtoUsa WHEN x-CtoUsa <> 0
        WITH FRAME FC-REP.
    IF LAST-OF(t-cdoc.codven) THEN DO:
        UNDERLINE STREAM REPORT
            x-ImpNac
            x-ImpUsa
            x-CtoNac
            x-CtoUsa
            WITH FRAME FC-REP.
        DISPLAY STREAM REPORT
            ACCUM SUB-TOTAL BY t-cdoc.codven x-ImpNac @ x-ImpNac
            ACCUM SUB-TOTAL BY t-cdoc.codven x-ImpUsa @ x-ImpUsa
            ACCUM SUB-TOTAL BY t-cdoc.codven x-CtoNac @ x-CtoNac
            ACCUM SUB-TOTAL BY t-cdoc.codven x-CtoUsa @ x-CtoUsa
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

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.

  RUN Formato.
  
  PAGE STREAM REPORT.
  OUTPUT STREAM REPORT CLOSE.
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


