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
&Scoped-Define ENABLED-OBJECTS RECT-7 FILL-IN-NRO-MES RECT-8 Btn-UP ~
Btn-DOWN FILL-IN-Copias Btn-UP-2 Btn-DOWN-2 R-seleccion B-aceptar 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-NRO-MES FILL-IN-Msg FILL-IN-Copias ~
R-seleccion FILL-IN-CodPer FILL-IN-NroCopia 

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

DEFINE VARIABLE FILL-IN-NRO-MES AS INTEGER FORMAT "Z9":U INITIAL 0 
     LABEL "Mes" 
     VIEW-AS FILL-IN 
     SIZE 3.14 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-NroCopia AS INTEGER FORMAT "Z9":U INITIAL 0 
     LABEL "Copia nro." 
     VIEW-AS FILL-IN 
     SIZE 3 BY .81
     BGCOLOR 8 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE R-seleccion AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Remuneraciones", 1,
"Descuentos", 2,
"Aportes Empl.", 3
     SIZE 15.14 BY 1.69 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 68.86 BY 2.31
     BGCOLOR 8 FGCOLOR 0 .

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 68.86 BY 1.54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-NRO-MES AT ROW 1.69 COL 3.57 COLON-ALIGNED
     FILL-IN-Msg AT ROW 3.88 COL 1.72 NO-LABEL
     Btn-UP AT ROW 1.42 COL 8.86
     Btn-DOWN AT ROW 2.04 COL 8.86
     FILL-IN-Copias AT ROW 1.73 COL 16.14 COLON-ALIGNED
     Btn-UP-2 AT ROW 1.46 COL 21.72
     Btn-DOWN-2 AT ROW 2.08 COL 21.72
     R-seleccion AT ROW 1.31 COL 26 NO-LABEL
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
    ASSIGN FILL-IN-NRO-MES FILL-IN-Copias R-seleccion.
    CASE R-Seleccion:
    WHEN 1 THEN RUN imp_remuneracion.
    WHEN 2 THEN RUN imp_descuento.
    WHEN 3 THEN RUN imp_aporte.
    END CASE.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imp_aporte V-table-Win 
PROCEDURE imp_aporte :
/*------------------------------------------------------------------------------
    Impresi¢n de conceptos.
------------------------------------------------------------------------------*/

FIND PF-CIAS WHERE PF-CIAS.CodCia = s-CodCia NO-LOCK.

DEFINE VARIABLE x-Titulo  AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE x-NroPag  AS INTEGER FORMAT "ZZ9".
DEFINE VARIABLE x-NroOrd  AS INTEGER FORMAT "ZZZ9".
DEFINE VARIABLE j         AS INTEGER.
DEFINE VARIABLE x-NomPer  AS CHARACTER.
DEFINE VARIABLE x-val-var AS DECIMAL EXTENT 12 NO-UNDO.

DEFINE FRAME F-aportaciones
    x-NroOrd          COLUMN-LABEL "Ord"
    PL-FLG-MES.codPer COLUMN-LABEL "C¢digo" FORMAT "x(6)"
    x-NomPer          COLUMN-LABEL "Apellidos y nombres" FORMAT "x(50)"
    x-VAL-VAR[1]      COLUMN-LABEL "!R. P. S.  " FORMAT "Z,ZZZ,ZZ9.99"
    x-VAL-VAR[2]      COLUMN-LABEL "!FONAVI   " FORMAT "Z,ZZZ,ZZ9.99"
    x-Imptot          COLUMN-LABEL "Total    !Aportaci¢n " FORMAT "Z,ZZZ,ZZ9.99"
    HEADER
    integral.PF-CIAS.NomCia "APORTACIONES DEL EMPLEADOR ( EMPLEADOS )"  AT 55
    "Fecha :" TO 130 TODAY TO 140
    integral.PF-CIAS.DirCia x-titulo AT 70
    "P gina :" TO 130 x-NroPag TO 140
    SKIP(1)
    WITH DOWN NO-BOX STREAM-IO WIDTH 150.

RUN bin/_mes.r( FILL-IN-NRO-MES, 1 , OUTPUT x-titulo ).

ASSIGN
    x-Titulo = x-Titulo + " - " + STRING(s-Periodo, "9,999")
    FILL-IN-Msg:VISIBLE IN FRAME F-Main = TRUE
    FILL-IN-CodPer:VISIBLE = TRUE
    B-aceptar:SENSITIVE = FALSE
    FILL-IN-Copias:SENSITIVE = FALSE
    FILL-IN-NRO-MES:SENSITIVE = FALSE
    Btn-UP:SENSITIVE = FALSE
    Btn-UP-2:SENSITIVE = FALSE
    Btn-DOWN:SENSITIVE = FALSE
    Btn-DOWN-2:SENSITIVE = FALSE.


DO i = 1 TO FILL-IN-Copias:

    OUTPUT STREAM strm-aporte TO PRINTER PAGED PAGE-SIZE 66.

    PUT STREAM strm-aporte CONTROL "~033@~0335~033F~033P~033x~001~033E~033C" CHR(66).
    PUT STREAM strm-aporte CONTROL "~033x" NULL "~017~033P".

    DISPLAY i @ FILL-IN-NroCopia WITH FRAME F-Main.

    ASSIGN
        x-NroPag = 1
        x-NroOrd = 0.

    FOR EACH PL-FLG-MES NO-LOCK WHERE
        PL-FLG-MES.CodCia  = s-CodCia AND
        PL-FLG-MES.Periodo = s-Periodo AND
        PL-FLG-MES.NroMes  = FILL-IN-NRO-MES AND
        PL-FLG-MES.CodPln  = PL-PLAN.CodPln BREAK BY PL-FLG-MES.NroMes:
        IF PL-FLG-MES.SitAct = "Inactivo" THEN NEXT.
        DISPLAY PL-FLG-MES.CodPer @ FILL-IN-CodPer WITH FRAME F-Main.
        ASSIGN
            x-ImpTot = 0
            x-NomPer = "".

        FIND PL-PERS WHERE PL-PERS.CodPer = PL-FLG-MES.CodPer NO-LOCK NO-ERROR.
        IF AVAILABLE PL-PERS THEN
            ASSIGN
                x-NomPer = PL-PERS.PatPer + " " + PL-PERS.MatPer + ", " +
                PL-PERS.NomPer.
        DO j = 1 TO 12:
            ASSIGN x-VAL-VAR[j] = 0.
        END.

        RUN PLN/P-CALC-M.R(
            integral.PL-FLG-MES.Codcia,
            integral.PL-FLG-MES.PERIODO,
            integral.PL-FLG-MES.NROMES,
            integral.PL-FLG-MES.codpln,
            1,
            integral.PL-FLG-MES.codper,
            "^601;^602"
            ).

        ASSIGN
            x-NroOrd = x-NroOrd + 1
            x-VAL-VAR[1] = VAL-VAR[1]
            x-VAL-VAR[2] = VAL-VAR[2].

        ASSIGN
            x-Imptot = X-VAL-VAR[1] + X-VAL-VAR[2] + X-VAL-VAR[3] +
            x-VAL-VAR[4] + x-VAL-VAR[5] + x-VAL-VAR[6] + x-VAL-VAR[7] +
            x-VAL-VAR[8] + x-VAL-VAR[9] + x-VAL-VAR[10].

        DISPLAY STREAM strm-aporte
            x-NroOrd
            PL-FLG-MES.codPer
            x-NomPer
            x-VAL-VAR[1] WHEN x-VAL-VAR[1] <> 0
            x-VAL-VAR[2] WHEN x-VAL-VAR[2] <> 0
            x-ImpTot WITH FRAME F-aportaciones.

        ACCUMULATE x-VAL-VAR[1] (SUB-TOTAL BY PL-FLG-MES.NroMes).
        ACCUMULATE x-VAL-VAR[2] (SUB-TOTAL BY PL-FLG-MES.NroMes).
        ACCUMULATE x-Imptot (SUB-TOTAL BY PL-FLG-MES.NroMes).

        IF LINE-COUNTER( strm-aporte ) > 62 THEN DO:
            ASSIGN x-NroPag = x-NroPag + 1.
            PAGE STREAM strm-aporte.
        END.
        IF LAST-OF(PL-FLG-MES.NroMes) THEN DO:
            UNDERLINE STREAM strm-aporte
                x-NroOrd
                X-VAL-VAR[1]
                X-VAL-VAR[2]
                x-Imptot
                WITH FRAME F-Aportaciones.
            DISPLAY STREAM strm-aporte
                x-NroOrd
                ACCUM SUB-TOTAL BY (PL-FLG-MES.NroMes) x-VAL-VAR[1] @ x-VAL-VAR[1]
                ACCUM SUB-TOTAL BY (PL-FLG-MES.NroMes) x-VAL-VAR[2] @ x-VAL-VAR[2]
                ACCUM SUB-TOTAL BY (PL-FLG-MES.NroMes) x-ImpTot @ x-ImpTot
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
    FILL-IN-NRO-MES:SENSITIVE = TRUE
    Btn-UP:SENSITIVE = TRUE
    Btn-UP-2:SENSITIVE = TRUE
    Btn-DOWN:SENSITIVE = TRUE
    Btn-DOWN-2:SENSITIVE = TRUE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imp_descuento V-table-Win 
PROCEDURE imp_descuento :
/*------------------------------------------------------------------------------
    Impresi¢n de conceptos.
------------------------------------------------------------------------------*/

FIND PF-CIAS WHERE PF-CIAS.CodCia = s-CodCia NO-LOCK.

DEFINE VARIABLE x-Titulo  AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE x-NroPag  AS INTEGER FORMAT "ZZ9".
DEFINE VARIABLE x-NroOrd  AS INTEGER FORMAT "ZZZ9".
DEFINE VARIABLE j         AS INTEGER.
DEFINE VARIABLE x-NomPer  AS CHARACTER.
DEFINE VARIABLE x-val-var AS DECIMAL EXTENT 20 NO-UNDO.

DEFINE FRAME F-aportaciones
    x-NroOrd          COLUMN-LABEL "Ord"
    PL-FLG-MES.codPer COLUMN-LABEL "C¢digo" FORMAT "x(6)"
    x-NomPer          COLUMN-LABEL "Apellidos y nombres" FORMAT "x(40)"
    x-VAL-VAR[1]      COLUMN-LABEL "!S.N.P.   " FORMAT "Z,ZZZ,ZZ9.99"
    x-VAL-VAR[2]      COLUMN-LABEL "Pensiones  !AFP     " FORMAT "Z,ZZZ,ZZ9.99"
    x-VAL-VAR[3]      COLUMN-LABEL "Seguro-Vida!AFP     " FORMAT "Z,ZZZ,ZZ9.99"
    x-VAL-VAR[4]      COLUMN-LABEL "Comisi¢n  !Fija AFP  " FORMAT "Z,ZZZ,ZZ9.99"
    x-VAL-VAR[5]      COLUMN-LABEL "Comisi¢n  !Porcen. AFP " FORMAT "Z,ZZZ,ZZ9.99"
    x-VAL-VAR[6]      COLUMN-LABEL "!IPSS Vida  " FORMAT "Z,ZZZ,ZZ9.99"
    x-VAL-VAR[7]      COLUMN-LABEL "Renta de  !Quinta Cat. " FORMAT "Z,ZZZ,ZZ9.99"
    x-VAL-VAR[8]      COLUMN-LABEL "!Tardanzas  " FORMAT "Z,ZZZ,ZZ9.99"
    x-VAL-VAR[9]      COLUMN-LABEL "Retenci¢n  !Judicial  " FORMAT "Z,ZZZ,ZZ9.99"
    x-VAL-VAR[10]     COLUMN-LABEL "Adelanto de !Sueldo   " FORMAT "Z,ZZZ,ZZ9.99"
    x-VAL-VAR[11]     COLUMN-LABEL "Total    !Pr‚stamos  " FORMAT "Z,ZZZ,ZZ9.99"
    x-VAL-VAR[12]     COLUMN-LABEL "Otros    !Descuentos " FORMAT "Z,ZZZ,ZZ9.99"
    x-Imptot          COLUMN-LABEL "Total    !Descuentos " FORMAT "Z,ZZZ,ZZ9.99"

    HEADER
    integral.PF-CIAS.NomCia "D E S C U E N T O S   ** E M P L E A D O S **" AT 90
    "Fecha :" TO 223 TODAY TO 233 
    integral.PF-CIAS.DirCia x-titulo AT 100
    "P gina :" TO 223 x-NroPag TO 233
    SKIP(1)
    WITH DOWN NO-BOX STREAM-IO WIDTH 250.

RUN bin/_mes.r( FILL-IN-NRO-MES, 1 , OUTPUT x-titulo ).

ASSIGN
    x-Titulo = x-Titulo + " - " + STRING(s-Periodo, "9,999")
    FILL-IN-Msg:VISIBLE IN FRAME F-Main = TRUE
    FILL-IN-CodPer:VISIBLE = TRUE
    B-aceptar:SENSITIVE = FALSE
    FILL-IN-Copias:SENSITIVE = FALSE
    FILL-IN-NRO-MES:SENSITIVE = FALSE
    Btn-UP:SENSITIVE = FALSE
    Btn-UP-2:SENSITIVE = FALSE
    Btn-DOWN:SENSITIVE = FALSE
    Btn-DOWN-2:SENSITIVE = FALSE.    

DO i = 1 TO FILL-IN-Copias:

    OUTPUT STREAM strm-aporte TO PRINTER PAGED PAGE-SIZE 66.

    PUT STREAM strm-aporte CONTROL "~033@~0335~033F~033P~033x~001~033E~033C" CHR(66).
    PUT STREAM strm-aporte CONTROL "~033x" NULL "~017~033P".

    DISPLAY i @ FILL-IN-NroCopia WITH FRAME F-Main.

    ASSIGN
        x-NroPag = 1
        x-NroOrd = 0.

    FOR EACH PL-FLG-MES NO-LOCK WHERE
        PL-FLG-MES.CodCia  = s-CodCia AND
        PL-FLG-MES.Periodo = s-Periodo AND
        PL-FLG-MES.NroMes  = FILL-IN-NRO-MES AND
        PL-FLG-MES.CodPln  = PL-PLAN.CodPln BREAK BY PL-FLG-MES.NroMes:
        IF PL-FLG-MES.SitAct = "Inactivo" THEN NEXT.
        DISPLAY PL-FLG-MES.CodPer @ FILL-IN-CodPer WITH FRAME F-Main.
        ASSIGN
            x-ImpTot = 0
            x-NomPer = "".
        FIND PL-PERS WHERE PL-PERS.CodPer = PL-FLG-MES.CodPer NO-LOCK NO-ERROR.
        IF AVAILABLE PL-PERS THEN
            ASSIGN
                x-NomPer = PL-PERS.PatPer + " " + PL-PERS.MatPer + ", " +
                PL-PERS.NomPer.
        DO j = 1 TO 20:
            ASSIGN x-VAL-VAR[j] = 0.
        END.

        RUN PLN/P-CALC-M.R(
            integral.PL-FLG-MES.Codcia,
            integral.PL-FLG-MES.PERIODO,
            integral.PL-FLG-MES.NROMES,
            integral.PL-FLG-MES.codpln,
            1,
            integral.PL-FLG-MES.codper,
            "^501;^503;^504;^505;^506;^508;^509;^511;^512;^513;^514;^515;^516;^517;^507"
            ).

        ASSIGN
            x-NroOrd = x-NroOrd + 1
            x-VAL-VAR[1] = VAL-VAR[1]
            x-VAL-VAR[2] = VAL-VAR[2]
            x-VAL-VAR[3] = VAL-VAR[3]
            x-VAL-VAR[4] = VAL-VAR[4]
            x-VAL-VAR[5] = VAL-VAR[5]
            x-VAL-VAR[6] = VAL-VAR[6]
            x-VAL-VAR[7] = VAL-VAR[7]
            x-VAL-VAR[8] = VAL-VAR[8]
            x-VAL-VAR[9] = VAL-VAR[9]
            x-VAL-VAR[10] = VAL-VAR[10]
            x-VAL-VAR[11] = VAL-VAR[11] + VAL-VAR[12] + VAL-VAR[13] + VAL-VAR[14]
            x-VAL-VAR[12] = VAL-VAR[15].
        ASSIGN
            x-Imptot = X-VAL-VAR[1] + X-VAL-VAR[2] + X-VAL-VAR[3] +
            x-VAL-VAR[4] + x-VAL-VAR[5] + x-VAL-VAR[6] + x-VAL-VAR[7] +
            x-VAL-VAR[8] + x-VAL-VAR[9] + x-VAL-VAR[10] + x-VAL-VAR[11] +
            x-VAL-VAR[12].

        DISPLAY STREAM strm-aporte
            x-NroOrd
            PL-FLG-MES.codPer
            x-NomPer
            x-VAL-VAR[1] WHEN x-VAL-VAR[1] <> 0
            x-VAL-VAR[2] WHEN x-VAL-VAR[2] <> 0
            x-VAL-VAR[3] WHEN x-VAL-VAR[3] <> 0
            x-VAL-VAR[4] WHEN x-VAL-VAR[4] <> 0
            x-VAL-VAR[5] WHEN x-VAL-VAR[5] <> 0
            x-VAL-VAR[6] WHEN x-VAL-VAR[6] <> 0
            x-VAL-VAR[7] WHEN x-VAL-VAR[7] <> 0
            x-VAL-VAR[8] WHEN x-VAL-VAR[8] <> 0
            x-VAL-VAR[9] WHEN x-VAL-VAR[9] <> 0
            x-VAL-VAR[10] WHEN x-VAL-VAR[10] <> 0
            x-VAL-VAR[11] WHEN x-VAL-VAR[11] <> 0
            x-VAL-VAR[12] WHEN x-VAL-VAR[12] <> 0
            x-ImpTot WITH FRAME F-aportaciones.

        ACCUMULATE x-VAL-VAR[1] (SUB-TOTAL BY PL-FLG-MES.NroMes).
        ACCUMULATE x-VAL-VAR[2] (SUB-TOTAL BY PL-FLG-MES.NroMes).
        ACCUMULATE x-VAL-VAR[3] (SUB-TOTAL BY PL-FLG-MES.NroMes).
        ACCUMULATE x-VAL-VAR[4] (SUB-TOTAL BY PL-FLG-MES.NroMes).
        ACCUMULATE x-VAL-VAR[5] (SUB-TOTAL BY PL-FLG-MES.NroMes).
        ACCUMULATE x-VAL-VAR[6] (SUB-TOTAL BY PL-FLG-MES.NroMes).
        ACCUMULATE x-VAL-VAR[7] (SUB-TOTAL BY PL-FLG-MES.NroMes).
        ACCUMULATE x-VAL-VAR[8] (SUB-TOTAL BY PL-FLG-MES.NroMes).
        ACCUMULATE x-VAL-VAR[9] (SUB-TOTAL BY PL-FLG-MES.NroMes).
        ACCUMULATE x-VAL-VAR[10] (SUB-TOTAL BY PL-FLG-MES.NroMes).
        ACCUMULATE x-VAL-VAR[11] (SUB-TOTAL BY PL-FLG-MES.NroMes).
        ACCUMULATE x-VAL-VAR[12] (SUB-TOTAL BY PL-FLG-MES.NroMes).
        ACCUMULATE x-Imptot (SUB-TOTAL BY PL-FLG-MES.NroMes).

        IF LINE-COUNTER( strm-aporte ) > 62 THEN DO:
            ASSIGN x-NroPag = x-NroPag + 1.
            PAGE STREAM strm-aporte.
        END.
        IF LAST-OF(PL-FLG-MES.NroMes) THEN DO:
            UNDERLINE STREAM strm-aporte
                x-NroOrd
                X-VAL-VAR[1]
                X-VAL-VAR[2]
                X-VAL-VAR[3]
                x-VAL-VAR[4]
                x-VAL-VAR[5]
                X-VAL-VAR[6]
                X-VAL-VAR[7]
                X-VAL-VAR[8]
                x-VAL-VAR[9]
                x-VAL-VAR[10]
                x-VAL-VAR[11]
                x-VAL-VAR[12]
                x-Imptot
                WITH FRAME F-Aportaciones.
            DISPLAY STREAM strm-aporte
                x-NroOrd
                ACCUM SUB-TOTAL BY (PL-FLG-MES.NroMes) x-VAL-VAR[1] @ x-VAL-VAR[1]
                ACCUM SUB-TOTAL BY (PL-FLG-MES.NroMes) x-VAL-VAR[2] @ x-VAL-VAR[2]
                ACCUM SUB-TOTAL BY (PL-FLG-MES.NroMes) x-VAL-VAR[3] @ x-VAL-VAR[3]
                ACCUM SUB-TOTAL BY (PL-FLG-MES.NroMes) x-VAL-VAR[4] @ x-VAL-VAR[4]
                ACCUM SUB-TOTAL BY (PL-FLG-MES.NroMes) x-VAL-VAR[5] @ x-VAL-VAR[5]
                ACCUM SUB-TOTAL BY (PL-FLG-MES.NroMes) x-VAL-VAR[6] @ x-VAL-VAR[6]
                ACCUM SUB-TOTAL BY (PL-FLG-MES.NroMes) x-VAL-VAR[7] @ x-VAL-VAR[7]
                ACCUM SUB-TOTAL BY (PL-FLG-MES.NroMes) x-VAL-VAR[8] @ x-VAL-VAR[8]
                ACCUM SUB-TOTAL BY (PL-FLG-MES.NroMes) x-VAL-VAR[9] @ x-VAL-VAR[9]
                ACCUM SUB-TOTAL BY (PL-FLG-MES.NroMes) x-VAL-VAR[10] @ x-VAL-VAR[10]
                ACCUM SUB-TOTAL BY (PL-FLG-MES.NroMes) x-VAL-VAR[11] @ x-VAL-VAR[11]
                ACCUM SUB-TOTAL BY (PL-FLG-MES.NroMes) x-VAL-VAR[12] @ x-VAL-VAR[12]
                ACCUM SUB-TOTAL BY (PL-FLG-MES.NroMes) x-ImpTot @ x-ImpTot
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
    FILL-IN-NRO-MES:SENSITIVE = TRUE
    Btn-UP:SENSITIVE = TRUE
    Btn-UP-2:SENSITIVE = TRUE
    Btn-DOWN:SENSITIVE = TRUE
    Btn-DOWN-2:SENSITIVE = TRUE.


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
DEFINE VARIABLE x-NroOrd  AS INTEGER FORMAT "ZZZ9".
DEFINE VARIABLE j         AS INTEGER.
DEFINE VARIABLE x-NomPer  AS CHARACTER.
DEFINE VARIABLE x-val-var AS DECIMAL EXTENT 12 NO-UNDO.

DEFINE FRAME F-aportaciones
    x-NroOrd          COLUMN-LABEL "Ord"
    PL-FLG-MES.codPer COLUMN-LABEL "C¢digo" FORMAT "x(6)"
    x-NomPer          COLUMN-LABEL "Apellidos y nombres" FORMAT "x(50)"
    x-VAL-VAR[1]      COLUMN-LABEL "Sueldo   !B sico   " FORMAT "Z,ZZZ,ZZ9.99"
    x-VAL-VAR[2]      COLUMN-LABEL "Incremento !AFP 10.23% " FORMAT "Z,ZZZ,ZZ9.99"
    x-VAL-VAR[3]      COLUMN-LABEL "Incremento !AFP 3%   " FORMAT "Z,ZZZ,ZZ9.99"
    x-VAL-VAR[4]      COLUMN-LABEL "Incremento !de Ley 26504" FORMAT "Z,ZZZ,ZZ9.99"
    x-VAL-VAR[5]      COLUMN-LABEL "Asignaci¢n !Familiar  " FORMAT "Z,ZZZ,ZZ9.99"
    x-VAL-VAR[6]      COLUMN-LABEL "Horas    !Extras   " FORMAT "Z,ZZZ,ZZ9.99"
    x-VAL-VAR[7]      COLUMN-LABEL "Gratificac. !Extraord.  " FORMAT "Z,ZZZ,ZZ9.99"
    x-VAL-VAR[8]      COLUMN-LABEL "Subsidio  !Enfermedad " FORMAT "Z,ZZZ,ZZ9.99"
    x-VAL-VAR[9]      COLUMN-LABEL "Participac. !Utilidades " FORMAT "Z,ZZZ,ZZ9.99"
    x-VAL-VAR[10]     COLUMN-LABEL "Subsidio  !Maternidad " FORMAT "Z,ZZZ,ZZ9.99"
    x-VAL-VAR[11]     COLUMN-LABEL "Monto    !Afecto   " FORMAT "Z,ZZZ,ZZ9.99"
    x-Imptot          COLUMN-LABEL "Total    !Remuneraci¢n" FORMAT "Z,ZZZ,ZZ9.99"
    x-VAL-VAR[12]     COLUMN-LABEL "Total    !Neto    " FORMAT "Z,ZZZ,ZZ9.99"
    HEADER
    integral.PF-CIAS.NomCia "R E M U N E R A C I O N E S   ** E M P L E A D O S **" AT 90
    "Fecha :" TO 223 TODAY TO 233 
    integral.PF-CIAS.DirCia x-titulo AT 100
    "P gina :" TO 223 x-NroPag TO 233
    SKIP(1)
    WITH DOWN NO-BOX STREAM-IO WIDTH 250.

RUN bin/_mes.r( FILL-IN-NRO-MES, 1 , OUTPUT x-titulo ).

ASSIGN
    x-Titulo = x-Titulo + " - " + STRING(s-Periodo, "9,999")
    FILL-IN-Msg:VISIBLE IN FRAME F-Main = TRUE
    FILL-IN-CodPer:VISIBLE = TRUE
    B-aceptar:SENSITIVE = FALSE
    FILL-IN-Copias:SENSITIVE = FALSE
    FILL-IN-NRO-MES:SENSITIVE = FALSE
    Btn-UP:SENSITIVE = FALSE
    Btn-UP-2:SENSITIVE = FALSE
    Btn-DOWN:SENSITIVE = FALSE
    Btn-DOWN-2:SENSITIVE = FALSE.

DO i = 1 TO FILL-IN-Copias:

    OUTPUT STREAM strm-aporte TO PRINTER PAGED PAGE-SIZE 66.

    PUT STREAM strm-aporte CONTROL "~033@~0335~033F~033P~033x~001~033E~033C" CHR(66).
    PUT STREAM strm-aporte CONTROL "~033x" NULL "~017~033P".

    DISPLAY i @ FILL-IN-NroCopia WITH FRAME F-Main.

    ASSIGN
        x-NroPag = 1
        x-NroOrd = 0.

    FOR EACH PL-FLG-MES NO-LOCK WHERE
        PL-FLG-MES.CodCia  = s-CodCia AND
        PL-FLG-MES.Periodo = s-Periodo AND
        PL-FLG-MES.NroMes  = FILL-IN-NRO-MES AND
        PL-FLG-MES.CodPln  = PL-PLAN.CodPln BREAK BY PL-FLG-MES.NroMes:
        IF PL-FLG-MES.SitAct = "Inactivo" THEN NEXT.
        DISPLAY PL-FLG-MES.CodPer @ FILL-IN-CodPer WITH FRAME F-Main.
        ASSIGN
            x-ImpTot = 0
            x-NomPer = "".

        FIND PL-PERS WHERE PL-PERS.CodPer = PL-FLG-MES.CodPer NO-LOCK NO-ERROR.
        IF AVAILABLE PL-PERS THEN
            ASSIGN
                x-NomPer = PL-PERS.PatPer + " " + PL-PERS.MatPer + ", " +
                PL-PERS.NomPer.
        DO j = 1 TO 12:
            ASSIGN x-VAL-VAR[j] = 0.
        END.

        RUN PLN/P-CALC-M.R(
            integral.PL-FLG-MES.Codcia,
            integral.PL-FLG-MES.PERIODO,
            integral.PL-FLG-MES.NROMES,
            integral.PL-FLG-MES.codpln,
            1,
            integral.PL-FLG-MES.codper,
            "^202;^422;^423;^420;^412;^004;^413;^424;^425;^426;^500;^704"
            ).

        ASSIGN
            x-NroOrd = x-NroOrd + 1
            x-VAL-VAR[1] = VAL-VAR[1]
            x-VAL-VAR[2] = VAL-VAR[2]
            x-VAL-VAR[3] = VAL-VAR[3]
            x-VAL-VAR[4] = VAL-VAR[4]
            x-VAL-VAR[5] = VAL-VAR[5]
            x-VAL-VAR[6] = VAL-VAR[6]
            x-VAL-VAR[7] = VAL-VAR[7]
            x-VAL-VAR[8] = VAL-VAR[8]
            x-VAL-VAR[9] = VAL-VAR[9]
            x-VAL-VAR[10] = VAL-VAR[10]
            x-VAL-VAR[11] = VAL-VAR[11]
            x-VAL-VAR[12] = VAL-VAR[12].
        ASSIGN
            x-Imptot = X-VAL-VAR[1] + X-VAL-VAR[2] + X-VAL-VAR[3] +
            x-VAL-VAR[4] + x-VAL-VAR[5] + x-VAL-VAR[6] + x-VAL-VAR[7] +
            x-VAL-VAR[8] + x-VAL-VAR[9] + x-VAL-VAR[10].

        DISPLAY STREAM strm-aporte
            x-NroOrd
            PL-FLG-MES.codPer
            x-NomPer
            x-VAL-VAR[1] WHEN x-VAL-VAR[1] <> 0
            x-VAL-VAR[2] WHEN x-VAL-VAR[2] <> 0
            x-VAL-VAR[3] WHEN x-VAL-VAR[3] <> 0
            x-VAL-VAR[4] WHEN x-VAL-VAR[4] <> 0
            x-VAL-VAR[5] WHEN x-VAL-VAR[5] <> 0
            x-VAL-VAR[6] WHEN x-VAL-VAR[6] <> 0
            x-VAL-VAR[7] WHEN x-VAL-VAR[7] <> 0
            x-VAL-VAR[8] WHEN x-VAL-VAR[8] <> 0
            x-VAL-VAR[9] WHEN x-VAL-VAR[9] <> 0
            x-VAL-VAR[10] WHEN x-VAL-VAR[10] <> 0
            x-VAL-VAR[11] WHEN x-VAL-VAR[11] <> 0
            x-VAL-VAR[12] WHEN x-VAL-VAR[12] <> 0
            x-ImpTot WITH FRAME F-aportaciones.

        ACCUMULATE x-VAL-VAR[1] (SUB-TOTAL BY PL-FLG-MES.NroMes).
        ACCUMULATE x-VAL-VAR[2] (SUB-TOTAL BY PL-FLG-MES.NroMes).
        ACCUMULATE x-VAL-VAR[3] (SUB-TOTAL BY PL-FLG-MES.NroMes).
        ACCUMULATE x-VAL-VAR[4] (SUB-TOTAL BY PL-FLG-MES.NroMes).
        ACCUMULATE x-VAL-VAR[5] (SUB-TOTAL BY PL-FLG-MES.NroMes).
        ACCUMULATE x-VAL-VAR[6] (SUB-TOTAL BY PL-FLG-MES.NroMes).
        ACCUMULATE x-VAL-VAR[7] (SUB-TOTAL BY PL-FLG-MES.NroMes).
        ACCUMULATE x-VAL-VAR[8] (SUB-TOTAL BY PL-FLG-MES.NroMes).
        ACCUMULATE x-VAL-VAR[9] (SUB-TOTAL BY PL-FLG-MES.NroMes).
        ACCUMULATE x-VAL-VAR[10] (SUB-TOTAL BY PL-FLG-MES.NroMes).
        ACCUMULATE x-VAL-VAR[11] (SUB-TOTAL BY PL-FLG-MES.NroMes).
        ACCUMULATE x-VAL-VAR[12] (SUB-TOTAL BY PL-FLG-MES.NroMes).
        ACCUMULATE x-Imptot (SUB-TOTAL BY PL-FLG-MES.NroMes).

        IF LINE-COUNTER( strm-aporte ) > 62 THEN DO:
            ASSIGN x-NroPag = x-NroPag + 1.
            PAGE STREAM strm-aporte.
        END.
        IF LAST-OF(PL-FLG-MES.NroMes) THEN DO:
            UNDERLINE STREAM strm-aporte
                x-NroOrd
                X-VAL-VAR[1]
                X-VAL-VAR[2]
                X-VAL-VAR[3]
                x-VAL-VAR[4]
                x-VAL-VAR[5]
                X-VAL-VAR[6]
                X-VAL-VAR[7]
                X-VAL-VAR[8]
                x-VAL-VAR[9]
                x-VAL-VAR[10]
                x-VAL-VAR[11]
                x-VAL-VAR[12]
                x-Imptot
                WITH FRAME F-Aportaciones.
            DISPLAY STREAM strm-aporte
                x-NroOrd
                ACCUM SUB-TOTAL BY (PL-FLG-MES.NroMes) x-VAL-VAR[1] @ x-VAL-VAR[1]
                ACCUM SUB-TOTAL BY (PL-FLG-MES.NroMes) x-VAL-VAR[2] @ x-VAL-VAR[2]
                ACCUM SUB-TOTAL BY (PL-FLG-MES.NroMes) x-VAL-VAR[3] @ x-VAL-VAR[3]
                ACCUM SUB-TOTAL BY (PL-FLG-MES.NroMes) x-VAL-VAR[4] @ x-VAL-VAR[4]
                ACCUM SUB-TOTAL BY (PL-FLG-MES.NroMes) x-VAL-VAR[5] @ x-VAL-VAR[5]
                ACCUM SUB-TOTAL BY (PL-FLG-MES.NroMes) x-VAL-VAR[6] @ x-VAL-VAR[6]
                ACCUM SUB-TOTAL BY (PL-FLG-MES.NroMes) x-VAL-VAR[7] @ x-VAL-VAR[7]
                ACCUM SUB-TOTAL BY (PL-FLG-MES.NroMes) x-VAL-VAR[8] @ x-VAL-VAR[8]
                ACCUM SUB-TOTAL BY (PL-FLG-MES.NroMes) x-VAL-VAR[9] @ x-VAL-VAR[9]
                ACCUM SUB-TOTAL BY (PL-FLG-MES.NroMes) x-VAL-VAR[10] @ x-VAL-VAR[10]
                ACCUM SUB-TOTAL BY (PL-FLG-MES.NroMes) x-VAL-VAR[11] @ x-VAL-VAR[11]
                ACCUM SUB-TOTAL BY (PL-FLG-MES.NroMes) x-VAL-VAR[12] @ x-VAL-VAR[12]
                ACCUM SUB-TOTAL BY (PL-FLG-MES.NroMes) x-ImpTot @ x-ImpTot
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
    FILL-IN-NRO-MES:SENSITIVE = TRUE
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
        FILL-IN-NRO-MES = s-NroMes
        FILL-IN-Copias  = 2
        FILL-IN-CodPer:VISIBLE IN FRAME F-Main = FALSE
        FILL-IN-Msg:VISIBLE = FALSE
        FILL-IN-NroCopia:VISIBLE = FALSE.

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


