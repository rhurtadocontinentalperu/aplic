&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-periodo AS INT.
DEF SHARED VAR s-nromes AS INT.
DEF SHARED VAR s-nomcia AS CHAR.

/* Local Variable Definitions ---                                       */
DEF VAR x-Periodo AS CHAR NO-UNDO.
DEF VAR x-Meses   AS CHAR NO-UNDO.
DEF VAR i AS INT NO-UNDO.

RUN cbd/cb-m000 (OUTPUT x-Periodo).
IF x-Periodo = ''
THEN DO:
    MESSAGE 'NO existen periodos configurados para esta compañia'
        VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.

DEF VAR s-task-no AS INT INITIAL 0 NO-UNDO.
DEF VAR s-Titulo  AS CHAR NO-UNDO.

DEF TEMP-TABLE w-report
    FIELD task-no AS INT
    FIELD Llave-I AS INT
    FIELD Llave-C AS CHAR
    FIELD Campo-C AS CHAR EXTENT 10
    FIELD Campo-F AS DEC  EXTENT 20
    INDEX Llave01 AS PRIMARY task-no Llave-I.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-Periodo COMBO-BOX-Mes-1 ~
COMBO-BOX-Mes-2 x-Detallado BUTTON-1 BUTTON-2 BUTTON-3 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Periodo COMBO-BOX-Mes-1 ~
COMBO-BOX-Mes-2 x-Detallado 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Button 1" 
     SIZE 15 BY 1.54.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Button 2" 
     SIZE 15 BY 1.54.

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img\tbldat":U
     LABEL "Button 3" 
     SIZE 15 BY 1.5.

DEFINE VARIABLE COMBO-BOX-Mes-1 AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Desde el mes" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "1","2","3","4","5","6","7","8","9","10","11","12" 
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Mes-2 AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Hasta el mes" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "1","2","3","4","5","6","7","8","9","10","11","12" 
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE x-Detallado AS LOGICAL INITIAL no 
     LABEL "Detallado" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-Periodo AT ROW 1.58 COL 20 COLON-ALIGNED
     COMBO-BOX-Mes-1 AT ROW 2.54 COL 20 COLON-ALIGNED
     COMBO-BOX-Mes-2 AT ROW 3.5 COL 20 COLON-ALIGNED
     x-Detallado AT ROW 4.27 COL 22
     BUTTON-1 AT ROW 1.38 COL 50
     BUTTON-2 AT ROW 3.12 COL 50
     BUTTON-3 AT ROW 4.85 COL 50
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 17
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
         TITLE              = "Resumen de Planillas Anual"
         HEIGHT             = 5.5
         WIDTH              = 72.14
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
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Resumen de Planillas Anual */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Resumen de Planillas Anual */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
  ASSIGN COMBO-BOX-Periodo COMBO-BOX-Mes-1 COMBO-BOX-Mes-2 x-Detallado.
  RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  RUN dispatch IN THIS-PROCEDURE ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
  ASSIGN COMBO-BOX-Periodo COMBO-BOX-Mes-1 COMBO-BOX-Mes-2 x-Detallado.
  IF x-Detallado = YES 
  THEN RUN Texto-1.
  ELSE RUN Texto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
{src/adm/template/cntnrwin.i}

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-NroMes AS INT NO-UNDO.
  DEF VAR x-Meses  AS CHAR NO-UNDO.

  REPEAT:
    s-task-no = RANDOM(1,999999).
    IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK)
    THEN LEAVE.
  END.

  x-Meses = 'ENE,FEB,MAR,ABR,MAY,JUN,JUL,AGO,SET,OCT,NOV,DIC'.
  /*DO x-NroMes = 01 TO 12:*/
  DO x-NroMes = COMBO-BOX-Mes-1 TO COMBO-BOX-Mes-2:
    FOR EACH PL-SEM NO-LOCK WHERE PL-SEM.codcia = s-codcia 
        AND PL-SEM.periodo = COMBO-BOX-Periodo
        AND PL-SEM.nromes  = x-NroMes:
    FOR EACH PL-MOV-SEM NO-LOCK WHERE PL-MOV-SEM.codcia = s-codcia
            AND PL-MOV-SEM.periodo = COMBO-BOX-Periodo
            AND PL-MOV-SEM.nrosem  = PL-SEM.NroSem
            AND PL-MOV-SEM.codpln  = 02:
        DISPLAY pl-mov-sem.codper @ Fi-Mensaje LABEL "Personal "
             FORMAT "X(11)" 
             WITH FRAME F-Proceso.
        FIND w-report WHERE w-report.task-no = s-task-no 
            AND w-report.Llave-I = x-NroMes EXCLUSIVE-LOCK NO-ERROR.        
        IF NOT AVAILABLE w-report
        THEN CREATE w-report.
        ASSIGN
            w-report.task-no = s-task-no
            w-report.Llave-I = x-nromes
            w-report.Campo-C[1] = ENTRY(x-NroMes, x-Meses).
        CASE PL-MOV-SEM.codcal:
            WHEN 001 THEN DO:           /* Planilla de sueldos */
                CASE PL-MOV-SEM.codmov:
                    WHEN 151 THEN campo-f[1] = campo-f[1] + PL-MOV-SEM.valcal-sem.
                    WHEN 152 THEN campo-f[18] = campo-f[18] + PL-MOV-SEM.valcal-sem.
                    WHEN 136 THEN campo-f[2] = campo-f[2] + PL-MOV-SEM.valcal-sem.
                    WHEN 103 THEN campo-f[3] = campo-f[3] + PL-MOV-SEM.valcal-sem.
                    WHEN 125 OR WHEN 126 OR WHEN 127
                        THEN campo-f[4] = campo-f[4] + PL-MOV-SEM.valcal-sem.
                    WHEN 209 THEN campo-f[5] = campo-f[5] + PL-MOV-SEM.valcal-sem.
                    WHEN 131 THEN campo-f[6] = campo-f[6] + PL-MOV-SEM.valcal-sem.
                    WHEN 134 OR WHEN 138 OR WHEN 116
                        THEN campo-f[7] = campo-f[7] + PL-MOV-SEM.valcal-sem.
                    WHEN 139 THEN campo-f[8] = campo-f[8] + PL-MOV-SEM.valcal-sem.
                    WHEN 106 OR WHEN 107 OR WHEN 108
                        THEN campo-f[9] = campo-f[9] + PL-MOV-SEM.valcal-sem.
                    WHEN 202 THEN campo-f[10] = campo-f[10] + PL-MOV-SEM.valcal-sem.
                    WHEN 221 OR WHEN 222 OR WHEN 225
                        THEN campo-f[11] = campo-f[11] + PL-MOV-SEM.valcal-sem.
                    WHEN 215 THEN campo-f[12] = campo-f[12] + PL-MOV-SEM.valcal-sem.
                    WHEN 227 THEN campo-f[13] = campo-f[13] + PL-MOV-SEM.valcal-sem.
                    WHEN 204 THEN campo-f[14] = campo-f[14] + PL-MOV-SEM.valcal-sem.
                    WHEN 207 THEN campo-f[15] = campo-f[15] + PL-MOV-SEM.valcal-sem.
                    WHEN 301 THEN campo-f[16] = campo-f[16] + PL-MOV-SEM.valcal-sem.
                    WHEN 305 THEN campo-f[17] = campo-f[17] + PL-MOV-SEM.valcal-sem.
                END CASE.
            END.
            WHEN 004 THEN DO:           /* Planilla de Gratificaciones */
                CASE PL-MOV-MES.codmov:
                    WHEN 212 THEN campo-f[8] = campo-f[8] + PL-MOV-SEM.valcal-sem.
                    WHEN 202 THEN campo-f[10] = campo-f[10] + PL-MOV-SEM.valcal-sem.
                    WHEN 221 OR WHEN 222 OR WHEN 225
                        THEN campo-f[11] = campo-f[11] + PL-MOV-SEM.valcal-sem.
                    WHEN 215 THEN campo-f[12] = campo-f[12] + PL-MOV-SEM.valcal-sem.
                    WHEN 227 THEN campo-f[13] = campo-f[13] + PL-MOV-SEM.valcal-sem.
                    WHEN 204 THEN campo-f[14] = campo-f[14] + PL-MOV-SEM.valcal-sem.
                    WHEN 207 THEN campo-f[15] = campo-f[15] + PL-MOV-SEM.valcal-sem.
                    WHEN 301 THEN campo-f[16] = campo-f[16] + PL-MOV-SEM.valcal-sem.
                    WHEN 305 THEN campo-f[17] = campo-f[17] + PL-MOV-SEM.valcal-sem.
                END CASE.
            END.
        END CASE.            
    END.
    END.
  END.            
  HIDE FRAME F-PROCESO.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-1 W-Win 
PROCEDURE Carga-Temporal-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-NroMes AS INT NO-UNDO.
  DEF VAR x-Meses  AS CHAR NO-UNDO.
  DEF VAR x-NroEmp AS INT NO-UNDO.

  REPEAT:
    s-task-no = RANDOM(1,999999).
    IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK)
    THEN LEAVE.
  END.

  x-Meses = 'ENE,FEB,MAR,ABR,MAY,JUN,JUL,AGO,SET,OCT,NOV,DIC'.
  /*DO x-NroMes = 01 TO 12:*/
  DO x-NroMes = COMBO-BOX-Mes-1 TO COMBO-BOX-Mes-2:
    x-NroEmp = 0.       /* Cantidad de empleados en la planilla */
    FOR EACH PL-SEM NO-LOCK WHERE PL-SEM.codcia = s-codcia 
        AND PL-SEM.periodo = COMBO-BOX-Periodo
        AND PL-SEM.nromes  = x-NroMes:
        FOR EACH PL-MOV-SEM NO-LOCK WHERE PL-MOV-SEM.codcia = s-codcia
                AND PL-MOV-SEM.periodo = COMBO-BOX-Periodo
                AND PL-MOV-SEM.nrosem  = PL-SEM.NroSem
                AND PL-MOV-SEM.codpln  = 02,
                FIRST PL-PERS OF PL-MOV-SEM
                BREAK BY PL-MOV-SEM.codper:
            IF FIRST-OF(PL-MOV-SEM.codper) THEN x-NroEmp = x-NroEmp + 1.
            DISPLAY pl-mov-sem.codper @ Fi-Mensaje LABEL "Personal "
                 FORMAT "X(11)" 
                 WITH FRAME F-Proceso.
            FIND w-report WHERE w-report.task-no = s-task-no 
                AND w-report.Llave-I = x-NroMes 
                AND w-report.Llave-C = PL-MOV-SEM.CodPer
                EXCLUSIVE-LOCK NO-ERROR.        
            IF NOT AVAILABLE w-report
            THEN CREATE w-report.
            ASSIGN
                w-report.task-no = s-task-no
                w-report.Llave-I = x-nromes
                w-report.Llave-C = PL-MOV-SEM.CodPer
                w-report.Campo-C[2] = TRIM(PL-PERS.patper) + ' ' + TRIM(PL-PERS.matper) + ', ' + PL-PERS.nomper
                w-report.Campo-C[1] = ENTRY(x-NroMes, x-Meses)
                w-report.campo-f[20] = x-NroEmp.
            CASE PL-MOV-SEM.codcal:
                WHEN 001 THEN DO:           /* Planilla de sueldos */
                    CASE PL-MOV-SEM.codmov:
                        WHEN 151 THEN campo-f[1] = campo-f[1] + PL-MOV-SEM.valcal-sem.
                        WHEN 152 THEN campo-f[18] = campo-f[18] + PL-MOV-SEM.valcal-sem.
                        WHEN 136 THEN campo-f[2] = campo-f[2] + PL-MOV-SEM.valcal-sem.
                        WHEN 103 THEN campo-f[3] = campo-f[3] + PL-MOV-SEM.valcal-sem.
                        WHEN 125 OR WHEN 126 OR WHEN 127
                            THEN campo-f[4] = campo-f[4] + PL-MOV-SEM.valcal-sem.
                        WHEN 209 THEN campo-f[5] = campo-f[5] + PL-MOV-SEM.valcal-sem.
                        WHEN 131 THEN campo-f[6] = campo-f[6] + PL-MOV-SEM.valcal-sem.
                        WHEN 134 OR WHEN 138 OR WHEN 116
                            THEN campo-f[7] = campo-f[7] + PL-MOV-SEM.valcal-sem.
                        WHEN 139 THEN campo-f[8] = campo-f[8] + PL-MOV-SEM.valcal-sem.
                        WHEN 106 OR WHEN 107 OR WHEN 108
                            THEN campo-f[9] = campo-f[9] + PL-MOV-SEM.valcal-sem.
                        WHEN 202 THEN campo-f[10] = campo-f[10] + PL-MOV-SEM.valcal-sem.
                        WHEN 221 OR WHEN 222 OR WHEN 225
                            THEN campo-f[11] = campo-f[11] + PL-MOV-SEM.valcal-sem.
                        WHEN 215 THEN campo-f[12] = campo-f[12] + PL-MOV-SEM.valcal-sem.
                        WHEN 227 THEN campo-f[13] = campo-f[13] + PL-MOV-SEM.valcal-sem.
                        WHEN 204 THEN campo-f[14] = campo-f[14] + PL-MOV-SEM.valcal-sem.
                        WHEN 207 THEN campo-f[15] = campo-f[15] + PL-MOV-SEM.valcal-sem.
                        WHEN 301 THEN campo-f[16] = campo-f[16] + PL-MOV-SEM.valcal-sem.
                        WHEN 305 THEN campo-f[17] = campo-f[17] + PL-MOV-SEM.valcal-sem.
                    END CASE.
                END.
                WHEN 004 THEN DO:           /* Planilla de Gratificaciones */
                    CASE PL-MOV-MES.codmov:
                        WHEN 212 THEN campo-f[8] = campo-f[8] + PL-MOV-SEM.valcal-sem.
                        WHEN 202 THEN campo-f[10] = campo-f[10] + PL-MOV-SEM.valcal-sem.
                        WHEN 221 OR WHEN 222 OR WHEN 225
                            THEN campo-f[11] = campo-f[11] + PL-MOV-SEM.valcal-sem.
                        WHEN 215 THEN campo-f[12] = campo-f[12] + PL-MOV-SEM.valcal-sem.
                        WHEN 227 THEN campo-f[13] = campo-f[13] + PL-MOV-SEM.valcal-sem.
                        WHEN 204 THEN campo-f[14] = campo-f[14] + PL-MOV-SEM.valcal-sem.
                        WHEN 207 THEN campo-f[15] = campo-f[15] + PL-MOV-SEM.valcal-sem.
                        WHEN 301 THEN campo-f[16] = campo-f[16] + PL-MOV-SEM.valcal-sem.
                        WHEN 305 THEN campo-f[17] = campo-f[17] + PL-MOV-SEM.valcal-sem.
                    END CASE.
                END.
            END CASE.            
        END.
    END.
  END.            
  HIDE FRAME F-PROCESO.
  
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
  DISPLAY COMBO-BOX-Periodo COMBO-BOX-Mes-1 COMBO-BOX-Mes-2 x-Detallado 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX-Periodo COMBO-BOX-Mes-1 COMBO-BOX-Mes-2 x-Detallado BUTTON-1 
         BUTTON-2 BUTTON-3 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato W-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-TotIng AS DEC NO-UNDO.
  DEF VAR x-TotDes AS DEC NO-UNDO.
  DEF VAR x-NetPag AS DEC NO-UNDO.
  
  DEFINE FRAME F-REPORTE
    w-report.campo-c[1] FORMAT 'x(10)' COLUMN-LABEL "Mes" 
    w-report.campo-f[1] FORMAT '>>>>>>9.99' COLUMN-LABEL "Remuner.Basica" 
    w-report.campo-f[18] FORMAT '>>>>>>9.99' COLUMN-LABEL "Dominical" 
    w-report.campo-f[2] FORMAT '>>>>>>9.99' COLUMN-LABEL "Reintegros"
    w-report.campo-f[3] FORMAT '>>>>>>9.99' COLUMN-LABEL "Asign.!Familiar"
    w-report.campo-f[4] FORMAT '>>>>>>9.99' COLUMN-LABEL "H.Extras"
    w-report.campo-f[5] FORMAT '>>>>>>9.99' COLUMN-LABEL "Comisiones"
    w-report.campo-f[6] FORMAT '>>>>>>9.99' COLUMN-LABEL "Incentivo"
    w-report.campo-f[7] FORMAT '>>>>>>9.99' COLUMN-LABEL "B.Grat.!Extra"
    w-report.campo-f[8] FORMAT '>>>>>>9.99' COLUMN-LABEL "Grat.!Jul./Dic."
    w-report.campo-f[9] FORMAT '>>>>>>9.99' COLUMN-LABEL "Vacaciones"
    x-TotIng            FORMAT '>>>>>>9.99' COLUMN-LABEL "Total!Ingresos"
    w-report.campo-f[10] FORMAT '>>>>>>9.99' COLUMN-LABEL "SNP"
    w-report.campo-f[11] FORMAT '>>>>>>9.99' COLUMN-LABEL "SPP"
    w-report.campo-f[12] FORMAT '>>>>>>9.99' COLUMN-LABEL "5 Categoria"
    w-report.campo-f[13] FORMAT '>>>>>>9.99' COLUMN-LABEL "ESS VIDA"
    w-report.campo-f[14] FORMAT '>>>>>>9.99' COLUMN-LABEL "Prestamos"
    w-report.campo-f[15] FORMAT '>>>>>>9.99' COLUMN-LABEL "Otros"
    x-TotDes             FORMAT '>>>>>>9.99' COLUMN-LABEL "Total!Descuentos"
    x-NetPag             FORMAT '>>>>>>9.99' COLUMN-LABEL "Neto Pagar"
    w-report.campo-f[16] FORMAT '>>>>>>9.99' COLUMN-LABEL "ESSALUD"
    w-report.campo-f[17] FORMAT '>>>>>>9.99' COLUMN-LABEL "IESS"
    WITH WIDTH 250 NO-BOX STREAM-IO DOWN.
 
  DEFINE FRAME F-HEADER       
    HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN4} FORMAT "X(45)" SKIP
        {&PRN6A} + "RESUMEN DE PLANILLAS DE OBREROS"  AT 100 FORMAT 'x(35)'
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 200 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN4} + "Fecha : " AT 200 STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        "Hora  : " AT 200 STRING(TIME,"HH:MM:SS") SKIP
        s-Titulo FORMAT 'x(50)' SKIP
    WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
 
  FOR EACH w-report WHERE w-report.task-no = s-task-no BREAK BY w-report.task-no:
    VIEW STREAM REPORT FRAME F-HEADER.
    ASSIGN
        x-TotIng = w-report.campo-f[1] + w-report.campo-f[18] + w-report.campo-f[2] + w-report.campo-f[3] +
                w-report.campo-f[4] + w-report.campo-f[5] + w-report.campo-f[6] +
                w-report.campo-f[7] + w-report.campo-f[8] + w-report.campo-f[9]
        x-TotDes = w-report.campo-f[10] + w-report.campo-f[11] + w-report.campo-f[12] + 
                w-report.campo-f[13] + w-report.campo-f[14] + w-report.campo-f[15]
        x-NetPag = x-TotIng - x-TotDes.                
    ACCUMULATE w-report.campo-f[1] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[18] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[2] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[3] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[4] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[5] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[6] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[7] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[8] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[9] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[10] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[11] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[12] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[13] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[14] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[15] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[16] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[17] (TOTAL BY w-report.task-no).
    ACCUMULATE x-toting (TOTAL BY w-report.task-no).
    ACCUMULATE x-totdes (TOTAL BY w-report.task-no).
    ACCUMULATE x-netpag (TOTAL BY w-report.task-no).
    DISPLAY STREAM REPORT
        w-report.campo-c[1] 
        w-report.campo-f[1] 
        w-report.campo-f[18] 
        w-report.campo-f[2] 
        w-report.campo-f[3] 
        w-report.campo-f[4] 
        w-report.campo-f[5] 
        w-report.campo-f[6] 
        w-report.campo-f[7] 
        w-report.campo-f[8] 
        w-report.campo-f[9] 
        x-toting
        w-report.campo-f[10]
        w-report.campo-f[11]
        w-report.campo-f[12]
        w-report.campo-f[13]
        w-report.campo-f[14]
        w-report.campo-f[15]
        x-totdes
        x-netpag
        w-report.campo-f[16]
        w-report.campo-f[17]
        WITH FRAME F-REPORTE.
    IF LAST-OF(w-report.task-no)
    THEN DO:
        UNDERLINE STREAM REPORT
        w-report.campo-c[1] 
        w-report.campo-f[1] 
        w-report.campo-f[18] 
        w-report.campo-f[2] 
        w-report.campo-f[3] 
        w-report.campo-f[4] 
        w-report.campo-f[5] 
        w-report.campo-f[6] 
        w-report.campo-f[7] 
        w-report.campo-f[8] 
        w-report.campo-f[9] 
        x-toting
        w-report.campo-f[10]
        w-report.campo-f[11]
        w-report.campo-f[12]
        w-report.campo-f[13]
        w-report.campo-f[14]
        w-report.campo-f[15]
        x-totdes
        x-netpag
        w-report.campo-f[16]
        w-report.campo-f[17]
        WITH FRAME F-REPORTE.
        
        DISPLAY STREAM REPORT
            "TOTAL" @ w-report.campo-c[1]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[1] @ w-report.campo-f[1]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[18] @ w-report.campo-f[18]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[2] @ w-report.campo-f[2]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[3] @ w-report.campo-f[3]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[4] @ w-report.campo-f[4]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[5] @ w-report.campo-f[5]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[6] @ w-report.campo-f[6]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[7] @ w-report.campo-f[7]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[8] @ w-report.campo-f[8]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[9] @ w-report.campo-f[9]
            ACCUM TOTAL BY w-report.task-no x-toting @ x-toting
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[10] @ w-report.campo-f[10]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[11] @ w-report.campo-f[11]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[12] @ w-report.campo-f[12]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[13] @ w-report.campo-f[13]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[14] @ w-report.campo-f[14]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[15] @ w-report.campo-f[15]
            ACCUM TOTAL BY w-report.task-no x-totdes @ x-totdes
            ACCUM TOTAL BY w-report.task-no x-netpag @ x-netpag
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[16] @ w-report.campo-f[16]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[17] @ w-report.campo-f[17]
            WITH FRAME F-REPORTE.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-1 W-Win 
PROCEDURE Formato-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-TotIng AS DEC NO-UNDO.
  DEF VAR x-TotDes AS DEC NO-UNDO.
  DEF VAR x-NetPag AS DEC NO-UNDO.
  
  DEFINE FRAME F-REPORTE
    w-report.campo-c[1] FORMAT 'x(10)' COLUMN-LABEL "Mes" 
    w-report.llave-c    FORMAT 'x(6)'       COLUMN-LABEL "Codigo"
    w-report.campo-c[2] FORMAT 'x(40)'      COLUMN-LABEL "Apellidos y nombres"
    w-report.campo-f[1] FORMAT '>>>>>>9.99' COLUMN-LABEL "Remuner.Basica" 
    w-report.campo-f[18] FORMAT '>>>>>>9.99' COLUMN-LABEL "Dominical" 
    w-report.campo-f[2] FORMAT '>>>>>>9.99' COLUMN-LABEL "Reintegros"
    w-report.campo-f[3] FORMAT '>>>>>>9.99' COLUMN-LABEL "Asign.!Familiar"
    w-report.campo-f[4] FORMAT '>>>>>>9.99' COLUMN-LABEL "H.Extras"
    w-report.campo-f[5] FORMAT '>>>>>>9.99' COLUMN-LABEL "Comisiones"
    w-report.campo-f[6] FORMAT '>>>>>>9.99' COLUMN-LABEL "Incentivo"
    w-report.campo-f[7] FORMAT '>>>>>>9.99' COLUMN-LABEL "B.Grat.!Extra"
    w-report.campo-f[8] FORMAT '>>>>>>9.99' COLUMN-LABEL "Grat.!Jul./Dic."
    w-report.campo-f[9] FORMAT '>>>>>>9.99' COLUMN-LABEL "Vacaciones"
    x-TotIng            FORMAT '>>>>>>9.99' COLUMN-LABEL "Total!Ingresos"
    w-report.campo-f[10] FORMAT '>>>>>>9.99' COLUMN-LABEL "SNP"
    w-report.campo-f[11] FORMAT '>>>>>>9.99' COLUMN-LABEL "SPP"
    w-report.campo-f[12] FORMAT '>>>>>>9.99' COLUMN-LABEL "5 Categoria"
    w-report.campo-f[13] FORMAT '>>>>>>9.99' COLUMN-LABEL "ESS VIDA"
    w-report.campo-f[14] FORMAT '>>>>>>9.99' COLUMN-LABEL "Prestamos"
    w-report.campo-f[15] FORMAT '>>>>>>9.99' COLUMN-LABEL "Otros"
    x-TotDes             FORMAT '>>>>>>9.99' COLUMN-LABEL "Total!Descuentos"
    x-NetPag             FORMAT '>>>>>>9.99' COLUMN-LABEL "Neto Pagar"
    w-report.campo-f[16] FORMAT '>>>>>>9.99' COLUMN-LABEL "ESSALUD"
    w-report.campo-f[17] FORMAT '>>>>>>9.99' COLUMN-LABEL "IESS"
    WITH WIDTH 320 NO-BOX STREAM-IO DOWN.
 
  DEFINE FRAME F-HEADER       
    HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN4} FORMAT "X(45)" SKIP
        {&PRN6A} + "RESUMEN DE PLANILLAS DE OBREROS"  AT 100 FORMAT 'x(35)'
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 200 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN4} + "Fecha : " AT 200 STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        "Hora  : " AT 200 STRING(TIME,"HH:MM:SS") SKIP
        s-Titulo FORMAT 'x(50)' SKIP
    WITH PAGE-TOP WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
 
  FOR EACH w-report WHERE w-report.task-no = s-task-no BREAK BY w-report.task-no:
    VIEW STREAM REPORT FRAME F-HEADER.
    ASSIGN
        x-TotIng = w-report.campo-f[1] + w-report.campo-f[18] + w-report.campo-f[2] + w-report.campo-f[3] +
                w-report.campo-f[4] + w-report.campo-f[5] + w-report.campo-f[6] +
                w-report.campo-f[7] + w-report.campo-f[8] + w-report.campo-f[9]
        x-TotDes = w-report.campo-f[10] + w-report.campo-f[11] + w-report.campo-f[12] + 
                w-report.campo-f[13] + w-report.campo-f[14] + w-report.campo-f[15]
        x-NetPag = x-TotIng - x-TotDes.                
    ACCUMULATE w-report.campo-f[1] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[18] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[2] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[3] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[4] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[5] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[6] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[7] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[8] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[9] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[10] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[11] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[12] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[13] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[14] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[15] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[16] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[17] (TOTAL BY w-report.task-no).
    ACCUMULATE x-toting (TOTAL BY w-report.task-no).
    ACCUMULATE x-totdes (TOTAL BY w-report.task-no).
    ACCUMULATE x-netpag (TOTAL BY w-report.task-no).
    DISPLAY STREAM REPORT
        w-report.campo-c[1] 
        w-report.llave-c    
        w-report.campo-c[2] 
        w-report.campo-f[1] 
        w-report.campo-f[18] 
        w-report.campo-f[2] 
        w-report.campo-f[3] 
        w-report.campo-f[4] 
        w-report.campo-f[5] 
        w-report.campo-f[6] 
        w-report.campo-f[7] 
        w-report.campo-f[8] 
        w-report.campo-f[9] 
        x-toting
        w-report.campo-f[10]
        w-report.campo-f[11]
        w-report.campo-f[12]
        w-report.campo-f[13]
        w-report.campo-f[14]
        w-report.campo-f[15]
        x-totdes
        x-netpag
        w-report.campo-f[16]
        w-report.campo-f[17]
        WITH FRAME F-REPORTE.
    IF LAST-OF(w-report.task-no)
    THEN DO:
        UNDERLINE STREAM REPORT
        w-report.campo-c[1] 
        w-report.campo-f[1] 
        w-report.campo-f[18] 
        w-report.campo-f[2] 
        w-report.campo-f[3] 
        w-report.campo-f[4] 
        w-report.campo-f[5] 
        w-report.campo-f[6] 
        w-report.campo-f[7] 
        w-report.campo-f[8] 
        w-report.campo-f[9] 
        x-toting
        w-report.campo-f[10]
        w-report.campo-f[11]
        w-report.campo-f[12]
        w-report.campo-f[13]
        w-report.campo-f[14]
        w-report.campo-f[15]
        x-totdes
        x-netpag
        w-report.campo-f[16]
        w-report.campo-f[17]
        WITH FRAME F-REPORTE.
        
        DISPLAY STREAM REPORT
            "TOTAL" @ w-report.campo-c[1]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[1] @ w-report.campo-f[1]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[18] @ w-report.campo-f[18]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[2] @ w-report.campo-f[2]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[3] @ w-report.campo-f[3]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[4] @ w-report.campo-f[4]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[5] @ w-report.campo-f[5]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[6] @ w-report.campo-f[6]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[7] @ w-report.campo-f[7]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[8] @ w-report.campo-f[8]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[9] @ w-report.campo-f[9]
            ACCUM TOTAL BY w-report.task-no x-toting @ x-toting
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[10] @ w-report.campo-f[10]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[11] @ w-report.campo-f[11]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[12] @ w-report.campo-f[12]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[13] @ w-report.campo-f[13]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[14] @ w-report.campo-f[14]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[15] @ w-report.campo-f[15]
            ACCUM TOTAL BY w-report.task-no x-totdes @ x-totdes
            ACCUM TOTAL BY w-report.task-no x-netpag @ x-netpag
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[16] @ w-report.campo-f[16]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[17] @ w-report.campo-f[17]
            WITH FRAME F-REPORTE.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir W-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF x-Detallado
    THEN RUN Carga-Temporal-1.
    ELSE RUN Carga-Temporal.

    FIND FIRST w-report NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        MESSAGE
            "No hay registros a imprimir"
            VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.
    s-Titulo = 'RESUMEN DE ENERO A DICIEMBRE DEL ' +
        STRING(COMBO-BOX-Periodo, '9999').

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        IF x-Detallado = YES 
        THEN RUN Formato-1.
        ELSE RUN Formato.
        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            RUN LIB/W-README.R(s-print-file).
            IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

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
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        COMBO-BOX-Periodo:LIST-ITEMS = x-Periodo
        COMBO-BOX-Periodo = s-periodo.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Texto W-Win 
PROCEDURE Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-Archivo AS CHAR NO-UNDO.
  DEF VAR x-Rpta    AS LOG  NO-UNDO.

  x-Archivo = 'Obreros' + STRING(COMBO-BOX-Periodo, '9999') + STRING(COMBO-BOX-Mes-1, '99') + '.txt'.
  SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS 'Texto' '*.txt'
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION '.txt'
    INITIAL-DIR 'c:\tmp'
    RETURN-TO-START-DIR 
    USE-FILENAME
    SAVE-AS
    UPDATE x-rpta.
  IF x-rpta = NO THEN RETURN.

  RUN Carga-Temporal.
  FIND FIRST w-report WHERE w-report.task-no = s-task-no 
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE w-report
  THEN DO:
      MESSAGE "Fin de archivo" VIEW-AS ALERT-BOX WARNING.
      RETURN.
  END.

  DEF VAR x-TotIng AS DEC NO-UNDO.
  DEF VAR x-TotDes AS DEC NO-UNDO.
  DEF VAR x-NetPag AS DEC NO-UNDO.
  
  DEFINE FRAME F-REPORTE
    w-report.campo-c[1] FORMAT 'x(10)' COLUMN-LABEL "Mes" 
    w-report.campo-f[1] FORMAT '>>>>>>9.99' COLUMN-LABEL "Remuner.Basica" 
    w-report.campo-f[18] FORMAT '>>>>>>9.99' COLUMN-LABEL "Dominical" 
    w-report.campo-f[2] FORMAT '>>>>>>9.99' COLUMN-LABEL "Reintegros"
    w-report.campo-f[3] FORMAT '>>>>>>9.99' COLUMN-LABEL "Asign.!Familiar"
    w-report.campo-f[4] FORMAT '>>>>>>9.99' COLUMN-LABEL "H.Extras"
    w-report.campo-f[5] FORMAT '>>>>>>9.99' COLUMN-LABEL "Comisiones"
    w-report.campo-f[6] FORMAT '>>>>>>9.99' COLUMN-LABEL "Incentivo"
    w-report.campo-f[7] FORMAT '>>>>>>9.99' COLUMN-LABEL "B.Grat.!Extra"
    w-report.campo-f[8] FORMAT '>>>>>>9.99' COLUMN-LABEL "Grat.!Jul./Dic."
    w-report.campo-f[9] FORMAT '>>>>>>9.99' COLUMN-LABEL "Vacaciones"
    x-TotIng            FORMAT '>>>>>>9.99' COLUMN-LABEL "Total!Ingresos"
    w-report.campo-f[10] FORMAT '>>>>>>9.99' COLUMN-LABEL "SNP"
    w-report.campo-f[11] FORMAT '>>>>>>9.99' COLUMN-LABEL "SPP"
    w-report.campo-f[12] FORMAT '>>>>>>9.99' COLUMN-LABEL "5 Categoria"
    w-report.campo-f[13] FORMAT '>>>>>>9.99' COLUMN-LABEL "ESS VIDA"
    w-report.campo-f[14] FORMAT '>>>>>>9.99' COLUMN-LABEL "Prestamos"
    w-report.campo-f[15] FORMAT '>>>>>>9.99' COLUMN-LABEL "Otros"
    x-TotDes             FORMAT '>>>>>>9.99' COLUMN-LABEL "Total!Descuentos"
    x-NetPag             FORMAT '>>>>>>9.99' COLUMN-LABEL "Neto Pagar"
    w-report.campo-f[16] FORMAT '>>>>>>9.99' COLUMN-LABEL "ESSALUD"
    w-report.campo-f[17] FORMAT '>>>>>>9.99' COLUMN-LABEL "IESS"
    WITH WIDTH 250 NO-BOX STREAM-IO DOWN.
 
  OUTPUT STREAM REPORT TO VALUE(x-Archivo). 
  FOR EACH w-report WHERE w-report.task-no = s-task-no BREAK BY w-report.task-no:
    ASSIGN
        x-TotIng = w-report.campo-f[1] + w-report.campo-f[18] + w-report.campo-f[2] + w-report.campo-f[3] +
                w-report.campo-f[4] + w-report.campo-f[5] + w-report.campo-f[6] +
                w-report.campo-f[7] + w-report.campo-f[8] + w-report.campo-f[9]
        x-TotDes = w-report.campo-f[10] + w-report.campo-f[11] + w-report.campo-f[12] + 
                w-report.campo-f[13] + w-report.campo-f[14] + w-report.campo-f[15]
        x-NetPag = x-TotIng - x-TotDes.                
    ACCUMULATE w-report.campo-f[1] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[18] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[2] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[3] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[4] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[5] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[6] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[7] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[8] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[9] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[10] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[11] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[12] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[13] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[14] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[15] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[16] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[17] (TOTAL BY w-report.task-no).
    ACCUMULATE x-toting (TOTAL BY w-report.task-no).
    ACCUMULATE x-totdes (TOTAL BY w-report.task-no).
    ACCUMULATE x-netpag (TOTAL BY w-report.task-no).
    DISPLAY STREAM REPORT
        w-report.campo-c[1] 
        w-report.campo-f[1] 
        w-report.campo-f[18] 
        w-report.campo-f[2] 
        w-report.campo-f[3] 
        w-report.campo-f[4] 
        w-report.campo-f[5] 
        w-report.campo-f[6] 
        w-report.campo-f[7] 
        w-report.campo-f[8] 
        w-report.campo-f[9] 
        x-toting
        w-report.campo-f[10]
        w-report.campo-f[11]
        w-report.campo-f[12]
        w-report.campo-f[13]
        w-report.campo-f[14]
        w-report.campo-f[15]
        x-totdes
        x-netpag
        w-report.campo-f[16]
        w-report.campo-f[17]
        WITH FRAME F-REPORTE.
    IF LAST-OF(w-report.task-no)
    THEN DO:
        UNDERLINE STREAM REPORT
        w-report.campo-c[1] 
        w-report.campo-f[1] 
        w-report.campo-f[18] 
        w-report.campo-f[2] 
        w-report.campo-f[3] 
        w-report.campo-f[4] 
        w-report.campo-f[5] 
        w-report.campo-f[6] 
        w-report.campo-f[7] 
        w-report.campo-f[8] 
        w-report.campo-f[9] 
        x-toting
        w-report.campo-f[10]
        w-report.campo-f[11]
        w-report.campo-f[12]
        w-report.campo-f[13]
        w-report.campo-f[14]
        w-report.campo-f[15]
        x-totdes
        x-netpag
        w-report.campo-f[16]
        w-report.campo-f[17]
        WITH FRAME F-REPORTE.
        
        DISPLAY STREAM REPORT
            "TOTAL" @ w-report.campo-c[1]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[1] @ w-report.campo-f[1]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[18] @ w-report.campo-f[18]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[2] @ w-report.campo-f[2]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[3] @ w-report.campo-f[3]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[4] @ w-report.campo-f[4]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[5] @ w-report.campo-f[5]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[6] @ w-report.campo-f[6]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[7] @ w-report.campo-f[7]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[8] @ w-report.campo-f[8]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[9] @ w-report.campo-f[9]
            ACCUM TOTAL BY w-report.task-no x-toting @ x-toting
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[10] @ w-report.campo-f[10]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[11] @ w-report.campo-f[11]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[12] @ w-report.campo-f[12]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[13] @ w-report.campo-f[13]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[14] @ w-report.campo-f[14]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[15] @ w-report.campo-f[15]
            ACCUM TOTAL BY w-report.task-no x-totdes @ x-totdes
            ACCUM TOTAL BY w-report.task-no x-netpag @ x-netpag
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[16] @ w-report.campo-f[16]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[17] @ w-report.campo-f[17]
            WITH FRAME F-REPORTE.
    END.
  END.
  PAGE STREAM REPORT.
  OUTPUT STREAM REPORT CLOSE.
  FOR EACH w-report WHERE w-report.task-no = s-task-no:
    DELETE w-report.
  END.
  MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Texto-1 W-Win 
PROCEDURE Texto-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-Archivo AS CHAR NO-UNDO.
  DEF VAR x-Rpta    AS LOG  NO-UNDO.

  x-Archivo = 'Obreros' + STRING(COMBO-BOX-Periodo, '9999') + STRING(COMBO-BOX-Mes-1, '99') + '.txt'.
  SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS 'Texto' '*.txt'
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION '.txt'
    INITIAL-DIR 'c:\tmp'
    RETURN-TO-START-DIR 
    USE-FILENAME
    SAVE-AS
    UPDATE x-rpta.
  IF x-rpta = NO THEN RETURN.

  RUN Carga-Temporal-1.
  FIND FIRST w-report WHERE w-report.task-no = s-task-no 
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE w-report
  THEN DO:
      MESSAGE "Fin de archivo" VIEW-AS ALERT-BOX WARNING.
      RETURN.
  END.

  DEF VAR x-TotIng AS DEC NO-UNDO.
  DEF VAR x-TotDes AS DEC NO-UNDO.
  DEF VAR x-NetPag AS DEC NO-UNDO.
  
  DEFINE FRAME F-REPORTE
    w-report.campo-c[1] FORMAT 'x(10)' COLUMN-LABEL "Mes" 
    w-report.llave-c    FORMAT 'x(6)'       COLUMN-LABEL "Codigo"
    w-report.campo-c[2] FORMAT 'x(40)'      COLUMN-LABEL "Apellidos y nombres"
    w-report.campo-f[1] FORMAT '>>>>>>9.99' COLUMN-LABEL "Remuner.Basica" 
    w-report.campo-f[18] FORMAT '>>>>>>9.99' COLUMN-LABEL "Dominical" 
    w-report.campo-f[2] FORMAT '>>>>>>9.99' COLUMN-LABEL "Reintegros"
    w-report.campo-f[3] FORMAT '>>>>>>9.99' COLUMN-LABEL "Asign.!Familiar"
    w-report.campo-f[4] FORMAT '>>>>>>9.99' COLUMN-LABEL "H.Extras"
    w-report.campo-f[5] FORMAT '>>>>>>9.99' COLUMN-LABEL "Comisiones"
    w-report.campo-f[6] FORMAT '>>>>>>9.99' COLUMN-LABEL "Incentivo"
    w-report.campo-f[7] FORMAT '>>>>>>9.99' COLUMN-LABEL "B.Grat.!Extra"
    w-report.campo-f[8] FORMAT '>>>>>>9.99' COLUMN-LABEL "Grat.!Jul./Dic."
    w-report.campo-f[9] FORMAT '>>>>>>9.99' COLUMN-LABEL "Vacaciones"
    x-TotIng            FORMAT '>>>>>>9.99' COLUMN-LABEL "Total!Ingresos"
    w-report.campo-f[10] FORMAT '>>>>>>9.99' COLUMN-LABEL "SNP"
    w-report.campo-f[11] FORMAT '>>>>>>9.99' COLUMN-LABEL "SPP"
    w-report.campo-f[12] FORMAT '>>>>>>9.99' COLUMN-LABEL "5 Categoria"
    w-report.campo-f[13] FORMAT '>>>>>>9.99' COLUMN-LABEL "ESS VIDA"
    w-report.campo-f[14] FORMAT '>>>>>>9.99' COLUMN-LABEL "Prestamos"
    w-report.campo-f[15] FORMAT '>>>>>>9.99' COLUMN-LABEL "Otros"
    x-TotDes             FORMAT '>>>>>>9.99' COLUMN-LABEL "Total!Descuentos"
    x-NetPag             FORMAT '>>>>>>9.99' COLUMN-LABEL "Neto Pagar"
    w-report.campo-f[16] FORMAT '>>>>>>9.99' COLUMN-LABEL "ESSALUD"
    w-report.campo-f[17] FORMAT '>>>>>>9.99' COLUMN-LABEL "IESS"
    WITH WIDTH 320 NO-BOX STREAM-IO DOWN.
 
  OUTPUT STREAM REPORT TO VALUE(x-Archivo). 
  FOR EACH w-report WHERE w-report.task-no = s-task-no BREAK BY w-report.task-no:
    ASSIGN
        x-TotIng = w-report.campo-f[1] + w-report.campo-f[18] + w-report.campo-f[2] + w-report.campo-f[3] +
                w-report.campo-f[4] + w-report.campo-f[5] + w-report.campo-f[6] +
                w-report.campo-f[7] + w-report.campo-f[8] + w-report.campo-f[9]
        x-TotDes = w-report.campo-f[10] + w-report.campo-f[11] + w-report.campo-f[12] + 
                w-report.campo-f[13] + w-report.campo-f[14] + w-report.campo-f[15]
        x-NetPag = x-TotIng - x-TotDes.                
    ACCUMULATE w-report.campo-f[1] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[18] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[2] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[3] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[4] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[5] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[6] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[7] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[8] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[9] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[10] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[11] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[12] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[13] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[14] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[15] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[16] (TOTAL BY w-report.task-no).
    ACCUMULATE w-report.campo-f[17] (TOTAL BY w-report.task-no).
    ACCUMULATE x-toting (TOTAL BY w-report.task-no).
    ACCUMULATE x-totdes (TOTAL BY w-report.task-no).
    ACCUMULATE x-netpag (TOTAL BY w-report.task-no).
    DISPLAY STREAM REPORT
        w-report.campo-c[1] 
        w-report.llave-c    
        w-report.campo-c[2] 
        w-report.campo-f[1] 
        w-report.campo-f[18] 
        w-report.campo-f[2] 
        w-report.campo-f[3] 
        w-report.campo-f[4] 
        w-report.campo-f[5] 
        w-report.campo-f[6] 
        w-report.campo-f[7] 
        w-report.campo-f[8] 
        w-report.campo-f[9] 
        x-toting
        w-report.campo-f[10]
        w-report.campo-f[11]
        w-report.campo-f[12]
        w-report.campo-f[13]
        w-report.campo-f[14]
        w-report.campo-f[15]
        x-totdes
        x-netpag
        w-report.campo-f[16]
        w-report.campo-f[17]
        WITH FRAME F-REPORTE.
    IF LAST-OF(w-report.task-no)
    THEN DO:
        UNDERLINE STREAM REPORT
        w-report.campo-c[1] 
        w-report.campo-f[1] 
        w-report.campo-f[18] 
        w-report.campo-f[2] 
        w-report.campo-f[3] 
        w-report.campo-f[4] 
        w-report.campo-f[5] 
        w-report.campo-f[6] 
        w-report.campo-f[7] 
        w-report.campo-f[8] 
        w-report.campo-f[9] 
        x-toting
        w-report.campo-f[10]
        w-report.campo-f[11]
        w-report.campo-f[12]
        w-report.campo-f[13]
        w-report.campo-f[14]
        w-report.campo-f[15]
        x-totdes
        x-netpag
        w-report.campo-f[16]
        w-report.campo-f[17]
        WITH FRAME F-REPORTE.
        
        DISPLAY STREAM REPORT
            "TOTAL" @ w-report.campo-c[1]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[1] @ w-report.campo-f[1]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[18] @ w-report.campo-f[18]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[2] @ w-report.campo-f[2]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[3] @ w-report.campo-f[3]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[4] @ w-report.campo-f[4]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[5] @ w-report.campo-f[5]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[6] @ w-report.campo-f[6]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[7] @ w-report.campo-f[7]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[8] @ w-report.campo-f[8]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[9] @ w-report.campo-f[9]
            ACCUM TOTAL BY w-report.task-no x-toting @ x-toting
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[10] @ w-report.campo-f[10]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[11] @ w-report.campo-f[11]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[12] @ w-report.campo-f[12]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[13] @ w-report.campo-f[13]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[14] @ w-report.campo-f[14]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[15] @ w-report.campo-f[15]
            ACCUM TOTAL BY w-report.task-no x-totdes @ x-totdes
            ACCUM TOTAL BY w-report.task-no x-netpag @ x-netpag
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[16] @ w-report.campo-f[16]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[17] @ w-report.campo-f[17]
            WITH FRAME F-REPORTE.
    END.
  END.
  PAGE STREAM REPORT.
  OUTPUT STREAM REPORT CLOSE.
  FOR EACH w-report WHERE w-report.task-no = s-task-no:
    DELETE w-report.
  END.
  MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


