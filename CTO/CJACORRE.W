&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-maestro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-maestro 
/*------------------------------------------------------------------------

  File: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author:  VALMIESA - DEPARTAMENTO DE TECNOLOGIA

  Created: 10/25/93 - 11:42 am

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/*~ MAESTRO V1.00 FOR MS-WINDOWS ~*/
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE {&NEW} SHARED VARIABLE  s-codcia AS INTEGER INITIAL 1.
DEFINE VARIABLE RECID-stack AS RECID NO-UNDO.
DEFINE VARIABLE RECID-tmp   AS RECID NO-UNDO.
DEFINE VARIABLE x-nivel     AS CHARACTER.
DEFINE VARIABLE Y-codcia    AS INTEGER INITIAL 0.

FIND integral.empresas WHERE integral.empresas.codcia = s-codcia.
IF NOT integral.empresas.campo-codcbd THEN y-codcia = s-codcia.

DEFINE VARIABLE pto AS LOGICAL.
pto = SESSION:SET-WAIT-STATE("").
DEFINE {&NEW} SHARED VARIABLE cb-niveles AS CHARACTER INITIAL "2,3,5".
DEFINE VARIABLE x-tabla  AS CHARACTER INITIAL "04".
DEFINE VARIABLE x-ctacre AS CHARACTER INITIAL "".
DEFINE VARIABLE x-ctaaho AS CHARACTER INITIAL "".
DEFINE VARIABLE x-maxnivel AS INTEGER.

FIND integral.cb-cfga WHERE cb-cfga.CodCia = Y-CodCia AND CodCfg = 1
    NO-LOCK NO-ERROR.        
IF NOT AVAIL integral.cb-cfga THEN DO:
    BELL.
    MESSAGE "NO SE HA CONFIGURADO EL SISTEMA CONTABLE"
        VIEW-AS ALERT-BOX.
    RETURN.
END.

IF integral.cb-cfga.ctacredito = "" OR integral.cb-cfga.ctaahorro = "" THEN DO: 
    BELL.
    MESSAGE "NO SE HA CONFIGURADO LAS VARIABLES DE CAJA Y BANCOS" 
        VIEW-AS ALERT-BOX.
    RETURN.
END.       
x-ctacre = integral.cb-cfga.ctacredito.
x-ctaaho = integral.cb-cfga.ctaahorro.
x-nivel  = ENTRY(2, cb-niveles).   
x-maxnivel = NUM-ENTRIES(cb-niveles).
x-maxnivel = INTEGER ( ENTRY ( x-maxnivel,cb-niveles )).
   
/*   C A M B I O S   E N    L O S   P R E - P R O C E S A D O R E S */

/* Solo muestra los registros que cumplan con la condici¢n : */
&Scoped-define RECORD-SCOPE integral.cb-ctas.CodCia = Y-CodCia   AND ~
    ( integral.cb-ctas.Codcta BEGINS integral.cb-cfga.ctacredito OR  ~
    integral.cb-ctas.Codcta BEGINS integral.cb-cfga.ctaahorro )  AND ~
    LENGTH ( integral.cb-ctas.Codcta ) = x-maxnivel

/* Como Buscar un Registro en la Tabla ( Para Crear, modificar, anular etc.) */
&Scoped-define SEARCH-KEY integral.cb-ctas.Codcta = integral.cb-ctas.Codcta:SCREEN-VALUE IN FRAME F-maestro

/* Campos Ocultos que deben ser asignados en cada modificaci¢n */
&Scoped-define ASSIGN-ADD integral.cb-ctas.CodCia = Y-CodCia

/* Campos que no pueden ser modificados */
&Scoped-define NO-MODIFY integral.cb-ctas.Codcta integral.cb-ctas.nomcta

/* Programa donde relaizara la Consulta */
&Scoped-define q-modelo cbd/q-ctas3.w ( Y-CodCia, "10", OUTPUT RECID-stack )

/* Campos por los cuales se puede hacer Busquedas */
&Scoped-define Query-Field cb-ctas.Codcta cb-ctas.nomcta

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-add

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES cb-ctas

/* Definitions for FRAME F-maestro                                      */
&Scoped-define FIELDS-IN-QUERY-F-maestro cb-ctas.Codcta cb-ctas.Nomcta ~
cb-ctas.chqIni cb-ctas.nrochq cb-ctas.codbco cb-ctas.nrocta cb-ctas.Codmon ~
cb-ctas.sector cb-ctas.activo cb-ctas.chqFin 
&Scoped-define ENABLED-FIELDS-IN-QUERY-F-maestro cb-ctas.Codcta ~
cb-ctas.Nomcta cb-ctas.chqIni cb-ctas.nrochq cb-ctas.codbco cb-ctas.nrocta ~
cb-ctas.Codmon cb-ctas.sector cb-ctas.activo cb-ctas.chqFin 
&Scoped-define ENABLED-TABLES-IN-QUERY-F-maestro cb-ctas
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-F-maestro cb-ctas

&Scoped-define FIELD-PAIRS-IN-QUERY-F-maestro~
 ~{&FP1}Codcta ~{&FP2}Codcta ~{&FP3}~
 ~{&FP1}Nomcta ~{&FP2}Nomcta ~{&FP3}~
 ~{&FP1}chqIni ~{&FP2}chqIni ~{&FP3}~
 ~{&FP1}nrochq ~{&FP2}nrochq ~{&FP3}~
 ~{&FP1}codbco ~{&FP2}codbco ~{&FP3}~
 ~{&FP1}nrocta ~{&FP2}nrocta ~{&FP3}~
 ~{&FP1}sector ~{&FP2}sector ~{&FP3}~
 ~{&FP1}activo ~{&FP2}activo ~{&FP3}~
 ~{&FP1}chqFin ~{&FP2}chqFin ~{&FP3}
&Scoped-define OPEN-QUERY-F-maestro OPEN QUERY F-maestro FOR EACH cb-ctas ~
      WHERE cb-ctas.CodCia = y-codcia ~
 AND LENGTH(integral.cb-ctas.Codcta) = x-Maxnivel AND ~
 ( cb-ctas.Codcta BEGINS cb-cfga.ctacredito OR ~
  cb-ctas.Codcta BEGINS cb-cfga.ctaahorro ) SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-F-maestro cb-ctas
&Scoped-define FIRST-TABLE-IN-QUERY-F-maestro cb-ctas


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS R-navigaate-2 B-ok B-Cancel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-maestro AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-Cancel 
     LABEL "&Cancelar":L 
     SIZE 9 BY 1
     FONT 4.

DEFINE BUTTON B-ok 
     LABEL "&Aceptar":L 
     SIZE 9 BY 1
     FONT 4.

DEFINE RECTANGLE R-navigaate-2
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 90.57 BY 2
     BGCOLOR 8 FGCOLOR 15 .

DEFINE BUTTON B-add 
     LABEL "&Crear":L 
     SIZE 1 BY 1
     FONT 4.

DEFINE BUTTON B-browse 
     IMAGE-UP FILE "IMG/pvbrow":U
     IMAGE-DOWN FILE "IMG/pvbrowd":U
     IMAGE-INSENSITIVE FILE "IMG/pvbrowx":U
     LABEL "&Consulta" 
     SIZE 5.72 BY 1.5.

DEFINE BUTTON B-delete 
     LABEL "&Eliminar":L 
     SIZE 1.57 BY 1
     FONT 4.

DEFINE BUTTON B-exit 
     LABEL "&Salir":L 
     SIZE 7 BY 1
     FONT 4.

DEFINE BUTTON B-first 
     IMAGE-UP FILE "IMG/pvfirst":U
     IMAGE-DOWN FILE "IMG/pvfirstd":U
     IMAGE-INSENSITIVE FILE "IMG/pvfirstx":U
     LABEL "<<":L 
     SIZE 5 BY 1
     FONT 4.

DEFINE BUTTON B-last 
     IMAGE-UP FILE "IMG/pvlast":U
     IMAGE-DOWN FILE "IMG/pvlastd":U
     IMAGE-INSENSITIVE FILE "IMG/pvlastx":U
     LABEL ">>":L 
     SIZE 4.57 BY 1
     FONT 4.

DEFINE BUTTON B-next 
     IMAGE-UP FILE "IMG/pvforw":U
     IMAGE-DOWN FILE "IMG/pvforwd":U
     IMAGE-INSENSITIVE FILE "IMG/pvforwx":U
     LABEL ">":L 
     SIZE 5 BY 1
     FONT 4.

DEFINE BUTTON B-prev 
     IMAGE-UP FILE "IMG/pvback":U
     IMAGE-DOWN FILE "IMG/pvbackd":U
     IMAGE-INSENSITIVE FILE "IMG/pvbackx":U
     LABEL "<":L 
     SIZE 5 BY 1
     FONT 4.

DEFINE BUTTON B-query 
     LABEL "&Buscar":L 
     SIZE 7.57 BY 1
     FONT 4.

DEFINE BUTTON B-update 
     LABEL "&Modificar":L 
     SIZE 1.72 BY 1
     FONT 4.

DEFINE RECTANGLE R-consulta
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8.43 BY 2
     BGCOLOR 8 .

DEFINE RECTANGLE R-exit
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 9.57 BY 2
     BGCOLOR 8 FGCOLOR 15 .

DEFINE RECTANGLE R-modify
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 4 BY .96
     BGCOLOR 8 FGCOLOR 15 .

DEFINE RECTANGLE R-navigaate
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 21.14 BY 2
     BGCOLOR 8 FGCOLOR 15 .

DEFINE RECTANGLE R-query
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 40 BY 2
     BGCOLOR 8 FGCOLOR 15 .

DEFINE VARIABLE x-nombco AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE R-maestro1
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 79.43 BY 2.65
     BGCOLOR 8 FGCOLOR 15 .

DEFINE RECTANGLE R-maestro2
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 79.43 BY 7
     BGCOLOR 8 FGCOLOR 15 .

DEFINE BUTTON B-Cancel-3 
     LABEL "&Cancelar":L 
     SIZE 9 BY 1
     FONT 4.

DEFINE BUTTON B-ok-3 AUTO-GO 
     LABEL "&Aceptar":L 
     SIZE 9 BY 1
     FONT 4.

DEFINE RECTANGLE R-navigaate-4
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 90.57 BY 2
     BGCOLOR 8 FGCOLOR 15 .

DEFINE BUTTON B-Cancel-2 
     LABEL "&Cancelar":L 
     SIZE 9 BY 1
     FONT 4.

DEFINE BUTTON B-ok-2 
     LABEL "&Aceptar":L 
     SIZE 9 BY 1
     FONT 4.

DEFINE RECTANGLE R-navigaate-3
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 90.57 BY 2
     BGCOLOR 8 FGCOLOR 15 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY F-maestro FOR 
      cb-ctas SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-maestro
     cb-ctas.Codcta AT ROW 1.5 COL 19.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
          BGCOLOR 15 
     cb-ctas.Nomcta AT ROW 2.35 COL 19.57 COLON-ALIGNED
          LABEL "Descripci¢n" FORMAT "x(64)"
          VIEW-AS FILL-IN 
          SIZE 51.43 BY .81
          BGCOLOR 15 
     cb-ctas.chqIni AT ROW 3.85 COL 19.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .81
          BGCOLOR 15 FGCOLOR 0 
     cb-ctas.nrochq AT ROW 4.77 COL 19.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .81
          BGCOLOR 15 
     cb-ctas.codbco AT ROW 5.65 COL 19.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
          BGCOLOR 15 
     cb-ctas.nrocta AT ROW 6.54 COL 19.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .81
          BGCOLOR 15 
     cb-ctas.Codmon AT ROW 7.46 COL 21.57 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Soles", 1,
"Dolares", 2
          SIZE 21 BY .81
     cb-ctas.sector AT ROW 8.42 COL 19.86 COLON-ALIGNED
          LABEL "Firma Cheque" FORMAT "X(256)"
          VIEW-AS FILL-IN 
          SIZE 51.14 BY .81
          BGCOLOR 15 
     cb-ctas.activo AT ROW 9.38 COL 19.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .81
          BGCOLOR 15 
     x-nombco AT ROW 5.65 COL 25 COLON-ALIGNED NO-LABEL
     cb-ctas.chqFin AT ROW 3.85 COL 45.72 COLON-ALIGNED
          LABEL "Hasta Nro."
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .81
          BGCOLOR 15 
     R-maestro2 AT ROW 3.54 COL 1
     "Moneda:" VIEW-AS TEXT
          SIZE 8.29 BY .5 AT ROW 7.5 COL 12.43
     R-maestro1 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 1
         SIZE 87.43 BY 9.77
         BGCOLOR 8 FGCOLOR 0 FONT 4.

DEFINE FRAME F-add
     B-ok AT ROW 1.5 COL 24.29
     B-Cancel AT ROW 1.5 COL 57.57
     R-navigaate-2 AT ROW 1 COL 1
    WITH 1 DOWN OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 10.61
         SIZE 90.86 BY 2.08
         BGCOLOR 8 FGCOLOR 0 
         CANCEL-BUTTON B-Cancel.

DEFINE FRAME F-update
     B-ok-2 AT ROW 1.5 COL 24.29
     B-Cancel-2 AT ROW 1.5 COL 57.57
     R-navigaate-3 AT ROW 1 COL 1
    WITH 1 DOWN OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 10.61
         SIZE 90.86 BY 2.08
         BGCOLOR 8 FGCOLOR 0 .

DEFINE FRAME F-search
     B-ok-3 AT ROW 1.54 COL 24.29
     B-Cancel-3 AT ROW 1.54 COL 57.57
     R-navigaate-4 AT ROW 1 COL 1
    WITH 1 DOWN OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 10.61
         SIZE 90.86 BY 2.08
         BGCOLOR 8 FGCOLOR 0 .

DEFINE FRAME F-ctrl-frame
     B-query AT ROW 1.46 COL 2
     B-update AT ROW 1.46 COL 21.14
     B-delete AT ROW 1.46 COL 30.29
     B-add AT ROW 1.58 COL 36
     B-first AT ROW 1.46 COL 41.72
     B-prev AT ROW 1.46 COL 46.57
     B-next AT ROW 1.46 COL 51.57
     B-last AT ROW 1.46 COL 56.29
     B-browse AT ROW 1.31 COL 63
     B-exit AT ROW 1.46 COL 71.72
     R-query AT ROW 1 COL 1
     R-modify AT ROW 1.58 COL 32
     R-navigaate AT ROW 1 COL 40.72
     R-consulta AT ROW 1 COL 61.86
     R-exit AT ROW 1 COL 70.43
    WITH 1 DOWN OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 10.62
         SIZE 90.86 BY 2.08
         BGCOLOR 8 FGCOLOR 0 FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: WINDOW
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-maestro ASSIGN
         HIDDEN             = YES
         TITLE              = "Cuentas de Caja y Bancos"
         COLUMN             = 24
         ROW                = 6.08
         HEIGHT             = 11.85
         WIDTH              = 79.43
         MAX-HEIGHT         = 15.69
         MAX-WIDTH          = 90.86
         VIRTUAL-HEIGHT     = 15.69
         VIRTUAL-WIDTH      = 90.86
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

IF NOT W-maestro:LOAD-ICON("IMG/valmiesa":U) THEN
    MESSAGE "Unable to load icon: IMG/valmiesa"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
/* END WINDOW DEFINITION                                                */
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
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       B-add:HIDDEN IN FRAME F-ctrl-frame           = TRUE.

/* SETTINGS FOR BUTTON B-delete IN FRAME F-ctrl-frame
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       B-delete:HIDDEN IN FRAME F-ctrl-frame           = TRUE.

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
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       B-query:HIDDEN IN FRAME F-ctrl-frame           = TRUE.

/* SETTINGS FOR BUTTON B-update IN FRAME F-ctrl-frame
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       B-update:HIDDEN IN FRAME F-ctrl-frame           = TRUE.

/* SETTINGS FOR RECTANGLE R-modify IN FRAME F-ctrl-frame
   NO-ENABLE                                                            */
ASSIGN 
       R-modify:HIDDEN IN FRAME F-ctrl-frame           = TRUE.

/* SETTINGS FOR FRAME F-maestro
   UNDERLINE                                                            */
/* SETTINGS FOR FILL-IN cb-ctas.chqFin IN FRAME F-maestro
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cb-ctas.Nomcta IN FRAME F-maestro
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN cb-ctas.sector IN FRAME F-maestro
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN x-nombco IN FRAME F-maestro
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
     _TblList          = "integral.cb-ctas"
     _Where[1]         = "integral.cb-ctas.CodCia = y-codcia
 AND LENGTH(integral.cb-ctas.Codcta) = x-Maxnivel AND
 ( integral.cb-ctas.Codcta BEGINS integral.cb-cfga.ctacredito OR
  integral.cb-ctas.Codcta BEGINS integral.cb-cfga.ctaahorro )"
     _Query            is OPENED
*/  /* FRAME F-maestro */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define FRAME-NAME F-ctrl-frame
&Scoped-define SELF-NAME B-add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-add W-maestro
ON CHOOSE OF B-add IN FRAME F-ctrl-frame /* Crear */
DO:
    RECID-Tmp = RECID( {&FIRST-TABLE-IN-QUERY-F-maestro} ).
    FRAME F-ctrl-frame:VISIBLE = FALSE.
    DO TRANSACTION ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        FIND {&FIRST-TABLE-IN-QUERY-F-maestro}
            WHERE RECID-Tmp = RECID( {&FIRST-TABLE-IN-QUERY-F-maestro} )
            EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN DO:
            IF integral.cb-ctas.activo THEN DO:
                MESSAGE  "Registros Activo." VIEW-AS ALERT-BOX ERROR
                BUTTONS OK.
                UNDO , LEAVE.
            END.
            MESSAGE "Activar el Registro"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE selection AS LOGICAL.
            IF selection THEN DO:
               ASSIGN integral.cb-ctas.activo = TRUE.
               DISPLAY integral.cb-ctas.activo WITH FRAME F-Maestro.
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
        IF AVAIL  {&FIRST-TABLE-IN-QUERY-F-maestro} THEN RUN Pintado.
        ELSE CLEAR FRAME F-maestro.
    END.
    FRAME F-ctrl-frame:VISIBLE = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-browse W-maestro
ON CHOOSE OF B-browse IN FRAME F-ctrl-frame /* Consulta */
DO:
    RUN {&q-modelo} .
    IF RECID-stack <> 0
    THEN DO:
        FIND {&TABLES-IN-QUERY-F-maestro}
             WHERE RECID( {&TABLES-IN-QUERY-F-maestro} ) = RECID-stack
              NO-LOCK  NO-ERROR.
         IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN RUN Pintado.
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
         IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN RUN Pintado.
         ELSE CLEAR FRAME F-maestro.
         RECID-stack = ?.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-update
&Scoped-define SELF-NAME B-Cancel-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Cancel-2 W-maestro
ON CHOOSE OF B-Cancel-2 IN FRAME F-update /* Cancelar */
DO:
    RECID-stack = ?. 
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
     IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN  RUN Pintado.
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
            IF NOT ( integral.cb-ctas.codcta:SCREEN-VALUE IN FRAME F-maestro BEGINS x-ctacre OR
                   integral.cb-ctas.codcta:SCREEN-VALUE IN FRAME F-maestro BEGINS x-ctaaho ) 
            THEN DO:
               MESSAGE "C¢digos de cuentas no v lidos, deben ser:" SKIP
                 x-ctacre + " / " + x-ctaaho VIEW-AS ALERT-BOX ERROR
               BUTTONS OK.
               UNDO , LEAVE.
            END.  
            IF NOT integral.cb-ctas.activo THEN DO:
                MESSAGE  "Registros Inactivo." VIEW-AS ALERT-BOX ERROR
                BUTTONS OK.
                UNDO , LEAVE.
            END.
            MESSAGE "Inactivar el Registro"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE selection AS LOGICAL.
            IF selection THEN DO:
               ASSIGN integral.cb-ctas.activo = FALSE.
               DISPLAY integral.cb-ctas.activo WITH FRAME F-Maestro.
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
        IF AVAIL  {&FIRST-TABLE-IN-QUERY-F-maestro} THEN RUN Pintado.
        ELSE CLEAR FRAME F-maestro.
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

     IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN RUN Pintado.
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
     
     IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN RUN Pintado.
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
     IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN RUN Pintado.
     ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
             BUTTONS OK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-update
&Scoped-define SELF-NAME B-ok-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-ok-2 W-maestro
ON CHOOSE OF B-ok-2 IN FRAME F-update /* Aceptar */
DO:
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
    IF cb-ctas.codcta:SCREEN-VALUE IN FRAME F-maestro <> "" THEN DO:
         FIND FIRST  {&FIRST-TABLE-IN-QUERY-F-maestro}
              WHERE 
                  &IF "{&RECORD-SCOPE}" <> "" &THEN
                      {&RECORD-SCOPE} AND
                  &ENDIF
                  cb-ctas.codcta = cb-ctas.codcta:SCREEN-VALUE IN FRAME F-maestro
                   NO-LOCK NO-ERROR.
         ASSIGN integral.cb-ctas.Nomcta:SCREEN-VALUE = "".
    END.

    IF integral.cb-ctas.Nomcta:SCREEN-VALUE IN FRAME F-maestro <> "" THEN DO:
         FIND FIRST  {&FIRST-TABLE-IN-QUERY-F-maestro}
              WHERE 
                  &IF "{&RECORD-SCOPE}" <> "" &THEN
                      {&RECORD-SCOPE} AND
                  &ENDIF
                  integral.cb-ctas.Nomcta BEGINS integral.cb-ctas.Nomcta:SCREEN-VALUE IN FRAME F-maestro
                   NO-LOCK NO-ERROR.
         ASSIGN integral.cb-ctas.codcta:SCREEN-VALUE = "".
    END.
   
     IF NOT AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN DO:
         APPLY "CHOOSE" TO B-Browse IN FRAME F-ctrl-frame.
        IF RECID-stack <> 0
        THEN RETURN.
     END.
         
     IF NOT AVAIL  {&FIRST-TABLE-IN-QUERY-F-maestro}  THEN DO:
         FIND FIRST  {&FIRST-TABLE-IN-QUERY-F-maestro}
         &IF "{&RECORD-SCOPE}" <> "" &THEN
              WHERE {&RECORD-SCOPE}
          &ENDIF  
          NO-LOCK NO-ERROR.
     END.
     
      IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN  RUN Pintado.
      ELSE DO:
           CLEAR FRAME F-maestro.
           MESSAGE  "Registro no Existente." VIEW-AS ALERT-BOX ERROR BUTTONS OK. 
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
     IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN RUN Pintado.
     ELSE MESSAGE "No Existen Registros" VIEW-AS ALERT-BOX ERROR
             BUTTONS OK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-query
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-query W-maestro
ON CHOOSE OF B-query IN FRAME F-ctrl-frame /* Buscar */
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
END.

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
    IF NOT integral.cb-ctas.activo THEN DO:
        MESSAGE  "Registros Inactivo." VIEW-AS ALERT-BOX ERROR
        BUTTONS OK.
        RETURN.
    END.
    IF NOT ( integral.cb-ctas.codcta:SCREEN-VALUE IN FRAME F-maestro BEGINS x-ctacre OR
        integral.cb-ctas.codcta:SCREEN-VALUE IN FRAME F-maestro BEGINS x-ctaaho ) 
        THEN DO:
           MESSAGE "C¢digos de cuentas no v lidos, deben ser:" SKIP
            x-ctacre + " / " + x-ctaaho VIEW-AS ALERT-BOX ERROR
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
            /*
            IF LAST-EVENT:FUNCTION = "END-ERROR" OR
               RECID-stack = ?
          THEN UNDO, LEAVE.
          */
        END.
        ELSE MESSAGE "Registros no existente." VIEW-AS ALERT-BOX ERROR
            BUTTONS OK.
    END.
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
    IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN RUN Pintado.
    ELSE CLEAR FRAME F-maestro.
    DISABLE {&FIELDS-IN-QUERY-F-maestro} WITH FRAME F-maestro.
    FRAME f-update:VISIBLE = FALSE.
    FRAME F-ctrl-frame:VISIBLE = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-maestro
&Scoped-define SELF-NAME cb-ctas.codbco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ctas.codbco W-maestro
ON LEAVE OF cb-ctas.codbco IN FRAME F-maestro /* Banco */
DO:
IF LOOKUP (LAST-EVENT:FUNCTION,"ENDKEY,ERROR,END-ERROR") <> 0 THEN RETURN.
    FIND integral.cb-tabl WHERE integral.cb-tabl.tabla = x-tabla AND
        integral.cb-tabl.codigo = integral.cb-ctas.codbco:SCREEN-VALUE
             NO-LOCK  NO-ERROR.
    IF NOT AVAIL integral.cb-tabl THEN DO:
        MESSAGE "C¢digo de banco no existente." VIEW-AS ALERT-BOX ERROR.
  
    END. 
    x-nombco:SCREEN-VALUE = integral.cb-tabl.Nombre. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ctas.codbco W-maestro
ON MOUSE-SELECT-DBLCLICK OF cb-ctas.codbco IN FRAME F-maestro /* Banco */
OR "F8":U OF CB-CTAS.CODBCO DO:
    RECID-stack = 0.
    RUN cbd/q-tabla.w ( x-tabla, OUTPUT RECID-stack  ).
    IF RECID-stack <> 0
    THEN DO:
        FIND integral.cb-tabl
             WHERE RECID( integral.cb-tabl ) = RECID-stack
              NO-LOCK  NO-ERROR.
         IF AVAIL integral.cb-tabl THEN DO:
             x-nombco = integral.cb-tabl.nombre.
             DISPLAY x-nombco WITH FRAME f-Maestro.
             DISPLAY integral.cb-tabl.codigo @ integral.cb-ctas.codbco
                 WITH FRAME F-maestro.
         END.
         ELSE MESSAGE "No existe Registro de bancos" VIEW-AS ALERT-BOX ERROR
         BUTTONS OK.
   END. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ctas.Codcta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ctas.Codcta W-maestro
ON LEAVE OF cb-ctas.Codcta IN FRAME F-maestro /* Cuenta */
DO:
    IF LOOKUP (LAST-EVENT:FUNCTION,"ENDKEY,ERROR,END-ERROR") <> 0 THEN RETURN.
    IF NOT ( integral.cb-ctas.codcta:SCREEN-VALUE IN FRAME F-maestro BEGINS x-ctacre OR
             integral.cb-ctas.codcta:SCREEN-VALUE IN FRAME F-maestro BEGINS x-ctaaho ) 
    THEN DO:
        MESSAGE "C¢digos de cuentas no v lidos, deben ser:" SKIP
                x-ctacre + " / " + x-ctaaho
                VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO integral.cb-ctas.codcta.
        RETURN NO-APPLY.
    END.  
    FIND integral.cb-ctas WHERE integral.cb-ctas.codcia = s-codcia AND
        integral.cb-ctas.codcta = integral.cb-ctas.codcta:SCREEN-VALUE
             NO-LOCK  NO-ERROR.
    IF NOT AVAIL integral.cb-ctas THEN DO:
        MESSAGE "Nro.de cuenta no existente." VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO integral.cb-ctas.codcta.
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
ASSIGN CURRENT-WINDOW             = {&WINDOW-NAME}
       SESSION:SYSTEM-ALERT-BOXES = (CURRENT-WINDOW:MESSAGE-AREA = NO).
 
ON CLOSE OF THIS-PROCEDURE
      RUN disable_UI.
        
ON "WINDOW-CLOSE" OF {&WINDOW-NAME}  DO:
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

ON END OF  B-query, B-add, B-update, B-delete, 
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
    IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN RUN Pintado.
    ELSE CLEAR FRAME F-maestro. 

    DISABLE {&FIELDS-IN-QUERY-F-maestro} WITH FRAME F-maestro.     
    integral.cb-ctas.activo:SENSITIVE = FALSE.
    IF NOT THIS-PROCEDURE:PERSISTENT THEN    
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
    
END. /*main-block*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-maestro _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-maestro)
  THEN DELETE WIDGET W-maestro.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-maestro _DEFAULT-ENABLE
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

  {&OPEN-QUERY-F-maestro}
  GET FIRST F-maestro.
  DISPLAY x-nombco 
      WITH FRAME F-maestro IN WINDOW W-maestro.
  IF AVAILABLE cb-ctas THEN 
    DISPLAY cb-ctas.Codcta cb-ctas.Nomcta cb-ctas.chqIni cb-ctas.nrochq 
          cb-ctas.codbco cb-ctas.nrocta cb-ctas.Codmon cb-ctas.sector 
          cb-ctas.activo cb-ctas.chqFin 
      WITH FRAME F-maestro IN WINDOW W-maestro.
  ENABLE R-maestro2 R-maestro1 cb-ctas.Codcta cb-ctas.Nomcta cb-ctas.chqIni 
         cb-ctas.nrochq cb-ctas.codbco cb-ctas.nrocta cb-ctas.Codmon 
         cb-ctas.sector cb-ctas.activo cb-ctas.chqFin 
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
  ENABLE R-query R-navigaate R-consulta R-exit B-first B-prev B-next B-last 
         B-browse B-exit 
      WITH FRAME F-ctrl-frame IN WINDOW W-maestro.
  {&OPEN-BROWSERS-IN-QUERY-F-ctrl-frame}
  VIEW W-maestro.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pintado W-maestro 
PROCEDURE pintado :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/

    DISPLAY {&FIELDS-IN-QUERY-F-maestro} WITH FRAME F-maestro.
    {&OPEN-BROWSERS-IN-QUERY-F-maestro}
    x-nombco = "".
    FIND integral.cb-tabl WHERE integral.cb-tabl.tabla = x-tabla AND
         integral.cb-tabl.codigo = INPUT FRAME f-Maestro integral.cb-ctas.codbco
         NO-LOCK NO-ERROR.
    IF AVAIL integral.cb-tabl THEN x-nombco = integral.cb-tabl.nombre.
    DISPLAY x-nombco WITH FRAME f-Maestro.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


