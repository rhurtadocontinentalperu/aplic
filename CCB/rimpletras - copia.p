&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME mesW-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS mesW-Win 
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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR cl-codcia AS INT.

DEF VAR s-task-no AS INT NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-let FILL-IN-let-1 RADIO-tipo_letra ~
BUTTON-print BUTTON-exit 
&Scoped-Define DISPLAYED-OBJECTS tg-formato FILL-IN-let FILL-IN-let-1 ~
RADIO-tipo_letra 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR mesW-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-exit DEFAULT 
     IMAGE-UP FILE "img\exit":U
     LABEL "&Salir" 
     SIZE 8 BY 1.92 TOOLTIP "Salir"
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-print 
     IMAGE-UP FILE "img\print1":U
     LABEL "&Imprimir" 
     SIZE 8 BY 1.92 TOOLTIP "Imprimir".

DEFINE VARIABLE FILL-IN-let AS CHARACTER FORMAT "XXXXXXXXXXXX":U 
     LABEL "Desde Letra" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-let-1 AS CHARACTER FORMAT "XXXXXXXXXXXX":U 
     LABEL "Hasta Letra" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-tipo_letra AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Por Canje", "CJE",
"Adelantadas", "CLA",
"Por Renovación", "RNV",
"Refinanciadas", "REF"
     SIZE 15 BY 3.27 NO-UNDO.

DEFINE VARIABLE tg-formato AS LOGICAL INITIAL yes 
     LABEL "Nuevo Formato" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     tg-formato AT ROW 3.12 COL 14 WIDGET-ID 2
     FILL-IN-let AT ROW 1.19 COL 12 COLON-ALIGNED
     FILL-IN-let-1 AT ROW 2.15 COL 12 COLON-ALIGNED
     RADIO-tipo_letra AT ROW 3.88 COL 14 NO-LABEL
     BUTTON-print AT ROW 1.19 COL 34
     BUTTON-exit AT ROW 1.19 COL 42
     "Tipo de Letra:" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 4.08 COL 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 53.43 BY 6.54
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
  CREATE WINDOW mesW-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Impresión de Letras"
         HEIGHT             = 6.54
         WIDTH              = 53.43
         MAX-HEIGHT         = 7.85
         MAX-WIDTH          = 53.43
         VIRTUAL-HEIGHT     = 7.85
         VIRTUAL-WIDTH      = 53.43
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB mesW-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm/method/viewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW mesW-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR TOGGLE-BOX tg-formato IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(mesW-Win)
THEN mesW-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME mesW-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mesW-Win mesW-Win
ON END-ERROR OF mesW-Win /* Impresión de Letras */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mesW-Win mesW-Win
ON WINDOW-CLOSE OF mesW-Win /* Impresión de Letras */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-exit mesW-Win
ON CHOOSE OF BUTTON-exit IN FRAME F-Main /* Salir */
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-print
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-print mesW-Win
ON CHOOSE OF BUTTON-print IN FRAME F-Main /* Imprimir */
DO:
    ASSIGN
        FILL-IN-let
        FILL-IN-let-1
        RADIO-tipo_letra
        tg-formato.
    RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK mesW-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
/*{src/adm/template/cntnrwin.i}*/

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available mesW-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI mesW-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(mesW-Win)
  THEN DELETE WIDGET mesW-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI mesW-Win  _DEFAULT-ENABLE
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
  DISPLAY tg-formato FILL-IN-let FILL-IN-let-1 RADIO-tipo_letra 
      WITH FRAME F-Main IN WINDOW mesW-Win.
  ENABLE FILL-IN-let FILL-IN-let-1 RADIO-tipo_letra BUTTON-print BUTTON-exit 
      WITH FRAME F-Main IN WINDOW mesW-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW mesW-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir mesW-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR s-titulo AS CHAR NO-UNDO.

/*     IF RADIO-tipo_letra = "RNV" THEN RUN proc_carga-temporal-2. */
/*     ELSE RUN proc_carga-temporal.                               */

    RUN proc_carga-temporal.

    /* Rutina Impresión de Letras */
    IF tg-formato THEN RUN ccb\r-letform2(s-task-no, s-user-id).
    ELSE RUN ccb\r-letform(s-task-no, s-user-id).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit mesW-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_carga-temporal mesW-Win 
PROCEDURE proc_carga-temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE cNroRef AS CHARACTER NO-UNDO.
DEFINE VARIABLE cImpLetras AS CHARACTER NO-UNDO.

DEFINE BUFFER b-dmvto FOR ccbdmvto.

REPEAT:
    s-task-no = RANDOM(1, 999999).
    IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no 
                    AND w-report.Llave-C = s-user-id NO-LOCK) THEN LEAVE.
END.

FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
    AND Ccbcdocu.coddoc = "LET"
    AND Ccbcdocu.fchdoc >= DATE(01,01,2018)     /* OJO */
    AND Ccbcdocu.codref = RADIO-tipo_letra
    AND (FILL-IN-let = "" OR Ccbcdocu.nrodoc >= FILL-IN-let)
    AND (FILL-IN-let-1 = "" OR Ccbcdocu.nrodoc <= FILL-IN-let-1)
    AND Ccbcdocu.flgest <> "A",
    FIRST gn-clie NO-LOCK WHERE gn-clie.codcia = cl-codcia
    AND gn-clie.codcli = Ccbcdocu.codcli:
    cNroRef = "".
    FOR EACH b-dmvto WHERE b-dmvto.CodCia = Ccbcdocu.CodCia 
        AND b-dmvto.CodDoc = Ccbcdocu.CodRef
        AND b-dmvto.NroDoc = Ccbcdocu.NroRef
        AND b-dmvto.TpoRef = "O" NO-LOCK:
        IF cNroRef = "" THEN cNroRef = b-dmvto.NroRef.
        ELSE cNroRef = cNroRef + "," + b-dmvto.NroRef.
    END.
    IF NUM-ENTRIES(cNroRef) > 1 THEN cNroRef = "-".
    RUN bin/_numero (Ccbcdocu.ImpTot, 2, 1, OUTPUT cImpLetras).
    cImpLetras = cImpLetras + (IF Ccbcdocu.codmon = 1 THEN " SOLES" ELSE " DOLARES AMERICANOS").
    CREATE w-report.
    ASSIGN
        w-report.Task-No = s-task-no                /* ID Tarea */
        w-report.Llave-C = s-user-id                /* ID Usuario */
        w-report.Campo-C[1] = Ccbcdocu.NroDoc       /* Número Letra */
        w-report.Campo-C[2] = cNroRef               /* Ref Girador */
        w-report.Campo-D[1] = Ccbcdocu.FchDoc       /* Fecha Giro */
        w-report.Campo-D[2] = Ccbcdocu.FchVto       /* Fecha Vencimiento */
        w-report.Campo-C[3] = (IF Ccbcdocu.codmon = 1 THEN "S/" ELSE "US$")
        w-report.Campo-F[1] = Ccbcdocu.imptot       /* Importe */
        w-report.Campo-C[4] = cImpLetras.           /* Importe Letras */
    ASSIGN
        w-report.Campo-C[5] = gn-clie.NomCli 
        w-report.Campo-C[6] = gn-clie.DirCli 
        w-report.Campo-C[7] = gn-clie.Ruc 
        w-report.Campo-C[8] = gn-clie.Telfnos[1]
        w-report.Campo-C[9] = ENTRY (1, gn-clie.Aval1[1], '|')
        w-report.Campo-C[10] = gn-clie.Aval1[2]
        w-report.Campo-C[11] = ENTRY (1, gn-clie.Aval1[3], '|')
        w-report.Campo-C[12] = gn-clie.Aval1[4]
        w-report.Campo-C[16] = w-report.Campo-C[11]
        NO-ERROR.
    /* RHC 16/08/2016 */
    ASSIGN
        w-report.Campo-C[7] = CcbCDocu.RucCli + CcbCDocu.CodAnt.

    IF NUM-ENTRIES(gn-clie.Aval1[1], '|') = 2 THEN w-report.Campo-C[13] = ENTRY (2, gn-clie.Aval1[1], '|').
    IF NUM-ENTRIES(gn-clie.Aval1[3], '|') = 2 THEN w-report.Campo-C[14] = ENTRY (2, gn-clie.Aval1[3], '|').
    /* datos del conyugue */
    FIND gn-cliecyg OF gn-clie NO-LOCK NO-ERROR.
    IF AVAILABLE Gn-ClieCyg THEN DO:
        ASSIGN
            w-report.Campo-C[20] = Gn-ClieCyg.NomCyg
            w-report.Campo-C[21] = Gn-ClieCyg.NroIde
            w-report.Campo-C[22] = Gn-ClieCyg.Telefono
            w-report.Campo-C[23] = Gn-ClieCyg.Direccion.
    END.
    IF w-report.Campo-C[13] <> '' THEN DO:
        ASSIGN
            w-report.Campo-C[9] = TRIM (w-report.Campo-C[9])
            w-report.Campo-C[13] = TRIM (w-report.Campo-C[13])
            w-report.Campo-C[16] = w-report.Campo-C[11]
            w-report.Campo-C[17] = w-report.Campo-C[14]
            w-report.Campo-C[11] = ''.        
    END.
END.

/*
FOR EACH CCBDMVTO NO-LOCK WHERE
    ccbdmvto.codcia = s-codcia AND
    ccbdmvto.coddoc = RADIO-tipo_letra AND
    ccbdmvto.nrodoc >= "" AND
    ccbdmvto.tporef = "L" AND
    ccbdmvto.nroref >= FILL-IN-let AND
    ccbdmvto.nroref <= FILL-IN-let-1,
    FIRST ccbcmvto NO-LOCK WHERE
    ccbcmvto.codcia = ccbdmvto.codcia AND
    ccbcmvto.coddoc = ccbdmvto.coddoc AND
    ccbcmvto.nrodoc = ccbdmvto.nrodoc
    BREAK BY ccbdmvto.nroref:

    IF ccbcmvto.flgest = "A" THEN NEXT.

    cNroRef = "".
    FOR EACH b-dmvto WHERE
        b-dmvto.CodCia = CcbDMvto.CodCia AND
        b-dmvto.CodDoc = CcbDMvto.CodDoc AND
        b-dmvto.NroDoc = CcbDMvto.NroDoc AND
        b-dmvto.TpoRef = "O" NO-LOCK:
        IF cNroRef = "" THEN cNroRef = b-dmvto.NroRef.
        ELSE cNroRef = cNroRef + "," + b-dmvto.NroRef.
    END.
    IF NUM-ENTRIES(cNroRef) > 1 THEN cNroRef = "-".

    RUN bin/_numero(ccbdmvto.imptot, 2, 1, OUTPUT cImpLetras).
    cImpLetras = cImpLetras +
        IF ccbcmvto.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS".

    FIND gn-clie WHERE
        gn-clie.CodCia = cl-codcia AND
        gn-clie.CodCli = ccbdmvto.CodCli
        NO-LOCK NO-ERROR.


    IF s-task-no = 0 THEN REPEAT:
        s-task-no = RANDOM(1, 999999).
        IF NOT CAN-FIND(FIRST w-report WHERE
            w-report.task-no = s-task-no AND
            w-report.Llave-C = s-user-id NO-LOCK) THEN LEAVE.
    END.

    CREATE w-report.
    ASSIGN
        w-report.Task-No = s-task-no                /* ID Tarea */
        w-report.Llave-C = s-user-id                /* ID Usuario */
        w-report.Campo-C[1] = ccbdmvto.NroRef       /* Número Letra */
        w-report.Campo-C[2] = cNroRef               /* Ref Girador */
        w-report.Campo-D[1] = ccbdmvto.fchemi       /* Fecha Giro */
        w-report.Campo-D[2] = ccbdmvto.fchvto       /* Fecha Vencimiento */
        w-report.Campo-C[3] =                       /* Moneda */
            IF ccbcmvto.codmon = 1
            THEN "S/" ELSE "US$"
        w-report.Campo-F[1] = ccbdmvto.imptot       /* Importe */
        w-report.Campo-C[4] = cImpLetras.           /* Importe Letras */

    IF AVAILABLE gn-clie THEN DO:
        ASSIGN
            w-report.Campo-C[5] = gn-clie.NomCli 
            w-report.Campo-C[6] = gn-clie.DirCli 
            w-report.Campo-C[7] = gn-clie.Ruc 
            w-report.Campo-C[8] = gn-clie.Telfnos[1]
            w-report.Campo-C[9] = ENTRY (1, gn-clie.Aval1[1], '|')
            w-report.Campo-C[10] = gn-clie.Aval1[2]
            w-report.Campo-C[11] = ENTRY (1, gn-clie.Aval1[3], '|')
            w-report.Campo-C[12] = gn-clie.Aval1[4]
            w-report.Campo-C[16] = w-report.Campo-C[11]
            NO-ERROR.
        IF NUM-ENTRIES(gn-clie.Aval1[1], '|') = 2 THEN w-report.Campo-C[13] = ENTRY (2, gn-clie.Aval1[1], '|').
        IF NUM-ENTRIES(gn-clie.Aval1[3], '|') = 2 THEN w-report.Campo-C[14] = ENTRY (2, gn-clie.Aval1[3], '|').
        /* datos del conyugue */
        FIND gn-cliecyg OF gn-clie NO-LOCK NO-ERROR.
        IF AVAILABLE Gn-ClieCyg THEN DO:
            w-report.Campo-C[20] = Gn-ClieCyg.NomCyg.
            w-report.Campo-C[21] = Gn-ClieCyg.NroIde.
            w-report.Campo-C[22] = Gn-ClieCyg.Telefono.
            w-report.Campo-C[23] = Gn-ClieCyg.Direccion.
        END.
    END.

    IF w-report.Campo-C[13] <> '' THEN DO:
        w-report.Campo-C[9] = TRIM (w-report.Campo-C[9]).
        w-report.Campo-C[13] = TRIM (w-report.Campo-C[13]).        
        w-report.Campo-C[16] = w-report.Campo-C[11].        
        w-report.Campo-C[17] = w-report.Campo-C[14].        
        w-report.Campo-C[11] = ''.        
    END.
END.
*/  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records mesW-Win  _ADM-SEND-RECORDS
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed mesW-Win 
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

