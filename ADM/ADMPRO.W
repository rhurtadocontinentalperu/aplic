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

DEFINE VARIABLE RECID-stack AS RECID NO-UNDO.
DEFINE VARIABLE RECID-tmp   AS RECID NO-UNDO.
DEFINE VARIABLE pto AS LOGICAL.
pto = SESSION:SET-WAIT-STATE("").

DEFINE {&NEW} SHARED VARIABLE  s-codcia AS INTEGER.
DEFINE VARIABLE pv-codcia AS INTEGER INITIAL 0.

FIND Empresas WHERE Empresas.CodCia = s-codcia.
IF NOT Empresas.Campo-CodPro THEN pv-codcia = s-codcia.

/*   C A M B I O S   E N    L O S   P R E - P R O C E S A D O R E S */

/* Solo muestra los registros que cumplan con la condici¢n : */
&Scoped-define RECORD-SCOPE gn-prov.CodCia = pv-codcia

/* Como Buscar un Registro en la Tabla ( Para Crear, modificar, anular etc.) */
&Scoped-define SEARCH-KEY gn-prov.CodPro = gn-prov.CodPro:SCREEN-VALUE IN FRAME F-maestro

/* Campos Ocultos que deben ser asignados en cada modificaci¢n */
&Scoped-define ASSIGN-ADD gn-prov.CodCia = pv-codcia

/* Campos que no pueden ser modificados */
&Scoped-define NO-MODIFY gn-prov.CodPro

/* Programa donde relaizara la Consulta */
&Scoped-define q-modelo adm/q-prov.w ( pv-codcia, OUTPUT RECID-stack )

/* Campos por los cuales se puede hacer Busquedas */
&Scoped-define Query-Field gn-prov.CodPro gn-prov.NomPro

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-add

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES gn-prov

/* Definitions for FRAME F-maestro                                      */
&Scoped-define FIELDS-IN-QUERY-F-maestro gn-prov.CodPro gn-prov.NomPro ~
gn-prov.DirPro gn-prov.Ruc gn-prov.FaxPro gn-prov.TpoPro gn-prov.Codpos ~
gn-prov.Fching 
&Scoped-define ENABLED-FIELDS-IN-QUERY-F-maestro gn-prov.CodPro ~
gn-prov.NomPro gn-prov.DirPro gn-prov.Ruc gn-prov.FaxPro gn-prov.TpoPro ~
&Scoped-define ENABLED-TABLES-IN-QUERY-F-maestro gn-prov
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-F-maestro gn-prov

&Scoped-define FIELD-PAIRS-IN-QUERY-F-maestro~
 ~{&FP1}CodPro ~{&FP2}CodPro ~{&FP3}~
 ~{&FP1}NomPro ~{&FP2}NomPro ~{&FP3}~
 ~{&FP1}DirPro ~{&FP2}DirPro ~{&FP3}~
 ~{&FP1}Ruc ~{&FP2}Ruc ~{&FP3}~
 ~{&FP1}FaxPro ~{&FP2}FaxPro ~{&FP3}~
 ~{&FP1}TpoPro ~{&FP2}TpoPro ~{&FP3}~
 ~{&FP1}Codpos ~{&FP2}Codpos ~{&FP3}~
 ~{&FP1}Fching ~{&FP2}Fching ~{&FP3}
&Scoped-define OPEN-QUERY-F-maestro OPEN QUERY F-maestro FOR EACH gn-prov SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-F-maestro gn-prov
&Scoped-define FIRST-TABLE-IN-QUERY-F-maestro gn-prov


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
     LABEL "&Query":L 
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

DEFINE RECTANGLE R-maestro1
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 86.86 BY 6
     BGCOLOR 8 FGCOLOR 15 .

DEFINE RECTANGLE R-maestro2
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 86.86 BY 6.5
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
      gn-prov SCROLLING.
&ANALYZE-RESUME

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
     B-query AT ROW 1.5 COL 2
     B-add AT ROW 1.5 COL 13
     B-update AT ROW 1.5 COL 23
     B-delete AT ROW 1.5 COL 33
     B-first AT ROW 1.5 COL 46
     B-prev AT ROW 1.5 COL 52
     B-next AT ROW 1.5 COL 58
     B-last AT ROW 1.5 COL 64
     B-browse AT ROW 1.27 COL 72
     B-exit AT ROW 1.5 COL 82
     R-query AT ROW 1 COL 1
     R-modify AT ROW 1 COL 11
     R-navigaate AT ROW 1 COL 44
     R-consulta AT ROW 1 COL 70
     R-exit AT ROW 1 COL 80
    WITH 1 DOWN OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 14.61
         SIZE 90.86 BY 2.08
         BGCOLOR 8 FGCOLOR 0 FONT 4.

DEFINE FRAME F-maestro
     gn-prov.CodPro AT ROW 2.5 COL 32 COLON-ALIGNED
          LABEL "C¢digo"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 15 
     gn-prov.NomPro AT ROW 3.5 COL 32 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 44.29 BY .81
          BGCOLOR 15 
     gn-prov.DirPro AT ROW 5 COL 32 COLON-ALIGNED
          LABEL "Direcci¢n"
          VIEW-AS FILL-IN 
          SIZE 52.86 BY .81
          BGCOLOR 15 
     gn-prov.Ruc AT ROW 6 COL 32 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 15 
     gn-prov.FaxPro AT ROW 8.5 COL 29 COLON-ALIGNED
          LABEL "Tel‚fono"
          VIEW-AS FILL-IN 
          SIZE 26 BY .81
          BGCOLOR 15 
     gn-prov.TpoPro AT ROW 10 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4 BY .81
          BGCOLOR 15 
     gn-prov.Codpos AT ROW 11.5 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 15 
     gn-prov.Fching AT ROW 12.5 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
          BGCOLOR 15 
     R-maestro1 AT ROW 1.5 COL 3
     "Informaci¢n General" VIEW-AS TEXT
          SIZE 18 BY .77 AT ROW 2 COL 4
          BGCOLOR 8 FGCOLOR 0 FONT 4
     R-maestro2 AT ROW 7.5 COL 3
    WITH 1 DOWN NO-BOX OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 1
         SIZE 90.86 BY 13.62
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
         TITLE              = "Informaci¢n del Proveedor"
         COLUMN             = 1
         ROW                = 1
         HEIGHT             = 15.69
         WIDTH              = 90.86
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
   UNDERLINE Default                                                    */
/* SETTINGS FOR FILL-IN gn-prov.CodPro IN FRAME F-maestro
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-prov.DirPro IN FRAME F-maestro
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-prov.FaxPro IN FRAME F-maestro
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
     _TblList          = "integral.gn-prov"
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
          RECID-stack = RECID ( {&FIRST-TABLE-IN-QUERY-F-maestro} ).
          ENABLE {&FIELDS-IN-QUERY-F-maestro} WITH FRAME F-maestro.
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
     IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN  DO:
              DISPLAY {&FIELDS-IN-QUERY-F-maestro} WITH FRAME f-maestro.
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
            MESSAGE "Eliminar el Registro"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE selection AS LOGICAL.
            IF selection THEN DO:
                   DELETE  {&FIRST-TABLE-IN-QUERY-F-maestro}.
            END.
            ELSE
                FIND {&FIRST-TABLE-IN-QUERY-F-maestro}
                    WHERE  RECID-Tmp = RECID(  {&FIRST-TABLE-IN-QUERY-F-maestro} )
                        NO-LOCK NO-ERROR.
        END.
        ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
        BUTTONS OK.  
    END.

    IF NOT AVAIL  {&FIRST-TABLE-IN-QUERY-F-maestro} THEN DO:
        FIND PREV  {&FIRST-TABLE-IN-QUERY-F-maestro}
        &IF "{&RECORD-SCOPE}" <> "" &THEN
            WHERE {&RECORD-SCOPE}
        &ENDIF
        NO-LOCK NO-ERROR.
        IF NOT AVAIL  {&FIRST-TABLE-IN-QUERY-F-maestro}
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
           {&SEARCH-KEY} ) THEN DO:
           MESSAGE "Registro Existente" VIEW-AS ALERT-BOX ERROR.
           APPLY "ENTRY" TO gn-prov.CodPro IN FRAME F-maestro.
           RETURN NO-APPLY.
     END.  

     ASSIGN FRAME F-Maestro
     {&FIELDS-IN-QUERY-F-maestro}
     {&ASSIGN-ADD}.
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
  ASSIGN FRAME F-maestro
  {&FIELDS-IN-QUERY-F-maestro}
  {&ASSIGN-ADD}
  .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-search
&Scoped-define SELF-NAME B-ok-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-ok-3 W-maestro
ON CHOOSE OF B-ok-3 IN FRAME F-search /* Aceptar */
DO:
    IF gn-prov.CodPro:SCREEN-VALUE IN FRAME F-maestro <> "" THEN DO:
         FIND FIRST  {&FIRST-TABLE-IN-QUERY-F-maestro}
              WHERE 
                  &IF "{&RECORD-SCOPE}" <> "" &THEN
                      {&RECORD-SCOPE} AND
                  &ENDIF
                  gn-prov.CodPro = gn-prov.CodPro:SCREEN-VALUE IN FRAME F-maestro
                   NO-LOCK NO-ERROR.
         ASSIGN gn-prov.NomPro:SCREEN-VALUE = "".
    END.

    IF gn-prov.NomPro:SCREEN-VALUE IN FRAME F-maestro <> "" THEN DO:
         FIND FIRST  {&FIRST-TABLE-IN-QUERY-F-maestro}
              WHERE 
                  &IF "{&RECORD-SCOPE}" <> "" &THEN
                      {&RECORD-SCOPE} AND
                  &ENDIF
                  gn-prov.NomPro BEGINS gn-prov.NomPro:SCREEN-VALUE IN FRAME F-maestro
                   NO-LOCK NO-ERROR.
         ASSIGN gn-prov.CodPro:SCREEN-VALUE = "".
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

     CLEAR FRAME F-maestro.
     FRAME F-ctrl-frame:VISIBLE = FALSE.
     FRAME F-search:VISIBLE = TRUE.
      
     ENABLE {&QUERY-field}  WITH FRAME F-maestro.

     WAIT-FOR  "CHOOSE" OF b-ok-3 IN FRAME f-search
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
    FRAME f-ctrl-frame:VISIBLE = FALSE.
    FRAME f-update:VISIBLE = TRUE.
    RECID-stack = RECID( {&FIRST-TABLE-IN-QUERY-F-maestro} ).
    DO TRANSACTION ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        FIND {&FIRST-TABLE-IN-QUERY-F-maestro}
            WHERE RECID-stack = RECID( {&FIRST-TABLE-IN-QUERY-F-maestro} )
                EXCLUSIVE NO-ERROR.
        IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN DO:
            ENABLE {&FIELDS-IN-QUERY-F-maestro} WITH FRAME F-maestro.
            DISABLE {&NO-MODIFY} WITH FRAME F-maestro.
            WAIT-FOR CHOOSE OF b-ok-2 OR CHOOSE OF B-CANCEL-2 IN FRAME f-UPDATE.
        END.
        ELSE MESSAGE "No exiten Registros." VIEW-AS ALERT-BOX ERROR
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
    ELSE
        CLEAR FRAME F-maestro.
    DISABLE {&FIELDS-IN-QUERY-F-maestro} WITH FRAME F-maestro.
    FRAME f-update:VISIBLE = FALSE.
    FRAME F-ctrl-frame:VISIBLE = TRUE.
     
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
  IF AVAILABLE gn-prov THEN 
    DISPLAY gn-prov.CodPro gn-prov.NomPro gn-prov.DirPro gn-prov.Ruc 
          gn-prov.FaxPro gn-prov.TpoPro gn-prov.Codpos gn-prov.Fching 
      WITH FRAME F-maestro IN WINDOW W-maestro.
  ENABLE R-maestro1 R-maestro2 gn-prov.CodPro gn-prov.NomPro gn-prov.DirPro 
         gn-prov.Ruc gn-prov.FaxPro gn-prov.TpoPro gn-prov.Codpos 
         gn-prov.Fching 
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


