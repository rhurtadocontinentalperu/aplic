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
    INDEX i-codper IS PRIMARY t-CodPer ASCENDING.

FIND LAST PL-SEM WHERE
    PL-SEM.CodCia = s-CodCia AND
    PL-SEM.Periodo = s-Periodo NO-LOCK NO-ERROR.

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
&Scoped-Define ENABLED-OBJECTS RECT-7 RECT-8 FILL-IN-NRO-SEM Btn-UP ~
Btn-DOWN Btn-UP-2 FILL-IN-Copias Btn-DOWN-2 B-aceptar 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Msg FILL-IN-NRO-SEM FILL-IN-Copias ~
FILL-IN-CodPer FILL-IN-NroCopia 

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
     SIZE 3 BY .69.

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

DEFINE VARIABLE FILL-IN-CodPer AS CHARACTER FORMAT "X(6)":U 
     LABEL "Personal" 
     VIEW-AS FILL-IN 
     SIZE 6.86 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-Copias AS INTEGER FORMAT "Z9":U INITIAL 0 
     LABEL "Copias" 
     VIEW-AS FILL-IN 
     SIZE 3.14 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Msg AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .81
     BGCOLOR 8 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-NRO-SEM AS INTEGER FORMAT "Z9":U INITIAL 0 
     LABEL "Semana" 
     VIEW-AS FILL-IN 
     SIZE 3.14 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-NroCopia AS INTEGER FORMAT "Z9":U INITIAL 0 
     LABEL "Copia nro." 
     VIEW-AS FILL-IN 
     SIZE 3 BY .81
     BGCOLOR 8 FGCOLOR 9  NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 68.86 BY 2.31
     BGCOLOR 8 FGCOLOR 0 .

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 68.86 BY 1.54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-Msg AT ROW 3.88 COL 1.72 NO-LABEL
     FILL-IN-NRO-SEM AT ROW 1.69 COL 8.43 COLON-ALIGNED
     Btn-UP AT ROW 1.5 COL 13.57
     Btn-DOWN AT ROW 2.12 COL 13.57
     Btn-UP-2 AT ROW 1.58 COL 30.29
     FILL-IN-Copias AT ROW 1.69 COL 24.29 COLON-ALIGNED
     Btn-DOWN-2 AT ROW 2.19 COL 30.29
     B-aceptar AT ROW 1.38 COL 43.14
     FILL-IN-CodPer AT ROW 3.88 COL 48.57 COLON-ALIGNED
     FILL-IN-NroCopia AT ROW 3.88 COL 64 COLON-ALIGNED
     RECT-7 AT ROW 1 COL 1
     RECT-8 AT ROW 3.54 COL 1
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
         HEIGHT             = 4.08
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

/* SETTINGS FOR FILL-IN FILL-IN-CodPer IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Msg IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-NroCopia IN FRAME F-Main
   NO-ENABLE                                                            */
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
    ASSIGN FILL-IN-NRO-SEM FILL-IN-Copias.
    RUN imp_remuneracion.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-DOWN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-DOWN V-table-Win
ON CHOOSE OF Btn-DOWN IN FRAME F-Main
DO:
  IF INPUT FRAME F-Main FILL-IN-NRO-SEM - 1 >= 1 THEN DO:
    DISPLAY INPUT FILL-IN-NRO-SEM - 1 @ FILL-IN-NRO-SEM WITH FRAME F-Main.
    ASSIGN FILL-IN-NRO-SEM.
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
  IF INPUT FRAME F-Main FILL-IN-NRO-SEM + 1 <= 53 THEN DO:
    DISPLAY INPUT FILL-IN-NRO-SEM + 1 @ FILL-IN-NRO-SEM WITH FRAME F-Main.
    ASSIGN FILL-IN-NRO-SEM.
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


&Scoped-define SELF-NAME FILL-IN-NRO-SEM
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NRO-SEM V-table-Win
ON LEAVE OF FILL-IN-NRO-SEM IN FRAME F-Main /* Semana */
DO:
    IF INPUT FILL-IN-NRO-SEM > PL-SEM.NroSem OR INPUT FILL-IN-NRO-SEM = 0 THEN DO:
        BELL.
        MESSAGE "Rango de semana es de 1 a" PL-SEM.NroSem
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FILL-IN-NRO-SEM.
        RETURN NO-APPLY.
    END.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imp_remuneracion V-table-Win 
PROCEDURE imp_remuneracion :
/*------------------------------------------------------------------------------
    Impresi¢n de conceptos.
------------------------------------------------------------------------------*/

FIND PF-CIAS WHERE PF-CIAS.CodCia = s-CodCia NO-LOCK.

DEFINE VARIABLE x-Titulo  AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE x-NroPag  AS INTEGER FORMAT "ZZ9".
DEFINE VARIABLE j         AS INTEGER.
DEFINE VARIABLE x-NomPer  AS CHARACTER.
DEFINE VARIABLE x-val-var AS DECIMAL EXTENT 12 NO-UNDO.

DEFINE VARIABLE BASICO         AS DECIMAL NO-UNDO.
DEFINE VARIABLE DESCUENTOS     AS DECIMAL NO-UNDO.
DEFINE VARIABLE ING-FONDO-AFP  AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-ImpGrl       AS DECIMAL NO-UNDO.

DEFINE VARIABLE x-ImpCol AS DECIMAL EXTENT 8 FORMAT "Z,ZZZ,ZZ9.99".

DEFINE FRAME F-aportaciones
    PL-FLG-SEM.codPer COLUMN-LABEL "C¢digo" FORMAT "x(6)"
    x-NomPer          COLUMN-LABEL "Apellidos y nombres" FORMAT "x(47)"
    PL-FLG-SEM.fecing COLUMN-LABEL "Fecha de!ingreso"
    x-VAL-VAR[1]      COLUMN-LABEL "Jornal   !B sico   " FORMAT "Z,ZZZ,ZZ9.99"
    x-VAL-VAR[2]      COLUMN-LABEL "Incremento !AFP 10.23% " FORMAT "Z,ZZZ,ZZ9.99"
    x-VAL-VAR[3]      COLUMN-LABEL "Incremento !AFP 3%   " FORMAT "Z,ZZZ,ZZ9.99"
    x-VAL-VAR[4]      COLUMN-LABEL "Bonificaci¢n!Tpo.Serv.30%" FORMAT "Z,ZZZ,ZZ9.99"
    x-VAL-VAR[5]      COLUMN-LABEL "Bonificaci¢n!Tpo.Serv.25%" FORMAT "Z,ZZZ,ZZ9.99"
    x-VAL-VAR[6]      COLUMN-LABEL "Asignaci¢n !Por C¢nyugue" FORMAT "Z,ZZZ,ZZ9.99"
    x-VAL-VAR[7]      COLUMN-LABEL "Asignaci¢n !Por Hijo(s)" FORMAT "Z,ZZZ,ZZ9.99"
    x-VAL-VAR[8]      COLUMN-LABEL "Bonificaci¢n!Por Movilidad" FORMAT "Z,ZZZ,ZZ9.99"
    x-VAL-VAR[9]     COLUMN-LABEL "Bonificaci¢n!Por Alimento" FORMAT "Z,ZZZ,ZZ9.99"
    x-VAL-VAR[10]     COLUMN-LABEL "Bonificaci¢n!H. Nocturnas" FORMAT "Z,ZZZ,ZZ9.99"
    x-Imptot          COLUMN-LABEL "Total    !Remuneraci¢n" FORMAT "Z,ZZZ,ZZ9.99"
    DESCUENTOS        COLUMN-LABEL "Total    !Descuentos " FORMAT "Z,ZZZ,ZZ9.99"
    x-ImpGrl          COLUMN-LABEL "Total    !Neto    " FORMAT "Z,ZZZ,ZZ9.99"
    HEADER
    integral.PF-CIAS.NomCia "R E M U N E R A C I O N E S   ** O B R E R O S **" AT 92
    "Fecha :" TO 223 TODAY TO 233 
    integral.PF-CIAS.DirCia x-titulo AT 111
    "P gina :" TO 223 x-NroPag TO 233
    SKIP(1)
    WITH DOWN NO-BOX STREAM-IO WIDTH 250.

ASSIGN
    x-Titulo = "Semana - " + STRING(FILL-IN-NRO-SEM, "Z9")
    FILL-IN-Msg:VISIBLE IN FRAME F-Main = TRUE
    FILL-IN-CodPer:VISIBLE = TRUE
    B-aceptar:SENSITIVE = FALSE
    FILL-IN-Copias:SENSITIVE = FALSE
    FILL-IN-NRO-SEM:SENSITIVE = FALSE
    Btn-UP:SENSITIVE = FALSE
    Btn-UP-2:SENSITIVE = FALSE
    Btn-DOWN:SENSITIVE = FALSE
    Btn-DOWN-2:SENSITIVE = FALSE.


DO i = 1 TO FILL-IN-Copias:

    OUTPUT STREAM strm-aporte TO PRINTER PAGED PAGE-SIZE 66.

    PUT STREAM strm-aporte CONTROL "~033@~0335~033F~033P~033x~001~033E~033C" CHR(66).
    PUT STREAM strm-aporte CONTROL "~033x" NULL "~017~033P".

    DISPLAY i @ FILL-IN-NroCopia WITH FRAME F-Main.

    ASSIGN x-NroPag = 1.

    FOR EACH PL-FLG-SEM NO-LOCK WHERE
        PL-FLG-SEM.CodCia  = s-CodCia AND
        PL-FLG-SEM.Periodo = s-Periodo AND
        PL-FLG-SEM.NroSem  = FILL-IN-NRO-SEM AND
        PL-FLG-SEM.CodPln  = PL-PLAN.CodPln BREAK BY PL-FLG-SEM.NroSem:
        IF LOOKUP(PL-FLG-SEM.SitAct,"Activo,Vacaciones") = 0 THEN NEXT.
        DISPLAY PL-FLG-SEM.CodPer @ FILL-IN-CodPer WITH FRAME F-Main.
        ASSIGN
            x-ImpTot = 0
            x-NomPer = ""
            x-ImpGrl = 0
            DESCUENTOS = 0.
        FIND PL-PERS WHERE PL-PERS.CodPer = PL-FLG-SEM.CodPer NO-LOCK NO-ERROR.
        IF AVAILABLE PL-PERS THEN
            ASSIGN
                x-NomPer = PL-PERS.PatPer + " " + PL-PERS.MatPer + ", " +
                PL-PERS.NomPer.
        DO j = 1 TO 11:
            ASSIGN x-VAL-VAR[j] = 0.
        END.

        RUN PLN/P-CALC-S.R(
            integral.PL-FLG-SEM.Codcia,
            integral.PL-FLG-SEM.Periodo,
            integral.PL-FLG-SEM.NroSem,
            integral.PL-FLG-SEM.codpln,
            0,
            integral.PL-FLG-SEM.codper,
            "^002;^013;^014"
            ).
        ASSIGN
            x-VAL-VAR[1] = VAL-VAR[1]
            BASICO       = VAL-VAR[1]
            x-VAL-VAR[2] = VAL-VAR[2] / 7
            x-VAL-VAR[3] = VAL-VAR[3] / 7.

        /* 009 Bonificaci¢n tpo servicios 30 % */
        RUN PLN/P-CALC-S.R(
            integral.PL-FLG-SEM.Codcia,
            integral.PL-FLG-SEM.PERIODO,
            integral.PL-FLG-SEM.NroSem,
            integral.PL-FLG-SEM.codpln,
            0,
            integral.PL-FLG-SEM.codper,
            "^009"
            ).
        IF VAL-VAR[1] <> 0 THEN x-VAL-VAR[4] = BASICO * 0.30.

        /* 010 Bonificaci¢n tpo servicios 25 % */
        RUN PLN/P-CALC-S.R(
            integral.PL-FLG-SEM.Codcia,
            integral.PL-FLG-SEM.PERIODO,
            integral.PL-FLG-SEM.NroSem,
            integral.PL-FLG-SEM.codpln,
            0,
            integral.PL-FLG-SEM.codper,
            "^010"
            ).
        IF VAL-VAR[1] <> 0 THEN x-VAL-VAR[5] = BASICO * 0.25.

        /* 012 Asignaci¢n x Conyuge */
        IF integral.PL-FLG-SEM.Conyugue THEN x-VAL-VAR[6] = 4 / 30.

        /* 011 Asignaci¢n x Hijos */
        IF integral.PL-FLG-SEM.Nro-de-Hijos > 0 THEN
            ASSIGN x-VAL-VAR[7] = 9.2 / 30.

        /* 007 Bonificaci¢n Movilidad */
        ASSIGN x-VAL-VAR[8] = 0.70 * 3.

        /* 005 Bonificaci¢n Alimentaci¢n */
        RUN PLN/P-CALC-S.R(
            integral.PL-FLG-SEM.Codcia,
            integral.PL-FLG-SEM.Periodo,
            integral.PL-FLG-SEM.NroSem,
            integral.PL-FLG-SEM.codpln,
            0,
            integral.PL-FLG-SEM.codper,
            "^005"
        ).
        IF VAL-VAR[1] > 0 THEN ASSIGN x-VAL-VAR[9] = 1.30.

        /* 227 Horas NOCTUNAS % */
        RUN PLN/P-CALC-S.R(
            integral.PL-FLG-SEM.Codcia,
            integral.PL-FLG-SEM.Periodo,
            integral.PL-FLG-SEM.NroSem,
            integral.PL-FLG-SEM.codpln,
            0,
            integral.PL-FLG-SEM.codper,
            "^227"
            ).
        IF VAL-VAR[1] > 0 THEN x-VAL-VAR[10] = BASICO * .05.

        ASSIGN
            x-Imptot = X-VAL-VAR[1] + X-VAL-VAR[2] + X-VAL-VAR[3] +
            x-VAL-VAR[4] + x-VAL-VAR[5] + x-VAL-VAR[6] + x-VAL-VAR[7] +
            x-VAL-VAR[8] + x-VAL-VAR[9] + x-VAL-VAR[10].
        ASSIGN
            ING-FONDO-AFP = x-VAL-VAR[1] + x-VAL-VAR[4] + x-VAL-VAR[5] + 
            x-VAL-VAR[6] + x-VAL-VAR[7] + x-VAL-VAR[8] + x-VAL-VAR[10].

        /* DESCUENTOS */

        FIND integral.PL-AFPS WHERE
            integral.PL-AFPS.CodAfp = integral.PL-FLG-SEM.CodAfp NO-LOCK NO-ERROR.
        IF NOT AVAILABLE PL-AFPS THEN DO:
            ASSIGN
                DESCUENTOS = (ING-FONDO-AFP + X-VAL-VAR[2] + X-VAL-VAR[3]) * .11.
        END.
        ELSE DO:
            /* 550 APORTE AFP */
            ASSIGN
                DESCUENTOS = ING-FONDO-AFP * (integral.PL-AFPS.fondo-afp / 100).
            ASSIGN DESCUENTOS = DESCUENTOS + integral.PL-AFPS.comision-FIJA-AFP.
            ASSIGN
                DESCUENTOS = DESCUENTOS + (ING-FONDO-AFP * integral.PL-AFPS.comision-porcentual / 100).
            IF ING-FONDO-AFP >= 4677.46 THEN
                ASSIGN
                    DESCUENTOS = DESCUENTOS + (4677.46 * (integral.PL-AFPS.seguro-invalidez / 100)).
            ELSE
                ASSIGN
                   DESCUENTOS = DESCUENTOS + (ING-FONDO-AFP * (integral.PL-AFPS.seguro-invalidez / 100)).
        END.

        /* 506 Quinta categoria */
        RUN PLN/P-CALC-S.R(
            integral.PL-FLG-SEM.Codcia,
            integral.PL-FLG-SEM.Periodo,
            integral.PL-FLG-SEM.NroSem,
            integral.PL-FLG-SEM.codpln,
            0,
            integral.PL-FLG-SEM.codper,
            "^506"
            ).
        DESCUENTOS = DESCUENTOS + (VAL-VAR[1] / 7).

        /* 510 I.P.S.S. VIDA */
        RUN PLN/P-CALC-S.R(
            integral.PL-FLG-SEM.Codcia,
            integral.PL-FLG-SEM.Periodo,
            integral.PL-FLG-SEM.NroSem,
            integral.PL-FLG-SEM.codpln,
            0,
            integral.PL-FLG-SEM.codper,
            "^510"
            ).
        IF VAL-VAR[1] <> 0 THEN ASSIGN DESCUENTOS = DESCUENTOS + (2 / 7).

        /* 603 Retenci¢n Judicial */
        RUN PLN/P-CALC-S.R(
            integral.PL-FLG-SEM.Codcia,
            integral.PL-FLG-SEM.Periodo,
            integral.PL-FLG-SEM.NroSem,
            integral.PL-FLG-SEM.codpln,
            0,
            integral.PL-FLG-SEM.codper,
            "^603"
            ).
        ASSIGN DESCUENTOS = DESCUENTOS + (VAL-VAR[1] / 7).

        /* 610 Comedor */
        RUN PLN/P-CALC-S.R(
            integral.PL-FLG-SEM.Codcia,
            integral.PL-FLG-SEM.Periodo,
            integral.PL-FLG-SEM.NroSem,
            integral.PL-FLG-SEM.codpln,
            0,
            integral.PL-FLG-SEM.codper,
            "^005"
            ).
        IF VAL-VAR[1] > 0 THEN ASSIGN DESCUENTOS = DESCUENTOS + 1.30.
        
        ASSIGN x-ImpGrl = x-Imptot - DESCUENTOS.

        DISPLAY STREAM strm-aporte
            PL-FLG-SEM.codPer
            x-NomPer
            PL-FLG-SEM.fecing
            X-VAL-VAR[1] WHEN (X-VAL-VAR[1] <> 0)
            X-VAL-VAR[2] WHEN (X-VAL-VAR[2] <> 0)
            X-VAL-VAR[3] WHEN (X-VAL-VAR[3] <> 0)
            x-VAL-VAR[4] WHEN (x-VAL-VAR[4] <> 0)
            x-VAL-VAR[5] WHEN (x-VAL-VAR[5] <> 0)
            x-VAL-VAR[6] WHEN (x-VAL-VAR[6] <> 0)
            x-VAL-VAR[7] WHEN (x-VAL-VAR[7] <> 0)
            x-VAL-VAR[8] WHEN (x-VAL-VAR[8] <> 0)
            x-VAL-VAR[9] WHEN (x-VAL-VAR[9] <> 0)
            x-VAL-VAR[10] WHEN (x-VAL-VAR[10] <> 0)
            x-Imptot
            DESCUENTOS
            x-ImpGrl
            WITH FRAME F-Aportaciones.
        ACCUMULATE x-VAL-VAR[1] (SUB-TOTAL BY PL-FLG-SEM.NroSem).
        ACCUMULATE x-VAL-VAR[2] (SUB-TOTAL BY PL-FLG-SEM.NroSem).
        ACCUMULATE x-VAL-VAR[3] (SUB-TOTAL BY PL-FLG-SEM.NroSem).
        ACCUMULATE x-VAL-VAR[4] (SUB-TOTAL BY PL-FLG-SEM.NroSem).
        ACCUMULATE x-VAL-VAR[5] (SUB-TOTAL BY PL-FLG-SEM.NroSem).
        ACCUMULATE x-VAL-VAR[6] (SUB-TOTAL BY PL-FLG-SEM.NroSem).
        ACCUMULATE x-VAL-VAR[7] (SUB-TOTAL BY PL-FLG-SEM.NroSem).
        ACCUMULATE x-VAL-VAR[8] (SUB-TOTAL BY PL-FLG-SEM.NroSem).
        ACCUMULATE x-VAL-VAR[9] (SUB-TOTAL BY PL-FLG-SEM.NroSem).
        ACCUMULATE x-VAL-VAR[10] (SUB-TOTAL BY PL-FLG-SEM.NroSem).
        ACCUMULATE x-Imptot (SUB-TOTAL BY PL-FLG-SEM.NroSem).
        ACCUMULATE DESCUENTOS (SUB-TOTAL BY PL-FLG-SEM.NroSem).
        ACCUMULATE x-ImpGrl (SUB-TOTAL BY PL-FLG-SEM.NroSem).

        IF LINE-COUNTER( strm-aporte ) > 62 THEN DO:
            ASSIGN x-NroPag = x-NroPag + 1.
            PAGE STREAM strm-aporte.
        END.
        IF LAST-OF(PL-FLG-SEM.NroSem) THEN DO:
            UNDERLINE STREAM strm-aporte
                X-VAL-VAR[1]
                X-VAL-VAR[2]
                X-VAL-VAR[3]
                x-VAL-VAR[4]
                x-VAL-VAR[5]
                x-VAL-VAR[6]
                x-VAL-VAR[7]
                x-VAL-VAR[8]
                x-VAL-VAR[9]
                x-VAL-VAR[10]
                x-Imptot 
                DESCUENTOS
                x-ImpGrl
                WITH FRAME F-Aportaciones.
            DISPLAY STREAM strm-aporte
                ACCUM SUB-TOTAL BY (PL-FLG-SEM.NroSem) x-VAL-VAR[1] @ x-VAL-VAR[1]
                ACCUM SUB-TOTAL BY (PL-FLG-SEM.NroSem) x-VAL-VAR[2] @ x-VAL-VAR[2]
                ACCUM SUB-TOTAL BY (PL-FLG-SEM.NroSem) x-VAL-VAR[3] @ x-VAL-VAR[3]
                ACCUM SUB-TOTAL BY (PL-FLG-SEM.NroSem) x-VAL-VAR[4] @ x-VAL-VAR[4]
                ACCUM SUB-TOTAL BY (PL-FLG-SEM.NroSem) x-VAL-VAR[5] @ x-VAL-VAR[5]
                ACCUM SUB-TOTAL BY (PL-FLG-SEM.NroSem) x-VAL-VAR[6] @ x-VAL-VAR[6]
                ACCUM SUB-TOTAL BY (PL-FLG-SEM.NroSem) x-VAL-VAR[7] @ x-VAL-VAR[7]
                ACCUM SUB-TOTAL BY (PL-FLG-SEM.NroSem) x-VAL-VAR[8] @ x-VAL-VAR[8]
                ACCUM SUB-TOTAL BY (PL-FLG-SEM.NroSem) x-VAL-VAR[9] @ x-VAL-VAR[9]
                ACCUM SUB-TOTAL BY (PL-FLG-SEM.NroSem) x-VAL-VAR[10] @ x-VAL-VAR[10]
                ACCUM SUB-TOTAL BY (PL-FLG-SEM.NroSem) x-ImpTot @ x-ImpTot
                ACCUM SUB-TOTAL BY (PL-FLG-SEM.NroSem) DESCUENTOS @ DESCUENTOS
                ACCUM SUB-TOTAL BY (PL-FLG-SEM.NroSem) x-ImpGrl @ x-ImpGrl
                WITH FRAME F-Aportaciones.
        END.
    END.
    OUTPUT STREAM strm-aporte CLOSE.

END.

ASSIGN
    FILL-IN-Msg:VISIBLE IN FRAME F-Main = FALSE
    FILL-IN-CodPer:VISIBLE = FALSE
    FILL-IN-NroCopia:VISIBLE = FALSE
    FILL-IN-NroCopia = 0
    B-aceptar:SENSITIVE = TRUE
    FILL-IN-Copias:SENSITIVE = TRUE
    FILL-IN-NRO-SEM:SENSITIVE = TRUE
    Btn-UP:SENSITIVE = TRUE
    Btn-UP-2:SENSITIVE = TRUE
    Btn-DOWN:SENSITIVE = TRUE
    Btn-DOWN-2:SENSITIVE = TRUE.


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
        FILL-IN-NRO-SEM = s-NroSem
        FILL-IN-Copias  = 2
        FILL-IN-CodPer:VISIBLE IN FRAME F-Main = FALSE
        FILL-IN-Msg:VISIBLE = FALSE
        FILL-IN-NroCopia:VISIBLE = FALSE.

    DISPLAY FILL-IN-NRO-SEM FILL-IN-Copias WITH FRAME F-Main.

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


