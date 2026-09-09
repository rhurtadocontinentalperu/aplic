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

DEF SHARED VAR cl-codcia AS INT.
DEF VAR s-task-no AS INT NO-UNDO.

DEF TEMP-TABLE DETALLE LIKE CcbCcaja
    FIELD ImpTot AS DEC.

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-Fecha-1 FILL-IN-Fecha-2 BUTTON-1 ~
BUTTON-3 Btn_Done 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Fecha-1 FILL-IN-Fecha-2 F-Division 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Done DEFAULT 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Salir" 
     SIZE 15 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     LABEL "..." 
     SIZE 3 BY .77.

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Imprimir" 
     SIZE 15 BY 1.54.

DEFINE VARIABLE F-Division AS CHARACTER FORMAT "X(60)":U 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-2 AS DATE FORMAT "99/99/99":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-Fecha-1 AT ROW 1.58 COL 24 COLON-ALIGNED
     FILL-IN-Fecha-2 AT ROW 1.58 COL 39 COLON-ALIGNED
     F-Division AT ROW 2.73 COL 24 COLON-ALIGNED
     BUTTON-1 AT ROW 2.73 COL 70
     BUTTON-3 AT ROW 4.85 COL 6
     Btn_Done AT ROW 4.85 COL 21
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
         TITLE              = "REPORTE DE CHEQUES DIFERIDOS"
         HEIGHT             = 7.12
         WIDTH              = 76.29
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
   FRAME-NAME L-To-R                                                    */
/* SETTINGS FOR FILL-IN F-Division IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REPORTE DE CHEQUES DIFERIDOS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REPORTE DE CHEQUES DIFERIDOS */
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


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* ... */
DO:
  DEF VAR x-Divisiones AS CHAR.
  x-Divisiones = f-Division:SCREEN-VALUE.
  RUN vta/d-repo06 (INPUT-OUTPUT x-Divisiones).
  f-Division:SCREEN-VALUE = x-Divisiones.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Imprimir */
DO:
  ASSIGN
    FILL-IN-Fecha-1 FILL-IN-Fecha-2 F-Division.
  IF FILL-IN-Fecha-1 = ? OR FILL-IN-Fecha-2 = ? 
  THEN DO:
    MESSAGE 'Ingrese todos los parametros' VIEW-AS ALERT-BOX WARNING.
    RETURN NO-APPLY.
  END.
  RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Division W-Win
ON LEAVE OF F-Division IN FRAME F-Main /* División */
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
  DEF VAR x-CodDiv AS CHAR NO-UNDO.
  
  DEF FRAME f-Mensaje 
    Ccbcdocu.coddiv Ccbcdocu.coddoc Ccbcdocu.nrodoc Ccbcdocu.fchdoc
    WITH VIEW-AS DIALOG-BOX  CENTERED OVERLAY NO-LABELS 
        TITLE 'Procesando informacion'.
  
  FOR EACH DETALLE:
    DELETE DETALLE.
  END.

  IF f-Division = '' THEN DO:
    FOR EACH GN-DIVI WHERE gn-divi.codcia = s-codcia NO-LOCK:
        IF f-Division = '' 
        THEN f-Division = TRIM(gn-divi.coddiv).
        ELSE f-Division = f-Division + ',' + TRIM(gn-divi.coddiv).
    END.
  END.

  DO i = 1 TO NUM-ENTRIES(f-Division):
    x-CodDiv = ENTRY(i, f-Division).
    FOR EACH CcbCcaja USE-INDEX LLAVE07 WHERE CcbcCaja.CodCia  = S-CODCIA 
            AND CcbcCaja.CodDiv  = x-CODDIV 
            AND CcbcCaja.CodDoc  = "I/C"    
            AND CcbcCaja.FchDoc >= FILL-IN-Fecha-1
            AND CcbcCaja.FchDoc <= FILL-IN-Fecha-2
            AND (CcbcCaja.FchVto[3] <> ? AND CcbcCaja.FchVto[3] > CcbcCaja.FchDoc)
            AND CCbcCaja.Flgest  <> 'A' 
            AND (CcbcCaja.ImpNac[2] <> 0 OR CcbcCaja.ImpNac[3] <> 0 OR
                CcbcCaja.ImpUsa[2] <> 0 OR CcbcCaja.ImpUsa[3] <> 0)
            NO-LOCK:
        CREATE DETALLE.
        BUFFER-COPY Ccbccaja TO DETALLE.
/*        ASSIGN
 *             DETALLE.codcia = Ccbccaja.codcia
 *             DETALLE.coddoc = 'CHC'
 *             DETALLE.coddiv = Ccbccaja.coddiv
 *             DETALLE.codcli = Ccbccaja.codcli
 *             DETALLE.nomcli = Ccbccaja.nomcli
 *             DETALLE.fchdoc = Ccbccaja.fchdoc
 *             DETALLE.fchvto = Ccbccaja.fchvto[2]
 *             DETALLE.codbco[3] = ccbccaja.codbco[3].*/
        IF CcbCCaja.ImpNac[2] <> 0 OR CcbCCaja.ImpNac[3] <> 0 THEN DO:
            ASSIGN
                DETALLE.codmon = 1
                DETALLE.imptot = CcbCCaja.ImpNac[2].
            IF DETALLE.imptot = 0 THEN DETALLE.imptot = CcbCCaja.ImpNac[3].
        END.   
        IF CcbCCaja.ImpUsa[2] <> 0 OR CcbCCaja.ImpUsa[3] <> 0 THEN DO:
            ASSIGN
                DETALLE.codmon = 2
                DETALLE.imptot = CcbCCaja.ImpUsa[2].
            IF DETALLE.imptot = 0 THEN DETALLE.imptot = CcbCCaja.ImpUsa[3].
        END.   
    END.            
  END.

  HIDE FRAME f-Mensaje.
    

END PROCEDURE.

/*
  DO i = 1 TO NUM-ENTRIES(f-Division):
    x-CodDiv = ENTRY(i, f-Division).
    FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
            AND Ccbcdocu.coddiv = x-coddiv
            AND Ccbcdocu.coddoc = 'CHC'
            AND Ccbcdocu.flgest = 'P'
            AND Ccbcdocu.fchdoc >= FILL-IN-Fecha-1
            AND Ccbcdocu.fchdoc <= FILL-IN-Fecha-2
            AND Ccbcdocu.fchdoc < Ccbcdocu.fchvto,
            FIRST Ccbccaja NO-LOCK WHERE Ccbccaja.codcia = s-codcia
                AND Ccbccaja.coddoc = Ccbcdocu.codref
                AND Ccbccaja.nrodoc = Ccbcdocu.nroref:
        DISPLAY Ccbcdocu.coddiv Ccbcdocu.coddoc Ccbcdocu.nrodoc Ccbcdocu.fchdoc
            WITH FRAME f-Mensaje.
        CREATE DETALLE.
        BUFFER-COPY Ccbcdocu TO DETALLE
            ASSIGN
                DETALLE.codbco[3] = ccbccaja.codbco[3].
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
  DISPLAY FILL-IN-Fecha-1 FILL-IN-Fecha-2 F-Division 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-Fecha-1 FILL-IN-Fecha-2 BUTTON-1 BUTTON-3 Btn_Done 
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
  DEF VAR x-Moneda AS CHAR NO-UNDO.
  DEF VAR x-Banco AS CHAR NO-UNDO.
  
  DEFINE FRAME F-Cab
    DETALLE.nomcli                      COLUMN-LABEL 'Nombre del Cliente'
    DETALLE.codcli                      COLUMN-LABEL 'Codigo'
    DETALLE.VOUCHER[3]  FORMAT 'x(15)'  COLUMN-LABEL 'Numero de Cheque'
    DETALLE.fchdoc                      COLUMN-LABEL 'Fecha de Ingreso'
    DETALLE.fchvto[3]                   COLUMN-LABEL 'Fecha del Cheque'
    x-Moneda            FORMAT 'x(3)'   COLUMN-LABEL 'Mon'
    DETALLE.imptot                      COLUMN-LABEL 'Importe'
    x-Banco             FORMAT 'x(20)'  COLUMN-LABEL 'Banco'
    HEADER
        S-NOMCIA FORMAT 'X(50)' SKIP
        "REPORTE DE CHEQUES DIFERIDOS PENDIENTES" AT 30
        "Pag.  : " AT 90 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "Fecha : " AT 90 STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
        "DESDE EL" FILL-IN-Fecha-1 "HASTA EL" FILL-IN-Fecha-2 SKIP
        "DIVISION(es):" f-Division FORMAT 'x(60)' SKIP(1)
    WITH WIDTH 200 NO-BOX STREAM-IO DOWN.         

  FOR EACH DETALLE:
    x-Moneda = IF DETALLE.codmon = 1 THEN 'S/' ELSE 'US$'.
    x-Banco = ''.
    FIND Cb-tabl WHERE Cb-tabl.tabla = '04'
        AND Cb-tabl.codigo = DETALLE.codbco[3]
        NO-LOCK NO-ERROR.
    IF AVAILABLE Cb-tabl THEN x-Banco = Cb-tabl.nombre.
    DISPLAY STREAM REPORT
        DETALLE.nomcli                      
        DETALLE.codcli                      
        DETALLE.VOUCHER[3]      
        DETALLE.fchdoc      
        DETALLE.fchvto[3]  
        x-Moneda            
        DETALLE.imptot
        x-Banco             
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
  ASSIGN
    FILL-IN-Fecha-1 = TODAY
    FILL-IN-Fecha-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

