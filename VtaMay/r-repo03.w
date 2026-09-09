&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t-ccbcdocu NO-UNDO LIKE CcbCDocu.



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
DEF INPUT PARAMETER pParam AS CHAR.
/* 
"YES" permite seleccionar la división
"NO"  no permite seleccionar la división
*/

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-nomcia AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.

DEF BUFFER b-ccbcdocu FOR ccbcdocu.

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
&Scoped-Define ENABLED-OBJECTS x-CodDiv x-FchDoc-1 x-FchDoc-2 x-FchEnv-1 ~
x-FchEnv-2 x-CodCli x-Estado BUTTON-2 BUTTON-3 
&Scoped-Define DISPLAYED-OBJECTS x-CodDiv x-DesDiv x-FchDoc-1 x-FchDoc-2 ~
x-FchEnv-1 x-FchEnv-2 x-CodCli x-NomCli x-Estado x-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Button 2" 
     SIZE 15 BY 1.54.

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Button 3" 
     SIZE 15 BY 1.54.

DEFINE VARIABLE x-CodDiv AS CHARACTER FORMAT "X(256)":U 
     LABEL "Division" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "?" 
     DROP-DOWN-LIST
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE x-CodCli AS CHARACTER FORMAT "x(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81 NO-UNDO.

DEFINE VARIABLE x-DesDiv AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Emitidos desde" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "hasta" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchEnv-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Enviados desde" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchEnv-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "hasta" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE x-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 64 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .81 NO-UNDO.

DEFINE VARIABLE x-Estado AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Todos", "T",
"Enviados", "E",
"Pendientes", "P",
"Anulados", "A"
     SIZE 12 BY 3 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-CodDiv AT ROW 1.38 COL 13 COLON-ALIGNED
     x-DesDiv AT ROW 1.38 COL 24 COLON-ALIGNED NO-LABEL
     x-FchDoc-1 AT ROW 2.35 COL 13 COLON-ALIGNED
     x-FchDoc-2 AT ROW 2.35 COL 31 COLON-ALIGNED
     x-FchEnv-1 AT ROW 3.31 COL 13 COLON-ALIGNED
     x-FchEnv-2 AT ROW 3.31 COL 31 COLON-ALIGNED
     x-CodCli AT ROW 4.27 COL 13 COLON-ALIGNED
     x-NomCli AT ROW 4.27 COL 27 COLON-ALIGNED NO-LABEL
     x-Estado AT ROW 5.23 COL 15 NO-LABEL
     x-Mensaje AT ROW 8.88 COL 3 COLON-ALIGNED NO-LABEL
     BUTTON-2 AT ROW 10.42 COL 4
     BUTTON-3 AT ROW 10.42 COL 20
     "Situacion:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 5.23 COL 7
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
   Temp-Tables and Buffers:
      TABLE: t-ccbcdocu T "?" NO-UNDO INTEGRAL CcbCDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Control de Comprobantes por Enviar"
         HEIGHT             = 11.27
         WIDTH              = 71.86
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
   L-To-R                                                               */
/* SETTINGS FOR FILL-IN x-DesDiv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-Mensaje IN FRAME F-Main
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
ON END-ERROR OF W-Win /* Control de Comprobantes por Enviar */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Control de Comprobantes por Enviar */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  ASSIGN
    x-CodCli x-CodDiv x-Estado x-FChDoc-1 x-FChDoc-2 x-FchEnv-1 x-FchEnv-2.
  RUN Imprime.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
  RUN dispatch IN THIS-PROCEDURE ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodDiv W-Win
ON VALUE-CHANGED OF x-CodDiv IN FRAME F-Main /* Division */
DO:
  FIND gn-divi WHERE gn-divi.codcia = s-codcia 
    AND gn-divi.coddiv = SELF:SCREEN-VALUE NO-LOCK.
  x-DesDiv:SCREEN-VALUE = gn-divi.desdiv.
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
  FOR EACH t-ccbcdocu:
    DELETE t-ccbcdocu.
  END.

  IF x-FchDoc-1 = ?
  THEN DO:
    x-FchDoc-1 = DATE(01,01,1900).
    FIND FIRST ccbcdocu USE-INDEX Llave10 WHERE ccbcdocu.codcia = s-codcia
        AND LOOKUP(TRIM(ccbcdocu.coddoc), 'FAC,BOL') > 0
        AND ccbcdocu.coddiv = x-coddiv
        NO-LOCK NO-ERROR.
    IF AVAILABLE ccbcdocu THEN x-FchDoc-1 = ccbcdocu.fchdoc.
  END.
  IF x-FchDoc-2 = ? THEN x-FchDoc-2 = TODAY.

  x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'PREPARANDO INFORMACION....'.
  FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia
        AND LOOKUP(TRIM(ccbcdocu.coddoc), 'FAC,BOL') > 0
        AND ccbcdocu.coddiv = x-coddiv
        AND ccbcdocu.fchdoc >= x-fchdoc-1
        AND ccbcdocu.fchdoc <= x-fchdoc-2
        AND ccbcdocu.codcli BEGINS x-codcli:
    IF ccbcdocu.flgenv = NO THEN NEXT.        
    IF x-Estado <> 'A' AND ccbcdocu.flgest = 'A' THEN NEXT.
    /* CONDICIONES DEL FILTRO */
    FIND AlmDCDoc WHERE almdcdoc.codcia = s-codcia
        AND almdcdoc.coddoc = ccbcdocu.coddoc
        AND almdcdoc.nrodoc = ccbcdocu.nrodoc
        AND almdcdoc.flgest = 'S'
        NO-LOCK NO-ERROR.
    CASE x-Estado:
        WHEN 'E'        /* Enviados */
            THEN DO:
                IF NOT AVAILABLE AlmDCDoc THEN NEXT.
                IF x-FchEnv-1 <> ? AND AlmDCdoc.Fecha < x-FchEnv-1 THEN NEXT.
                IF x-FchEnv-2 <> ? AND AlmDCdoc.Fecha > x-FchEnv-2 THEN NEXT.
            END.
        WHEN 'P'        /* Pendientes */
            THEN DO:
                IF AVAILABLE AlmDCDoc THEN NEXT.
            END.
        WHEN 'A'        /* Anulados */
            THEN DO:
                IF ccbcdocu.flgest <> 'A' THEN NEXT.
            END.
    END CASE.
    x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ccbcdocu.coddoc + ' ' + ccbcdocu.nrodoc + ' ' +
        STRING(ccbcdocu.fchdoc) + ' ' + ccbcdocu.nomcli.
    CREATE t-ccbcdocu.
    BUFFER-COPY ccbcdocu TO t-ccbcdocu
        ASSIGN t-ccbcdocu.fchvto = ?.
    IF t-ccbcdocu.flgest <> 'A' 
    THEN DO:
        IF AVAILABLE almdcdoc 
        THEN ASSIGN
                t-ccbcdocu.flgest = 'E'
                t-ccbcdocu.fchvto = almdcdoc.fecha.
        ELSE t-ccbcdocu.flgest = 'P'.
    END.
  END.        
  x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.

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
  DISPLAY x-CodDiv x-DesDiv x-FchDoc-1 x-FchDoc-2 x-FchEnv-1 x-FchEnv-2 x-CodCli 
          x-NomCli x-Estado x-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE x-CodDiv x-FchDoc-1 x-FchDoc-2 x-FchEnv-1 x-FchEnv-2 x-CodCli x-Estado 
         BUTTON-2 BUTTON-3 
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
  DEF VAR x-Situacion AS CHAR FORMAT 'x(10)'.
  DEF VAR x-SubTit AS CHAR FORMAT 'x(50)'.
  
  x-SubTit = 'DIVISION: ' + x-CodDiv.
  DEFINE FRAME F-REPORTE
    t-ccbcdocu.coddoc                   COLUMN-LABEL 'Cod.'
    t-ccbcdocu.nrodoc                   COLUMN-LABEL 'Numero'
    t-ccbcdocu.codcli                   COLUMN-LABEL 'Cliente'
    t-ccbcdocu.nomcli FORMAT 'x(35)'    COLUMN-LABEL 'Nombre o Razon Social'
    t-ccbcdocu.codmon                   COLUMN-LABEL 'Mon'
    t-ccbcdocu.imptot                   COLUMN-LABEL 'Importe'
    t-ccbcdocu.fmapgo                   COLUMN-LABEL 'Cond.!Vta.'
    t-ccbcdocu.fchdoc                   COLUMN-LABEL 'Emision'
    x-Situacion                         COLUMN-LABEL 'Situacion'
    t-ccbcdocu.fchvto                   COLUMN-LABEL 'Envio'
    HEADER
         S-NOMCIA FORMAT "X(50)" SKIP
         "CONTROL DE COMPROBANTES POR ENVIAR" AT 20 
         "Pagina : " TO 90 PAGE-NUMBER(REPORT) TO 100 FORMAT "ZZZZZ9" SKIP
         " Fecha : " TO 90 TODAY TO 100 FORMAT "99/99/9999" SKIP
         "  Hora : " TO 90 STRING(TIME,"HH:MM:SS") TO 100 SKIP
         x-SubTit SKIP(1)
  WITH WIDTH 130 NO-BOX STREAM-IO DOWN.

  FOR EACH t-ccbcdocu :
    CASE t-ccbcdocu.flgest:
        WHEN 'A' THEN x-Situacion = 'ANULADO'.
        WHEN 'E' THEN x-Situacion = 'ENVIADO'.
        WHEN 'P' THEN x-Situacion = 'PENDIENTE'.
        OTHERWISE x-Situacion = '???'.
    END CASE.
    DISPLAY STREAM REPORT
        t-ccbcdocu.coddoc 
        t-ccbcdocu.nrodoc
        t-ccbcdocu.codcli
        t-ccbcdocu.nomcli
        t-ccbcdocu.codmon
        t-ccbcdocu.imptot
        t-ccbcdocu.fmapgo
        t-ccbcdocu.fchdoc
        x-situacion
        t-ccbcdocu.fchvto
        WITH FRAME F-REPORTE.
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
  DEF VAR x-Copias AS INT.
  
/*  RUN bin/_prnctr.p.*/
  RUN lib/imprimir2.
  IF s-salida-impresion = 0 THEN RETURN.
   
  /* Captura parametros de impresion */
  /* s-pagina-inicial,  s-pagina-final,  s-printer-name,  s-print-file,  s-nro-copias */
  
  RUN Carga-Temporal.

  FIND FIRST t-ccbcdocu NO-LOCK NO-ERROR.
  IF NOT AVAILABLE t-ccbcdocu
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
     s-print-file = SESSION:TEMP-DIRECTORY + "report.prn".
  
  DO x-Copias = 1 TO s-nro-copias:
    CASE s-salida-impresion:
          WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
/*          WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */*/
          WHEN 2 THEN OUTPUT STREAM REPORT TO PRINTER             PAGED PAGE-SIZE 62. /* Impresora */
          WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
    END CASE.
    
    PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
     
    RUN Formato.
  
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
  FOR EACH gn-divi WHERE codcia = s-codcia NO-LOCK:
    x-CodDiv:ADD-LAST(gn-divi.coddiv) IN FRAME {&FRAME-NAME}.
  END.
  x-CodDiv = s-coddiv.
  FIND gn-divi WHERE gn-divi.codcia = s-codcia 
    AND gn-divi.coddiv = s-coddiv NO-LOCK.
  x-DesDiv = gn-divi.desdiv.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  CASE pParam:
      WHEN "YES" THEN x-CodDiv:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
      WHEN "NO"  THEN x-CodDiv:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
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

