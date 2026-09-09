&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME WINDOW-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS WINDOW-1 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 07/13/95 - 12:16 pm

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE {&NEW} SHARED VARIABLE cb-niveles AS CHARACTER INITIAL "2,3,4,5".
DEFINE {&NEW} SHARED VARIABLE s-codcia AS INTEGER INITIAL 1.

DEFINE VARIABLE y-CodCia    AS INTEGER INITIAL 0.
DEFINE VARIABLE X-Maxniv    AS INTEGER INITIAL 0.
DEFINE VARIABLE RECID-stack AS RECID NO-UNDO.
DEFINE VARIABLE RECID-tmp   AS RECID NO-UNDO.
DEFINE VARIABLE pto         AS LOGICAL.


FIND integral.Empresas WHERE integral.Empresas.Codcia = s-codcia.
IF NOT campo-codcbd THEN y-Codcia = s-codcia.
     
FIND integral.cb-cfga WHERE cb-cfga.CodCia = y-codcia 
                            NO-LOCK NO-ERROR.
IF NOT AVAIL cb-cfga THEN DO:
   MESSAGE "Tabla de Configuraci¢n para la" SKIP
           "La Compa¤ia " + STRING(y-codcia) + " no Creada"
           VIEW-AS ALERT-BOX ERROR.
   RETURN.        
END.   
pto      = SESSION:SET-WAIT-STATE("").
x-MaxNiv = INTEGER( ENTRY ( NUM-ENTRIES ( cb-niveles ), cb-niveles ) ). 

/*   C A M B I O S   E N    L O S   P R E - P R O C E S A D O R E S */

/* Asignacion de Valores por Defecto Y-Codcia    */
&Scoped-define FIELD-ADD integral.Cbdtdist.Codcia = Y-Codcia

/* Programa donde realizara la Consulta Ctas.Contables  */
&Scoped-define q-modelo1 cbd/q-cb-ctas.w( Y-Codcia , OUTPUT RECID-tmp)

/* Programa donde realizara la Consulta Ctas.Contables de Ultimo Nivel  */
&Scoped-define q-modelo2 cbd/q-ctas2.w( Y-Codcia, "" , OUTPUT RECID-tmp)

/* Programa donde realizara la Consulta Configuracion de Operaciones  */
&Scoped-define q-modelo3 cbd/q-oper.w( Y-Codcia, OUTPUT RECID-tmp)

/* variable de Display  de Campos */
&Scoped-define cmpo1 integral.cb-cfga.cjaChc

&Scoped-define cmpo2 integral.cb-cfga.cjaegr

&Scoped-define cmpo3 integral.cb-cfga.cjaing

&Scoped-define cmpo4 integral.cb-cfga.transf
&Scoped-define Desc4 Desctra

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Maestro

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES cb-cfga

/* Definitions for FRAME F-Maestro                                      */
&Scoped-define FIELDS-IN-QUERY-F-Maestro cb-cfga.ctaahorro ~
cb-cfga.ctacredito cb-cfga.ctacajamn cb-cfga.ctacajame cb-cfga.cjaChc ~
cb-cfga.cjaEgr cb-cfga.cjaIng cb-cfga.Transf 
&Scoped-define OPEN-QUERY-F-Maestro OPEN QUERY F-Maestro FOR EACH cb-cfga SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-F-Maestro cb-cfga
&Scoped-define FIRST-TABLE-IN-QUERY-F-Maestro cb-cfga


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-4 RECT-5 RECT-6 BUTTON-1 
&Scoped-Define DISPLAYED-FIELDS cb-cfga.ctaahorro cb-cfga.ctacredito ~
cb-cfga.ctacajamn cb-cfga.ctacajame cb-cfga.cjaChc cb-cfga.cjaEgr ~
cb-cfga.cjaIng cb-cfga.Transf 
&Scoped-Define DISPLAYED-OBJECTS Desctaaho Desctacre Desctacajmn ~
Desctacajme Desctra 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR WINDOW-1 AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-aceptar 
     LABEL "&Aceptar" 
     SIZE 10.72 BY 1.08.

DEFINE BUTTON B-cancelar 
     LABEL "&Cancelar" 
     SIZE 10.72 BY 1.08.

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\exit":U
     LABEL "Salir" 
     SIZE 6.86 BY 1.35.

DEFINE VARIABLE Desctaaho AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .69 NO-UNDO.

DEFINE VARIABLE Desctacajme AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .69 NO-UNDO.

DEFINE VARIABLE Desctacajmn AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .69 NO-UNDO.

DEFINE VARIABLE Desctacre AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .69 NO-UNDO.

DEFINE VARIABLE Desctra AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42.86 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 74.72 BY 4.88
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 74.72 BY 4.23
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 74.72 BY 1.69
     BGCOLOR 8 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY F-Maestro FOR 
      cb-cfga SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Maestro
     B-aceptar AT ROW 10.5 COL 5 HELP
          "Acepta los datos ingresados"
     cb-cfga.ctaahorro AT ROW 1.54 COL 16.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     cb-cfga.ctacredito AT ROW 2.31 COL 16.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     cb-cfga.ctacajamn AT ROW 3.08 COL 16.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     cb-cfga.ctacajame AT ROW 3.85 COL 16.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     B-cancelar AT ROW 10.5 COL 19 HELP
          "Cancela los datos ingresados"
     cb-cfga.cjaChc AT ROW 6.38 COL 21 COLON-ALIGNED FORMAT "X(90)"
          VIEW-AS FILL-IN 
          SIZE 37.29 BY .69
     cb-cfga.cjaEgr AT ROW 7.23 COL 21 COLON-ALIGNED FORMAT "X(150)"
          VIEW-AS FILL-IN 
          SIZE 37.29 BY .69
     cb-cfga.cjaIng AT ROW 8.04 COL 21 COLON-ALIGNED FORMAT "X(150)"
          VIEW-AS FILL-IN 
          SIZE 37.29 BY .69
     cb-cfga.Transf AT ROW 8.85 COL 21.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .69
     Desctaaho AT ROW 1.54 COL 27 COLON-ALIGNED NO-LABEL
     Desctacre AT ROW 2.35 COL 27 COLON-ALIGNED NO-LABEL
     Desctacajmn AT ROW 3.08 COL 27 COLON-ALIGNED NO-LABEL
     Desctacajme AT ROW 3.85 COL 27 COLON-ALIGNED NO-LABEL
     Desctra AT ROW 8.85 COL 29.43 COLON-ALIGNED NO-LABEL
     BUTTON-1 AT ROW 10.42 COL 68 HELP
          "Salida"
     "                   CONFIGURACION DE OPERACIONES" VIEW-AS TEXT
          SIZE 74.14 BY .69 AT ROW 5.38 COL 1.29
          BGCOLOR 1 FGCOLOR 15 FONT 0
     RECT-4 AT ROW 5.31 COL 1
     RECT-5 AT ROW 1 COL 1
     RECT-6 AT ROW 10.19 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.86 BY 15.69
         FONT 4.


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
  CREATE WINDOW WINDOW-1 ASSIGN
         HIDDEN             = YES
         TITLE              = "Configuración de Caja Bancos"
         COLUMN             = 47.29
         ROW                = 10.92
         HEIGHT             = 10.96
         WIDTH              = 75.29
         MAX-HEIGHT         = 15.69
         MAX-WIDTH          = 91.43
         VIRTUAL-HEIGHT     = 15.69
         VIRTUAL-WIDTH      = 91.43
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW WINDOW-1
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Maestro
                                                                        */
/* SETTINGS FOR BUTTON B-aceptar IN FRAME F-Maestro
   NO-ENABLE                                                            */
ASSIGN 
       B-aceptar:HIDDEN IN FRAME F-Maestro           = TRUE.

/* SETTINGS FOR BUTTON B-cancelar IN FRAME F-Maestro
   NO-ENABLE                                                            */
ASSIGN 
       B-cancelar:HIDDEN IN FRAME F-Maestro           = TRUE.

/* SETTINGS FOR FILL-IN cb-cfga.cjaChc IN FRAME F-Maestro
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN cb-cfga.cjaEgr IN FRAME F-Maestro
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN cb-cfga.cjaIng IN FRAME F-Maestro
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN cb-cfga.ctaahorro IN FRAME F-Maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-cfga.ctacajame IN FRAME F-Maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-cfga.ctacajamn IN FRAME F-Maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-cfga.ctacredito IN FRAME F-Maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Desctaaho IN FRAME F-Maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Desctacajme IN FRAME F-Maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Desctacajmn IN FRAME F-Maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Desctacre IN FRAME F-Maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Desctra IN FRAME F-Maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-cfga.Transf IN FRAME F-Maestro
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(WINDOW-1)
THEN WINDOW-1:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Maestro
/* Query rebuild information for FRAME F-Maestro
     _TblList          = "integral.cb-cfga"
     _Query            is OPENED
*/  /* FRAME F-Maestro */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME B-aceptar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-aceptar WINDOW-1
ON CHOOSE OF B-aceptar IN FRAME F-Maestro /* Aceptar */
DO:
    ASSIGN FRAME F-Maestro
    {&FIELDS-IN-QUERY-{&FRAME-NAME}}.
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 WINDOW-1
ON CHOOSE OF BUTTON-1 IN FRAME F-Maestro /* Salir */
DO:
    &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-cfga.ctaahorro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cfga.ctaahorro WINDOW-1
ON F8 OF cb-cfga.ctaahorro IN FRAME F-Maestro /* Cuentas de ahorro */
DO:
    RECID-tmp = 0.
    RUN {&q-modelo1}.
    IF RECID-tmp <> 0
    THEN DO:
        FIND integral.cb-ctas
             WHERE RECID( integral.cb-ctas ) = RECID-tmp 
                        NO-LOCK  NO-ERROR.
        IF AVAIL integral.cb-ctas 
        THEN DO:
            DISPLAY  integral.cb-ctas.Codcta @ integral.cb-cfga.ctaahorro WITH FRAME F-maestro.
            Desctaaho:SCREEN-VALUE =  integral.cb-ctas.Nomcta.
        END.
        ELSE 
             MESSAGE "C¢digo de Cuenta ingresado No existe" VIEW-AS ALERT-BOX ERROR.
             APPLY "ENTRY" TO integral.cb-cfga.ctaahorro IN FRAME F-Maestro.
             RETURN NO-APPLY.      
        END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cfga.ctaahorro WINDOW-1
ON LEAVE OF cb-cfga.ctaahorro IN FRAME F-Maestro /* Cuentas de ahorro */
DO:
   IF integral.cb-cfga.ctaahorro:SCREEN-VALUE = "" 
   THEN DO:
       desctaaho:SCREEN-VALUE = "". 
       RETURN.
   END.
    
   IF LOOKUP(LAST-EVENT:FUNCTION,"ERROR,ENDKEY,END-KEY") <> 0 THEN RETURN.
   
   FIND integral.cb-ctas WHERE integral.cb-ctas.CodCia = Y-Codcia AND
        integral.cb-ctas.Codcta = integral.cb-cfga.ctaahorro:SCREEN-VALUE
        NO-LOCK NO-ERROR.
        
   IF NOT AVAILABLE integral.cb-ctas 
   THEN DO:
       BELL.
       MESSAGE "C¢digo de Cuenta ingresado No existe" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO integral.cb-cfga.ctaahorro IN FRAME F-Maestro. 
       RETURN NO-APPLY.
   END.
   
   DISPLAY integral.cb-ctas.Codcta @ integral.cb-cfga.ctaahorro WITH FRAME F-maestro.  
   desctaaho:SCREEN-VALUE = integral.cb-ctas.Nomcta.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cfga.ctaahorro WINDOW-1
ON MOUSE-SELECT-DBLCLICK OF cb-cfga.ctaahorro IN FRAME F-Maestro /* Cuentas de ahorro */
DO:
    APPLY "F8" TO integral.cb-cfga.ctaahorro.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-cfga.ctacajame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cfga.ctacajame WINDOW-1
ON F8 OF cb-cfga.ctacajame IN FRAME F-Maestro /* Cuenta de Caja ME */
DO:
    RECID-tmp = 0.
    RUN {&q-modelo2}.
    IF RECID-tmp <> 0
    THEN DO:
        FIND integral.cb-ctas
             WHERE RECID( integral.cb-ctas ) = RECID-tmp 
                        NO-LOCK  NO-ERROR.
                        
        IF AVAIL integral.cb-ctas 
                 AND LENGTH(integral.cb-ctas.Codcta) <> X-Maxniv 
        THEN DO:
            BELL.
            MESSAGE "El C¢digo de Cuenta debe ser de £ltimo Nivel" VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO integral.cb-cfga.ctacajame IN FRAME F-Maestro. 
            RETURN NO-APPLY.
        END.
                        
        IF AVAIL integral.cb-ctas 
        THEN DO:
            DISPLAY  integral.cb-ctas.Codcta @ integral.cb-cfga.ctacajame WITH FRAME F-maestro.
            desctacajme:SCREEN-VALUE =  integral.cb-ctas.Nomcta.
        END.
        ELSE 
             MESSAGE "C¢digo de Cuenta ingresado No existe" VIEW-AS ALERT-BOX ERROR.
             APPLY "ENTRY" TO integral.cb-cfga.ctacajame IN FRAME F-Maestro.
             RETURN NO-APPLY.      
        END.  
  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cfga.ctacajame WINDOW-1
ON LEAVE OF cb-cfga.ctacajame IN FRAME F-Maestro /* Cuenta de Caja ME */
DO:
   IF integral.cb-cfga.ctacajame:SCREEN-VALUE = "" 
   THEN DO:
       desctacajme:SCREEN-VALUE = "". 
       RETURN.
   END.
    
   IF LOOKUP(LAST-EVENT:FUNCTION,"ERROR,ENDKEY,END-KEY") <> 0 THEN RETURN.
   
   FIND integral.cb-ctas WHERE integral.cb-ctas.CodCia = Y-Codcia AND
        integral.cb-ctas.Codcta = integral.cb-cfga.ctacajame:SCREEN-VALUE
        NO-LOCK NO-ERROR.
        
   IF NOT AVAILABLE integral.cb-ctas 
   THEN DO:
       BELL.
       MESSAGE "C¢digo de Cuenta ingresado No existe" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO integral.cb-cfga.ctacajame IN FRAME F-Maestro. 
       RETURN NO-APPLY.
   END.

   
   DISPLAY integral.cb-ctas.Codcta @ integral.cb-cfga.ctacajame WITH FRAME F-maestro.  
   desctacajme:SCREEN-VALUE = integral.cb-ctas.Nomcta.    
            
   IF LENGTH(integral.cb-ctas.Codcta) <> X-Maxniv 
   THEN DO:
   BELL.
        MESSAGE "El C¢digo de Cuenta debe ser de £ltimo Nivel" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO integral.cb-cfga.ctacajame IN FRAME F-Maestro. 
        RETURN NO-APPLY.
    END.
    
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cfga.ctacajame WINDOW-1
ON MOUSE-SELECT-DBLCLICK OF cb-cfga.ctacajame IN FRAME F-Maestro /* Cuenta de Caja ME */
DO:
    APPLY "F8" TO integral.cb-cfga.ctacajame.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-cfga.ctacajamn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cfga.ctacajamn WINDOW-1
ON F8 OF cb-cfga.ctacajamn IN FRAME F-Maestro /* Cuenta de Caja MN */
DO:
    RECID-tmp = 0.
    RUN {&q-modelo2}.
    IF RECID-tmp <> 0
    THEN DO:
        FIND integral.cb-ctas
             WHERE RECID( integral.cb-ctas ) = RECID-tmp 
                        NO-LOCK  NO-ERROR.
                        
        IF AVAIL integral.cb-ctas 
                 AND LENGTH(integral.cb-ctas.Codcta) <> X-Maxniv 
        THEN DO:
            BELL.
            MESSAGE "El C¢digo de Cuenta debe ser de £ltimo Nivel" VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO integral.cb-cfga.ctacajamn IN FRAME F-Maestro. 
            RETURN NO-APPLY.
        END.
                        
        IF AVAIL integral.cb-ctas 
        THEN DO:
            DISPLAY  integral.cb-ctas.Codcta @ integral.cb-cfga.ctacajamn WITH FRAME F-maestro.
            desctacajmn:SCREEN-VALUE =  integral.cb-ctas.Nomcta.
        END.
        ELSE 
             MESSAGE "C¢digo de Cuenta ingresado No existe" VIEW-AS ALERT-BOX ERROR.
             APPLY "ENTRY" TO integral.cb-cfga.ctacajamn IN FRAME F-Maestro.
             RETURN NO-APPLY.      
        END.  
  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cfga.ctacajamn WINDOW-1
ON LEAVE OF cb-cfga.ctacajamn IN FRAME F-Maestro /* Cuenta de Caja MN */
DO:
   IF integral.cb-cfga.ctacajamn:SCREEN-VALUE = "" 
   THEN DO:
       desctacajmn:SCREEN-VALUE = "". 
       RETURN.
   END.
    
   IF LOOKUP(LAST-EVENT:FUNCTION,"ERROR,ENDKEY,END-KEY") <> 0 THEN RETURN.
   
   FIND integral.cb-ctas WHERE integral.cb-ctas.CodCia = Y-Codcia AND
        integral.cb-ctas.Codcta = integral.cb-cfga.ctacajamn:SCREEN-VALUE
        NO-LOCK NO-ERROR.
        
   IF NOT AVAILABLE integral.cb-ctas 
   THEN DO:
       BELL.
       MESSAGE "C¢digo de Cuenta ingresado No existe" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO integral.cb-cfga.ctacajamn IN FRAME F-Maestro. 
       RETURN NO-APPLY.
   END.

   
   DISPLAY integral.cb-ctas.Codcta @ integral.cb-cfga.ctacajamn WITH FRAME F-maestro.  
   desctacajmn:SCREEN-VALUE = integral.cb-ctas.Nomcta.    
            
   IF LENGTH(integral.cb-ctas.Codcta) <> X-Maxniv 
   THEN DO:
   BELL.
        MESSAGE "El C¢digo de Cuenta debe ser de £ltimo Nivel" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO integral.cb-cfga.ctacajamn IN FRAME F-Maestro. 
        RETURN NO-APPLY.
    END.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cfga.ctacajamn WINDOW-1
ON MOUSE-SELECT-DBLCLICK OF cb-cfga.ctacajamn IN FRAME F-Maestro /* Cuenta de Caja MN */
DO:
    APPLY "F8" TO integral.cb-cfga.ctacajamn.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-cfga.ctacredito
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cfga.ctacredito WINDOW-1
ON F8 OF cb-cfga.ctacredito IN FRAME F-Maestro /* Cuentas de cr‚dito */
DO:
    RECID-tmp = 0.
    RUN {&q-modelo1}.
    IF RECID-tmp <> 0
    THEN DO:
        FIND integral.cb-ctas
             WHERE RECID( integral.cb-ctas ) = RECID-tmp 
                        NO-LOCK  NO-ERROR.
        IF AVAIL integral.cb-ctas 
        THEN DO:
            DISPLAY  integral.cb-ctas.Codcta @ integral.cb-cfga.ctacredito WITH FRAME F-maestro.
            Desctacre:SCREEN-VALUE =  integral.cb-ctas.Nomcta.
        END.
        ELSE 
             MESSAGE "C¢digo de Cuenta ingresado No existe" VIEW-AS ALERT-BOX ERROR.
             APPLY "ENTRY" TO integral.cb-cfga.ctacredito IN FRAME F-Maestro.
             RETURN NO-APPLY.      
        END.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cfga.ctacredito WINDOW-1
ON LEAVE OF cb-cfga.ctacredito IN FRAME F-Maestro /* Cuentas de cr‚dito */
DO:
   IF integral.cb-cfga.ctacredito:SCREEN-VALUE = "" 
   THEN DO:
       desctacre:SCREEN-VALUE = "". 
       RETURN.
   END.
    
   IF LOOKUP(LAST-EVENT:FUNCTION,"ERROR,ENDKEY,END-KEY") <> 0 THEN RETURN.
   
   FIND integral.cb-ctas WHERE integral.cb-ctas.CodCia = Y-Codcia AND
        integral.cb-ctas.Codcta = integral.cb-cfga.ctacredito:SCREEN-VALUE
        NO-LOCK NO-ERROR.
        
   IF NOT AVAILABLE integral.cb-ctas 
   THEN DO:
       BELL.
       MESSAGE "C¢digo de Cuenta ingresado No existe" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO integral.cb-cfga.ctacredito IN FRAME F-Maestro. 
       RETURN NO-APPLY.
   END.
   
   DISPLAY integral.cb-ctas.Codcta @ integral.cb-cfga.ctacredito WITH FRAME F-maestro.  
   desctacre:SCREEN-VALUE = integral.cb-ctas.Nomcta.  
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cfga.ctacredito WINDOW-1
ON MOUSE-SELECT-DBLCLICK OF cb-cfga.ctacredito IN FRAME F-Maestro /* Cuentas de cr‚dito */
DO:
    APPLY "F8" TO integral.cb-cfga.ctacredito.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-cfga.Transf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cfga.Transf WINDOW-1
ON F8 OF cb-cfga.Transf IN FRAME F-Maestro /* Depositos/Transferencias */
DO:
   RECID-tmp = 0.
   RUN {&q-modelo3}.
   IF RECID-tmp <> 0
   THEN DO:
        FIND integral.cb-oper
             WHERE RECID( integral.cb-oper ) = RECID-tmp 
                        NO-LOCK  NO-ERROR.
        IF AVAIL integral.cb-oper
        THEN DO:
            DISPLAY integral.cb-oper.Codope @ {&cmpo4} WITH FRAME F-maestro.
            {&desc4}:SCREEN-VALUE =  integral.cb-oper.Nomope.
        END.
        ELSE 
             MESSAGE "C¢digo de Operaci¢n ingresado No existe" VIEW-AS ALERT-BOX ERROR.
             APPLY "ENTRY" TO {&cmpo4} IN FRAME F-Maestro.
             RETURN NO-APPLY.      
        END.    

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cfga.Transf WINDOW-1
ON LEAVE OF cb-cfga.Transf IN FRAME F-Maestro /* Depositos/Transferencias */
DO:
   IF {&cmpo4}:SCREEN-VALUE = "" 
   THEN DO:
       {&desc4}:SCREEN-VALUE = "". 
       RETURN.
   END.
    
   IF LOOKUP(LAST-EVENT:FUNCTION,"ERROR,ENDKEY,END-KEY") <> 0 THEN RETURN.
   /*Errores Criminales*/
   FIND integral.cb-oper WHERE integral.cb-oper.CodCia = Y-Codcia AND
        integral.cb-oper.Codope = {&cmpo4}:SCREEN-VALUE
        NO-LOCK NO-ERROR.
        
   IF NOT AVAILABLE integral.cb-oper 
   THEN DO:
       BELL.
       MESSAGE "C¢digo de Operaci¢n ingresado No existe" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO {&cmpo4} IN FRAME F-Maestro. 
       RETURN NO-APPLY.
   END.
   
   DISPLAY integral.cb-oper.Codope @ {&cmpo4} WITH FRAME F-maestro.  
   {&desc4}:SCREEN-VALUE = integral.cb-oper.Nomope.
    
  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cfga.Transf WINDOW-1
ON MOUSE-SELECT-DBLCLICK OF cb-cfga.Transf IN FRAME F-Maestro /* Depositos/Transferencias */
DO:
    APPLY "F8" TO {&cmpo4}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK WINDOW-1 


/* ***************************  Main Block  *************************** */

ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME}
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

ON CLOSE OF THIS-PROCEDURE
   RUN disable_UI.

ON WINDOW-CLOSE OF {&WINDOW-NAME} DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

ON ENDKEY, END-ERROR OF {&WINDOW-NAME} ANYWHERE DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

ON GO OF FRAME F-maestro DO:
    APPLY "CHOOSE" TO B-aceptar.
    RETURN NO-APPLY.
END.

PAUSE 0 BEFORE-HIDE.

MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
    FIND cb-cfga WHERE cb-cfga.CodCia = y-CodCia 
        AND CodCfg = 1 EXCLUSIVE NO-ERROR.
    IF NOT AVAILABLE cb-cfga THEN DO:
    CREATE cb-cfga.
           cb-cfga.CodCia = y-CodCia.
           cb-cfga.CodCfg = 1.
    END.
    RUN enable_UI.
    RUN pintado.
    IF NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI WINDOW-1 _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(WINDOW-1)
  THEN DELETE WIDGET WINDOW-1.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI WINDOW-1 _DEFAULT-ENABLE
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

  {&OPEN-QUERY-F-Maestro}
  GET FIRST F-Maestro.
  DISPLAY Desctaaho Desctacre Desctacajmn Desctacajme Desctra 
      WITH FRAME F-Maestro IN WINDOW WINDOW-1.
  IF AVAILABLE cb-cfga THEN 
    DISPLAY cb-cfga.ctaahorro cb-cfga.ctacredito cb-cfga.ctacajamn 
          cb-cfga.ctacajame cb-cfga.cjaChc cb-cfga.cjaEgr cb-cfga.cjaIng 
          cb-cfga.Transf 
      WITH FRAME F-Maestro IN WINDOW WINDOW-1.
  ENABLE RECT-4 RECT-5 RECT-6 BUTTON-1 
      WITH FRAME F-Maestro IN WINDOW WINDOW-1.
  {&OPEN-BROWSERS-IN-QUERY-F-Maestro}
  VIEW WINDOW-1.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pintado WINDOW-1 
PROCEDURE pintado :
IF integral.cb-cfga.ctaahorro <> "" THEN DO:
        FIND integral.cb-ctas WHERE integral.cb-ctas.CodCia = Y-Codcia AND
            integral.cb-ctas.Codcta = integral.cb-cfga.ctaahorro
            NO-LOCK NO-ERROR.
        IF AVAIL integral.cb-ctas THEN
            ASSIGN
                integral.cb-cfga.ctaahorro:SCREEN-VALUE IN FRAME F-maestro
                    = integral.cb-ctas.Codcta
                desctaaho:SCREEN-VALUE = integral.cb-ctas.Nomcta.
    END.

    IF integral.cb-cfga.ctacredito <> "" THEN DO:
        FIND integral.cb-ctas WHERE integral.cb-ctas.CodCia = Y-Codcia AND
            integral.cb-ctas.Codcta = integral.cb-cfga.ctacredito
            NO-LOCK NO-ERROR.
        IF AVAIL integral.cb-ctas THEN
            ASSIGN
                integral.cb-cfga.ctacredito:SCREEN-VALUE = integral.cb-ctas.Codcta
                desctacre:SCREEN-VALUE = integral.cb-ctas.Nomcta.
    END.
       
    IF integral.cb-cfga.ctacajamn <> "" THEN DO:
        FIND integral.cb-ctas WHERE integral.cb-ctas.CodCia = Y-Codcia AND
            integral.cb-ctas.Codcta = integral.cb-cfga.ctacajamn
            NO-LOCK NO-ERROR.
        IF AVAIL integral.cb-ctas THEN
            ASSIGN
                integral.cb-cfga.ctacajamn:SCREEN-VALUE = integral.cb-ctas.Codcta
                desctacajmn:SCREEN-VALUE = integral.cb-ctas.Nomcta.
    END.
     
    IF integral.cb-cfga.ctacajame <> "" THEN DO:
        FIND integral.cb-ctas WHERE integral.cb-ctas.CodCia = Y-Codcia AND
            integral.cb-ctas.Codcta = integral.cb-cfga.ctacajame
            NO-LOCK NO-ERROR.
        IF AVAIL integral.cb-ctas THEN
            ASSIGN
                integral.cb-cfga.ctacajame:SCREEN-VALUE = integral.cb-ctas.Codcta
                desctacajme:SCREEN-VALUE = integral.cb-ctas.Nomcta.
    END. 

    
    IF {&cmpo4} <> "" THEN DO:   
        FIND integral.cb-oper WHERE integral.cb-ctas.CodCia = Y-Codcia AND
            integral.cb-oper.Codope = {&cmpo4}:SCREEN-VALUE
            NO-LOCK NO-ERROR.
        IF AVAIL integral.cb-oper THEN
            ASSIGN
                {&cmpo4}:SCREEN-VALUE = integral.cb-oper.Codope
                {&desc4}:SCREEN-VALUE = integral.cb-oper.Nomope.
    END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


