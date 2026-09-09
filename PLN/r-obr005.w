&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
DEF SHARED VAR cb-codcia AS INT.

/* Local Variable Definitions ---                                       */
DEF VAR x-Periodo AS CHAR NO-UNDO.
DEF VAR x-Meses   AS CHAR NO-UNDO.
DEF VAR i AS INT NO-UNDO.

x-Meses = 'ENERO,FEBRERO,MARZO,ABRIL,MAYO,JUNIO,JULIO,AGOSTO,SETIEMBRE,OCTUBRE,NOVIEMBRE,DICIEMBRE'.

RUN cbd/cb-m000 (OUTPUT x-Periodo).
IF x-Periodo = ''
THEN DO:
    MESSAGE 'NO existen periodos configurados para esta compañia'
        VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.

DEF VAR s-task-no AS INT INITIAL 0 NO-UNDO.
DEF VAR s-Titulo  AS CHAR NO-UNDO.

DEF TEMP-TABLE t-report
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
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-Periodo COMBO-BOX-NroMes ~
FILL-IN-CCosto BUTTON-1 BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Periodo COMBO-BOX-NroMes ~
FILL-IN-CCosto FILL-IN-NomAux 

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

DEFINE VARIABLE COMBO-BOX-NroMes AS INTEGER FORMAT "99":U INITIAL 1 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "01","02","03","04","05","06","07","08","09","10","11","12" 
     DROP-DOWN-LIST
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-CCosto AS CHARACTER FORMAT "X(256)":U 
     LABEL "Centro de Costo" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomAux AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-Periodo AT ROW 1.58 COL 19 COLON-ALIGNED
     COMBO-BOX-NroMes AT ROW 2.54 COL 19 COLON-ALIGNED
     FILL-IN-CCosto AT ROW 3.5 COL 19 COLON-ALIGNED
     FILL-IN-NomAux AT ROW 3.5 COL 27 COLON-ALIGNED NO-LABEL
     BUTTON-1 AT ROW 4.85 COL 6
     BUTTON-2 AT ROW 5.04 COL 25
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 71.86 BY 6.5
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
         TITLE              = "Resumen de Planillas Anual por Centro de Costo"
         HEIGHT             = 6.5
         WIDTH              = 71.86
         MAX-HEIGHT         = 6.5
         MAX-WIDTH          = 71.86
         VIRTUAL-HEIGHT     = 6.5
         VIRTUAL-WIDTH      = 71.86
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/bin/_prns.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN FILL-IN-NomAux IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Resumen de Planillas Anual por Centro de Costo */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Resumen de Planillas Anual por Centro de Costo */
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
  ASSIGN COMBO-BOX-Periodo COMBO-BOX-NroMes FILL-IN-CCosto.
  IF FILL-IN-CCosto <> ''
  THEN DO:
    FIND cb-auxi WHERE cb-auxi.codcia = cb-codcia
        AND cb-auxi.clfaux = 'CCO'
        AND cb-auxi.codaux = FILL-IN-CCosto
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-auxi
    THEN FIND cb-auxi WHERE cb-auxi.codcia = s-codcia
            AND cb-auxi.clfaux = 'CCO'
            AND cb-auxi.codaux = FILL-IN-CCosto
            NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-auxi
    THEN DO:
        MESSAGE 'Centro de costo no registrado'
            VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO FILL-IN-CCosto.
        RETURN NO-APPLY.
    END.
  END.
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


&Scoped-define SELF-NAME FILL-IN-CCosto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CCosto W-Win
ON LEAVE OF FILL-IN-CCosto IN FRAME F-Main /* Centro de Costo */
DO:
  FILL-IN-NomAux:SCREEN-VALUE = ''.
  FIND cb-auxi WHERE cb-auxi.codcia = cb-codcia
    AND cb-auxi.clfaux = 'CCO'
    AND cb-auxi.codaux = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE cb-auxi
  THEN FIND cb-auxi WHERE cb-auxi.codcia = s-codcia
            AND cb-auxi.clfaux = 'CCO'
            AND cb-auxi.codaux = SELF:SCREEN-VALUE
            NO-LOCK NO-ERROR.
  IF AVAILABLE cb-auxi
  THEN FILL-IN-NomAux:SCREEN-VALUE = cb-auxi.nomaux.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-1 W-Win 
PROCEDURE Carga-Temporal-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-nrosem AS INT NO-UNDO.

  FOR EACH t-report:
    DELETE t-report.
  END.

  REPEAT:
    s-task-no = RANDOM(1,999999).
    IF NOT CAN-FIND(FIRST t-report WHERE t-report.task-no = s-task-no NO-LOCK)
    THEN LEAVE.
  END.

  FOR EACH Pl-sem NO-LOCK WHERE Pl-sem.codcia = s-codcia
         AND Pl-sem.periodo = COMBO-BOX-Periodo
         AND Pl-sem.nromes  = COMBO-BOX-NroMes:
    x-nrosem = PL-SEM.NroSem.
    FOR EACH PL-MOV-SEM NO-LOCK WHERE PL-MOV-SEM.codcia = s-codcia
            AND PL-MOV-SEM.periodo = COMBO-BOX-Periodo
            AND PL-MOV-SEM.nrosem  = x-nrosem
            AND PL-MOV-SEM.codpln  = 02,
            FIRST PL-FLG-SEM OF PL-MOV-SEM NO-LOCK WHERE PL-FLG-SEM.ccosto BEGINS FILL-IN-CCosto,
            FIRST PL-PERS OF PL-FLG-SEM NO-LOCK:
        DISPLAY pl-mov-sem.codper @ Fi-Mensaje LABEL "Personal "
             FORMAT "X(11)" 
             WITH FRAME F-Proceso.
        FIND t-report WHERE t-report.task-no = s-task-no 
            AND t-report.Llave-C = PL-FLG-SEM.ccosto
            AND t-report.Campo-c[1] = PL-FLG-SEM.codper
            EXCLUSIVE-LOCK NO-ERROR.        
        IF NOT AVAILABLE t-report
        THEN CREATE t-report.
        ASSIGN
            t-report.task-no = s-task-no
            t-report.Llave-C = PL-FLG-SEM.ccosto
            t-report.Campo-c[1] = PL-FLG-SEM.codper
            t-report.Campo-c[2] = TRIM(PL-PERS.patper) + ' ' + TRIM(PL-PERS.matper) + ', ' + TRIM(PL-PERS.nomper).
        CASE PL-MOV-SEM.codcal:
            WHEN 001 THEN DO:           /* Planilla de sueldos */
                CASE PL-MOV-SEM.codmov:
                    WHEN 151 THEN campo-f[1] = campo-f[1] + PL-MOV-SEM.valcal-sem.
                    WHEN 136 THEN campo-f[2] = campo-f[2] + PL-MOV-SEM.valcal-sem.
                    WHEN 103 THEN campo-f[3] = campo-f[3] + PL-MOV-SEM.valcal-sem.
                    WHEN 125 OR WHEN 127 THEN campo-f[4] = campo-f[4] + PL-MOV-SEM.valcal-sem.
                    WHEN 126 THEN campo-f[5] = campo-f[5] + PL-MOV-SEM.valcal-sem.
                    WHEN 131 THEN campo-f[6] = campo-f[6] + PL-MOV-SEM.valcal-sem.
                    WHEN 134 THEN campo-f[7] = campo-f[7] + PL-MOV-SEM.valcal-sem.
                    WHEN 139 OR WHEN 212 THEN campo-f[8] = campo-f[8] + PL-MOV-SEM.valcal-sem.
                    WHEN 106 OR WHEN 107 OR WHEN 108 THEN campo-f[9] = campo-f[9] + PL-MOV-SEM.valcal-sem.
                    WHEN 138 THEN campo-f[10] = campo-f[10] + PL-MOV-SEM.valcal-sem.
                    WHEN 116 THEN campo-f[11] = campo-f[11] + PL-MOV-SEM.valcal-sem.
                    WHEN 401 THEN campo-f[12] = campo-f[12] + PL-MOV-SEM.valcal-sem.    /* BOLSA */
                    WHEN 152 THEN campo-f[13] = campo-f[13] + PL-MOV-SEM.valcal-sem.    /*se carga un campo dominical*/
                    WHEN 301 THEN campo-f[16] = campo-f[16] + PL-MOV-SEM.valcal-sem.
                    WHEN 305 THEN campo-f[17] = campo-f[17] + PL-MOV-SEM.valcal-sem.
                END CASE.
            END.
            WHEN 004 THEN DO:           /* Planilla de Gratificaciones */
                CASE PL-MOV-SEM.codmov:
                    WHEN 301 THEN campo-f[16] = campo-f[16] + PL-MOV-SEM.valcal-sem.
                    WHEN 305 THEN campo-f[17] = campo-f[17] + PL-MOV-SEM.valcal-sem.
                END CASE.
            END.
        END CASE.            
    END.
  END.            
  FOR EACH t-report WHERE t-report.task-no = s-task-no:
    t-report.campo-f[12] = t-report.campo-f[12] - ( t-report.campo-f[1] + t-report.campo-f[2] +
                            t-report.campo-f[3] + t-report.campo-f[4] + t-report.campo-f[5] +
                            t-report.campo-f[6] + t-report.campo-f[7] + t-report.campo-f[8] +
                            t-report.campo-f[9] + t-report.campo-f[10] + t-report.campo-f[11] +
                            t-report.campo-f[13] ).
  END.
  HIDE FRAME F-PROCESO.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win  _DEFAULT-ENABLE
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
  DISPLAY COMBO-BOX-Periodo COMBO-BOX-NroMes FILL-IN-CCosto FILL-IN-NomAux 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX-Periodo COMBO-BOX-NroMes FILL-IN-CCosto BUTTON-1 BUTTON-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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
  DEF VAR x-TotGto AS DEC NO-UNDO.
  DEF VAR x-NetPag AS DEC NO-UNDO.
  DEF VAR x-Descrip AS CHAR FORMAT 'x(40)' NO-UNDO.
  
  DEFINE FRAME F-REPORTE
    t-report.campo-c[1] FORMAT 'x(6)'
    t-report.campo-c[2] FORMAT 'x(35)'
    t-report.campo-f[1] FORMAT '>>>>>>9.99' 
    t-report.campo-f[2] FORMAT '>>>>>>9.99' 
    t-report.campo-f[3] FORMAT '>>>>>>9.99' 
    t-report.campo-f[4] FORMAT '>>>>>>9.99' 
    t-report.campo-f[5] FORMAT '>>>>>>9.99' 
    t-report.campo-f[6] FORMAT '>>>>>>9.99' 
    t-report.campo-f[7] FORMAT '>>>>>>9.99' 
    t-report.campo-f[8] FORMAT '>>>>>>9.99' 
    t-report.campo-f[9] FORMAT '>>>>>>9.99' 
    t-report.campo-f[10] FORMAT '>>>>>>9.99' 
    t-report.campo-f[11] FORMAT '>>>>>>9.99' 
    t-report.campo-f[13] FORMAT '>>>>>>9.99'
    t-report.campo-f[12] FORMAT '>>>>>>9.99' 
    x-TotIng            FORMAT '>>>>>>9.99' 
    t-report.campo-f[16] FORMAT '>>>>>>9.99'
    t-report.campo-f[17] FORMAT '>>>>>>9.99'
    x-TotGto            FORMAT '>>>>>>9.99' 
    x-NetPag            FORMAT '>>>>>>9.99' 
    WITH WIDTH 320 NO-BOX NO-LABELS STREAM-IO DOWN.
 
  DEFINE FRAME F-HEADER       
    HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN4} FORMAT "X(45)" SKIP
        {&PRN6A} + "RESUMEN DE PLANILLAS POR CENTRO DE COSTO OBREROS"  AT 100 FORMAT 'x(60)'
        {&PRN4} + {&PRN6B} + "Pag.  : " AT 200 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN4} + "Fecha : " AT 200 STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        "Hora  : " AT 200 STRING(TIME,"HH:MM:SS") SKIP
        s-Titulo FORMAT 'x(50)' SKIP
       "                                                                         Asign.  H. Extras  H. Extras              Bonific.      Grat.                Asign.  Refrig. y                          Total                            Total           " SKIP 
       "Codigo Apellidos y Nombres                     Basico     Reintegros   Familiar    Simples     Dobles  Incentivo   Especial  Jul./Dic.  Vacaciones Extraord.  Movilidad   Dominical   Otros   Ingresos    ESSALUD       IESS     Gastos      Total" SKIP
       "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*
                 1         2         3         4         5         6         7         8         9        10        11        12        14         13          15        16        17        18        19        20        21        22        23
        12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
        123456 12345678901234567890123456789012345 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99
*/
    WITH PAGE-TOP WIDTH 320 NO-BOX NO-LABELS STREAM-IO DOWN.
 
  FOR EACH t-report WHERE t-report.task-no = s-task-no BREAK BY t-report.task-no BY t-report.llave-c BY t-report.llave-i:
    VIEW STREAM REPORT FRAME F-HEADER.
    IF FIRST-OF(t-report.llave-c)
    THEN DO:
        FIND cb-auxi WHERE cb-auxi.codcia = cb-codcia
            AND cb-auxi.clfaux = 'CCO'
            AND cb-auxi.codaux = t-report.llave-c
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE cb-auxi
        THEN FIND cb-auxi WHERE cb-auxi.codcia = s-codcia
            AND cb-auxi.clfaux = 'CCO'
            AND cb-auxi.codaux = t-report.llave-c
            NO-LOCK NO-ERROR.
        IF AVAILABLE cb-auxi
        THEN x-Descrip = cb-auxi.nomaux.
        ELSE x-Descrip = ''.
        PUT STREAM REPORT
            " " SKIP
            "CENTRO DE COSTO: " t-report.llave-c SPACE x-Descrip SKIP
            "----------------" SKIP.
    END.
    ASSIGN
        x-TotIng = t-report.campo-f[1] + t-report.campo-f[2] + t-report.campo-f[3] +
                t-report.campo-f[4] + t-report.campo-f[5] + t-report.campo-f[6] +
                t-report.campo-f[7] + t-report.campo-f[8] + t-report.campo-f[9] +
                t-report.campo-f[10] + t-report.campo-f[11] + t-report.campo-f[12] + 
                t-report.campo-f[13]
        x-TotGto = t-report.campo-f[16] + t-report.campo-f[17]
        x-NetPag = x-TotIng + x-TotGto.
    ACCUMULATE t-report.campo-f[1] (TOTAL BY t-report.task-no BY t-report.llave-c).
    ACCUMULATE t-report.campo-f[2] (TOTAL BY t-report.task-no BY t-report.llave-c).
    ACCUMULATE t-report.campo-f[3] (TOTAL BY t-report.task-no BY t-report.llave-c).
    ACCUMULATE t-report.campo-f[4] (TOTAL BY t-report.task-no BY t-report.llave-c).
    ACCUMULATE t-report.campo-f[5] (TOTAL BY t-report.task-no BY t-report.llave-c).
    ACCUMULATE t-report.campo-f[6] (TOTAL BY t-report.task-no BY t-report.llave-c).
    ACCUMULATE t-report.campo-f[7] (TOTAL BY t-report.task-no BY t-report.llave-c).
    ACCUMULATE t-report.campo-f[8] (TOTAL BY t-report.task-no BY t-report.llave-c).
    ACCUMULATE t-report.campo-f[9] (TOTAL BY t-report.task-no BY t-report.llave-c).
    ACCUMULATE t-report.campo-f[10] (TOTAL BY t-report.task-no BY t-report.llave-c).
    ACCUMULATE t-report.campo-f[11] (TOTAL BY t-report.task-no BY t-report.llave-c).
    ACCUMULATE t-report.campo-f[12] (TOTAL BY t-report.task-no BY t-report.llave-c).
    ACCUMULATE t-report.campo-f[13] (TOTAL BY t-report.task-no BY t-report.llave-c).
    ACCUMULATE t-report.campo-f[16] (TOTAL BY t-report.task-no BY t-report.llave-c).
    ACCUMULATE t-report.campo-f[17] (TOTAL BY t-report.task-no BY t-report.llave-c).
    ACCUMULATE x-toting (TOTAL BY t-report.task-no BY t-report.llave-c).
    ACCUMULATE x-totgto (TOTAL BY t-report.task-no BY t-report.llave-c).
    ACCUMULATE x-netpag (TOTAL BY t-report.task-no BY t-report.llave-c).
    DISPLAY STREAM REPORT
        t-report.campo-c[1] 
        t-report.campo-c[2] 
        t-report.campo-f[1] 
        t-report.campo-f[2] 
        t-report.campo-f[3] 
        t-report.campo-f[4] 
        t-report.campo-f[5] 
        t-report.campo-f[6] 
        t-report.campo-f[7] 
        t-report.campo-f[8] 
        t-report.campo-f[9] 
        t-report.campo-f[10]
        t-report.campo-f[11]
        t-report.campo-f[13]        
        t-report.campo-f[12]
        x-toting
        t-report.campo-f[16]
        t-report.campo-f[17]
        x-totgto
        x-netpag
        WITH FRAME F-REPORTE.
    IF LAST-OF(t-report.llave-c)
    THEN DO:
        UNDERLINE STREAM REPORT
        t-report.campo-c[1] 
        t-report.campo-c[2] 
        t-report.campo-f[1] 
        t-report.campo-f[2] 
        t-report.campo-f[3] 
        t-report.campo-f[4] 
        t-report.campo-f[5] 
        t-report.campo-f[6] 
        t-report.campo-f[7] 
        t-report.campo-f[8] 
        t-report.campo-f[9] 
        t-report.campo-f[10]
        t-report.campo-f[11]
        t-report.campo-f[12]
        t-report.campo-f[13]        
        x-toting
        t-report.campo-f[16]
        t-report.campo-f[17]
        x-totgto
        x-netpag
        WITH FRAME F-REPORTE.
        
        DISPLAY STREAM REPORT
            "SUB-TOTAL" @ t-report.campo-c[1]
            ACCUM TOTAL BY t-report.llave-c t-report.campo-f[1] @ t-report.campo-f[1]
            ACCUM TOTAL BY t-report.llave-c t-report.campo-f[2] @ t-report.campo-f[2]
            ACCUM TOTAL BY t-report.llave-c t-report.campo-f[3] @ t-report.campo-f[3]
            ACCUM TOTAL BY t-report.llave-c t-report.campo-f[4] @ t-report.campo-f[4]
            ACCUM TOTAL BY t-report.llave-c t-report.campo-f[5] @ t-report.campo-f[5]
            ACCUM TOTAL BY t-report.llave-c t-report.campo-f[6] @ t-report.campo-f[6]
            ACCUM TOTAL BY t-report.llave-c t-report.campo-f[7] @ t-report.campo-f[7]
            ACCUM TOTAL BY t-report.llave-c t-report.campo-f[8] @ t-report.campo-f[8]
            ACCUM TOTAL BY t-report.llave-c t-report.campo-f[9] @ t-report.campo-f[9]
            ACCUM TOTAL BY t-report.llave-c t-report.campo-f[10] @ t-report.campo-f[10]
            ACCUM TOTAL BY t-report.llave-c t-report.campo-f[11] @ t-report.campo-f[11]
            ACCUM TOTAL BY t-report.llave-c t-report.campo-f[12] @ t-report.campo-f[12]
            ACCUM TOTAL BY t-report.llave-c t-report.campo-f[13] @ t-report.campo-f[13]
            ACCUM TOTAL BY t-report.llave-c x-toting @ x-toting
            ACCUM TOTAL BY t-report.llave-c t-report.campo-f[16] @ t-report.campo-f[16]
            ACCUM TOTAL BY t-report.llave-c t-report.campo-f[17] @ t-report.campo-f[17]
            ACCUM TOTAL BY t-report.llave-c x-totgto @ x-totgto
            ACCUM TOTAL BY t-report.llave-c x-netpag @ x-netpag
            WITH FRAME F-REPORTE.
    END.
    IF LAST-OF(t-report.task-no)
    THEN DO:
        UNDERLINE STREAM REPORT
        t-report.campo-c[1] 
        t-report.campo-c[2] 
        t-report.campo-f[1] 
        t-report.campo-f[2] 
        t-report.campo-f[3] 
        t-report.campo-f[4] 
        t-report.campo-f[5] 
        t-report.campo-f[6] 
        t-report.campo-f[7] 
        t-report.campo-f[8] 
        t-report.campo-f[9] 
        t-report.campo-f[10]
        t-report.campo-f[11]
        t-report.campo-f[13]
        t-report.campo-f[12]
        x-toting
        t-report.campo-f[16]
        t-report.campo-f[17]
        x-totgto
        x-netpag
        WITH FRAME F-REPORTE.
        
        DISPLAY STREAM REPORT
            "TOTAL" @ t-report.campo-c[1]
            ACCUM TOTAL BY t-report.task-no t-report.campo-f[1] @ t-report.campo-f[1]
            ACCUM TOTAL BY t-report.task-no t-report.campo-f[2] @ t-report.campo-f[2]
            ACCUM TOTAL BY t-report.task-no t-report.campo-f[3] @ t-report.campo-f[3]
            ACCUM TOTAL BY t-report.task-no t-report.campo-f[4] @ t-report.campo-f[4]
            ACCUM TOTAL BY t-report.task-no t-report.campo-f[5] @ t-report.campo-f[5]
            ACCUM TOTAL BY t-report.task-no t-report.campo-f[6] @ t-report.campo-f[6]
            ACCUM TOTAL BY t-report.task-no t-report.campo-f[7] @ t-report.campo-f[7]
            ACCUM TOTAL BY t-report.task-no t-report.campo-f[8] @ t-report.campo-f[8]
            ACCUM TOTAL BY t-report.task-no t-report.campo-f[9] @ t-report.campo-f[9]
            ACCUM TOTAL BY t-report.task-no t-report.campo-f[10] @ t-report.campo-f[10]
            ACCUM TOTAL BY t-report.task-no t-report.campo-f[11] @ t-report.campo-f[11]
            ACCUM TOTAL BY t-report.task-no t-report.campo-f[13] @ t-report.campo-f[13]            
            ACCUM TOTAL BY t-report.task-no t-report.campo-f[12] @ t-report.campo-f[12]
            ACCUM TOTAL BY t-report.task-no x-toting @ x-toting
            ACCUM TOTAL BY t-report.task-no t-report.campo-f[16] @ t-report.campo-f[16]
            ACCUM TOTAL BY t-report.task-no t-report.campo-f[17] @ t-report.campo-f[17]
            ACCUM TOTAL BY t-report.task-no x-totgto @ x-totgto
            ACCUM TOTAL BY t-report.task-no x-netpag @ x-netpag
            WITH FRAME F-REPORTE.
    END.
  END.

END PROCEDURE.

/*
  DEF VAR x-TotIng AS DEC NO-UNDO.
  DEF VAR x-TotGto AS DEC NO-UNDO.
  DEF VAR x-NetPag AS DEC NO-UNDO.
  DEF VAR x-Descrip AS CHAR FORMAT 'x(40)' NO-UNDO.
  
  DEFINE FRAME F-REPORTE
    t-report.campo-c[1] FORMAT 'x(6)'
    t-report.campo-c[2] FORMAT 'x(35)'
    t-report.campo-f[1] FORMAT '>>>>,>>9.99' 
    t-report.campo-f[2] FORMAT '>>>>,>>9.99' 
    t-report.campo-f[3] FORMAT '>>>>,>>9.99' 
    t-report.campo-f[4] FORMAT '>>>>,>>9.99' 
    t-report.campo-f[10] FORMAT '>>>>,>>9.99' 
    WITH WIDTH 200 NO-BOX NO-LABELS STREAM-IO DOWN.
 
  DEFINE FRAME F-HEADER       
    HEADER
        S-NOMCIA FORMAT "X(45)" SKIP
        "DETALLE CONSOLIDADO DE PLANILLAS POR CENTRO DE COSTO EMPLEADOS"  AT 10
        "Pag.  : " AT 80 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "Fecha : " AT 80 STRING(TODAY,"99/99/9999") FORMAT "X(12)" 
        "Hora  : " AT 80 STRING(TIME,"HH:MM:SS") SKIP
        s-Titulo FORMAT 'x(50)' SKIP
       "                                                                         Total       Total            " SKIP
       "                                                 Total       Total  Vacaciones    Gratific.      Total" SKIP
       "Codigo Apellidos y Nombres                      Sueldo         CTS     Truncas     Truncas     General" SKIP
       "------------------------------------------------------------------------------------------------------" SKIP
/*
                 1         2         3         4         5         6         8         9        10        12
        12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
        123456 12345678901234567890123456789012345 >>>>,>>9.99 >>>>,>99.99 >>>>,>>9.99 >>>>,>>9.99 >>>>,>>9.99 
*/
    WITH PAGE-TOP WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
 
  FOR EACH t-report WHERE t-report.task-no = s-task-no BREAK BY t-report.task-no BY t-report.llave-c BY t-report.llave-i:
    VIEW STREAM REPORT FRAME F-HEADER.
    IF FIRST-OF(t-report.llave-c)
    THEN DO:
        FIND cb-auxi WHERE cb-auxi.codcia = 0
            AND cb-auxi.clfaux = 'CCO'
            AND cb-auxi.codaux = t-report.llave-c
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE cb-auxi
        THEN FIND cb-auxi WHERE cb-auxi.codcia = s-codcia
            AND cb-auxi.clfaux = 'CCO'
            AND cb-auxi.codaux = t-report.llave-c
            NO-LOCK NO-ERROR.
        IF AVAILABLE cb-auxi
        THEN x-Descrip = cb-auxi.nomaux.
        ELSE x-Descrip = ''.
        PUT STREAM REPORT
            " " SKIP
            "CENTRO DE COSTO: " t-report.llave-c SPACE x-Descrip SKIP
            "----------------" SKIP.
    END.
    ASSIGN
        x-TotIng = t-report.campo-f[1] + t-report.campo-f[2] + t-report.campo-f[3] +
                t-report.campo-f[4] + t-report.campo-f[5] + t-report.campo-f[6] +
                t-report.campo-f[7] + t-report.campo-f[8] + t-report.campo-f[9] +
                t-report.campo-f[10] + t-report.campo-f[11] + t-report.campo-f[12]
        x-TotGto = t-report.campo-f[16] + t-report.campo-f[17]
        x-NetPag = x-TotIng + x-TotGto.
    ACCUMULATE t-report.campo-f[1] (TOTAL BY t-report.task-no BY t-report.llave-c).
    ACCUMULATE t-report.campo-f[2] (TOTAL BY t-report.task-no BY t-report.llave-c).
    ACCUMULATE t-report.campo-f[3] (TOTAL BY t-report.task-no BY t-report.llave-c).
    ACCUMULATE t-report.campo-f[4] (TOTAL BY t-report.task-no BY t-report.llave-c).
    ACCUMULATE t-report.campo-f[10] (TOTAL BY t-report.task-no BY t-report.llave-c).
    DISPLAY STREAM REPORT
        t-report.campo-c[1] 
        t-report.campo-c[2]
        t-report.campo-f[1] 
        t-report.campo-f[2] 
        t-report.campo-f[3] 
        t-report.campo-f[4] 
        t-report.campo-f[10]
        WITH FRAME F-REPORTE.
    IF LAST-OF(t-report.llave-c)
    THEN DO:
        UNDERLINE STREAM REPORT
        t-report.campo-c[1]
        t-report.campo-c[2] 
        t-report.campo-f[1] 
        t-report.campo-f[2] 
        t-report.campo-f[3] 
        t-report.campo-f[4] 
        t-report.campo-f[10]
        WITH FRAME F-REPORTE.
        
        DISPLAY STREAM REPORT
            "SUB-TOTAL" @ t-report.campo-c[2]
            ACCUM TOTAL BY t-report.llave-c t-report.campo-f[1] @ t-report.campo-f[1]
            ACCUM TOTAL BY t-report.llave-c t-report.campo-f[2] @ t-report.campo-f[2]
            ACCUM TOTAL BY t-report.llave-c t-report.campo-f[3] @ t-report.campo-f[3]
            ACCUM TOTAL BY t-report.llave-c t-report.campo-f[4] @ t-report.campo-f[4]
            ACCUM TOTAL BY t-report.llave-c t-report.campo-f[10] @ t-report.campo-f[10]
            WITH FRAME F-REPORTE.
    END.
    IF LAST-OF(t-report.task-no)
    THEN DO:
        UNDERLINE STREAM REPORT
        t-report.campo-c[1] 
        t-report.campo-c[2]
        t-report.campo-f[1] 
        t-report.campo-f[2] 
        t-report.campo-f[3] 
        t-report.campo-f[4] 
        t-report.campo-f[10]
        WITH FRAME F-REPORTE.
        
        DISPLAY STREAM REPORT
            "TOTAL" @ t-report.campo-c[2]
            ACCUM TOTAL BY t-report.task-no t-report.campo-f[1] @ t-report.campo-f[1]
            ACCUM TOTAL BY t-report.task-no t-report.campo-f[2] @ t-report.campo-f[2]
            ACCUM TOTAL BY t-report.task-no t-report.campo-f[3] @ t-report.campo-f[3]
            ACCUM TOTAL BY t-report.task-no t-report.campo-f[4] @ t-report.campo-f[4]
            ACCUM TOTAL BY t-report.task-no t-report.campo-f[10] @ t-report.campo-f[10]
            WITH FRAME F-REPORTE.
    END.
  END.

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir W-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  RUN bin/_prnctr.p.
  IF s-salida-impresion = 0 THEN RETURN.
   
  RUN Carga-Temporal-1.
  
  FIND FIRST t-report WHERE t-report.task-no = s-task-no 
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE t-report
  THEN DO:
      MESSAGE "Fin de archivo" VIEW-AS ALERT-BOX WARNING.
      RETURN.
  END.
  s-Titulo = 'MES DE ' + TRIM(ENTRY(COMBO-BOX-NroMes, x-Meses)) + ' DE ' + STRING(COMBO-BOX-Periodo, '9999').

  /* Captura parametros de impresion */
  /* s-pagina-inicial,  s-pagina-final,  s-printer-name,  s-print-file,  s-nro-copias */
  
  RUN aderb/_prlist.p(
      OUTPUT s-printer-list,
      OUTPUT s-port-list,
      OUTPUT s-printer-count).
  s-port-name = ENTRY(LOOKUP(s-printer-name, s-printer-list), s-port-list).
  s-port-name = REPLACE(S-PORT-NAME, ":", "").

  IF s-salida-impresion = 1 
  THEN s-print-file = SESSION:TEMP-DIRECTORY + "report.prn".
  
  CASE s-salida-impresion:
        WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
        WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
        WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
  END CASE.

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  RUN Formato-1.
  
  PAGE STREAM REPORT.
  OUTPUT STREAM REPORT CLOSE.
  CASE s-salida-impresion:
       WHEN 1 OR WHEN 3 THEN RUN LIB/W-README.R(s-print-file).
  END CASE. 

  /*DELETE FROM t-report WHERE t-report.task-no = s-task-no.*/

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros W-Win 
PROCEDURE Procesa-Parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    output-var-1 como ROWID
    output-var-2 como CHARACTER
    output-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
    END CASE.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros W-Win 
PROCEDURE Recoge-Parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    input-var-1 como CHARACTER
    input-var-2 como CHARACTER
    input-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "FILL-IN-CCosto" THEN 
            ASSIGN
                input-var-1 = "CCO"
                input-var-2 = ""
                input-var-3 = "".
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
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

