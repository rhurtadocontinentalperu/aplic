&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v7r11 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME    W-maestro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-maestro 
/*-------------------------------------------------------------------------------

  File:
      < cjapresu.w    Presupuesto Anual por Cta

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author:  VALMIESA - DEPARTAMENTO DE TECNOLOGIA
           Jorge L. Infante B.
           
  Created: 02/09/95


------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/*~ MAESTRO V1.00 FOR MS-WINDOWS ~*/
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE {&NEW} SHARED VARIABLE s-codcia AS INTEGER INIT 1.

DEFINE VARIABLE RECID-stack AS RECID NO-UNDO.
DEFINE VARIABLE RECID-tmp   AS RECID NO-UNDO.
DEFINE VARIABLE pto         AS LOGICAL.
pto = SESSION:SET-WAIT-STATE(""). /* Para borrar Reloj de Arena del Mouse o Puntero */

/*   C A M B I O S   E N    L O S   P R E - P R O C E S A D O R E S */

/* Solo muestra los registros que cumplan con la condici¢n : */
&Scoped-define RECORD-SCOPE integral.Cjapresu.CodCia = s-codcia 

/* Como Buscar un Registro en la Tabla ( Para Crear, modificar, anular etc.) */
&Scoped-define SEARCH-KEY  integral.Cjapresu.Codflj =  INPUT FRAME F-maestro integral.Cjapresu.Codflj AND integral.Cjapresu.Anopre =  INPUT FRAME F-maestro integral.Cjapresu.Anopre

/* Asignacion de Valores por Defecto s-codcia    */
&Scoped-define FIELD-ADD integral.Cjapresu.CodCia = s-codcia  

/* Campos que no pueden ser modificados */
&Scoped-define NO-MODIFY integral.Cjapresu.Codflj integral.Cjapresu.Anopre

/* Programa donde realizara la Consulta */
&Scoped-define q-modelo cja/q-presu.w (INPUT s-codcia ,  OUTPUT RECID-stack )

/* Campos por los cuales se puede hacer Busquedas */
&Scoped-define Query-Field integral.Cjapresu.Codflj integral.Cjapresu.Anopre

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



/* ********************  Preprocessor Definitions  ******************** */

/* Name of first Frame and/or Browse (alphabetically)                   */
&Scoped-define FRAME-NAME  F-add

/* Custom List Definitions                                              */
&Scoped-define LIST-1 
&Scoped-define LIST-2 
&Scoped-define LIST-3 

/* Definitions for FRAME F-add                                          */
&Scoped-define FIELDS-IN-QUERY-F-add 
&Scoped-define ENABLED-FIELDS-IN-QUERY-F-add 

/* Definitions for FRAME F-ctrl-frame                                   */
&Scoped-define FIELDS-IN-QUERY-F-ctrl-frame 
&Scoped-define ENABLED-FIELDS-IN-QUERY-F-ctrl-frame 

/* Definitions for FRAME F-maestro                                      */
&Scoped-define FIELDS-IN-QUERY-F-maestro integral.Cjapresu.Codflj ~
integral.Cjapresu.Anopre integral.Cjapresu.Imppre[1] ~
integral.Cjapresu.Imppre[7] integral.Cjapresu.Imppre[2] ~
integral.Cjapresu.Imppre[8] integral.Cjapresu.Imppre[3] ~
integral.Cjapresu.Imppre[9] integral.Cjapresu.Imppre[4] ~
integral.Cjapresu.Imppre[10] integral.Cjapresu.Imppre[5] ~
integral.Cjapresu.Imppre[11] integral.Cjapresu.Imppre[6] ~
integral.Cjapresu.Imppre[12] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-F-maestro ~
integral.Cjapresu.Codflj integral.Cjapresu.Anopre integral.Cjapresu.Imppre[1] ~
integral.Cjapresu.Imppre[7] integral.Cjapresu.Imppre[2] ~
integral.Cjapresu.Imppre[8] integral.Cjapresu.Imppre[3] integral.Cjapresu.Imppre[9] ~
integral.Cjapresu.Imppre[4] integral.Cjapresu.Imppre[10] ~
integral.Cjapresu.Imppre[5] integral.Cjapresu.Imppre[11] integral.Cjapresu.Imppre[6] ~
integral.Cjapresu.Imppre[12] 
&Scoped-define OPEN-QUERY-F-maestro OPEN QUERY F-maestro FOR EACH integral.Cjapresu SHARE-LOCK.
&Scoped-define FIRST-TABLE-IN-QUERY-F-maestro integral.Cjapresu
&Scoped-define TABLES-IN-QUERY-F-maestro integral.Cjapresu 

/* Definitions for FRAME F-search                                       */
&Scoped-define FIELDS-IN-QUERY-F-search 
&Scoped-define ENABLED-FIELDS-IN-QUERY-F-search 

/* Definitions for FRAME F-update                                       */
&Scoped-define FIELDS-IN-QUERY-F-update 
&Scoped-define ENABLED-FIELDS-IN-QUERY-F-update 

/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-maestro AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-Cancel AUTO-END-KEY 
     LABEL "&Cancelar":L 
     SIZE 9 BY 1
     font 4.

DEFINE BUTTON B-ok 
     LABEL "&Aceptar":L 
     SIZE 9 BY 1
     font 4.

DEFINE RECTANGLE R-navigaate-2
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 90.57 BY 2
     BGCOLOR 8 FGCOLOR 15 .

DEFINE BUTTON B-add 
     LABEL "&Crear":L 
     SIZE 9 BY 1
     font 4.

DEFINE BUTTON B-browse 
     IMAGE-UP FILE "IMG/pvbrow"
     IMAGE-DOWN FILE "IMG/pvbrowd"
     IMAGE-INSENSITIVE FILE "IMG/pvbrowx"
     LABEL "&Consulta" 
     SIZE 5.72 BY 1.5.

DEFINE BUTTON B-delete 
     LABEL "&Eliminar":L 
     SIZE 9 BY 1
     font 4.

DEFINE BUTTON B-exit 
     LABEL "&Salir":L 
     SIZE 7 BY 1
     font 4.

DEFINE BUTTON B-first 
     IMAGE-UP FILE "IMG/pvfirst"
     IMAGE-DOWN FILE "IMG/pvfirstd"
     IMAGE-INSENSITIVE FILE "IMG/pvfirstx"
     LABEL "<<":L 
     SIZE 5 BY 1
     font 4.

DEFINE BUTTON B-last 
     IMAGE-UP FILE "IMG/pvlast"
     IMAGE-DOWN FILE "IMG/pvlastd"
     IMAGE-INSENSITIVE FILE "IMG/pvlastx"
     LABEL ">>":L 
     SIZE 4.57 BY 1
     font 4.

DEFINE BUTTON B-next 
     IMAGE-UP FILE "IMG/pvforw"
     IMAGE-DOWN FILE "IMG/pvforwd"
     IMAGE-INSENSITIVE FILE "IMG/pvforwx"
     LABEL ">":L 
     SIZE 5 BY 1
     font 4.

DEFINE BUTTON B-prev 
     IMAGE-UP FILE "IMG/pvback"
     IMAGE-DOWN FILE "IMG/pvbackd"
     IMAGE-INSENSITIVE FILE "IMG/pvbackx"
     LABEL "<":L 
     SIZE 5 BY 1
     font 4.

DEFINE BUTTON B-query 
     LABEL "&Query":L 
     SIZE 7.57 BY 1
     font 4.

DEFINE BUTTON B-update 
     LABEL "&Modificar":L 
     SIZE 9 BY 1
     font 4.

DEFINE RECTANGLE R-consulta
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 10 BY 2
     BGCOLOR 8 .

DEFINE RECTANGLE R-exit
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 11.57 BY 2
     BGCOLOR 8 FGCOLOR 15 .

DEFINE RECTANGLE R-modify
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 33 BY 2
     BGCOLOR 8 FGCOLOR 15 .

DEFINE RECTANGLE R-navigaate
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 26 BY 2
     BGCOLOR 8 FGCOLOR 15 .

DEFINE RECTANGLE R-query
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 10 BY 2
     BGCOLOR 8 FGCOLOR 15 .

DEFINE VARIABLE X-Desflj AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY 1
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE VARIABLE x-Destip AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY 1
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE RECTANGLE R-maestro1
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 90 BY 3.5
     BGCOLOR 8 FGCOLOR 15 .

DEFINE RECTANGLE R-maestro2
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 90 BY 10
     BGCOLOR 8 FGCOLOR 15 .

DEFINE BUTTON B-Cancel-3 
     LABEL "&Cancelar":L 
     SIZE 9 BY 1
     font 4.

DEFINE BUTTON B-ok-3 AUTO-GO 
     LABEL "&Aceptar":L 
     SIZE 9 BY 1
     font 4.

DEFINE RECTANGLE R-navigaate-4
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 90.57 BY 2
     BGCOLOR 8 FGCOLOR 15 .

DEFINE BUTTON B-Cancel-2 AUTO-END-KEY 
     LABEL "&Cancelar":L 
     SIZE 9 BY 1
     font 4.

DEFINE BUTTON B-ok-2 
     LABEL "&Aceptar":L 
     SIZE 9 BY 1
     font 4.

DEFINE RECTANGLE R-navigaate-3
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 90.57 BY 2
     BGCOLOR 8 FGCOLOR 15 .


/* Query definitions                                                    */
DEFINE QUERY F-maestro FOR integral.Cjapresu SCROLLING.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-add
     B-ok AT ROW 1.5 COL 24.29
     B-Cancel AT ROW 1.5 COL 57.57
     R-navigaate-2 AT ROW 1 COL 1
    WITH 1 DOWN OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 14.61
         SIZE 90.86 BY 2.08
         BGCOLOR 8 FGCOLOR 0 
         CANCEL-BUTTON B-Cancel.

DEFINE FRAME F-search
     B-ok-3 AT ROW 1.54 COL 24.29
     B-Cancel-3 AT ROW 1.54 COL 57.57
     R-navigaate-4 AT ROW 1 COL 1
    WITH 1 DOWN OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 14.61
         SIZE 90.86 BY 2.08
         BGCOLOR 8 FGCOLOR 0 .

DEFINE FRAME F-update
     B-ok-2 AT ROW 1.5 COL 24.29
     B-Cancel-2 AT ROW 1.5 COL 57.57
     R-navigaate-3 AT ROW 1 COL 1
    WITH 1 DOWN OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 14.61
         SIZE 90.86 BY 2.08
         BGCOLOR 8 FGCOLOR 0 .

DEFINE FRAME F-ctrl-frame
     B-browse AT ROW 1.27 COL 72
     B-query AT ROW 1.5 COL 2
     B-add AT ROW 1.5 COL 14
     B-update AT ROW 1.5 COL 24
     B-delete AT ROW 1.5 COL 34
     B-first AT ROW 1.5 COL 46
     B-prev AT ROW 1.5 COL 52
     B-next AT ROW 1.5 COL 58
     B-last AT ROW 1.5 COL 64
     B-exit AT ROW 1.5 COL 82
     R-query AT ROW 1 COL 1
     R-modify AT ROW 1 COL 11
     R-navigaate AT ROW 1 COL 44
     R-consulta AT ROW 1 COL 70
     R-exit AT ROW 1 COL 80
    WITH 1 DOWN OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 14.62
         SIZE 90.86 BY 2.08
         BGCOLOR 8 FGCOLOR 0 font 4.

DEFINE FRAME F-maestro
     x-Destip AT ROW 1.5 COL 76 COLON-ALIGNED NO-LABEL
     integral.Cjapresu.Codflj AT ROW 2.5 COL 37 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY 1
          BGCOLOR 15 FONT 1
     X-Desflj AT ROW 2.5 COL 46 COLON-ALIGNED NO-LABEL
     integral.Cjapresu.Anopre AT ROW 5 COL 37 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 6 BY 1
          BGCOLOR 15 FONT 1
     integral.Cjapresu.Imppre[1] AT ROW 6 COL 17.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .81
          BGCOLOR 15 
     integral.Cjapresu.Imppre[7] AT ROW 6 COL 58 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .81
          BGCOLOR 15 
     integral.Cjapresu.Imppre[2] AT ROW 7.5 COL 17.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .81
          BGCOLOR 15 
     integral.Cjapresu.Imppre[8] AT ROW 7.5 COL 58 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .81
          BGCOLOR 15 
     integral.Cjapresu.Imppre[3] AT ROW 9 COL 17.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .81
          BGCOLOR 15 
     integral.Cjapresu.Imppre[9] AT ROW 9 COL 58 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .81
          BGCOLOR 15 
     integral.Cjapresu.Imppre[4] AT ROW 10.5 COL 17.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .81
          BGCOLOR 15 
     integral.Cjapresu.Imppre[10] AT ROW 10.5 COL 58 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .81
          BGCOLOR 15 
     integral.Cjapresu.Imppre[5] AT ROW 12 COL 17 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .81
          BGCOLOR 15 
     integral.Cjapresu.Imppre[11] AT ROW 12 COL 58 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .81
          BGCOLOR 15 
     integral.Cjapresu.Imppre[6] AT ROW 13.5 COL 17.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .81
          BGCOLOR 15 
     integral.Cjapresu.Imppre[12] AT ROW 13.5 COL 58 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .81
          BGCOLOR 15 
     R-maestro1 AT ROW 1 COL 1
     "PRESUPUESTO" VIEW-AS TEXT
          SIZE 29 BY 1.5 AT ROW 1.5 COL 3
          FONT 11
     "Dolares" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 3 COL 3
          FONT 11
     R-maestro2 AT ROW 4.5 COL 1
     "A¤o :" VIEW-AS TEXT
          SIZE 5 BY .81 AT ROW 5 COL 34
          FONT 1
     "Enero" VIEW-AS TEXT
          SIZE 8 BY .81 AT ROW 6 COL 11
          FONT 1
     "Julio" VIEW-AS TEXT
          SIZE 8 BY .81 AT ROW 6 COL 48
          FONT 1
     "Febrero" VIEW-AS TEXT
          SIZE 8 BY .81 AT ROW 7.5 COL 11
          FONT 1
     "Agosto" VIEW-AS TEXT
          SIZE 8 BY .81 AT ROW 7.5 COL 48
          FONT 1
     "Marzo" VIEW-AS TEXT
          SIZE 8 BY .81 AT ROW 9 COL 11
          FONT 1
     "Setiembre" VIEW-AS TEXT
          SIZE 10 BY .81 AT ROW 9 COL 48
          FONT 1
     "Abril" VIEW-AS TEXT
          SIZE 8 BY .81 AT ROW 10.5 COL 11
          FONT 1
     "Octubre" VIEW-AS TEXT
          SIZE 8 BY .81 AT ROW 10.5 COL 48
          FONT 1
.
/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-maestro
     "Mayo" VIEW-AS TEXT
          SIZE 8 BY .81 AT ROW 12 COL 11
          FONT 1
     "Noviembre" VIEW-AS TEXT
          SIZE 10 BY .81 AT ROW 12 COL 48
          FONT 1
     "Junio" VIEW-AS TEXT
          SIZE 8 BY .81 AT ROW 13.5 COL 11
          FONT 1
     "Diciembre" VIEW-AS TEXT
          SIZE 10 BY .81 AT ROW 13.5 COL 48
          FONT 1
    WITH 1 DOWN NO-BOX OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 1
         SIZE 90.86 BY 13.54
         BGCOLOR 8 FGCOLOR 0 font 4.

 

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-maestro ASSIGN
         HIDDEN             = YES
         TITLE              = "Conceptos de Flujo"
         COLUMN             = 1.29
         ROW                = 1.08
         HEIGHT             = 15.81
         WIDTH              = 90.86
         MAX-HEIGHT         = 18.46
         MAX-WIDTH          = 91.43
         VIRTUAL-HEIGHT     = 18.46
         VIRTUAL-WIDTH      = 91.43
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = 8
         FGCOLOR            = 0
         THREE-D            = yes
         FONT               = 8
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

IF NOT W-maestro:LOAD-ICON("IMG/valmiesa") THEN
    MESSAGE "Unable to load icon: IMG/valmiesa"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR FRAME F-add
   NOT-VISIBLE UNDERLINE                                                */
ASSIGN 
       FRAME F-add:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON B-Cancel IN FRAME F-add
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON B-ok IN FRAME F-add
   NO-DISPLAY                                                           */
/* SETTINGS FOR FRAME F-ctrl-frame
   UNDERLINE                                                            */
/* SETTINGS FOR BUTTON B-add IN FRAME F-ctrl-frame
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON B-delete IN FRAME F-ctrl-frame
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON B-exit IN FRAME F-ctrl-frame
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON B-first IN FRAME F-ctrl-frame
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON B-last IN FRAME F-ctrl-frame
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON B-next IN FRAME F-ctrl-frame
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON B-prev IN FRAME F-ctrl-frame
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON B-query IN FRAME F-ctrl-frame
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON B-update IN FRAME F-ctrl-frame
   NO-DISPLAY                                                           */
/* SETTINGS FOR FRAME F-maestro
   UNDERLINE                                                            */
/* SETTINGS FOR FILL-IN X-Desflj IN FRAME F-maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-Destip IN FRAME F-maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME F-search
   NOT-VISIBLE UNDERLINE                                                */
ASSIGN 
       FRAME F-search:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON B-Cancel-3 IN FRAME F-search
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON B-ok-3 IN FRAME F-search
   NO-DISPLAY                                                           */
/* SETTINGS FOR FRAME F-update
   NOT-VISIBLE UNDERLINE                                                */
ASSIGN 
       FRAME F-update:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON B-Cancel-2 IN FRAME F-update
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON B-ok-2 IN FRAME F-update
   NO-DISPLAY                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-maestro)
THEN W-maestro:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-maestro
/* Query rebuild information for FRAME F-maestro
     _TblList          = "integral.Cjapresu"
     _Options          = "SHARE-LOCK"
     _OrdList          = ""
     _Query            is OPENED
*/  /* FRAME F-maestro */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define FRAME-NAME F-ctrl-frame
&Scoped-define SELF-NAME B-add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-add W-maestro
ON CHOOSE OF B-add IN FRAME F-ctrl-frame /* Crear */
DO:
    FRAME F-ctrl-frame:VISIBLE = FALSE.
    FRAME F-add:VISIBLE = TRUE.
    CLEAR FRAME f-maestro.
    RECID-stack = 0.
    DO TRANSACTION:
        CREATE  {&FIRST-TABLE-IN-QUERY-F-maestro} .
        DISPLAY {&FIELDS-IN-QUERY-F-maestro} WITH FRAME F-maestro.
        ENABLE  {&FIELDS-IN-QUERY-F-maestro} WITH FRAME F-maestro.
        RECID-stack = RECID ( {&FIRST-TABLE-IN-QUERY-F-maestro} ).
        WAIT-FOR CHOOSE OF b-ok OR CHOOSE OF b-cancel.
    END.
    FRAME f-add:VISIBLE = FALSE.
    FRAME f-ctrl-frame:visible = TRUE.
    DISABLE {&FIELDS-IN-QUERY-F-maestro} WITH FRAME F-maestro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-browse W-maestro
ON CHOOSE OF B-browse IN FRAME F-ctrl-frame /* Consulta */
DO:
    RUN {&q-modelo}.
    IF RECID-stack <> 0
    THEN DO:
        FIND {&TABLES-IN-QUERY-F-maestro}
             WHERE RECID( {&TABLES-IN-QUERY-F-maestro} ) = RECID-stack
                 NO-LOCK  NO-ERROR.
         IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN DO:
             DISPLAY  {&FIELDS-IN-QUERY-F-maestro} WITH FRAME F-maestro.
             
             FIND integral.cjaconce
                 WHERE integral.Cjaconce.Codcia = integral.Cjapresu.Codcia AND integral.Cjaconce.Codflj = integral.Cjapresu.Codflj
                     NO-LOCK  NO-ERROR.
                 DISPLAY  integral.Cjaconce.Codflj @ integral.Cjapresu.Codflj WITH FRAME F-maestro.
                 x-desflj:SCREEN-VALUE = integral.Cjaconce.Desflj.                  
         
         END.
         ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
         BUTTONS OK.
     END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-add
&Scoped-define SELF-NAME B-Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Cancel W-maestro
ON CHOOSE OF B-Cancel IN FRAME F-add /* Cancelar */
DO:
    IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN DO:
        DELETE {&FIRST-TABLE-IN-QUERY-F-maestro}.
    END.
    FIND PREV {&FIRST-TABLE-IN-QUERY-F-maestro}
        &IF "{&RECORD-SCOPE}" <> "" &THEN
            WHERE {&RECORD-SCOPE}
        &ENDIF
        NO-LOCK NO-ERROR.
    IF NOT AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro}
    THEN FIND FIRST {&FIRST-TABLE-IN-QUERY-F-maestro}
        &IF "{&RECORD-SCOPE}" <> "" &THEN
            WHERE {&RECORD-SCOPE}
        &ENDIF
        NO-LOCK NO-ERROR.
    IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN DO:
        DISPLAY {&FIELDS-IN-QUERY-F-maestro} WITH FRAME f-maestro.
    END.
    ELSE CLEAR FRAME F-maestro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-search
&Scoped-define SELF-NAME B-Cancel-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Cancel-3 W-maestro
ON CHOOSE OF B-Cancel-3 IN FRAME F-search /* Cancelar */
DO:
    FIND PREV {&FIRST-TABLE-IN-QUERY-F-maestro}
        &IF "{&RECORD-SCOPE}" <> "" &THEN
             WHERE {&RECORD-SCOPE}
        &ENDIF
        NO-LOCK NO-ERROR.
    IF NOT AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN
        FIND FIRST {&FIRST-TABLE-IN-QUERY-F-maestro}
            &IF "{&RECORD-SCOPE}" <> "" &THEN
                WHERE {&RECORD-SCOPE}
            &ENDIF
            NO-LOCK NO-ERROR.
    IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN DO:
        DISPLAY {&FIELDS-IN-QUERY-F-maestro} WITH FRAME f-maestro.
    END.
    ELSE CLEAR FRAME F-maestro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-ctrl-frame
&Scoped-define SELF-NAME B-delete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-delete W-maestro
ON CHOOSE OF B-delete IN FRAME F-ctrl-frame /* Eliminar */
DO:
    RECID-tmp = 0.
    IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN
        RECID-Tmp = RECID( {&FIRST-TABLE-IN-QUERY-F-maestro} ).
    FIND FIRST {&FIRST-TABLE-IN-QUERY-F-maestro}
        &IF "{&RECORD-SCOPE}" <> "" &THEN
            WHERE {&RECORD-SCOPE}
        &ENDIF
        NO-LOCK NO-ERROR.
    IF NOT AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN DO:
        CLEAR FRAME F-maestro.
        MESSAGE  "No exiten Registros." VIEW-AS ALERT-BOX ERROR
        BUTTONS OK.
        RETURN.
    END.
    FRAME F-ctrl-frame:VISIBLE = FALSE.
    DO TRANSACTION ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        FIND {&FIRST-TABLE-IN-QUERY-F-maestro}
            WHERE RECID-Tmp = RECID( {&FIRST-TABLE-IN-QUERY-F-maestro} )
            EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN DO:
            MESSAGE "Eliminar el Registro"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE selection AS LOGICAL.
            IF selection THEN DO:
                DELETE {&FIRST-TABLE-IN-QUERY-F-maestro}.
            END.
            ELSE
                FIND {&FIRST-TABLE-IN-QUERY-F-maestro}
                    WHERE RECID-Tmp = RECID(  {&FIRST-TABLE-IN-QUERY-F-maestro} )
                        NO-LOCK NO-ERROR.
        END.
        ELSE MESSAGE "Registros no existente." VIEW-AS ALERT-BOX ERROR
        BUTTONS OK.
    END.
    IF NOT AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN DO:
        FIND PREV {&FIRST-TABLE-IN-QUERY-F-maestro}
        &IF "{&RECORD-SCOPE}" <> "" &THEN
            WHERE {&RECORD-SCOPE}
        &ENDIF
        NO-LOCK NO-ERROR.
        IF NOT AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro}
        THEN FIND FIRST {&FIRST-TABLE-IN-QUERY-F-maestro}
            &IF "{&RECORD-SCOPE}" <> "" &THEN
                WHERE {&RECORD-SCOPE}
            &ENDIF
            NO-LOCK NO-ERROR.
        IF AVAIL  {&FIRST-TABLE-IN-QUERY-F-maestro} THEN DO:
            DISPLAY {&FIELDS-IN-QUERY-F-maestro} WITH FRAME f-maestro.
        END.
        ELSE DO:
            CLEAR FRAME F-maestro.
        END.
    END.
    FRAME F-ctrl-frame:VISIBLE = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-exit W-maestro
ON CHOOSE OF B-exit IN FRAME F-ctrl-frame /* Salir */
DO:
     APPLY  "CLOSE" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-first
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-first W-maestro
ON CHOOSE OF B-first IN FRAME F-ctrl-frame /* << */
DO:
    FIND FIRST {&TABLES-IN-QUERY-F-maestro}
        &IF "{&RECORD-SCOPE}" <> "" &THEN
            WHERE {&RECORD-SCOPE}
        &ENDIF
        NO-LOCK  NO-ERROR.
    IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN DO:
        DISPLAY  {&FIELDS-IN-QUERY-F-maestro} WITH FRAME F-maestro.
    
        RUN Dspdesc.
    
    END.
    ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
    BUTTONS OK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-last
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-last W-maestro
ON CHOOSE OF B-last IN FRAME F-ctrl-frame /* >> */
DO:
    FIND LAST {&FIRST-TABLE-IN-QUERY-F-maestro}
    &IF "{&RECORD-SCOPE}" <> "" &THEN
        WHERE {&RECORD-SCOPE}
    &ENDIF
    NO-LOCK  NO-ERROR.
    IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN DO:
        DISPLAY {&FIELDS-IN-QUERY-F-maestro} WITH FRAME F-maestro.

        RUN Dspdesc. 
    END.
    ELSE MESSAGE "No exiten Registros." VIEW-AS ALERT-BOX ERROR
    BUTTONS OK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-next
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-next W-maestro
ON CHOOSE OF B-next IN FRAME F-ctrl-frame /* > */
DO: 
    FIND NEXT {&FIRST-TABLE-IN-QUERY-F-maestro}
        &IF "{&RECORD-SCOPE}" <> "" &THEN
            WHERE {&RECORD-SCOPE}
        &ENDIF
        NO-LOCK  NO-ERROR.
    IF NOT AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN
        FIND FIRST {&FIRST-TABLE-IN-QUERY-F-maestro}
        &IF "{&RECORD-SCOPE}" <> "" &THEN
            WHERE {&RECORD-SCOPE}
        &ENDIF
        NO-LOCK NO-ERROR.
    IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN DO:
        DISPLAY {&FIELDS-IN-QUERY-F-maestro} WITH FRAME F-maestro.
        
        RUN Dspdesc.
        
    END.
    ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
    BUTTONS OK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-add
&Scoped-define SELF-NAME B-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-ok W-maestro
ON CHOOSE OF B-ok IN FRAME F-add /* Aceptar */
DO:
    IF CAN-FIND( {&FIRST-TABLE-IN-QUERY-F-maestro}
        WHERE
        &IF "{&RECORD-SCOPE}" <> "" &THEN
            {&RECORD-SCOPE} AND
        &ENDIF
        {&SEARCH-KEY} ) THEN 
        DO:
        MESSAGE "Registro Existente" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO integral.Cjapresu.Codflj IN FRAME F-maestro.
        RETURN NO-APPLY.
        END.
    
    IF integral.Cjapresu.Codflj:SCREEN-VALUE IN FRAME F-Maestro = "" THEN DO:
        MESSAGE "C¢digo es Obligatorio" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO integral.Cjapresu.Codflj IN FRAME F-maestro.
        RETURN NO-APPLY.
    END.
    
    IF integral.Cjapresu.Anopre:SCREEN-VALUE IN FRAME F-Maestro = "" THEN DO:
        MESSAGE "A¤o es Dato Obligatorio" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO integral.Cjapresu.Anopre IN FRAME F-maestro.
        RETURN NO-APPLY.
    END.  
           
    
    ASSIGN FRAME F-Maestro
    {&FIELDS-IN-QUERY-F-maestro}
    {&FIELD-ADD}.
    FIND {&FIRST-TABLE-IN-QUERY-F-maestro}
        WHERE RECID-stack = RECID ( {&FIRST-TABLE-IN-QUERY-F-maestro} )
            NO-LOCK NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-update
&Scoped-define SELF-NAME B-ok-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-ok-2 W-maestro
ON CHOOSE OF B-ok-2 IN FRAME F-update /* Aceptar */
DO:    
    IF integral.Cjapresu.Anopre:SCREEN-VALUE IN FRAME F-Maestro = "" THEN DO:
        MESSAGE "A¤o es Dato Obligatorio" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO integral.Cjapresu.Anopre IN FRAME F-maestro.
        RETURN NO-APPLY.
    END.

  ASSIGN FRAME F-maestro
  {&FIELDS-IN-QUERY-F-maestro}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-search
&Scoped-define SELF-NAME B-ok-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-ok-3 W-maestro
ON CHOOSE OF B-ok-3 IN FRAME F-search /* Aceptar */
DO:
    IF  integral.Cjapresu.Codflj:SCREEN-VALUE IN FRAME F-Maestro <> "" THEN DO:
        FIND FIRST {&FIRST-TABLE-IN-QUERY-F-maestro}
            WHERE
            &IF "{&RECORD-SCOPE}" <> "" &THEN
                {&RECORD-SCOPE} AND
            &ENDIF
            integral.Cjapresu.Codflj = integral.Cjapresu.Codflj:SCREEN-VALUE
            NO-LOCK NO-ERROR.
    END.
    IF NOT AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN DO:
        APPLY "CHOOSE" TO B-Browse IN FRAME F-ctrl-frame.
        IF RECID-stack <> 0
        THEN RETURN.
    END.
    IF NOT AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN DO:
        FIND FIRST  {&FIRST-TABLE-IN-QUERY-F-maestro}
            &IF "{&RECORD-SCOPE}" <> "" &THEN
                WHERE {&RECORD-SCOPE}
            &ENDIF
            NO-LOCK NO-ERROR.
    END.
    IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN  DO:
        DISPLAY {&FIELDS-IN-QUERY-F-maestro} WITH FRAME f-maestro.
        
        RUN Dspdesc.
        
        {&OPEN-QUERY-BRW-conce}        
    END.
    IF NOT AVAIL  {&FIRST-TABLE-IN-QUERY-F-maestro}  THEN DO:
        CLEAR FRAME F-maestro.
        MESSAGE "Registro no Existente." VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-ctrl-frame
&Scoped-define SELF-NAME B-prev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-prev W-maestro
ON CHOOSE OF B-prev IN FRAME F-ctrl-frame /* < */
DO:
    FIND PREV {&FIRST-TABLE-IN-QUERY-F-maestro}
        &IF "{&RECORD-SCOPE}" <> "" &THEN
            WHERE {&RECORD-SCOPE}
        &ENDIF
        NO-LOCK  NO-ERROR.
    IF NOT AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN
        FIND LAST {&FIRST-TABLE-IN-QUERY-F-maestro}
        &IF "{&RECORD-SCOPE}" <> "" &THEN
            WHERE {&RECORD-SCOPE}
        &ENDIF
        NO-LOCK NO-ERROR.
    IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN DO:
        DISPLAY {&FIELDS-IN-QUERY-F-maestro} WITH FRAME F-maestro.

        RUN Dspdesc.
        
    END.
    ELSE MESSAGE "No Existen Registros" VIEW-AS ALERT-BOX ERROR
    BUTTONS OK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-query
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-query W-maestro
ON CHOOSE OF B-query IN FRAME F-ctrl-frame /* Query */
DO:
    FIND FIRST {&FIRST-TABLE-IN-QUERY-F-maestro}
        &IF "{&RECORD-SCOPE}" <> "" &THEN
            WHERE {&RECORD-SCOPE}
        &ENDIF
        NO-LOCK NO-ERROR.
    IF NOT AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN DO:
        MESSAGE  "No exiten Registros." VIEW-AS ALERT-BOX ERROR
        BUTTONS OK.
        RETURN.
    END.
    CLEAR FRAME F-maestro.
    FRAME F-ctrl-frame:VISIBLE = FALSE.
    FRAME F-search:VISIBLE = TRUE.
    ENABLE {&QUERY-field} WITH FRAME F-maestro.
    WAIT-FOR "CHOOSE" OF b-ok-3 IN FRAME f-search
        OR CHOOSE OF b-cancel-3 IN FRAME f-search.
    DISABLE {&QUERY-field} WITH FRAME F-maestro.
    FRAME f-search:VISIBLE = FALSE.
    FRAME f-ctrl-frame:VISIBLE = TRUE.
END. /*choose of b-query*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-update
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-update W-maestro
ON CHOOSE OF B-update IN FRAME F-ctrl-frame /* Modificar */
DO:
    RECID-stack = 0.
    IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN
        RECID-stack = RECID( {&FIRST-TABLE-IN-QUERY-F-maestro} ).
    FIND FIRST {&FIRST-TABLE-IN-QUERY-F-maestro}
        &IF "{&RECORD-SCOPE}" <> "" &THEN
            WHERE {&RECORD-SCOPE}
        &ENDIF
        NO-LOCK NO-ERROR.
    IF NOT AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN DO:
        MESSAGE  "No exiten Registros." VIEW-AS ALERT-BOX ERROR
        BUTTONS OK.
        RETURN.
    END.
    FRAME f-ctrl-frame:VISIBLE = FALSE.
    FRAME f-update:VISIBLE = TRUE.
    DO TRANSACTION ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        FIND {&FIRST-TABLE-IN-QUERY-F-maestro}
            WHERE RECID-stack = RECID( {&FIRST-TABLE-IN-QUERY-F-maestro} )
                EXCLUSIVE NO-ERROR.
        IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN DO:
            ENABLE {&FIELDS-IN-QUERY-F-maestro} WITH FRAME F-maestro.
            DISABLE {&NO-MODIFY} WITH FRAME F-maestro.
            WAIT-FOR CHOOSE OF b-ok-2 OR CHOOSE OF B-cancel-2 IN FRAME f-UPDATE.
        END.
        ELSE MESSAGE "Registros no existente." VIEW-AS ALERT-BOX ERROR
            BUTTONS OK.
    END.  /*transaction*/
    IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN
        FIND {&FIRST-TABLE-IN-QUERY-F-maestro}
            WHERE RECID-stack = RECID( {&FIRST-TABLE-IN-QUERY-F-maestro} )
                NO-LOCK NO-ERROR.
    ELSE
        FIND PREV  {&FIRST-TABLE-IN-QUERY-F-maestro}
            &IF "{&RECORD-SCOPE}" <> "" &THEN
                WHERE {&RECORD-SCOPE}
            &ENDIF
            NO-LOCK NO-ERROR.
    IF NOT AVAIL  {&FIRST-TABLE-IN-QUERY-F-maestro}
    THEN FIND FIRST  {&FIRST-TABLE-IN-QUERY-F-maestro}
        &IF "{&RECORD-SCOPE}" <> "" &THEN
            WHERE {&RECORD-SCOPE}
        &ENDIF
        NO-LOCK NO-ERROR.
    IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN
        DISPLAY {&FIELDS-IN-QUERY-F-maestro} WITH FRAME f-maestro.
   
    ELSE CLEAR FRAME F-maestro.
    DISABLE {&FIELDS-IN-QUERY-F-maestro} WITH FRAME F-maestro.
    FRAME f-update:VISIBLE = FALSE.
    FRAME F-ctrl-frame:VISIBLE = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-maestro
&Scoped-define SELF-NAME integral.Cjapresu.Codflj
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL integral.Cjapresu.Codflj W-maestro
ON F8 OF integral.Cjapresu.Codflj IN FRAME F-maestro /* C¢digo */
DO:
    RECID-tmp = 0.
    RUN cja/q-conce.w (s-codcia, OUTPUT RECID-tmp).
    IF RECID-tmp <> 0
    THEN DO:
        FIND integral.cjaconce
             WHERE RECID( integral.Cjaconce ) = RECID-tmp
                 NO-LOCK  NO-ERROR.
         IF AVAIL integral.cjaconce THEN DO:
             DISPLAY  integral.Cjaconce.Codflj @ integral.Cjapresu.Codflj WITH FRAME F-maestro.
             x-desflj:SCREEN-VALUE = integral.Cjaconce.Desflj. 
         END.
         ELSE MESSAGE "C¢digo Ingresado No existe" VIEW-AS ALERT-BOX ERROR.      
              APPLY "ENTRY" TO integral.Cjapresu.Codflj IN FRAME F-Maestro.
              RETURN NO-APPLY.
     END.
        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL integral.Cjapresu.Codflj W-maestro
ON LEAVE OF integral.Cjapresu.Codflj IN FRAME F-maestro /* C¢digo */
DO:
   IF LOOKUP(LAST-EVENT:FUNCTION,"ERROR,ENDKEY,END-KEY") <> 0 THEN RETURN.
    FIND integral.Cjaconce WHERE integral.Cjaconce.Codcia = s-codcia AND
         integral.Cjaconce.Codflj = INPUT FRAME F-maestro integral.Cjapresu.Codflj
            NO-LOCK NO-ERROR.
    IF NOT AVAILABLE integral.Cjaconce THEN DO:
        BELL.
        MESSAGE "C¢digo de Concepto no registrado" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO integral.Cjapresu.Codflj IN FRAME F-Maestro.
        RETURN NO-APPLY.
    END.
    DISPLAY integral.Cjaconce.Codflj @ integral.Cjapresu.Codflj WITH FRAME F-maestro.  
    x-desflj:SCREEN-VALUE = integral.Cjaconce.Desflj.   

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL integral.Cjapresu.Codflj W-maestro
ON MOUSE-SELECT-DBLCLICK OF integral.Cjapresu.Codflj IN FRAME F-maestro /* C¢digo */
DO:
    RECID-tmp = 0.
    RUN cja/q-conce.w (s-codcia, OUTPUT RECID-tmp).
    IF RECID-tmp <> 0
    THEN DO:
        FIND integral.cjaconce
             WHERE RECID( integral.Cjaconce ) = RECID-tmp
                 NO-LOCK  NO-ERROR.
         IF AVAIL integral.cjaconce THEN DO:
             DISPLAY  integral.Cjaconce.Codflj @ integral.Cjapresu.Codflj WITH FRAME F-maestro.
             x-desflj:SCREEN-VALUE = integral.Cjaconce.Desflj. 
         END.
         ELSE MESSAGE "C¢digo Ingresado No existe" VIEW-AS ALERT-BOX ERROR.      
              APPLY "ENTRY" TO integral.Cjapresu.Codflj IN FRAME F-Maestro.
              RETURN NO-APPLY.
     END.
        
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-add
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-maestro 


/* ***************************  Main Block  *************************** */

/* Send messages to alert boxes because there is no message area.       */
ASSIGN CURRENT-WINDOW          = {&WINDOW-NAME}
    SESSION:SYSTEM-ALERT-BOXES = (CURRENT-WINDOW:MESSAGE-AREA = NO).

ON CLOSE OF THIS-PROCEDURE
    RUN disable_UI.

ON "WINDOW-CLOSE" OF {&WINDOW-NAME}
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.
END.

ON "ENDKEY", END-ERROR OF B-add, B-browse, B-Cancel, B-Cancel-2, B-Cancel-3, 
        B-delete, B-exit, B-first, B-last, B-next, B-ok, B-ok-2, B-ok-3, B-prev,
        B-query, B-update, FRAME F-maestro
DO:
    IF FRAME F-add:VISIBLE    = TRUE THEN APPLY "CHOOSE" TO B-cancel.
    IF FRAME F-update:VISIBLE = TRUE THEN APPLY "CHOOSE" TO B-cancel-2.
    IF FRAME F-search:VISIBLE = TRUE THEN APPLY "CHOOSE" TO B-cancel-3.
    IF FRAME F-ctrl-frame:VISIBLE = TRUE
    THEN APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.
END.

ON "GO" OF FRAME F-maestro, FRAME F-add, FRAME F-update, FRAME F-search
DO: 
    IF FRAME F-add:VISIBLE    = TRUE THEN APPLY "CHOOSE" TO B-ok.
    IF FRAME F-update:VISIBLE = TRUE THEN APPLY "CHOOSE" TO B-ok-2.
    IF FRAME F-search:VISIBLE = TRUE THEN APPLY "CHOOSE" TO B-ok-3.
    RETURN NO-APPLY.
END.

ON DELETE-CHARACTER OF  B-query, B-add, B-update, B-delete,
        B-First, B-prev, B-next, B-last, B-Browse, B-exit
DO:
    APPLY "CHOOSE" TO B-delete.
    RETURN NO-APPLY.
END.

ON END OF B-query, B-add, B-update, B-delete,
        B-First, B-prev, B-next, B-last, B-Browse, B-exit
DO:
    APPLY "CHOOSE" TO B-last.
    RETURN NO-APPLY.
END.

ON F8 OF  B-query, B-add, B-update, B-delete,
        B-First, B-prev, B-next, B-last, B-Browse, B-exit
DO:
    APPLY "CHOOSE" TO B-browse.
    RETURN NO-APPLY.
END.

ON HOME OF  B-query, B-add, B-update, B-delete,
        B-First, B-prev, B-next, B-last, B-Browse, B-exit
DO:
    APPLY "CHOOSE" TO B-first.
    RETURN NO-APPLY.
END.

ON INSERT-MODE OF  B-query, B-add, B-update, B-delete,
        B-First, B-prev, B-next, B-last, B-Browse, B-exit
DO:
    APPLY "CHOOSE" TO B-add.
    RETURN NO-APPLY.
END.

ON PAGE-DOWN OF  B-query, B-add, B-update, B-delete,
        B-First, B-prev, B-next, B-last, B-Browse, B-exit
DO:
    APPLY "CHOOSE" TO B-next.
    RETURN NO-APPLY.
END.

ON PAGE-UP OF  B-query, B-add, B-update, B-delete,
        B-First, B-prev, B-next, B-last, B-Browse, B-exit
DO:
    APPLY "CHOOSE" TO B-prev.
    RETURN NO-APPLY.
END.

ON RETURN OF  B-query, B-add, B-update, B-delete,
        B-First, B-prev, B-next, B-last, B-Browse, B-exit
DO:
    APPLY "CHOOSE" TO B-update.
    RETURN NO-APPLY.
END.


/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

MAIN-BLOCK:
DO ON ERROR UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
    ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    ASSIGN
    FRAME f-add:VISIBLE = FALSE
    FRAME f-update:VISIBLE = FALSE
    FRAME f-search:VISIBLE = FALSE
    FRAME F-ctrl-frame:VISIBLE = TRUE.
    RUN enable_UI.

    FIND LAST {&FIRST-TABLE-IN-QUERY-F-maestro}
    &IF "{&RECORD-SCOPE}" <> "" &THEN
         WHERE {&RECORD-SCOPE}
    &ENDIF  
    NO-LOCK  NO-ERROR.    
    IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN DO:
       DISPLAY {&FIELDS-IN-QUERY-F-maestro} WITH FRAME F-maestro.
        
        RUN Dspdesc.
         
       {&OPEN-BROWSERS-IN-QUERY-F-maestro}
    END.
    ELSE CLEAR FRAME F-maestro. 

    DISABLE {&FIELDS-IN-QUERY-F-maestro} WITH FRAME F-maestro.
    IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-maestro _DEFAULT-DISABLE
PROCEDURE disable_UI :
/* --------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
   -------------------------------------------------------------------- */
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U THEN DELETE WIDGET W-maestro.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Dspdesc W-maestro 
PROCEDURE Dspdesc :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/

FIND integral.cjaconce
                 WHERE integral.Cjaconce.Codcia = integral.Cjapresu.Codcia AND integral.Cjaconce.Codflj = integral.Cjapresu.Codflj
                     NO-LOCK  NO-ERROR.
                 DISPLAY  integral.Cjaconce.Codflj @ integral.Cjapresu.Codflj WITH FRAME F-maestro.
                          x-desflj:SCREEN-VALUE = integral.Cjaconce.Desflj.
                 IF integral.Cjaconce.tipflj = TRUE THEN
                     X-Destip:SCREEN-VALUE = "Ingreso".
                 ELSE 
                     X-Destip:SCREEN-VALUE = "Egreso".
                         
              
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-maestro _DEFAULT-ENABLE
PROCEDURE enable_UI :
/* --------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
   -------------------------------------------------------------------- */

  {&OPEN-QUERY-F-maestro}
  GET FIRST F-maestro.
  DISPLAY x-Destip X-Desflj 
      WITH FRAME F-maestro IN WINDOW W-maestro.
  IF AVAILABLE integral.Cjapresu THEN 
    DISPLAY integral.Cjapresu.Codflj integral.Cjapresu.Anopre 
          integral.Cjapresu.Imppre[1] integral.Cjapresu.Imppre[7] 
          integral.Cjapresu.Imppre[2] integral.Cjapresu.Imppre[8] 
          integral.Cjapresu.Imppre[3] integral.Cjapresu.Imppre[9] 
          integral.Cjapresu.Imppre[4] integral.Cjapresu.Imppre[10] 
          integral.Cjapresu.Imppre[5] integral.Cjapresu.Imppre[11] 
          integral.Cjapresu.Imppre[6] integral.Cjapresu.Imppre[12] 
      WITH FRAME F-maestro IN WINDOW W-maestro.
  ENABLE R-maestro1 integral.Cjapresu.Codflj R-maestro2 
         integral.Cjapresu.Anopre integral.Cjapresu.Imppre[1] 
         integral.Cjapresu.Imppre[7] integral.Cjapresu.Imppre[2] 
         integral.Cjapresu.Imppre[8] integral.Cjapresu.Imppre[3] 
         integral.Cjapresu.Imppre[9] integral.Cjapresu.Imppre[4] 
         integral.Cjapresu.Imppre[10] integral.Cjapresu.Imppre[5] 
         integral.Cjapresu.Imppre[11] integral.Cjapresu.Imppre[6] 
         integral.Cjapresu.Imppre[12] 
      WITH FRAME F-maestro IN WINDOW W-maestro.
  {&OPEN-BROWSERS-IN-QUERY-F-maestro}
  ENABLE R-navigaate-2 B-ok B-Cancel 
      WITH FRAME F-add IN WINDOW W-maestro.
  {&OPEN-BROWSERS-IN-QUERY-F-add}
  ENABLE R-navigaate-4 B-ok-3 B-Cancel-3 
      WITH FRAME F-search IN WINDOW W-maestro.
  {&OPEN-BROWSERS-IN-QUERY-F-search}
  ENABLE R-navigaate-3 B-ok-2 B-Cancel-2 
      WITH FRAME F-update IN WINDOW W-maestro.
  {&OPEN-BROWSERS-IN-QUERY-F-update}
  ENABLE R-query R-modify R-navigaate R-consulta R-exit B-browse B-query B-add 
         B-update B-delete B-first B-prev B-next B-last B-exit 
      WITH FRAME F-ctrl-frame IN WINDOW W-maestro.
  {&OPEN-BROWSERS-IN-QUERY-F-ctrl-frame}
  VIEW W-maestro.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE FRAME-NAME
&UNDEFINE WINDOW-NAME
