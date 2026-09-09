&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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

DEFINE VARIABLE CMB-lista AS CHARACTER NO-UNDO.
DEFINE VARIABLE i         AS INTEGER NO-UNDO.

DEFINE BUTTON Btn_OK IMAGE-UP FILE "img/plemrcal"
    LABEL "OK" SIZE 6.43 BY 1.58 BGCOLOR 8 .

DEFINE VARIABLE FILL-IN-Codigo AS CHARACTER FORMAT "X(256)":U 
    LABEL "Personal" VIEW-AS FILL-IN SIZE 6.72 BY .81 BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-Seccion AS CHARACTER FORMAT "X(256)":U 
    LABEL "Proyecto" VIEW-AS FILL-IN SIZE 28 BY .81 BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE RECTANGLE RECT-20 EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL SIZE 37.14 BY 3.08.

DEFINE FRAME F-msg
    FILL-IN-Codigo AT ROW 2.08 COL 6.72 COLON-ALIGNED
    FILL-IN-Seccion AT ROW 2.96 COL 6.72 COLON-ALIGNED
    Btn_OK AT ROW 1.23 COL 30.29
    RECT-20 AT ROW 1 COL 1
    "Espere un momento por favor ..." VIEW-AS TEXT
    SIZE 22.57 BY .62 AT ROW 1.31 COL 4.43
    SPACE(11.13) SKIP(2.14)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
    SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
    FONT 4 TITLE "Procesando..." CENTERED.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_pl-flg-m

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES integral.PL-PLAN
&Scoped-define FIRST-EXTERNAL-TABLE integral.PL-PLAN


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR integral.PL-PLAN.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES integral.PL-FLG-MES INTEGRAL.pl-pers

/* Definitions for BROWSE br_pl-flg-m                                   */
&Scoped-define FIELDS-IN-QUERY-br_pl-flg-m integral.PL-FLG-MES.codper ~
INTEGRAL.pl-pers.patper INTEGRAL.pl-pers.matper INTEGRAL.pl-pers.nomper 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_pl-flg-m 
&Scoped-define QUERY-STRING-br_pl-flg-m FOR EACH integral.PL-FLG-MES ~
      WHERE PL-FLG-MES.CodCia = s-CodCia ~
 AND PL-FLG-MES.Periodo = s-Periodo ~
 AND PL-FLG-MES.codpln = PL-PLAN.CodPln ~
 AND PL-FLG-MES.NroMes = s-NroMes ~
 AND PL-FLG-MES.SitAct <> "Inactivo" NO-LOCK, ~
      EACH INTEGRAL.pl-pers OF integral.PL-FLG-MES NO-LOCK ~
    BY integral.PL-FLG-MES.Proyecto ~
       BY integral.PL-FLG-MES.seccion ~
        BY INTEGRAL.pl-pers.patper ~
         BY INTEGRAL.pl-pers.matper ~
          BY INTEGRAL.pl-pers.nomper
&Scoped-define OPEN-QUERY-br_pl-flg-m OPEN QUERY br_pl-flg-m FOR EACH integral.PL-FLG-MES ~
      WHERE PL-FLG-MES.CodCia = s-CodCia ~
 AND PL-FLG-MES.Periodo = s-Periodo ~
 AND PL-FLG-MES.codpln = PL-PLAN.CodPln ~
 AND PL-FLG-MES.NroMes = s-NroMes ~
 AND PL-FLG-MES.SitAct <> "Inactivo" NO-LOCK, ~
      EACH INTEGRAL.pl-pers OF integral.PL-FLG-MES NO-LOCK ~
    BY integral.PL-FLG-MES.Proyecto ~
       BY integral.PL-FLG-MES.seccion ~
        BY INTEGRAL.pl-pers.patper ~
         BY INTEGRAL.pl-pers.matper ~
          BY INTEGRAL.pl-pers.nomper.
&Scoped-define TABLES-IN-QUERY-br_pl-flg-m integral.PL-FLG-MES ~
INTEGRAL.pl-pers
&Scoped-define FIRST-TABLE-IN-QUERY-br_pl-flg-m integral.PL-FLG-MES
&Scoped-define SECOND-TABLE-IN-QUERY-br_pl-flg-m INTEGRAL.pl-pers


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-br_pl-flg-m}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-22 COMBO-BOX-1 COMBO-BOX-2 ~
FILL-IN-NOMBRE R-seleccion br_pl-flg-m COMBO-S B-aceptar 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-1 COMBO-BOX-2 FILL-IN-NOMBRE ~
R-seleccion COMBO-S 

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

DEFINE VARIABLE COMBO-BOX-1 AS CHARACTER FORMAT "X(256)":U INITIAL "C¢digos" 
     LABEL "Mostrar ordenado por" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "Códigos","Nombres" 
     DROP-DOWN-LIST
     SIZE 10.57 BY 1
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE COMBO-BOX-2 AS CHARACTER FORMAT "X(256)":U INITIAL "Nombres que inicie con" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "Nombres que inicie con","Nombres que contenga" 
     DROP-DOWN-LIST
     SIZE 20.43 BY 1
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE COMBO-S AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 20.43 BY 1
     BGCOLOR 15 FGCOLOR 0 FONT 4 NO-UNDO.

DEFINE VARIABLE FILL-IN-NOMBRE AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39.29 BY .81
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE R-seleccion AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Todo el personal", 1,
"Selectivo", 2,
"Por sección", 3,
"Por proyecto", 4
     SIZE 14.14 BY 2.31 NO-UNDO.

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 69.86 BY 9.23.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_pl-flg-m FOR 
      integral.PL-FLG-MES, 
      INTEGRAL.pl-pers SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_pl-flg-m
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_pl-flg-m B-table-Win _STRUCTURED
  QUERY br_pl-flg-m NO-LOCK DISPLAY
      integral.PL-FLG-MES.codper FORMAT "X(6)":U
      INTEGRAL.pl-pers.patper FORMAT "X(40)":U
      INTEGRAL.pl-pers.matper FORMAT "X(40)":U
      INTEGRAL.pl-pers.nomper FORMAT "X(40)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS MULTIPLE SIZE 47 BY 6.73
         BGCOLOR 15 FGCOLOR 0 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-1 AT ROW 1.19 COL 7.57
     COMBO-BOX-2 AT ROW 2.12 COL 2 NO-LABEL
     FILL-IN-NOMBRE AT ROW 2.15 COL 22.86 NO-LABEL
     R-seleccion AT ROW 3.12 COL 5.86 NO-LABEL
     br_pl-flg-m AT ROW 3.23 COL 23.14
     COMBO-S AT ROW 5.58 COL 2 NO-LABEL
     B-aceptar AT ROW 6.58 COL 7
     RECT-22 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 69.86 BY 9.23
         BGCOLOR 8 FGCOLOR 0 FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: integral.PL-PLAN
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 9.23
         WIDTH              = 69.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
                                                                        */
/* BROWSE-TAB br_pl-flg-m R-seleccion F-Main */
ASSIGN 
       br_pl-flg-m:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 1.

/* SETTINGS FOR COMBO-BOX COMBO-BOX-1 IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-2 IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR COMBO-BOX COMBO-S IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-NOMBRE IN FRAME F-Main
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_pl-flg-m
/* Query rebuild information for BROWSE br_pl-flg-m
     _TblList          = "integral.PL-FLG-MES OF integral.PL-PLAN,INTEGRAL.pl-pers OF integral.PL-FLG-MES"
     _Options          = "NO-LOCK"
     _OrdList          = "integral.PL-FLG-MES.Proyecto|yes,integral.PL-FLG-MES.seccion|yes,INTEGRAL.pl-pers.patper|yes,INTEGRAL.pl-pers.matper|yes,INTEGRAL.pl-pers.nomper|yes"
     _Where[1]         = "PL-FLG-MES.CodCia = s-CodCia
 AND PL-FLG-MES.Periodo = s-Periodo
 AND PL-FLG-MES.codpln = PL-PLAN.CodPln
 AND PL-FLG-MES.NroMes = s-NroMes
 AND PL-FLG-MES.SitAct <> ""Inactivo"""
     _FldNameList[1]   = integral.PL-FLG-MES.codper
     _FldNameList[2]   = INTEGRAL.pl-pers.patper
     _FldNameList[3]   = INTEGRAL.pl-pers.matper
     _FldNameList[4]   = INTEGRAL.pl-pers.nomper
     _Query            is OPENED
*/  /* BROWSE br_pl-flg-m */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME B-aceptar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-aceptar B-table-Win
ON CHOOSE OF B-aceptar IN FRAME F-Main /* Aceptar */
DO:

    ASSIGN R-seleccion COMBO-S.

    MESSAGE
        "¿Está seguro de proceder con el CALCULO?"
        VIEW-AS ALERT-BOX QUESTION BUTTONS
        YES-NO UPDATE rpta AS LOGICAL.
    IF rpta <> TRUE THEN RETURN NO-APPLY.

    RUN proc_calculo.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br_pl-flg-m
&Scoped-define SELF-NAME br_pl-flg-m
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_pl-flg-m B-table-Win
ON ROW-ENTRY OF br_pl-flg-m IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_pl-flg-m B-table-Win
ON ROW-LEAVE OF br_pl-flg-m IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_pl-flg-m B-table-Win
ON VALUE-CHANGED OF br_pl-flg-m IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-1 B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-1 IN FRAME F-Main /* Mostrar ordenado por */
DO:
    IF INPUT COMBO-BOX-1 <> COMBO-BOX-1
    THEN RUN OPEN-QUERY.
    ASSIGN COMBO-BOX-1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-2 B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-2 IN FRAME F-Main
DO:
    IF INPUT COMBO-BOX-2 <> COMBO-BOX-2
    THEN IF FILL-IN-NOMBRE:SCREEN-VALUE <> "" THEN RUN OPEN-QUERY.
    ASSIGN COMBO-BOX-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-S
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-S B-table-Win
ON ENTRY OF COMBO-S IN FRAME F-Main
DO:
    ASSIGN CMB-Lista = "".
    CASE INPUT R-seleccion:
    WHEN 3 THEN DO:
        FOR EACH integral.PL-SECC NO-LOCK:
            ASSIGN CMB-Lista = CMB-Lista + "," + integral.PL-SECC.seccion.
        END.
    END.
    WHEN 4 THEN DO:
        FOR EACH integral.PL-PROY NO-LOCK:
            ASSIGN CMB-Lista = CMB-Lista + "," + integral.PL-PROY.proyecto.
        END.
    END.
    END CASE.
    COMBO-S:LIST-ITEMS IN FRAME F-Main = CMB-Lista.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NOMBRE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NOMBRE B-table-Win
ON LEAVE OF FILL-IN-NOMBRE IN FRAME F-Main
DO:
    IF INPUT FILL-IN-NOMBRE <> FILL-IN-NOMBRE
    THEN RUN OPEN-QUERY.
    ASSIGN FILL-IN-NOMBRE.
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
            Br_pl-flg-m:SENSITIVE = FALSE
            COMBO-S:SENSITIVE     = FALSE.
    WHEN 2 THEN
        ASSIGN
            Br_pl-flg-m:SENSITIVE = TRUE
            COMBO-S:SENSITIVE     = FALSE.
    WHEN 3 OR WHEN 4 THEN DO:
        ASSIGN
            COMBO-S:LIST-ITEMS    = ""
            Br_pl-flg-m:SENSITIVE = FALSE
            COMBO-S:SENSITIVE     = TRUE.
        DISPLAY COMBO-S WITH FRAME F-Main.
    END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ADD-MENSUAL W-Win 
PROCEDURE ADD-MENSUAL :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i AS INTEGER NO-UNDO.

    CASE R-seleccion:
    WHEN 1 THEN
        FOR EACH integral.PL-FLG-MES WHERE
            integral.PL-FLG-MES.codcia  = S-codcia AND
            integral.PL-FLG-MES.periodo = S-periodo AND
            integral.PL-FLG-MES.codpln  = L-codpln-m AND
            integral.PL-FLG-MES.nromes  = L-nromes:
            RUN pl-mensual.
        END.
    WHEN 2 THEN
        DO i = 1 TO br_pl-flg-m:NUM-SELECTED-ROWS IN FRAME F-Main:
            ASSIGN ok-status  = br_pl-flg-m:FETCH-SELECTED-ROW(i).
            IF ok-status THEN RUN pl-mensual.
        END.
    WHEN 3  THEN
        FOR EACH integral.PL-FLG-MES WHERE
            integral.PL-FLG-MES.codcia  = S-codcia AND
            integral.PL-FLG-MES.periodo = S-periodo AND
            integral.PL-FLG-MES.codpln  = L-codpln-m AND
            integral.PL-FLG-MES.nromes  = L-nromes AND
            integral.PL-FLG-MES.Seccion = Combo-s:
            RUN pl-mensual.
        END.
    WHEN 4 THEN
        FOR EACH integral.PL-FLG-MES WHERE
            integral.PL-FLG-MES.codcia   = S-codcia AND
            integral.PL-FLG-MES.periodo  = s-periodo AND
            integral.PL-FLG-MES.codpln   = L-codpln-m AND
            integral.PL-FLG-MES.nromes   = L-nromes AND
            integral.PL-FLG-MES.proyecto = Combo-s:
            RUN pl-mensual.
        END.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ADD-PFCIAS W-Win 
PROCEDURE ADD-PFCIAS :
/*
    Compa¤¡a
*/

    FIND integral.PF-CIAS WHERE integral.PF-CIAS.CodCia = S-CodCia NO-LOCK.
    CREATE DB-WORK.PF-CIAS.
    ASSIGN 
        db-work.PF-CIAS.CodCia  = integral.PF-CIAS.CodCia
        db-work.PF-CIAS.DirCia  = integral.PF-CIAS.DirCia
        db-work.PF-CIAS.NomCia  = integral.PF-CIAS.NomCia
        db-work.PF-CIAS.RegPat  = integral.PF-CIAS.RegPat
        db-work.PF-CIAS.RucCia  = integral.PF-CIAS.Ruccia
        db-work.PF-CIAS.TlflCia = integral.PF-CIAS.TlflCia.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ADD-PL-AFP W-Win 
PROCEDURE ADD-PL-AFP :
/*
    AFP
*/

    FOR EACH integral.PL-AFPS NO-LOCK:
        CREATE DB-WORK.PL-AFPS.
        DB-WORK.PL-AFPS.codafp                  = integral.PL-AFPS.codafp.
        DB-WORK.PL-AFPS.Comision-Fija-AFP       = integral.PL-AFPS.Comision-Fija-AFP.
        DB-WORK.PL-AFPS.Comision-Porcentual-AFP = integral.PL-AFPS.Comision-Porcentual-AFP.
        DB-WORK.PL-AFPS.desafp                  = integral.PL-AFPS.desafp.
        DB-WORK.PL-AFPS.Fondo-AFP               = integral.PL-AFPS.Fondo-AFP.
        DB-WORK.PL-AFPS.Seguro-Invalidez-AFP    = integral.PL-AFPS.Seguro-Invalidez-AFP.
        DB-WORK.PL-AFPS.banco                   = integral.PL-AFPS.banco.
        DB-WORK.PL-AFPS.ctacte-afp              = integral.PL-AFPS.nroctacte-afp.
        DB-WORK.PL-AFPS.ctacte-fondo            = integral.PL-AFPS.nroctacte-fondo.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ADD-PL-CFG W-Win 
PROCEDURE ADD-PL-CFG :
/*
    Configuración
*/

    DEFINE VARIABLE L-DesPln AS CHARACTER.

    CASE p-tipo:
    WHEN 1 THEN DO:
         L-desPln = PL-PLAN.DesPln.
         FIND PL-SEM WHERE
            PL-SEM.CODCIA = S-CODCIA AND
            PL-SEM.PERIODO = S-PERIODO NO-LOCK NO-ERROR.
    END.
    WHEN 2 THEN DO:
        L-desPln = PL-PLAN.DesPln.
    END.
    WHEN 3 THEN DO:
        L-CodPln = 0.
        L-DesPln = "".
    END.
    END CASE.   
    CREATE DB-WORK.PL-CFG.
    ASSIGN
        DB-WORK.PL-CFG.CodCia   = S-CodCia
        DB-WORK.PL-CFG.Periodo  = S-Periodo
        DB-WORK.PL-CFG.CodPln   = L-CodPln
        DB-WORK.PL-CFG.DesPln   = L-DesPln
        DB-WORK.PL-CFG.NROREG-TOT = s-nroreg-tot
        DB-WORK.PL-CFG.NROREG-ACT = s-nroreg-act.

    CASE p-tipo:
    WHEN 1 THEN DO:
        FIND PL-SEM WHERE
            PL-SEM.CODCIA  = S-CODCIA AND
            PL-SEM.PERIODO = S-PERIODO AND
            PL-SEM.NROSEM  = L-NROSEM NO-LOCK NO-ERROR.
        IF AVAILABLE PL-SEM THEN DO:
            DB-WORK.PL-CFG.NroMes      = PL-SEM.NroMes.
            DB-WORK.PL-CFG.NroSem      = PL-SEM.NroSem.
            DB-WORK.PL-CFG.Fecha-Desde = PL-SEM.FecIni.
            DB-WORK.PL-CFG.Fecha-Hasta = PL-SEM.FecFin.
        END.                
        /* PRIMERA SEMANA DEL MES */
        FIND FIRST integral.PL-SEM WHERE
            integral.PL-SEM.CodCia  = s-CodCia AND
            integral.PL-SEM.Periodo = s-Periodo AND
            integral.PL-SEM.NroMes  = DB-WORK.PL-CFG.NroMes NO-LOCK NO-ERROR.
        ASSIGN
            DB-WORK.PL-CFG.Fecha-Desde-1 = PL-SEM.FecIni
            DB-WORK.PL-CFG.NroSem-1      = PL-SEM.NroSem.
        /* ULTIMA SEMANA DEL MES */
        FIND LAST integral.PL-SEM WHERE
            integral.PL-SEM.CodCia  = s-CodCia AND
            integral.PL-SEM.Periodo = s-Periodo AND
            integral.PL-SEM.NroMes  = DB-WORK.PL-CFG.NroMes NO-LOCK NO-ERROR.
        ASSIGN
            DB-WORK.PL-CFG.Fecha-Hasta-1 = PL-SEM.FecFin
            DB-WORK.PL-CFG.NroSem-2      = PL-SEM.NroSem.
    END.
    WHEN 2 THEN DO:
        ASSIGN
            DB-WORK.PL-CFG.NroSem      = 0     
            DB-WORK.PL-CFG.NroMes      = L-NROMES 
            DB-WORK.PL-CFG.Fecha-Desde = DATE(L-NROMES, 1, S-PERIODO).
            IF L-NROMES = 12 THEN
                DB-WORK.PL-CFG.Fecha-Hasta =  DATE(12, 31, S-PERIODO).
            ELSE
                DB-WORK.PL-CFG.Fecha-Hasta =  DATE(L-NROMES + 1, 1 , S-PERIODO ) - 1.
    END.
    WHEN 3 THEN DO:

    END.
    END CASE.

    /* Nombre del Mes */

    RUN bin/_mes.p( DB-WORK.PL-CFG.NroMes, 2 , OUTPUT DB-WORK.PL-CFG.Nombre-Mes ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ADD-SEMANAL W-Win 
PROCEDURE ADD-SEMANAL :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i AS INTEGER NO-UNDO.

    CASE R-seleccion:
    WHEN 1 THEN 
        FOR EACH integral.PL-FLG-SEM WHERE
            integral.PL-FLG-SEM.codcia  = s-codcia AND
            integral.PL-FLG-SEM.periodo = s-periodo AND
            integral.PL-FLG-SEM.codpln  = l-codpln AND
            integral.PL-FLG-SEM.nrosem  = l-nrosem:
            RUN pl-semanal.
        END.
    WHEN 2 THEN 
        DO i = 1 TO br_pl-flg-s:NUM-SELECTED-ROWS IN FRAME F-Main:
            ASSIGN ok-status = br_pl-flg-s:FETCH-SELECTED-ROW(i).
            IF ok-status THEN RUN pl-semanal.
        END.
    WHEN 3 THEN
        FOR EACH integral.PL-FLG-SEM  WHERE
            integral.PL-FLG-SEM.codcia  = s-codcia AND
            integral.PL-FLG-SEM.periodo = s-periodo AND
            integral.PL-FLG-SEM.codpln  = l-codpln AND
            integral.PL-FLG-SEM.nrosem  = l-nrosem AND
            integral.PL-FLG-SEM.seccion = Combo-s:
            RUN pl-semanal.
        END.
    WHEN 4  THEN
        FOR EACH integral.PL-FLG-SEM WHERE
            integral.PL-FLG-SEM.codcia   = s-codcia AND
            integral.PL-FLG-SEM.periodo  = s-periodo AND
            integral.PL-FLG-SEM.codpln   = l-codpln AND
            integral.PL-FLG-SEM.nrosem   = l-nrosem AND
            integral.PL-FLG-SEM.proyecto = Combo-s:
            RUN pl-semanal.
        END.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CREA-TEMP-DBWORK W-Win 
PROCEDURE CREA-TEMP-DBWORK :
DEFINE INPUT PARAMETER P-CODVAR AS INTEGER.
DEFINE INPUT PARAMETER P-VALCAL AS DECIMAL.

IF P-VALCAL = 0 THEN    RETURN.

IF P-CODVAR > 0 AND P-CODVAR < 51 THEN
   ASSIGN db-work.PL-PERS.V[P-CODVAR] = db-work.PL-PERS.V[P-CODVAR] + P-VALCAL
          db-work.PL-PERS.FLGEST      = TRUE.
          
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win  _DEFAULT-DISABLE
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

    APPLY "VALUE-CHANGED" TO R-seleccion IN FRAME F-Main.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FECHAS_V W-Win 
PROCEDURE FECHAS_V :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER idx AS INTEGER.
    DEFINE VARIABLE meses-serv AS DECIMAL.
    DEFINE VARIABLE cstr       AS CHARACTER NO-UNDO.

    meses-serv = DB-WORK.PL-PERS.V[ idx ].

    IF meses-serv = 0 THEN RETURN.

    IF (meses-serv / 12) >= 1 THEN
        IF (meses-serv / 12) >= 2 THEN
            cstr = STRING(TRUNCATE(meses-serv / 12 , 0), ">>>9") + " A¤os ".
        ELSE cstr = "1 A¤o ".

    meses-serv = ((meses-serv / 12) - TRUNCATE(meses-serv / 12 , 0)) * 12.

    IF meses-serv >= 1 THEN
        IF meses-serv >= 2 THEN
            cstr = cstr + STRING(TRUNCATE(meses-serv, 0) , ">9") + " Meses ".
        ELSE cstr = cstr + "1 Mes ".

    meses-serv = INTEGER((meses-serv - TRUNCATE(meses-serv , 0)) * 30).

    IF meses-serv >= 1 THEN
        IF meses-serv >= 2 THEN
            cstr = cstr + STRING(meses-serv, ">9") + " Dias ".
        ELSE cstr = cstr + "1 Dia ".

    ASSIGN DB-WORK.PL-PERS.FECHA_V[ idx ] = cstr.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE habilita W-Win 
PROCEDURE habilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER tipo AS INTEGER.

    DO WITH FRAME {&FRAME-NAME}:
        CASE tipo:
        WHEN 1 THEN DO:
            L-CODPLN:VISIBLE = TRUE.
            Btn-DOWN-3:VISIBLE = TRUE.
            Btn-DOWN-4:VISIBLE = FALSE.
            Btn-UP-3:VISIBLE = TRUE.
            Btn-UP-4:VISIBLE = FALSE.
            L-CODPLN-m:VISIBLE = FALSE.
            FIND FIRST PL-PLAN WHERE PL-PLAN.TipPln = FALSE NO-ERROR.
            IF AVAILABLE PL-PLAN THEN L-CODPLN = PL-PLAN.CODPLN.
            DISPLAY L-CODPLN WITH FRAME F-Main.
            L-NROSEM = s-nrosem.
            L-NROSEM:VISIBLE   = YES.
            DISPLAY L-NROSEM.
            L-NROMES:HIDDEN    = YES.
            Btn-DOWN:VISIBLE   = YES. 
            Btn-UP:VISIBLE     = YES.
            Btn-DOWN-2:VISIBLE = NO.
            Btn-UP-2:VISIBLE   = NO.
            br_pl-flg-s:SENSITIVE = YES.
            br_pl-flg-s:VISIBLE   = YES.
            br_pl-flg-m:SENSITIVE = NO.
            br_pl-flg-m:HIDDEN   = YES.
            {&OPEN-QUERY-br_pl-flg-s}
        END.
        WHEN 2 THEN DO:
            L-CODPLN:VISIBLE = FALSE.
            L-CODPLN-m:VISIBLE = TRUE.
            Btn-DOWN-3:VISIBLE = FALSE.
            Btn-DOWN-4:VISIBLE = TRUE.
            Btn-UP-3:VISIBLE = FALSE.
            Btn-UP-4:VISIBLE = TRUE.
            FIND FIRST PL-PLAN WHERE PL-PLAN.TipPln = TRUE NO-ERROR.
            IF AVAILABLE PL-PLAN THEN L-CODPLN-m = PL-PLAN.CODPLN.
            DISPLAY L-CODPLN-m WITH FRAME F-Main.
            L-NROSEM:HIDDEN   = YES.
            L-NROMES  = s-nromes.
            L-NROMES:VISIBLE  = YES.
            DISPLAY L-NROMES.
            Btn-DOWN:VISIBLE  = NO. 
            Btn-UP:VISIBLE    = NO.
            Btn-DOWN-2:VISIBLE = YES. 
            Btn-UP-2:VISIBLE   = YES.
            br_pl-flg-m:SENSITIVE = YES.
            br_pl-flg-m:VISIBLE   = YES.
            br_pl-flg-s:SENSITIVE = NO.
            br_pl-flg-s:HIDDEN   = YES.
            {&OPEN-QUERY-br_pl-flg-m}                 
        END.
        WHEN 3 THEN DO:
            L-NROSEM:HIDDEN      = YES.
            L-NROMES:HIDDEN      = YES.
            L-CODPLN:VISIBLE     = NO.
            Btn-DOWN:VISIBLE     = NO. 
            Btn-UP:VISIBLE       = NO.
            Btn-DOWN-2:VISIBLE   = NO. 
            Btn-UP-2:VISIBLE     = NO.
            Btn-DOWN-3:VISIBLE   = NO. 
            Btn-UP-3:VISIBLE     = NO.
            br_pl-pers:SENSITIVE = YES.
            br_pl-pers:VISIBLE   = YES.
            {&OPEN-QUERY-br_pl-pers}
        END.
        END CASE.
        APPLY "VALUE-CHANGED" TO R-seleccion.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPORTES_V W-Win 
PROCEDURE IMPORTES_V :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF DB-WORK.PL-PERS.V[1] <= 0 THEN RETURN.

    RUN bin/_numero.p(DB-WORK.PL-PERS.V[1], 2, 2, OUTPUT DB-WORK.PL-PERS.IMPORTE_V1).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OPEN-QUERY B-table-Win 
PROCEDURE OPEN-QUERY :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO WITH FRAME {&FRAME-NAME}:    
        CASE COMBO-BOX-1:SCREEN-VALUE:
            WHEN COMBO-BOX-1:ENTRY(1) THEN RUN OPEN-QUERY-CODIGO.
            WHEN COMBO-BOX-1:ENTRY(2) THEN RUN OPEN-QUERY-NOMBRE.
        END CASE.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OPEN-QUERY-CODIGO B-table-Win 
PROCEDURE OPEN-QUERY-CODIGO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:

    IF FILL-IN-NOMBRE:SCREEN-VALUE = "" THEN
        OPEN QUERY {&BROWSE-NAME} FOR EACH PL-FLG-MES WHERE
            PL-FLG-MES.CodCia = s-CodCia AND
            PL-FLG-MES.Periodo = s-Periodo AND
            PL-FLG-MES.codpln = PL-PLAN.CodPln AND
            PL-FLG-MES.NroMes = s-nromes NO-LOCK,
            EACH INTEGRAL.pl-pers OF PL-FLG-MES NO-LOCK
            BY PL-FLG-MES.codper.
    ELSE
        IF COMBO-BOX-2:SCREEN-VALUE = COMBO-BOX-2:ENTRY(1) THEN
            OPEN QUERY {&BROWSE-NAME} FOR EACH PL-FLG-MES WHERE
                PL-FLG-MES.CodCia = s-CodCia AND
                PL-FLG-MES.Periodo = s-Periodo AND
                PL-FLG-MES.codpln = PL-PLAN.CodPln AND
                PL-FLG-MES.NroMes = s-nromes NO-LOCK,
                EACH INTEGRAL.pl-pers OF PL-FLG-MES NO-LOCK WHERE
                    INTEGRAL.pl-pers.patper BEGINS FILL-IN-NOMBRE:SCREEN-VALUE OR
                    INTEGRAL.pl-pers.matper BEGINS FILL-IN-NOMBRE:SCREEN-VALUE OR
                    INTEGRAL.pl-pers.nomper BEGINS FILL-IN-NOMBRE:SCREEN-VALUE
                BY PL-FLG-MES.codper.
        ELSE
            OPEN QUERY {&BROWSE-NAME} FOR EACH PL-FLG-MES WHERE
                PL-FLG-MES.CodCia = s-CodCia AND
                PL-FLG-MES.Periodo = s-Periodo AND
                PL-FLG-MES.codpln = PL-PLAN.CodPln AND
                PL-FLG-MES.NroMes = s-nromes NO-LOCK,
                EACH INTEGRAL.pl-pers OF PL-FLG-MES NO-LOCK WHERE
                    INDEX( INTEGRAL.pl-pers.patper, FILL-IN-NOMBRE:SCREEN-VALUE ) <> 0 OR
                    INDEX( INTEGRAL.pl-pers.matper, FILL-IN-NOMBRE:SCREEN-VALUE ) <> 0 OR
                    INDEX( INTEGRAL.pl-pers.nomper, FILL-IN-NOMBRE:SCREEN-VALUE ) <> 0
                BY PL-FLG-MES.codper.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OPEN-QUERY-NOMBRE B-table-Win 
PROCEDURE OPEN-QUERY-NOMBRE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:

    IF FILL-IN-NOMBRE:SCREEN-VALUE = "" THEN
        OPEN QUERY {&BROWSE-NAME} FOR EACH PL-FLG-MES WHERE
            PL-FLG-MES.CodCia = s-CodCia AND
            PL-FLG-MES.Periodo = s-Periodo AND
            PL-FLG-MES.codpln = PL-PLAN.CodPln AND
            PL-FLG-MES.NroMes = s-nromes NO-LOCK,
            EACH INTEGRAL.pl-pers OF PL-FLG-MES NO-LOCK
            BY INTEGRAL.pl-pers.patper
            BY INTEGRAL.pl-pers.matper
            BY INTEGRAL.pl-pers.nomper.
    ELSE
        IF COMBO-BOX-2:SCREEN-VALUE = COMBO-BOX-2:ENTRY(1) THEN
            OPEN QUERY {&BROWSE-NAME} FOR EACH PL-FLG-MES WHERE
                PL-FLG-MES.CodCia = s-CodCia AND
                PL-FLG-MES.Periodo = s-Periodo AND
                PL-FLG-MES.codpln = PL-PLAN.CodPln AND
                PL-FLG-MES.NroMes = s-nromes NO-LOCK,
                EACH INTEGRAL.pl-pers OF PL-FLG-MES NO-LOCK WHERE
                    INTEGRAL.pl-pers.patper BEGINS FILL-IN-NOMBRE:SCREEN-VALUE OR
                    INTEGRAL.pl-pers.matper BEGINS FILL-IN-NOMBRE:SCREEN-VALUE OR
                    INTEGRAL.pl-pers.nomper BEGINS FILL-IN-NOMBRE:SCREEN-VALUE
                BY INTEGRAL.pl-pers.patper
                BY INTEGRAL.pl-pers.matper
                BY INTEGRAL.pl-pers.nomper.
        ELSE
            OPEN QUERY {&BROWSE-NAME} FOR EACH PL-FLG-MES WHERE
                PL-FLG-MES.CodCia = s-CodCia AND
                PL-FLG-MES.Periodo = s-Periodo AND
                PL-FLG-MES.codpln = PL-PLAN.CodPln AND
                PL-FLG-MES.NroMes = s-nromes NO-LOCK,
                EACH INTEGRAL.pl-pers OF PL-FLG-MES NO-LOCK WHERE
                    INDEX( INTEGRAL.pl-pers.patper, FILL-IN-NOMBRE:SCREEN-VALUE ) <> 0 OR
                    INDEX( INTEGRAL.pl-pers.matper, FILL-IN-NOMBRE:SCREEN-VALUE ) <> 0 OR
                    INDEX( INTEGRAL.pl-pers.nomper, FILL-IN-NOMBRE:SCREEN-VALUE ) <> 0
                BY INTEGRAL.pl-pers.patper
                BY INTEGRAL.pl-pers.matper
                BY INTEGRAL.pl-pers.nomper.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PL-MENSUAL W-Win 
PROCEDURE PL-MENSUAL :
/*
    Planilla mensual
*/

    DEFINE VARIABLE x-nromes AS INTEGER.
    DEFINE VARIABLE x-valcal AS DECIMAL.
    
    /* CREANDO EL REGISTRO TEMPORAL DE PERSONAL */
    CREATE DB-WORK.PL-PERS.
    ASSIGN
        db-work.PL-PERS.codper       = integral.PL-FLG-MES.codper
        db-work.PL-PERS.codpln       = integral.PL-FLG-MES.codpln
        db-work.PL-PERS.cargos       = integral.PL-FLG-MES.cargos 
        db-work.PL-PERS.ccosto       = integral.PL-FLG-MES.ccosto 
        db-work.PL-PERS.Clase        = integral.PL-FLG-MES.Clase 
        db-work.PL-PERS.cnpago       = integral.PL-FLG-MES.cnpago 
        db-work.PL-PERS.nrodpt       = integral.PL-FLG-MES.nrodpt
        db-work.PL-PERS.codafp       = integral.PL-FLG-MES.codafp 
        db-work.PL-PERS.CodDiv       = integral.PL-FLG-MES.CodDiv 
        db-work.PL-PERS.Conyugue     = integral.PL-FLG-MES.Conyugue 
        db-work.PL-PERS.fecing       = integral.PL-FLG-MES.fecing 
        db-work.PL-PERS.finvac       = integral.PL-FLG-MES.finvac 
        db-work.PL-PERS.CTS          = integral.PL-FLG-MES.CTS 
        db-work.PL-PERS.nrodpt-cts   = integral.PL-FLG-MES.nrodpt-cts 
        db-work.PL-PERS.inivac       = integral.PL-FLG-MES.inivac 
        db-work.PL-PERS.Nro-de-Hijos = integral.PL-FLG-MES.Nro-de-Hijos 
        db-work.PL-PERS.nroafp       = integral.PL-FLG-MES.nroafp 
        db-work.PL-PERS.Proyecto     = integral.PL-FLG-MES.Proyecto 
        db-work.PL-PERS.seccion      = integral.PL-FLG-MES.seccion
        db-work.PL-PERS.SitAct       = integral.PL-FLG-MES.SitAct 
        db-work.PL-PERS.vcontr       = integral.PL-FLG-MES.vcontr.

    ASSIGN s-nroreg-tot = s-nroreg-tot + 1.
    IF db-work.PL-PERS.SitAct <> "Inactivo" THEN s-nroreg-act = s-nroreg-act + 1.

    FIND integral.PL-PROY WHERE
        integral.PL-PROY.PROYECTO = integral.PL-FLG-MES.PROYECTO NO-LOCK NO-ERROR.
    IF AVAILABLE integral.PL-PROY THEN
        ASSIGN db-work.PL-PERS.RegPat = integral.PL-PROY.RegPat.

    FIND integral.PL-AFPS WHERE
        integral.PL-AFPS.CODAFP = integral.PL-FLG-MES.CODAFP NO-LOCK NO-ERROR.
    IF AVAILABLE integral.PL-AFPS THEN
        ASSIGN db-work.PL-PERS.AFP = integral.PL-AFPS.DesAfp.

    FIND integral.PL-CTS WHERE
        integral.PL-CTS.CTS = integral.PL-FLG-MES.CTS NO-LOCK NO-ERROR.
    IF AVAILABLE integral.PL-CTS THEN
        ASSIGN db-work.PL-PERS.MONEDA-CTS = integral.PL-CTS.MONEDA-CTS.

    FIND integral.PL-PERS WHERE
        integral.PL-PERS.codper = integral.PL-FLG-MES.codper NO-LOCK NO-ERROR.
    IF AVAILABLE integral.PL-PERS THEN DO:
        db-work.PL-PERS.CodBar    = integral.PL-PERS.CodBar.
        db-work.PL-PERS.CodCia    = s-codcia.
        db-work.PL-PERS.ctipss    = integral.PL-PERS.ctipss.
        db-work.PL-PERS.dirper    = integral.PL-PERS.dirper.
        db-work.PL-PERS.distri    = integral.PL-PERS.distri.
        db-work.PL-PERS.ecivil    = integral.PL-PERS.ecivil.
        db-work.PL-PERS.fecnac    = integral.PL-PERS.fecnac.
        db-work.PL-PERS.lelect    = integral.PL-PERS.NroDocId.
        db-work.PL-PERS.lmilit    = integral.PL-PERS.lmilit.
        db-work.PL-PERS.localidad = integral.PL-PERS.localidad.
        db-work.PL-PERS.matper    = integral.PL-PERS.matper.
        db-work.PL-PERS.nacion    = integral.PL-PERS.nacion.
        db-work.PL-PERS.nomper    = integral.PL-PERS.nomper.
        db-work.PL-PERS.patper    = integral.PL-PERS.patper.
        db-work.PL-PERS.profesion = integral.PL-PERS.profesion.
        db-work.PL-PERS.provin    = integral.PL-PERS.provin.
        db-work.PL-PERS.sexper    = integral.PL-PERS.sexper.
        db-work.PL-PERS.telefo    = integral.PL-PERS.telefo.
        db-work.PL-PERS.titulo    = integral.PL-PERS.titulo.
        db-work.PL-PERS.TpoPer    = integral.PL-PERS.TpoPer.
    END.

    FILL-IN-msj = db-work.PL-PERS.codper + " " +
        db-work.PL-PERS.PATPER + " " +
        db-work.PL-PERS.MATPER + ", " +
        db-work.PL-PERS.NOMPER.

    DISPLAY FILL-IN-msj WITH FRAME F-mensaje.

    FOR EACH PL-VAR-RPT WHERE
        PL-VAR-RPT.CodRep = p-codrep AND
        PL-VAR-RPT.TpoRpt = 2 NO-LOCK:

        /* VARIABLES SEGUN CONFIGURACION */
        x-nromes = IF PL-VAR-RPT.NROMES = 0 THEN l-nromes ELSE PL-VAR-RPT.NROMES.

        IF x-nromes < 0 THEN x-nromes = l-nromes + x-nromes.

        IF PL-VAR-RPT.Periodo = 0 THEN p-periodo = s-periodo.
        ELSE
            IF PL-VAR-RPT.Periodo > 0 THEN p-periodo = PL-VAR-RPT.Periodo.
            ELSE p-periodo = s-periodo - PL-VAR-RPT.Periodo.

        ASSIGN
            p-mes-1 = x-nromes
            p-mes-2 = x-nromes.

        IF PL-VAR-RPT.Metodo = 3 THEN
            ASSIGN
                p-mes-1 = 1
                p-mes-2 = l-nromes.
                
        /* JALANDO DATOS */
        x-valcal = 0.
        FOR EACH integral.PL-MOV-MES WHERE
            integral.PL-MOV-MES.CODCIA  = s-codcia AND
            integral.PL-MOV-MES.PERIODO = p-periodo AND
            integral.PL-MOV-MES.codpln  = PL-FLG-MES.codpln AND
            integral.PL-MOV-MES.CODCAL  = PL-VAR-RPT.CodCal AND
            integral.PL-MOV-MES.codper  = PL-FLG-MES.codper AND
            integral.PL-MOV-MES.CODMOV  = PL-VAR-RPT.CodMov AND
            integral.PL-MOV-MES.NROMES  >= p-mes-1 AND
            integral.PL-MOV-MES.NROMES  <= p-mes-2 NO-LOCK:
            x-valcal = x-valcal + integral.PL-MOV-MES.VALCAL-MES.
        END.
        RUN CREA-TEMP-DBWORK ( PL-VAR-RPT.CodVAR, x-valcal ).
    END.
    RUN IMPORTES_V.
    RUN FECHAS_V( 2 ).
    RUN FECHAS_V( 3 ).
    RUN FECHAS_V( 4 ).
    RUN FECHAS_V( 5 ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PL-SEMANAL W-Win 
PROCEDURE PL-SEMANAL :
/*
    Crea registros de semana
*/

    DEFINE VARIABLE x-nrosem AS INTEGER.
    DEFINE VARIABLE x-valcal AS DECIMAL.

    /* CREANDO EL REGISTRO TEMPORAL DE PERSONAL */
    FIND db-work.PL-PERS WHERE
        db-work.PL-PERS.codper = integral.PL-FLG-SEM.codper NO-LOCK NO-ERROR.
    IF AVAILABLE db-work.PL-PERS THEN RETURN.

    CREATE DB-WORK.PL-PERS.
    ASSIGN
        db-work.PL-PERS.codper       = integral.PL-FLG-SEM.codper
        db-work.PL-PERS.codpln       = integral.PL-FLG-SEM.codpln
        db-work.PL-PERS.cargos       = integral.PL-FLG-SEM.cargos 
        db-work.PL-PERS.ccosto       = integral.PL-FLG-SEM.ccosto 
        db-work.PL-PERS.Clase        = integral.PL-FLG-SEM.Clase 
        db-work.PL-PERS.cnpago       = integral.PL-FLG-SEM.cnpago 
        db-work.PL-PERS.nrodpt       = integral.PL-FLG-SEM.nrodpt
        db-work.PL-PERS.codafp       = integral.PL-FLG-SEM.codafp 
        db-work.PL-PERS.CodDiv       = integral.PL-FLG-SEM.CodDiv 
        db-work.PL-PERS.Conyugue     = integral.PL-FLG-SEM.Conyugue 
        db-work.PL-PERS.fecing       = integral.PL-FLG-SEM.fecing 
        db-work.PL-PERS.finvac       = integral.PL-FLG-SEM.finvac 
        db-work.PL-PERS.CTS          = integral.PL-FLG-SEM.CTS 
        db-work.PL-PERS.nrodpt-cts   = integral.PL-FLG-SEM.nrodpt-cts 
        db-work.PL-PERS.inivac       = integral.PL-FLG-SEM.inivac 
        db-work.PL-PERS.Nro-de-Hijos = integral.PL-FLG-SEM.Nro-de-Hijos 
        db-work.PL-PERS.nroafp       = integral.PL-FLG-SEM.nroafp 
        db-work.PL-PERS.Proyecto     = integral.PL-FLG-SEM.Proyecto 
        db-work.PL-PERS.seccion      = integral.PL-FLG-SEM.seccion
        db-work.PL-PERS.SitAct       = integral.PL-FLG-SEM.SitAct 
        db-work.PL-PERS.vcontr       = integral.PL-FLG-SEM.vcontr.

    ASSIGN s-nroreg-tot = s-nroreg-tot + 1.
    IF db-work.PL-PERS.SitAct <> "Inactivo" THEN s-nroreg-act = s-nroreg-act + 1.

    FIND integral.PL-PROY WHERE
        integral.PL-PROY.PROYECTO = integral.PL-FLG-SEM.proyecto NO-LOCK NO-ERROR.
    IF AVAILABLE integral.PL-PROY THEN
        ASSIGN db-work.PL-PERS.RegPat = integral.PL-PROY.RegPat.

    FIND integral.PL-CTS WHERE
        integral.PL-CTS.CTS = integral.PL-FLG-SEM.CTS NO-LOCK NO-ERROR.
    IF AVAILABLE integral.PL-CTS THEN
        ASSIGN db-work.PL-PERS.MONEDA-CTS = integral.PL-CTS.MONEDA-CTS.

    FIND integral.PL-AFPS WHERE
        integral.PL-AFPS.CODAFP = integral.PL-FLG-MES.CODAFP NO-LOCK NO-ERROR.
    IF AVAILABLE integral.PL-AFPS THEN
        ASSIGN db-work.PL-PERS.AFP = integral.PL-AFPS.DesAfp.

    FIND integral.PL-PERS WHERE
        integral.PL-PERS.codper = integral.PL-FLG-SEM.codper NO-LOCK NO-ERROR.
    IF AVAILABLE integral.PL-PERS THEN DO:
        db-work.PL-PERS.CodBar    = integral.PL-PERS.CodBar.
        db-work.PL-PERS.CodCia    = s-codcia.
        db-work.PL-PERS.ctipss    = integral.PL-PERS.ctipss.
        db-work.PL-PERS.dirper    = integral.PL-PERS.dirper.
        db-work.PL-PERS.distri    = integral.PL-PERS.distri.
        db-work.PL-PERS.ecivil    = integral.PL-PERS.ecivil.
        db-work.PL-PERS.fecnac    = integral.PL-PERS.fecnac.
        db-work.PL-PERS.lelect    = integral.PL-PERS.NroDocId.
        db-work.PL-PERS.lmilit    = integral.PL-PERS.lmilit.
        db-work.PL-PERS.localidad = integral.PL-PERS.localidad.
        db-work.PL-PERS.matper    = integral.PL-PERS.matper.
        db-work.PL-PERS.nacion    = integral.PL-PERS.nacion.
        db-work.PL-PERS.nomper    = integral.PL-PERS.nomper.
        db-work.PL-PERS.patper    = integral.PL-PERS.patper.
        db-work.PL-PERS.profesion = integral.PL-PERS.profesion.
        db-work.PL-PERS.provin    = integral.PL-PERS.provin.
        db-work.PL-PERS.sexper    = integral.PL-PERS.sexper.
        db-work.PL-PERS.telefo    = integral.PL-PERS.telefo.
        db-work.PL-PERS.titulo    = integral.PL-PERS.titulo.
        db-work.PL-PERS.TpoPer    = integral.PL-PERS.TpoPer.
    END.

    FILL-IN-msj = db-work.PL-PERS.codper + " " +
        db-work.PL-PERS.PATPER + " " +
        db-work.PL-PERS.MATPER + ", " +
        db-work.PL-PERS.NOMPER.

    DISPLAY FILL-IN-msj WITH FRAME F-mensaje.

    FOR EACH PL-VAR-RPT WHERE
        PL-VAR-RPT.CodRep = p-codrep AND
        PL-VAR-RPT.TpoRpt = 1:

        /* VARIABLES SEGUN CONFIGURACION */
        x-nrosem = IF PL-VAR-RPT.nrosem = 0 THEN L-nrosem ELSE PL-VAR-RPT.nrosem.

        IF PL-VAR-RPT.Periodo = 0 THEN p-periodo = s-periodo.
        ELSE
            IF PL-VAR-RPT.Periodo > 0 THEN p-periodo = PL-VAR-RPT.Periodo.
            ELSE p-periodo = s-periodo - PL-VAR-RPT.Periodo.

        ASSIGN
            p-sem-1 = x-nrosem
            p-sem-2 = x-nrosem.

        IF PL-VAR-RPT.Metodo = 3 THEN
            ASSIGN
                p-sem-1 = 1
                p-sem-2 = L-nrosem.

        /* BUSCAMOS LA SEMANA DE INICIO Y FIN DEL MES */
        IF PL-VAR-RPT.Metodo = 2 THEN DO:
            mes-actual = PL-VAR-RPT.nromes.
            IF mes-actual <= 0 THEN DO:
                FIND integral.PL-SEM WHERE
                    integral.PL-SEM.CodCia = s-codcia AND
                    integral.PL-SEM.Periodo = s-periodo AND
                    integral.PL-SEM.nrosem = L-nrosem NO-LOCK NO-ERROR.
                ASSIGN mes-actual = integral.PL-SEM.nromes + mes-actual.
            END.
            IF mes-actual < 1 THEN
                ASSIGN
                    p-periodo = ( p-periodo - 1 )
                    mes-actual = mes-actual + 12.

            /* PRIMERA SEMANA DEL MES */
            FIND FIRST integral.PL-SEM WHERE
                integral.PL-SEM.CodCia = s-codcia AND
                integral.PL-SEM.Periodo = s-periodo AND
                integral.PL-SEM.nromes = mes-actual
                NO-LOCK NO-ERROR.
            p-sem-1 = integral.PL-SEM.nrosem.

            /* ULTIMA SEMANA DEL MES */
            FIND LAST integral.PL-SEM WHERE
                integral.PL-SEM.CodCia = s-codcia AND
                integral.PL-SEM.Periodo = s-periodo AND
                integral.PL-SEM.nromes = mes-actual
                NO-LOCK NO-ERROR.
            p-sem-2 = integral.PL-SEM.nrosem.
        END.

        /* JALANDO DATOS */  
        x-valcal = 0.
        FOR EACH integral.PL-MOV-SEM WHERE
            integral.PL-MOV-SEM.CODCIA  = s-codcia AND
            integral.PL-MOV-SEM.PERIODO = p-periodo AND
            integral.PL-MOV-SEM.CODPLN  = PL-FLG-SEM.CodPLN AND
            integral.PL-MOV-SEM.CODCAL  = PL-VAR-RPT.CodCal AND
            integral.PL-MOV-SEM.codper  = PL-FLG-SEM.codper AND
            integral.PL-MOV-SEM.CODMOV  = PL-VAR-RPT.CodMov AND
            integral.PL-MOV-SEM.nrosem  >= p-sem-1 AND
            integral.PL-MOV-SEM.nrosem  <= p-sem-2:
            x-valcal = x-valcal + integral.PL-MOV-SEM.VALCAL-SEM.
        END.
        RUN CREA-TEMP-DBWORK ( PL-VAR-RPT.CodVAR, x-valcal ).
    END.
    RUN IMPORTES_V.
    RUN FECHAS_V( 2 ).
    RUN FECHAS_V( 3 ).
    RUN FECHAS_V( 4 ).
    RUN FECHAS_V( 5 ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PROCESA W-Win 
PROCEDURE PROCESA :
/*
    Porcesa
*/
    IF TGL-uni = TRUE THEN DO:
        RUN add-semanal.
        RUN add-mensual.
    END.
    ELSE DO:
        CASE p-tipo:
            WHEN 1 THEN RUN add-semanal.
            WHEN 2 THEN RUN add-mensual.
        END CASE.
    END.

    FILL-IN-msj = "... Archivos de Configuraci¢n ...".
    DISPLAY FILL-IN-msj WITH FRAME F-mensaje.
    RUN add-pl-cfg.
    RUN add-pfcias.
    RUN add-pl-afp.
    HIDE FRAME F-mensaje.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win  _ADM-SEND-RECORDS
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
  {src/adm/template/snd-list.i "integral.PL-FLG-MES"}
  {src/adm/template/snd-list.i "INTEGRAL.pl-pers"}

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

