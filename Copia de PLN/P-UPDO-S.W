&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r2 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME F-updown
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS F-updown 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{bin/s-global.i}
{pln/s-global.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-updown

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RADIO-updown FILL-IN-nomarch ~
COMBO-updown Btn_OK Btn_Cancel Btn_Help 
&Scoped-Define DISPLAYED-OBJECTS RADIO-updown FILL-IN-nomarch COMBO-updown 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 12 BY 1
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Ayuda" 
     SIZE 12 BY 1
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "&Aceptar" 
     SIZE 12 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE COMBO-updown AS CHARACTER FORMAT "X(256)":U INITIAL "Datos Personal" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Datos Personal","Asignaciones Personal","C lculos","Configuraci¢n Cta. Cte.","Movimientos Cta. Cte.","Correlativos" 
     SIZE 26.29 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-nomarch AS CHARACTER FORMAT "X(256)":U INITIAL "A:" 
     LABEL "Directorio" 
     VIEW-AS FILL-IN 
     SIZE 33.72 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-updown AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Levantar Datos", 1,
"Bajar Datos", 2
     SIZE 13.86 BY 1.65 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 59.43 BY 5.77.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-updown
     RADIO-updown AT ROW 1.81 COL 4.14 NO-LABEL
     FILL-IN-nomarch AT ROW 5.04 COL 8.86 COLON-ALIGNED
     COMBO-updown AT ROW 2.15 COL 16.57 COLON-ALIGNED NO-LABEL
     Btn_OK AT ROW 1.85 COL 46.86
     Btn_Cancel AT ROW 2.96 COL 46.86
     Btn_Help AT ROW 4.42 COL 46.86
     RECT-1 AT ROW 1 COL 1
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Levantar, Bajar Datos".

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
ASSIGN 
       FRAME F-updown:SCROLLABLE       = FALSE
       FRAME F-updown:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME F-updown
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-updown F-updown
ON WINDOW-CLOSE OF FRAME F-updown /* Levantar, Bajar Datos */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help F-updown
ON CHOOSE OF Btn_Help IN FRAME F-updown /* Ayuda */
OR HELP OF FRAME {&FRAME-NAME}
DO:
    MESSAGE "Help for File: {&FILE-NAME}" VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK F-updown
ON CHOOSE OF Btn_OK IN FRAME F-updown /* Aceptar */
DO:
   ASSIGN
        COMBO-updown
        RADIO-updown
        FILL-IN-nomarch.
    IF RADIO-updown = 2 THEN DO:
        BELL.
        MESSAGE "ADVERTENCIA : Se van a borrar los" SKIP
            "registros existentes" SKIP
            "Desea continuar ?" VIEW-AS ALERT-BOX
            QUESTION BUTTONS YES-NO UPDATE rpta AS LOGICAL.
        IF rpta = FALSE THEN DO:
            APPLY "ENTRY" TO RADIO-updown.
            RETURN NO-APPLY.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK F-updown 


IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
    RUN enable_UI.
    ASSIGN FRAME F-updown:TITLE = FRAME F-updown:TITLE + " Semana " + STRING(s-nrosem,"99").
    WAIT-FOR GO OF FRAME {&FRAME-NAME}.
    IF RADIO-updown = 1 THEN RUN _levantar-datos.
    ELSE RUN _bajar-datos.
END.

RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI F-updown _DEFAULT-DISABLE
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
  HIDE FRAME F-updown.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI F-updown _DEFAULT-ENABLE
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
  DISPLAY RADIO-updown FILL-IN-nomarch COMBO-updown 
      WITH FRAME F-updown.
  ENABLE RECT-1 RADIO-updown FILL-IN-nomarch COMBO-updown Btn_OK Btn_Cancel 
         Btn_Help 
      WITH FRAME F-updown.
  VIEW FRAME F-updown.
  {&OPEN-BROWSERS-IN-QUERY-F-updown}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _bajar-datos F-updown 
PROCEDURE _bajar-datos :
DEFINE VARIABLE fullname AS CHARACTER.

ASSIGN
    FILL-IN-nomarch = FILL-IN-nomarch + "\" +
    STRING(s-codcia,"99") +
    STRING(s-periodo,"9999") +
    STRING(s-nrosem,"99").

CASE COMBO-updown:
    WHEN "Datos Personal" THEN DO:
        ASSIGN FILL-IN-nomarch = FILL-IN-nomarch + ".SPE".
        ASSIGN fullname = SEARCH(FILL-IN-nomarch).
        IF fullname = ? THEN DO:
            BELL.
            MESSAGE "Archivo texto de personal" SKIP
                "no encontrado en este directorio"
                VIEW-AS ALERT-BOX ERROR.
            RETURN.
        END.
        FOR EACH PL-PERS:
            DELETE PL-PERS.
        END.
        INPUT FROM VALUE( FILL-IN-nomarch ).
        REPEAT:
            CREATE PL-PERS.
            IMPORT
                PL-PERS.CodBar
                PL-PERS.codper
                PL-PERS.ctipss
                PL-PERS.dirper
                PL-PERS.distri
                PL-PERS.ecivil
                PL-PERS.fecnac
                PL-PERS.lelect
                PL-PERS.lmilit
                PL-PERS.localidad
                PL-PERS.matper
                PL-PERS.nacion
                PL-PERS.nomper
                PL-PERS.patper
                PL-PERS.profesion
                PL-PERS.provin
                PL-PERS.sexper
                PL-PERS.telefo
                PL-PERS.titulo
                PL-PERS.TpoPer.
        END.
        INPUT CLOSE.
    END.
    WHEN "Asignaci¢n Personal" THEN DO:
        ASSIGN FILL-IN-nomarch = FILL-IN-nomarch + ".SFL".
        ASSIGN fullname = SEARCH(FILL-IN-nomarch).
        IF fullname = ? THEN DO:
            BELL.
            MESSAGE "Archivo texto de asignaci¢n de personal" SKIP
                "no encontrado en este directorio"
                VIEW-AS ALERT-BOX ERROR.
            RETURN.
        END.
        FOR EACH PL-FLG-SEM WHERE
            PL-FLG-SEM.codcia = s-codcia AND
            PL-FLG-SEM.periodo = s-periodo AND
            PL-FLG-SEM.nrosem = s-nrosem:
            DELETE PL-FLG-SEM.
        END.
        INPUT FROM VALUE( FILL-IN-nomarch ).
        REPEAT:
            CREATE PL-FLG-SEM.
            IMPORT
                PL-FLG-SEM.cargos
                PL-FLG-SEM.ccosto
                PL-FLG-SEM.Clase
                PL-FLG-SEM.cnpago
                PL-FLG-SEM.codafp
                PL-FLG-SEM.CodCia
                PL-FLG-SEM.CodDiv
                PL-FLG-SEM.codper
                PL-FLG-SEM.codpln
                PL-FLG-SEM.Conyugue
                PL-FLG-SEM.CTS
                PL-FLG-SEM.Exceso-Sem
                PL-FLG-SEM.Fch-Ult-Reg
                PL-FLG-SEM.fecing
                PL-FLG-SEM.finvac
                PL-FLG-SEM.Hra-Ult-Reg
                PL-FLG-SEM.inivac
                PL-FLG-SEM.Nro-De-Hijos
                PL-FLG-SEM.nroafp
                PL-FLG-SEM.nrodpt
                PL-FLG-SEM.nrodpt-cts
                PL-FLG-SEM.NroSem
                PL-FLG-SEM.Periodo
                PL-FLG-SEM.Proyecto
                PL-FLG-SEM.seccion
                PL-FLG-SEM.SitAct
                PL-FLG-SEM.vcontr.
        END.
        INPUT CLOSE.
    END.
    WHEN "C lculos" THEN DO:
        ASSIGN FILL-IN-nomarch = FILL-IN-nomarch + ".SMV".
        ASSIGN fullname = SEARCH(FILL-IN-nomarch).
        IF fullname = ? THEN DO:
            BELL.
            MESSAGE "Archivo texto de c lculos de personal" SKIP
                "no encontrado en este directorio"
                VIEW-AS ALERT-BOX ERROR.
            RETURN.
        END.
        FOR EACH PL-MOV-SEM WHERE
            PL-MOV-SEM.codcia = s-codcia AND
            PL-MOV-SEM.periodo = s-periodo AND
            PL-MOV-SEM.nrosem = s-nrosem:
            DELETE PL-MOV-SEM.
        END.
        INPUT FROM VALUE( FILL-IN-nomarch ).
        REPEAT:
            CREATE PL-MOV-SEM.
            IMPORT
                PL-MOV-SEM.codcal
                PL-MOV-SEM.CodCia
                PL-MOV-SEM.CodMov
                PL-MOV-SEM.codper
                PL-MOV-SEM.codpln
                PL-MOV-SEM.Fch-Ult-Cal
                PL-MOV-SEM.flgreg-sem
                PL-MOV-SEM.Hra-Ult-Cal
                PL-MOV-SEM.NroSem
                PL-MOV-SEM.Periodo
                PL-MOV-SEM.valcal-sem.
        END.
        INPUT CLOSE.
    END.
    WHEN "Configuraci¢n Cta. Cte." THEN DO:
        ASSIGN FILL-IN-nomarch = FILL-IN-nomarch + ".SCC".
        ASSIGN fullname = SEARCH(FILL-IN-nomarch).
        IF fullname = ? THEN DO:
            BELL.
            MESSAGE "Archivo texto de configuraci¢n de cta. cte." SKIP
                "no encontrado en este directorio"
                VIEW-AS ALERT-BOX ERROR.
            RETURN.
        END.
        FOR EACH PL-CFG-CTE-SEM WHERE
            PL-CFG-CTE-SEM.CodCia = s-codcia AND
            PL-CFG-CTE-SEM.Periodo = s-periodo AND
            PL-CFG-CTE-SEM.NroSem = s-nrosem:
            DELETE PL-CFG-CTE-SEM.
        END.
        INPUT FROM VALUE( FILL-IN-nomarch ).
        REPEAT:
            CREATE PL-CFG-CTE-SEM.
            IMPORT
                PL-CFG-CTE-SEM.Beneficiario-Sem
                PL-CFG-CTE-SEM.Clf-Cte-Sem
                PL-CFG-CTE-SEM.CodCia
                PL-CFG-CTE-SEM.CodPer
                PL-CFG-CTE-SEM.Cuo-Cte-Sem
                PL-CFG-CTE-SEM.Cuo-Por-Sem
                PL-CFG-CTE-SEM.Fch-Cte-Sem
                PL-CFG-CTE-SEM.Fch-Prx-Pgo-Sem
                PL-CFG-CTE-SEM.Fch-Ult-Cal-Cte-Sem
                PL-CFG-CTE-SEM.Hra-Ult-Cal-Cte-Sem
                PL-CFG-CTE-SEM.Imp-Cte-Sem
                PL-CFG-CTE-SEM.Imp-USA-Sem
                PL-CFG-CTE-SEM.Moneda-Sem
                PL-CFG-CTE-SEM.Nro-Cte-Sem
                PL-CFG-CTE-SEM.NroSem
                PL-CFG-CTE-SEM.Periodo
                PL-CFG-CTE-SEM.Sdo-Cte-Sem
                PL-CFG-CTE-SEM.Sdo-USA-Sem
                PL-CFG-CTE-SEM.Tpo-Cte-Sem.
        END.
        INPUT CLOSE.
    END.
    WHEN "Movimientos Cta. Cte." THEN DO:
        ASSIGN FILL-IN-nomarch = FILL-IN-nomarch + ".SMC".
        ASSIGN fullname = SEARCH(FILL-IN-nomarch).
        IF fullname = ? THEN DO:
            BELL.
            MESSAGE "Archivo texto de movimientos de cta. cte." SKIP
                "no encontrado en este directorio"
                VIEW-AS ALERT-BOX ERROR.
            RETURN.
        END.
        FOR EACH PL-MOV-CTE-SEM WHERE
            PL-MOV-CTE-SEM.CodCia = s-codcia AND
            PL-MOV-CTE-SEM.Periodo = s-periodo AND
            PL-MOV-CTE-SEM.NroSem = s-nrosem:
            DELETE PL-MOV-CTE-SEM.
        END.
        INPUT FROM VALUE( FILL-IN-nomarch ).
        REPEAT:
            CREATE PL-MOV-CTE-SEM.
            IMPORT
                PL-MOV-CTE-SEM.Clf-Cte-Sem
                PL-MOV-CTE-SEM.CodCal
                PL-MOV-CTE-SEM.CodCia
                PL-MOV-CTE-SEM.CodPer
                PL-MOV-CTE-SEM.CodPln
                PL-MOV-CTE-SEM.Fch-Ult-Mov-Cte-Sem
                PL-MOV-CTE-SEM.Hra-Ult-Mov-Cte-Sem
                PL-MOV-CTE-SEM.Nro-Cte-Sem
                PL-MOV-CTE-SEM.NroSem
                PL-MOV-CTE-SEM.Periodo
                PL-MOV-CTE-SEM.Tpo-Cte-Sem
                PL-MOV-CTE-SEM.Val-Cte-Sem
                PL-MOV-CTE-SEM.Val-USA-Sem.
        END.
        INPUT CLOSE.
    END.
    WHEN "Correlativos" THEN DO:
        ASSIGN FILL-IN-nomarch = FILL-IN-nomarch + ".SCR".
        ASSIGN fullname = SEARCH(FILL-IN-nomarch).
        IF fullname = ? THEN DO:
            BELL.
            MESSAGE "Archivo texto de correlativos de cta. cte." SKIP
                "no encontrado en este directorio"
                VIEW-AS ALERT-BOX ERROR.
            RETURN.
        END.
        FOR EACH PL-CORR-CTE-SEM WHERE
            PL-CORR-CTE-SEM.CodCia = s-codcia AND
            PL-CORR-CTE-SEM.Periodo = s-periodo:
            DELETE PL-CORR-CTE-SEM.
        END.
        INPUT FROM VALUE( FILL-IN-nomarch ).
        REPEAT:
            CREATE PL-CORR-CTE-SEM.
            IMPORT
                PL-CORR-CTE-SEM.Clf-Cte-Sem
                PL-CORR-CTE-SEM.CodCia
                PL-CORR-CTE-SEM.Des-Cte-Sem
                PL-CORR-CTE-SEM.Nro-Cte-Sem
                PL-CORR-CTE-SEM.Periodo
                PL-CORR-CTE-SEM.Tpo-Cte-Sem.
        END.
        INPUT CLOSE.
    END.
END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _levantar-datos F-updown 
PROCEDURE _levantar-datos :
ASSIGN
    FILL-IN-nomarch = FILL-IN-nomarch + "\" +
    STRING(s-codcia,"99") +
    STRING(s-periodo,"9999") +
    STRING(s-nrosem,"99").

CASE COMBO-updown:
    WHEN "Datos Personal" THEN DO:
        ASSIGN FILL-IN-nomarch = FILL-IN-nomarch + ".SPE".
        OUTPUT TO VALUE( FILL-IN-nomarch ).
        FOR EACH PL-PERS NO-LOCK:
            EXPORT
                PL-PERS.CodBar
                PL-PERS.codper
                PL-PERS.ctipss
                PL-PERS.dirper
                PL-PERS.distri
                PL-PERS.ecivil
                PL-PERS.fecnac
                PL-PERS.lelect
                PL-PERS.lmilit
                PL-PERS.localidad
                PL-PERS.matper
                PL-PERS.nacion
                PL-PERS.nomper
                PL-PERS.patper
                PL-PERS.profesion
                PL-PERS.provin
                PL-PERS.sexper
                PL-PERS.telefo
                PL-PERS.titulo
                PL-PERS.TpoPer.
        END.
        OUTPUT CLOSE.
    END.
    WHEN "Asignaci¢n Personal" THEN DO:
        ASSIGN FILL-IN-nomarch = FILL-IN-nomarch + ".SFL".
        OUTPUT TO VALUE( FILL-IN-nomarch ).
        FOR EACH PL-FLG-SEM WHERE
            PL-FLG-SEM.codcia = s-codcia AND
            PL-FLG-SEM.periodo = s-periodo AND
            PL-FLG-SEM.nrosem = s-nrosem NO-LOCK:
            EXPORT
                PL-FLG-SEM.cargos
                PL-FLG-SEM.ccosto
                PL-FLG-SEM.Clase
                PL-FLG-SEM.cnpago
                PL-FLG-SEM.codafp
                PL-FLG-SEM.CodCia
                PL-FLG-SEM.CodDiv
                PL-FLG-SEM.codper
                PL-FLG-SEM.codpln
                PL-FLG-SEM.Conyugue
                PL-FLG-SEM.CTS
                PL-FLG-SEM.Exceso-Sem
                PL-FLG-SEM.Fch-Ult-Reg
                PL-FLG-SEM.fecing
                PL-FLG-SEM.finvac
                PL-FLG-SEM.Hra-Ult-Reg
                PL-FLG-SEM.inivac
                PL-FLG-SEM.Nro-De-Hijos
                PL-FLG-SEM.nroafp
                PL-FLG-SEM.nrodpt
                PL-FLG-SEM.nrodpt-cts
                PL-FLG-SEM.NroSem
                PL-FLG-SEM.Periodo
                PL-FLG-SEM.Proyecto
                PL-FLG-SEM.seccion
                PL-FLG-SEM.SitAct
                PL-FLG-SEM.vcontr.
        END.
        OUTPUT CLOSE.
    END.
    WHEN "C lculos" THEN DO:
        ASSIGN FILL-IN-nomarch = FILL-IN-nomarch + ".SMV".
        OUTPUT TO VALUE( FILL-IN-nomarch ).
        FOR EACH PL-MOV-SEM WHERE
            PL-MOV-SEM.codcia = s-codcia AND
            PL-MOV-SEM.periodo = s-periodo AND
            PL-MOV-SEM.nrosem = s-nrosem NO-LOCK:
            EXPORT
                PL-MOV-SEM.codcal
                PL-MOV-SEM.CodCia
                PL-MOV-SEM.CodMov
                PL-MOV-SEM.codper
                PL-MOV-SEM.codpln
                PL-MOV-SEM.Fch-Ult-Cal
                PL-MOV-SEM.flgreg-sem
                PL-MOV-SEM.Hra-Ult-Cal
                PL-MOV-SEM.NroSem
                PL-MOV-SEM.Periodo
                PL-MOV-SEM.valcal-sem.
        END.
        OUTPUT CLOSE.
    END.
    WHEN "Configuraci¢n Cta. Cte." THEN DO:
        ASSIGN FILL-IN-nomarch = FILL-IN-nomarch + ".SCC".
        OUTPUT TO VALUE( FILL-IN-nomarch ).
        FOR EACH PL-CFG-CTE-SEM WHERE
            PL-CFG-CTE-SEM.CodCia = s-codcia AND
            PL-CFG-CTE-SEM.Periodo = s-periodo AND
            PL-CFG-CTE-SEM.NroSem = s-nrosem NO-LOCK:
            EXPORT
                PL-CFG-CTE-SEM.Beneficiario-Sem
                PL-CFG-CTE-SEM.Clf-Cte-Sem
                PL-CFG-CTE-SEM.CodCia
                PL-CFG-CTE-SEM.CodPer
                PL-CFG-CTE-SEM.Cuo-Cte-Sem
                PL-CFG-CTE-SEM.Cuo-Por-Sem
                PL-CFG-CTE-SEM.Fch-Cte-Sem
                PL-CFG-CTE-SEM.Fch-Prx-Pgo-Sem
                PL-CFG-CTE-SEM.Fch-Ult-Cal-Cte-Sem
                PL-CFG-CTE-SEM.Hra-Ult-Cal-Cte-Sem
                PL-CFG-CTE-SEM.Imp-Cte-Sem
                PL-CFG-CTE-SEM.Imp-USA-Sem
                PL-CFG-CTE-SEM.Moneda-Sem
                PL-CFG-CTE-SEM.Nro-Cte-Sem
                PL-CFG-CTE-SEM.NroSem
                PL-CFG-CTE-SEM.Periodo
                PL-CFG-CTE-SEM.Sdo-Cte-Sem
                PL-CFG-CTE-SEM.Sdo-USA-Sem
                PL-CFG-CTE-SEM.Tpo-Cte-Sem.
        END.
        OUTPUT CLOSE.
    END.
    WHEN "Movimientos Cta. Cte." THEN DO:
        ASSIGN FILL-IN-nomarch = FILL-IN-nomarch + ".SMC".
        OUTPUT TO VALUE( FILL-IN-nomarch ).
        FOR EACH PL-MOV-CTE-SEM WHERE
            PL-MOV-CTE-SEM.CodCia = s-codcia AND
            PL-MOV-CTE-SEM.Periodo = s-periodo AND
            PL-MOV-CTE-SEM.NroSem = s-nrosem NO-LOCK:
            EXPORT
                PL-MOV-CTE-SEM.Clf-Cte-Sem
                PL-MOV-CTE-SEM.CodCal
                PL-MOV-CTE-SEM.CodCia
                PL-MOV-CTE-SEM.CodPer
                PL-MOV-CTE-SEM.CodPln
                PL-MOV-CTE-SEM.Fch-Ult-Mov-Cte-Sem
                PL-MOV-CTE-SEM.Hra-Ult-Mov-Cte-Sem
                PL-MOV-CTE-SEM.Nro-Cte-Sem
                PL-MOV-CTE-SEM.NroSem
                PL-MOV-CTE-SEM.Periodo
                PL-MOV-CTE-SEM.Tpo-Cte-Sem
                PL-MOV-CTE-SEM.Val-Cte-Sem
                PL-MOV-CTE-SEM.Val-USA-Sem.
        END.
        OUTPUT CLOSE.
    END.
    WHEN "Correlativos" THEN DO:
        ASSIGN FILL-IN-nomarch = FILL-IN-nomarch + ".SCR".
        OUTPUT TO VALUE( FILL-IN-nomarch ).
        FOR EACH PL-CORR-CTE-SEM WHERE
            PL-CORR-CTE-SEM.CodCia = s-codcia AND
            PL-CORR-CTE-SEM.Periodo = s-periodo NO-LOCK:
            EXPORT
                PL-CORR-CTE-SEM.Clf-Cte-Sem
                PL-CORR-CTE-SEM.CodCia
                PL-CORR-CTE-SEM.Des-Cte-Sem
                PL-CORR-CTE-SEM.Nro-Cte-Sem
                PL-CORR-CTE-SEM.Periodo
                PL-CORR-CTE-SEM.Tpo-Cte-Sem.
        END.
        OUTPUT CLOSE.
    END.
END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


