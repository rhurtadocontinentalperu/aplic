&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
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

{bin/s-global.i}
{pln/s-global.i}

DEFINE NEW GLOBAL SHARED VARIABLE VAL-VAR AS DECIMAL EXTENT 20 FORMAT "ZZZ,ZZ9.99".

DEFINE VARIABLE i        AS INTEGER NO-UNDO.
DEFINE VARIABLE x-ImpTot AS DECIMAL NO-UNDO.

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 Btn-UP FILL-IN-NRO-MES ~
Btn-DOWN Btn-UP-2 FILL-IN-Copias Btn-DOWN-2 B-aceptar B-cancelar 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-NRO-MES FILL-IN-Copias ~
FILL-IN-CodPer 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-aceptar 
     IMAGE-UP FILE "img/b-ok":U
     LABEL "&Aceptar" 
     SIZE 10.72 BY 1.54.

DEFINE BUTTON B-cancelar 
     IMAGE-UP FILE "img/b-cancel":U
     LABEL "Cancelar" 
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

DEFINE VARIABLE FILL-IN-Copias AS INTEGER FORMAT "ZZ9":U INITIAL 0 
     LABEL "Copias" 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NRO-MES AS INTEGER FORMAT "Z9":U INITIAL 0 
     LABEL "Mes" 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 65.72 BY 2.31.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 65.72 BY 1.38.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Btn-UP AT ROW 1.5 COL 20.72
     FILL-IN-NRO-MES AT ROW 1.81 COL 14.72 COLON-ALIGNED
     Btn-DOWN AT ROW 2.12 COL 20.72
     Btn-UP-2 AT ROW 1.46 COL 35.57
     FILL-IN-Copias AT ROW 1.81 COL 29.86 COLON-ALIGNED
     Btn-DOWN-2 AT ROW 2.08 COL 35.57
     B-aceptar AT ROW 1.5 COL 43
     B-cancelar AT ROW 1.5 COL 54.86
     FILL-IN-CodPer AT ROW 3.88 COL 56.14 COLON-ALIGNED
     RECT-1 AT ROW 1.12 COL 1.43
     RECT-2 AT ROW 3.58 COL 1.43
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 66.57 BY 4.04
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
         TITLE              = "Aportaciones a AFPs"
         HEIGHT             = 4.15
         WIDTH              = 66.72
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
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   Default                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-CodPer IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Aportaciones a AFPs */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Aportaciones a AFPs */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-aceptar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-aceptar W-Win
ON CHOOSE OF B-aceptar IN FRAME F-Main /* Aceptar */
DO:
    ASSIGN
        FILL-IN-NRO-MES
        FILL-IN-Copias.
    RUN imprime_aportes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-cancelar W-Win
ON CHOOSE OF B-cancelar IN FRAME F-Main /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-DOWN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-DOWN W-Win
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-DOWN-2 W-Win
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-UP W-Win
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-UP-2 W-Win
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NRO-MES W-Win
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE acumula_empleados W-Win 
PROCEDURE acumula_empleados :
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

    DISPLAY PL-FLG-MES.CodPer @ FILL-IN-CodPer WITH FRAME F-Main.
    
    ASSIGN x-ImpTot = 0.

    RUN pln/p-calc-m.r(
        s-codcia,
        x-Periodo,
        x-NroMes,
        PL-FLG-MES.CodPln,
        x-codcal,
        PL-FLG-MES.CodPer,
        "^500;^503;^505;^506;^504"
        ).

    ASSIGN x-Imptot = VAL-VAR[2] + VAL-VAR[3] + VAL-VAR[4] + VAL-VAR[5].

    IF x-Imptot <> 0 THEN DO:
        FIND FIRST tmp-aporte WHERE t-CodPer = PL-FLG-MES.CodPer NO-ERROR.
        IF NOT AVAILABLE tmp-aporte THEN DO:
            CREATE tmp-aporte.
            ASSIGN
                t-codafp = PL-FLG-MES.CodAfp
                t-codPer = PL-FLG-MES.CodPer
                t-nroafp = PL-FLG-MES.nroafp.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE acumula_obreros W-Win 
PROCEDURE acumula_obreros :
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

    DISPLAY PL-FLG-SEM.CodPer @ FILL-IN-CodPer WITH FRAME F-Main.

    ASSIGN x-ImpTot = 0.

    RUN pln/p-calc-s.r(
        s-codcia,
        x-Periodo,
        x-NroSem,
        PL-FLG-SEM.CodPln,
        x-codcal,
        PL-FLG-SEM.CodPer,
        "^500;^503;^505;^506;^504"
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
            t-nroafp   = PL-FLG-SEM.nroafp
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
  DISPLAY FILL-IN-NRO-MES FILL-IN-Copias FILL-IN-CodPer 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 RECT-2 Btn-UP FILL-IN-NRO-MES Btn-DOWN Btn-UP-2 FILL-IN-Copias 
         Btn-DOWN-2 B-aceptar B-cancelar 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprime_aportes W-Win 
PROCEDURE imprime_aportes :
/*------------------------------------------------------------------------------
    Impresi¢n de aportes.
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
    t-NroAfp COLUMN-LABEL   "N£mero AFP" FORMAT "x(12)"
    t-CodPer COLUMN-LABEL   "C¢digo" FORMAT "x(6)"
    t-NomPer COLUMN-LABEL   "Apellidos y nombres" FORMAT "x(50)"
    t-afp0   COLUMN-LABEL   "Monto    !Asegurable " FORMAT "Z,ZZZ,ZZ9.99"
    t-afp1   COLUMN-LABEL   "Aporte   !Obligatorio " FORMAT "Z,ZZZ,ZZ9.99"
    x-apvol  COLUMN-LABEL   "Aporte   ! Voluntario " FORMAT "Z,ZZZ,ZZ9.99"
    x-apemp  COLUMN-LABEL   "Aporte   !  Empleador " FORMAT "Z,ZZZ,ZZ9.99"
    x-apcts  COLUMN-LABEL   "Aporte   !   C.T.S.   " FORMAT "Z,ZZZ,ZZ9.99"
    x-Sbpen  COLUMN-LABEL   "SUB TOTAL  !F.PENSIONES " FORMAT "Z,ZZZ,ZZ9.99"
    x-ctips  COLUMN-LABEL   "Contrib. !    IPSS    " FORMAT "Z,ZZZ,ZZ9.99"
    t-afp4   COLUMN-LABEL   "Seguro de  !Invalidez  " FORMAT "Z,ZZZ,ZZ9.99"
    t-afp2   COLUMN-LABEL   "Comisi¢n  !Fija    " FORMAT "Z,ZZZ,ZZ9.99"
    t-afp3   COLUMN-LABEL   "Comisi¢n  !Porcentual " FORMAT "Z,ZZZ,ZZ9.99"
    x-Sbren  COLUMN-LABEL   "SUB TOTAL  !RETENCIONES " FORMAT "Z,ZZZ,ZZ9.99"
    x-Imptot COLUMN-LABEL   "Total    " FORMAT "Z,ZZZ,ZZ9.99"
    HEADER
    integral.PF-CIAS.NomCia x-titulo AT 106 "Fecha :" TO 215 TODAY TO 225 SKIP
    integral.PF-CIAS.DirCia "Aportaciones de EMPLEADOS Y OBREROS a AFPS" AT 94 SKIP(1)
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

/* Para obreros */
FOR EACH PL-SEM WHERE
    PL-SEM.Periodo = s-Periodo AND
    PL-SEM.NroMes  = FILL-IN-NRO-MES NO-LOCK:
    RUN acumula_obreros( PL-SEM.NroSem, 4, PL-SEM.Periodo ). /* Gratificaciones */
    RUN acumula_obreros( PL-SEM.NroSem, 1, PL-SEM.Periodo ). /* Semanal */
END.
FOR EACH PL-SEM WHERE
    PL-SEM.Periodo = x-Periodo AND
    PL-SEM.NroMes  = x-Mes NO-LOCK:
    RUN acumula_obreros( PL-SEM.NroSem, 3, PL-SEM.Periodo ). /* VACACIONES */
END.
/* Para empleados */
RUN acumula_empleados( FILL-IN-NRO-MES, 1, s-Periodo ). /* Mes */
RUN acumula_empleados( x-Mes, 3, x-Periodo ).           /* Vacaciones */
RUN acumula_empleados( FILL-IN-NRO-MES, 4, s-Periodo ). /* Gratificaciones */

DO i = 1 TO FILL-IN-Copias:

    OUTPUT STREAM strm-concep TO PRINTER PAGED PAGE-SIZE 66.

    PUT STREAM strm-concep CONTROL "~033@~0335~033F~033P~033x~001~033E~033C" CHR(66).
    PUT STREAM strm-concep CONTROL "~033x" NULL "~017~033M".

    FOR EACH tmp-aporte NO-LOCK
        BREAK BY t-CodAfp
        BY t-CodPer:
        IF FIRST-OF(t-CodAfp) THEN
            FIND PL-AFPS WHERE PL-AFPS.codafp = t-CodAfp NO-LOCK NO-ERROR.

        ASSIGN x-Imptot= t-afp1 + t-afp2 + t-afp3 + t-afp4 + x-apvol + x-apemp + x-apcts.
        ASSIGN x-Sbpen = t-afp1 + x-apvol + x-apemp + x-apcts.
        ASSIGN x-Sbren = t-afp2 + t-afp3 + t-afp4.
        
        DISPLAY STREAM strm-concep
            t-Nroafp
            t-CodPer
            t-NomPer
            t-afp0  WHEN (t-afp0 <> 0)
            t-afp1  WHEN (t-afp1 <> 0)
            x-apvol WHEN (x-apvol <> 0)
            x-apemp WHEN (x-apemp <> 0)
            x-apcts WHEN (x-apcts <> 0)
            x-Sbpen WHEN (x-Sbpen <> 0)
            x-ctips WHEN (x-ctips <> 0)
            t-afp2  WHEN (t-afp2 <> 0)
            t-afp3  WHEN (t-afp3 <> 0)
            t-afp4  WHEN (t-afp4 <> 0)
            x-Sbren WHEN (x-Sbren <> 0)
            x-ImpTot WHEN (x-Imptot <> 0)
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
    
    OUTPUT STREAM strm-concep CLOSE.

END.

FOR EACH tmp-aporte:
    DELETE tmp-aporte.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

    DISPLAY
        s-NroMes @ FILL-IN-NRO-MES
        2        @ FILL-IN-Copias WITH FRAME F-Main.

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


