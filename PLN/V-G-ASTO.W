&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
SESSION:DATE-FORMAT = "dmy".

CREATE WIDGET-POOL.

DEFINE STREAM REPORT.

DEFINE NEW GLOBAL SHARED VARIABLE cb-niveles AS CHARACTER INITIAL "2,3,5".
DEFINE {&NEW} SHARED VARIABLE s-codcia  AS INTEGER.
DEFINE {&NEW} SHARED VARIABLE s-nomcia  AS CHAR FORMAT 'X(35)'.
DEFINE {&NEW} SHARED VARIABLE s-periodo AS INTEGER.
DEFINE {&NEW} SHARED VARIABLE s-nromes  AS INTEGER.
DEFINE {&NEW} SHARED VARIABLE s-nrosem  AS INTEGER.

DEFINE VARIABLE pto        AS LOGICAL.
DEFINE VARIABLE f-genero   AS LOGICAL.
DEFINE VARIABLE x-codope   AS CHARACTER.
DEFINE VARIABLE x-nroast   AS CHARACTER.
DEFINE VARIABLE cbd-codcia AS INTEGER.

DEFINE TEMP-TABLE t-prev
    FIELD codcta AS CHARACTER
    FIELD ctacta AS CHARACTER
    FIELD coddiv AS CHARACTER
    FIELD cco    AS CHARACTER
    FIELD nomcta AS CHARACTER
    FIELD tpomov AS LOGICAL
    FIELD clfaux AS CHAR
    FIELD codaux AS CHAR
    FIELD impmn1 AS DECIMAL
    FIELD impmn2 AS DECIMAL
    INDEX IDX01 coddiv codcta
    INDEX IDX02 codcta codaux.

FIND EMPRESAS WHERE EMPRESAS.codcia = s-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE EMPRESAS THEN DO:
    BELL.
    MESSAGE "Empresa no Registrada"
    VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
IF NOT EMPRESAS.CAMPO-CODCBD THEN cbd-codcia = s-codcia.

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
&Scoped-define EXTERNAL-TABLES integral.PL-CALC integral.PL-PLAN
&Scoped-define FIRST-EXTERNAL-TABLE integral.PL-CALC


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR integral.PL-CALC, integral.PL-PLAN.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-gasto CMB-mes CMB-sem FILL-IN-fchast ~
Btn-generar 
&Scoped-Define DISPLAYED-OBJECTS CMB-mes CMB-sem FILL-IN-fchast 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn-generar 
     LABEL "&Generar  Pre-Asiento" 
     SIZE 15 BY .92.

DEFINE BUTTON Btn-imprimir 
     LABEL "&Imprimir" 
     SIZE 15 BY .92
     FONT 4.

DEFINE BUTTON Btn-transferir 
     LABEL "&Transferir Asiento" 
     SIZE 15 BY .92.

DEFINE VARIABLE CMB-mes AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 14
     LIST-ITEMS "1","2","3","4","5","6","7","8","9","10","11","12" 
     DROP-DOWN-LIST
     SIZE 6.72 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE CMB-sem AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Semana" 
     VIEW-AS COMBO-BOX INNER-LINES 20
     LIST-ITEMS "1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53" 
     DROP-DOWN-LIST
     SIZE 7.14 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-fchast AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha" 
     VIEW-AS FILL-IN 
     SIZE 10.86 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-gasto
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 52 BY 4.69.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CMB-mes AT ROW 1.5 COL 9 COLON-ALIGNED
     CMB-sem AT ROW 1.5 COL 34.14 COLON-ALIGNED
     FILL-IN-fchast AT ROW 2.69 COL 8.86 COLON-ALIGNED
     Btn-generar AT ROW 4.23 COL 2.57
     Btn-imprimir AT ROW 4.23 COL 19.29
     Btn-transferir AT ROW 4.23 COL 35.86
     RECT-gasto AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.PL-CALC,integral.PL-PLAN
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
         HEIGHT             = 4.69
         WIDTH              = 52.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON Btn-imprimir IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON Btn-transferir IN FRAME F-Main
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Btn-generar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-generar V-table-Win
ON CHOOSE OF Btn-generar IN FRAME F-Main /* Generar  Pre-Asiento */
DO:
    ASSIGN
        CMB-sem
        CMB-mes
        FILL-IN-fchast.

    IF FILL-IN-fchast = ? THEN DO:
        BELL.
        MESSAGE "Ingrese fecha del asiento"
            VIEW-AS ALERT-BOX.
        APPLY "ENTRY" TO FILL-IN-fchast.
        RETURN NO-APPLY.
    END.

    pto = SESSION:SET-WAIT-STATE("GENERAL").
    /*DETERMINACION DE LA OPERACION Y DEL NUMERO DE ASIENTO CORRESPONDIENTE */
    CASE PL-CALC.codpln:
        WHEN 1 THEN DO:
            x-codope = "068".
            x-nroast = STRING(CMB-mes,"99") +
                STRING(PL-CALC.codpln,"99") +
                STRING(PL-CALC.codcal,"99").
            RUN genera-emp( s-codcia,
                s-periodo,
                CMB-mes,
                x-codope,
                x-nroast,
                PL-CALC.codpln,
                PL-CALC.codcal ).
        END.
        WHEN 2 THEN DO:
             x-codope = "068".
             x-nroast = STRING(MONTH(FILL-IN-fchast),"99") +
                 STRING(CMB-sem,"99") +
                 STRING(PL-CALC.codcal,"99").
             /* RHC 17.05.04
             RUN genera-obr(s-codcia,
                 s-periodo,
                 CMB-sem,
                 x-codope,
                 x-nroast,
                 PL-CALC.codpln,
                 PL-CALC.codcal ).
            ***************** */
             RUN genera-obr-new(s-codcia,
                 s-periodo,
                 CMB-sem,
                 x-codope,
                 x-nroast,
                 PL-CALC.codpln,
                 PL-CALC.codcal ).
         END.
        WHEN 3 THEN DO:
            x-codope = "067".
            x-nroast = STRING(CMB-mes,"99") +
                STRING(PL-CALC.codpln,"99") +
                STRING(PL-CALC.codcal,"99").
            RUN genera-4ta( s-codcia,
                s-periodo,
                CMB-mes,
                x-codope,
                x-nroast,
                PL-CALC.codpln,
                PL-CALC.codcal ).
        END.

        OTHERWISE x-codope = "ERR".
    END.
    pto = SESSION:SET-WAIT-STATE("").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-imprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-imprimir V-table-Win
ON CHOOSE OF Btn-imprimir IN FRAME F-Main /* Imprimir */
DO:
    RUN IMPRIMIR-1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-transferir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-transferir V-table-Win
ON CHOOSE OF Btn-transferir IN FRAME F-Main /* Transferir Asiento */
DO:
    ASSIGN FRAME {&FRAME-NAME} FILL-IN-fchast.
    pto = SESSION:SET-WAIT-STATE("GENERAL").
    RUN transferir-asto(
        s-codcia,
        s-periodo,
        CMB-mes,
        x-codope,
        x-nroast,
        FILL-IN-fchast ).
    pto = SESSION:SET-WAIT-STATE("").
    BELL.
    MESSAGE "Proceso completo" VIEW-AS ALERT-BOX INFORMA.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CMB-mes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CMB-mes V-table-Win
ON LEAVE OF CMB-mes IN FRAME F-Main /* Mes */
DO:
    DO WITH FRAME {&FRAME-NAME}:
        CASE INPUT CMB-mes:
            WHEN 1 OR
                WHEN 3 OR
                WHEN 5 OR
                WHEN 7 OR
                WHEN 8 OR
                WHEN 10 OR
                WHEN 12 THEN
                DISPLAY DATE(INPUT CMB-mes,31,s-periodo) @ FILL-IN-fchast.
            WHEN 4 OR
                WHEN 6 OR
                WHEN 7 OR
                WHEN 9 THEN
                DISPLAY DATE(INPUT CMB-mes,30,s-periodo) @ FILL-IN-fchast.
            WHEN 2 THEN
                DISPLAY DATE(3,1,s-periodo) - 1 @ FILL-IN-fchast.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CMB-mes V-table-Win
ON VALUE-CHANGED OF CMB-mes IN FRAME F-Main /* Mes */
DO:
    DO WITH FRAME {&FRAME-NAME}:
        CASE INPUT CMB-mes:
            WHEN 1 OR
                WHEN 3 OR
                WHEN 5 OR
                WHEN 7 OR
                WHEN 8 OR
                WHEN 10 OR
                WHEN 12 THEN
                DISPLAY DATE(INPUT CMB-mes,31,s-periodo) @ FILL-IN-fchast.
            WHEN 4 OR
                WHEN 6 OR
                WHEN 7 OR
                WHEN 9 THEN
                DISPLAY DATE(INPUT CMB-mes,30,s-periodo) @ FILL-IN-fchast.
            WHEN 2 THEN
                DISPLAY DATE(3,1,s-periodo) - 1 @ FILL-IN-fchast.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
  DEFINE VAR X-fecha AS DATE NO-UNDO.
  IF s-nromes = 12 THEN 
      x-fecha = DATE(01,01, s-periodo + 1) - 1.
  ELSE
      x-fecha = DATE(s-nromes + 1,01, s-periodo) - 1.
  ASSIGN
    CMB-mes    = s-nromes
    CMB-sem    = s-nrosem
    FILL-IN-fchast = x-fecha.
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
  {src/adm/template/row-list.i "integral.PL-CALC"}
  {src/adm/template/row-list.i "integral.PL-PLAN"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "integral.PL-CALC"}
  {src/adm/template/row-find.i "integral.PL-PLAN"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE anula-asto V-table-Win 
PROCEDURE anula-asto :
DEFINE INPUT PARAMETER p-codcia  AS INTEGER.
DEFINE INPUT PARAMETER p-periodo AS INTEGER.
DEFINE INPUT PARAMETER p-mes     AS INTEGER.
DEFINE INPUT PARAMETER p-codope  AS CHARACTER.
DEFINE INPUT PARAMETER p-nroast  AS CHARACTER.

DEFINE BUFFER C-DMOV FOR CB-DMOV.

FOR EACH CB-DMOV WHERE
    CB-DMOV.codcia  = p-codcia AND
    CB-DMOV.periodo = p-periodo AND
    CB-DMOV.nromes  = p-mes AND
    CB-DMOV.codope  = p-codope AND
    CB-DMOV.nroast  = p-nroast:
    FOR EACH C-DMOV WHERE C-DMOV.RELACION = RECID(CB-DMOV) :
        RUN cbd/cb-acmd.p(RECID(C-DMOV),NO,YES).
        DELETE C-DMOV.
    END.
    RUN cbd/cb-acmd.p(RECID(CB-DMOV),NO,YES).
    DELETE CB-DMOV.
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE genera-4ta V-table-Win 
PROCEDURE genera-4ta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-codcia  AS INTEGER.
DEFINE INPUT PARAMETER p-periodo AS INTEGER.
DEFINE INPUT PARAMETER p-mes     AS INTEGER.
DEFINE INPUT PARAMETER p-codope  AS CHARACTER.
DEFINE INPUT PARAMETER p-nroast  AS CHARACTER.
DEFINE INPUT PARAMETER p-codpln  AS INTEGER.
DEFINE INPUT PARAMETER p-codcal  AS INTEGER.

DEFINE VARIABLE t-tpomov AS LOGICAL.
DEFINE VARIABLE a-tpomov AS LOGICAL.
DEFINE VARIABLE x-ctrcta AS CHARACTER.
DEFINE VARIABLE m-clfaux AS CHARACTER.
DEFINE VARIABLE n-clfaux AS CHARACTER.
DEFINE VARIABLE x-cta    AS CHARACTER.
DEFINE VARIABLE x-imptot AS INTEGER.
DEFINE VARIABLE x-coddiv AS CHAR.

f-genero = FALSE.
x-ctrcta = "411201".
x-imptot = 403.
x-coddiv = "00000".

FOR EACH t-prev:
    DELETE t-prev.
END.

FOR EACH PL-BOLE NO-LOCK WHERE
    PL-BOLE.codpln = p-codpln AND
    PL-BOLE.codcal = p-codcal AND
    PL-BOLE.codcta <> "" BREAK BY PL-BOLE.tpobol DESCENDING.
    IF FIRST-OF ( PL-BOLE.tpobol ) THEN DO:
        CASE PL-BOLE.tpobol:
            WHEN "Aportes" OR
            WHEN "Descuentos"     THEN t-tpomov = TRUE.
            WHEN "Remuneraciones" THEN t-tpomov = FALSE.
        END CASE.
        a-tpomov = NOT t-tpomov.
    END.
    FOR EACH PL-MOV-MES WHERE
        PL-MOV-MES.codcia  = p-codcia AND
        PL-MOV-MES.periodo = p-periodo AND
        PL-MOV-MES.nromes  = p-mes AND
        PL-MOV-MES.codpln  = p-codpln AND
        PL-MOV-MES.codcal  = p-codcal AND
        PL-MOV-MES.codmov  = PL-BOLE.codmov NO-LOCK:
        FIND PL-FLG-MES WHERE
            PL-FLG-MES.codcia  = p-codcia AND
            PL-FLG-MES.periodo = p-periodo AND
            PL-FLG-MES.nromes  = p-mes AND
            PL-FLG-MES.codpln  = PL-MOV-MES.codpln AND
            PL-FLG-MES.codper  = PL-MOV-MES.codper NO-LOCK NO-ERROR.
        IF AVAILABLE PL-FLG-MES /* AND PL-FLG-MES.sitact <> "Inactivo" */ THEN DO:
            n-clfaux = ''.
            m-clfaux = ''.
            /******************07-06-2002 MGM*************/            
            x-cta    = PL-BOLE.CodCta.            
            IF PL-BOLE.Tpobol = "Remuneraciones" THEN DO:
               x-cta = SUBSTR(PL-FLG-MES.Clase,1,2) + SUBSTR(PL-BOLE.Codcta,3,4).
            END.
            FIND cb-ctas WHERE
                 cb-ctas.codcia = cbd-codcia AND
                 cb-ctas.codcta = x-cta /*PL-BOLE.codcta*/ NO-LOCK NO-ERROR.
            /*******************************************/
            IF AVAILABLE cb-ctas AND cb-ctas.PidAux THEN DO:
               ASSIGN
                   n-clfaux = "00" + PL-FLG-MES.codper
                   m-clfaux = 'PER'.
               IF x-cta /*PL-BOLE.codcta*/ BEGINS '46' THEN DO:
                  FIND PL-AFPS WHERE PL-AFPS.codafp = PL-FLG-MES.codafp NO-LOCK NO-ERROR.
                  IF AVAILABLE PL-AFPS THEN
                     ASSIGN
                         n-clfaux =  STRING(PL-AFPS.codafp,"99")
                         m-clfaux = '@AFP'.
               END.
            END.
            FIND t-prev WHERE
                t-prev.coddiv = x-coddiv AND
                t-prev.codcta = x-cta /*PL-BOLE.codcta*/ AND
                t-prev.tpomov = t-tpomov AND
                t-prev.codaux = n-clfaux AND
                t-prev.clfaux = m-clfaux NO-ERROR.
            IF NOT AVAILABLE t-prev THEN DO:
                CREATE t-prev.
                t-prev.coddiv = x-coddiv.                 
                t-prev.codcta = x-cta /*PL-BOLE.codcta*/.
                t-prev.tpomov = t-tpomov.
                t-prev.clfaux = m-clfaux.
                t-prev.codaux = n-clfaux.
                FIND cb-ctas WHERE
                    cb-ctas.codcia = cbd-codcia AND
                    cb-ctas.codcta = t-prev.codcta NO-LOCK NO-ERROR.
                IF AVAILABLE cb-ctas THEN DO:
                   t-prev.nomcta = cb-ctas.nomcta.
                END.
                ELSE t-prev.nomcta = "CUENTA NO EXISTE !!!".
            END.
            t-prev.impmn1 = t-prev.impmn1 + PL-MOV-MES.valcal-mes.
            IF PL-BOLE.codcta-cntr = "" THEN DO:
               NEXT.
            /*
                n-clfaux = ''.
                m-clfaux = ''.
                FIND cb-ctas WHERE
                     cb-ctas.codcia = cbd-codcia AND
                     cb-ctas.codcta = x-ctrcta NO-LOCK NO-ERROR.
                IF AVAILABLE cb-ctas AND cb-ctas.PidAux THEN DO:
                   ASSIGN
                       n-clfaux = "00" + PL-FLG-MES.codper
                       m-clfaux = 'PER'.
                   IF x-ctrcta BEGINS '46' THEN DO:
                      FIND PL-AFPS WHERE PL-AFPS.codafp = PL-FLG-MES.codafp NO-LOCK NO-ERROR.
                      IF AVAILABLE PL-AFPS THEN
                         ASSIGN
                             n-clfaux = STRING(PL-AFPS.codafp,"99")
                             m-clfaux = '@AFP'.
                   END.
                END.
                IF AVAILABLE cb-ctas AND cb-ctas.PidAux THEN 
                   ASSIGN
                       n-clfaux = "00" + PL-FLG-MES.codper
                       m-clfaux = 'PER'.
                FIND t-prev WHERE
                    t-prev.coddiv = x-coddiv AND                
                    t-prev.codcta = x-ctrcta AND
                    t-prev.tpomov = a-tpomov AND 
                    t-prev.codaux = n-clfaux AND
                    t-prev.clfaux = m-clfaux NO-ERROR.                    
                IF NOT AVAIL t-prev THEN DO:
                    CREATE t-prev.
                    t-prev.coddiv = x-coddiv.                     
                    t-prev.codcta = x-ctrcta.
                    t-prev.tpomov = a-tpomov.
                    t-prev.clfaux = m-clfaux.
                    t-prev.codaux = n-clfaux.
                    FIND cb-ctas WHERE
                        cb-ctas.codcia = cbd-codcia AND
                        cb-ctas.codcta = t-prev.codcta NO-LOCK NO-ERROR.
                    IF AVAILABLE cb-ctas THEN DO:
                       t-prev.nomcta = cb-ctas.nomcta.
                    END.
                    ELSE t-prev.nomcta = "CUENTA NO EXISTE !!!".
                END.
            */    
            END.
            ELSE DO:
                n-clfaux = ''.
                m-clfaux = ''.
                x-cta    = PL-BOLE.CodCta-cntr.            
                IF PL-BOLE.Tpobol = "Aportes" THEN DO:
                   x-cta = SUBSTR(PL-FLG-MES.Clase,1,2) + SUBSTR(PL-BOLE.Codcta-cntr,3,4).
                END.

                FIND cb-ctas WHERE
                     cb-ctas.codcia = cbd-codcia AND
                     cb-ctas.codcta = x-cta /*PL-BOLE.codcta-cntr*/ NO-LOCK NO-ERROR.
                IF AVAILABLE cb-ctas AND cb-ctas.PidAux THEN DO:
                   ASSIGN
                       n-clfaux = "00" + PL-FLG-MES.codper
                       m-clfaux = 'PER'.
                   IF x-cta /*PL-BOLE.codcta-cntr*/ BEGINS '46' THEN DO:
                      FIND PL-AFPS WHERE PL-AFPS.codafp = PL-FLG-MES.codafp NO-LOCK NO-ERROR.
                      IF AVAILABLE PL-AFPS THEN
                         ASSIGN
                             n-clfaux = STRING(PL-AFPS.codafp,"99")
                             m-clfaux = '@AFP'.
                   END.
                END.
                FIND t-prev WHERE
                    t-prev.coddiv = x-coddiv AND                
                    t-prev.codcta = x-cta /*PL-BOLE.codcta-cntr*/ AND
                    t-prev.tpomov = a-tpomov AND
                    t-prev.codaux = n-clfaux AND
                    t-prev.clfaux = m-clfaux NO-ERROR.                    
                IF NOT AVAIL t-prev THEN DO:
                    CREATE t-prev.
                    t-prev.coddiv = x-coddiv.                    
                    t-prev.codcta = x-cta /*PL-BOLE.codcta-CNTR*/.
                    t-prev.tpomov = a-tpomov.
                    t-prev.clfaux = m-clfaux.
                    t-prev.codaux = n-clfaux.
                    FIND cb-ctas WHERE
                        cb-ctas.codcia = cbd-codcia AND
                        cb-ctas.codcta = t-prev.codcta NO-LOCK NO-ERROR.
                    IF AVAILABLE cb-ctas THEN DO:
                       t-prev.nomcta = cb-ctas.nomcta.
                    END.
                    ELSE t-prev.nomcta = "CUENTA NO EXISTE !!!".
                END.
            END.
            t-prev.impmn1 = t-prev.impmn1 + PL-MOV-MES.valcal-mes.
        END.
    END.
END.


n-clfaux = ''.
m-clfaux = ''.
a-tpomov = TRUE.

FOR EACH PL-MOV-MES WHERE
    PL-MOV-MES.codcia  = p-codcia AND
    PL-MOV-MES.periodo = p-periodo AND
    PL-MOV-MES.nromes  = p-mes AND
    PL-MOV-MES.codpln  = p-codpln AND
    PL-MOV-MES.codcal  = p-codcal AND
    PL-MOV-MES.codmov  = x-imptot NO-LOCK:
    FIND PL-FLG-MES WHERE
         PL-FLG-MES.codcia  = p-codcia AND
         PL-FLG-MES.periodo = p-periodo AND
         PL-FLG-MES.nromes  = p-mes AND
         PL-FLG-MES.codpln  = PL-MOV-MES.codpln AND
         PL-FLG-MES.codper  = PL-MOV-MES.codper NO-LOCK NO-ERROR.
    IF AVAILABLE PL-FLG-MES THEN DO:
        FIND t-prev WHERE
            t-prev.coddiv = x-coddiv AND    
            t-prev.codcta = x-ctrcta AND
            t-prev.tpomov = a-tpomov AND
            t-prev.codaux = n-clfaux AND
            t-prev.clfaux = m-clfaux NO-ERROR.                    
        IF NOT AVAIL t-prev THEN DO:
            CREATE t-prev.
            t-prev.coddiv = x-coddiv.            
            t-prev.codcta = x-ctrcta.
            t-prev.tpomov = a-tpomov.
            t-prev.clfaux = m-clfaux.
            t-prev.codaux = n-clfaux.
            FIND cb-ctas WHERE
                cb-ctas.codcia = cbd-codcia AND
                cb-ctas.codcta = t-prev.codcta NO-LOCK NO-ERROR.
            IF AVAILABLE cb-ctas THEN DO:
               t-prev.nomcta = cb-ctas.nomcta.
            END.
            ELSE t-prev.nomcta = "CUENTA NO EXISTE !!!".
        END.
        t-prev.impmn1 = t-prev.impmn1 + PL-MOV-MES.valcal-mes.
    END.
END.

f-genero = TRUE.

DO WITH FRAME {&FRAME-NAME}:
    Btn-imprimir:SENSITIVE   = TRUE.
    Btn-transferir:SENSITIVE = TRUE.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE genera-emp V-table-Win 
PROCEDURE genera-emp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-codcia  AS INTEGER.
DEFINE INPUT PARAMETER p-periodo AS INTEGER.
DEFINE INPUT PARAMETER p-mes     AS INTEGER.
DEFINE INPUT PARAMETER p-codope  AS CHARACTER.
DEFINE INPUT PARAMETER p-nroast  AS CHARACTER.
DEFINE INPUT PARAMETER p-codpln  AS INTEGER.
DEFINE INPUT PARAMETER p-codcal  AS INTEGER.

DEFINE VARIABLE t-tpomov AS LOGICAL.
DEFINE VARIABLE a-tpomov AS LOGICAL.
DEFINE VARIABLE x-ctrcta AS CHARACTER.
DEFINE VARIABLE m-clfaux AS CHARACTER.
DEFINE VARIABLE n-clfaux AS CHARACTER.
DEFINE VARIABLE x-cta    AS CHARACTER.
DEFINE VARIABLE x-imptot AS INTEGER.
DEFINE VARIABLE x-coddiv AS CHAR.

f-genero = FALSE.
x-ctrcta = "411101".
x-imptot = 403.
x-coddiv = "00000".

FOR EACH t-prev:
    DELETE t-prev.
END.

FOR EACH PL-BOLE NO-LOCK WHERE
    PL-BOLE.codpln = p-codpln AND
    PL-BOLE.codcal = p-codcal AND
    PL-BOLE.codcta <> "" BREAK BY PL-BOLE.tpobol DESCENDING.
    IF FIRST-OF ( PL-BOLE.tpobol ) THEN DO:
        CASE PL-BOLE.tpobol:
            WHEN "Aportes" OR
            WHEN "Descuentos"     THEN t-tpomov = TRUE.
            WHEN "Remuneraciones" THEN t-tpomov = FALSE.
        END CASE.
        a-tpomov = NOT t-tpomov.
    END.
    FOR EACH PL-MOV-MES WHERE
        PL-MOV-MES.codcia  = p-codcia AND
        PL-MOV-MES.periodo = p-periodo AND
        PL-MOV-MES.nromes  = p-mes AND
        PL-MOV-MES.codpln  = p-codpln AND
        PL-MOV-MES.codcal  = p-codcal AND
        PL-MOV-MES.codmov  = PL-BOLE.codmov NO-LOCK:
        FIND PL-FLG-MES WHERE
            PL-FLG-MES.codcia  = p-codcia AND
            PL-FLG-MES.periodo = p-periodo AND
            PL-FLG-MES.nromes  = p-mes AND
            PL-FLG-MES.codpln  = PL-MOV-MES.codpln AND
            PL-FLG-MES.codper  = PL-MOV-MES.codper NO-LOCK NO-ERROR.
        IF AVAILABLE PL-FLG-MES /* AND PL-FLG-MES.sitact <> "Inactivo" */ THEN DO:
            n-clfaux = ''.
            m-clfaux = ''.
            /******************07-06-2002 MGM*************/            
            x-cta    = PL-BOLE.CodCta.            
            IF PL-BOLE.Tpobol = "Remuneraciones" THEN DO:
               x-cta = SUBSTR(PL-FLG-MES.Clase,1,2) + SUBSTR(PL-BOLE.Codcta,3,4).
            END.
            FIND cb-ctas WHERE
                 cb-ctas.codcia = cbd-codcia AND
                 cb-ctas.codcta = x-cta /*PL-BOLE.codcta*/ NO-LOCK NO-ERROR.
            /*******************************************/
            IF AVAILABLE cb-ctas AND cb-ctas.PidAux THEN DO:
               ASSIGN
                   n-clfaux = "00" + PL-FLG-MES.codper
                   m-clfaux = 'PER'.
               IF x-cta /*PL-BOLE.codcta*/ BEGINS '46' THEN DO:
                  FIND PL-AFPS WHERE PL-AFPS.codafp = PL-FLG-MES.codafp NO-LOCK NO-ERROR.
                  IF AVAILABLE PL-AFPS THEN
                     ASSIGN
                         n-clfaux =  STRING(PL-AFPS.codafp,"99")
                         m-clfaux = '@AFP'.
               END.
            END.
            FIND t-prev WHERE
                t-prev.coddiv = x-coddiv AND
                t-prev.codcta = x-cta /*PL-BOLE.codcta*/ AND
                t-prev.tpomov = t-tpomov AND
                t-prev.codaux = n-clfaux AND
                t-prev.clfaux = m-clfaux NO-ERROR.
            IF NOT AVAILABLE t-prev THEN DO:
                CREATE t-prev.
                t-prev.coddiv = x-coddiv.                 
                t-prev.codcta = x-cta /*PL-BOLE.codcta*/.
                t-prev.tpomov = t-tpomov.
                t-prev.clfaux = m-clfaux.
                t-prev.codaux = n-clfaux.
                FIND cb-ctas WHERE
                    cb-ctas.codcia = cbd-codcia AND
                    cb-ctas.codcta = t-prev.codcta NO-LOCK NO-ERROR.
                IF AVAILABLE cb-ctas THEN DO:
                   t-prev.nomcta = cb-ctas.nomcta.
                END.
                ELSE t-prev.nomcta = "CUENTA NO EXISTE !!!".
            END.
            t-prev.impmn1 = t-prev.impmn1 + PL-MOV-MES.valcal-mes.
            IF PL-BOLE.codcta-cntr = "" THEN DO:
               NEXT.
            /*
                n-clfaux = ''.
                m-clfaux = ''.
                FIND cb-ctas WHERE
                     cb-ctas.codcia = cbd-codcia AND
                     cb-ctas.codcta = x-ctrcta NO-LOCK NO-ERROR.
                IF AVAILABLE cb-ctas AND cb-ctas.PidAux THEN DO:
                   ASSIGN
                       n-clfaux = "00" + PL-FLG-MES.codper
                       m-clfaux = 'PER'.
                   IF x-ctrcta BEGINS '46' THEN DO:
                      FIND PL-AFPS WHERE PL-AFPS.codafp = PL-FLG-MES.codafp NO-LOCK NO-ERROR.
                      IF AVAILABLE PL-AFPS THEN
                         ASSIGN
                             n-clfaux = STRING(PL-AFPS.codafp,"99")
                             m-clfaux = '@AFP'.
                   END.
                END.
                IF AVAILABLE cb-ctas AND cb-ctas.PidAux THEN 
                   ASSIGN
                       n-clfaux = "00" + PL-FLG-MES.codper
                       m-clfaux = 'PER'.
                FIND t-prev WHERE
                    t-prev.coddiv = x-coddiv AND                
                    t-prev.codcta = x-ctrcta AND
                    t-prev.tpomov = a-tpomov AND 
                    t-prev.codaux = n-clfaux AND
                    t-prev.clfaux = m-clfaux NO-ERROR.                    
                IF NOT AVAIL t-prev THEN DO:
                    CREATE t-prev.
                    t-prev.coddiv = x-coddiv.                     
                    t-prev.codcta = x-ctrcta.
                    t-prev.tpomov = a-tpomov.
                    t-prev.clfaux = m-clfaux.
                    t-prev.codaux = n-clfaux.
                    FIND cb-ctas WHERE
                        cb-ctas.codcia = cbd-codcia AND
                        cb-ctas.codcta = t-prev.codcta NO-LOCK NO-ERROR.
                    IF AVAILABLE cb-ctas THEN DO:
                       t-prev.nomcta = cb-ctas.nomcta.
                    END.
                    ELSE t-prev.nomcta = "CUENTA NO EXISTE !!!".
                END.
            */    
            END.
            ELSE DO:
                n-clfaux = ''.
                m-clfaux = ''.
                x-cta    = PL-BOLE.CodCta-cntr.            
                IF PL-BOLE.Tpobol = "Aportes" THEN DO:
                   x-cta = SUBSTR(PL-FLG-MES.Clase,1,2) + SUBSTR(PL-BOLE.Codcta-cntr,3,4).
                END.

                FIND cb-ctas WHERE
                     cb-ctas.codcia = cbd-codcia AND
                     cb-ctas.codcta = x-cta /*PL-BOLE.codcta-cntr*/ NO-LOCK NO-ERROR.
                IF AVAILABLE cb-ctas AND cb-ctas.PidAux THEN DO:
                   ASSIGN
                       n-clfaux = "00" + PL-FLG-MES.codper
                       m-clfaux = 'PER'.
                   IF x-cta /*PL-BOLE.codcta-cntr*/ BEGINS '46' THEN DO:
                      FIND PL-AFPS WHERE PL-AFPS.codafp = PL-FLG-MES.codafp NO-LOCK NO-ERROR.
                      IF AVAILABLE PL-AFPS THEN
                         ASSIGN
                             n-clfaux = STRING(PL-AFPS.codafp,"99")
                             m-clfaux = '@AFP'.
                   END.
                END.
                FIND t-prev WHERE
                    t-prev.coddiv = x-coddiv AND                
                    t-prev.codcta = x-cta /*PL-BOLE.codcta-cntr*/ AND
                    t-prev.tpomov = a-tpomov AND
                    t-prev.codaux = n-clfaux AND
                    t-prev.clfaux = m-clfaux NO-ERROR.                    
                IF NOT AVAIL t-prev THEN DO:
                    CREATE t-prev.
                    t-prev.coddiv = x-coddiv.                    
                    t-prev.codcta = x-cta /*PL-BOLE.codcta-CNTR*/.
                    t-prev.tpomov = a-tpomov.
                    t-prev.clfaux = m-clfaux.
                    t-prev.codaux = n-clfaux.
                    FIND cb-ctas WHERE
                        cb-ctas.codcia = cbd-codcia AND
                        cb-ctas.codcta = t-prev.codcta NO-LOCK NO-ERROR.
                    IF AVAILABLE cb-ctas THEN DO:
                       t-prev.nomcta = cb-ctas.nomcta.
                    END.
                    ELSE t-prev.nomcta = "CUENTA NO EXISTE !!!".
                END.
            END.
            t-prev.impmn1 = t-prev.impmn1 + PL-MOV-MES.valcal-mes.
        END.
    END.
END.


n-clfaux = ''.
m-clfaux = ''.
a-tpomov = TRUE.

FOR EACH PL-MOV-MES WHERE
    PL-MOV-MES.codcia  = p-codcia AND
    PL-MOV-MES.periodo = p-periodo AND
    PL-MOV-MES.nromes  = p-mes AND
    PL-MOV-MES.codpln  = p-codpln AND
    PL-MOV-MES.codcal  = p-codcal AND
    PL-MOV-MES.codmov  = x-imptot NO-LOCK:
    FIND PL-FLG-MES WHERE
         PL-FLG-MES.codcia  = p-codcia AND
         PL-FLG-MES.periodo = p-periodo AND
         PL-FLG-MES.nromes  = p-mes AND
         PL-FLG-MES.codpln  = PL-MOV-MES.codpln AND
         PL-FLG-MES.codper  = PL-MOV-MES.codper NO-LOCK NO-ERROR.
    IF AVAILABLE PL-FLG-MES THEN DO:
        FIND t-prev WHERE
            t-prev.coddiv = x-coddiv AND    
            t-prev.codcta = x-ctrcta AND
            t-prev.tpomov = a-tpomov AND
            t-prev.codaux = n-clfaux AND
            t-prev.clfaux = m-clfaux NO-ERROR.                    
        IF NOT AVAIL t-prev THEN DO:
            CREATE t-prev.
            t-prev.coddiv = x-coddiv.            
            t-prev.codcta = x-ctrcta.
            t-prev.tpomov = a-tpomov.
            t-prev.clfaux = m-clfaux.
            t-prev.codaux = n-clfaux.
            FIND cb-ctas WHERE
                cb-ctas.codcia = cbd-codcia AND
                cb-ctas.codcta = t-prev.codcta NO-LOCK NO-ERROR.
            IF AVAILABLE cb-ctas THEN DO:
               t-prev.nomcta = cb-ctas.nomcta.
            END.
            ELSE t-prev.nomcta = "CUENTA NO EXISTE !!!".
        END.
        t-prev.impmn1 = t-prev.impmn1 + PL-MOV-MES.valcal-mes.
    END.
END.

f-genero = TRUE.

DO WITH FRAME {&FRAME-NAME}:
    Btn-imprimir:SENSITIVE   = TRUE.
    Btn-transferir:SENSITIVE = TRUE.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE genera-emp-back V-table-Win 
PROCEDURE genera-emp-back :
DEFINE INPUT PARAMETER p-codcia  AS INTEGER.
DEFINE INPUT PARAMETER p-periodo AS INTEGER.
DEFINE INPUT PARAMETER p-mes     AS INTEGER.
DEFINE INPUT PARAMETER p-codope  AS CHARACTER.
DEFINE INPUT PARAMETER p-nroast  AS CHARACTER.
DEFINE INPUT PARAMETER p-codpln  AS INTEGER.
DEFINE INPUT PARAMETER p-codcal  AS INTEGER.

DEFINE VARIABLE t-tpomov AS LOGICAL.
DEFINE VARIABLE a-tpomov AS LOGICAL.
DEFINE VARIABLE x-ctrcta AS CHARACTER.
DEFINE VARIABLE m-clfaux AS CHARACTER.
DEFINE VARIABLE n-clfaux AS CHARACTER.

f-genero = FALSE.
x-ctrcta = "41110101".

FOR EACH t-prev:
    DELETE t-prev.
END.

FOR EACH PL-BOLE NO-LOCK WHERE
    PL-BOLE.codpln = p-codpln AND
    PL-BOLE.codcal = p-codcal AND
    PL-BOLE.codcta <> "" BREAK BY PL-BOLE.tpobol DESCENDING.
    IF FIRST-OF ( PL-BOLE.tpobol ) THEN DO:
        CASE PL-BOLE.tpobol:
            WHEN "Aportes" OR
            WHEN "Descuentos"     THEN t-tpomov = TRUE.
            WHEN "Remuneraciones" THEN t-tpomov = FALSE.
        END CASE.
        a-tpomov = NOT t-tpomov.
    END.
    FOR EACH PL-MOV-MES WHERE
        PL-MOV-MES.codcia  = p-codcia AND
        PL-MOV-MES.periodo = p-periodo AND
        PL-MOV-MES.nromes  = p-mes AND
        PL-MOV-MES.codpln  = p-codpln AND
        PL-MOV-MES.codcal  = p-codcal AND
        PL-MOV-MES.codmov  = PL-BOLE.codmov NO-LOCK:
        FIND PL-FLG-MES WHERE
            PL-FLG-MES.codcia  = p-codcia AND
            PL-FLG-MES.periodo = p-periodo AND
            PL-FLG-MES.nromes  = p-mes AND
            PL-FLG-MES.codpln  = PL-MOV-MES.codpln AND
            PL-FLG-MES.codper  = PL-MOV-MES.codper NO-LOCK NO-ERROR.
        IF AVAILABLE PL-FLG-MES /* AND PL-FLG-MES.sitact <> "Inactivo" */ THEN DO:
            n-clfaux = ''.
            m-clfaux = ''.
            FIND cb-ctas WHERE
                 cb-ctas.codcia = cbd-codcia AND
                 cb-ctas.codcta = PL-BOLE.codcta NO-LOCK NO-ERROR.
            IF AVAILABLE cb-ctas AND cb-ctas.PidAux THEN DO:
               ASSIGN
                   n-clfaux = PL-FLG-MES.codper
                   m-clfaux = 'PER'.
               IF PL-BOLE.codcta BEGINS '46' THEN DO:
                  FIND PL-AFPS WHERE PL-AFPS.codafp = PL-FLG-MES.codafp NO-LOCK NO-ERROR.
                  IF AVAILABLE PL-AFPS THEN
                     ASSIGN
                         n-clfaux = 'AFP' + SUBSTRING(PL-AFPS.desafp,1,5)
                         m-clfaux = '@PV'.
               END.
            END.
            FIND t-prev WHERE
                t-prev.coddiv = PL-FLG-MES.coddiv AND
                t-prev.cco    = PL-FLG-MES.ccosto AND
                t-prev.codcta = PL-BOLE.codcta AND
                t-prev.tpomov = t-tpomov AND
                t-prev.codaux = n-clfaux AND
                t-prev.clfaux = m-clfaux NO-ERROR.
            IF NOT AVAILABLE t-prev THEN DO:
                CREATE t-prev.
                t-prev.codcta = PL-BOLE.codcta.
                t-prev.coddiv = PL-FLG-MES.coddiv.
                t-prev.cco    = PL-FLG-MES.ccosto.
                t-prev.tpomov = t-tpomov.
                t-prev.clfaux = m-clfaux.
                t-prev.codaux = n-clfaux.
                FIND cb-ctas WHERE
                    cb-ctas.codcia = cbd-codcia AND
                    cb-ctas.codcta = t-prev.codcta NO-LOCK NO-ERROR.
                IF AVAILABLE cb-ctas THEN DO:
                   t-prev.nomcta = cb-ctas.nomcta.
                END.
                ELSE t-prev.nomcta = "CUENTA NO EXISTE !!!".
            END.
            t-prev.impmn1 = t-prev.impmn1 + PL-MOV-MES.valcal-mes.
            IF PL-BOLE.codcta-cntr = "" THEN DO:
                n-clfaux = ''.
                m-clfaux = ''.
                FIND cb-ctas WHERE
                     cb-ctas.codcia = cbd-codcia AND
                     cb-ctas.codcta = x-ctrcta NO-LOCK NO-ERROR.
                IF AVAILABLE cb-ctas AND cb-ctas.PidAux THEN DO:
                   ASSIGN
                       n-clfaux = PL-FLG-MES.codper
                       m-clfaux = 'PER'.
                   IF x-ctrcta BEGINS '46' THEN DO:
                      FIND PL-AFPS WHERE PL-AFPS.codafp = PL-FLG-MES.codafp NO-LOCK NO-ERROR.
                      IF AVAILABLE PL-AFPS THEN
                         ASSIGN
                             n-clfaux = 'AFP' + SUBSTRING(PL-AFPS.desafp,1,5)
                             m-clfaux = '@PV'.
                   END.
                END.
                IF AVAILABLE cb-ctas AND cb-ctas.PidAux THEN 
                   ASSIGN
                       n-clfaux = PL-FLG-MES.codper
                       m-clfaux = 'PER'.
                FIND t-prev WHERE
                    t-prev.coddiv = PL-FLG-MES.coddiv AND
                    t-prev.cco    = PL-FLG-MES.ccosto AND
                    t-prev.codcta = x-ctrcta AND
                    t-prev.tpomov = a-tpomov AND 
                    t-prev.codaux = n-clfaux AND
                    t-prev.clfaux = m-clfaux NO-ERROR.                    
                IF NOT AVAIL t-prev THEN DO:
                    CREATE t-prev.
                    t-prev.codcta = x-ctrcta.
                    t-prev.coddiv = PL-FLG-MES.coddiv.
                    t-prev.cco    = PL-FLG-MES.ccosto.
                    t-prev.tpomov = a-tpomov.
                    t-prev.clfaux = m-clfaux.
                    t-prev.codaux = n-clfaux.
                    FIND cb-ctas WHERE
                        cb-ctas.codcia = cbd-codcia AND
                        cb-ctas.codcta = t-prev.codcta NO-LOCK NO-ERROR.
                    IF AVAILABLE cb-ctas THEN DO:
                       t-prev.nomcta = cb-ctas.nomcta.
                    END.
                    ELSE t-prev.nomcta = "CUENTA NO EXISTE !!!".
                END.
            END.
            ELSE DO:
                n-clfaux = ''.
                m-clfaux = ''.
                FIND cb-ctas WHERE
                     cb-ctas.codcia = cbd-codcia AND
                     cb-ctas.codcta = PL-BOLE.codcta-cntr NO-LOCK NO-ERROR.
                IF AVAILABLE cb-ctas AND cb-ctas.PidAux THEN DO:
                   ASSIGN
                       n-clfaux = PL-FLG-MES.codper
                       m-clfaux = 'PER'.
                   IF PL-BOLE.codcta-cntr BEGINS '46' THEN DO:
                      FIND PL-AFPS WHERE PL-AFPS.codafp = PL-FLG-MES.codafp NO-LOCK NO-ERROR.
                      IF AVAILABLE PL-AFPS THEN
                         ASSIGN
                             n-clfaux = 'AFP' + SUBSTRING(PL-AFPS.desafp,1,5)
                             m-clfaux = '@PV'.
                   END.
                END.
                FIND t-prev WHERE
                    t-prev.coddiv = PL-FLG-MES.coddiv AND
                    t-prev.cco    = PL-FLG-MES.ccosto AND
                    t-prev.codcta = PL-BOLE.codcta-cntr AND
                    t-prev.tpomov = a-tpomov AND
                    t-prev.codaux = n-clfaux AND
                    t-prev.clfaux = m-clfaux NO-ERROR.                    
                IF NOT AVAIL t-prev THEN DO:
                    CREATE t-prev.
                    t-prev.codcta = PL-BOLE.codcta-CNTR.
                    t-prev.coddiv = PL-FLG-MES.coddiv.
                    t-prev.cco    = PL-FLG-MES.ccosto.
                    t-prev.tpomov = a-tpomov.
                    t-prev.clfaux = m-clfaux.
                    t-prev.codaux = n-clfaux.
                    FIND cb-ctas WHERE
                        cb-ctas.codcia = cbd-codcia AND
                        cb-ctas.codcta = t-prev.codcta NO-LOCK NO-ERROR.
                    IF AVAILABLE cb-ctas THEN DO:
                       t-prev.nomcta = cb-ctas.nomcta.
                    END.
                    ELSE t-prev.nomcta = "CUENTA NO EXISTE !!!".
                END.
            END.
            t-prev.impmn1 = t-prev.impmn1 + PL-MOV-MES.valcal-mes.
        END.
    END.
END.

f-genero = TRUE.

DO WITH FRAME {&FRAME-NAME}:
    Btn-imprimir:SENSITIVE   = TRUE.
    Btn-transferir:SENSITIVE = TRUE.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE genera-obr V-table-Win 
PROCEDURE genera-obr :
DEFINE INPUT PARAMETER p-codcia  AS INTEGER.
DEFINE INPUT PARAMETER p-periodo AS INTEGER.
DEFINE INPUT PARAMETER p-sem     AS INTEGER.
DEFINE INPUT PARAMETER p-codope  AS CHARACTER.
DEFINE INPUT PARAMETER p-nroast  AS CHARACTER.
DEFINE INPUT PARAMETER p-codpln  AS INTEGER.
DEFINE INPUT PARAMETER p-codcal  AS INTEGER.

DEFINE VARIABLE t-tpomov AS LOGICAL.
DEFINE VARIABLE a-tpomov AS LOGICAL.
DEFINE VARIABLE x-ctrcta AS CHARACTER.
DEFINE VARIABLE m-clfaux AS CHARACTER.
DEFINE VARIABLE n-clfaux AS CHARACTER.

f-genero = FALSE.
x-ctrcta = "41110102".

FOR EACH t-prev:
    DELETE t-prev.
END.

FOR EACH PL-BOLE NO-LOCK WHERE
    PL-BOLE.codpln = p-codpln AND
    PL-BOLE.codcal = p-codcal AND
    PL-BOLE.codcta <> "" BREAK BY PL-BOLE.tpobol DESCENDING.
    IF FIRST-OF ( PL-BOLE.tpobol ) THEN DO:
        CASE PL-BOLE.tpobol:
            WHEN "Aportes" OR WHEN "Descuentos" THEN t-tpomov = TRUE.
            WHEN "Remuneraciones" THEN t-tpomov = FALSE.
            OTHERWISE NEXT.
        END CASE.
        a-tpomov = NOT t-tpomov.
    END.
    FOR EACH PL-MOV-SEM WHERE
        PL-MOV-SEM.codcia  = p-codcia AND
        PL-MOV-SEM.periodo = p-periodo AND
        PL-MOV-SEM.nrosem  = p-sem AND
        PL-MOV-SEM.codpln  = p-codpln AND
        PL-MOV-SEM.codcal  = p-codcal AND
        PL-MOV-SEM.codmov  = PL-BOLE.codmov NO-LOCK:
        FIND PL-FLG-SEM WHERE
            PL-FLG-SEM.codcia  = p-codcia AND
            PL-FLG-SEM.periodo = p-periodo AND
            PL-FLG-SEM.nrosem  = p-sem AND
            PL-FLG-SEM.codpln  = PL-MOV-SEM.codpln AND
            PL-FLG-SEM.codper  = PL-MOV-SEM.codper NO-LOCK NO-ERROR.
        IF AVAILABLE PL-FLG-SEM /* AND PL-FLG-SEM.sitact <> "Inactivo" */ THEN DO:
            n-clfaux = ''.
            m-clfaux = ''.
            FIND cb-ctas WHERE
                 cb-ctas.codcia = cbd-codcia AND
                 cb-ctas.codcta = PL-BOLE.codcta NO-LOCK NO-ERROR.
            IF AVAILABLE cb-ctas AND cb-ctas.PidAux THEN DO:
               ASSIGN
                   n-clfaux = PL-FLG-SEM.codper
                   m-clfaux = 'PER'.
               IF PL-BOLE.codcta BEGINS '46' THEN DO:
                  FIND PL-AFPS WHERE PL-AFPS.codafp = PL-FLG-SEM.codafp NO-LOCK NO-ERROR.
                  IF AVAILABLE PL-AFPS THEN
                     ASSIGN
                         n-clfaux = 'AFP' + SUBSTRING(PL-AFPS.desafp,1,5)
                         m-clfaux = '@PV'.
               END.
            END.
            FIND t-prev WHERE
                t-prev.coddiv = PL-FLG-SEM.coddiv AND
                t-prev.cco    = PL-FLG-SEM.ccosto AND
                t-prev.codcta = PL-BOLE.codcta AND
                t-prev.tpomov = t-tpomov AND
                t-prev.codaux = n-clfaux AND
                t-prev.clfaux = m-clfaux NO-ERROR.                
            IF NOT AVAILABLE t-prev THEN DO:
                CREATE t-prev.
                t-prev.codcta = PL-BOLE.codcta.
                t-prev.coddiv = PL-FLG-SEM.coddiv.
                t-prev.cco    = PL-FLG-SEM.ccosto.
                t-prev.tpomov = t-tpomov.
                t-prev.clfaux = m-clfaux.
                t-prev.codaux = n-clfaux.
                FIND cb-ctas WHERE
                    cb-ctas.codcia = cbd-codcia AND
                    cb-ctas.codcta = t-prev.codcta NO-LOCK NO-ERROR.
                IF AVAILABLE cb-ctas THEN t-prev.nomcta = cb-ctas.nomcta.
                ELSE t-prev.nomcta = "CUENTA NO EXISTE !!!".
            END.
            t-prev.impmn1 = t-prev.impmn1 + PL-MOV-SEM.valcal-sem.
            IF PL-BOLE.codcta-cntr = "" THEN DO:
                n-clfaux = ''.
                m-clfaux = ''.
                FIND cb-ctas WHERE
                     cb-ctas.codcia = cbd-codcia AND
                     cb-ctas.codcta = x-ctrcta NO-LOCK NO-ERROR.
                IF AVAILABLE cb-ctas AND cb-ctas.PidAux THEN DO:
                   ASSIGN
                       n-clfaux = PL-FLG-SEM.codper
                       m-clfaux = 'PER'.
                   IF x-ctrcta BEGINS '46' THEN DO:
                      FIND PL-AFPS WHERE PL-AFPS.codafp = PL-FLG-SEM.codafp NO-LOCK NO-ERROR.
                      IF AVAILABLE PL-AFPS THEN
                         ASSIGN
                             n-clfaux = 'AFP' + SUBSTRING(PL-AFPS.desafp,1,5)
                             m-clfaux = '@PV'.
                   END.
                END.
                IF AVAILABLE cb-ctas AND cb-ctas.PidAux THEN 
                   ASSIGN
                       n-clfaux = PL-FLG-SEM.codper
                       m-clfaux = 'PER'.
                FIND t-prev WHERE
                    t-prev.coddiv = PL-FLG-SEM.coddiv AND
                    t-prev.cco    = PL-FLG-SEM.ccosto AND
                    t-prev.codcta = x-ctrcta AND
                    t-prev.tpomov = a-tpomov AND
                    t-prev.codaux = n-clfaux AND
                    t-prev.clfaux = m-clfaux NO-ERROR.                
                IF NOT AVAIL t-prev THEN DO:
                    CREATE t-prev.
                    t-prev.codcta = x-ctrcta.
                    t-prev.coddiv = PL-FLG-SEM.coddiv.
                    t-prev.cco    = PL-FLG-SEM.ccosto.
                    t-prev.tpomov = a-tpomov.
                    t-prev.clfaux = m-clfaux.
                    t-prev.codaux = n-clfaux.
                    FIND cb-ctas WHERE
                        cb-ctas.codcia = cbd-codcia AND
                        cb-ctas.codcta = t-prev.codcta NO-LOCK NO-ERROR.
                    IF AVAILABLE cb-ctas THEN t-prev.nomcta = cb-ctas.nomcta.
                    ELSE t-prev.nomcta = "CUENTA NO EXISTE !!!".
                END.
            END.
            ELSE DO:
                n-clfaux = ''.
                m-clfaux = ''.
                FIND cb-ctas WHERE
                     cb-ctas.codcia = cbd-codcia AND
                     cb-ctas.codcta = PL-BOLE.codcta-cntr NO-LOCK NO-ERROR.
                IF AVAILABLE cb-ctas AND cb-ctas.PidAux THEN DO:
                   ASSIGN
                       n-clfaux = PL-FLG-SEM.codper
                       m-clfaux = 'PER'.
                   IF PL-BOLE.codcta-cntr BEGINS '46' THEN DO:
                      FIND PL-AFPS WHERE PL-AFPS.codafp = PL-FLG-SEM.codafp NO-LOCK NO-ERROR.
                      IF AVAILABLE PL-AFPS THEN
                         ASSIGN
                             n-clfaux = 'AFP' + SUBSTRING(PL-AFPS.desafp,1,5)
                             m-clfaux = '@PV'.
                   END.
                END.
                FIND t-prev WHERE
                    t-prev.coddiv = PL-FLG-SEM.coddiv AND
                    t-prev.cco    = PL-FLG-SEM.ccosto AND
                    t-prev.codcta = PL-BOLE.codcta-cntr AND
                    t-prev.tpomov = a-tpomov AND
                    t-prev.codaux = n-clfaux AND
                    t-prev.clfaux = m-clfaux NO-ERROR.                
                IF NOT AVAIL t-prev THEN DO:
                    CREATE t-prev.
                    t-prev.codcta = PL-BOLE.codcta-CNTR.
                    t-prev.coddiv = PL-FLG-SEM.coddiv.
                    t-prev.cco    = PL-FLG-SEM.ccosto.
                    t-prev.tpomov = a-tpomov.
                    t-prev.clfaux = m-clfaux.
                    t-prev.codaux = n-clfaux.
                    FIND cb-ctas WHERE
                        cb-ctas.codcia = cbd-codcia AND
                        cb-ctas.codcta = t-prev.codcta NO-LOCK NO-ERROR.
                    IF AVAILABLE cb-ctas THEN t-prev.nomcta = cb-ctas.nomcta.
                    ELSE t-prev.nomcta = "CUENTA NO EXISTE !!!".
                END.
            END.
            t-prev.impmn1 = t-prev.impmn1 + PL-MOV-SEM.valcal-sem.
        END.
    END.
END.

f-genero = TRUE.

DO WITH FRAME {&FRAME-NAME}:
    Btn-imprimir:SENSITIVE   = TRUE.
    Btn-transferir:SENSITIVE = TRUE.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE genera-obr-new V-table-Win 
PROCEDURE genera-obr-new :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-codcia  AS INTEGER.
DEFINE INPUT PARAMETER p-periodo AS INTEGER.
DEFINE INPUT PARAMETER p-sem     AS INTEGER.
DEFINE INPUT PARAMETER p-codope  AS CHARACTER.
DEFINE INPUT PARAMETER p-nroast  AS CHARACTER.
DEFINE INPUT PARAMETER p-codpln  AS INTEGER.
DEFINE INPUT PARAMETER p-codcal  AS INTEGER.

DEFINE VARIABLE t-tpomov AS LOGICAL.
DEFINE VARIABLE a-tpomov AS LOGICAL.
DEFINE VARIABLE x-ctrcta AS CHARACTER.
DEFINE VARIABLE m-clfaux AS CHARACTER.
DEFINE VARIABLE n-clfaux AS CHARACTER.
DEFINE VARIABLE x-cta    AS CHARACTER.
DEFINE VARIABLE x-imptot AS INTEGER.
DEFINE VARIABLE x-coddiv AS CHAR.

f-genero = FALSE.
x-ctrcta = "411102".
x-imptot = 403.
x-coddiv = "00000".

FOR EACH t-prev:
    DELETE t-prev.
END.

FOR EACH PL-BOLE NO-LOCK WHERE
    PL-BOLE.codpln = p-codpln AND
    PL-BOLE.codcal = p-codcal AND
    PL-BOLE.codcta <> "" BREAK BY PL-BOLE.tpobol DESCENDING.
    IF FIRST-OF ( PL-BOLE.tpobol ) THEN DO:
        CASE PL-BOLE.tpobol:
            WHEN "Aportes" OR
            WHEN "Descuentos"     THEN t-tpomov = TRUE.
            WHEN "Remuneraciones" THEN t-tpomov = FALSE.
        END CASE.
        a-tpomov = NOT t-tpomov.
    END.
    FOR EACH PL-MOV-SEM WHERE
        PL-MOV-SEM.codcia  = p-codcia AND
        PL-MOV-SEM.periodo = p-periodo AND
        PL-MOV-SEM.nrosem  = p-sem AND
        PL-MOV-SEM.codpln  = p-codpln AND
        PL-MOV-SEM.codcal  = p-codcal AND
        PL-MOV-SEM.codmov  = PL-BOLE.codmov NO-LOCK:
        FIND PL-FLG-SEM WHERE
            PL-FLG-SEM.codcia  = p-codcia AND
            PL-FLG-SEM.periodo = p-periodo AND
            PL-FLG-SEM.nrosem  = p-sem AND
            PL-FLG-SEM.codpln  = PL-MOV-SEM.codpln AND
            PL-FLG-SEM.codper  = PL-MOV-SEM.codper NO-LOCK NO-ERROR.
        IF AVAILABLE PL-FLG-SEM /* AND PL-FLG-SEM.sitact <> "Inactivo" */ THEN DO:
            n-clfaux = ''.
            m-clfaux = ''.
            /******************07-06-2002 MGM*************/            
            x-cta    = PL-BOLE.CodCta.            
            IF PL-BOLE.Tpobol = "Remuneraciones" THEN DO:
               x-cta = SUBSTR(PL-FLG-SEM.Clase,1,2) + SUBSTR(PL-BOLE.Codcta,3,4).
            END.
            FIND cb-ctas WHERE
                 cb-ctas.codcia = cbd-codcia AND
                 cb-ctas.codcta = x-cta /*PL-BOLE.codcta*/ NO-LOCK NO-ERROR.
            /*******************************************/
            IF AVAILABLE cb-ctas AND cb-ctas.PidAux THEN DO:
               ASSIGN
                   n-clfaux = "00" + PL-FLG-SEM.codper
                   m-clfaux = 'PER'.
               IF x-cta /*PL-BOLE.codcta*/ BEGINS '46' THEN DO:
                  FIND PL-AFPS WHERE PL-AFPS.codafp = PL-FLG-SEM.codafp NO-LOCK NO-ERROR.
                  IF AVAILABLE PL-AFPS THEN
                     ASSIGN
                         n-clfaux =  STRING(PL-AFPS.codafp,"99")
                         m-clfaux = '@AFP'.
               END.
            END.
            FIND t-prev WHERE
                t-prev.coddiv = x-coddiv AND
                t-prev.codcta = x-cta /*PL-BOLE.codcta*/ AND
                t-prev.tpomov = t-tpomov AND
                t-prev.codaux = n-clfaux AND
                t-prev.clfaux = m-clfaux NO-ERROR.
            IF NOT AVAILABLE t-prev THEN DO:
                CREATE t-prev.
                t-prev.coddiv = x-coddiv.                 
                t-prev.codcta = x-cta /*PL-BOLE.codcta*/.
                t-prev.tpomov = t-tpomov.
                t-prev.clfaux = m-clfaux.
                t-prev.codaux = n-clfaux.
                FIND cb-ctas WHERE
                    cb-ctas.codcia = cbd-codcia AND
                    cb-ctas.codcta = t-prev.codcta NO-LOCK NO-ERROR.
                IF AVAILABLE cb-ctas THEN DO:
                   t-prev.nomcta = cb-ctas.nomcta.
                END.
                ELSE t-prev.nomcta = "CUENTA NO EXISTE !!!".
            END.
            t-prev.impmn1 = t-prev.impmn1 + PL-MOV-SEM.valcal-sem.
            IF PL-BOLE.codcta-cntr = "" THEN DO:
               NEXT.
            END.
            ELSE DO:
                n-clfaux = ''.
                m-clfaux = ''.
                x-cta    = PL-BOLE.CodCta-cntr.            
                IF PL-BOLE.Tpobol = "Aportes" THEN DO:
                   x-cta = SUBSTR(PL-FLG-SEM.Clase,1,2) + SUBSTR(PL-BOLE.Codcta-cntr,3,4).
                END.

                FIND cb-ctas WHERE
                     cb-ctas.codcia = cbd-codcia AND
                     cb-ctas.codcta = x-cta /*PL-BOLE.codcta-cntr*/ NO-LOCK NO-ERROR.
                IF AVAILABLE cb-ctas AND cb-ctas.PidAux THEN DO:
                   ASSIGN
                       n-clfaux = "00" + PL-FLG-SEM.codper
                       m-clfaux = 'PER'.
                   IF x-cta /*PL-BOLE.codcta-cntr*/ BEGINS '46' THEN DO:
                      FIND PL-AFPS WHERE PL-AFPS.codafp = PL-FLG-SEM.codafp NO-LOCK NO-ERROR.
                      IF AVAILABLE PL-AFPS THEN
                         ASSIGN
                             n-clfaux = STRING(PL-AFPS.codafp,"99")
                             m-clfaux = '@AFP'.
                   END.
                END.
                FIND t-prev WHERE
                    t-prev.coddiv = x-coddiv AND                
                    t-prev.codcta = x-cta /*PL-BOLE.codcta-cntr*/ AND
                    t-prev.tpomov = a-tpomov AND
                    t-prev.codaux = n-clfaux AND
                    t-prev.clfaux = m-clfaux NO-ERROR.                    
                IF NOT AVAIL t-prev THEN DO:
                    CREATE t-prev.
                    t-prev.coddiv = x-coddiv.                    
                    t-prev.codcta = x-cta /*PL-BOLE.codcta-CNTR*/.
                    t-prev.tpomov = a-tpomov.
                    t-prev.clfaux = m-clfaux.
                    t-prev.codaux = n-clfaux.
                    FIND cb-ctas WHERE
                        cb-ctas.codcia = cbd-codcia AND
                        cb-ctas.codcta = t-prev.codcta NO-LOCK NO-ERROR.
                    IF AVAILABLE cb-ctas THEN DO:
                       t-prev.nomcta = cb-ctas.nomcta.
                    END.
                    ELSE t-prev.nomcta = "CUENTA NO EXISTE !!!".
                END.
            END.
            t-prev.impmn1 = t-prev.impmn1 + PL-MOV-SEM.valcal-sem.
        END.
    END.
END.


n-clfaux = ''.
m-clfaux = ''.
a-tpomov = TRUE.

FOR EACH PL-MOV-SEM WHERE
    PL-MOV-SEM.codcia  = p-codcia AND
    PL-MOV-SEM.periodo = p-periodo AND
    PL-MOV-SEM.nrosem  = p-sem AND
    PL-MOV-SEM.codpln  = p-codpln AND
    PL-MOV-SEM.codcal  = p-codcal AND
    PL-MOV-SEM.codmov  = x-imptot NO-LOCK:
    FIND PL-FLG-SEM WHERE
         PL-FLG-SEM.codcia  = p-codcia AND
         PL-FLG-SEM.periodo = p-periodo AND
         PL-FLG-SEM.nrosem  = p-sem AND
         PL-FLG-SEM.codpln  = PL-MOV-SEM.codpln AND
         PL-FLG-SEM.codper  = PL-MOV-SEM.codper NO-LOCK NO-ERROR.
    IF AVAILABLE PL-FLG-SEM THEN DO:
        FIND t-prev WHERE
            t-prev.coddiv = x-coddiv AND    
            t-prev.codcta = x-ctrcta AND
            t-prev.tpomov = a-tpomov AND
            t-prev.codaux = n-clfaux AND
            t-prev.clfaux = m-clfaux NO-ERROR.                    
        IF NOT AVAIL t-prev THEN DO:
            CREATE t-prev.
            t-prev.coddiv = x-coddiv.            
            t-prev.codcta = x-ctrcta.
            t-prev.tpomov = a-tpomov.
            t-prev.clfaux = m-clfaux.
            t-prev.codaux = n-clfaux.
            FIND cb-ctas WHERE
                cb-ctas.codcia = cbd-codcia AND
                cb-ctas.codcta = t-prev.codcta NO-LOCK NO-ERROR.
            IF AVAILABLE cb-ctas THEN DO:
               t-prev.nomcta = cb-ctas.nomcta.
            END.
            ELSE t-prev.nomcta = "CUENTA NO EXISTE !!!".
        END.
        t-prev.impmn1 = t-prev.impmn1 + PL-MOV-SEM.valcal-sem.
    END.
END.

f-genero = TRUE.

DO WITH FRAME {&FRAME-NAME}:
    Btn-imprimir:SENSITIVE   = TRUE.
    Btn-transferir:SENSITIVE = TRUE.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPRIMIR V-table-Win 
PROCEDURE IMPRIMIR :
/*IMPRESION DEL TEMPORAL */

DEFINE VARIABLE x-despln AS CHARACTER FORMAT "x(25)".
DEFINE VARIABLE a-nroast AS CHARACTER FORMAT "x(25)".
DEFINE VARIABLE x-codcta AS CHARACTER LABEL "CTA".
DEFINE VARIABLE x-nomcta AS CHARACTER LABEL "DESCRIPCION".
DEFINE VARIABLE x-descc  AS CHARACTER FORMAT "x(60)".
DEFINE VARIABLE x-cco    AS CHARACTER LABEL "CCo".
DEFINE VARIABLE x-debe   AS DECIMAL   LABEL "DEBE".
DEFINE VARIABLE x-haber  AS DECIMAL   LABEL "HABER".
DEFINE VARIABLE x-mes    AS INTEGER.

x-mes = CMB-mes.
x-despln = IF PL-CALC.CODPLN = 2 THEN "PLANILLA DE OBREROS" ELSE "PLANILLA DE EMPLEADOS".

DEFINE FRAME F-CAB
    x-codcta
    x-nomcta FORMAT "x(25)"
    x-cco
    x-debe
    x-haber
    HEADER
    "PREASIENTO.."
    "COMPA¥IA : CLINICA STELLA MARIS"
    "PERIODO : " s-periodo FORMAT "9999"
    SKIP
    "MES : " x-mes FORMAT "99"
    "PLANILLA : " PL-CALC.CODPLN x-DESPLN
    "CALCULO : " PL-CALC.CODCAL
    SKIP
    "OPERACION : " x-codope "NRO ASIENTO : " a-nroast
    SKIP(1)
    "CENTRO DE COSTO : " x-descc SKIP(1)
    WITH DOWN STREAM-IO NO-BOX.

OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 66.

FOR EACH t-prev NO-LOCK BREAK
    BY t-prev.cco
    BY t-prev.codcta:
    IF FIRST-OF(t-prev.cco) THEN DO:
        FIND GN-CCOS WHERE
            GN-CCOS.codcia = s-codcia AND
            GN-CCOS.codcco = t-prev.cco NO-LOCK NO-ERROR.
        IF AVAILABLE GN-CCOS THEN x-descc = GN-CCOS.DesCco.
        ELSE x-descc = "".
        a-nroast = STRING(CMB-mes,"99") +
            IF PL-PLAN.tippln THEN STRING(PL-CALC.codpln,"99")
            ELSE STRING(CMB-sem,"99") + SUBSTRING(t-prev.cco,1,2).
        x-cco = t-prev.cco.
    END.
    x-debe   = 0.
    x-haber  = 0.
    x-codcta = t-prev.codcta.
    x-nomcta = t-prev.nomcta.
    IF t-prev.tpomov THEN x-haber = t-prev.impmn1.
    ELSE x-debe = t-prev.impmn1.
    ACCUMULATE x-debe (SUB-TOTAL BY t-prev.cco).
    ACCUMULATE x-haber (SUB-TOTAL BY t-prev.cco).
    DISPLAY STREAM REPORT
        x-codcta
        x-nomcta
        x-cco
        x-debe  WHEN x-debe  <> 0
        x-haber WHEN x-haber <> 0
        WITH FRAME F-CAB.
    IF LAST-OF(t-prev.cco) THEN DO:
        UNDERLINE STREAM report
            x-debe
            x-haber
            WITH FRAME f-cab.
        x-debe =  ACCUM SUB-TOTAL BY t-prev.cco x-debe.
        x-haber = ACCUM SUB-TOTAL BY t-prev.cco x-haber.
        DISPLAY STREAM report
            "TOTAL CC" @ x-nomcta
            x-debe
            x-haber
            WITH FRAME f-cab.
        PAGE STREAM report.
    END.
END.

OUTPUT STREAM REPORT CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPRIMIR-1 V-table-Win 
PROCEDURE IMPRIMIR-1 :
DEFINE VARIABLE x-nomcta AS CHARACTER LABEL "DESCRIPCION".
DEFINE VARIABLE x-codaux AS CHARACTER LABEL "AUXILIAR".
DEFINE VARIABLE x-clfaux AS CHARACTER LABEL "TIPO".
DEFINE VARIABLE x-DESPLN AS CHARACTER FORMAT "X(20)".
DEFINE VARIABLE F-codcta AS CHARACTER LABEL "CUENTA".
DEFINE VARIABLE F-coddiv AS CHARACTER LABEL "DIV".
DEFINE VARIABLE F-cco    AS CHARACTER LABEL "CCo".
DEFINE VARIABLE F-DEBE   AS DECIMAL   LABEL "DEBE".
DEFINE VARIABLE F-HABER  AS DECIMAL   LABEL "HABER".
DEFINE VARIABLE T-DEBE   AS DECIMAL   LABEL "DEBE".
DEFINE VARIABLE T-HABER  AS DECIMAL   LABEL "HABER".
DEFINE VARIABLE T-SALDO  AS DECIMAL   LABEL "SALDO".
DEFINE VARIABLE T-MES AS INTEGER.
T-MES = CMB-mes.
x-despln = IF PL-CALC.CODPLN = 2 THEN "PLANILLA DE OBREROS" ELSE "PLANILLA DE EMPLEADOS".
DEFINE FRAME F-CAB-1
    F-coddiv
    F-codcta
    x-nomcta FORMAT "x(35)"
    x-clfaux FORMAT "x(5)"
    x-codaux FORMAT "x(8)"
    T-DEBE  FORMAT "-ZZZ,ZZZ,ZZ9.99"
    T-HABER FORMAT "-ZZZ,ZZZ,ZZ9.99"
    T-SALDO FORMAT "-ZZZ,ZZZ,ZZ9.99"
    HEADER
    "PREASIENTO...." SKIP(1)
    "EMPRESA  :"  s-codcia FORMAT '999'
    " " s-nomcia  SPACE(33) "PERIODO :  " s-periodo FORMAT "9999" 
    SKIP
    "MES      : " T-MES FORMAT "99" SKIP 
    "PLANILLA : " PL-CALC.CODPLN X-DESPLN  SPACE(50) "OPERACION   : " x-codope SKIP
    "CALCULO  : " PL-CALC.CODCAL  SPACE(70) "NRO ASIENTO : " x-nroast
    SKIP(2)
    WITH DOWN STREAM-IO NO-BOX WIDTH 150.

OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62.

/*PUT STREAM REPORT CONTROL CHR(27) CHR(70) CHR(27) CHR(77). comprimida normal con menor espacio interlineal
PUT STREAM REPORT CONTROL CHR(27) CHR(80) CHR(27) CHR(69).  comprimida negrita */
PUT STREAM REPORT CONTROL CHR(27) CHR(70) CHR(15).  /* comprimida normal */

DO WITH FRAME F-CAB-1.

FOR EACH t-prev BREAK BY t-prev.coddiv BY t-prev.tpomov BY t-prev.codcta BY t-prev.codaux:
    
    IF FIRST-OF(t-prev.coddiv) THEN 
       ASSIGN 
        T-DEBE  = 0 T-HABER = 0 T-SALDO = 0.
    IF FIRST-OF(t-prev.codcta) THEN 
       ASSIGN 
        T-DEBE  = 0 T-HABER = 0 T-SALDO = 0.
    IF FIRST-OF(t-prev.codaux) THEN
       ASSIGN 
        T-DEBE  = 0 T-HABER = 0 T-SALDO = 0.
    
    IF t-prev.tpomov THEN T-HABER = T-HABER + t-prev.impmn1.
    ELSE T-DEBE  = T-DEBE  + t-prev.impmn1.
    
/*    IF t-prev.codaux <> ''  THEN DO:
        T-SALDO = T-DEBE - T-HABER.
        F-coddiv = t-prev.coddiv.
        F-codcta = t-prev.codcta.
        x-nomcta = t-prev.nomcta.
        x-clfaux = t-prev.clfaux.
        x-codaux = t-prev.codaux.
        DISPLAY STREAM REPORT
            F-coddiv 
            F-codcta 
            x-nomcta 
            x-clfaux 
            x-codaux 
            T-DEBE  WHEN T-DEBE  <> 0
            T-HABER WHEN T-HABER <> 0
            T-SALDO WHEN T-SALDO <> 0
            WITH FRAME F-CAB-1.
        DOWN STREAM REPORT WITH FRAME F-CAB-1.
        ACCUM T-DEBE  (TOTAL).
        ACCUM T-HABER (TOTAL).
        ACCUM T-SALDO (TOTAL).
    END.
*/    
    
    IF LAST-OF(t-prev.coddiv) OR LAST-OF(t-prev.codcta) OR LAST-OF(t-prev.codaux) THEN DO:
        T-SALDO = T-DEBE - T-HABER.
        F-coddiv = t-prev.coddiv.
        F-codcta = t-prev.codcta.
        x-nomcta = t-prev.nomcta.
        x-clfaux = t-prev.clfaux.
        x-codaux = t-prev.codaux.
        DISPLAY STREAM REPORT
            F-coddiv 
            F-codcta 
            x-nomcta 
            x-clfaux 
            x-codaux 
            T-DEBE  WHEN T-DEBE  <> 0
            T-HABER WHEN T-HABER <> 0
            T-SALDO WHEN T-SALDO <> 0
            WITH FRAME F-CAB-1.
        DOWN STREAM REPORT WITH FRAME F-CAB-1.
        ACCUM T-DEBE  (TOTAL).
        ACCUM T-HABER (TOTAL).
        ACCUM T-SALDO (TOTAL).
    END.
END.
UNDERLINE STREAM REPORT T-DEBE T-HABER T-SALDO WITH FRAME F-CAB-1.
DISPLAY STREAM REPORT
    (ACCUM TOTAL T-DEBE ) @ T-DEBE
    (ACCUM TOTAL T-HABER) @ T-HABER
    (ACCUM TOTAL T-SALDO) @ T-SALDO
    WITH FRAME F-CAB-1.
    DOWN STREAM REPORT WITH FRAME F-CAB-1.
END.
OUTPUT STREAM REPORT CLOSE.

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
  {src/adm/template/snd-list.i "integral.PL-CALC"}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE transferir-asto V-table-Win 
PROCEDURE transferir-asto :
DEFINE INPUT PARAMETER p-codcia  AS INTEGER.
DEFINE INPUT PARAMETER p-periodo AS INTEGER.
DEFINE INPUT PARAMETER p-mes     AS INTEGER.
DEFINE INPUT PARAMETER p-codope  AS CHARACTER.
DEFINE INPUT PARAMETER p-nroast  AS CHARACTER.
DEFINE INPUT PARAMETER p-fchast  AS DATE.

DEFINE VARIABLE x-glosa1 AS CHARACTER.
DEFINE VARIABLE x-glosa2 AS CHARACTER.
DEFINE VARIABLE x-clfaux AS CHARACTER.
DEFINE VARIABLE x-nrodoc AS CHARACTER.
DEFINE VARIABLE x-genaut AS INTEGER.
DEFINE VARIABLE i        AS INTEGER.
DEFINE VARIABLE j        AS INTEGER.
DEFINE VARIABLE x-tpocmb AS DECIMAL.
DEFINE VARIABLE t-debe   AS DECIMAL.
DEFINE VARIABLE t-haber  AS DECIMAL.
DEFINE VARIABLE d-uno    AS DECIMAL.
DEFINE VARIABLE d-dos    AS DECIMAL.
DEFINE VARIABLE h-uno    AS DECIMAL.
DEFINE VARIABLE h-dos    AS DECIMAL.

DEFINE BUFFER detalle FOR CB-DMOV.

pto = SESSION:SET-WAIT-STATE("").

FIND FIRST t-prev NO-ERROR.
IF NOT AVAILABLE t-prev THEN DO:
    BELL.
    MESSAGE
        "No se ha generado " SKIP
        "ning£n preasiento"
    VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

FIND cb-cfga WHERE cb-cfga.codcia = cbd-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-cfga THEN DO:
    BELL.
    MESSAGE "Plan de cuentas no configurado"
    VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

FIND gn-tcmb WHERE gn-tcmb.FECHA = p-fchast NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-tcmb THEN DO:
    BELL.
    MESSAGE "Tipo de cambio para el" p-fchast "no Registrado"
    VIEW-AS ALERT-BOX.
    APPLY "ENTRY" TO FILL-IN-fchast IN FRAME {&FRAME-NAME}.
    RETURN.
END.
x-tpocmb = gn-tcmb.venta.

FIND FIRST CB-DMOV WHERE
    CB-DMOV.codcia  = p-codcia AND
    CB-DMOV.PERIODO = p-periodo AND
    CB-DMOV.NROMES  = p-mes AND
    CB-DMOV.CODOPE  = p-codope AND
    CB-DMOV.NROAST  = p-nroast NO-LOCK NO-ERROR.
IF AVAILABLE CB-DMOV THEN DO:
    BELL.
    MESSAGE
        "Ya se generar¢ el asiento contable" p-nroast SKIP
        "¨Desea reemplazarlos?"
        VIEW-AS ALERT-BOX WARNING
        BUTTONS YES-NO UPDATE sigue AS LOGICAL.
    IF sigue THEN DO:
        pto = SESSION:SET-WAIT-STATE("GENERAL").
        RUN anula-asto(
            p-codcia,
            p-periodo,
            p-mes,
            p-codope,
            p-nroast ).
    END.
    ELSE RETURN.
END.

CASE p-mes :
    WHEN 1 THEN x-nrodoc = "ENE" + STRING(p-periodo, '9999') .
    WHEN 2 THEN x-nrodoc = "FEB" + STRING(p-periodo, '9999') .
    WHEN 3 THEN x-nrodoc = "MAR" + STRING(p-periodo, '9999') .
    WHEN 4 THEN x-nrodoc = "ABR" + STRING(p-periodo, '9999') .
    WHEN 5 THEN x-nrodoc = "MAY" + STRING(p-periodo, '9999') .
    WHEN 6 THEN x-nrodoc = "JUN" + STRING(p-periodo, '9999') .
    WHEN 7 THEN x-nrodoc = "JUL" + STRING(p-periodo, '9999') .
    WHEN 8 THEN x-nrodoc = "AGO" + STRING(p-periodo, '9999') .
    WHEN 9 THEN x-nrodoc = "SET" + STRING(p-periodo, '9999') .
    WHEN 10 THEN x-nrodoc = "OCT" + STRING(p-periodo, '9999') .
    WHEN 11 THEN x-nrodoc = "NOV" + STRING(p-periodo, '9999') .
    WHEN 12 THEN x-nrodoc = "DIC" + STRING(p-periodo, '9999') .
END CASE.

x-glosa1 = PL-PLAN.DESPLN.
x-glosa2 = PL-CALC.DESCAL.

pto = SESSION:SET-WAIT-STATE("GENERAL").

FOR EACH t-prev NO-LOCK BREAK
    BY t-prev.coddiv
    BY t-prev.tpomov
    BY t-prev.codcta 
    BY t-prev.codaux:
    IF FIRST-OF(t-prev.coddiv) THEN DO:
        t-debe  = 0.
        t-haber = 0.
    END.
    IF FIRST-OF(t-prev.codcta) THEN DO:
        t-debe  = 0.
        t-haber = 0.
    END.
    IF FIRST-OF(t-prev.codaux) THEN DO:
        t-debe  = 0.
        t-haber = 0.
    END.
    IF t-prev.tpomov THEN t-haber = t-haber + t-prev.impmn1.
    ELSE t-debe = t-debe + t-prev.impmn1.

    IF LAST-OF(t-prev.coddiv) OR LAST-OF(t-prev.codcta) OR LAST-OF(t-prev.codaux)THEN DO:
        FIND cb-ctas WHERE
            cb-ctas.codcia = cbd-codcia AND
            cb-ctas.codcta = t-prev.codcta NO-LOCK NO-ERROR.
        IF NOT AVAILABLE cb-ctas THEN NEXT.
        x-clfaux = cb-ctas.clfaux.
        IF t-haber > 0 THEN DO:
            J = J + 1.
            CREATE CB-DMOV.
            CB-DMOV.codcia  = p-codcia.
            CB-DMOV.PERIODO = p-periodo.
            CB-DMOV.NROMES  = p-mes.
            CB-DMOV.CODOPE  = p-codope.
            CB-DMOV.NROAST  = p-nroast.
            CB-DMOV.NROITM  = J.
            CB-DMOV.codcta  = t-prev.codcta.
            CB-DMOV.coddiv  = t-prev.coddiv.
            CB-DMOV.cco     = t-prev.cco.
            Cb-dmov.Coddoc  = "".  /*"PLA".*/
            Cb-dmov.Nrodoc  = "".  /*x-nrodoc.*/
            CB-DMOV.clfaux  = x-clfaux.
            CB-DMOV.codaux  = t-prev.codaux.
            CB-DMOV.GLODOC  = x-glosa1 + "-" + x-glosa2 + "-" + x-nrodoc.
            CB-DMOV.tpomov  = TRUE.
            CB-DMOV.impmn1  = t-haber.
            CB-DMOV.impmn2  = 0. /*ROUND(t-haber / x-tpocmb,3).*/
            CB-DMOV.FCHDOC  = p-fchast.
            CB-DMOV.FCHVTO  = p-fchast.
            CB-DMOV.FLGACT  = TRUE.
            CB-DMOV.RELACION = 0.
            CB-DMOV.codmon  = 1.
            CB-DMOV.tpocmb  = 0. /*x-tpocmb.*/
            RUN cbd/cb-acmd.p(RECID(CB-DMOV),YES,YES).
            IF CB-DMOV.tpomov THEN DO:
                h-uno = h-uno + CB-DMOV.impmn1.
                h-dos = h-dos + CB-DMOV.impmn2.
            END.
            ELSE DO:
                d-uno = d-uno + CB-DMOV.impmn1.
                d-dos = d-dos + CB-DMOV.impmn2.
            END.
        END.
        IF t-debe > 0 THEN DO:
            J = J + 1.
            CREATE CB-DMOV.
            CB-DMOV.codcia  = p-codcia.
            CB-DMOV.PERIODO = p-periodo.
            CB-DMOV.NROMES  = p-mes.
            CB-DMOV.CODOPE  = p-codope.
            CB-DMOV.NROAST  = p-nroast.
            CB-DMOV.NROITM  = J.
            CB-DMOV.codcta  = t-prev.codcta.
            CB-DMOV.coddiv  = t-prev.coddiv.
            CB-DMOV.cco     = t-prev.cco.
            Cb-dmov.Coddoc  = "". /*"PLA".*/
            Cb-dmov.Nrodoc  = "". /*x-nrodoc.*/
            CB-DMOV.clfaux  = x-clfaux.
            CB-DMOV.codaux  = t-prev.codaux.
            CB-DMOV.GLODOC  = x-glosa1 + "-" + x-glosa2 + "-" + x-nrodoc.
            CB-DMOV.tpomov  = FALSE.
            CB-DMOV.impmn1  = t-debe.
            CB-DMOV.impmn2  = 0. /*ROUND(t-debe / x-tpocmb,3).*/
            CB-DMOV.FCHDOC  = p-fchast.
            CB-DMOV.FCHVTO  = p-fchast.
            CB-DMOV.FLGACT  = TRUE.
            CB-DMOV.RELACION = 0.
            CB-DMOV.codmon  = 1.
            CB-DMOV.tpocmb  = 0. /*x-tpocmb.*/
            RUN cbd/cb-acmd.p(RECID(CB-DMOV),YES,YES).
            IF CB-DMOV.tpomov THEN DO:
                h-uno = h-uno + CB-DMOV.impmn1.
                h-dos = h-dos + CB-DMOV.impmn2.
            END.
            ELSE DO:
                d-uno = d-uno + CB-DMOV.impmn1.
                d-dos = d-dos + CB-DMOV.impmn2.
            END.
        END.
        x-GenAut = 0.
        /* Preparando para Autom ticas */
        /* Verificamos si la Cuenta genera automaticas de Clase 9 */
        DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut9 ):
            IF cb-dmov.CodCta BEGINS ENTRY( i, cb-cfga.GenAut9 ) THEN DO:
                IF ENTRY( i, cb-cfga.GenAut9) <> "" THEN DO:
                    x-GenAut = 1.
                    LEAVE.
                END.
            END.
        END.
        /* Verificamos si la Cuenta genera automaticas de Clase 6 */
        DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut6 ):
            IF cb-dmov.CodCta BEGINS ENTRY( i, cb-cfga.GenAut6 ) THEN DO:
                IF ENTRY( i, cb-cfga.GenAut6) <> "" THEN DO:
                    x-GenAut = 2.
                    LEAVE.
                END.
           END.
        END.
        /* Verificamos si la Cuenta genera automaticas de otro tipo */
        DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut ):
            IF cb-dmov.CodCta BEGINS ENTRY( i, cb-cfga.GenAut ) THEN DO:
                IF ENTRY( i, cb-cfga.GenAut) <> "" THEN DO:
                    x-GenAut = 3.
                    LEAVE.
                END.
           END.
        END.
        cb-dmov.CtaAut = "".
        cb-dmov.CtrCta = "".
        CASE x-GenAut:
            /* Genera Cuentas Clase 9 */
            WHEN 1 THEN DO:
                cb-dmov.CtrCta = cb-ctas.Cc1Cta.
                cb-dmov.CtaAut = cb-ctas.An1Cta.
                IF cb-dmov.CtrCta = "" THEN cb-dmov.CtrCta = cb-cfga.Cc1Cta9.
            END.
            /* Genera Cuentas Clase 6 */
            WHEN 2 THEN DO:
                cb-dmov.CtrCta = cb-ctas.Cc1Cta.
                cb-dmov.CtaAut = cb-ctas.An1Cta.
                IF cb-dmov.CtrCta = "" THEN
                    cb-dmov.CtrCta = cb-cfga.Cc1Cta6.
            END.
            WHEN 3 THEN DO:
                cb-dmov.CtaAut = cb-ctas.An1Cta.
                cb-dmov.CtrCta = cb-ctas.Cc1Cta.
            END.
        END CASE.
        /* Chequendo las cuentas a generar en forma autom tica */
        IF x-GenAut > 0 THEN DO:
            IF NOT CAN-FIND(FIRST cb-ctas WHERE
                cb-ctas.CodCia = cbd-codcia AND
                cb-ctas.CodCta = cb-dmov.CtaAut) THEN DO:
                BELL.
                MESSAGE
                    "Cuentas Autom ticas a generar" SKIP
                    "Tienen mal registro, Cuenta" cb-dmov.CtaAut "no existe"
                    VIEW-AS ALERT-BOX ERROR.
                cb-dmov.CtaAut = "".
            END.
            IF NOT CAN-FIND( cb-ctas WHERE
                cb-ctas.CodCia = cbd-codcia AND
                cb-ctas.CodCta = cb-dmov.CtrCta ) THEN DO:
                BELL.
                MESSAGE
                    "Cuentas Autom ticas a generar" SKIP
                    "Tienen mal registro, Contra Cuenta" cb-dmov.CtrCta "no existe"
                    VIEW-AS ALERT-BOX ERROR.
                cb-dmov.CtrCta = "".
            END.
        END. /*Fin del x-genaut > 0 */
        IF cb-dmov.CtaAut <> "" AND cb-dmov.CtrCta <> "" THEN DO:
            J = J + 1.
            CREATE detalle.
            detalle.CodCia   = cb-dmov.CodCia.
            detalle.Periodo  = cb-dmov.Periodo.
            detalle.NroMes   = cb-dmov.NroMes.
            detalle.CodOpe   = cb-dmov.CodOpe.
            detalle.NroAst   = cb-dmov.NroAst.
            detalle.TpoItm   = "A".
            detalle.Relacion = RECID(cb-dmov).
            detalle.CodMon   = cb-dmov.CodMon.
            detalle.TpoCmb   = cb-dmov.TpoCmb.
            detalle.NroItm   = cb-dmov.NroItm.
            detalle.Codcta   = cb-dmov.CtaAut.
            detalle.CodDiv   = cb-dmov.CodDiv.
            detalle.ClfAux   = cb-dmov.ClfAux.
            detalle.CodAux   = cb-dmov.CodCta.
            detalle.NroRuc   = cb-dmov.NroRuc.
            detalle.CodDoc   = cb-dmov.CodDoc.
            detalle.NroDoc   = cb-dmov.NroDoc.
            detalle.GloDoc   = cb-dmov.GloDoc.
            detalle.CodMon   = cb-dmov.CodMon.
            detalle.TpoCmb   = cb-dmov.TpoCmb.
            detalle.TpoMov   = cb-dmov.TpoMov.
            detalle.NroRef   = cb-dmov.NroRef.
            detalle.FchDoc   = cb-dmov.FchDoc.
            detalle.FchVto   = cb-dmov.FchVto.
            detalle.ImpMn1   = cb-dmov.ImpMn1.
            detalle.ImpMn2   = cb-dmov.ImpMn2.
            detalle.ImpMn3   = cb-dmov.ImpMn3.
            detalle.Tm       = cb-dmov.Tm.
            detalle.CCO      = cb-dmov.CCO.
            RUN cbd/cb-acmd.p(RECID(detalle), YES ,YES).
            IF detalle.tpomov THEN DO:
                h-uno = h-uno + detalle.impmn1.
                h-dos = h-dos + detalle.impmn2.
            END.
            ELSE DO:
                d-uno = d-uno + CB-DMOV.impmn1.
                d-dos = d-dos + CB-DMOV.impmn2.
            END.
            J = J + 1.
            CREATE detalle.
            detalle.CodCia   = cb-dmov.CodCia.
            detalle.Periodo  = cb-dmov.Periodo.
            detalle.NroMes   = cb-dmov.NroMes.
            detalle.CodOpe   = cb-dmov.CodOpe.
            detalle.NroAst   = cb-dmov.NroAst.
            detalle.TpoItm   = "A".
            detalle.Relacion = RECID(cb-dmov).
            detalle.CodMon   = cb-dmov.CodMon.
            detalle.TpoCmb   = cb-dmov.TpoCmb.
            detalle.NroItm   = cb-dmov.NroItm.
            detalle.Codcta   = cb-dmov.Ctrcta.
            detalle.CodDiv   = cb-dmov.CodDiv.
            detalle.ClfAux   = cb-dmov.ClfAux.
            detalle.CodAux   = cb-dmov.CodCta.
            detalle.NroRuc   = cb-dmov.NroRuc.
            detalle.CodDoc   = cb-dmov.CodDoc.
            detalle.NroDoc   = cb-dmov.NroDoc.
            detalle.GloDoc   = cb-dmov.GloDoc.
            detalle.CodMon   = cb-dmov.CodMon.
            detalle.TpoCmb   = cb-dmov.TpoCmb.
            detalle.TpoMov   = NOT cb-dmov.TpoMov.
            detalle.ImpMn1   = cb-dmov.ImpMn1.
            detalle.ImpMn2   = cb-dmov.ImpMn2.
            detalle.ImpMn3   = cb-dmov.ImpMn3.
            detalle.NroRef   = cb-dmov.NroRef.
            detalle.FchDoc   = cb-dmov.FchDoc.
            detalle.FchVto   = cb-dmov.FchVto.
            detalle.Tm       = cb-dmov.Tm.
            detalle.CCO      = cb-dmov.CCO.
            RUN cbd/cb-acmd.p(RECID(detalle), YES ,YES).
            IF detalle.tpomov THEN DO:
                h-uno = h-uno + detalle.impmn1.
                h-dos = h-dos + detalle.impmn2.
            END.
            ELSE DO:
                d-uno = d-uno + CB-DMOV.impmn1.
                d-dos = d-dos + CB-DMOV.impmn2.
            END.
        END.
    END.
END.

FIND cb-cmov WHERE
    cb-cmov.codcia  = p-codcia AND
    cb-cmov.PERIODO = p-periodo AND
    cb-cmov.NROMES  = p-mes AND
    cb-cmov.CODOPE  = p-codope AND
    cb-cmov.NROAST  = p-nroast NO-ERROR.
IF NOT AVAILABLE cb-cmov THEN DO:
    CREATE cb-cmov.
    cb-cmov.codcia  = p-codcia.
    cb-cmov.PERIODO = p-periodo.
    cb-cmov.NROMES  = p-mes.
    cb-cmov.CODOPE  = p-codope.
    cb-cmov.NROAST  = p-nroast.
END.
cb-cmov.Fchast = FILL-IN-fchast.
cb-cmov.TOTITM = J.
cb-cmov.CODMON = 1.
cb-cmov.TPOCMB = 0. /*x-tpocmb.*/
cb-cmov.DBEMN1 = d-uno.
cb-cmov.DBEMN2 = d-dos.
cb-cmov.HBEMN1 = h-uno.
cb-cmov.HBEMN2 = h-dos.
cb-cmov.NOTAST = x-glosa1 + "-" + x-glosa2 + "-" + x-nrodoc.
cb-cmov.GLOAST = x-glosa1 + "-" + x-glosa2 + "-" + x-nrodoc.

pto = SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE transferir-astoxcc V-table-Win 
PROCEDURE transferir-astoxcc :
DEFINE INPUT PARAMETER p-codcia  AS INTEGER.
DEFINE INPUT PARAMETER p-periodo AS INTEGER.
DEFINE INPUT PARAMETER p-mes     AS INTEGER.
DEFINE INPUT PARAMETER p-codope  AS CHARACTER.
DEFINE INPUT PARAMETER p-fchast  AS DATE.

DEFINE VARIABLE a-nroast AS CHARACTER.
DEFINE VARIABLE x-glosa1 AS CHARACTER.
DEFINE VARIABLE x-clfaux AS CHARACTER.
DEFINE VARIABLE x-nrodoc AS CHARACTER.
DEFINE VARIABLE x-genaut AS INTEGER.
DEFINE VARIABLE i        AS INTEGER.
DEFINE VARIABLE j        AS INTEGER.
DEFINE VARIABLE x-tpocmb AS DECIMAL.
DEFINE VARIABLE t-debe   AS DECIMAL.
DEFINE VARIABLE t-haber  AS DECIMAL.
DEFINE VARIABLE d-uno    AS DECIMAL.
DEFINE VARIABLE d-dos    AS DECIMAL.
DEFINE VARIABLE h-uno    AS DECIMAL.
DEFINE VARIABLE h-dos    AS DECIMAL.

DEFINE BUFFER detalle FOR CB-DMOV.

pto = SESSION:SET-WAIT-STATE("").

FIND FIRST t-prev NO-ERROR.
IF NOT AVAILABLE t-prev THEN DO:
    BELL.
    MESSAGE
        "No se ha generado " SKIP
        "ning£n preasiento"
    VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

FIND cb-cfga WHERE cb-cfga.codcia = cbd-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-cfga THEN DO:
    BELL.
    MESSAGE "Plan de cuentas no configurado"
    VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

FIND gn-tcmb WHERE gn-tcmb.FECHA = p-fchast NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-tcmb THEN DO:
    BELL.
    MESSAGE "Tipo de cambio para el" p-fchast "no Registrado"
    VIEW-AS ALERT-BOX.
    APPLY "ENTRY" TO FILL-IN-fchast IN FRAME {&FRAME-NAME}.
    RETURN.
END.
x-tpocmb = gn-tcmb.venta.

BELL.
MESSAGE
    "Si se han generado los asientos contable por" SKIP
    "Centros de Costo, ser n eliminados." SKIP
    "¨Desea continuar?"
    VIEW-AS ALERT-BOX WARNING
        BUTTONS YES-NO UPDATE sigue AS LOGICAL.
IF sigue THEN DO:
    pto = SESSION:SET-WAIT-STATE("GENERAL").
    FOR EACH GN-CCOS WHERE GN-CCOS.codcia = s-codcia NO-LOCK:
        a-nroast = STRING(CMB-mes,"99") + 
            IF PL-PLAN.tippln THEN STRING(PL-CALC.codpln,"99") + SUBSTRING(GN-CCOS.codcco,1,2)
            ELSE STRING(CMB-sem,"99") + SUBSTRING(GN-CCOS.codcco,1,2).
        RUN anula-asto(
            p-codcia,
            p-periodo,
            p-mes,
            p-codope,
            a-nroast ).
    END.
END.
ELSE RETURN.

CASE p-mes :
    WHEN 1 THEN x-nrodoc = "ENE" + STRING(p-periodo, '9999').
    WHEN 2 THEN x-nrodoc = "FEB" + STRING(p-periodo, '9999').
    WHEN 3 THEN x-nrodoc = "MAR" + STRING(p-periodo, '9999').
    WHEN 4 THEN x-nrodoc = "ABR" + STRING(p-periodo, '9999').
    WHEN 5 THEN x-nrodoc = "MAY" + STRING(p-periodo, '9999').
    WHEN 6 THEN x-nrodoc = "JUN" + STRING(p-periodo, '9999').
    WHEN 7 THEN x-nrodoc = "JUL" + STRING(p-periodo, '9999').
    WHEN 8 THEN x-nrodoc = "AGO" + STRING(p-periodo, '9999').
    WHEN 9 THEN x-nrodoc = "SET" + STRING(p-periodo, '9999').
    WHEN 10 THEN x-nrodoc = "OCT" + STRING(p-periodo, '9999').
    WHEN 11 THEN x-nrodoc = "NOV" + STRING(p-periodo, '9999').
    WHEN 12 THEN x-nrodoc = "DIC" + STRING(p-periodo, '9999').
END CASE.

pto = SESSION:SET-WAIT-STATE("GENERAL").

FOR EACH t-prev NO-LOCK BREAK
    BY t-prev.cco
    BY t-prev.tpomov
    BY t-prev.codcta:
    IF FIRST-OF(t-prev.cco) THEN DO:
        x-glosa1 = PL-PLAN.DESPLN + "-" + PL-CALC.DESCAL + " " +
            IF PL-PLAN.tippln THEN "Mes " + STRING(CMB-sem,"99")
            ELSE "Semana " + STRING(CMB-sem,"99").
        FIND GN-CCOS WHERE
            GN-CCOS.codcia = s-codcia AND
            GN-CCOS.codcco = t-prev.cco NO-LOCK NO-ERROR.
        IF AVAILABLE GN-CCOS THEN
            x-glosa1 = x-glosa1 + " C.C. " + GN-CCOS.DesCco.
        a-nroast = STRING(CMB-mes,"99") + IF PL-PLAN.tippln 
            THEN STRING(PL-CALC.codpln,"99") + SUBSTRING(t-prev.cco,1,2)
            ELSE STRING(CMB-sem,"99") + SUBSTRING(t-prev.cco,1,2).
        J     = 0.
        h-uno = 0.
        h-dos = 0.
        d-uno = 0.
        d-dos = 0.
    END.
    IF FIRST-OF(t-prev.codcta) THEN DO:
        t-debe  = 0.
        t-haber = 0.
    END.
    IF t-prev.tpomov THEN t-haber = t-haber + t-prev.impmn1.
    ELSE t-debe = t-debe + t-prev.impmn1.
    IF LAST-OF(t-prev.codcta) THEN DO:
        FIND cb-ctas WHERE
            cb-ctas.codcia = cbd-codcia AND
            cb-ctas.codcta = t-prev.codcta NO-LOCK NO-ERROR.
        IF NOT AVAILABLE cb-ctas THEN NEXT.
        x-clfaux = cb-ctas.clfaux.
        IF t-haber > 0 THEN DO:
            J = J + 1.
            CREATE CB-DMOV.
            CB-DMOV.codcia  = p-codcia.
            CB-DMOV.PERIODO = p-periodo.
            CB-DMOV.NROMES  = p-mes.
            CB-DMOV.CODOPE  = p-codope.
            CB-DMOV.NROAST  = a-nroast.
            CB-DMOV.NROITM  = J.
            CB-DMOV.codcta  = t-prev.codcta.
            CB-DMOV.coddiv  = t-prev.cco.
            CB-DMOV.cco     = t-prev.cco.
            Cb-dmov.Coddoc  = "PLA".
            Cb-dmov.Nrodoc  = x-nrodoc.
            CB-DMOV.clfaux  = x-clfaux.
            CB-DMOV.GLODOC  = x-glosa1.
            CB-DMOV.tpomov  = TRUE.
            CB-DMOV.impmn1  = t-haber.
            CB-DMOV.impmn2  = ROUND(t-haber / x-tpocmb,4).
            CB-DMOV.FCHDOC  = p-fchast.
            CB-DMOV.FCHVTO  = p-fchast.
            CB-DMOV.FLGACT  = TRUE.
            CB-DMOV.RELACION = 0.
            CB-DMOV.codmon  = 1.
            CB-DMOV.tpocmb  = x-tpocmb.
            RUN cbd/cb-acmd.p(RECID(CB-DMOV),YES,YES).
            IF CB-DMOV.tpomov THEN DO:
                h-uno = h-uno + CB-DMOV.impmn1.
                h-dos = h-dos + CB-DMOV.impmn2.
            END.
            ELSE DO:
                d-uno = d-uno + CB-DMOV.impmn1.
                d-dos = d-dos + CB-DMOV.impmn2.
            END.
        END.
        IF t-debe > 0 THEN DO:
            J = J + 1.
            CREATE CB-DMOV.
            CB-DMOV.codcia  = p-codcia.
            CB-DMOV.PERIODO = p-periodo.
            CB-DMOV.NROMES  = p-mes.
            CB-DMOV.CODOPE  = p-codope.
            CB-DMOV.NROAST  = a-nroast.
            CB-DMOV.NROITM  = J.
            CB-DMOV.codcta  = t-prev.codcta.
            CB-DMOV.coddiv  = t-prev.cco.
            CB-DMOV.cco     = t-prev.cco.
            Cb-dmov.Coddoc  = "PLA".
            Cb-dmov.Nrodoc  = x-nrodoc.
            CB-DMOV.clfaux  = x-clfaux.
            CB-DMOV.GLODOC  = x-glosa1.
            CB-DMOV.tpomov  = FALSE.
            CB-DMOV.impmn1  = t-debe.
            CB-DMOV.impmn2  = ROUND(t-debe / x-tpocmb,4).
            CB-DMOV.FCHDOC  = p-fchast.
            CB-DMOV.FCHVTO  = p-fchast.
            CB-DMOV.FLGACT  = TRUE.
            CB-DMOV.RELACION = 0.
            CB-DMOV.codmon  = 1.
            CB-DMOV.tpocmb  = x-tpocmb.
            RUN cbd/cb-acmd.p(RECID(CB-DMOV),YES,YES).
            IF CB-DMOV.tpomov THEN DO:
                h-uno = h-uno + CB-DMOV.impmn1.
                h-dos = h-dos + CB-DMOV.impmn2.
            END.
            ELSE DO:
                d-uno = d-uno + CB-DMOV.impmn1.
                d-dos = d-dos + CB-DMOV.impmn2.
            END.
        END.
        x-GenAut = 0.
        /* Preparando para Autom ticas */
        /* Verificamos si la Cuenta genera automaticas de Clase 9 */
        DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut9 ):
            IF cb-dmov.CodCta BEGINS ENTRY( i, cb-cfga.GenAut9 ) THEN DO:
                IF ENTRY( i, cb-cfga.GenAut9) <> "" THEN DO:
                    x-GenAut = 1.
                    LEAVE.
                END.
            END.
        END.
        /* Verificamos si la Cuenta genera automaticas de Clase 6 */
        DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut6 ):
            IF cb-dmov.CodCta BEGINS ENTRY( i, cb-cfga.GenAut6 ) THEN DO:
                IF ENTRY( i, cb-cfga.GenAut6) <> "" THEN DO:
                    x-GenAut = 2.
                    LEAVE.
                END.
           END.
        END.
        /* Verificamos si la Cuenta genera automaticas de otro tipo */
        DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut ):
            IF cb-dmov.CodCta BEGINS ENTRY( i, cb-cfga.GenAut ) THEN DO:
                IF ENTRY( i, cb-cfga.GenAut) <> "" THEN DO:
                    x-GenAut = 3.
                    LEAVE.
                END.
           END.
        END.
        cb-dmov.CtaAut = "".
        cb-dmov.CtrCta = "".
        CASE x-GenAut:
            /* Genera Cuentas Clase 9 */
            WHEN 1 THEN DO:
                cb-dmov.CtrCta = cb-ctas.Cc1Cta.
                cb-dmov.CtaAut = cb-ctas.An1Cta.
                IF cb-dmov.CtrCta = "" THEN cb-dmov.CtrCta = cb-cfga.Cc1Cta9.
            END.
            /* Genera Cuentas Clase 6 */
            WHEN 2 THEN DO:
                cb-dmov.CtrCta = cb-ctas.Cc1Cta.
                cb-dmov.CtaAut = cb-ctas.An1Cta.
                IF cb-dmov.CtrCta = "" THEN
                    cb-dmov.CtrCta = cb-cfga.Cc1Cta6.
            END.
            WHEN 3 THEN DO:
                cb-dmov.CtaAut = cb-ctas.An1Cta.
                cb-dmov.CtrCta = cb-ctas.Cc1Cta.
            END.
        END CASE.
        /* Chequendo las cuentas a generar en forma autom tica */
        IF x-GenAut > 0 THEN DO:
            IF NOT CAN-FIND(FIRST cb-ctas WHERE
                cb-ctas.CodCia = cbd-codcia AND
                cb-ctas.CodCta = cb-dmov.CtaAut) THEN DO:
                BELL.
                MESSAGE
                    "Cuentas Autom ticas a generar" SKIP
                    "Tienen mal registro, Cuenta" cb-dmov.CtaAut "no existe"
                    VIEW-AS ALERT-BOX ERROR.
                cb-dmov.CtaAut = "".
            END.
            IF NOT CAN-FIND( cb-ctas WHERE
                cb-ctas.CodCia = cbd-codcia AND
                cb-ctas.CodCta = cb-dmov.CtrCta ) THEN DO:
                BELL.
                MESSAGE
                    "Cuentas Autom ticas a generar" SKIP
                    "Tienen mal registro, Contra Cuenta" cb-dmov.CtrCta "no existe"
                    VIEW-AS ALERT-BOX ERROR.
                cb-dmov.CtrCta = "".
            END.
        END. /*Fin del x-genaut > 0 */
        IF cb-dmov.CtaAut <> "" AND cb-dmov.CtrCta <> "" THEN DO:
            J = J + 1.
            CREATE detalle.
            detalle.CodCia   = cb-dmov.CodCia.
            detalle.Periodo  = cb-dmov.Periodo.
            detalle.NroMes   = cb-dmov.NroMes.
            detalle.CodOpe   = cb-dmov.CodOpe.
            detalle.NroAst   = cb-dmov.NroAst.
            detalle.TpoItm   = "A".
            detalle.Relacion = RECID(cb-dmov).
            detalle.CodMon   = cb-dmov.CodMon.
            detalle.TpoCmb   = cb-dmov.TpoCmb.
            detalle.NroItm   = cb-dmov.NroItm.
            detalle.Codcta   = cb-dmov.CtaAut.
            detalle.CodDiv   = cb-dmov.CodDiv.
            detalle.ClfAux   = cb-dmov.ClfAux.
            detalle.CodAux   = cb-dmov.CodCta.
            detalle.NroRuc   = cb-dmov.NroRuc.
            detalle.CodDoc   = cb-dmov.CodDoc.
            detalle.NroDoc   = cb-dmov.NroDoc.
            detalle.GloDoc   = cb-dmov.GloDoc.
            detalle.CodMon   = cb-dmov.CodMon.
            detalle.TpoCmb   = cb-dmov.TpoCmb.
            detalle.TpoMov   = cb-dmov.TpoMov.
            detalle.NroRef   = cb-dmov.NroRef.
            detalle.FchDoc   = cb-dmov.FchDoc.
            detalle.FchVto   = cb-dmov.FchVto.
            detalle.ImpMn1   = cb-dmov.ImpMn1.
            detalle.ImpMn2   = cb-dmov.ImpMn2.
            detalle.ImpMn3   = cb-dmov.ImpMn3.
            detalle.Tm       = cb-dmov.Tm.
            detalle.CCO      = cb-dmov.CCO.
            RUN cbd/cb-acmd.p(RECID(detalle), YES ,YES).
            IF detalle.tpomov THEN DO:
                h-uno = h-uno + detalle.impmn1.
                h-dos = h-dos + detalle.impmn2.
            END.
            ELSE DO:
                d-uno = d-uno + CB-DMOV.impmn1.
                d-dos = d-dos + CB-DMOV.impmn2.
            END.
            J = J + 1.
            CREATE detalle.
            detalle.CodCia   = cb-dmov.CodCia.
            detalle.Periodo  = cb-dmov.Periodo.
            detalle.NroMes   = cb-dmov.NroMes.
            detalle.CodOpe   = cb-dmov.CodOpe.
            detalle.NroAst   = cb-dmov.NroAst.
            detalle.TpoItm   = "A".
            detalle.Relacion = RECID(cb-dmov).
            detalle.CodMon   = cb-dmov.CodMon.
            detalle.TpoCmb   = cb-dmov.TpoCmb.
            detalle.NroItm   = cb-dmov.NroItm.
            detalle.Codcta   = cb-dmov.Ctrcta.
            detalle.CodDiv   = cb-dmov.CodDiv.
            detalle.ClfAux   = cb-dmov.ClfAux.
            detalle.CodAux   = cb-dmov.CodCta.
            detalle.NroRuc   = cb-dmov.NroRuc.
            detalle.CodDoc   = cb-dmov.CodDoc.
            detalle.NroDoc   = cb-dmov.NroDoc.
            detalle.GloDoc   = cb-dmov.GloDoc.
            detalle.CodMon   = cb-dmov.CodMon.
            detalle.TpoCmb   = cb-dmov.TpoCmb.
            detalle.TpoMov   = NOT cb-dmov.TpoMov.
            detalle.ImpMn1   = cb-dmov.ImpMn1.
            detalle.ImpMn2   = cb-dmov.ImpMn2.
            detalle.ImpMn3   = cb-dmov.ImpMn3.
            detalle.NroRef   = cb-dmov.NroRef.
            detalle.FchDoc   = cb-dmov.FchDoc.
            detalle.FchVto   = cb-dmov.FchVto.
            detalle.Tm       = cb-dmov.Tm.
            detalle.CCO      = cb-dmov.CCO.
            RUN cbd/cb-acmd.p(RECID(detalle), YES ,YES).
            IF detalle.tpomov THEN DO:
                h-uno = h-uno + detalle.impmn1.
                h-dos = h-dos + detalle.impmn2.
            END.
            ELSE DO:
                d-uno = d-uno + CB-DMOV.impmn1.
                d-dos = d-dos + CB-DMOV.impmn2.
            END.
        END.
    END.
    IF LAST-OF(t-prev.cco) THEN DO:
        FIND cb-cmov WHERE
            cb-cmov.codcia  = p-codcia AND
            cb-cmov.PERIODO = p-periodo AND
            cb-cmov.NROMES  = p-mes AND
            cb-cmov.CODOPE  = p-codope AND
            cb-cmov.NROAST  = a-nroast NO-ERROR.
        IF NOT AVAILABLE cb-cmov THEN DO:
            CREATE cb-cmov.
            cb-cmov.codcia  = p-codcia.
            cb-cmov.PERIODO = p-periodo.
            cb-cmov.NROMES  = p-mes.
            cb-cmov.CODOPE  = p-codope.
            cb-cmov.NROAST  = a-nroast.
        END.
        cb-cmov.Fchast = FILL-IN-fchast.
        cb-cmov.TOTITM = J.
        cb-cmov.CODMON = 1.
        cb-cmov.TPOCMB = x-tpocmb.
        cb-cmov.DBEMN1 = d-uno.
        cb-cmov.DBEMN2 = d-dos.
        cb-cmov.HBEMN1 = h-uno.
        cb-cmov.HBEMN2 = h-dos.
        cb-cmov.NOTAST = x-glosa1.
        cb-cmov.GLOAST = x-glosa1.
    END.
END.

pto = SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

