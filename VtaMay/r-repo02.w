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

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-CodDiv FILL-IN-FchDoc BUTTON-2 ~
BUTTON-3 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-CodDiv FILL-IN-DesDiv ~
FILL-IN-FchDoc FILL-IN-2 

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

DEFINE VARIABLE COMBO-BOX-CodDiv AS CHARACTER FORMAT "X(256)":U 
     LABEL "Division" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "?" 
     DROP-DOWN-LIST
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-DesDiv AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc AS DATE FORMAT "99/99/9999":U 
     LABEL "Del Día" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-CodDiv AT ROW 1.96 COL 13 COLON-ALIGNED
     FILL-IN-DesDiv AT ROW 1.96 COL 24 COLON-ALIGNED NO-LABEL
     FILL-IN-FchDoc AT ROW 3.12 COL 13 COLON-ALIGNED
     FILL-IN-2 AT ROW 4.27 COL 25 COLON-ALIGNED NO-LABEL
     BUTTON-2 AT ROW 5.42 COL 9
     BUTTON-3 AT ROW 5.42 COL 25
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
         TITLE              = "Reporte de Documentos al Crédito"
         HEIGHT             = 6.58
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
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN FILL-IN-2 IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       FILL-IN-2:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-DesDiv IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Reporte de Documentos al Crédito */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte de Documentos al Crédito */
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
    COMBO-BOX-CodDiv FILL-IN-FchDoc.
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


&Scoped-define SELF-NAME COMBO-BOX-CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-CodDiv W-Win
ON VALUE-CHANGED OF COMBO-BOX-CodDiv IN FRAME F-Main /* Division */
DO:
  FIND gn-divi WHERE gn-divi.codcia = s-codcia 
    AND gn-divi.coddiv = SELF:SCREEN-VALUE NO-LOCK.
  FILL-IN-DesDiv:SCREEN-VALUE = gn-divi.desdiv.
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
  
  FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia
        AND LOOKUP(ccbcdocu.coddoc, 'FAC,BOL') > 0
        AND ccbcdocu.coddiv = COMBO-BOX-CodDiv
        AND ccbcdocu.tpofac = 'R'
        AND ccbcdocu.fchdoc = FILL-IN-FchDoc:
    FILL-IN-2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "PROCESANDO " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc.
    CREATE t-ccbcdocu.
    BUFFER-COPY ccbcdocu TO t-ccbcdocu.        
  END.
  
  FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia
        AND ccbcdocu.coddoc = 'N/C'
        AND ccbcdocu.coddiv = COMBO-BOX-CodDiv
        AND ccbcdocu.fchdoc = FILL-IN-FchDoc,
        FIRST b-ccbcdocu NO-LOCK WHERE b-ccbcdocu.codcia = s-codcia
            AND b-ccbcdocu.coddoc = ccbcdocu.codref
            AND b-ccbcdocu.nrodoc = ccbcdocu.nroref
            AND b-ccbcdocu.tpofac = 'R':
    FILL-IN-2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "PROCESANDO " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc.
    CREATE t-ccbcdocu.
    BUFFER-COPY ccbcdocu TO t-ccbcdocu.        
  END.
  FILL-IN-2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    
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
  DISPLAY COMBO-BOX-CodDiv FILL-IN-DesDiv FILL-IN-FchDoc FILL-IN-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX-CodDiv FILL-IN-FchDoc BUTTON-2 BUTTON-3 
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
  DEF VAR x-ImpNac AS DEC FORMAT '->>>,>>>,>>9.99' NO-UNDO.
  DEF VAR x-ImpUsa AS DEC FORMAT '->>>,>>>,>>9.99' NO-UNDO.
  DEF VAR x-TotNac AS DEC FORMAT '->>>,>>>,>>9.99' NO-UNDO.
  DEF VAR x-TotUsa AS DEC FORMAT '->>>,>>>,>>9.99' NO-UNDO.
  DEF VAR x-Factor AS DEC NO-UNDO.
  DEF VAR x-SubTit AS CHAR FORMAT 'x(60)' NO-UNDO.
  DEF VAR x-Estado AS CHAR FORMAT 'x(10)' NO-UNDO.

  x-SubTit = 'DIVISION: ' + COMBO-BOX-CodDiv + ' DEL DIA: ' + STRING(FILL-IN-FchDoc, '99/99/9999').
  DEFINE FRAME F-REPORTE
    t-ccbcdocu.coddoc 
    t-ccbcdocu.nrodoc
    t-ccbcdocu.codcli
    t-ccbcdocu.nomcli FORMAT 'x(35)'
    t-ccbcdocu.codref
    t-ccbcdocu.nroref
    x-impnac
    x-impusa
    x-estado
    HEADER
         {&Prn3} + {&Prn7A} + {&Prn6A} + S-NOMCIA + {&Prn7B} + {&Prn6A} AT 6 FORMAT "X(50)" SKIP
         "REPORTE DE COMPROBANTES AL CREDITO" AT 20 
         "Pagina : " TO 90 PAGE-NUMBER(REPORT) TO 100 FORMAT "ZZZZZ9" SKIP
         " Fecha : " TO 90 TODAY TO 100 FORMAT "99/99/9999" SKIP
         "  Hora : " TO 90 STRING(TIME,"HH:MM:SS") TO 100 SKIP
         x-SubTit SKIP(1)
         "Doc Numero    Cliente     Nombre o Razon Social               Ref Numero        Importe S/.     Importe US$" SKIP
/*
**********         1         2         3         4         5         6         7         8         9        10
**********123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
          123 123456789 12345678901 12345678901234567890123456789012345 123 123456789 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 1234567890        
*/
  WITH WIDTH 120 NO-LABELS NO-BOX STREAM-IO DOWN.

  ASSIGN
    x-TotNac = 0
    x-TotUsa = 0.
  FOR EACH t-ccbcdocu BREAK BY t-ccbcdocu.codcia BY t-ccbcdocu.coddoc BY t-ccbcdocu.nrodoc:
    ASSIGN
        x-impnac = 0
        x-impusa = 0
        x-estado = ''.
    IF t-ccbcdocu.flgest <> 'A'
    THEN DO:
        IF t-ccbcdocu.coddoc = 'N/C'
        THEN x-Factor = -1.
        ELSE x-Factor = 1.
        IF t-ccbcdocu.codmon = 1
        THEN ASSIGN
                x-impnac = t-ccbcdocu.imptot
                x-totnac = x-totnac + x-factor * t-ccbcdocu.imptot.
        ELSE ASSIGN
                x-impusa = t-ccbcdocu.imptot
                x-totusa = x-totusa + x-factor * t-ccbcdocu.imptot.
    END.
    ELSE x-Estado = 'ANULADO'.
    DISPLAY STREAM REPORT
        t-ccbcdocu.coddoc 
        t-ccbcdocu.nrodoc
        t-ccbcdocu.codcli
        t-ccbcdocu.nomcli
        t-ccbcdocu.codref WHEN t-ccbcdocu.coddoc = 'N/C'
        t-ccbcdocu.nroref WHEN t-ccbcdocu.coddoc = 'N/C'
        x-impnac
        x-impusa
        WITH FRAME F-REPORTE.
    ACCUMULATE x-impnac (TOTAL BY t-ccbcdocu.codcia BY t-ccbcdocu.coddoc).
    ACCUMULATE x-impusa (TOTAL BY t-ccbcdocu.codcia BY t-ccbcdocu.coddoc).
    IF LAST-OF(t-ccbcdocu.coddoc)
    THEN DO:
        UNDERLINE STREAM REPORT
            x-impnac x-impusa
            WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT
            (ACCUM TOTAL BY t-ccbcdocu.coddoc x-impnac) @ x-impnac
            (ACCUM TOTAL BY t-ccbcdocu.coddoc x-impusa) @ x-impusa
            WITH FRAME F-REPORTE.
        DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
    END.
    IF LAST-OF(t-ccbcdocu.codcia)
    THEN DO:
        UNDERLINE STREAM REPORT
            x-impnac x-impusa
            WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT
            x-totnac @ x-impnac
            x-totusa @ x-impusa
            WITH FRAME F-REPORTE.
    END.
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
  
  CASE s-salida-impresion:
        WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
/*        WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */*/
        WHEN 2 THEN OUTPUT STREAM REPORT TO PRINTER             PAGED PAGE-SIZE 62. /* Impresora */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FILL-IN-FchDoc = TODAY.
  FOR EACH gn-divi WHERE codcia = s-codcia NO-LOCK:
    COMBO-BOX-CodDiv:ADD-LAST(gn-divi.coddiv) IN FRAME {&FRAME-NAME}.
  END.
  COMBO-BOX-CodDiv = s-coddiv.
  FIND gn-divi WHERE gn-divi.codcia = s-codcia 
    AND gn-divi.coddiv = s-coddiv NO-LOCK.
  FILL-IN-DesDiv = gn-divi.desdiv.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  CASE pParam:
      WHEN "YES" THEN COMBO-BOX-CodDiv:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
      WHEN "NO"  THEN COMBO-BOX-CodDiv:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
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

