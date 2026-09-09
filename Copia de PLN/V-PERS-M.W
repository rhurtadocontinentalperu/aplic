&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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

{bin/s-global.i}
{pln/s-global.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES integral.PL-FLG-MES integral.PL-PLAN
&Scoped-define FIRST-EXTERNAL-TABLE integral.PL-FLG-MES


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR integral.PL-FLG-MES, integral.PL-PLAN.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS INTEGRAL.PL-FLG-MES.codper ~
INTEGRAL.PL-FLG-MES.SitAct INTEGRAL.PL-FLG-MES.cnpago ~
INTEGRAL.PL-FLG-MES.CTS INTEGRAL.PL-FLG-MES.codafp ~
INTEGRAL.PL-FLG-MES.Proyecto INTEGRAL.PL-FLG-MES.fecing ~
INTEGRAL.PL-FLG-MES.vcontr INTEGRAL.PL-FLG-MES.nrodpt ~
INTEGRAL.PL-FLG-MES.NroDpt-CTS INTEGRAL.PL-FLG-MES.nroafp ~
INTEGRAL.PL-FLG-MES.FchInsRgp INTEGRAL.PL-FLG-MES.Conyugue ~
INTEGRAL.PL-FLG-MES.ccosto INTEGRAL.PL-FLG-MES.seccion ~
INTEGRAL.PL-FLG-MES.cargos INTEGRAL.PL-FLG-MES.Clase ~
INTEGRAL.PL-FLG-MES.inivac INTEGRAL.PL-FLG-MES.finvac ~
INTEGRAL.PL-FLG-MES.Nro-de-Hijos INTEGRAL.PL-FLG-MES.CodDiv 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}codper ~{&FP2}codper ~{&FP3}~
 ~{&FP1}codafp ~{&FP2}codafp ~{&FP3}~
 ~{&FP1}fecing ~{&FP2}fecing ~{&FP3}~
 ~{&FP1}vcontr ~{&FP2}vcontr ~{&FP3}~
 ~{&FP1}nrodpt ~{&FP2}nrodpt ~{&FP3}~
 ~{&FP1}NroDpt-CTS ~{&FP2}NroDpt-CTS ~{&FP3}~
 ~{&FP1}nroafp ~{&FP2}nroafp ~{&FP3}~
 ~{&FP1}FchInsRgp ~{&FP2}FchInsRgp ~{&FP3}~
 ~{&FP1}Conyugue ~{&FP2}Conyugue ~{&FP3}~
 ~{&FP1}ccosto ~{&FP2}ccosto ~{&FP3}~
 ~{&FP1}inivac ~{&FP2}inivac ~{&FP3}~
 ~{&FP1}finvac ~{&FP2}finvac ~{&FP3}~
 ~{&FP1}Nro-de-Hijos ~{&FP2}Nro-de-Hijos ~{&FP3}~
 ~{&FP1}CodDiv ~{&FP2}CodDiv ~{&FP3}
&Scoped-define ENABLED-TABLES INTEGRAL.PL-FLG-MES
&Scoped-define FIRST-ENABLED-TABLE INTEGRAL.PL-FLG-MES
&Scoped-Define ENABLED-OBJECTS RECT-15 RECT-16 RECT-14 
&Scoped-Define DISPLAYED-FIELDS INTEGRAL.PL-FLG-MES.codper ~
INTEGRAL.PL-FLG-MES.SitAct INTEGRAL.PL-FLG-MES.cnpago ~
INTEGRAL.PL-FLG-MES.CTS INTEGRAL.PL-FLG-MES.codafp ~
INTEGRAL.PL-FLG-MES.Proyecto INTEGRAL.PL-FLG-MES.fecing ~
INTEGRAL.PL-FLG-MES.vcontr INTEGRAL.PL-FLG-MES.nrodpt ~
INTEGRAL.PL-FLG-MES.NroDpt-CTS INTEGRAL.PL-FLG-MES.nroafp ~
INTEGRAL.PL-FLG-MES.FchInsRgp INTEGRAL.PL-FLG-MES.Conyugue ~
INTEGRAL.PL-FLG-MES.ccosto INTEGRAL.PL-FLG-MES.seccion ~
INTEGRAL.PL-FLG-MES.cargos INTEGRAL.PL-FLG-MES.Clase ~
INTEGRAL.PL-FLG-MES.inivac INTEGRAL.PL-FLG-MES.finvac ~
INTEGRAL.PL-FLG-MES.Nro-de-Hijos INTEGRAL.PL-FLG-MES.CodDiv 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-desafp FILL-IN-Nombre 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE FILL-IN-desafp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Nombre AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 45.72 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 82 BY .19.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 82 BY 9.42.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 82 BY .12.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     INTEGRAL.PL-FLG-MES.codper AT ROW 1.23 COL 8.43 COLON-ALIGNED
          LABEL "C¢digo"
          VIEW-AS FILL-IN 
          SIZE 7.57 BY .81
          BGCOLOR 15 FGCOLOR 0 
     INTEGRAL.PL-FLG-MES.SitAct AT ROW 2.15 COL 8.43 COLON-ALIGNED
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEMS "Activo","Vacaciones","Descanso m‚dico","Descanso pre-natal","Descanso post-natal","Licencia con Goce","Licencia sin Goce","Inactivo" 
          SIZE 20.72 BY 1
     INTEGRAL.PL-FLG-MES.cnpago AT ROW 3.35 COL 8.43 COLON-ALIGNED
          VIEW-AS COMBO-BOX SORT INNER-LINES 5
          LIST-ITEMS "","" 
          SIZE 21.29 BY 1
     INTEGRAL.PL-FLG-MES.CTS AT ROW 4.27 COL 8.43 COLON-ALIGNED
          VIEW-AS COMBO-BOX SORT INNER-LINES 5
          LIST-ITEMS "","" 
          SIZE 21.29 BY 1
     INTEGRAL.PL-FLG-MES.codafp AT ROW 5.23 COL 8.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.14 BY .81
     INTEGRAL.PL-FLG-MES.Proyecto AT ROW 7.15 COL 8.43 COLON-ALIGNED
          VIEW-AS COMBO-BOX SORT INNER-LINES 5
          LIST-ITEMS "","" 
          SIZE 39.43 BY 1
     FILL-IN-desafp AT ROW 5.23 COL 11.57 COLON-ALIGNED NO-LABEL
     FILL-IN-Nombre AT ROW 1.23 COL 16.57 COLON-ALIGNED NO-LABEL
     INTEGRAL.PL-FLG-MES.fecing AT ROW 8.5 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     INTEGRAL.PL-FLG-MES.vcontr AT ROW 9.38 COL 16 COLON-ALIGNED
          LABEL "F.Cese"
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     INTEGRAL.PL-FLG-MES.nrodpt AT ROW 3.35 COL 33.72 COLON-ALIGNED
          LABEL "Nro."
          VIEW-AS FILL-IN 
          SIZE 14.29 BY .81
     INTEGRAL.PL-FLG-MES.NroDpt-CTS AT ROW 4.27 COL 33.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.29 BY .81
     INTEGRAL.PL-FLG-MES.nroafp AT ROW 5.23 COL 33.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.29 BY .81
     INTEGRAL.PL-FLG-MES.FchInsRgp AT ROW 6.19 COL 33.72 COLON-ALIGNED
          LABEL "Fecha de inscrip. al reg. pensionario"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     INTEGRAL.PL-FLG-MES.Conyugue AT ROW 2.15 COL 54.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .73
     INTEGRAL.PL-FLG-MES.ccosto AT ROW 3.35 COL 54.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.57 BY .81
     INTEGRAL.PL-FLG-MES.seccion AT ROW 4.27 COL 54.72 COLON-ALIGNED
          VIEW-AS COMBO-BOX SORT INNER-LINES 5
          LIST-ITEMS "","" 
          SIZE 24.72 BY 1
     INTEGRAL.PL-FLG-MES.cargos AT ROW 5.23 COL 54.72 COLON-ALIGNED
          VIEW-AS COMBO-BOX SORT INNER-LINES 5
          LIST-ITEMS "","" 
          SIZE 24.57 BY 1
     INTEGRAL.PL-FLG-MES.Clase AT ROW 6.15 COL 54.72 COLON-ALIGNED FORMAT "x(80)"
          VIEW-AS COMBO-BOX SORT INNER-LINES 5
          LIST-ITEMS "","" 
          SIZE 24.43 BY 1
     INTEGRAL.PL-FLG-MES.inivac AT ROW 8.5 COL 54.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     INTEGRAL.PL-FLG-MES.finvac AT ROW 9.38 COL 54.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     INTEGRAL.PL-FLG-MES.Nro-de-Hijos AT ROW 2.15 COL 74 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.57 BY .73
     INTEGRAL.PL-FLG-MES.CodDiv AT ROW 3.35 COL 74 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
.
/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     RECT-15 AT ROW 1 COL 1
     RECT-16 AT ROW 3.12 COL 1
     RECT-14 AT ROW 8.12 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.PL-FLG-MES,integral.PL-PLAN
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
         HEIGHT             = 9.92
         WIDTH              = 82.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX INTEGRAL.PL-FLG-MES.Clase IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN INTEGRAL.PL-FLG-MES.codper IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN INTEGRAL.PL-FLG-MES.FchInsRgp IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-desafp IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Nombre IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN INTEGRAL.PL-FLG-MES.nrodpt IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN INTEGRAL.PL-FLG-MES.vcontr IN FRAME F-Main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME INTEGRAL.PL-FLG-MES.cargos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-FLG-MES.cargos V-table-Win
ON ENTRY OF INTEGRAL.PL-FLG-MES.cargos IN FRAME F-Main /* Cargo */
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


&Scoped-define SELF-NAME INTEGRAL.PL-FLG-MES.ccosto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-FLG-MES.ccosto V-table-Win
ON LEAVE OF INTEGRAL.PL-FLG-MES.ccosto IN FRAME F-Main /* C.Costo */
DO:
    IF PL-FLG-MES.ccosto:SCREEN-VALUE = "" THEN RETURN.
    FIND cb-auxi WHERE cb-auxi.CodCia = 0
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-FLG-MES.ccosto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF INTEGRAL.PL-FLG-MES.ccosto IN FRAME F-Main /* C.Costo */
OR F8 OF PL-FLG-MES.ccosto DO:
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


&Scoped-define SELF-NAME INTEGRAL.PL-FLG-MES.Clase
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-FLG-MES.Clase V-table-Win
ON ENTRY OF INTEGRAL.PL-FLG-MES.Clase IN FRAME F-Main /* Clase */
DO:
    /* Clases */
    ASSIGN CMB-clase = " ".
    FOR EACH integral.PL-CLAS NO-LOCK:
        ASSIGN CMB-clase = CMB-clase + "," + integral.PL-CLAS.clase.
    END.
    ASSIGN SELF:LIST-ITEMS IN FRAME F-Main = CMB-clase.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME INTEGRAL.PL-FLG-MES.cnpago
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-FLG-MES.cnpago V-table-Win
ON ENTRY OF INTEGRAL.PL-FLG-MES.cnpago IN FRAME F-Main /* Canal Pago */
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


&Scoped-define SELF-NAME INTEGRAL.PL-FLG-MES.codafp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-FLG-MES.codafp V-table-Win
ON LEAVE OF INTEGRAL.PL-FLG-MES.codafp IN FRAME F-Main /* Cód. AFP. */
DO:
    IF INPUT integral.PL-FLG-MES.CodAfp = 0 THEN
        FILL-IN-desafp = "No afiliado a AFP".
    ELSE DO:
        FIND integral.PL-AFPS WHERE
            integral.PL-AFPS.CodAfp = INPUT integral.PL-FLG-MES.CodAfp
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE PL-AFPS THEN DO:
            BELL.
            MESSAGE "C¢digo de AFP no registrado"
                VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO integral.PL-FLG-MES.CodAfp.
            RETURN NO-APPLY.
        END.
        ELSE FILL-IN-desafp = PL-AFPS.desafp.
    END.
    DISPLAY FILL-IN-desafp WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-FLG-MES.codafp V-table-Win
ON MOUSE-SELECT-DBLCLICK OF INTEGRAL.PL-FLG-MES.codafp IN FRAME F-Main /* Cód. AFP. */
OR F8 OF integral.PL-FLG-MES.CodAfp
DO:
    RUN pln/h-afps.r(OUTPUT reg-act).
    IF reg-act <> ? THEN DO:
        FIND integral.PL-AFPS WHERE
            ROWID(integral.PL-AFPS) = reg-act NO-LOCK NO-ERROR.
        IF AVAILABLE integral.PL-AFPS THEN
            DISPLAY
                integral.PL-AFPS.CodAfp @ integral.PL-FLG-MES.CodAfp
                integral.PL-AFPS.DesAfp @ FILL-IN-desafp
                WITH FRAME F-Main.
        ELSE
            DISPLAY
                "No afiliado a AFP" @ FILL-IN-desafp WITH FRAME F-Main.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME INTEGRAL.PL-FLG-MES.CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-FLG-MES.CodDiv V-table-Win
ON LEAVE OF INTEGRAL.PL-FLG-MES.CodDiv IN FRAME F-Main /* División */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-FLG-MES.CodDiv V-table-Win
ON MOUSE-SELECT-DBLCLICK OF INTEGRAL.PL-FLG-MES.CodDiv IN FRAME F-Main /* División */
DO:
  {CBD/H-DIVI01.I NO SELF}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME INTEGRAL.PL-FLG-MES.codper
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-FLG-MES.codper V-table-Win
ON LEAVE OF INTEGRAL.PL-FLG-MES.codper IN FRAME F-Main /* C¢digo */
DO:
    FIND PL-PERS WHERE PL-PERS.CodPer = INPUT PL-FLG-MES.CodPer NO-LOCK NO-ERROR.
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
       APPLY 'ENTRY' TO integral.PL-FLG-MES.codper.
       RETURN NO-APPLY.
    END.
    
    FILL-IN-Nombre = PL-PERS.PatPer + " " + PL-PERS.MatPer + ", " + PL-PERS.NomPer.
    DISPLAY FILL-IN-Nombre WITH FRAME F-Main.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-FLG-MES.codper V-table-Win
ON MOUSE-SELECT-DBLCLICK OF INTEGRAL.PL-FLG-MES.codper IN FRAME F-Main /* C¢digo */
OR F8 OF PL-FLG-MES.codper DO:
    RUN PLN/H-PERS.R (OUTPUT reg-act).
    IF reg-act <> ? THEN DO:
        FIND PL-PERS WHERE ROWID(PL-PERS) = reg-act NO-LOCK NO-ERROR.
        IF AVAILABLE PL-PERS THEN DO:
            FILL-IN-Nombre = PL-PERS.PatPer + " " + PL-PERS.MatPer + ", " +
                PL-PERS.NomPer.
            DISPLAY
                PL-PERS.codper @ PL-FLG-MES.codper
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


&Scoped-define SELF-NAME INTEGRAL.PL-FLG-MES.CTS
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-FLG-MES.CTS V-table-Win
ON ENTRY OF INTEGRAL.PL-FLG-MES.CTS IN FRAME F-Main /* CTS */
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


&Scoped-define SELF-NAME INTEGRAL.PL-FLG-MES.Proyecto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-FLG-MES.Proyecto V-table-Win
ON ENTRY OF INTEGRAL.PL-FLG-MES.Proyecto IN FRAME F-Main /* Proyecto */
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


&Scoped-define SELF-NAME INTEGRAL.PL-FLG-MES.seccion
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-FLG-MES.seccion V-table-Win
ON ENTRY OF INTEGRAL.PL-FLG-MES.seccion IN FRAME F-Main /* Sección */
DO:
    /* Secciones */
    ASSIGN CMB-Seccion = " ".
    FOR EACH integral.PL-SECC NO-LOCK:
        ASSIGN CMB-Seccion = CMB-Seccion + "," + integral.PL-SECC.seccion.
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
  {src/adm/template/row-list.i "integral.PL-FLG-MES"}
  {src/adm/template/row-list.i "integral.PL-PLAN"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "integral.PL-FLG-MES"}
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
    ASSIGN integral.PL-FLG-MES.cargos:LIST-ITEMS IN FRAME F-Main = CMB-Cargos.

    /* Clases */
    ASSIGN CMB-clase = " ".
    FOR EACH integral.PL-CLAS NO-LOCK:
        ASSIGN CMB-clase = CMB-clase + "," + integral.PL-CLAS.clase.
    END.
    ASSIGN integral.PL-FLG-MES.clase:LIST-ITEMS IN FRAME F-Main = CMB-clase.

    /* Canales de Pago */
    ASSIGN CMB-Canal = " ".
    FOR EACH integral.PL-PAGO NO-LOCK:
        ASSIGN CMB-Canal = CMB-Canal + "," + integral.PL-PAGO.cnpago.
    END.
    ASSIGN integral.PL-FLG-MES.cnpago:LIST-ITEMS IN FRAME F-Main = CMB-Canal.

    /* CTS */
    ASSIGN CMB-CTS = " ".
    FOR EACH integral.PL-CTS NO-LOCK:
        ASSIGN CMB-CTS = CMB-CTS + "," + integral.PL-CTS.CTS.
    END.
    ASSIGN integral.PL-FLG-MES.CTS:LIST-ITEMS IN FRAME F-Main = CMB-CTS.    
    
    /* Proyectos */
    ASSIGN CMB-Proyecto = " ".
    FOR EACH integral.PL-PROY NO-LOCK:
        ASSIGN CMB-Proyecto = CMB-Proyecto + "," + integral.PL-PROY.Proyecto.
    END.
    ASSIGN integral.PL-FLG-MES.Proyecto:LIST-ITEMS IN FRAME F-Main = CMB-Proyecto.    

    /* Secciones */
    ASSIGN CMB-Seccion = " ".
    FOR EACH integral.PL-SECC NO-LOCK:
        ASSIGN CMB-Seccion = CMB-Seccion + "," + integral.PL-SECC.seccion.
    END.
    ASSIGN integral.PL-FLG-MES.seccion:LIST-ITEMS IN FRAME F-Main = CMB-Seccion.

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
    ASSIGN integral.PL-FLG-MES.codper:SENSITIVE IN FRAME F-Main = TRUE.
    APPLY "ENTRY" TO PL-FLG-MES.CodPer.

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

    RUN get-attribute ('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'YES' THEN DO:
        ASSIGN
            integral.PL-FLG-MES.CodCia  = s-codcia
            integral.PL-FLG-MES.Periodo = s-periodo
            integral.PL-FLG-MES.nromes  = s-nromes
            integral.PL-FLG-MES.codpln  = integral.PL-PLAN.CodPln.
        ASSIGN integral.PL-FLG-MES.codper:SENSITIVE IN FRAME F-Main = FALSE.
        FIND PL-PERS WHERE PL-PERS.CodPer = PL-FLG-MES.CodPer NO-ERROR.
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
    ASSIGN integral.PL-FLG-MES.codper:SENSITIVE IN FRAME F-Main = FALSE.        

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

    IF AVAILABLE integral.Pl-Flg-Mes THEN DO:
        IF integral.Pl-Flg-Mes.Cargos = "" THEN
            integral.Pl-Flg-Mes.Cargos:SCREEN-VALUE IN FRAME F-MAIN = " ".
        IF integral.Pl-Flg-Mes.Clase = "" THEN
            integral.Pl-Flg-Mes.Clase:SCREEN-VALUE IN FRAME F-MAIN = " ".
        IF integral.Pl-Flg-Mes.cnpago = "" THEN
            integral.Pl-Flg-Mes.cnpago:SCREEN-VALUE IN FRAME F-MAIN = " ".
        IF integral.Pl-Flg-Mes.CTS = "" THEN
            integral.Pl-Flg-Mes.CTS:SCREEN-VALUE IN FRAME F-MAIN = " ".
        IF integral.Pl-Flg-Mes.Proyecto = "" THEN
            integral.Pl-Flg-Mes.Proyecto:SCREEN-VALUE IN FRAME F-MAIN = " ".
        IF integral.Pl-Flg-Mes.Seccion = "" THEN
            integral.Pl-Flg-Mes.Seccion:SCREEN-VALUE IN FRAME F-MAIN = " " .

     FIND PL-AFPS WHERE PL-AFPS.codafp = PL-FLG-MES.codafp NO-LOCK NO-ERROR.
     IF AVAILABLE PL-AFPS THEN FILL-IN-desafp = PL-AFPS.DesAfp.
     ELSE FILL-IN-desafp = "No afiliado a AFP".

    END.
  
  /* Dispatch standard ADM method.                             */

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

    ASSIGN FILL-IN-Nombre = "".
    FIND PL-PERS WHERE PL-PERS.CodPer = PL-FLG-MES.CodPer NO-LOCK NO-ERROR.
    IF AVAILABLE PL-PERS THEN
        ASSIGN
            FILL-IN-Nombre = PL-PERS.PatPer + " " + PL-PERS.MatPer + ", " +
            PL-PERS.NomPer.

    DISPLAY
        FILL-IN-Nombre
        FILL-IN-desafp
        WITH FRAME F-Main.

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
    ASSIGN integral.PL-FLG-MES.codper:SENSITIVE IN FRAME F-Main = FALSE.        

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
  {src/adm/template/snd-list.i "integral.PL-FLG-MES"}
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
    PL-FLG-MES.CodPer:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-LOCK NO-ERROR.
    IF NOT AVAILABLE PL-PERS THEN DO:
        BELL.
        MESSAGE "C¢digo de personal no registrado"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO PL-FLG-MES.codper.
        RETURN "ADM-ERROR".
    END.
END.
IF PL-FLG-MES.ccosto:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "" THEN DO:
    FIND cb-auxi WHERE cb-auxi.CodCia = 0
                    AND cb-auxi.CLFAUX = "CCO"
                    AND cb-auxi.CodAUX = PL-FLG-MES.ccosto:SCREEN-VALUE
                    NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-auxi THEN
       FIND cb-auxi WHERE cb-auxi.CodCia = s-codcia
                    AND cb-auxi.CLFAUX = "CCO"
                    AND cb-auxi.CodAUX = PL-FLG-MES.ccosto:SCREEN-VALUE
                    NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-auxi THEN DO:
        BELL.
        MESSAGE "Centro de Costo no registrado" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO PL-FLG-MES.ccosto.
        RETURN "ADM-ERROR".
    END.
END.
RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


