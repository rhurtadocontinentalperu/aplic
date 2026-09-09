&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*------------------------------------------------------------------------

  File:

  Description: from VIEWER.W - Template for SmartViewer Objects

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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

{BIN/S-GLOBAL.I}
{PLN/S-GLOBAL.I}

DEFINE NEW GLOBAL SHARED VARIABLE VAL-VAR AS DECIMAL EXTENT 20 FORMAT "Z,ZZZ,ZZ9.99".

DEFINE VARIABLE x-ImpTot AS DECIMAL NO-UNDO.
DEFINE VARIABLE i        AS INTEGER NO-UNDO.

DEFINE STREAM strm-aporte. /* STREAM para el reporte */

DEFINE TEMP-TABLE tmp-aporte
    FIELD t-codPer AS CHARACTER
    FIELD t-NomPer AS CHARACTER
    FIELD t-mtobrt AS DECIMAL
    FIELD t-mtoaft AS DECIMAL
    FIELD t-mtoinc AS DECIMAL
    FIELD t-mtoinf AS DECIMAL
    FIELD t-mtoSNP AS DECIMAL
    FIELD t-mtoSSP AS DECIMAL
    FIELD t-mtoFNV AS DECIMAL
    FIELD t-mtoADT AS DECIMAL
    INDEX i-codper IS PRIMARY t-CodPer ASCENDING.

DEFINE BUTTON Btn_OK IMAGE-UP FILE "img/r-depos"
    LABEL "OK" SIZE 6.43 BY 1.65 BGCOLOR 8 .

DEFINE VARIABLE FILL-IN-Codigo AS CHARACTER FORMAT "X(256)":U 
    LABEL "personal" VIEW-AS FILL-IN SIZE 6.72 BY .81
    BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Des AS CHARACTER FORMAT "X(256)":U 
    VIEW-AS FILL-IN SIZE 20.29 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-20 EDGE-PIXELS 2 GRAPHIC-EDGE NO-FILL SIZE 44.43 BY 2.19.

DEFINE FRAME F-msg
    Btn_OK AT ROW 1.23 COL 3
    FILL-IN-Des AT ROW 1.92 COL 8.43 COLON-ALIGNED NO-LABEL
    FILL-IN-Codigo AT ROW 1.92 COL 35.72 COLON-ALIGNED
    RECT-20 AT ROW 1 COL 1
    "Espere un momento por favor ..." VIEW-AS TEXT
    SIZE 22.57 BY .62 AT ROW 1.31 COL 10.29
    SPACE(12.56) SKIP(1.25)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER
    SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE
    FONT 4 TITLE "Procesando..." CENTERED.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES integral.PL-PLAN
&Scoped-define FIRST-EXTERNAL-TABLE integral.PL-PLAN


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR integral.PL-PLAN.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-7 FILL-IN-NRO-MES Btn-UP Btn-DOWN ~
Btn-UP-2 FILL-IN-Copias Btn-DOWN-2 B-aceptar 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-NRO-MES FILL-IN-Copias 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON B-aceptar 
     IMAGE-UP FILE "img/b-ok":U
     LABEL "&Aceptar" 
     SIZE 10.72 BY 1.54.

DEFINE BUTTON Btn-DOWN 
     IMAGE-UP FILE "img/btn-down":U
     LABEL "" 
     SIZE 3 BY .81.

DEFINE BUTTON Btn-DOWN-2 
     IMAGE-UP FILE "img/btn-down":U
     LABEL "" 
     SIZE 3 BY .69.

DEFINE BUTTON Btn-UP 
     IMAGE-UP FILE "img/btn-up":U
     LABEL "" 
     SIZE 3 BY .69.

DEFINE BUTTON Btn-UP-2 
     IMAGE-UP FILE "img/btn-up":U
     LABEL "" 
     SIZE 3 BY .69.

DEFINE VARIABLE FILL-IN-Copias AS INTEGER FORMAT "Z9":U INITIAL 0 
     LABEL "Copias" 
     VIEW-AS FILL-IN 
     SIZE 3.14 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-NRO-MES AS INTEGER FORMAT "Z9":U INITIAL 0 
     LABEL "Mes" 
     VIEW-AS FILL-IN 
     SIZE 3.14 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 68.86 BY 2.31
     BGCOLOR 8 FGCOLOR 0 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-NRO-MES AT ROW 1.69 COL 8.43 COLON-ALIGNED
     Btn-UP AT ROW 1.42 COL 14.14
     Btn-DOWN AT ROW 1.92 COL 14.14
     Btn-UP-2 AT ROW 1.46 COL 29.57
     FILL-IN-Copias AT ROW 1.69 COL 24.29 COLON-ALIGNED
     Btn-DOWN-2 AT ROW 2.08 COL 29.57
     B-aceptar AT ROW 1.38 COL 43.14
     RECT-7 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.PL-PLAN
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 2.31
         WIDTH              = 68.86.
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit Default                                      */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME B-aceptar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-aceptar V-table-Win
ON CHOOSE OF B-aceptar IN FRAME F-Main /* Aceptar */
DO:
    ASSIGN FILL-IN-NRO-MES FILL-IN-Copias.
    RUN imp_aportes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-DOWN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-DOWN V-table-Win
ON CHOOSE OF Btn-DOWN IN FRAME F-Main
DO:
  IF INPUT FRAME F-Main FILL-IN-NRO-MES - 1 >= 1 THEN DO:
    DISPLAY INPUT FILL-IN-NRO-MES - 1 @ FILL-IN-NRO-MES WITH FRAME F-Main.
    ASSIGN FILL-IN-NRO-MES.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-DOWN-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-DOWN-2 V-table-Win
ON CHOOSE OF Btn-DOWN-2 IN FRAME F-Main
DO:
  IF INPUT FRAME F-Main FILL-IN-Copias - 1 >= 1 THEN DO:
    DISPLAY INPUT FILL-IN-Copias - 1 @ FILL-IN-Copias WITH FRAME F-Main.
    ASSIGN FILL-IN-Copias.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-UP
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-UP V-table-Win
ON CHOOSE OF Btn-UP IN FRAME F-Main
DO:
  IF INPUT FRAME F-Main FILL-IN-NRO-MES + 1 <= 53 THEN DO:
    DISPLAY INPUT FILL-IN-NRO-MES + 1 @ FILL-IN-NRO-MES WITH FRAME F-Main.
    ASSIGN FILL-IN-NRO-MES.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-UP-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-UP-2 V-table-Win
ON CHOOSE OF Btn-UP-2 IN FRAME F-Main
DO:
  IF INPUT FRAME F-Main FILL-IN-Copias + 1 <= 99 THEN DO:
    DISPLAY INPUT FILL-IN-Copias + 1 @ FILL-IN-Copias WITH FRAME F-Main.
    ASSIGN FILL-IN-Copias.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NRO-MES
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NRO-MES V-table-Win
ON LEAVE OF FILL-IN-NRO-MES IN FRAME F-Main /* Mes */
DO:
    IF INPUT FILL-IN-NRO-MES > 12 OR INPUT FILL-IN-NRO-MES = 0 THEN DO:
        BELL.
        MESSAGE "Rango de mes es de 1 a 12"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FILL-IN-NRO-MES.
        RETURN NO-APPLY.
    END.
    IF INPUT FILL-IN-NRO-MES = FILL-IN-NRO-MES THEN RETURN.
    ASSIGN FILL-IN-NRO-MES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE acumula_aportes V-table-Win 
PROCEDURE acumula_aportes :
DEFINE INPUT PARAMETER x-NroSem AS INTEGER.
DEFINE INPUT PARAMETER x-CodCal AS INTEGER.
DEFINE VARIABLE x-valcalI AS DECIMAL NO-UNDO.

DISPLAY
    "C lculo " + STRING(x-CodCal,"99") + ". Semana # " + STRING(x-NroSem,"99") @
    FILL-IN-Des WITH FRAME F-msg.

FOR EACH PL-FLG-SEM WHERE
    PL-FLG-SEM.CodCia  = s-CodCia AND
    PL-FLG-SEM.Periodo = s-Periodo AND
    PL-FLG-SEM.NroSem  = x-NroSem AND
    PL-FLG-SEM.CodPln  = PL-PLAN.CodPln:
    DISPLAY PL-FLG-SEM.CodPer @ FILL-IN-Codigo WITH FRAME F-msg.
    ASSIGN x-valcalI = 0.
    FOR EACH PL-BOLE WHERE
        PL-BOLE.CodPln = PL-PLAN.CodPln AND
        PL-BOLE.CodCal = x-CodCal AND
        PL-BOLE.TpoBol = "Remuneraciones" NO-LOCK:
        FIND PL-MOV-SEM WHERE
            PL-MOV-SEM.CodCia  = s-CodCia AND
            PL-MOV-SEM.Periodo = s-Periodo AND
            PL-MOV-SEM.NroSem  = PL-FLG-SEM.NroSem AND
            PL-MOV-SEM.CodPln  = PL-PLAN.CodPln AND
            PL-MOV-SEM.CodCal  = PL-BOLE.CodCal AND
            PL-MOV-SEM.CodPer  = PL-FLG-SEM.CodPer AND
            PL-MOV-SEM.CodMov  = PL-BOLE.CodMov NO-LOCK NO-ERROR.
        IF AVAILABLE PL-MOV-SEM AND PL-MOV-SEM.ValCal-Sem <> 0 THEN
            ASSIGN x-valcalI = x-valcalI + PL-MOV-SEM.ValCal-Sem.
    END.
    IF x-valcalI > 0 THEN DO:
        RUN pln/p-calc-s.r(
            s-codcia,
            s-PERIODO,
            x-NroSem,
            PL-PLAN.codpln,
            x-codcal,
            PL-FLG-SEM.CodPer,
            "^500;^422;^423;^501;^601;^602;^603"
            ).
        FIND FIRST tmp-aporte WHERE t-CodPer = PL-FLG-SEM.CodPer NO-ERROR.
        IF NOT AVAILABLE tmp-aporte THEN DO:
            CREATE tmp-aporte.
            ASSIGN t-codPer = PL-FLG-SEM.CodPer.
            FIND PL-PERS WHERE PL-PERS.CodPer = PL-FLG-SEM.CodPer NO-LOCK NO-ERROR.
            IF AVAILABLE PL-PERS THEN
                ASSIGN t-NomPer = PL-PERS.PatPer + " " + PL-PERS.MatPer + ", " + PL-PERS.NomPer.
        END.
        ASSIGN
            t-mtobrt = t-mtobrt + x-valcalI
            t-mtoaft = t-mtoaft + VAL-VAR[1]
            t-mtoinc = t-mtoinc + (VAL-VAR[2] + VAL-VAR[3])
            t-mtoinf = t-mtoinf + (x-valcalI - (VAL-VAR[1] + VAL-VAR[2] + VAL-VAR[3]))
            t-mtoSNP = t-mtoSNP + VAL-VAR[4]
            t-mtoSSP = t-mtoSSP + VAL-VAR[5]
            t-mtoFNV = t-mtoFNV + VAL-VAR[6]
            t-mtoADT = t-mtoADT + VAL-VAR[7].
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win _ADM-ROW-AVAILABLE
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "integral.PL-PLAN"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "integral.PL-PLAN"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imp_aportes V-table-Win 
PROCEDURE imp_aportes :
/*------------------------------------------------------------------------------
    Impresi¢n de conceptos.
------------------------------------------------------------------------------*/

FIND PF-CIAS WHERE PF-CIAS.CodCia = s-CodCia NO-LOCK.

DEFINE VARIABLE x-Titulo AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE x-NroPag AS INTEGER FORMAT "ZZ9".

DEFINE VARIABLE x-ImpCol AS DECIMAL EXTENT 8 FORMAT "Z,ZZZ,ZZ9.99".

DEFINE FRAME F-aportaciones
    t-codPer COLUMN-LABEL "C¢digo" FORMAT "x(6)"
    t-NomPer COLUMN-LABEL "Apellidos y nombres" FORMAT "x(35)"
    t-mtobrt COLUMN-LABEL "Monto    !Bruto    " FORMAT "Z,ZZZ,ZZ9.99"
    t-mtoaft COLUMN-LABEL "Monto    !Afecto   " FORMAT "Z,ZZZ,ZZ9.99"
    t-mtoinc COLUMN-LABEL "Incrementos !A.F.P.   " FORMAT "Z,ZZZ,ZZ9.99"
    t-mtoinf COLUMN-LABEL "Monto    !Inafecto  " FORMAT "Z,ZZZ,ZZ9.99"
    t-mtoSNP COLUMN-LABEL "Monto    !S.N.P.   " FORMAT "Z,ZZZ,ZZ9.99"
    t-mtoSSP COLUMN-LABEL "Monto    !S.S.P./EMPL." FORMAT "Z,ZZZ,ZZ9.99"
    t-mtoFNV COLUMN-LABEL "Monto    !FONAVI/EMPL." FORMAT "Z,ZZZ,ZZ9.99"
    t-mtoADT COLUMN-LABEL "Monto    !ACC./TRABAJO" FORMAT "Z,ZZZ,ZZ9.99"
    HEADER
    integral.PF-CIAS.NomCia "CUADRO DE APORTACIONES ** O B R E R O S **" AT 54
    "Fecha :" TO 138 TODAY TO 148 
    integral.PF-CIAS.DirCia x-titulo AT 66
    "P gina :" TO 138 x-NroPag TO 148
    SKIP(1)
    WITH DOWN NO-BOX STREAM-IO WIDTH 150.

RUN bin/_mes.r( FILL-IN-NRO-MES, 1 , OUTPUT x-titulo ).

ASSIGN x-Titulo = x-Titulo + " - " + STRING(s-Periodo, "9,999").

/* Llenamos temporal para cada calculo */

FOR EACH PL-SEM WHERE PL-SEM.NroMes = FILL-IN-NRO-MES NO-LOCK:
    RUN acumula_aportes(PL-SEM.NroSem,1).
    RUN acumula_aportes(PL-SEM.NroSem,3).
    RUN acumula_aportes(PL-SEM.NroSem,4).
END.

ASSIGN FRAME F-msg:TITLE = "Imprimiendo...".

DO i = 1 TO FILL-IN-Copias:

    DISPLAY
        "Imprimiendo copia # " + STRING(i,"Z9") + " para" @
        FILL-IN-Des WITH FRAME F-msg.

    OUTPUT STREAM strm-aporte TO PRINTER PAGED PAGE-SIZE 66.

    PUT STREAM strm-aporte CONTROL "~033@~0335~033F~033P~033x~001~033E~033C" CHR(66).
    PUT STREAM strm-aporte CONTROL "~033x" NULL "~017~033P".

    ASSIGN x-NroPag = 1
        x-ImpCol[1] = 0
        x-ImpCol[2] = 0
        x-ImpCol[3] = 0
        x-ImpCol[4] = 0
        x-ImpCol[5] = 0
        x-ImpCol[6] = 0
        x-ImpCol[7] = 0
        x-ImpCol[8] = 0.

    FOR EACH tmp-aporte NO-LOCK:
        DISPLAY t-CodPer @ FILL-IN-Codigo WITH FRAME F-msg.
        DISPLAY STREAM strm-aporte
            t-CodPer
            t-NomPer
            t-mtobrt
            t-mtoaft
            t-mtoinc WHEN ( t-mtoinc > 0 )
            t-mtoinf
            t-mtoSNP WHEN ( t-mtoSNP > 0 )
            t-mtoSSP
            t-mtoFNV
            t-mtoADT
            WITH FRAME F-aportaciones.
        ASSIGN
            x-ImpCol[1] = x-ImpCol[1] + t-mtobrt
            x-ImpCol[2] = x-ImpCol[2] + t-mtoaft
            x-ImpCol[3] = x-ImpCol[3] + t-mtoinc
            x-ImpCol[4] = x-ImpCol[4] + t-mtoinf
            x-ImpCol[5] = x-ImpCol[5] + t-mtoSNP
            x-ImpCol[6] = x-ImpCol[6] + t-mtoSSP
            x-ImpCol[7] = x-ImpCol[7] + t-mtoFNV.
            x-ImpCol[8] = x-ImpCol[8] + t-mtoADT.

        IF LINE-COUNTER( strm-aporte ) > 62 THEN DO:
            ASSIGN x-NroPag = x-NroPag + 1.
            PAGE STREAM strm-aporte.
        END.
    END.
    PUT STREAM strm-aporte "" SKIP.
    PUT STREAM strm-aporte
        FILL(" ",33) FORMAT "X(33)"
        "TOTALES : "
        x-ImpCol[1] " "
        x-ImpCol[2] " "
        x-ImpCol[3] " "
        x-ImpCol[4] " "
        x-ImpCol[5] " "
        x-ImpCol[6] " "
        x-ImpCol[7] " "
        x-ImpCol[8].

    OUTPUT STREAM strm-aporte CLOSE.

END.

HIDE FRAME F-msg.

FOR EACH tmp-aporte:
    DELETE tmp-aporte.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
    ASSIGN
        FILL-IN-NRO-MES = s-NroMes
        FILL-IN-Copias  = 2.

    DISPLAY FILL-IN-NRO-MES FILL-IN-Copias WITH FRAME F-Main.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "integral.PL-PLAN"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


