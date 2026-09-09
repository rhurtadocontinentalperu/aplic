&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
/*------------------------------------------------------------------------

  File:  

  Description: from BROWSER.W - Basic SmartBrowser Object Template

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

{bin/s-global.i}
{pln/s-global.i}

DEFINE NEW GLOBAL SHARED VARIABLE VAL-VAR AS DECIMAL EXTENT 20 FORMAT "ZZZ,ZZ9.99".

DEFINE VARIABLE CMB-seccion AS CHARACTER NO-UNDO.
DEFINE VARIABLE stat-reg    AS LOGICAL NO-UNDO.
DEFINE VARIABLE i           AS INTEGER NO-UNDO.
DEFINE VARIABLE x-ImpTot    AS DECIMAL NO-UNDO.

DEFINE BUTTON Btn_OK IMAGE-UP FILE "img/print-2" SIZE 5.43 BY 1.46 BGCOLOR 8.

DEFINE VARIABLE FILL-IN-Codigo AS CHARACTER FORMAT "X(6)":U 
    LABEL "Personal" VIEW-AS FILL-IN SIZE 7.57 BY .81 BGCOLOR 15 FGCOLOR 9 NO-UNDO.

DEFINE VARIABLE FILL-IN-seccion AS CHARACTER FORMAT "X(25)":U 
    LABEL "AFP" VIEW-AS FILL-IN SIZE 26.14 BY .81 BGCOLOR 15 FGCOLOR 9 NO-UNDO.

DEFINE RECTANGLE RECT-1
    EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL SIZE 37.29 BY 3.88 BGCOLOR 8 FGCOLOR 0 .

DEFINE FRAME D-Dialog
    FILL-IN-seccion AT ROW 2.88 COL 8.72 COLON-ALIGNED
    FILL-IN-Codigo AT ROW 3.73 COL 8.72 COLON-ALIGNED
    Btn_OK AT ROW 1.27 COL 30.72
    RECT-1 AT ROW 1 COL 1
    "Espere un momento por favor ..." VIEW-AS TEXT
    SIZE 26.57 BY .5 AT ROW 2 COL 2.29
    SPACE(8.42) SKIP(2.37)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
    SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
    FONT 6 TITLE "Imprimiendo..." CENTERED.

DEFINE STREAM strm-concep. /* STREAM para el reporte */

DEFINE TEMP-TABLE tmp-aporte
    FIELD t-codafp AS INTEGER
    FIELD t-codPer AS CHARACTER
    FIELD t-Nroafp AS CHARACTER
    FIELD t-NomPer AS CHARACTER
    FIELD t-afp0   AS DECIMAL
    FIELD t-afp1   AS DECIMAL
    FIELD t-afp2   AS DECIMAL
    FIELD t-afp3   AS DECIMAL
    FIELD t-afp4   AS DECIMAL
    INDEX i-codper IS PRIMARY t-codafp t-CodPer ASCENDING.

DEFINE BUFFER b-PL-SEM FOR PL-SEM.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_pl-flg-s

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES integral.PL-FLG-SEM integral.PL-PERS

/* Definitions for BROWSE br_pl-flg-s                                   */
&Scoped-define FIELDS-IN-QUERY-br_pl-flg-s integral.PL-FLG-SEM.codper ~
integral.PL-PERS.patper integral.PL-PERS.matper integral.PL-PERS.nomper 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_pl-flg-s 
&Scoped-define FIELD-PAIRS-IN-QUERY-br_pl-flg-s
&Scoped-define OPEN-QUERY-br_pl-flg-s OPEN QUERY br_pl-flg-s FOR EACH integral.PL-FLG-SEM ~
      WHERE PL-FLG-SEM.CodCia = s-CodCia ~
 AND PL-FLG-SEM.Periodo = s-Periodo ~
 AND PL-FLG-SEM.codpln = 2 ~
 AND PL-FLG-SEM.NroSem = FILL-IN-NRO-MES ~
 AND PL-FLG-SEM.SitAct <> "Inactivo" NO-LOCK, ~
      EACH integral.PL-PERS OF integral.PL-FLG-SEM NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br_pl-flg-s integral.PL-FLG-SEM ~
integral.PL-PERS
&Scoped-define FIRST-TABLE-IN-QUERY-br_pl-flg-s integral.PL-FLG-SEM


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-br_pl-flg-s}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS R-seleccion B-aceptar FILL-IN-NRO-MES ~
br_pl-flg-s 
&Scoped-Define DISPLAYED-OBJECTS R-seleccion FILL-IN-NRO-MES 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON B-aceptar 
     IMAGE-UP FILE "img/b-ok":U
     LABEL "&Aceptar" 
     SIZE 10.72 BY 1.54.

DEFINE VARIABLE FILL-IN-NRO-MES AS INTEGER FORMAT "Z9":U INITIAL 0 
     LABEL "Mes" 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE R-seleccion AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Todo el personal", 1
     SIZE 14.86 BY .92 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_pl-flg-s FOR 
      integral.PL-FLG-SEM, 
      integral.PL-PERS SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_pl-flg-s
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_pl-flg-s B-table-Win _STRUCTURED
  QUERY br_pl-flg-s NO-LOCK DISPLAY
      integral.PL-FLG-SEM.codper
      integral.PL-PERS.patper
      integral.PL-PERS.matper
      integral.PL-PERS.nomper
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS MULTIPLE SIZE 47 BY 6.96
         BGCOLOR 15 FGCOLOR 0 FONT 6.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     R-seleccion AT ROW 2.08 COL 3.57 NO-LABEL
     B-aceptar AT ROW 4.77 COL 5
     FILL-IN-NRO-MES AT ROW 1.12 COL 8.43 COLON-ALIGNED
     br_pl-flg-s AT ROW 1.12 COL 20.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 66.57 BY 7.19
         BGCOLOR 8 FGCOLOR 0 FONT 4.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
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
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 7.19
         WIDTH              = 66.57.
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   Default                                                              */
ASSIGN 
       br_pl-flg-s:NUM-LOCKED-COLUMNS IN FRAME F-Main = 1.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_pl-flg-s
/* Query rebuild information for BROWSE br_pl-flg-s
     _TblList          = "integral.PL-FLG-SEM,integral.PL-PERS OF integral.PL-FLG-SEM"
     _Options          = "NO-LOCK"
     _Where[1]         = "PL-FLG-SEM.CodCia = s-CodCia
 AND PL-FLG-SEM.Periodo = s-Periodo
 AND PL-FLG-SEM.codpln = 2
 AND PL-FLG-SEM.NroSem = FILL-IN-NRO-MES
 AND PL-FLG-SEM.SitAct <> ""Inactivo"""
     _FldNameList[1]   = integral.PL-FLG-SEM.codper
     _FldNameList[2]   = integral.PL-PERS.patper
     _FldNameList[3]   = integral.PL-PERS.matper
     _FldNameList[4]   = integral.PL-PERS.nomper
     _Query            is OPENED
*/  /* BROWSE br_pl-flg-s */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME B-aceptar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-aceptar B-table-Win
ON CHOOSE OF B-aceptar IN FRAME F-Main /* Aceptar */
DO:
    ASSIGN FILL-IN-NRO-MES R-seleccion. /* COMBO-1.*/
    RUN imp_aportes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br_pl-flg-s
&Scoped-define SELF-NAME br_pl-flg-s
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_pl-flg-s B-table-Win
ON ROW-ENTRY OF br_pl-flg-s IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_pl-flg-s B-table-Win
ON ROW-LEAVE OF br_pl-flg-s IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_pl-flg-s B-table-Win
ON VALUE-CHANGED OF br_pl-flg-s IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NRO-MES
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NRO-MES B-table-Win
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
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME R-seleccion
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL R-seleccion B-table-Win
ON VALUE-CHANGED OF R-seleccion IN FRAME F-Main
DO:
    CASE INPUT R-seleccion:
    WHEN 1 THEN
        ASSIGN
            Br_pl-flg-s:SENSITIVE = FALSE.
            /*COMBO-1:SENSITIVE  = FALSE.*/
    END CASE.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE acumula_aportes B-table-Win 
PROCEDURE acumula_aportes :
DEFINE INPUT PARAMETER x-NroSem  AS INTEGER.
DEFINE INPUT PARAMETER x-CodCal  AS INTEGER.
DEFINE INPUT PARAMETER x-Periodo AS INTEGER.

FOR EACH PL-FLG-SEM WHERE
    PL-FLG-SEM.CodCia  = s-CodCia AND
    PL-FLG-SEM.Periodo = x-Periodo AND
    PL-FLG-SEM.NroSem  = x-NroSem AND
    PL-FLG-SEM.CodPln  = 2:
    FIND PL-AFPS WHERE PL-AFPS.codafp = PL-FLG-SEM.CodAfp NO-LOCK NO-ERROR.
    IF NOT AVAILABLE PL-AFPS THEN NEXT.

    ASSIGN x-ImpTot = 0.

    RUN pln/p-calc-s.r(
        s-codcia,
        x-Periodo,
        x-NroSem,
        PL-FLG-SEM.CodPln,
        x-codcal,
        PL-FLG-SEM.CodPer,
        "^559;^550;^551;^552;^553"
        ).

    ASSIGN x-Imptot = VAL-VAR[2] + VAL-VAR[3] + VAL-VAR[4] + VAL-VAR[5].

    IF x-Imptot <> 0 THEN DO:
        FIND FIRST tmp-aporte WHERE t-CodPer = PL-FLG-SEM.CodPer NO-ERROR.
        IF NOT AVAILABLE tmp-aporte THEN DO:
            CREATE tmp-aporte.
            ASSIGN
                t-codafp = PL-FLG-SEM.CodAfp
                t-codPer = PL-FLG-SEM.CodPer
                t-nroafp = PL-FLG-SEM.nroafp.
            FIND PL-PERS WHERE PL-PERS.CodPer = PL-FLG-SEM.CodPer NO-LOCK NO-ERROR.
            IF AVAILABLE PL-PERS THEN
                ASSIGN t-NomPer = PL-PERS.PatPer + " " + PL-PERS.MatPer + ", " + PL-PERS.NomPer.
        END.
        ASSIGN
            t-afp0     = t-afp0 + VAL-VAR[1]
            t-afp1     = t-afp1 + VAL-VAR[2]
            t-afp2     = t-afp2 + VAL-VAR[3]
            t-afp3     = t-afp3 + VAL-VAR[4]
            t-afp4     = t-afp4 + VAL-VAR[5]
            VAL-VAR[1] = 0
            VAL-VAR[2] = 0
            VAL-VAR[3] = 0
            VAL-VAR[4] = 0
            VAL-VAR[5] = 0.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE acumula_aportes1 B-table-Win 
PROCEDURE acumula_aportes1 :
DEFINE INPUT PARAMETER x-NroMes  AS INTEGER.
DEFINE INPUT PARAMETER x-CodCal  AS INTEGER.
DEFINE INPUT PARAMETER x-Periodo AS INTEGER.

FOR EACH PL-FLG-MES WHERE
    PL-FLG-MES.CodCia  = s-CodCia  AND
    PL-FLG-MES.Periodo = x-Periodo AND
    PL-FLG-MES.NroMes  = x-NroMes  AND
    PL-FLG-MES.CodPln  = 1:
    FIND PL-AFPS WHERE PL-AFPS.codafp = PL-FLG-MES.CodAfp NO-LOCK NO-ERROR.
    IF NOT AVAILABLE PL-AFPS THEN NEXT.

    ASSIGN x-ImpTot = 0.

    RUN pln/p-calc-m.r(
        s-codcia,
        x-Periodo,
        x-NroMes,
        PL-FLG-MES.CodPln,
        x-codcal,
        PL-FLG-MES.CodPer,
        "^559;^550;^551;^552;^553"
        ).

    ASSIGN x-Imptot = VAL-VAR[2] + VAL-VAR[3] + VAL-VAR[4] + VAL-VAR[5].

    IF x-Imptot <> 0 THEN DO:
        FIND FIRST tmp-aporte WHERE t-CodPer = PL-FLG-MES.CodPer NO-ERROR.
        IF NOT AVAILABLE tmp-aporte THEN DO:
            CREATE tmp-aporte.
            ASSIGN
                t-codafp = PL-FLG-MES.CodAfp
                t-codPer = PL-FLG-MES.CodPer.
            FIND PL-PERS WHERE PL-PERS.CodPer = PL-FLG-MES.CodPer NO-LOCK NO-ERROR.
            IF AVAILABLE PL-PERS THEN
                ASSIGN t-NomPer = PL-PERS.PatPer + " " + PL-PERS.MatPer + ", " + PL-PERS.NomPer.
        END.
        ASSIGN
            t-afp0     = t-afp0 + VAL-VAR[1]
            t-afp1     = t-afp1 + VAL-VAR[2]
            t-afp2     = t-afp2 + VAL-VAR[3]
            t-afp3     = t-afp3 + VAL-VAR[4]
            t-afp4     = t-afp4 + VAL-VAR[5]
            VAL-VAR[1] = 0
            VAL-VAR[2] = 0
            VAL-VAR[3] = 0
            VAL-VAR[4] = 0
            VAL-VAR[5] = 0.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imp_aportes B-table-Win 
PROCEDURE imp_aportes :
/*------------------------------------------------------------------------------
    Impresi¢n de conceptos.
------------------------------------------------------------------------------*/

FIND PF-CIAS WHERE PF-CIAS.CodCia = s-CodCia NO-LOCK.

DEFINE VARIABLE x-Titulo  AS CHARACTER FORMAT "x(17)".
DEFINE VARIABLE x-Mes     AS INTEGER.
DEFINE VARIABLE x-Periodo AS INTEGER.
DEFINE VARIABLE x-apvol   AS DECIMAL.
DEFINE VARIABLE x-apemp   AS DECIMAL.
DEFINE VARIABLE x-apcts   AS DECIMAL.
DEFINE VARIABLE x-Sbpen   AS DECIMAL.
DEFINE VARIABLE x-ctips   AS DECIMAL.
DEFINE VARIABLE x-Sbren   AS DECIMAL.

DEFINE FRAME F-aportaciones
    t-NroAfp COLUMN-LABEL   "N£mero AFP" FORMAT "x(10)"
    t-CodPer COLUMN-LABEL   "C¢digo" FORMAT "x(6)"
    t-NomPer COLUMN-LABEL   "Apellidos y nombres" FORMAT "x(50)"
    t-afp0   COLUMN-LABEL   "Monto    !Asegurable " FORMAT "Z,ZZZ,ZZ9.99"
    t-afp1   COLUMN-LABEL   "Aporte   !Obligatorio " FORMAT "Z,ZZZ,ZZ9.99"
    x-apvol  COLUMN-LABEL   "Aporte   ! Voluntario " FORMAT "Z,ZZZ,ZZ9.99"
    x-apemp  COLUMN-LABEL   "Aporte   !  Empleador " FORMAT "Z,ZZZ,ZZ9.99"
    x-apcts  COLUMN-LABEL   "Aporte   !   C.T.S.   " FORMAT "Z,ZZZ,ZZ9.99"
    x-Sbpen  COLUMN-LABEL   "SUB TOTAL!F.PENSIONES " FORMAT "Z,ZZZ,ZZ9.99"
    x-ctips  COLUMN-LABEL   "Contrib. !    IPSS    " FORMAT "Z,ZZZ,ZZ9.99"
    t-afp4   COLUMN-LABEL   "Seguro de  !Invalidez  " FORMAT "Z,ZZZ,ZZ9.99"
    t-afp2   COLUMN-LABEL   "Comisi¢n  !Fija    " FORMAT "Z,ZZZ,ZZ9.99"
    t-afp3   COLUMN-LABEL   "Comisi¢n  !Porcentual " FORMAT "Z,ZZZ,ZZ9.99"
    x-Sbren  COLUMN-LABEL   "SUB TOTAL!RETENCIONES " FORMAT "Z,ZZZ,ZZ9.99"
    x-Imptot COLUMN-LABEL   "Total    " FORMAT "Z,ZZZ,ZZ9.99"
    HEADER
    integral.PF-CIAS.NomCia x-titulo AT 80 "Fecha :" TO 140 TODAY TO 150 SKIP
    integral.PF-CIAS.DirCia "Aportaciones de EMPLEADOS Y OBREROS a AFPS" AT 70 SKIP(1)
    integral.PL-AFPS.codafp integral.PL-AFPS.desafp SKIP(2)
    WITH DOWN NO-BOX STREAM-IO WIDTH 255.

RUN bin/_mes.r( FILL-IN-NRO-MES, 1 , OUTPUT x-titulo ).

ASSIGN x-Titulo = x-Titulo + " - " + STRING(s-Periodo, "9,999").

IF FILL-IN-NRO-MES = 1 THEN
    ASSIGN
        x-Mes     = 12
        x-Periodo = s-Periodo - 1.
ELSE
    ASSIGN
        x-Mes     = FILL-IN-NRO-MES - 1
        x-Periodo = s-Periodo.

IF R-seleccion = 1 THEN DO:
    /* Para obreros */
    FOR EACH PL-SEM WHERE
        PL-SEM.Periodo = s-Periodo AND
        PL-SEM.NroMes  = FILL-IN-NRO-MES NO-LOCK:
        RUN acumula_aportes( PL-SEM.NroSem, 1, PL-SEM.Periodo ). /* Semanal */
        RUN acumula_aportes( PL-SEM.NroSem, 4, PL-SEM.Periodo ). /* Gratificaciones */
    END.
    FOR EACH PL-SEM WHERE
        PL-SEM.Periodo = x-Periodo AND
        PL-SEM.NroMes  = x-Mes NO-LOCK:
        RUN acumula_aportes( PL-SEM.NroSem, 3, PL-SEM.Periodo ). /* VACACIONES */
    END.
    /* Para empleados */
    RUN acumula_aportes1( FILL-IN-NRO-MES, 1, s-Periodo ). /* Mes */
    RUN acumula_aportes1( x-Mes, 3, x-Periodo ).           /* Vacaciones */
    RUN acumula_aportes1( FILL-IN-NRO-MES, 4, s-Periodo ). /* Gratificaciones */

    OUTPUT STREAM strm-concep TO PRINTER PAGED PAGE-SIZE 66.

    PUT STREAM strm-concep CONTROL "~033@~0335~033F~033P~033x~001~033E~033C" CHR(66).
    PUT STREAM strm-concep CONTROL "~033x" NULL "~017~033M".

    FOR EACH tmp-aporte NO-LOCK
        BREAK BY t-CodAfp
        BY t-CodPer:
        IF FIRST-OF(t-CodAfp) THEN DO:
            FIND PL-AFPS WHERE PL-AFPS.codafp = t-CodAfp NO-LOCK NO-ERROR.
            IF AVAILABLE PL-AFPS THEN
                DISPLAY PL-AFPS.desafp @ FILL-IN-seccion WITH FRAME D-Dialog.
        END.

        DISPLAY t-CodPer @ FILL-IN-Codigo WITH FRAME D-Dialog.

        ASSIGN x-Imptot= t-afp1 + t-afp2 + t-afp3 + t-afp4 + x-apvol + x-apemp + x-apcts.
        ASSIGN x-Sbpen = t-afp1 + x-apvol + x-apemp + x-apcts.
        ASSIGN x-Sbren = t-afp2 + t-afp3 + t-afp4.
        
        DISPLAY STREAM strm-concep
            t-Nroafp
            t-CodPer
            t-NomPer
            t-afp0
            t-afp1
            x-apvol
            x-apemp
            x-apcts
            x-Sbpen
            x-ctips
            t-afp2
            t-afp3
            t-afp4
            x-Sbren
            x-ImpTot
            WITH FRAME F-aportaciones.

        ACCUMULATE t-afp0  (SUB-TOTAL BY t-codafp).
        ACCUMULATE t-afp1  (SUB-TOTAL BY t-codafp).
        ACCUMULATE x-apvol (SUB-TOTAL BY t-codafp).
        ACCUMULATE x-apemp (SUB-TOTAL BY t-codafp).
        ACCUMULATE x-apcts (SUB-TOTAL BY t-codafp).
        ACCUMULATE x-Sbpen (SUB-TOTAL BY t-codafp).
        ACCUMULATE x-ctips (SUB-TOTAL BY t-codafp).
        ACCUMULATE t-afp2 (SUB-TOTAL BY t-codafp).
        ACCUMULATE t-afp3 (SUB-TOTAL BY t-codafp).
        ACCUMULATE t-afp4 (SUB-TOTAL BY t-codafp).
        ACCUMULATE x-Sbren (SUB-TOTAL BY t-codafp).
        ACCUMULATE x-Imptot (SUB-TOTAL BY t-codafp).

        IF LAST-OF(t-CodAfp) THEN DO:
            UNDERLINE STREAM strm-concep
                t-afp0
                t-afp1
                x-apvol
                x-apemp
                x-apcts
                x-Sbpen
                x-ctips
                t-afp2
                t-afp3
                t-afp4
                x-Sbren
                x-ImpTot
                WITH FRAME F-aportaciones.
            DISPLAY STREAM strm-concep
                "TOTALES : " @ t-NomPer
                ACCUM SUB-TOTAL BY (t-codafp) t-afp0 @ t-afp0
                ACCUM SUB-TOTAL BY (t-codafp) t-afp1 @ t-afp1
                ACCUM SUB-TOTAL BY (t-codafp) x-apvol @ x-apvol
                ACCUM SUB-TOTAL BY (t-codafp) x-apemp @ x-apemp
                ACCUM SUB-TOTAL BY (t-codafp) x-apcts @ x-apcts
                ACCUM SUB-TOTAL BY (t-codafp) x-Sbpen @ x-Sbpen
                ACCUM SUB-TOTAL BY (t-codafp) x-ctips @ x-ctips
                ACCUM SUB-TOTAL BY (t-codafp) t-afp2 @ t-afp2
                ACCUM SUB-TOTAL BY (t-codafp) t-afp3 @ t-afp3
                ACCUM SUB-TOTAL BY (t-codafp) t-afp4 @ t-afp4
                ACCUM SUB-TOTAL BY (t-codafp) x-Sbren @ x-Sbren
                ACCUM SUB-TOTAL BY (t-codafp) x-ImpTot @ x-ImpTot
                WITH FRAME F-aportaciones.
            PAGE STREAM strm-concep.
        END.
    END.
    
    HIDE FRAME D-Dialog.

    OUTPUT STREAM strm-concep CLOSE.

    FOR EACH tmp-aporte:
        DELETE tmp-aporte.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
    ASSIGN FILL-IN-NRO-MES = s-NroMes.
    DISPLAY FILL-IN-NRO-MES WITH FRAME F-Main.

    APPLY "VALUE-CHANGED" TO R-seleccion IN FRAME F-Main.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "integral.PL-FLG-SEM"}
  {src/adm/template/snd-list.i "integral.PL-PERS"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win 
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
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


