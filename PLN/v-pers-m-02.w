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

  History:
    Modificó    Fecha       Objetivo
    --------    ----------- --------------------------------------------
    MLR-1       17/Set/2008 Habilitado campos para "Afliciación Asegura tu
                            Pensión" (PL-FLG-MES.Campo-C[1]), "Categoría
                            Ocupacional del Trabajador" (PL-FLG-MES.Campo-C[2])
                            y "Convenio para Evitar Doble Tributación"
                            (PL-FLG-MES.Campo-C[3]).

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
&Scoped-define EXTERNAL-TABLES INTEGRAL.PL-FLG-MES
&Scoped-define FIRST-EXTERNAL-TABLE INTEGRAL.PL-FLG-MES


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR INTEGRAL.PL-FLG-MES.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS INTEGRAL.PL-FLG-MES.TpoTrabaj ~
INTEGRAL.PL-FLG-MES.RegLabora INTEGRAL.PL-FLG-MES.NivEducat ~
INTEGRAL.PL-FLG-MES.Ocupacion INTEGRAL.PL-FLG-MES.Discapaci ~
INTEGRAL.PL-FLG-MES.RegPensio INTEGRAL.PL-FLG-MES.TpoConTra ~
INTEGRAL.PL-FLG-MES.PeriodIng INTEGRAL.PL-FLG-MES.AfilEPS ~
INTEGRAL.PL-FLG-MES.CodEPS INTEGRAL.PL-FLG-MES.Situacion ~
INTEGRAL.PL-FLG-MES.Jornada[1] INTEGRAL.PL-FLG-MES.Jornada[2] ~
INTEGRAL.PL-FLG-MES.Jornada[3] INTEGRAL.PL-FLG-MES.QtaCatego ~
INTEGRAL.PL-FLG-MES.Campo-C[1] INTEGRAL.PL-FLG-MES.IndRenta ~
INTEGRAL.PL-FLG-MES.SitEspeci INTEGRAL.PL-FLG-MES.TpoPago ~
INTEGRAL.PL-FLG-MES.Campo-C[2] INTEGRAL.PL-FLG-MES.Campo-C[3] ~
INTEGRAL.PL-FLG-MES.FchIniCont INTEGRAL.PL-FLG-MES.FchFinCont ~
INTEGRAL.PL-FLG-MES.Campo-C[4] 
&Scoped-define ENABLED-TABLES INTEGRAL.PL-FLG-MES
&Scoped-define FIRST-ENABLED-TABLE INTEGRAL.PL-FLG-MES
&Scoped-Define ENABLED-OBJECTS BUTTON-4 RECT-1 RECT-2 RECT-3 
&Scoped-Define DISPLAYED-FIELDS INTEGRAL.PL-FLG-MES.TpoTrabaj ~
INTEGRAL.PL-FLG-MES.RegLabora INTEGRAL.PL-FLG-MES.NivEducat ~
INTEGRAL.PL-FLG-MES.Ocupacion INTEGRAL.PL-FLG-MES.Discapaci ~
INTEGRAL.PL-FLG-MES.RegPensio INTEGRAL.PL-FLG-MES.TpoConTra ~
INTEGRAL.PL-FLG-MES.PeriodIng INTEGRAL.PL-FLG-MES.AfilEPS ~
INTEGRAL.PL-FLG-MES.CodEPS INTEGRAL.PL-FLG-MES.Situacion ~
INTEGRAL.PL-FLG-MES.Jornada[1] INTEGRAL.PL-FLG-MES.Jornada[2] ~
INTEGRAL.PL-FLG-MES.Jornada[3] INTEGRAL.PL-FLG-MES.QtaCatego ~
INTEGRAL.PL-FLG-MES.Campo-C[1] INTEGRAL.PL-FLG-MES.IndRenta ~
INTEGRAL.PL-FLG-MES.SitEspeci INTEGRAL.PL-FLG-MES.TpoPago ~
INTEGRAL.PL-FLG-MES.Campo-C[2] INTEGRAL.PL-FLG-MES.Campo-C[3] ~
INTEGRAL.PL-FLG-MES.FchIniCont INTEGRAL.PL-FLG-MES.FchFinCont ~
INTEGRAL.PL-FLG-MES.Campo-C[4] 
&Scoped-define DISPLAYED-TABLES INTEGRAL.PL-FLG-MES
&Scoped-define FIRST-DISPLAYED-TABLE INTEGRAL.PL-FLG-MES
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-TpoTrabaj FILL-IN-NivEducat ~
FILL-IN-RegPensio FILL-IN-TpoConTra FILL-IN-Ocupacion FILL-IN-PeriodIng ~
FILL-IN-CodEPS FILL-IN-Situacion FILL-IN-Convenio 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-4 
     LABEL "IMPORTAR MINTRA" 
     SIZE 18 BY 1.12.

DEFINE VARIABLE FILL-IN-CodEPS AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 56 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Convenio AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NivEducat AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 56 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Ocupacion AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 56 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-PeriodIng AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 27 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-RegPensio AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 56 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Situacion AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 56 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-TpoConTra AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 56 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-TpoTrabaj AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 56 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83.43 BY 7.27.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83.43 BY 7.31.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83.43 BY 3.46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-4 AT ROW 19.04 COL 1 WIDGET-ID 8
     INTEGRAL.PL-FLG-MES.TpoTrabaj AT ROW 1.38 COL 13 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 2.86 BY .81
     INTEGRAL.PL-FLG-MES.RegLabora AT ROW 2.35 COL 15.14 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Privado", "1":U,
"Público", "2":U
          SIZE 17 BY .77
     INTEGRAL.PL-FLG-MES.NivEducat AT ROW 3.12 COL 13 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 2.86 BY .81
     INTEGRAL.PL-FLG-MES.Ocupacion AT ROW 3.92 COL 13 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     INTEGRAL.PL-FLG-MES.Discapaci AT ROW 4.85 COL 15.14 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Sí", "1":U,
"No", "0":U
          SIZE 10 BY .77
     INTEGRAL.PL-FLG-MES.RegPensio AT ROW 5.62 COL 13 COLON-ALIGNED
          LABEL "Rég. Pensionario"
          VIEW-AS FILL-IN 
          SIZE 2.86 BY .81
     INTEGRAL.PL-FLG-MES.TpoConTra AT ROW 6.42 COL 13 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 2.86 BY .81
     FILL-IN-TpoTrabaj AT ROW 1.38 COL 16 COLON-ALIGNED NO-LABEL
     FILL-IN-NivEducat AT ROW 3.12 COL 16 COLON-ALIGNED NO-LABEL
     FILL-IN-RegPensio AT ROW 5.62 COL 16 COLON-ALIGNED NO-LABEL
     FILL-IN-TpoConTra AT ROW 6.42 COL 16 COLON-ALIGNED NO-LABEL
     FILL-IN-Ocupacion AT ROW 3.92 COL 20 COLON-ALIGNED NO-LABEL
     INTEGRAL.PL-FLG-MES.PeriodIng AT ROW 11.92 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 2.14 BY .81
     FILL-IN-PeriodIng AT ROW 11.92 COL 22 COLON-ALIGNED NO-LABEL
     INTEGRAL.PL-FLG-MES.AfilEPS AT ROW 12.88 COL 22 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Sí", "1":U,
"No", "0":U
          SIZE 10 BY .77
     INTEGRAL.PL-FLG-MES.CodEPS AT ROW 13.65 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 2.14 BY .81
     FILL-IN-CodEPS AT ROW 13.65 COL 22 COLON-ALIGNED NO-LABEL
     INTEGRAL.PL-FLG-MES.Situacion AT ROW 14.46 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 2.86 BY .81
     FILL-IN-Situacion AT ROW 14.46 COL 23 COLON-ALIGNED NO-LABEL
     INTEGRAL.PL-FLG-MES.Jornada[1] AT ROW 8.65 COL 26 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Sí", "1":U,
"No", "0":U
          SIZE 10 BY .77
     INTEGRAL.PL-FLG-MES.Jornada[2] AT ROW 9.42 COL 26 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Sí", "1":U,
"No", "0":U
          SIZE 10 BY .77
     INTEGRAL.PL-FLG-MES.Jornada[3] AT ROW 10.19 COL 26 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Sí", "1":U,
"No", "0":U
          SIZE 10 BY .77
     INTEGRAL.PL-FLG-MES.QtaCatego AT ROW 10.96 COL 26 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Sí", "1":U,
"No", "0":U
          SIZE 10 BY .77
     INTEGRAL.PL-FLG-MES.Campo-C[1] AT ROW 16.35 COL 31 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Sí", "1":U,
"No", "0":U
          SIZE 10 BY .77
     INTEGRAL.PL-FLG-MES.IndRenta AT ROW 8.65 COL 64 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Sí", "1":U,
"No", "0":U
          SIZE 10 BY .77
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     INTEGRAL.PL-FLG-MES.SitEspeci AT ROW 9.62 COL 64 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Trabajador de dirección", "1":U,
"Trabajador de confianza", "2":U,
"Ninguna", "0":U
          SIZE 20 BY 1.92
     INTEGRAL.PL-FLG-MES.TpoPago AT ROW 11.73 COL 64 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Efectivo", "1":U,
"Depósito en Cuenta", "2":U,
"Otros", "3":U
          SIZE 17 BY 1.92
     INTEGRAL.PL-FLG-MES.Campo-C[2] AT ROW 15.77 COL 71.57 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Ejecutivo", "1":U,
"Obrero", "2":U,
"Empleado", "3":U
          SIZE 10.43 BY 1.92
     INTEGRAL.PL-FLG-MES.Campo-C[3] AT ROW 17.88 COL 28 COLON-ALIGNED
          LABEL "Convenio para Evitar Doble Tributación" FORMAT "x"
          VIEW-AS FILL-IN 
          SIZE 3 BY .81
     FILL-IN-Convenio AT ROW 17.88 COL 31 COLON-ALIGNED NO-LABEL
     INTEGRAL.PL-FLG-MES.FchIniCont AT ROW 7.19 COL 13 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     INTEGRAL.PL-FLG-MES.FchFinCont AT ROW 7.19 COL 39 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     INTEGRAL.PL-FLG-MES.Campo-C[4] AT ROW 7.19 COL 61 COLON-ALIGNED WIDGET-ID 6
          LABEL "Reg. MINTRA"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     "Sujeto a Horario Nocturno:" VIEW-AS TEXT
          SIZE 18 BY .5 AT ROW 10.19 COL 7
     "Afiliado EPS:" VIEW-AS TEXT
          SIZE 9 BY .5 AT ROW 12.88 COL 13
     "Tipo de Pago:" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 12.31 COL 54
     "Sujeto a Jornada Trabajo Máxima:" VIEW-AS TEXT
          SIZE 23 BY .5 AT ROW 9.42 COL 2
     "Categoría Ocupacional del Trabajador:" VIEW-AS TEXT
          SIZE 26.72 BY .5 AT ROW 16.35 COL 45
     "Afiliación Asegura tu Pensión:" VIEW-AS TEXT
          SIZE 20 BY .5 AT ROW 16.35 COL 9.57
     "Discapacidad:" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 4.96 COL 5
     "Otros Ingresos de 5ta Categoria:" VIEW-AS TEXT
          SIZE 22 BY .5 AT ROW 10.96 COL 3.29
     "5ta Categoría Exonerada o Inafecta:" VIEW-AS TEXT
          SIZE 25 BY .5 AT ROW 8.65 COL 39
     "Situación Especial:" VIEW-AS TEXT
          SIZE 13 BY .5 AT ROW 10.19 COL 51
     "Sujeto a Régimen Alternativo:" VIEW-AS TEXT
          SIZE 20 BY .5 AT ROW 8.65 COL 5
     "Régimen Laboral:" VIEW-AS TEXT
          SIZE 12 BY .5 AT ROW 2.46 COL 2.72
     RECT-1 AT ROW 1 COL 1
     RECT-2 AT ROW 8.27 COL 1
     RECT-3 AT ROW 15.58 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.PL-FLG-MES
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
         HEIGHT             = 19.58
         WIDTH              = 85.43.
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

/* SETTINGS FOR FILL-IN INTEGRAL.PL-FLG-MES.Campo-C[3] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN INTEGRAL.PL-FLG-MES.Campo-C[4] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-CodEPS IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Convenio IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NivEducat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Ocupacion IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-PeriodIng IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-RegPensio IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Situacion IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-TpoConTra IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-TpoTrabaj IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN INTEGRAL.PL-FLG-MES.RegPensio IN FRAME F-Main
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

&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 V-table-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* IMPORTAR MINTRA */
DO:
  RUN EXP/w-impmintra.
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME INTEGRAL.PL-FLG-MES.Campo-C[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-FLG-MES.Campo-C[3] V-table-Win
ON MOUSE-SELECT-DBLCLICK OF INTEGRAL.PL-FLG-MES.Campo-C[3] IN FRAME F-Main /* Convenio para Evitar Doble Tributación */
OR F8 OF PL-FLG-MES.Campo-C[3] DO:

    ASSIGN
        input-var-1 = "25"
        input-var-2 = ""
        input-var-3 = ""
        output-var-1 = ?
        OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").
    DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
        RUN LKUP/C-PLTabla.r("Convenio para Evitar Doble Tributación").
        IF OUTPUT-VAR-1 <> ? THEN DO:
            FIND pl-tabla WHERE ROWID(pl-tabla) = OUTPUT-VAR-1 NO-LOCK NO-ERROR.
            DISPLAY
                pl-tabl.Codigo @ PL-FLG-MES.Campo-c[3]
                pl-tabl.Nombre @ FILL-IN-Convenio
                WITH FRAME {&FRAME-NAME}.
        END.
    END.
    OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME INTEGRAL.PL-FLG-MES.CodEPS
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-FLG-MES.CodEPS V-table-Win
ON MOUSE-SELECT-DBLCLICK OF INTEGRAL.PL-FLG-MES.CodEPS IN FRAME F-Main /* Código EPS */
OR F8 OF PL-FLG-MES.CodEPS DO:

    ASSIGN
        input-var-1 = "14"
        input-var-2 = ""
        input-var-3 = ""
        output-var-1 = ?
        OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").
    DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
        RUN LKUP/C-PLTabla.r("EPS").
        IF OUTPUT-VAR-1 <> ? THEN DO:
            FIND pl-tabl WHERE ROWID(pl-tabl) = OUTPUT-VAR-1 NO-LOCK NO-ERROR.
            DISPLAY
                pl-tabl.Codigo @ PL-FLG-MES.CodEPS
                pl-tabl.Nombre @ FILL-IN-CodEPS
                WITH FRAME {&FRAME-NAME}.
        END.
    END.
    OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME INTEGRAL.PL-FLG-MES.NivEducat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-FLG-MES.NivEducat V-table-Win
ON MOUSE-SELECT-DBLCLICK OF INTEGRAL.PL-FLG-MES.NivEducat IN FRAME F-Main /* Nivel Educativo */
OR F8 OF PL-FLG-MES.NivEducat DO:

    ASSIGN
        input-var-1 = "09"
        input-var-2 = ""
        input-var-3 = ""
        output-var-1 = ?
        OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").
    DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
        RUN LKUP/C-PLTabla.r("Nivel Educativo").
        IF OUTPUT-VAR-1 <> ? THEN DO:
            FIND pl-tabl WHERE ROWID(pl-tabl) = OUTPUT-VAR-1 NO-LOCK NO-ERROR.
            DISPLAY
                pl-tabl.Codigo @ PL-FLG-MES.NivEducat
                pl-tabl.Nombre @ FILL-IN-NivEducat
                WITH FRAME {&FRAME-NAME}.
        END.
    END.
    OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME INTEGRAL.PL-FLG-MES.Ocupacion
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-FLG-MES.Ocupacion V-table-Win
ON MOUSE-SELECT-DBLCLICK OF INTEGRAL.PL-FLG-MES.Ocupacion IN FRAME F-Main /* Ocupación */
OR F8 OF PL-FLG-MES.Ocupacion DO:

    ASSIGN
        input-var-1 = "10"
        input-var-2 = ""
        input-var-3 = ""
        output-var-1 = ?
        OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").
    DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
        RUN LKUP/C-PLTabla.r("Ocupación").
        IF OUTPUT-VAR-1 <> ? THEN DO:
            FIND pl-tabl WHERE ROWID(pl-tabl) = OUTPUT-VAR-1 NO-LOCK NO-ERROR.
            DISPLAY
                pl-tabl.Codigo @ PL-FLG-MES.Ocupacion
                pl-tabl.Nombre @ FILL-IN-Ocupacion
                WITH FRAME {&FRAME-NAME}.
        END.
    END.
    OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME INTEGRAL.PL-FLG-MES.PeriodIng
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-FLG-MES.PeriodIng V-table-Win
ON MOUSE-SELECT-DBLCLICK OF INTEGRAL.PL-FLG-MES.PeriodIng IN FRAME F-Main /* Periodicidad Remuneración */
OR F8 OF PL-FLG-MES.PeriodIng DO:

    ASSIGN
        input-var-1 = "13"
        input-var-2 = ""
        input-var-3 = ""
        output-var-1 = ?
        OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").
    DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
        RUN LKUP/C-PLTabla.r("Periodicidad de Ingreso").
        IF OUTPUT-VAR-1 <> ? THEN DO:
            FIND pl-tabl WHERE ROWID(pl-tabl) = OUTPUT-VAR-1 NO-LOCK NO-ERROR.
            DISPLAY
                pl-tabl.Codigo @ PL-FLG-MES.PeriodIng
                pl-tabl.Nombre @ FILL-IN-PeriodIng
                WITH FRAME {&FRAME-NAME}.
        END.
    END.
    OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME INTEGRAL.PL-FLG-MES.RegPensio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-FLG-MES.RegPensio V-table-Win
ON MOUSE-SELECT-DBLCLICK OF INTEGRAL.PL-FLG-MES.RegPensio IN FRAME F-Main /* Rég. Pensionario */
OR F8 OF PL-FLG-MES.RegPensio DO:

    ASSIGN
        input-var-1 = "11"
        input-var-2 = ""
        input-var-3 = ""
        output-var-1 = ?
        OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").
    DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
        RUN LKUP/C-PLTabla.r("Régimen Pensionario").
        IF OUTPUT-VAR-1 <> ? THEN DO:
            FIND pl-tabl WHERE ROWID(pl-tabl) = OUTPUT-VAR-1 NO-LOCK NO-ERROR.
            DISPLAY
                pl-tabl.Codigo @ PL-FLG-MES.RegPensio
                pl-tabl.Nombre @ FILL-IN-RegPensio
                WITH FRAME {&FRAME-NAME}.
        END.
    END.
    OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME INTEGRAL.PL-FLG-MES.Situacion
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-FLG-MES.Situacion V-table-Win
ON MOUSE-SELECT-DBLCLICK OF INTEGRAL.PL-FLG-MES.Situacion IN FRAME F-Main /* Situación */
OR F8 OF PL-FLG-MES.Situacion DO:

    ASSIGN
        input-var-1 = "15"
        input-var-2 = ""
        input-var-3 = ""
        output-var-1 = ?
        OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").
    DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
        RUN LKUP/C-PLTabla.r("Situación Trabajador").
        IF OUTPUT-VAR-1 <> ? THEN DO:
            FIND pl-tabl WHERE ROWID(pl-tabl) = OUTPUT-VAR-1 NO-LOCK NO-ERROR.
            DISPLAY
                pl-tabl.Codigo @ PL-FLG-MES.Situacion
                pl-tabl.Nombre @ FILL-IN-Situacion
                WITH FRAME {&FRAME-NAME}.
        END.
    END.
    OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME INTEGRAL.PL-FLG-MES.TpoConTra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-FLG-MES.TpoConTra V-table-Win
ON MOUSE-SELECT-DBLCLICK OF INTEGRAL.PL-FLG-MES.TpoConTra IN FRAME F-Main /* Tipo Contrato */
OR F8 OF PL-FLG-MES.TpoConTra DO:

    ASSIGN
        input-var-1 = "12"
        input-var-2 = ""
        input-var-3 = ""
        output-var-1 = ?
        OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").
    DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
        RUN LKUP/C-PLTabla.r("Tipo de Contrato").
        IF OUTPUT-VAR-1 <> ? THEN DO:
            FIND pl-tabl WHERE ROWID(pl-tabl) = OUTPUT-VAR-1 NO-LOCK NO-ERROR.
            DISPLAY
                pl-tabl.Codigo @ PL-FLG-MES.TpoConTra
                pl-tabl.Nombre @ FILL-IN-TpoConTra
                WITH FRAME {&FRAME-NAME}.
        END.
    END.
    OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME INTEGRAL.PL-FLG-MES.TpoTrabaj
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-FLG-MES.TpoTrabaj V-table-Win
ON MOUSE-SELECT-DBLCLICK OF INTEGRAL.PL-FLG-MES.TpoTrabaj IN FRAME F-Main /* Tipo Trabajador */
OR F8 OF PL-FLG-MES.TpoTrabaj DO:

    ASSIGN
        input-var-1 = "08"
        input-var-2 = ""
        input-var-3 = ""
        output-var-1 = ?
        OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").
    DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
        RUN LKUP/C-PLTabla.r("Tipo De Trabajador").
        IF OUTPUT-VAR-1 <> ? THEN DO:
            FIND pl-tabl WHERE ROWID(pl-tabl) = OUTPUT-VAR-1 NO-LOCK NO-ERROR.
            DISPLAY
                pl-tabl.Codigo @ PL-FLG-MES.TpoTrabaj
                pl-tabl.Nombre @ FILL-IN-TpoTrabaj
                WITH FRAME {&FRAME-NAME}.
        END.
    END.
    OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

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
  {src/adm/template/row-list.i "INTEGRAL.PL-FLG-MES"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "INTEGRAL.PL-FLG-MES"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
    DO WITH FRAME {&FRAME-NAME}:
        /* Tipo de Trabajador */
        FIND pl-tabla WHERE
            pl-tabla.codcia = 0 AND
            pl-tabla.tabla = '08' AND
            pl-tabla.codigo = PL-FLG-MES.TpoTrabaj NO-LOCK NO-ERROR.
        IF AVAILABLE pl-tabla THEN FILL-IN-TpoTrabaj:SCREEN-VALUE = pl-tabla.nombre.
        ELSE FILL-IN-TpoTrabaj:SCREEN-VALUE = ' '.
        /* Nivel Educativo */
        FIND pl-tabla WHERE
            pl-tabla.codcia = 0 AND
            pl-tabla.tabla = '09' AND
            pl-tabla.codigo = PL-FLG-MES.NivEducat NO-LOCK NO-ERROR.
        IF AVAILABLE pl-tabla THEN FILL-IN-NivEducat:SCREEN-VALUE = pl-tabla.nombre.
        ELSE FILL-IN-NivEducat:SCREEN-VALUE = ' '.
        /* Ocupacion */
        FIND pl-tabla WHERE
            pl-tabla.codcia = 0 AND
            pl-tabla.tabla = '10' AND
            pl-tabla.codigo = PL-FLG-MES.Ocupacion NO-LOCK NO-ERROR.
        IF AVAILABLE pl-tabla THEN FILL-IN-Ocupacion:SCREEN-VALUE = pl-tabla.nombre.
        ELSE FILL-IN-Ocupacion:SCREEN-VALUE = ' '.
        /* Reg Pensionario */
        FIND pl-tabla WHERE
            pl-tabla.codcia = 0 AND
            pl-tabla.tabla = '11' AND
            pl-tabla.codigo = PL-FLG-MES.RegPensio NO-LOCK NO-ERROR.
        IF AVAILABLE pl-tabla THEN FILL-IN-RegPensio:SCREEN-VALUE = pl-tabla.nombre.
        ELSE FILL-IN-RegPensio:SCREEN-VALUE = ' '.
        /* Tipo Contrato */
        FIND pl-tabla WHERE
            pl-tabla.codcia = 0 AND
            pl-tabla.tabla = '12' AND
            pl-tabla.codigo = PL-FLG-MES.TpoConTra NO-LOCK NO-ERROR.
        IF AVAILABLE pl-tabla THEN FILL-IN-TpoConTra:SCREEN-VALUE = pl-tabla.nombre.
        ELSE FILL-IN-TpoConTra:SCREEN-VALUE = ' '.
        /* Peridiocidad Ingreso */
        FIND pl-tabla WHERE
            pl-tabla.codcia = 0 AND
            pl-tabla.tabla = '13' AND
            pl-tabla.codigo = PL-FLG-MES.PeriodIng NO-LOCK NO-ERROR.
        IF AVAILABLE pl-tabla THEN FILL-IN-PeriodIng:SCREEN-VALUE = pl-tabla.nombre.
        ELSE FILL-IN-PeriodIng:SCREEN-VALUE = ' '.
        /* EPS */
        FIND pl-tabla WHERE
            pl-tabla.codcia = 0 AND
            pl-tabla.tabla = '14' AND
            pl-tabla.codigo = PL-FLG-MES.CodEPS NO-LOCK NO-ERROR.
        IF AVAILABLE pl-tabla THEN FILL-IN-CodEPS:SCREEN-VALUE = pl-tabla.nombre.
        ELSE FILL-IN-CodEPS:SCREEN-VALUE = ' '.
        /* Situación EPS */
        FIND pl-tabla WHERE
            pl-tabla.codcia = 0 AND
            pl-tabla.tabla = '15' AND
            pl-tabla.codigo = PL-FLG-MES.Situacion NO-LOCK NO-ERROR.
        IF AVAILABLE pl-tabla THEN FILL-IN-Situacion:SCREEN-VALUE = pl-tabla.nombre.
        ELSE FILL-IN-Situacion:SCREEN-VALUE = ' '.

/*MLR-1* Inicio de bloque ***/
        /* Situación EPS */
        FIND pl-tabla WHERE
            pl-tabla.codcia = 0 AND
            pl-tabla.tabla = '25' AND
            pl-tabla.codigo = PL-FLG-MES.Campo-C[3] NO-LOCK NO-ERROR.
        IF AVAILABLE pl-tabla THEN FILL-IN-Convenio:SCREEN-VALUE = pl-tabla.nombre.
        ELSE FILL-IN-Convenio:SCREEN-VALUE = ' '.
/*MLR-1* Fin de bloque ***/

    END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros V-table-Win 
PROCEDURE procesa-parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros V-table-Win 
PROCEDURE recoge-parametros :
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
        WHEN "" THEN .
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
         */      
    END CASE.

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
  {src/adm/template/snd-list.i "INTEGRAL.PL-FLG-MES"}

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

  IF p-state = 'update-begin':U THEN DO:
     RUN valida-update.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
  END.

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
  Purpose:     Validacion de datos
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME} :

    IF NOT CAN-FIND(FIRST pl-tabla WHERE
        pl-tabla.codcia = 0 AND
        pl-tabla.tabla = '08' AND
        pl-tabla.codigo = PL-FLG-MES.TpoTrabaj:SCREEN-VALUE) THEN DO:
        MESSAGE
            "Tipo de Trabajador no es Válido"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO PL-FLG-MES.TpoTrabaj.
        RETURN "ADM-ERROR".
    END.

    IF NOT CAN-FIND(FIRST pl-tabla WHERE
        pl-tabla.codcia = 0 AND
        pl-tabla.tabla = '09' AND
        pl-tabla.codigo = PL-FLG-MES.NivEducat:SCREEN-VALUE) THEN DO:
        MESSAGE
            "Nivel Educativo no es Válido"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO PL-FLG-MES.NivEducat.
        RETURN "ADM-ERROR".
    END.

    IF PL-FLG-MES.Ocupacion:SCREEN-VALUE <> "" AND
        NOT CAN-FIND(FIRST pl-tabla WHERE
        pl-tabla.codcia = 0 AND
        pl-tabla.tabla = '10' AND
        pl-tabla.codigo = PL-FLG-MES.Ocupacion:SCREEN-VALUE) THEN DO:
        MESSAGE
            "Ocupación no es Válido"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO PL-FLG-MES.Ocupacion.
        RETURN "ADM-ERROR".
    END.

    IF NOT CAN-FIND(FIRST pl-tabla WHERE
        pl-tabla.codcia = 0 AND
        pl-tabla.tabla = '11' AND
        pl-tabla.codigo = PL-FLG-MES.RegPensio:SCREEN-VALUE) THEN DO:
        MESSAGE
            "Régimen Pensionario no es Válido"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO PL-FLG-MES.RegPensio.
        RETURN "ADM-ERROR".
    END.

    IF NOT CAN-FIND(FIRST pl-tabla WHERE
        pl-tabla.codcia = 0 AND
        pl-tabla.tabla = '12' AND
        pl-tabla.codigo = PL-FLG-MES.TpoConTra:SCREEN-VALUE) THEN DO:
        MESSAGE
            "Tipo Contrato no es Válido"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO PL-FLG-MES.TpoConTra.
        RETURN "ADM-ERROR".
    END.

    IF NOT CAN-FIND(FIRST pl-tabla WHERE
        pl-tabla.codcia = 0 AND
        pl-tabla.tabla = '13' AND
        pl-tabla.codigo = PL-FLG-MES.PeriodIng:SCREEN-VALUE) THEN DO:
        MESSAGE
            "Periodicidad no es Válida"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO PL-FLG-MES.PeriodIng.
        RETURN "ADM-ERROR".
    END.

    IF PL-FLG-MES.AfilEPS:SCREEN-VALUE = "1" AND
        NOT CAN-FIND(FIRST pl-tabla WHERE
        pl-tabla.codcia = 0 AND
        pl-tabla.tabla = '14' AND
        pl-tabla.codigo = PL-FLG-MES.CodEPS:SCREEN-VALUE) THEN DO:
        MESSAGE
            "EPS no es Válido"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO PL-FLG-MES.CodEPS.
        RETURN "ADM-ERROR".
    END.
    IF PL-FLG-MES.AfilEPS:SCREEN-VALUE = "0" THEN DO:
        FILL-IN-CodEPS:SCREEN-VALUE = "".
        PL-FLG-MES.CodEPS:SCREEN-VALUE = "".
    END.

    IF NOT CAN-FIND(FIRST pl-tabla WHERE
        pl-tabla.codcia = 0 AND
        pl-tabla.tabla = '15' AND
        pl-tabla.codigo = PL-FLG-MES.Situacion:SCREEN-VALUE) THEN DO:
        MESSAGE
            "Situación EPS no es Válida"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO PL-FLG-MES.Situacion.
        RETURN "ADM-ERROR".
    END.

/*MLR-1* Inicio de Bloque ***/
    IF PL-FLG-MES.Campo-C[1]:SCREEN-VALUE = "" OR
        PL-FLG-MES.Campo-C[1]:SCREEN-VALUE = ? THEN DO:
        MESSAGE
            "Afiliación Asegura tu Pensión debe tener algún valor"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO PL-FLG-MES.Campo-C[1].
        RETURN "ADM-ERROR".
    END.

    IF PL-FLG-MES.Campo-C[2]:SCREEN-VALUE = "" OR
        PL-FLG-MES.Campo-C[2]:SCREEN-VALUE = ? THEN DO:
        MESSAGE
            "Categoría Ocupacional del Trabajador debe tener algún valor"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO PL-FLG-MES.Campo-C[2].
        RETURN "ADM-ERROR".
    END.

    IF PL-FLG-MES.Campo-C[3]:SCREEN-VALUE = "" OR
        PL-FLG-MES.Campo-C[3]:SCREEN-VALUE = ? THEN DO:
        MESSAGE
            "Convenio para Evitar Doble Tributación debe tener algún valor"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO PL-FLG-MES.Campo-C[3].
        RETURN "ADM-ERROR".
    END.
/*MLR-1* Fin de Bloque ***/

END.

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update V-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     Rutina de validacion en caso de modificacion
  Parameters:  Regresar "ADM-ERROR" si no se quiere modificar
  Notes:       
------------------------------------------------------------------------------*/

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

