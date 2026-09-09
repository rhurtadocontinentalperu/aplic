&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral          PROGRESS
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
DEFINE {&NEW} SHARED VARIABLE s-codcia       AS INTEGER INITIAL 1.
DEFINE {&NEW} SHARED VARIABLE cb-niveles AS CHARACTER INITIAL "2,3,5".
DEFINE VARIABLE cb-codcia                   AS INTEGER INITIAL 0.

FIND Empresas WHERE Empresas.CodCia = s-codcia.
IF NOT Empresas.Campo-CodCbd THEN cb-codcia = s-codcia.

/* Buscamos las configuraciones del Sistema Contable */
FIND cb-cfga WHERE cb-cfga.CodCia = cb-codcia
               AND cb-cfga.CodCfg = 1 NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-cfga
THEN DO:
    BELL.
    MESSAGE "NO SE HA CONFIGURADO EL SISTEMA CONTABLE"
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

/* Definimos variables para la consistencia de cuentas */
DEFINE VARIABLE x-MaxNiv    AS INTEGER.
DEFINE VARIABLE x-CodCta    LIKE cb-ctas.CodCta.
DEFINE VARIABLE nivel       AS INTEGER.
DEFINE VARIABLE i           AS INTEGER.
DEFINE VARIABLE x-Ctas9     AS LOGICAL.
DEFINE VARIABLE x-Ctas6     AS LOGICAL.
DEFINE VARIABLE x-Ctas0     AS LOGICAL.

DEFINE VARIABLE Cbd-CodDiv  AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE x-leave     AS LOGICAL INITIAL YES.
DEFINE VARIABLE RECID-stack AS RECID NO-UNDO.
DEFINE VARIABLE RECID-tmp   AS RECID NO-UNDO.
DEFINE VARIABLE ROWID-STACK AS ROWID NO-UNDO.
DEFINE VARIABLE pto         AS LOGICAL.

x-MaxNiv = INTEGER( ENTRY ( NUM-ENTRIES ( cb-niveles ), cb-niveles ) ).
pto      = SESSION:SET-WAIT-STATE("").

IF cb-cfga.coddiv THEN CBD-coddiv = YES.

/*   C A M B I O S   E N    L O S   P R E - P R O C E S A D O R E S */

/* Solo muestra los registros que cumplan con la condici¢n : */
&Scoped-define RECORD-SCOPE cb-ctas.CodCia = cb-codcia

/* Como Buscar un Registro en la Tabla ( Para Crear, modificar, anular etc.) */
 &Scoped-define SEARCH-KEY cb-ctas.CodCta = cb-ctas.CodCta:SCREEN-VALUE IN FRAME F-maestro

/* Campos Ocultos que deben ser asignados en cada modificaci¢n */
&Scoped-define ASSIGN-ADD cb-ctas.CodCia = cb-codcia

/* Campos que no pueden ser modificados */
&Scoped-define NO-MODIFY cb-ctas.CodCta

/* Programa donde relaizara la Consulta de cuentas*/
&Scoped-define q-modelo cbd/q-cuenta.w ( cb-codcia, OUTPUT RECID-stack )

/* Se relaizara la Consulta de clasificacion de auxiliar*/
&Scoped-define q-modelo2 cbd/q-clfaux.w ( "01", OUTPUT RECID-stack )

/* Se relaizara la Consulta de codigo de documento*/
&Scoped-define q-modelo3 cbd/q-clfaux.w ( "02", OUTPUT RECID-stack )

/* Se relaizara la Consulta de tipos de gasto*/
&Scoped-define q-modelo4 cbd/q-auxil.w ( cb-codcia, "04", OUTPUT RECID-stack )

/* Se realizara la consulta de divisionaria*/
&Scoped-define q-modelo5 cbd/q-auxil.w ( cb-codcia, "00", OUTPUT RECID-stack )

/* Se realizara la consulta de cuenta automatica*/
&Scoped-define q-modelo6 cbd/q-ctas2.w ( cb-codcia, cb-ctas.An1Cta:SCREEN-VALUE, OUTPUT RECID-stack )

/* Se realizara la consulta de cuenta automatica*/
&Scoped-define q-modelo7 cbd/q-ctas2.w ( cb-codcia, cb-ctas.Cc1Cta:SCREEN-VALUE, OUTPUT RECID-stack )

/* Campos por los cuales se puede hacer Busquedas */
&Scoped-define Query-Field cb-ctas.CodCta cb-ctas.Nomcta

/* Campos que se editan solo para cuentas de ultimo nivel */
&Scoped-define FIELDS-update cb-ctas.PidAux ~
                             cb-ctas.ClfAux ~
                             cb-ctas.PidDoc ~
                             cb-ctas.Coddoc ~
                             cb-ctas.PidRef ~
                             cb-ctas.AftDcb ~
                             cb-ctas.Tpocmb ~
                             cb-ctas.CieRes ~
                             cb-ctas.pidcco ~
                             cb-ctas.An1Cta ~
                             cb-ctas.Cc1Cta ~
                             cb-ctas.TpoGto ~
                             cb-ctas.vCodCia ~
                             cb-ctas.Coddiv

/* Campos que se editan para cualquier cuenta */
&Scoped-define FIELD-update cb-ctas.Codcta cb-ctas.Codmon cb-ctas.Nomcta

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
cb-ctas.PidAux cb-ctas.PidDoc cb-ctas.PidRef cb-ctas.AftDcb cb-ctas.pidcco ~
cb-ctas.CieRes cb-ctas.An1cta cb-ctas.Cc1cta cb-ctas.ClfAux cb-ctas.Coddoc ~
cb-ctas.Tpocmb cb-ctas.Codmon cb-ctas.Tpogto cb-ctas.vcodcia 
&Scoped-define ENABLED-FIELDS-IN-QUERY-F-maestro cb-ctas.Codcta ~
cb-ctas.Nomcta cb-ctas.PidAux cb-ctas.PidDoc cb-ctas.PidRef cb-ctas.AftDcb ~
cb-ctas.pidcco cb-ctas.CieRes cb-ctas.An1cta cb-ctas.Cc1cta cb-ctas.ClfAux ~
cb-ctas.Coddoc cb-ctas.Tpocmb cb-ctas.Codmon cb-ctas.Tpogto cb-ctas.CodDiv ~
&Scoped-define ENABLED-TABLES-IN-QUERY-F-maestro cb-ctas
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-F-maestro cb-ctas

&Scoped-define FIELD-PAIRS-IN-QUERY-F-maestro~
 ~{&FP1}Codcta ~{&FP2}Codcta ~{&FP3}~
 ~{&FP1}Nomcta ~{&FP2}Nomcta ~{&FP3}~
 ~{&FP1}An1cta ~{&FP2}An1cta ~{&FP3}~
 ~{&FP1}Cc1cta ~{&FP2}Cc1cta ~{&FP3}~
 ~{&FP1}ClfAux ~{&FP2}ClfAux ~{&FP3}~
 ~{&FP1}Coddoc ~{&FP2}Coddoc ~{&FP3}~
 ~{&FP1}Tpogto ~{&FP2}Tpogto ~{&FP3}~
 ~{&FP1}CodDiv ~{&FP2}CodDiv ~{&FP3}~
 ~{&FP1}vcodcia ~{&FP2}vcodcia ~{&FP3}
&Scoped-define OPEN-QUERY-F-maestro OPEN QUERY F-maestro FOR EACH cb-ctas SHARE-LOCK.
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
DEFINE BUTTON B-Cancel AUTO-END-KEY 
     LABEL "&Cancelar":L 
     SIZE 9 BY 1
     FONT 4.

DEFINE BUTTON B-ok 
     LABEL "&Aceptar":L 
     SIZE 9 BY 1
     FONT 4.

DEFINE RECTANGLE R-navigaate-2
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 88 BY 2
     BGCOLOR 8 FGCOLOR 15 .

DEFINE BUTTON B-add 
     LABEL "&Crear":L 
     SIZE 9 BY 1
     FONT 4.

DEFINE BUTTON B-browse 
     IMAGE-UP FILE "IMG/pvbrow":U
     IMAGE-DOWN FILE "IMG/pvbrowd":U
     IMAGE-INSENSITIVE FILE "IMG/pvbrowx":U
     LABEL "&Consulta" 
     SIZE 5.72 BY 1.5.

DEFINE BUTTON B-delete 
     LABEL "&Eliminar":L 
     SIZE 9 BY 1
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
     SIZE 9 BY 1
     FONT 4.

DEFINE RECTANGLE R-consulta
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 10 BY 2
     BGCOLOR 8 .

DEFINE RECTANGLE R-exit
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 10.29 BY 2
     BGCOLOR 8 FGCOLOR 15 .

DEFINE RECTANGLE R-modify
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 33 BY 2
     BGCOLOR 8 FGCOLOR 15 .

DEFINE RECTANGLE R-navigaate
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 23.72 BY 2
     BGCOLOR 8 FGCOLOR 15 .

DEFINE RECTANGLE R-query
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 10 BY 2
     BGCOLOR 8 FGCOLOR 15 .

DEFINE RECTANGLE R-maestro1
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 86.86 BY 3
     BGCOLOR 8 FGCOLOR 15 .

DEFINE RECTANGLE R-maestro2
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 86.86 BY 9.54
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
     SIZE 88.14 BY 2
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
     SIZE 88.14 BY 2
     BGCOLOR 8 FGCOLOR 15 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY F-maestro FOR 
      cb-ctas SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-maestro
     cb-ctas.Codcta AT ROW 1.62 COL 10.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 15 
     cb-ctas.Nomcta AT ROW 2.58 COL 10.43 COLON-ALIGNED
          LABEL "Descripci¢n"
          VIEW-AS FILL-IN 
          SIZE 45 BY .81
          BGCOLOR 15 
     cb-ctas.PidAux AT ROW 4.69 COL 19
          LABEL "Requiere C¢digo Auxiliar"
          VIEW-AS TOGGLE-BOX
          SIZE 23.72 BY .65
     cb-ctas.PidDoc AT ROW 5.77 COL 19
          VIEW-AS TOGGLE-BOX
          SIZE 29.72 BY .65
     cb-ctas.PidRef AT ROW 6.85 COL 19
          VIEW-AS TOGGLE-BOX
          SIZE 32.86 BY .65
     cb-ctas.AftDcb AT ROW 7.92 COL 19
          LABEL "Afecta diferencia de Cambio / Traslación"
          VIEW-AS TOGGLE-BOX
          SIZE 31.43 BY .65
     cb-ctas.pidcco AT ROW 9 COL 19
          LABEL "Requiere Centro de Costo"
          VIEW-AS TOGGLE-BOX
          SIZE 24 BY .77
     cb-ctas.CieRes AT ROW 10.08 COL 19
          VIEW-AS TOGGLE-BOX
          SIZE 22.14 BY .65
     cb-ctas.An1cta AT ROW 10.88 COL 33 COLON-ALIGNED
          LABEL "Cuenta Autom tica"
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .81
          BGCOLOR 15 
     cb-ctas.Cc1cta AT ROW 11.96 COL 33 COLON-ALIGNED
          LABEL "Contra Cuenta Autom tica"
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .81
          BGCOLOR 15 
     cb-ctas.ClfAux AT ROW 4.69 COL 61 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
          BGCOLOR 15 
     cb-ctas.Coddoc AT ROW 5.77 COL 61 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
          BGCOLOR 15 
     cb-ctas.Tpocmb AT ROW 7.92 COL 62.86 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Compra", 1,
"Venta", 2,
"Segun el Saldo", 3
          SIZE 16 BY 2
     cb-ctas.Codmon AT ROW 1.5 COL 68.29 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Soles", 1,
"Dolares", 2,
"Soles o Dolares", 3
          SIZE 17 BY 2
          BGCOLOR 8 
     cb-ctas.Tpogto AT ROW 10.35 COL 71 COLON-ALIGNED
          LABEL "Tipo de Gasto"
          VIEW-AS FILL-IN 
          SIZE 4 BY .81
          BGCOLOR 15 
     cb-ctas.CodDiv AT ROW 11.15 COL 71 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .81
          BGCOLOR 15 
     cb-ctas.vcodcia AT ROW 11.96 COL 71 COLON-ALIGNED
          LABEL "Visible para la Cia"
          VIEW-AS FILL-IN 
          SIZE 8 BY .81
          BGCOLOR 15 
     R-maestro1 AT ROW 1 COL 1
     R-maestro2 AT ROW 3.96 COL 1
     "Cambio:" VIEW-AS TEXT
          SIZE 7 BY 1 AT ROW 7.73 COL 54.72
     "Moneda:" VIEW-AS TEXT
          SIZE 8 BY 1 AT ROW 1.38 COL 59.14
    WITH 1 DOWN NO-BOX OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 1
         SIZE 87.72 BY 12.5
         BGCOLOR 8 FGCOLOR 0 FONT 4.

DEFINE FRAME F-add
     B-ok AT ROW 1.5 COL 24.29
     B-Cancel AT ROW 1.5 COL 57.57
     R-navigaate-2 AT ROW 1 COL 1
    WITH 1 DOWN OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 13.62
         SIZE 88.29 BY 2.08
         BGCOLOR 8 FGCOLOR 0 FONT 4
         CANCEL-BUTTON B-Cancel.

DEFINE FRAME F-update
     B-ok-2 AT ROW 1.5 COL 24.29
     B-Cancel-2 AT ROW 1.5 COL 57.57
     R-navigaate-3 AT ROW 1 COL 1
    WITH 1 DOWN OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 13.62
         SIZE 88.43 BY 2.08
         BGCOLOR 8 FGCOLOR 0 FONT 4.

DEFINE FRAME F-search
     B-ok-3 AT ROW 1.54 COL 24.29
     B-Cancel-3 AT ROW 1.54 COL 57.57
     R-navigaate-4 AT ROW 1 COL 1
    WITH 1 DOWN OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 13.62
         SIZE 88.43 BY 2.08
         BGCOLOR 8 FGCOLOR 0 FONT 4.

DEFINE FRAME F-ctrl-frame
     B-query AT ROW 1.5 COL 2
     B-add AT ROW 1.5 COL 13
     B-update AT ROW 1.5 COL 23
     B-delete AT ROW 1.5 COL 33
     B-first AT ROW 1.42 COL 46
     B-prev AT ROW 1.42 COL 50.86
     B-next AT ROW 1.42 COL 56.29
     B-last AT ROW 1.42 COL 61.57
     B-browse AT ROW 1.27 COL 69.86
     B-exit AT ROW 1.5 COL 79
     R-query AT ROW 1 COL 1
     R-modify AT ROW 1 COL 11
     R-navigaate AT ROW 1 COL 44
     R-consulta AT ROW 1 COL 67.86
     R-exit AT ROW 1 COL 77.72
    WITH 1 DOWN OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 13.62
         SIZE 87.86 BY 2.08
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
         TITLE              = "Plan de Cuentas"
         COLUMN             = 6.72
         ROW                = 4.35
         HEIGHT             = 14.81
         WIDTH              = 87.14
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
         FONT               = 4
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

IF NOT W-maestro:LOAD-ICON("IMG/valmiesa":U) THEN
    MESSAGE "Unable to load icon: IMG/valmiesa"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR FRAME F-add
   NOT-VISIBLE UNDERLINE Default                                        */
ASSIGN 
       FRAME F-add:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON B-Cancel IN FRAME F-add
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON B-ok IN FRAME F-add
   NO-DISPLAY                                                           */
/* SETTINGS FOR FRAME F-ctrl-frame
   UNDERLINE Default                                                    */
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
   NOT-VISIBLE UNDERLINE Default                                        */
/* SETTINGS FOR TOGGLE-BOX cb-ctas.AftDcb IN FRAME F-maestro
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cb-ctas.An1cta IN FRAME F-maestro
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cb-ctas.Cc1cta IN FRAME F-maestro
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cb-ctas.CodDiv IN FRAME F-maestro
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN cb-ctas.Nomcta IN FRAME F-maestro
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX cb-ctas.PidAux IN FRAME F-maestro
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX cb-ctas.pidcco IN FRAME F-maestro
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cb-ctas.Tpogto IN FRAME F-maestro
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cb-ctas.vcodcia IN FRAME F-maestro
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME F-search
   NOT-VISIBLE UNDERLINE Default                                        */
ASSIGN 
       FRAME F-search:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON B-Cancel-3 IN FRAME F-search
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON B-ok-3 IN FRAME F-search
   NO-DISPLAY                                                           */
/* SETTINGS FOR FRAME F-update
   NOT-VISIBLE UNDERLINE Default                                        */
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
     _Query            is OPENED
*/  /* FRAME F-maestro */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define FRAME-NAME F-maestro
&Scoped-define SELF-NAME cb-ctas.AftDcb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ctas.AftDcb W-maestro
ON VALUE-CHANGED OF cb-ctas.AftDcb IN FRAME F-maestro /* Afecta diferencia de Cambio / Traslación */
DO:
    IF NOT INPUT cb-ctas.AftDcb
    THEN DO:
        ASSIGN cb-ctas.TpoCmb:SENSITIVE = NO.
               cb-ctas.TpoCmb:SCREEN-VALUE = "".
    END.
    ELSE DO: 
        ASSIGN cb-ctas.TpoCmb:SENSITIVE = YES.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ctas.An1cta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ctas.An1cta W-maestro
ON F8 OF cb-ctas.An1cta IN FRAME F-maestro /* Cuenta Autom tica */
DO:
    APPLY "MOUSE-SELECT-DBLCLICK" TO cb-ctas.An1Cta.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ctas.An1cta W-maestro
ON LEAVE OF cb-ctas.An1cta IN FRAME F-maestro /* Cuenta Autom tica */
DO:
    APPLY "LEAVE" TO cb-ctas.Cc1Cta.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ctas.An1cta W-maestro
ON MOUSE-SELECT-DBLCLICK OF cb-ctas.An1cta IN FRAME F-maestro /* Cuenta Autom tica */
DO: DEF VAR X AS RECID.
    X = RECID(cb-ctas).
    RUN {&q-modelo6}.
    IF RECID-stack <> 0
    THEN DO:
        FIND {&FIRST-TABLE-IN-QUERY-F-maestro} 
            WHERE RECID( {&FIRST-TABLE-IN-QUERY-F-maestro} ) = RECID-stack
            NO-LOCK  NO-ERROR.
        IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN DO:
            cb-ctas.An1Cta:SCREEN-VALUE = cb-ctas.CodCta.
        END.
        ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
            BUTTONS OK.
    END.           
    find cb-ctas WHERE RECID(cb-ctas) = X NO-ERROR.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-ctrl-frame
&Scoped-define SELF-NAME B-add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-add W-maestro
ON CHOOSE OF B-add IN FRAME F-ctrl-frame /* Crear */
DO:
    FRAME F-ctrl-frame:VISIBLE = FALSE.
    FRAME F-add:VISIBLE = TRUE.
    CLEAR FRAME f-maestro.
    RECID-tmp = 0.
    DO TRANSACTION ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE:
        CREATE {&FIRST-TABLE-IN-QUERY-F-maestro} .
        DISPLAY {&FIELDS-IN-QUERY-F-maestro} WITH FRAME F-maestro.
        cb-ctas.CodDiv:VISIBLE IN FRAME F-maestro = CBD-CodDiv.
        ENABLE {&FIELD-update} WITH FRAME F-maestro.
        RECID-tmp = RECID ( {&FIRST-TABLE-IN-QUERY-F-maestro} ).
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
    RUN {&q-modelo} .
    IF RECID-stack <> 0
    THEN DO:
        FIND {&TABLES-IN-QUERY-F-maestro}
             WHERE RECID( {&TABLES-IN-QUERY-F-maestro} ) = RECID-stack
              NO-LOCK  NO-ERROR.

         IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN DO:
             DISPLAY  {&FIELDS-IN-QUERY-F-maestro} WITH FRAME F-maestro.
             cb-ctas.CodDiv:VISIBLE IN FRAME F-maestro = CBD-CodDiv.
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
    FIND {&FIRST-TABLE-IN-QUERY-F-maestro}
        WHERE  RECID-Tmp = RECID( {&FIRST-TABLE-IN-QUERY-F-maestro} )
            EXCLUSIVE-LOCK NO-ERROR.
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
        cb-ctas.CodDiv:VISIBLE IN FRAME F-maestro = CBD-CodDiv.
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
    IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN  DO:
        DISPLAY {&FIELDS-IN-QUERY-F-maestro} WITH FRAME f-maestro.
        cb-ctas.CodDiv:VISIBLE IN FRAME F-maestro = CBD-CodDiv.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-ctrl-frame
&Scoped-define SELF-NAME B-delete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-delete W-maestro
ON CHOOSE OF B-delete IN FRAME F-ctrl-frame /* Eliminar */
DO:
    FRAME F-ctrl-frame:VISIBLE = FALSE.
    RECID-tmp = 0.
    DO TRANSACTION ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN DO:
            RECID-Tmp = RECID(  {&FIRST-TABLE-IN-QUERY-F-maestro} ).
            FIND {&FIRST-TABLE-IN-QUERY-F-maestro}
                WHERE  RECID-Tmp = RECID(  {&FIRST-TABLE-IN-QUERY-F-maestro} )
                    EXCLUSIVE-LOCK NO-ERROR.
        END.
        IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN DO:
            IF CAN-FIND(FIRST cb-dmov WHERE cb-dmov.CODCTA = cb-ctas.CODCTA) 
               THEN DO:
                    MESSAGE "Cuenta tiene movimiento" SKIP
                            "no puede ser Eliminada" 
                            VIEW-AS ALERT-BOX ERROR.
                    RETURN NO-APPLY.
               END.
            MESSAGE "Eliminar el Registro"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE selection AS LOGICAL.
            IF selection THEN DO:
                DELETE  {&FIRST-TABLE-IN-QUERY-F-maestro}.
            END.
            ELSE FIND {&FIRST-TABLE-IN-QUERY-F-maestro}
                WHERE RECID-Tmp = RECID(  {&FIRST-TABLE-IN-QUERY-F-maestro} )
                    NO-LOCK NO-ERROR.         
        END.
        ELSE MESSAGE  "No existen Registros." VIEW-AS ALERT-BOX ERROR
            BUTTONS OK.  
    END.
    IF NOT AVAIL  {&FIRST-TABLE-IN-QUERY-F-maestro} THEN DO:
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
        IF AVAIL  {&FIRST-TABLE-IN-QUERY-F-maestro} THEN DO:
            DISPLAY {&FIELDS-IN-QUERY-F-maestro} WITH FRAME f-maestro.
            cb-ctas.CodDiv:VISIBLE IN FRAME F-maestro = CBD-CodDiv.
        END.
        ELSE DO:
             CLEAR FRAME F-maestro.
        END.
    END.
    FRAME  F-ctrl-frame:VISIBLE = TRUE.

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
         cb-ctas.CodDiv:VISIBLE IN FRAME F-maestro = CBD-CodDiv.
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
           cb-ctas.CodDiv:VISIBLE IN FRAME F-maestro = CBD-CodDiv.
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
         cb-ctas.CodDiv:VISIBLE IN FRAME F-maestro = CBD-CodDiv.
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
       {&SEARCH-KEY} )
    THEN DO:
        MESSAGE "Registro Existente" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO cb-ctas.CodCta IN FRAME F-maestro.
        RETURN NO-APPLY.
    END.
     
    FIND {&FIRST-TABLE-IN-QUERY-F-maestro}
        WHERE  RECID-Tmp = RECID( {&FIRST-TABLE-IN-QUERY-F-maestro} ).
    IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN DO:
        IF x-Ctas9 AND cb-ctas.Cc1Cta:SCREEN-VALUE IN FRAME F-maestro = cb-cfga.Cc1Cta9
        THEN cb-ctas.Cc1Cta:SCREEN-VALUE IN FRAME F-maestro = "".
        IF x-Ctas6 AND cb-ctas.Cc1Cta:SCREEN-VALUE IN FRAME F-maestro = cb-cfga.Cc1Cta6
        THEN cb-ctas.Cc1Cta:SCREEN-VALUE IN FRAME F-maestro = "".
        ASSIGN FRAME F-Maestro
        {&FIELDS-IN-QUERY-F-maestro}
        {&ASSIGN-ADD}.
    END.
    ELSE MESSAGE "Registro no creado".
    FIND {&FIRST-TABLE-IN-QUERY-F-maestro}
        WHERE RECID-tmp = RECID ( {&FIRST-TABLE-IN-QUERY-F-maestro} )
            NO-LOCK NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-update
&Scoped-define SELF-NAME B-ok-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-ok-2 W-maestro
ON CHOOSE OF B-ok-2 IN FRAME F-update /* Aceptar */
DO:
 /*   IF x-Ctas9 AND cb-ctas.Cc1Cta:SCREEN-VALUE IN FRAME F-maestro = cb-cfga.Cc1Cta9
    THEN cb-ctas.Cc1Cta:SCREEN-VALUE IN FRAME F-maestro = "".
    IF x-Ctas6 AND cb-ctas.Cc1Cta:SCREEN-VALUE IN FRAME F-maestro = cb-cfga.Cc1Cta6
    THEN cb-ctas.Cc1Cta:SCREEN-VALUE IN FRAME F-maestro = "".
*/    
    ASSIGN FRAME F-maestro
    {&FIELDS-IN-QUERY-F-maestro}
    {&ASSIGN-ADD}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-search
&Scoped-define SELF-NAME B-ok-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-ok-3 W-maestro
ON CHOOSE OF B-ok-3 IN FRAME F-search /* Aceptar */
DO:
    IF cb-ctas.CodCta:SCREEN-VALUE IN FRAME F-maestro <> "" THEN DO:
        FIND FIRST  {&FIRST-TABLE-IN-QUERY-F-maestro}
             WHERE 
                 &IF "{&RECORD-SCOPE}" <> "" &THEN
                     {&RECORD-SCOPE} AND
                 &ENDIF
                 cb-ctas.CodCta = cb-ctas.CodCta:SCREEN-VALUE IN FRAME F-maestro
                 NO-LOCK NO-ERROR.
        ASSIGN cb-ctas.NomCta:SCREEN-VALUE = "".
    END.

    IF cb-ctas.NomCta:SCREEN-VALUE IN FRAME F-maestro <> "" THEN DO:
        FIND FIRST  {&FIRST-TABLE-IN-QUERY-F-maestro}
            WHERE 
            &IF "{&RECORD-SCOPE}" <> "" &THEN
                {&RECORD-SCOPE} AND
            &ENDIF
            cb-ctas.NomCta BEGINS cb-ctas.NomCta:SCREEN-VALUE IN FRAME F-maestro
            NO-LOCK NO-ERROR.
        ASSIGN cb-ctas.CodCta:SCREEN-VALUE = "".
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
     
    IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN  DO:
        DISPLAY {&FIELDS-IN-QUERY-F-maestro} WITH FRAME f-maestro.
        cb-ctas.CodDiv:VISIBLE IN FRAME F-maestro = CBD-CodDiv.
    END.

    IF NOT AVAIL  {&FIRST-TABLE-IN-QUERY-F-maestro}  THEN DO:
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
     IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN DO:
         DISPLAY {&FIELDS-IN-QUERY-F-maestro} WITH FRAME F-maestro.
         cb-ctas.CodDiv:VISIBLE IN FRAME F-maestro = CBD-CodDiv.
     END.
     ELSE MESSAGE "No Existen Registros" VIEW-AS ALERT-BOX ERROR
     BUTTONS OK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-query
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-query W-maestro
ON CHOOSE OF B-query IN FRAME F-ctrl-frame /* Buscar */
DO:
     CLEAR FRAME F-maestro.
     FRAME F-ctrl-frame:VISIBLE = FALSE.
     FRAME F-search:VISIBLE = TRUE.
     x-leave = NO.
     DO ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE: 
         ENABLE {&QUERY-field}  WITH FRAME F-maestro.
         WAIT-FOR  "CHOOSE" OF b-ok-3 IN FRAME f-search
         OR "CHOOSE" OF b-cancel-3 IN FRAME f-search.
     END.
     x-leave = YES.
     DISABLE {&QUERY-field} WITH FRAME F-maestro.
     DISABLE {&FIELDS-update} WITH FRAME F-meastro.
     FRAME f-search:VISIBLE = FALSE.
     FRAME f-ctrl-frame:VISIBLE = TRUE.

END. /*choose of b-query*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-update
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-update W-maestro
ON CHOOSE OF B-update IN FRAME F-ctrl-frame /* Modificar */
DO: 
    FRAME f-ctrl-frame:VISIBLE = FALSE.
    FRAME f-update:VISIBLE = TRUE.
    RECID-stack = RECID( {&FIRST-TABLE-IN-QUERY-F-maestro} ).
    ROWID-STACK = ROWID( {&FIRST-TABLE-IN-QUERY-F-maestro} ).
    DO TRANSACTION ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        FIND {&FIRST-TABLE-IN-QUERY-F-maestro}
            WHERE RECID-stack = RECID( {&FIRST-TABLE-IN-QUERY-F-maestro} )
                EXCLUSIVE NO-ERROR.
        IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN DO:
            ENABLE {&FIELD-update} WITH FRAME F-maestro.
            DISABLE {&NO-MODIFY} WITH FRAME F-maestro.
            IF LENGTH(cb-ctas.codcta) = x-MaxNiv THEN DO:
                ENABLE {&FIELDS-update} WITH FRAME F-maestro.
                RUN user_procedure1.
            END.
            WAIT-FOR CHOOSE OF b-ok-2 OR CHOOSE OF B-CANCEL-2 IN FRAME f-UPDATE.
        END.
        ELSE MESSAGE "No exiten Registros." VIEW-AS ALERT-BOX ERROR
            BUTTONS OK.
    END.  /*transaction*/
    IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN
        /*FIND {&FIRST-TABLE-IN-QUERY-F-maestro}
            WHERE RECID-stack = RECID( {&FIRST-TABLE-IN-QUERY-F-maestro} )
                NO-LOCK NO-ERROR.*/
        FIND {&FIRST-TABLE-IN-QUERY-F-maestro}
            WHERE ROWID-STACK = ROWID( {&FIRST-TABLE-IN-QUERY-F-maestro} )
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
    ELSE 
        CLEAR FRAME F-maestro.
    cb-ctas.CodDiv:VISIBLE IN FRAME F-maestro = CBD-CodDiv.
    DISABLE {&FIELDS-IN-QUERY-F-maestro} WITH FRAME F-maestro.
    FRAME f-update:VISIBLE = FALSE.
    FRAME F-ctrl-frame:VISIBLE = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-maestro
&Scoped-define SELF-NAME cb-ctas.Cc1cta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ctas.Cc1cta W-maestro
ON F8 OF cb-ctas.Cc1cta IN FRAME F-maestro /* Contra Cuenta Autom tica */
DO:
    APPLY "MOUSE-SELECT-DBLCLICK" TO cb-ctas.Cc1cta.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ctas.Cc1cta W-maestro
ON LEAVE OF cb-ctas.Cc1cta IN FRAME F-maestro /* Contra Cuenta Autom tica */
DO:
    IF SELF:SCREEN-VALUE NE "" THEN DO:
    
        IF NOT CAN-FIND( cb-ctas WHERE cb-ctas.CodCia = cb-codcia
                               AND cb-ctas.CodCta = SELF:SCREEN-VALUE)
        THEN DO:
            BELL.
            MESSAGE "Codigo no registrado" VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
        IF LENGTH( SELF:SCREEN-VALUE ) <> x-MaxNiv
        THEN DO:
            BELL.
            MESSAGE "Debe ser una cuenta de Ultimo Nivel"
            VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ctas.Cc1cta W-maestro
ON MOUSE-SELECT-DBLCLICK OF cb-ctas.Cc1cta IN FRAME F-maestro /* Contra Cuenta Autom tica */
DO: DEF VAR X AS RECID.
    X = RECID(cb-ctas).
    RUN {&q-modelo7}.
    IF RECID-stack <> 0
    THEN DO:
        FIND {&FIRST-TABLE-IN-QUERY-F-maestro} 
            WHERE RECID( {&FIRST-TABLE-IN-QUERY-F-maestro} ) = RECID-stack
            NO-LOCK  NO-ERROR.
        IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN DO:
            cb-ctas.Cc1Cta:SCREEN-VALUE = cb-ctas.CodCta.         
        END.
        ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
            BUTTONS OK.
    END.           
    find cb-ctas WHERE RECID(cb-ctas) = X NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ctas.ClfAux
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ctas.ClfAux W-maestro
ON F8 OF cb-ctas.ClfAux IN FRAME F-maestro /* Auxiliar */
DO:
    APPLY "MOUSE-SELECT-DBLCLICK" TO cb-ctas.ClfAux.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ctas.ClfAux W-maestro
ON LEAVE OF cb-ctas.ClfAux IN FRAME F-maestro /* Auxiliar */
DO:
    CASE SELF:SCREEN-VALUE.
    WHEN "@CT" THEN.
    WHEN "@PV" THEN.
    WHEN "@CL" THEN.
    OTHERWISE 
        IF NOT CAN-FIND( cb-tabl WHERE cb-tabl.Tabla  = "01"
                                  AND cb-tabl.Codigo = SELF:SCREEN-VALUE)
        THEN DO:
            BELL.
            MESSAGE "Codigo no registrado" VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
    END CASE.
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ctas.ClfAux W-maestro
ON MOUSE-SELECT-DBLCLICK OF cb-ctas.ClfAux IN FRAME F-maestro /* Auxiliar */
DO:
/*&Scoped-define q-modelo2 cbd/q-clfaux.w ( "01", OUTPUT RECID-stack )*/
    RUN {&q-modelo2} .
    IF RECID-stack <> 0
    THEN DO:
        FIND cb-tabl WHERE RECID( cb-tabl ) = RECID-stack
             NO-LOCK  NO-ERROR.
        IF AVAIL cb-tabl THEN DO:
            cb-ctas.ClfAux:SCREEN-VALUE = cb-tabl.codigo.
        END.
        ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
        BUTTONS OK.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ctas.Codcta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ctas.Codcta W-maestro
ON LEAVE OF cb-ctas.Codcta IN FRAME F-maestro /* Cuenta */
DO:
    IF NOT x-leave THEN RETURN.
    IF LOOKUP(LAST-EVENT:FUNCTION, "ENDKEY,ERROR,END-ERROR") <> 0
    THEN RETURN.
    ASSIGN x-CodCta = cb-ctas.CodCta:SCREEN-VALUE IN FRAME F-maestro.
    Nivel = LOOKUP(STRING( LENGTH(x-CodCta) ), cb-niveles ).
    IF Nivel = 0
    THEN DO:
        BELL.
        MESSAGE "Inv lido formato en el registro de la cuenta"
            SKIP "  Intente de nuevo..." VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO cb-ctas.Codcta.
        RETURN NO-APPLY.
    END.
    ELSE DO:
        IF Nivel > 1 THEN DO:
            find cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND cb-ctas.CodCta =
                SUBSTRING(x-CodCta,1, INTEGER(ENTRY(Nivel - 1,cb-niveles)))
                    NO-ERROR.
            IF NOT AVAILABLE cb-ctas THEN DO:
                MESSAGE "Cuenta del Nivel anterior" SKIP
                    "aun no ha sido creada"
                    VIEW-AS ALERT-BOX ERROR.
                APPLY "ENTRY" TO cb-ctas.Codcta.
                RETURN NO-APPLY.
            END.
            IF Nivel = NUM-ENTRIES( cb-niveles )THEN DO:
                ENABLE {&FIELDS-update} WITH FRAME F-maestro.
                RUN user_procedure1.
            END.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ctas.CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ctas.CodDiv W-maestro
ON F8 OF cb-ctas.CodDiv IN FRAME F-maestro /* Divisionaria Asociada */
DO:
      APPLY "MOUSE-SELECT-DBLCLICK" TO cb-ctas.CodDiv.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ctas.CodDiv W-maestro
ON LEAVE OF cb-ctas.CodDiv IN FRAME F-maestro /* Divisionaria Asociada */
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    IF NOT CAN-FIND( GN-DIVI WHERE GN-DIVI.CodCia = S-codcia 
                               AND GN-DIVI.CODDIV = SELF:SCREEN-VALUE)
    THEN DO:
        BELL.
        MESSAGE "Codigo no registrado" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ctas.CodDiv W-maestro
ON MOUSE-SELECT-DBLCLICK OF cb-ctas.CodDiv IN FRAME F-maestro /* Divisionaria Asociada */
DO:
  
  {CBD/H-DIVI01.I NO SELF}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ctas.Coddoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ctas.Coddoc W-maestro
ON F8 OF cb-ctas.Coddoc IN FRAME F-maestro /* Documento */
DO:
    APPLY "MOUSE-SELECT-DBLCLICK" TO cb-ctas.Coddoc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ctas.Coddoc W-maestro
ON LEAVE OF cb-ctas.Coddoc IN FRAME F-maestro /* Documento */
DO:
    CASE SELF:SCREEN-VALUE.
    WHEN "" THEN.
    OTHERWISE
        IF NOT CAN-FIND( cb-tabl WHERE Tabla  = "02"
                             AND Codigo = SELF:SCREEN-VALUE)
        THEN DO:
            BELL.
            MESSAGE "Codigo no registrado" VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
    END CASE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ctas.Coddoc W-maestro
ON MOUSE-SELECT-DBLCLICK OF cb-ctas.Coddoc IN FRAME F-maestro /* Documento */
DO: 
    RUN {&q-modelo3}.
    IF RECID-stack <> 0
    THEN DO:
        FIND cb-tabl WHERE RECID( cb-tabl ) = RECID-stack
              NO-LOCK  NO-ERROR.
        IF AVAIL cb-tabl THEN DO:
             cb-ctas.CodDoc:SCREEN-VALUE = cb-tabl.codigo.
        END.
        ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
            BUTTONS OK.
    END.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ctas.PidAux
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ctas.PidAux W-maestro
ON VALUE-CHANGED OF cb-ctas.PidAux IN FRAME F-maestro /* Requiere C¢digo Auxiliar */
DO:
    IF NOT INPUT cb-ctas.PidAux
    THEN ASSIGN cb-ctas.ClfAux:SENSITIVE = NO
                cb-ctas.ClfAux:SCREEN-VALUE = "".
    ELSE DO:
        ASSIGN cb-ctas.ClfAux:SENSITIVE = YES.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ctas.PidDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ctas.PidDoc W-maestro
ON VALUE-CHANGED OF cb-ctas.PidDoc IN FRAME F-maestro /* Requiere Documento de Control */
DO:
   IF NOT INPUT cb-ctas.PidDoc
   THEN DO:
        ASSIGN cb-ctas.CodDoc:SENSITIVE = NO.
                cb-ctas.CodDoc:SCREEN-VALUE = "".
   END.            
   ELSE DO: 
        ASSIGN cb-ctas.CodDoc:SENSITIVE = YES.
   END.
     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ctas.Tpogto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ctas.Tpogto W-maestro
ON F8 OF cb-ctas.Tpogto IN FRAME F-maestro /* Tipo de Gasto */
DO:
    APPLY "MOUSE-SELECT-DBLCLICK" TO cb-ctas.TpoGto.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ctas.Tpogto W-maestro
ON LEAVE OF cb-ctas.Tpogto IN FRAME F-maestro /* Tipo de Gasto */
DO:
    IF NOT CAN-FIND( cb-auxi WHERE CodCia = cb-codcia 
                                AND ClfAux = "04"
                                AND CodAux = SELF:SCREEN-VALUE)
    THEN DO:
        BELL.
        MESSAGE "Codigo no registrado" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ctas.Tpogto W-maestro
ON MOUSE-SELECT-DBLCLICK OF cb-ctas.Tpogto IN FRAME F-maestro /* Tipo de Gasto */
DO:
    RUN {&q-modelo4}.
    IF RECID-stack <> 0
    THEN DO:
        FIND cb-auxi WHERE RECID( cb-auxi ) = RECID-stack
              NO-LOCK  NO-ERROR.
        IF AVAIL cb-auxi THEN DO:
             cb-ctas.TpoGto:SCREEN-VALUE = cb-auxi.CodAux.
        END.
        ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
            BUTTONS OK.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ctas.vcodcia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ctas.vcodcia W-maestro
ON F8 OF cb-ctas.vcodcia IN FRAME F-maestro /* Visible para la Cia */
DO:
  DEF VAR X-recid AS RECID.
  run adm/q-cias(OUTPUT X-Recid).
  IF  X-Recid <> 0 THEN DO:
      FIND EMPRESAS WHERE RECID(EMPRESAS) = X-Recid NO-LOCK NO-ERROR.
      IF AVAIL EMPRESAS THEN DO:
         {&SELF-NAME} = EMPRESAS.CodCia.
         display {&SELF-NAME} WITH FRAME {&FRAME-NAME}.
         RETURN NO-APPLY.
      END.
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
    IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN DO:
       DISPLAY {&FIELDS-IN-QUERY-F-maestro} WITH FRAME F-maestro.
       {&OPEN-BROWSERS-IN-QUERY-F-maestro}
    END.
    ELSE CLEAR FRAME F-maestro.
    cb-ctas.CodDiv:VISIBLE IN FRAME F-maestro = CBD-CodDiv.
        
    DISABLE {&FIELDS-IN-QUERY-F-maestro} WITH FRAME F-maestro.     

    IF NOT THIS-PROCEDURE:PERSISTENT THEN    
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
    
END.

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
  IF AVAILABLE cb-ctas THEN 
    DISPLAY cb-ctas.Codcta cb-ctas.Nomcta cb-ctas.PidAux cb-ctas.PidDoc 
          cb-ctas.PidRef cb-ctas.AftDcb cb-ctas.pidcco cb-ctas.CieRes 
          cb-ctas.An1cta cb-ctas.Cc1cta cb-ctas.ClfAux cb-ctas.Coddoc 
          cb-ctas.Tpocmb cb-ctas.Codmon cb-ctas.Tpogto cb-ctas.vcodcia 
      WITH FRAME F-maestro IN WINDOW W-maestro.
  ENABLE R-maestro1 R-maestro2 cb-ctas.Codcta cb-ctas.Nomcta cb-ctas.PidAux 
         cb-ctas.PidDoc cb-ctas.PidRef cb-ctas.AftDcb cb-ctas.pidcco 
         cb-ctas.CieRes cb-ctas.An1cta cb-ctas.Cc1cta cb-ctas.ClfAux 
         cb-ctas.Coddoc cb-ctas.Tpocmb cb-ctas.Codmon cb-ctas.Tpogto 
         cb-ctas.CodDiv cb-ctas.vcodcia 
      WITH FRAME F-maestro IN WINDOW W-maestro.
  {&OPEN-BROWSERS-IN-QUERY-F-maestro}
  ENABLE R-navigaate-2 B-ok B-Cancel 
      WITH FRAME F-add IN WINDOW W-maestro.
  {&OPEN-BROWSERS-IN-QUERY-F-add}
  ENABLE R-query B-query R-modify B-add B-update B-delete R-navigaate B-first 
         B-prev B-next B-last R-consulta B-browse R-exit B-exit 
      WITH FRAME F-ctrl-frame IN WINDOW W-maestro.
  {&OPEN-BROWSERS-IN-QUERY-F-ctrl-frame}
  ENABLE R-navigaate-4 B-ok-3 B-Cancel-3 
      WITH FRAME F-search IN WINDOW W-maestro.
  {&OPEN-BROWSERS-IN-QUERY-F-search}
  ENABLE R-navigaate-3 B-ok-2 B-Cancel-2 
      WITH FRAME F-update IN WINDOW W-maestro.
  {&OPEN-BROWSERS-IN-QUERY-F-update}
  VIEW W-maestro.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE user_procedure1 W-maestro 
PROCEDURE user_procedure1 :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  
  x-Ctas9 = FALSE.
  x-Ctas6 = FALSE.
  x-Ctas0 = FALSE.
  
  APPLY "VALUE-CHANGED" TO cb-ctas.PidAux IN FRAME F-maestro.
  APPLY "VALUE-CHANGED" TO cb-ctas.AftDcb.
  APPLY "VALUE-CHANGED" TO cb-ctas.PidDoc.
  
  /* Verificamos si la Cuenta genera automaticas de Clase 9 */
  DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut9 ):
      IF cb-ctas.CodCta BEGINS ENTRY( i, cb-cfga.GenAut9 ) 
      THEN DO:
          IF ENTRY( i, cb-cfga.GenAut9) <> ""
          THEN DO:
              x-Ctas9 = YES.
              LEAVE.
          END.                                              
     END.
  END.

  DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut6 ):
      IF cb-ctas.CodCta BEGINS ENTRY( i, cb-cfga.GenAut6 ) 
      THEN DO:
          IF ENTRY( i, cb-cfga.GenAut6) <> ""
          THEN DO:
              x-Ctas6 = YES.
              LEAVE.
          END.
     END.
  END.

  DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut ):
      IF cb-ctas.CodCta BEGINS ENTRY( i, cb-cfga.GenAut )
      THEN DO:
          IF ENTRY( i, cb-cfga.GenAut) <> ""
          THEN DO:
              x-Ctas0 = YES.
              LEAVE.
          END.
     END.
  END.

 
/* FILTRANDO LOS CAMPOS QUE DEBEN SALIR */
cb-ctas.CodDiv:VISIBLE IN FRAME F-maestro = CBD-CodDiv.

IF NOT x-Ctas9 THEN ASSIGN cb-ctas.TpoGto:VISIBLE IN FRAME F-maestro = NO.

IF x-Ctas9 THEN DO :
                       ASSIGN cb-ctas.An1Cta:VISIBLE = YES 
                       cb-ctas.Cc1Cta:VISIBLE = YES                              
                       x-Ctas6 = NO
                       x-Ctas0 = NO.
                       IF  cb-ctas.Cc1Cta:SCREEN-VALUE = "" THEN
                         cb-ctas.Cc1Cta:SCREEN-VALUE = cb-cfga.Cc1Cta9.

                END.       
        
IF x-Ctas6 THEN DO:
                       ASSIGN cb-ctas.An1Cta:VISIBLE = YES 
                       cb-ctas.Cc1Cta:VISIBLE = YES    
                       x-Ctas0 = NO.
                       IF cb-ctas.Cc1Cta:SCREEN-VALUE = "" THEN 
                            cb-ctas.Cc1Cta:SCREEN-VALUE = cb-cfga.Cc1Cta6.
                END.       

IF x-Ctas0 THEN ASSIGN cb-ctas.An1Cta:VISIBLE = YES 
                       cb-ctas.Cc1Cta:VISIBLE = YES.
                              
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


