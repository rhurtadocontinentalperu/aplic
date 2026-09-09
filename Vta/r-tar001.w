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
DEF SHARED VAR cl-CodCia AS INT.
DEF SHARED VAR s-nomcia AS CHAR.

DEF VAR RB-REPORT-LIBRARY AS CHAR INITIAL "".
DEF VAR RB-REPORT-NAME AS CHAR INITIAL "".
DEF VAR RB-INCLUDE-RECORDS AS CHAR INITIAL "".
DEF VAR RB-FILTER AS CHAR INITIAL "".
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".

DEF VAR s-task-no AS INT NO-UNDO.

    DEF VAR x-Division   AS CHAR NO-UNDO.
    DEF VAR f-Division   AS CHAR NO-UNDO.
    DEF VAR x-Control    AS INT NO-UNDO.
    DEF VAR x-SaldoMn    AS DEC NO-UNDO.
    DEF VAR x-SaldoMe    AS DEC NO-UNDO.
    DEF VAR x-CodCli     AS CHAR NO-UNDO.
    DEF VAR f-SaldoMn    AS DEC NO-UNDO.
    DEF VAR f-SaldoMe    AS DEC NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS F-nrocar x-FchDoc BUTTON-1 Btn_Done 
&Scoped-Define DISPLAYED-OBJECTS F-nrocar x-FchDoc x-mensaje 

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
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Imprimir" 
     SIZE 15 BY 1.54.

DEFINE VARIABLE F-nrocar AS CHARACTER FORMAT "X(6)":U 
     LABEL "Nro Tarjeta" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc AS DATE FORMAT "99/99/99":U 
     LABEL "Fecha de corte" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 58 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-nrocar AT ROW 1.81 COL 22 COLON-ALIGNED
     x-FchDoc AT ROW 2.77 COL 22 COLON-ALIGNED
     x-mensaje AT ROW 4.77 COL 3 NO-LABEL WIDGET-ID 2
     BUTTON-1 AT ROW 6.12 COL 28
     Btn_Done AT ROW 6.12 COL 44
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 61.43 BY 7.42
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
         TITLE              = "Clientes por Tarjeta"
         HEIGHT             = 7.42
         WIDTH              = 61.43
         MAX-HEIGHT         = 7.42
         MAX-WIDTH          = 61.43
         VIRTUAL-HEIGHT     = 7.42
         VIRTUAL-WIDTH      = 61.43
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
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Clientes por Tarjeta */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Clientes por Tarjeta */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Imprimir */
DO:
  ASSIGN F-nrocar x-FchDoc.
  RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-nrocar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-nrocar W-Win
ON LEAVE OF F-nrocar IN FRAME F-Main /* Nro Tarjeta */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
  FIND Gn-Card WHERE Gn-Card.NroCard = SELF:SCREEN-VALUE 
               NO-LOCK NO-ERROR.

     IF NOT AVAILABLE Gn-Card THEN DO:
        MESSAGE "Numero de Tarjeta No Existe...."
        VIEW-AS ALERT-BOX .
        RETURN NO-APPLY.
  
     END.
  
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
  REPEAT:
    s-task-no = RANDOM(1,999999).
    IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK)
    THEN LEAVE.
  END.
  
  FOR EACH GN-CARD NO-LOCK WHERE GN-CARD.NroCard BEGINS F-nrocar,
        EACH GN-CLIE NO-LOCK WHERE GN-CLIE.CodCia = cl-codcia
            AND GN-CLIE.NroCard = GN-CARD.NroCard:
    /*
    DISPLAY
        GN-CARD.NroCard SKIP
        WITH FRAME f-Mensaje VIEW-AS DIALOG-BOX CENTERED OVERLAY.
    */
    DISPLAY "NroCard: " + GN-CARD.NroCard @ x-mensaje WITH FRAME {&FRAME-NAME}.

    CREATE w-report.
    ASSIGN
        w-report.task-no    = s-task-no
        w-report.campo-c[1] = gn-card.NroCard 
        w-report.campo-c[2] = gn-card.NomCli[1]
        w-report.campo-c[3] = gn-clie.CodCli 
        w-report.campo-c[4] = gn-clie.NomCli.
    x-CodCli = GN-CLIE.CodCli.
    RUN Saldo.
    ASSIGN
        w-report.campo-f[1] = f-SaldoMn
        w-report.campo-f[2] = f-SaldoMe.
  END.  
  HIDE FRAME f-Mensaje.
  
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
  DISPLAY F-nrocar x-FchDoc x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE F-nrocar x-FchDoc BUTTON-1 Btn_Done 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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

    RUN carga-temporal.

    FIND FIRST w-report WHERE
        w-report.task-no = s-task-no NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        MESSAGE
            "No existen registros a imprimir"
            VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.

    GET-KEY-VALUE SECTION 'STARTUP' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
    ASSIGN
        RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "vta\rbvta.prl"
        RB-REPORT-NAME = "Clientes por Tarjeta Exclusiva 2"
        RB-INCLUDE-RECORDS = "O"
        RB-FILTER = "w-report.task-no = " + STRING(s-task-no)
        RB-OTHER-PARAMETERS = "s-nomcia = " + s-nomcia.

    RUN lib/_Imprime2(
        RB-REPORT-LIBRARY,
        RB-REPORT-NAME,
        RB-INCLUDE-RECORDS,
        RB-FILTER,
        RB-OTHER-PARAMETERS).

    FOR EACH w-report WHERE w-report.task-no = s-task-no:
        DELETE w-report.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  x-FchDoc = TODAY.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Saldo W-Win 
PROCEDURE Saldo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   
f-Division = '00001,00002,00003,00008,00014'.
ASSIGN
    f-SaldoMn = 0
    f-SaldoMe = 0.
    
/*DO x-Control = 1 TO NUM-ENTRIES(f-Division):
 *   x-Division = ENTRY(x-Control, f-Division).*/
FOR EACH GN-DIVI NO-LOCK WHERE GN-DIVI.codcia = s-codcia:
  x-Division = GN-DIVI.coddiv.
  /* DOS procesos */
  IF x-FchDoc < TODAY THEN DO:
    FOR EACH Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
          AND LOOKUP(TRIM(ccbcdocu.coddoc), 'FAC,BOL,N/C,N/D,CHQ,LET') > 0
          AND Ccbcdocu.coddiv = x-Division
          AND CcbCDocu.codcli = x-CodCli
          AND Ccbcdocu.flgest <> 'A'
          AND Ccbcdocu.fchdoc <= x-FchDoc NO-LOCK:
      /* RHC 03.11.05 hay casos que no tiene sustento de cancelacion => nos fijamos en la fecha de cancelacion */
      IF ccbcdocu.flgest = 'C' 
            AND ccbcdocu.fchcan <> ? 
            AND ccbcdocu.fchcan <= x-FchDoc THEN DO:
        FIND FIRST Ccbdcaja WHERE ccbdcaja.codcia = s-codcia
              AND Ccbdcaja.codref = Ccbcdocu.coddoc
              AND Ccbdcaja.nroref = Ccbcdocu.nrodoc NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ccbdcaja THEN NEXT.
      END.
      IF ccbcdocu.flgest = 'C' AND ccbcdocu.fchcan = ? THEN NEXT.   /* Suponemos que está cancelada en la fecha */
      /* ***************************************************************************************************** */
      ASSIGN
        x-SaldoMn = 0
        x-SaldoMe = 0.
      IF Ccbcdocu.codmon = 1
      THEN x-SaldoMn = Ccbcdocu.sdoact.
      ELSE x-SaldoMe = Ccbcdocu.sdoact.
      /* Buscamos las cancelaciones */
      FOR EACH Ccbdcaja WHERE ccbdcaja.codcia = s-codcia
              AND Ccbdcaja.codref = Ccbcdocu.coddoc
              AND Ccbdcaja.nroref = Ccbcdocu.nrodoc
              AND Ccbdcaja.fchdoc <= x-FchDoc NO-LOCK:
          IF Ccbcdocu.codmon = 1
          THEN x-SaldoMn = x-SaldoMn - Ccbdcaja.imptot.
          ELSE x-SaldoMe = x-SaldoMe - Ccbdcaja.imptot.
      END.            
      IF Ccbcdocu.CodDoc = 'N/C' THEN DO:
        FOR EACH Ccbdcaja WHERE ccbdcaja.codcia = s-codcia
                AND Ccbdcaja.coddoc = Ccbcdocu.coddoc
                AND Ccbdcaja.nrodoc = Ccbcdocu.nrodoc
                AND Ccbdcaja.fchdoc <= x-FchDoc NO-LOCK:
          IF Ccbcdocu.codmon = 1
          THEN x-SaldoMn = x-SaldoMn - Ccbdcaja.imptot.
          ELSE x-SaldoMe = x-SaldoMe - Ccbdcaja.imptot.
        END.            
      END.
      ASSIGN
        f-SaldoMn = f-SaldoMn + x-SaldoMn
        f-SaldoMe = f-SaldoMe + x-SaldoMe.
    END.
  END.
  ELSE DO:
    FOR EACH Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
          AND LOOKUP(TRIM(ccbcdocu.coddoc), 'FAC,BOL,N/C,N/D,CHQ,LET') > 0
          AND Ccbcdocu.coddiv = x-Division
          AND CcbCDocu.codcli = x-CodCli
          AND Ccbcdocu.flgest = 'P' NO-LOCK:
      ASSIGN
        x-SaldoMn = 0
        x-SaldoMe = 0.
      IF Ccbcdocu.codmon = 1
      THEN x-SaldoMn = Ccbcdocu.sdoact.
      ELSE x-SaldoMe = Ccbcdocu.sdoact.
      ASSIGN
        f-SaldoMn = f-SaldoMn + x-SaldoMn
        f-SaldoMe = f-SaldoMe + x-SaldoMe.
    END.
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

