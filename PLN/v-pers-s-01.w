&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
DEFINE VARIABLE CMB-Canal     AS CHARACTER NO-UNDO.
DEFINE VARIABLE CMB-Cargos    AS CHARACTER NO-UNDO.
DEFINE VARIABLE CMB-Seccion   AS CHARACTER NO-UNDO.
DEFINE VARIABLE CMB-Proyecto  AS CHARACTER NO-UNDO.
DEFINE VARIABLE CMB-CTS       AS CHARACTER NO-UNDO.
DEFINE VARIABLE CMB-Clase     AS CHARACTER NO-UNDO.
DEFINE VARIABLE reg-act       AS ROWID NO-UNDO.
DEFINE VARIABLE cCodPer       LIKE pl-pers.codper NO-UNDO.
DEFINE VARIABLE lExiste       AS LOGICAL   NO-UNDO.

{bin/s-global.i}
{pln/s-global.i}

DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES integral.PL-FLG-SEM integral.PL-PLAN
&Scoped-define FIRST-EXTERNAL-TABLE integral.PL-FLG-SEM


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR integral.PL-FLG-SEM, integral.PL-PLAN.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS INTEGRAL.PL-FLG-SEM.codper ~
INTEGRAL.PL-FLG-SEM.SitAct INTEGRAL.PL-FLG-SEM.Conyugue ~
INTEGRAL.PL-FLG-SEM.Nro-de-Hijos INTEGRAL.PL-FLG-SEM.cnpago ~
INTEGRAL.PL-FLG-SEM.nrodpt INTEGRAL.PL-FLG-SEM.ccosto ~
INTEGRAL.PL-FLG-SEM.CodDiv INTEGRAL.PL-FLG-SEM.CTS ~
INTEGRAL.PL-FLG-SEM.NroDpt-CTS INTEGRAL.PL-FLG-SEM.seccion ~
INTEGRAL.PL-FLG-SEM.codafp INTEGRAL.PL-FLG-SEM.nroafp ~
INTEGRAL.PL-FLG-SEM.cargos INTEGRAL.PL-FLG-SEM.FchInsRgp ~
INTEGRAL.PL-FLG-SEM.Clase INTEGRAL.PL-FLG-SEM.Proyecto ~
INTEGRAL.PL-FLG-SEM.Categoria INTEGRAL.PL-FLG-SEM.fecing ~
INTEGRAL.PL-FLG-SEM.inivac INTEGRAL.PL-FLG-SEM.finvac ~
INTEGRAL.PL-FLG-SEM.vcontr INTEGRAL.PL-FLG-SEM.MotivoFin ~
INTEGRAL.PL-FLG-SEM.ModFormat 
&Scoped-define ENABLED-TABLES INTEGRAL.PL-FLG-SEM
&Scoped-define FIRST-ENABLED-TABLE INTEGRAL.PL-FLG-SEM
&Scoped-Define ENABLED-OBJECTS RECT-14 RECT-15 RECT-16 
&Scoped-Define DISPLAYED-FIELDS INTEGRAL.PL-FLG-SEM.codper ~
INTEGRAL.PL-FLG-SEM.SitAct INTEGRAL.PL-FLG-SEM.Conyugue ~
INTEGRAL.PL-FLG-SEM.Nro-de-Hijos INTEGRAL.PL-FLG-SEM.cnpago ~
INTEGRAL.PL-FLG-SEM.nrodpt INTEGRAL.PL-FLG-SEM.ccosto ~
INTEGRAL.PL-FLG-SEM.CodDiv INTEGRAL.PL-FLG-SEM.CTS ~
INTEGRAL.PL-FLG-SEM.NroDpt-CTS INTEGRAL.PL-FLG-SEM.seccion ~
INTEGRAL.PL-FLG-SEM.codafp INTEGRAL.PL-FLG-SEM.nroafp ~
INTEGRAL.PL-FLG-SEM.cargos INTEGRAL.PL-FLG-SEM.FchInsRgp ~
INTEGRAL.PL-FLG-SEM.Clase INTEGRAL.PL-FLG-SEM.Proyecto ~
INTEGRAL.PL-FLG-SEM.Categoria INTEGRAL.PL-FLG-SEM.fecing ~
INTEGRAL.PL-FLG-SEM.inivac INTEGRAL.PL-FLG-SEM.finvac ~
INTEGRAL.PL-FLG-SEM.vcontr INTEGRAL.PL-FLG-SEM.MotivoFin ~
INTEGRAL.PL-FLG-SEM.ModFormat 
&Scoped-define DISPLAYED-TABLES INTEGRAL.PL-FLG-SEM
&Scoped-define FIRST-DISPLAYED-TABLE INTEGRAL.PL-FLG-SEM
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Nombre FILL-IN-desafp ~
FILL-IN-MotivoFin FILL-IN-ModFormat 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE FILL-IN-desafp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-ModFormat AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 28 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-MotivoFin AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 28 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Nombre AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 53 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY .12.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 9.81.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY .12.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     INTEGRAL.PL-FLG-SEM.codper AT ROW 1.27 COL 8 COLON-ALIGNED
          LABEL "Código"
          VIEW-AS FILL-IN 
          SIZE 7.57 BY .81
          BGCOLOR 15 FGCOLOR 0 
     FILL-IN-Nombre AT ROW 1.27 COL 16 COLON-ALIGNED NO-LABEL
     INTEGRAL.PL-FLG-SEM.SitAct AT ROW 2.08 COL 8 COLON-ALIGNED
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEMS "Activo","Vacaciones","Descanso médico","Descanso pre-natal","Descanso post-natal","Licencia con Goce","Licencia sin Goce","Inactivo" 
          DROP-DOWN-LIST
          SIZE 20.72 BY 1
     INTEGRAL.PL-FLG-SEM.Conyugue AT ROW 2.08 COL 54.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .81
     INTEGRAL.PL-FLG-SEM.Nro-de-Hijos AT ROW 2.08 COL 74 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.57 BY .81
     INTEGRAL.PL-FLG-SEM.cnpago AT ROW 3.5 COL 8 COLON-ALIGNED
          VIEW-AS COMBO-BOX SORT INNER-LINES 5
          DROP-DOWN-LIST
          SIZE 21.29 BY 1
     INTEGRAL.PL-FLG-SEM.nrodpt AT ROW 3.5 COL 34 COLON-ALIGNED
          LABEL "Nro."
          VIEW-AS FILL-IN 
          SIZE 14.29 BY .81
     INTEGRAL.PL-FLG-SEM.ccosto AT ROW 3.5 COL 55 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.57 BY .81
     INTEGRAL.PL-FLG-SEM.CodDiv AT ROW 3.5 COL 73 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     INTEGRAL.PL-FLG-SEM.CTS AT ROW 4.31 COL 8 COLON-ALIGNED
          VIEW-AS COMBO-BOX SORT INNER-LINES 5
          DROP-DOWN-LIST
          SIZE 21.29 BY 1
     INTEGRAL.PL-FLG-SEM.NroDpt-CTS AT ROW 4.31 COL 34 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.29 BY .81
     INTEGRAL.PL-FLG-SEM.seccion AT ROW 4.31 COL 55 COLON-ALIGNED FORMAT "X(50)"
          VIEW-AS COMBO-BOX SORT INNER-LINES 5
          DROP-DOWN-LIST
          SIZE 24.72 BY 1
     INTEGRAL.PL-FLG-SEM.codafp AT ROW 5.12 COL 8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.14 BY .81
     FILL-IN-desafp AT ROW 5.12 COL 11 COLON-ALIGNED NO-LABEL
     INTEGRAL.PL-FLG-SEM.nroafp AT ROW 5.12 COL 34 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.29 BY .81
     INTEGRAL.PL-FLG-SEM.cargos AT ROW 5.12 COL 55 COLON-ALIGNED
          VIEW-AS COMBO-BOX SORT INNER-LINES 5
          DROP-DOWN-LIST
          SIZE 24.72 BY 1
     INTEGRAL.PL-FLG-SEM.FchInsRgp AT ROW 5.92 COL 34 COLON-ALIGNED
          LABEL "Fecha de inscrip. al reg. pensionario"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     INTEGRAL.PL-FLG-SEM.Clase AT ROW 5.92 COL 55 COLON-ALIGNED FORMAT "x(100)"
          VIEW-AS COMBO-BOX SORT INNER-LINES 5
          DROP-DOWN-LIST
          SIZE 24.72 BY 1
     INTEGRAL.PL-FLG-SEM.Proyecto AT ROW 6.73 COL 8 COLON-ALIGNED
          VIEW-AS COMBO-BOX SORT INNER-LINES 5
          DROP-DOWN-LIST
          SIZE 39.43 BY 1
     INTEGRAL.PL-FLG-SEM.Categoria AT ROW 8.12 COL 10 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Trabajador", "1":U,
"Pensionista", "2":U,
"Modalidad Formativa", "5":U
          SIZE 17 BY 2.31
     INTEGRAL.PL-FLG-SEM.fecing AT ROW 8.12 COL 33 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     INTEGRAL.PL-FLG-SEM.inivac AT ROW 8.12 COL 57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     INTEGRAL.PL-FLG-SEM.finvac AT ROW 8.12 COL 70 COLON-ALIGNED
          LABEL "Fin"
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     INTEGRAL.PL-FLG-SEM.vcontr AT ROW 8.92 COL 33 COLON-ALIGNED
          LABEL "F.Cese"
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     INTEGRAL.PL-FLG-SEM.MotivoFin AT ROW 8.92 COL 49 COLON-ALIGNED
          LABEL "Motivo"
          VIEW-AS FILL-IN 
          SIZE 2.86 BY .81
     FILL-IN-MotivoFin AT ROW 8.92 COL 52 COLON-ALIGNED NO-LABEL
     INTEGRAL.PL-FLG-SEM.ModFormat AT ROW 9.73 COL 49 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 2.86 BY .81
     FILL-IN-ModFormat AT ROW 9.73 COL 52 COLON-ALIGNED NO-LABEL
     "Categoría:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 8.88 COL 2
     RECT-14 AT ROW 7.73 COL 1
     RECT-15 AT ROW 1 COL 1
     RECT-16 AT ROW 3.12 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.PL-FLG-SEM,integral.PL-PLAN
   Allow: Basic,DB-Fields
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
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 9.81
         WIDTH              = 82.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX INTEGRAL.PL-FLG-SEM.Clase IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN INTEGRAL.PL-FLG-SEM.codper IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN INTEGRAL.PL-FLG-SEM.FchInsRgp IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-desafp IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ModFormat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-MotivoFin IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Nombre IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN INTEGRAL.PL-FLG-SEM.finvac IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN INTEGRAL.PL-FLG-SEM.MotivoFin IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN INTEGRAL.PL-FLG-SEM.nrodpt IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR COMBO-BOX INTEGRAL.PL-FLG-SEM.seccion IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN INTEGRAL.PL-FLG-SEM.vcontr IN FRAME F-Main
   EXP-LABEL                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME INTEGRAL.PL-FLG-SEM.cargos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-FLG-SEM.cargos V-table-Win
ON ENTRY OF INTEGRAL.PL-FLG-SEM.cargos IN FRAME F-Main /* Cargo */
DO:
    /* Cargos */
    ASSIGN CMB-Cargos = " ".
    FOR EACH integral.PL-CARG NO-LOCK:
        ASSIGN CMB-Cargos = CMB-Cargos + "," + integral.PL-CARG.cargos.
    END.
    ASSIGN SELF:LIST-ITEMS IN FRAME F-Main = CMB-Cargos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME INTEGRAL.PL-FLG-SEM.ccosto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-FLG-SEM.ccosto V-table-Win
ON LEAVE OF INTEGRAL.PL-FLG-SEM.ccosto IN FRAME F-Main /* C.Costo */
DO:
    IF PL-FLG-SEM.ccosto:SCREEN-VALUE = "" THEN RETURN.
    FIND cb-auxi WHERE cb-auxi.CodCia = cb-codcia
                    AND cb-auxi.CLFAUX = "CCO"
                    AND cb-auxi.CodAUX = SELF:SCREEN-VALUE
                    NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-auxi THEN
       FIND cb-auxi WHERE cb-auxi.CodCia = s-codcia
                    AND cb-auxi.CLFAUX = "CCO"
                    AND cb-auxi.CodAUX = SELF:SCREEN-VALUE
                    NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-auxi
    THEN DO:
        MESSAGE "Centro de Costo no Registrado" VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-FLG-SEM.ccosto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF INTEGRAL.PL-FLG-SEM.ccosto IN FRAME F-Main /* C.Costo */
OR F8 OF PL-FLG-SEM.ccosto DO:
   DEF VAR T-ROWID AS ROWID.
   RUN cbd/H-auxi01.w(s-codcia,"CCO", OUTPUT T-ROWID). 
   IF T-ROWID <> ?
      THEN DO:
           FIND cb-auxi WHERE ROWID(cb-auxi) = T-ROWID NO-LOCK  NO-ERROR.
           IF AVAIL cb-auxi THEN SELF:SCREEN-VALUE = cb-auxi.CodAux.
      END.
      RETURN NO-APPLY.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME INTEGRAL.PL-FLG-SEM.Clase
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-FLG-SEM.Clase V-table-Win
ON ENTRY OF INTEGRAL.PL-FLG-SEM.Clase IN FRAME F-Main /* Clase */
DO:
    /* Clases */
    ASSIGN CMB-clase = "".
    FOR EACH integral.PL-CLAS NO-LOCK:
        IF CMB-clase = "" THEN CMB-clase = integral.PL-CLAS.clase.
        ELSE CMB-clase = CMB-clase + "," + integral.PL-CLAS.clase.
    END.
    ASSIGN SELF:LIST-ITEMS IN FRAME F-Main = CMB-clase.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME INTEGRAL.PL-FLG-SEM.cnpago
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-FLG-SEM.cnpago V-table-Win
ON ENTRY OF INTEGRAL.PL-FLG-SEM.cnpago IN FRAME F-Main /* Canal Pago */
DO:
    /* Canales de Pago */
    ASSIGN CMB-Canal = " ".
    FOR EACH integral.PL-PAGO NO-LOCK:
        ASSIGN CMB-Canal = CMB-Canal + "," + integral.PL-PAGO.cnpago.
    END.
    ASSIGN SELF:LIST-ITEMS IN FRAME F-Main = CMB-Canal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME INTEGRAL.PL-FLG-SEM.codafp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-FLG-SEM.codafp V-table-Win
ON LEAVE OF INTEGRAL.PL-FLG-SEM.codafp IN FRAME F-Main /* Cód. AFP. */
DO:
    IF INPUT integral.PL-FLG-SEM.CodAfp = 0 THEN
        FILL-IN-desafp = "No afiliado a AFP".
    ELSE DO:
        FIND integral.PL-AFPS WHERE
            integral.PL-AFPS.CodAfp = INPUT integral.PL-FLG-SEM.CodAfp
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE PL-AFPS THEN DO:
            BELL.
            MESSAGE "C¢digo de AFP no registrado"
                VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO integral.PL-FLG-SEM.CodAfp.
            RETURN NO-APPLY.
        END.
        ELSE FILL-IN-desafp = PL-AFPS.desafp.
    END.
    DISPLAY FILL-IN-desafp WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-FLG-SEM.codafp V-table-Win
ON MOUSE-SELECT-DBLCLICK OF INTEGRAL.PL-FLG-SEM.codafp IN FRAME F-Main /* Cód. AFP. */
OR F8 OF integral.PL-FLG-SEM.CodAfp
DO:
    RUN pln/h-afps.r(OUTPUT reg-act).
    IF reg-act <> ? THEN DO:
        FIND integral.PL-AFPS WHERE
            ROWID(integral.PL-AFPS) = reg-act NO-LOCK NO-ERROR.
        IF AVAILABLE integral.PL-AFPS THEN
            DISPLAY
                integral.PL-AFPS.CodAfp @ integral.PL-FLG-SEM.CodAfp
                integral.PL-AFPS.DesAfp @ FILL-IN-desafp
                WITH FRAME F-Main.
        ELSE
            DISPLAY
                "No afiliado a AFP" @ FILL-IN-desafp WITH FRAME F-Main.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME INTEGRAL.PL-FLG-SEM.CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-FLG-SEM.CodDiv V-table-Win
ON LEAVE OF INTEGRAL.PL-FLG-SEM.CodDiv IN FRAME F-Main /* División */
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    FIND gn-divi  WHERE gn-divi.CodCia = S-codcia
                    AND gn-divi.coddiv = SELF:SCREEN-VALUE
                    NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-divi
    THEN DO:
        MESSAGE "C¢digo de Divisionaria no Registrado" VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-FLG-SEM.CodDiv V-table-Win
ON MOUSE-SELECT-DBLCLICK OF INTEGRAL.PL-FLG-SEM.CodDiv IN FRAME F-Main /* División */
DO:
  {CBD/H-DIVI01.I NO SELF}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME INTEGRAL.PL-FLG-SEM.codper
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-FLG-SEM.codper V-table-Win
ON LEAVE OF INTEGRAL.PL-FLG-SEM.codper IN FRAME F-Main /* Código */
DO:
    FIND PL-PERS WHERE PL-PERS.CodPer = INPUT PL-FLG-SEM.CodPer NO-LOCK NO-ERROR.
    IF NOT AVAILABLE PL-PERS THEN DO:
        BELL.
        MESSAGE "C¢digo de personal no registrado"
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
    IF PL-PERS.Codcia <> s-codcia THEN DO:
       BELL.
       MESSAGE 'C¢digo de personal no se encuentra asignado a la compa¤¡a'
            VIEW-AS ALERT-BOX.
       APPLY 'ENTRY' TO integral.PL-FLG-SEM.codper.
       RETURN NO-APPLY.
    END.
    
    FILL-IN-Nombre = PL-PERS.PatPer + " " + PL-PERS.MatPer + ", " + PL-PERS.NomPer.
    DISPLAY FILL-IN-Nombre WITH FRAME F-Main.
    cCodPer = PL-FLG-SEM.CodPer:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-FLG-SEM.codper V-table-Win
ON MOUSE-SELECT-DBLCLICK OF INTEGRAL.PL-FLG-SEM.codper IN FRAME F-Main /* Código */
OR F8 OF PL-FLG-SEM.codper DO:
    RUN PLN/H-PERS.R (OUTPUT reg-act).
    IF reg-act <> ? THEN DO:
        FIND PL-PERS WHERE ROWID(PL-PERS) = reg-act NO-LOCK NO-ERROR.
        IF AVAILABLE PL-PERS THEN DO:
            FILL-IN-Nombre = PL-PERS.PatPer + " " + PL-PERS.MatPer + ", " +
                PL-PERS.NomPer.
            DISPLAY
                PL-PERS.codper @ PL-FLG-SEM.codper
                FILL-IN-Nombre WITH FRAME {&FRAME-NAME}.
        END.
        ELSE DO:
            FILL-IN-Nombre:SCREEN-VALUE = "".
            BELL.
            MESSAGE "Registro de personal no existe" VIEW-AS ALERT-BOX ERROR.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME INTEGRAL.PL-FLG-SEM.CTS
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-FLG-SEM.CTS V-table-Win
ON ENTRY OF INTEGRAL.PL-FLG-SEM.CTS IN FRAME F-Main /* CTS */
DO:
    /* Grupos */
    ASSIGN CMB-CTS = " ".
    FOR EACH integral.PL-CTS NO-LOCK:
        ASSIGN CMB-CTS = CMB-CTS + "," + integral.PL-CTS.CTS.
    END.
    ASSIGN SELF:LIST-ITEMS IN FRAME F-Main = CMB-CTS. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME INTEGRAL.PL-FLG-SEM.ModFormat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-FLG-SEM.ModFormat V-table-Win
ON MOUSE-SELECT-DBLCLICK OF INTEGRAL.PL-FLG-SEM.ModFormat IN FRAME F-Main /* Modalidad Formativa */
OR F8 OF PL-FLG-SEM.ModFormat DO:

    ASSIGN
        input-var-1 = "18"
        input-var-2 = ""
        input-var-3 = ""
        output-var-1 = ?
        OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").
    DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
        RUN LKUP/C-PLTabla.r("Modalidad Formativa").
        IF OUTPUT-VAR-1 <> ? THEN DO:
            FIND pl-tabl WHERE ROWID(pl-tabl) = OUTPUT-VAR-1 NO-LOCK NO-ERROR.
            DISPLAY
                pl-tabl.Codigo @ PL-FLG-SEM.ModFormat
                pl-tabl.Nombre @ FILL-IN-ModFormat
                WITH FRAME {&FRAME-NAME}.
        END.
    END.
    OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME INTEGRAL.PL-FLG-SEM.MotivoFin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-FLG-SEM.MotivoFin V-table-Win
ON MOUSE-SELECT-DBLCLICK OF INTEGRAL.PL-FLG-SEM.MotivoFin IN FRAME F-Main /* Motivo */
OR F8 OF PL-FLG-SEM.MotivoFin DO:

    ASSIGN
        input-var-1 = "17"
        input-var-2 = ""
        input-var-3 = ""
        output-var-1 = ?
        OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").
    DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
        RUN LKUP/C-PLTabla.r("Motivo Fin Periodo").
        IF OUTPUT-VAR-1 <> ? THEN DO:
            FIND pl-tabl WHERE ROWID(pl-tabl) = OUTPUT-VAR-1 NO-LOCK NO-ERROR.
            DISPLAY
                pl-tabl.Codigo @ PL-FLG-SEM.MotivoFin
                pl-tabl.Nombre @ FILL-IN-MotivoFin
                WITH FRAME {&FRAME-NAME}.
        END.
    END.
    OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME INTEGRAL.PL-FLG-SEM.Proyecto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-FLG-SEM.Proyecto V-table-Win
ON ENTRY OF INTEGRAL.PL-FLG-SEM.Proyecto IN FRAME F-Main /* Proyecto */
DO:
    /* Proyectos */
    ASSIGN CMB-Proyecto = " ".
    FOR EACH integral.PL-PROY NO-LOCK:
        ASSIGN CMB-Proyecto = CMB-Proyecto + "," + integral.PL-PROY.Proyecto.
    END.
    ASSIGN SELF:LIST-ITEMS IN FRAME F-Main = CMB-Proyecto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME INTEGRAL.PL-FLG-SEM.seccion
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-FLG-SEM.seccion V-table-Win
ON ENTRY OF INTEGRAL.PL-FLG-SEM.seccion IN FRAME F-Main /* Sección */
DO:
    /* Secciones */
    ASSIGN CMB-Seccion = "".
    FOR EACH integral.PL-SECC NO-LOCK:
        IF CMB-Seccion = "" THEN CMB-Seccion = integral.PL-SECC.seccion.
        ELSE CMB-Seccion = CMB-Seccion + "," + integral.PL-SECC.seccion.
    END.
    ASSIGN SELF:LIST-ITEMS IN FRAME F-Main = CMB-Seccion.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
  RUN INICIA_LISTAS.
  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "integral.PL-FLG-SEM"}
  {src/adm/template/row-list.i "integral.PL-PLAN"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "integral.PL-FLG-SEM"}
  {src/adm/template/row-find.i "integral.PL-PLAN"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE INICIA_LISTAS V-table-Win 
PROCEDURE INICIA_LISTAS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* Cargos */
    ASSIGN CMB-Cargos = " ".
    FOR EACH integral.PL-CARG NO-LOCK:
        ASSIGN CMB-Cargos = CMB-Cargos + "," + integral.PL-CARG.cargos.
    END.
    ASSIGN integral.PL-FLG-SEM.cargos:LIST-ITEMS IN FRAME F-Main = CMB-Cargos.

    /* Clases */
    ASSIGN CMB-clase = " ".
    FOR EACH integral.PL-CLAS NO-LOCK:
        ASSIGN CMB-clase = CMB-clase + "," + integral.PL-CLAS.clase.
    END.
    ASSIGN integral.PL-FLG-SEM.clase:LIST-ITEMS IN FRAME F-Main = CMB-clase.

    /* Canales de Pago */
    ASSIGN CMB-Canal = " ".
    FOR EACH integral.PL-PAGO NO-LOCK:
        ASSIGN CMB-Canal = CMB-Canal + "," + integral.PL-PAGO.cnpago.
    END.
    ASSIGN integral.PL-FLG-SEM.cnpago:LIST-ITEMS IN FRAME F-Main = CMB-Canal.

    /* CTS */
    ASSIGN CMB-CTS = " ".
    FOR EACH integral.PL-CTS NO-LOCK:
        ASSIGN CMB-CTS = CMB-CTS + "," + integral.PL-CTS.CTS.
    END.
    ASSIGN integral.PL-FLG-SEM.CTS:LIST-ITEMS IN FRAME F-Main = CMB-CTS.    
    
    /* Proyectos */
    ASSIGN CMB-Proyecto = " ".
    FOR EACH integral.PL-PROY NO-LOCK:
        ASSIGN CMB-Proyecto = CMB-Proyecto + "," + integral.PL-PROY.Proyecto.
    END.
    ASSIGN integral.PL-FLG-SEM.Proyecto:LIST-ITEMS IN FRAME F-Main = CMB-Proyecto.    

    /* Secciones */
    ASSIGN CMB-Seccion = " ".
    FOR EACH integral.PL-SECC NO-LOCK:
        ASSIGN CMB-Seccion = CMB-Seccion + "," + integral.PL-SECC.seccion.
    END.
    ASSIGN integral.PL-FLG-SEM.seccion:LIST-ITEMS IN FRAME F-Main = CMB-Seccion.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
    ASSIGN integral.PL-FLG-SEM.codper:SENSITIVE IN FRAME F-Main = TRUE.
    APPLY "ENTRY" TO PL-FLG-SEM.CodPer.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  
  lExiste = TRUE.
  FIND pl-pers WHERE pl-pers.codcia = s-codcia
      AND pl-pers.CodPer = cCodPer NO-LOCK NO-ERROR.
  IF AVAILABLE pl-pers THEN DO:
      FIND pl-negra WHERE pl-negra.DocIdentidad = PL-PERS.NroDocId NO-LOCK NO-ERROR.
      IF NOT AVAILABLE pl-negra THEN DO:
          FIND pl-negra WHERE pl-negra.patper = pl-pers.patper 
              AND pl-negra.matper = pl-pers.matper NO-LOCK NO-ERROR.
          IF AVAILABLE pl-negra THEN lExiste = FALSE.
      END.
      ELSE lExiste = FALSE.
      IF NOT lExiste THEN DO:
          MESSAGE 'Esta persona se encuentra registrada en la LISTA NEGRA' SKIP
              'Grabación rechazada'
              VIEW-AS ALERT-BOX WARNING.
          UNDO, RETURN 'ADM-ERROR'.
      END.
  END.  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

    RUN get-attribute ('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'YES' THEN DO:
        ASSIGN
            integral.PL-FLG-SEM.CodCia  = s-codcia
            integral.PL-FLG-SEM.Periodo = s-periodo
            integral.PL-FLG-SEM.nrosem  = s-nrosem
            integral.PL-FLG-SEM.codpln  = integral.PL-PLAN.CodPln.
        ASSIGN integral.PL-FLG-SEM.codper:SENSITIVE IN FRAME F-Main = FALSE.
        FIND PL-PERS WHERE PL-PERS.CodPer = PL-FLG-SEM.CodPer NO-ERROR.
        IF AVAILABLE PL-PERS THEN ASSIGN integral.PL-PERS.TpoPer = TRUE.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record V-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
    ASSIGN integral.PL-FLG-SEM.codper:SENSITIVE IN FRAME F-Main = FALSE.        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

    IF CAN-FIND(FIRST PL-MOV-SEM WHERE
        PL-MOV-SEM.CodCia = PL-FLG-SEM.CodCia AND
        PL-MOV-SEM.Periodo = PL-FLG-SEM.Periodo AND
        PL-MOV-SEM.NroSem = PL-FLG-SEM.NroSem AND
        PL-MOV-SEM.CodPln = PL-FLG-SEM.CodPln AND
        PL-MOV-SEM.CodCal >= 0 AND
        PL-MOV-SEM.codper = PL-FLG-SEM.CodPer) THEN DO:
        MESSAGE
            "Personal tiene movimiento. No se puede aliminar"
            VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.

    /* Borra calculo manual */
    FOR EACH PL-MOV-SEM WHERE
        PL-MOV-SEM.CodCia = PL-FLG-SEM.CodCia AND
        PL-MOV-SEM.Periodo = PL-FLG-SEM.Periodo AND
        PL-MOV-SEM.NroSem = PL-FLG-SEM.NroSem AND
        PL-MOV-SEM.CodPln = PL-FLG-SEM.CodPln AND
        PL-MOV-SEM.CodCal = 0 AND
        PL-MOV-SEM.codper = PL-FLG-SEM.CodPer:
        DELETE PL-MOV-SEM.
    END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

    IF AVAILABLE integral.PL-FLG-SEM THEN DO:
        IF integral.PL-FLG-SEM.Cargos = "" THEN
            integral.PL-FLG-SEM.Cargos:SCREEN-VALUE IN FRAME F-MAIN = " ".
        IF integral.PL-FLG-SEM.Clase = "" THEN
            integral.PL-FLG-SEM.Clase:SCREEN-VALUE IN FRAME F-MAIN = " ".
        IF integral.PL-FLG-SEM.cnpago = "" THEN
            integral.PL-FLG-SEM.cnpago:SCREEN-VALUE IN FRAME F-MAIN = " ".
        IF integral.PL-FLG-SEM.CTS = "" THEN
            integral.PL-FLG-SEM.CTS:SCREEN-VALUE IN FRAME F-MAIN = " ".
        IF integral.PL-FLG-SEM.Proyecto = "" THEN
            integral.PL-FLG-SEM.Proyecto:SCREEN-VALUE IN FRAME F-MAIN = " ".
        IF integral.PL-FLG-SEM.Seccion = "" THEN
            integral.PL-FLG-SEM.Seccion:SCREEN-VALUE IN FRAME F-MAIN = " " .

     FIND PL-AFPS WHERE PL-AFPS.codafp = PL-FLG-SEM.codafp NO-LOCK NO-ERROR.
     IF AVAILABLE PL-AFPS THEN FILL-IN-desafp = PL-AFPS.DesAfp.
     ELSE FILL-IN-desafp = "No afiliado a AFP".

    END.
  
  /* Dispatch standard ADM method.                             */

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

    ASSIGN FILL-IN-Nombre = "".
    FIND PL-PERS WHERE PL-PERS.CodPer = PL-FLG-SEM.CodPer NO-LOCK NO-ERROR.
    IF AVAILABLE PL-PERS THEN
        ASSIGN
            FILL-IN-Nombre = PL-PERS.PatPer + " " + PL-PERS.MatPer + ", " +
            PL-PERS.NomPer.

    DISPLAY
        FILL-IN-Nombre
        FILL-IN-desafp
        WITH FRAME F-Main.

    DO WITH FRAME {&FRAME-NAME}:
        /* Motivo Fin De Periodo */
        FIND pl-tabla WHERE
            pl-tabla.codcia = 0 AND
            pl-tabla.tabla = '17' AND
            pl-tabla.codigo = PL-FLG-SEM.MotivoFin NO-LOCK NO-ERROR.
        IF AVAILABLE pl-tabla THEN FILL-IN-MotivoFin:SCREEN-VALUE = pl-tabla.nombre.
        ELSE FILL-IN-MotivoFin:SCREEN-VALUE = ' '.
        /* Modalidad Formativa */
        FIND pl-tabla WHERE
            pl-tabla.codcia = 0 AND
            pl-tabla.tabla = '18' AND
            pl-tabla.codigo = PL-FLG-SEM.ModFormat NO-LOCK NO-ERROR.
        IF AVAILABLE pl-tabla THEN FILL-IN-ModFormat:SCREEN-VALUE = pl-tabla.nombre.
        ELSE FILL-IN-ModFormat:SCREEN-VALUE = ' '.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
    ASSIGN integral.PL-FLG-SEM.codper:SENSITIVE IN FRAME F-Main = FALSE.        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida V-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN get-attribute ('ADM-NEW-RECORD').
IF RETURN-VALUE = 'YES' THEN DO:
    FIND PL-PERS WHERE PL-PERS.CodPer =
    PL-FLG-SEM.CodPer:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-LOCK NO-ERROR.
    IF NOT AVAILABLE PL-PERS THEN DO:
        BELL.
        MESSAGE "Código de personal no registrado"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO PL-FLG-SEM.codper.
        RETURN "ADM-ERROR".
    END.
    /* Validacion en la lista negra */
    IF PL-PERS.TpoDocId = '01' THEN DO:        /* DNI */
        FIND pl-negra WHERE pl-negra.DocIdentidad = PL-PERS.NroDocId NO-LOCK NO-ERROR.
        IF AVAILABLE pl-negra THEN DO:
            MESSAGE 'Esta persona se encuentra registrada en la LISTA NEGRA' SKIP
                'Grabación rechazada'
                VIEW-AS ALERT-BOX WARNING.
            RETURN 'ADM-ERROR'.
        END.
    END.
END.
IF PL-FLG-SEM.ccosto:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "" THEN DO:
    FIND cb-auxi WHERE cb-auxi.CodCia = cb-codcia
                    AND cb-auxi.CLFAUX = "CCO"
                    AND cb-auxi.CodAUX = PL-FLG-SEM.ccosto:SCREEN-VALUE
                    NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-auxi THEN
       FIND cb-auxi WHERE cb-auxi.CodCia = s-codcia
                    AND cb-auxi.CLFAUX = "CCO"
                    AND cb-auxi.CodAUX = PL-FLG-SEM.ccosto:SCREEN-VALUE
                    NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-auxi THEN DO:
        BELL.
        MESSAGE "Centro de Costo no registrado" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO PL-FLG-SEM.ccosto.
        RETURN "ADM-ERROR".
    END.
END.

    IF LOOKUP(PL-FLG-SEM.Categoria:SCREEN-VALUE,"1,2") > 0 THEN DO:
        IF PL-FLG-SEM.vcontr:SCREEN-VALUE <> "" AND
            NOT CAN-FIND(FIRST pl-tabla WHERE
            pl-tabla.codcia = 0 AND
            pl-tabla.tabla = '17' AND
            pl-tabla.codigo = PL-FLG-SEM.MotivoFin:SCREEN-VALUE) THEN DO:
            MESSAGE
                "Motivo no es Válido"
                VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO PL-FLG-SEM.MotivoFin.
            RETURN "ADM-ERROR".
        END.
        IF PL-FLG-SEM.vcontr:SCREEN-VALUE = "" THEN DO:
            FILL-IN-MotivoFin:SCREEN-VALUE = "".
            PL-FLG-SEM.MotivoFin:SCREEN-VALUE = "".
        END.
        FILL-IN-ModFormat:SCREEN-VALUE = "".
        PL-FLG-SEM.ModFormat:SCREEN-VALUE = "".
    END.
    ELSE DO:
        IF NOT CAN-FIND(FIRST pl-tabla WHERE
            pl-tabla.codcia = 0 AND
            pl-tabla.tabla = '18' AND
            pl-tabla.codigo = PL-FLG-SEM.ModFormat:SCREEN-VALUE) THEN DO:
            MESSAGE
                "Modalidad Formativa no es Válida"
                VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO PL-FLG-SEM.ModFormat.
            RETURN "ADM-ERROR".
        END.
        FILL-IN-MotivoFin:SCREEN-VALUE = "".
        PL-FLG-SEM.MotivoFin:SCREEN-VALUE = "".
    END.

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

