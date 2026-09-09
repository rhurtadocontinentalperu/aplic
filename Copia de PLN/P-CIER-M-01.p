&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
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

DEFINE VARIABLE x-periodo    AS INTEGER NO-UNDO.
DEFINE VARIABLE x-nromes     AS INTEGER NO-UNDO.
DEFINE VARIABLE x-fchini     AS DATE    NO-UNDO.
DEFINE VARIABLE x-fchfin     AS DATE    NO-UNDO.
DEFINE VARIABLE x-ultfch     AS DATE    NO-UNDO.
DEFINE VARIABLE x-valcal-mes AS DECIMAL NO-UNDO.

IF s-nromes = 12 THEN DO:
    ASSIGN
        x-nromes = 1
        x-periodo = s-periodo + 1.
    FIND LAST integral.PL-SEM WHERE
        integral.PL-SEM.CodCia  = s-CodCia AND
        integral.PL-SEM.Periodo = x-periodo NO-LOCK NO-ERROR.
    IF AVAILABLE integral.PL-SEM THEN x-ultfch = integral.PL-SEM.FecFin.
    ELSE x-ultfch = date( 1, 1, x-periodo).
    RUN @genera-periodo.
END.
ELSE DO:
    ASSIGN
        x-nromes = s-nromes + 1
        x-periodo = s-periodo.
END.

ASSIGN x-fchini = DATE( x-nromes, 1, x-periodo).
IF x-nromes = 12 THEN ASSIGN x-fchfin = DATE( 12, 31, x-periodo).
ELSE ASSIGN x-fchfin = DATE( x-nromes + 1, 1, x-periodo) - 1.

DEFINE BUFFER b-FLG-MES     FOR integral.PL-FLG-MES.
DEFINE BUFFER b-MOV-MES     FOR integral.PL-MOV-MES.
DEFINE BUFFER b-CFG-CTE-MES FOR integral.PL-CFG-CTE-MES.
DEFINE BUFFER b-VAR-SEM     FOR integral.PL-VAR-SEM.
DEFINE BUFFER b-VAR-MES     FOR integral.PL-VAR-MES.
DEFINE BUFFER b-DHABIENTE   FOR integral.PL-DHABIENTE.  /* Derechohabiente */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Codigo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img/b-cancel":U
     LABEL "Cancel" 
     SIZE 11.57 BY 1.46
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/b-ok":U
     LABEL "OK" 
     SIZE 11.57 BY 1.46
     BGCOLOR 8 .

DEFINE VARIABLE FILL-IN-Codigo AS CHARACTER FORMAT "X(6)":U 
     LABEL "Procesando cierre para personal" 
     VIEW-AS FILL-IN 
     SIZE 7.57 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 47.57 BY 4.12
     BGCOLOR 8 FGCOLOR 0 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     Btn_OK AT ROW 1.42 COL 35.14
     Btn_Cancel AT ROW 3.23 COL 35.14
     FILL-IN-Codigo AT ROW 4 COL 23.14 COLON-ALIGNED
     "El presente proceso consiste en cerrar" VIEW-AS TEXT
          SIZE 27.29 BY .69 AT ROW 1.19 COL 5
     "el mes actual e inicializar el siguiente." VIEW-AS TEXT
          SIZE 26.86 BY .69 AT ROW 1.88 COL 2.43
     "Por lo tanto no deber  ejecutarse otro proceso" VIEW-AS TEXT
          SIZE 32.72 BY .69 AT ROW 2.62 COL 2.43
     "sobre le sistema." VIEW-AS TEXT
          SIZE 12.43 BY .69 AT ROW 3.35 COL 2.43
     RECT-2 AT ROW 1 COL 1
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Cierre de Mes".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME                                                           */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-Codigo IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON GO OF FRAME D-Dialog /* Cierre de Mes */
DO:
    ASSIGN
        Btn_Cancel:SENSITIVE = FALSE
        Btn_OK:SENSITIVE = FALSE
        FILL-IN-Codigo:VISIBLE = TRUE.
    RUN @cierre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Cierre de Mes */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

ASSIGN
    FRAME D-dialog:TITLE = "Cierre de Semana # " + STRING(s-NroMes, "99")
    FILL-IN-Codigo:VISIBLE = FALSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE @actualiza-variables D-Dialog 
PROCEDURE @actualiza-variables :
FIND LAST integral.PL-VAR-SEM WHERE
    integral.PL-VAR-SEM.Periodo = s-Periodo AND
    integral.PL-VAR-SEM.NroSem <= s-NroSem NO-LOCK NO-ERROR.
IF AVAILABLE integral.PL-VAR-SEM THEN DO:
    FIND LAST b-VAR-SEM WHERE
        b-VAR-SEM.Periodo = x-Periodo AND
        b-VAR-SEM.NroSem = 1 NO-ERROR.
    IF NOT AVAILABLE b-VAR-SEM THEN DO:
        CREATE b-VAR-SEM.
        ASSIGN
            b-VAR-SEM.Periodo       = x-Periodo
            b-VAR-SEM.NroSem        = 1
            b-VAR-SEM.ValVar-SEM[1] = PL-VAR-SEM.ValVar-SEM[1]
            b-VAR-SEM.ValVar-SEM[2] = PL-VAR-SEM.ValVar-SEM[2]
            b-VAR-SEM.ValVar-SEM[3] = PL-VAR-SEM.ValVar-SEM[3]
            b-VAR-SEM.ValVar-SEM[4] = PL-VAR-SEM.ValVar-SEM[4]
            b-VAR-SEM.ValVar-SEM[5] = PL-VAR-SEM.ValVar-SEM[5]
            b-VAR-SEM.ValVar-SEM[6] = PL-VAR-SEM.ValVar-SEM[6]
            b-VAR-SEM.ValVar-SEM[7] = PL-VAR-SEM.ValVar-SEM[7]
            b-VAR-SEM.ValVar-SEM[8] = PL-VAR-SEM.ValVar-SEM[8]
            b-VAR-SEM.ValVar-SEM[9] = PL-VAR-SEM.ValVar-SEM[9]
            b-VAR-SEM.ValVar-SEM[10] = PL-VAR-SEM.ValVar-SEM[10]
            b-VAR-SEM.ValVar-SEM[11] = PL-VAR-SEM.ValVar-SEM[11]
            b-VAR-SEM.ValVar-SEM[12] = PL-VAR-SEM.ValVar-SEM[12]
            b-VAR-SEM.ValVar-SEM[13] = PL-VAR-SEM.ValVar-SEM[13]
            b-VAR-SEM.ValVar-SEM[14] = PL-VAR-SEM.ValVar-SEM[14]
            b-VAR-SEM.ValVar-SEM[15] = PL-VAR-SEM.ValVar-SEM[15]
            b-VAR-SEM.ValVar-SEM[16] = PL-VAR-SEM.ValVar-SEM[16]
            b-VAR-SEM.ValVar-SEM[17] = PL-VAR-SEM.ValVar-SEM[17]
            b-VAR-SEM.ValVar-SEM[18] = PL-VAR-SEM.ValVar-SEM[18]
            b-VAR-SEM.ValVar-SEM[19] = PL-VAR-SEM.ValVar-SEM[19]
            b-VAR-SEM.ValVar-SEM[20] = PL-VAR-SEM.ValVar-SEM[20].
    END.
END.

FIND LAST integral.PL-VAR-MES WHERE
    integral.PL-VAR-MES.Periodo = s-Periodo AND
    integral.PL-VAR-MES.NroMes <= s-NroMes NO-LOCK NO-ERROR.
IF AVAILABLE integral.PL-VAR-MES THEN DO:
    FIND LAST b-VAR-MES WHERE
        b-VAR-MES.Periodo = x-Periodo AND
        b-VAR-MES.NroMes = 1 NO-ERROR.
    IF NOT AVAILABLE b-VAR-MES THEN DO:
        CREATE b-VAR-MES.
        ASSIGN
            b-VAR-MES.Periodo = x-Periodo
            b-VAR-MES.NroMes  = 1.
    END.
    ASSIGN
        b-VAR-MES.ValVAR-MES[1] = PL-VAR-MES.ValVAR-MES[1]
        b-VAR-MES.ValVAR-MES[2] = PL-VAR-MES.ValVAR-MES[2]
        b-VAR-MES.ValVAR-MES[3] = PL-VAR-MES.ValVAR-MES[3]
        b-VAR-MES.ValVAR-MES[4] = PL-VAR-MES.ValVAR-MES[4]
        b-VAR-MES.ValVAR-MES[5] = PL-VAR-MES.ValVAR-MES[5]
        b-VAR-MES.ValVAR-MES[6] = PL-VAR-MES.ValVAR-MES[6]
        b-VAR-MES.ValVAR-MES[7] = PL-VAR-MES.ValVAR-MES[7]
        b-VAR-MES.ValVAR-MES[8] = PL-VAR-MES.ValVAR-MES[8]
        b-VAR-MES.ValVAR-MES[9] = PL-VAR-MES.ValVAR-MES[9]
        b-VAR-MES.ValVAR-MES[10] = PL-VAR-MES.ValVAR-MES[10]
        b-VAR-MES.ValVAR-MES[11] = PL-VAR-MES.ValVAR-MES[11]
        b-VAR-MES.ValVAR-MES[12] = PL-VAR-MES.ValVAR-MES[12]
        b-VAR-MES.ValVAR-MES[13] = PL-VAR-MES.ValVAR-MES[13]
        b-VAR-MES.ValVAR-MES[14] = PL-VAR-MES.ValVAR-MES[14]
        b-VAR-MES.ValVAR-MES[15] = PL-VAR-MES.ValVAR-MES[15]
        b-VAR-MES.ValVAR-MES[16] = PL-VAR-MES.ValVAR-MES[16]
        b-VAR-MES.ValVAR-MES[17] = PL-VAR-MES.ValVAR-MES[17]
        b-VAR-MES.ValVAR-MES[18] = PL-VAR-MES.ValVAR-MES[18]
        b-VAR-MES.ValVAR-MES[19] = PL-VAR-MES.ValVAR-MES[19]
        b-VAR-MES.ValVAR-MES[20] = PL-VAR-MES.ValVAR-MES[20].
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE @cierre D-Dialog 
PROCEDURE @cierre :
FOR EACH PL-FLG-MES WHERE
    PL-FLG-MES.CodCia  = s-codcia  AND
    PL-FLG-MES.Periodo = s-periodo AND
    PL-FLG-MES.NroMes  = s-nromes  NO-LOCK:

    IF PL-FLG-MES.SitAct = "Inactivo" THEN DO:
        FOR EACH gn-users EXCLUSIVE-LOCK WHERE gn-users.codcia = s-codcia
            AND gn-users.codper = PL-FLG-MES.codper:
            ASSIGN
                gn-users.Disabled = YES
                gn-users.Disabled-Date = DATETIME-TZ(TODAY, MTIME, TIMEZONE).
        END.
        NEXT.
    END.

    DISPLAY PL-FLG-MES.CodPer @ FILL-IN-Codigo WITH FRAME D-Dialog.

    FIND b-FLG-MES WHERE
        b-FLG-MES.CodCia = s-codcia AND
        b-FLG-MES.Periodo = x-periodo AND
        b-FLG-MES.NroMes = x-nromes AND
        b-FLG-MES.CodPln = PL-FLG-MES.CodPln AND
        b-FLG-MES.CodPer = PL-FLG-MES.CodPer NO-ERROR.

    IF NOT AVAILABLE B-FLG-MES
    THEN CREATE B-FLG-MES.
    BUFFER-COPY PL-FLG-MES TO B-FLG-MES
        ASSIGN
            b-FLG-MES.Periodo = x-periodo
            b-FLG-MES.NroMes = x-nromes
            b-FLG-MES.Fch-Ult-Reg  = TODAY
            b-FLG-MES.Hra-Ult-Reg  = STRING(TIME, "HH:MM").
            
    /* RHC 21.12.04 OBSOLETO ******************************************
    IF NOT AVAILABLE b-FLG-MES THEN DO:
        CREATE b-FLG-MES.
        ASSIGN
            b-FLG-MES.CodCia = PL-FLG-MES.CodCia
            b-FLG-MES.Periodo = x-periodo
            b-FLG-MES.NroMes = x-nromes
            b-FLG-MES.codpln = PL-FLG-MES.Codpln
            b-FLG-MES.codper = PL-FLG-MES.CodPer.
    END.
    ASSIGN
        b-FLG-MES.Conyugue     = PL-FLG-MES.Conyugue
        b-FLG-MES.Nro-de-Hijos = PL-FLG-MES.Nro-de-Hijos
        b-FLG-MES.fecing       = PL-FLG-MES.fecing
        b-FLG-MES.vcontr       = PL-FLG-MES.vcontr
        b-FLG-MES.SitAct       = PL-FLG-MES.SitAct
        b-FLG-MES.codafp       = PL-FLG-MES.Codafp
        b-FLG-MES.cnpago       = PL-FLG-MES.cnpago
        b-FLG-MES.Clase        = PL-FLG-MES.Clase
        b-FLG-MES.ccosto       = PL-FLG-MES.ccosto
        b-FLG-MES.cargos       = PL-FLG-MES.cargos
        b-FLG-MES.inivac       = PL-FLG-MES.inivac
        b-FLG-MES.finvac       = PL-FLG-MES.finvac
        b-FLG-MES.CTS          = PL-FLG-MES.CTS
        b-FLG-MES.nrodpt-CTS   = PL-FLG-MES.nrodpt-CTS
        b-FLG-MES.nroafp       = PL-FLG-MES.nroafp
        b-FLG-MES.nrodpt       = PL-FLG-MES.nrodpt
        b-FLG-MES.Proyecto     = PL-FLG-MES.Proyecto
        b-FLG-MES.seccion      = PL-FLG-MES.seccion
        b-FLG-MES.Exceso-Mes   = PL-FLG-MES.Exceso-Mes
        b-FLG-MES.CodDiv       = PL-FLG-MES.CodDiv
        b-FLG-MES.Fch-Ult-Reg  = TODAY
        b-FLG-MES.Hra-Ult-Reg  = STRING(TIME, "HH:MM").
    ****************************************************** */
    
    /* Si no esta de vacaciones */
    IF PL-FLG-MES.SitAct = "Activo" AND
        PL-FLG-MES.inivac >= x-fchini AND
        PL-FLG-MES.inivac <= x-fchfin 
    THEN b-FLG-MES.SitAct = "Vacaciones".

    /* Si esta de vacaciones */
    IF PL-FLG-MES.SitAct = "Vacaciones" AND
        ( PL-FLG-MES.inivac < x-fchini OR
        PL-FLG-MES.inivac >= x-fchfin ) 
    THEN b-FLG-MES.SitAct = "Activo".

    RELEASE b-FLG-MES.

    FOR EACH PL-MOV-MES WHERE
        PL-MOV-MES.CodCia  = PL-FLG-MES.CodCia  AND
        PL-MOV-MES.Periodo = PL-FLG-MES.Periodo AND
        PL-MOV-MES.NroMes  = PL-FLG-MES.NroMes  AND
        PL-MOV-MES.CodPln  = PL-FLG-MES.CodPln  AND
        PL-MOV-MES.CodCal  = 0                  AND
        PL-MOV-MES.codper  = PL-FLG-MES.CodPer NO-LOCK:

        FIND PL-CONC WHERE PL-CONC.CodMov = PL-MOV-MES.CodMov NO-LOCK NO-ERROR.
        IF NOT AVAILABLE PL-CONC THEN NEXT.
        ASSIGN x-valcal-mes = 0.
        CASE PL-CONC.CieMov:
            WHEN "No cambia con los cierres" THEN
                ASSIGN x-valcal-mes = PL-MOV-MES.valcal-mes.
            WHEN "Al cierre del periodo" THEN
                ASSIGN x-valcal-mes = PL-CONC.ValIni-Mes.
            WHEN "Al cierre anual" THEN DO:
                IF s-nromes = 12 THEN
                     ASSIGN x-valcal-mes  = PL-CONC.ValIni-Mes.
                ELSE ASSIGN x-valcal-mes = PL-MOV-MES.valcal-mes.
            END.
        END CASE.

        IF x-valcal-mes = 0 THEN NEXT.
        FIND b-MOV-MES WHERE
            b-MOV-MES.CodCia  = PL-MOV-MES.CodCia AND
            b-MOV-MES.Periodo = x-periodo         AND
            b-MOV-MES.NroMes  = x-nromes          AND
            b-MOV-MES.CodPln  = PL-MOV-MES.CodPln AND
            b-MOV-MES.CodCal  = PL-MOV-MES.CodCal AND
            b-MOV-MES.codper  = PL-MOV-MES.CodPer AND
            b-MOV-MES.codmov  = PL-MOV-MES.CodMov NO-ERROR.
        IF NOT AVAILABLE b-MOV-MES THEN DO:
            CREATE b-MOV-MES.
            ASSIGN
                b-MOV-MES.CodCia = PL-MOV-MES.CodCia
                b-MOV-MES.Periodo = x-periodo
                b-MOV-MES.NroMes = x-nromes
                b-MOV-MES.codpln = PL-MOV-MES.Codpln
                b-MOV-MES.codcal = PL-MOV-MES.CodCal
                b-MOV-MES.codper = PL-MOV-MES.Codper
                b-MOV-MES.CodMov = PL-MOV-MES.Codmov.
        END.
        ASSIGN
            b-MOV-MES.valcal-mes = x-valcal-mes
            b-MOV-MES.flgreg-mes = FALSE.
        RELEASE b-MOV-MES.
    END.
    FOR EACH integral.PL-CFG-CTE-MES WHERE
        integral.PL-CFG-CTE-MES.CodCia = PL-FLG-MES.CodCia AND
        integral.PL-CFG-CTE-MES.Periodo = PL-FLG-MES.Periodo AND
        integral.PL-CFG-CTE-MES.NroMes = PL-FLG-MES.NroMes AND
        integral.PL-CFG-CTE-MES.CodPer = PL-FLG-MES.CodPer NO-LOCK:
        IF integral.PL-CFG-CTE-MES.Sdo-Cte-Mes > 0 OR
            integral.PL-CFG-CTE-MES.Sdo-Usa-Mes > 0 THEN DO:
            FIND b-CFG-CTE-MES WHERE
                b-CFG-CTE-MES.CodCia = integral.PL-CFG-CTE-MES.CodCia AND
                b-CFG-CTE-MES.Periodo = x-periodo AND
                b-CFG-CTE-MES.NroMes = x-nromes AND
                b-CFG-CTE-MES.Clf-Cte-Mes = integral.PL-CFG-CTE-MES.Clf-Cte-Mes AND
                b-CFG-CTE-MES.Tpo-Cte-Mes = integral.PL-CFG-CTE-MES.Tpo-Cte-Mes AND
                b-CFG-CTE-MES.CodPer = integral.PL-CFG-CTE-MES.CodPer AND
                b-CFG-CTE-MES.Nro-Cte-Mes = integral.PL-CFG-CTE-MES.Nro-Cte-Mes
                NO-ERROR.
            IF NOT AVAILABLE b-CFG-CTE-MES THEN DO:
                CREATE b-CFG-CTE-MES.
                ASSIGN
                    b-CFG-CTE-MES.CodCia = integral.PL-CFG-CTE-MES.CodCia
                    b-CFG-CTE-MES.Periodo = x-periodo
                    b-CFG-CTE-MES.NroMes = x-nromes
                    b-CFG-CTE-MES.Clf-Cte-Mes = integral.PL-CFG-CTE-MES.Clf-Cte-Mes
                    b-CFG-CTE-MES.Tpo-Cte-Mes = integral.PL-CFG-CTE-MES.Tpo-Cte-Mes
                    b-CFG-CTE-MES.CodPer = integral.PL-CFG-CTE-MES.CodPer
                    b-CFG-CTE-MES.Nro-Cte-Mes = integral.PL-CFG-CTE-MES.Nro-Cte-Mes.
            END.
            ASSIGN
                b-CFG-CTE-MES.Fch-Cte-Mes = integral.PL-CFG-CTE-MES.Fch-Cte-Mes
                b-CFG-CTE-MES.Beneficiario-Mes = integral.PL-CFG-CTE-MES.Beneficiario-Mes
                b-CFG-CTE-MES.Moneda-Mes  = integral.PL-CFG-CTE-MES.Moneda-Mes
                b-CFG-CTE-MES.Imp-Cte-Mes = integral.PL-CFG-CTE-MES.Imp-Cte-Mes
                b-CFG-CTE-MES.Imp-Usa-Mes = integral.PL-CFG-CTE-MES.Imp-USA-Mes                                
                b-CFG-CTE-MES.Cuo-Cte-Mes = integral.PL-CFG-CTE-MES.Cuo-Cte-Mes
                b-CFG-CTE-MES.Cuo-Por-Mes = integral.PL-CFG-CTE-MES.Cuo-Por-Mes
                b-CFG-CTE-MES.Sdo-Cte-Mes = integral.PL-CFG-CTE-MES.Sdo-Cte-Mes
                b-CFG-CTE-MES.Sdo-Usa-Mes = integral.PL-CFG-CTE-MES.Sdo-Usa-Mes
                b-CFG-CTE-MES.Fch-Prx-Pgo-Mes = integral.PL-CFG-CTE-MES.Fch-Prx-Pgo-Mes.
            IF integral.PL-CFG-CTE-MES.Fch-Prx-Pgo-Mes < x-fchfin THEN
                ASSIGN B-CFG-CTE-MES.Fch-Prx-Pgo-Mes = x-fchfin.
        END.
    END.

    /* Derechohabientes */
    FOR EACH PL-DHABIENTE WHERE
        PL-DHABIENTE.CodCia = PL-FLG-MES.CodCia AND
        PL-DHABIENTE.Periodo = PL-FLG-MES.Periodo AND
        PL-DHABIENTE.CodPln = PL-FLG-MES.CodPln AND
        PL-DHABIENTE.NroMes = PL-FLG-MES.NroMes AND
        PL-DHABIENTE.CodPer = PL-FLG-MES.CodPer NO-LOCK:
        IF PL-DHABIENTE.SitDerHab = "11" THEN NEXT. /* Baja */
        FIND b-DHABIENTE WHERE
            b-DHABIENTE.CodCia = PL-DHABIENTE.CodCia AND
            b-DHABIENTE.Periodo = x-periodo AND
            b-DHABIENTE.NroMes = x-nromes AND
            b-DHABIENTE.CodPln = PL-DHABIENTE.CodPln AND
            b-DHABIENTE.CodPer = PL-DHABIENTE.CodPer AND
            b-DHABIENTE.TpoDocId = PL-DHABIENTE.TpoDocId AND
            b-DHABIENTE.NroDocId = PL-DHABIENTE.NroDocId NO-ERROR.
        IF NOT AVAILABLE b-DHABIENTE THEN CREATE b-DHABIENTE.
        BUFFER-COPY PL-DHABIENTE TO b-DHABIENTE
        ASSIGN
            b-DHABIENTE.Periodo = x-periodo
            b-DHABIENTE.NroMes = x-nromes.
    END.

END.

IF x-nromes = 1 THEN DO:
    FIND LAST integral.CB-PERI WHERE
        integral.CB-PERI.CodCia = s-CodCia AND
        integral.CB-PERI.Periodo = x-periodo NO-ERROR.
    IF NOT AVAILABLE integral.CB-PERI THEN DO:
        CREATE integral.CB-PERI.
        ASSIGN
            integral.CB-PERI.CodCia = s-CodCia
            integral.CB-PERI.Periodo = x-periodo
            integral.CB-PERI.pl-NroSem = 1.
    END.
    ASSIGN integral.CB-PERI.pl-NroMes = 1.
    RUN @actualiza-variables.
    ASSIGN s-nrosem = integral.CB-PERI.pl-NroSem.
END.
ELSE DO:
    FIND LAST integral.CB-PERI WHERE
        integral.CB-PERI.CodCia = s-CodCia AND
        integral.CB-PERI.Periodo = s-Periodo AND
        integral.CB-PERI.pl-nromes = s-nromes NO-ERROR.
    IF AVAILABLE integral.CB-PERI THEN
        ASSIGN integral.CB-PERI.pl-nromes = x-nromes.
END.

ASSIGN
    s-nromes  = x-nromes
    s-Periodo = x-periodo.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE @genera-periodo D-Dialog 
PROCEDURE @genera-periodo :
DEFINE VARIABLE i AS INTEGER NO-UNDO.

IF NOT CAN-FIND(FIRST integral.PL-SEM WHERE
    integral.PL-SEM.CodCia  = s-CodCia AND
    integral.PL-SEM.Periodo = x-Periodo) THEN DO:
    DO i = 1 TO 53:
        CREATE integral.PL-SEM.
        ASSIGN
            integral.PL-SEM.CodCia  = s-CodCia
            integral.PL-SEM.Periodo = x-Periodo
            integral.PL-SEM.NroSem  = i
            integral.PL-SEM.FecIni  = x-ultfch
            integral.PL-SEM.FecFin  = x-ultfch + 6
            integral.PL-SEM.NroMes  = MONTH(integral.PL-SEM.FecFin)
            x-ultfch               = x-ultfch + 7.
        IF DAY(integral.PL-SEM.FecFin) < 4 THEN
            ASSIGN integral.PL-SEM.NroMes = MONTH(integral.PL-SEM.FecIni).
    END.
    FIND LAST integral.PL-SEM WHERE
        integral.PL-SEM.CodCia = s-CodCia AND
        integral.PL-SEM.Periodo = x-Periodo NO-ERROR.
    IF AVAILABLE integral.PL-SEM AND integral.PL-SEM.NroMes = 1 THEN
        DELETE integral.PL-SEM.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
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
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
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
  DISPLAY FILL-IN-Codigo 
      WITH FRAME D-Dialog.
  ENABLE RECT-2 Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartDialog, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
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

