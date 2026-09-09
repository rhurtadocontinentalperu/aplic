&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-master
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-master 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 07/14/95 -  8:37 am

------------------------------------------------------------------------*/

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE SHARED VARIABLE s-codcia  AS INTEGER.
DEFINE SHARED VARIABLE cb-codcia AS INTEGER.
DEFINE {&NEW} SHARED VARIABLE s-periodo          AS INTEGER INITIAL 1996.
DEFINE {&NEW} SHARED VARIABLE s-NroMes          AS INTEGER INITIAL 9.
DEFINE {&NEW} SHARED VARIABLE s-user-id       AS CHARACTER INITIAL "MASTER".
DEFINE {&NEW} SHARED VARIABLE cb-niveles AS CHARACTER INITIAL "2,3,5".
DEFINE SHARED VAR s-NomCia AS CHAR.

DEFINE VARIABLE pto       AS LOGICAL.
DEFINE VARIABLE RegAct    AS RECID.
DEFINE VARIABLE RECID-tmp AS RECID.
DEFINE VARIABLE Maxnivel  AS INTEGER.
DEFINE VARIABLE i         AS INTEGER.
DEFINE VARIABLE y-CodCia  AS INTEGER INITIAL 0.
DEFINE VARIABLE x-saldoIS AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-".
DEFINE VARIABLE x-saldoCS AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-".
DEFINE VARIABLE x-saldoAS AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-".
DEFINE VARIABLE x-saldoSS AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-".
DEFINE VARIABLE x-saldoID AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-".
DEFINE VARIABLE x-saldoCD AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-".
DEFINE VARIABLE x-saldoAD AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-".
DEFINE VARIABLE x-saldoSD AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-".

FIND Empresas WHERE Empresas.CodCia = s-codcia.
IF NOT Empresas.Campo-CodCbd THEN y-CodCia = s-codcia.

/* Buscamos las configuraciones del Sistema Contable */
FIND cb-cfga WHERE cb-cfga.CodCia = y-CodCia
               AND cb-cfga.CodCfg = 1 NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-cfga
THEN DO:
    BELL.
    MESSAGE "NO SE HA CONFIGURADO EL SISTEMA CONTABLE"
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

Maxnivel = NUM-ENTRIES ( cb-niveles ).
Maxnivel = INTEGER ( ENTRY ( Maxnivel, cb-niveles ) ).
pto      = SESSION:SET-WAIT-STATE("").

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-maestro
&Scoped-define BROWSE-NAME BRW-dolares

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES cb-ctas

/* Definitions for BROWSE BRW-dolares                                   */
&Scoped-define FIELDS-IN-QUERY-BRW-dolares (x-saldoID) (x-saldoCD) ~
(x-saldoAD) (x-saldoSD) cb-ctas.Nomcta cb-ctas.Codcta 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BRW-dolares 
&Scoped-define QUERY-STRING-BRW-dolares FOR EACH cb-ctas ~
      WHERE cb-ctas.CodCia = cb-CodCia AND ~
 LENGTH(cb-ctas.Codcta) = Maxnivel AND ~
 ( cb-ctas.Codcta BEGINS cb-cfga.ctacredito OR ~
 cb-ctas.Codcta BEGINS cb-cfga.ctaahorro ) AND ~
 cb-ctas.codmon = 2 AND ~
 cb-ctas.activo = TRUE NO-LOCK
&Scoped-define OPEN-QUERY-BRW-dolares OPEN QUERY BRW-dolares FOR EACH cb-ctas ~
      WHERE cb-ctas.CodCia = cb-CodCia AND ~
 LENGTH(cb-ctas.Codcta) = Maxnivel AND ~
 ( cb-ctas.Codcta BEGINS cb-cfga.ctacredito OR ~
 cb-ctas.Codcta BEGINS cb-cfga.ctaahorro ) AND ~
 cb-ctas.codmon = 2 AND ~
 cb-ctas.activo = TRUE NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BRW-dolares cb-ctas
&Scoped-define FIRST-TABLE-IN-QUERY-BRW-dolares cb-ctas


/* Definitions for BROWSE BRW-soles                                     */
&Scoped-define FIELDS-IN-QUERY-BRW-soles (x-saldoIS) (x-saldoCS) ~
(x-saldoAS) (x-saldoSS) cb-ctas.Nomcta cb-ctas.Codcta 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BRW-soles 
&Scoped-define QUERY-STRING-BRW-soles FOR EACH cb-ctas ~
      WHERE cb-ctas.CodCia = cb-CodCia AND ~
LENGTH(cb-ctas.Codcta) = Maxnivel AND ~
 ( cb-ctas.Codcta BEGINS cb-cfga.ctacredito OR ~
 cb-ctas.Codcta BEGINS cb-cfga.ctaahorro ) AND ~
 cb-ctas.Codmon = 1 AND ~
 cb-ctas.activo = TRUE  NO-LOCK
&Scoped-define OPEN-QUERY-BRW-soles OPEN QUERY BRW-soles FOR EACH cb-ctas ~
      WHERE cb-ctas.CodCia = cb-CodCia AND ~
LENGTH(cb-ctas.Codcta) = Maxnivel AND ~
 ( cb-ctas.Codcta BEGINS cb-cfga.ctacredito OR ~
 cb-ctas.Codcta BEGINS cb-cfga.ctaahorro ) AND ~
 cb-ctas.Codmon = 1 AND ~
 cb-ctas.activo = TRUE  NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BRW-soles cb-ctas
&Scoped-define FIRST-TABLE-IN-QUERY-BRW-soles cb-ctas


/* Definitions for FRAME F-maestro                                      */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-maestro ~
    ~{&OPEN-QUERY-BRW-dolares}~
    ~{&OPEN-QUERY-BRW-soles}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS R-maestro2 R-maestro3 R-maestro1 BRW-soles ~
BRW-dolares B-Imprimir B-salir 
&Scoped-Define DISPLAYED-OBJECTS x-totsiS x-totcS x-totaS x-totsS x-totsiD ~
x-totcD x-totaD x-totsD x-pintames x-pinta_ano 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-master AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-Imprimir 
     LABEL "Imprimir" 
     SIZE 15 BY .96.

DEFINE BUTTON B-salir AUTO-END-KEY 
     LABEL "&Salir" 
     SIZE 10.29 BY .96.

DEFINE VARIABLE x-pintames AS CHARACTER FORMAT "X(15)":U 
     VIEW-AS FILL-IN 
     SIZE 18 BY .69
     FONT 0 NO-UNDO.

DEFINE VARIABLE x-pinta_ano AS INTEGER FORMAT "Z,ZZZ":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9 BY .69
     BGCOLOR 8 FONT 0 NO-UNDO.

DEFINE VARIABLE x-totaD AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE x-totaS AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .62
     FONT 4 NO-UNDO.

DEFINE VARIABLE x-totcD AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14.57 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE x-totcS AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14.57 BY .62
     FONT 4 NO-UNDO.

DEFINE VARIABLE x-totsD AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14.57 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE x-totsiD AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     FONT 4 NO-UNDO.

DEFINE VARIABLE x-totsiS AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .62
     FONT 4 NO-UNDO.

DEFINE VARIABLE x-totsS AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14.57 BY .62
     FONT 4 NO-UNDO.

DEFINE RECTANGLE R-maestro1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 87.57 BY 6.23
     BGCOLOR 8 .

DEFINE RECTANGLE R-maestro2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 87.57 BY 6.38
     BGCOLOR 8 .

DEFINE RECTANGLE R-maestro3
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 87.57 BY 1.77
     BGCOLOR 8 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BRW-dolares FOR 
      cb-ctas SCROLLING.

DEFINE QUERY BRW-soles FOR 
      cb-ctas SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BRW-dolares
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BRW-dolares W-master _STRUCTURED
  QUERY BRW-dolares NO-LOCK DISPLAY
      (x-saldoID) COLUMN-LABEL "Saldo Inicial" FORMAT "ZZZ,ZZZ,ZZ9.99-":U
      (x-saldoCD) COLUMN-LABEL "Cargo" FORMAT "ZZZ,ZZZ,ZZ9.99-":U
      (x-saldoAD) COLUMN-LABEL "Abono" FORMAT "ZZZ,ZZZ,ZZ9.99-":U
      (x-saldoSD) COLUMN-LABEL "Saldo" FORMAT "ZZZ,ZZZ,ZZ9.99-":U
      cb-ctas.Nomcta FORMAT "x(40)":U
      cb-ctas.Codcta FORMAT "x(10)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 85.86 BY 4.96
         FONT 4
         TITLE "D¢lares".

DEFINE BROWSE BRW-soles
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BRW-soles W-master _STRUCTURED
  QUERY BRW-soles NO-LOCK DISPLAY
      (x-saldoIS) COLUMN-LABEL "Saldo Inicial" FORMAT "ZZZ,ZZZ,ZZ9.99-":U
      (x-saldoCS) COLUMN-LABEL "Cargo" FORMAT "ZZZ,ZZZ,ZZ9.99-":U
      (x-saldoAS) COLUMN-LABEL "Abono" FORMAT "ZZZ,ZZZ,ZZ9.99-":U
      (x-saldoSS) COLUMN-LABEL "Saldo" FORMAT "ZZZ,ZZZ,ZZ9.99-":U
      cb-ctas.Nomcta FORMAT "x(40)":U
      cb-ctas.Codcta FORMAT "x(10)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 86.14 BY 4.96
         FONT 4
         TITLE "Soles".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-maestro
     BRW-soles AT ROW 1.23 COL 1.57
     x-totsiS AT ROW 6.31 COL 1.57 NO-LABEL
     x-totcS AT ROW 6.31 COL 14.57 COLON-ALIGNED NO-LABEL
     x-totaS AT ROW 6.31 COL 30.57 COLON-ALIGNED NO-LABEL
     x-totsS AT ROW 6.31 COL 45.57 COLON-ALIGNED NO-LABEL
     BRW-dolares AT ROW 7.42 COL 1.57
     x-totsiD AT ROW 12.5 COL 2.43 NO-LABEL
     x-totcD AT ROW 12.5 COL 15.43 COLON-ALIGNED NO-LABEL
     x-totaD AT ROW 12.5 COL 31.43 COLON-ALIGNED NO-LABEL
     x-totsD AT ROW 12.5 COL 46.43 COLON-ALIGNED NO-LABEL
     B-Imprimir AT ROW 14.12 COL 60
     B-salir AT ROW 14.12 COL 76.29
     x-pintames AT ROW 14.15 COL 10 COLON-ALIGNED NO-LABEL
     x-pinta_ano AT ROW 14.15 COL 29 COLON-ALIGNED NO-LABEL
     "<-- Totales" VIEW-AS TEXT
          SIZE 14 BY .62 AT ROW 6.35 COL 66.72
          FONT 4
     "<-- Totales" VIEW-AS TEXT
          SIZE 13 BY .62 AT ROW 12.5 COL 70
     R-maestro2 AT ROW 7.27 COL 1
     R-maestro3 AT ROW 13.58 COL 1
     R-maestro1 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 87.72 BY 14.35
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
  CREATE WINDOW W-master ASSIGN
         HIDDEN             = YES
         TITLE              = "Consulta de Bancos"
         COLUMN             = 2
         ROW                = 1.88
         HEIGHT             = 14.5
         WIDTH              = 88
         MAX-HEIGHT         = 16.73
         MAX-WIDTH          = 91.43
         VIRTUAL-HEIGHT     = 16.73
         VIRTUAL-WIDTH      = 91.43
         RESIZE             = yes
         SCROLL-BARS        = yes
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         FONT               = 4
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-master 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-master
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-maestro
                                                                        */
/* BROWSE-TAB BRW-soles R-maestro1 F-maestro */
/* BROWSE-TAB BRW-dolares x-totsS F-maestro */
ASSIGN 
       BRW-dolares:NUM-LOCKED-COLUMNS IN FRAME F-maestro     = 1.

ASSIGN 
       BRW-soles:NUM-LOCKED-COLUMNS IN FRAME F-maestro     = 1.

/* SETTINGS FOR FILL-IN x-pintames IN FRAME F-maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-pinta_ano IN FRAME F-maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-totaD IN FRAME F-maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-totaS IN FRAME F-maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-totcD IN FRAME F-maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-totcS IN FRAME F-maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-totsD IN FRAME F-maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-totsiD IN FRAME F-maestro
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN x-totsiS IN FRAME F-maestro
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN x-totsS IN FRAME F-maestro
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-master)
THEN W-master:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BRW-dolares
/* Query rebuild information for BROWSE BRW-dolares
     _TblList          = "integral.cb-ctas"
     _Options          = "NO-LOCK"
     _Where[1]         = "cb-ctas.CodCia = cb-CodCia AND
 LENGTH(cb-ctas.Codcta) = Maxnivel AND
 ( cb-ctas.Codcta BEGINS cb-cfga.ctacredito OR
 cb-ctas.Codcta BEGINS cb-cfga.ctaahorro ) AND
 cb-ctas.codmon = 2 AND
 cb-ctas.activo = TRUE"
     _FldNameList[1]   > "_<CALC>"
"(x-saldoID)" "Saldo Inicial" "ZZZ,ZZZ,ZZ9.99-" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"(x-saldoCD)" "Cargo" "ZZZ,ZZZ,ZZ9.99-" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"(x-saldoAD)" "Abono" "ZZZ,ZZZ,ZZ9.99-" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"(x-saldoSD)" "Saldo" "ZZZ,ZZZ,ZZ9.99-" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = integral.cb-ctas.Nomcta
     _FldNameList[6]   = integral.cb-ctas.Codcta
     _Query            is OPENED
*/  /* BROWSE BRW-dolares */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BRW-soles
/* Query rebuild information for BROWSE BRW-soles
     _TblList          = "integral.cb-ctas"
     _Options          = "NO-LOCK"
     _Where[1]         = "cb-ctas.CodCia = cb-CodCia AND
LENGTH(cb-ctas.Codcta) = Maxnivel AND
 ( cb-ctas.Codcta BEGINS cb-cfga.ctacredito OR
 cb-ctas.Codcta BEGINS cb-cfga.ctaahorro ) AND
 cb-ctas.Codmon = 1 AND
 cb-ctas.activo = TRUE "
     _FldNameList[1]   > "_<CALC>"
"(x-saldoIS)" "Saldo Inicial" "ZZZ,ZZZ,ZZ9.99-" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"(x-saldoCS)" "Cargo" "ZZZ,ZZZ,ZZ9.99-" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"(x-saldoAS)" "Abono" "ZZZ,ZZZ,ZZ9.99-" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"(x-saldoSS)" "Saldo" "ZZZ,ZZZ,ZZ9.99-" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = integral.cb-ctas.Nomcta
     _FldNameList[6]   = integral.cb-ctas.Codcta
     _Query            is OPENED
*/  /* BROWSE BRW-soles */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME B-Imprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Imprimir W-master
ON CHOOSE OF B-Imprimir IN FRAME F-maestro /* Imprimir */
DO:
  RUN IMPRIMIR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BRW-dolares
&Scoped-define SELF-NAME BRW-dolares
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BRW-dolares W-master
ON MOUSE-SELECT-DBLCLICK OF BRW-dolares IN FRAME F-maestro /* D¢lares */
DO:
    /*IF QUERY-OFF-END("BRW-dolares") THEN RETURN.*/
    RUN cja/cjacons2.w( integral.cb-ctas.CodCta, y-codcia, Maxnivel, "D¢lares" ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BRW-dolares W-master
ON RETURN OF BRW-dolares IN FRAME F-maestro /* D¢lares */
DO:
    IF QUERY-OFF-END("BRW-dolares") THEN RETURN.
    RUN cja/cjacons2.w( integral.cb-ctas.CodCta, y-codcia, Maxnivel, "D¢lares" ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BRW-soles
&Scoped-define SELF-NAME BRW-soles
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BRW-soles W-master
ON MOUSE-SELECT-DBLCLICK OF BRW-soles IN FRAME F-maestro /* Soles */
DO:
    /*IF QUERY-OFF-END("BRW-soles") THEN RETURN.*/
    RUN cja/cjacons2.w( integral.cb-ctas.CodCta, y-codcia, Maxnivel, "Soles" ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BRW-soles W-master
ON RETURN OF BRW-soles IN FRAME F-maestro /* Soles */
DO:
    IF QUERY-OFF-END("BRW-soles") THEN RETURN.
    RUN cja/cjacons2.w( integral.cb-ctas.CodCta, y-codcia, Maxnivel, "Soles" ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BRW-dolares
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-master 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
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

ON FIND OF cb-ctas
DO:
   FIND FIRST cb-acmd WHERE cb-acmd.CodCia = s-codcia AND
                      cb-acmd.Periodo = s-periodo AND
                      cb-acmd.CodCta  BEGINS cb-ctas.Codcta AND
                      cb-acmd.CodDiv  BEGINS "" NO-LOCK NO-ERROR.
   x-saldoIS = 0.
   x-saldoCS = 0.
   x-saldoAS = 0.
   x-saldoSS = 0.
   x-saldoID = 0.
   x-saldoCD = 0.
   x-saldoAD = 0.
   x-saldoSD = 0.                   
   IF NOT AVAILABLE cb-acmd THEN RETURN.
   
   FOR EACH cb-acmd WHERE cb-acmd.CodCia    = s-codcia AND
                          cb-acmd.Periodo   = s-periodo AND
                          cb-acmd.CodCta    BEGINS cb-ctas.Codcta AND
                          cb-acmd.CodDiv    BEGINS "" NO-LOCK :   
       DO i = 1 TO s-NroMes:
          x-saldoIS = x-saldoIS + ( DbeMn1[i] - HbeMn1[i] ).
          x-saldoID = x-saldoID + ( DbeMn2[i] - HbeMn2[i] ).
       END.
       
       x-saldoCS = x-saldoCS + DbeMn1[s-NroMes + 1 ].
       x-saldoAS = x-saldoAS + HbeMn1[s-NroMes + 1 ].
       x-saldoSS = x-saldoSS + x-saldoIS + ( x-saldoCS - x-saldoAS ).
       x-saldoCD = x-saldoCD + DbeMn2[s-NroMes + 1 ].
       x-saldoAD = x-saldoAD + HbeMn2[s-NroMes + 1 ].
       x-saldoSD = x-saldoSD + x-saldoID + ( x-saldoCD - x-saldoAD ).
   END.
END.   

PAUSE 0 BEFORE-HIDE.

MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
    RUN enable_UI.
    RUN bin/_mes.p ( INPUT s-NroMes, 3 , OUTPUT x-pintames).
    x-pinta_ano = s-periodo.
    
    {&OPEN-QUERY-BRW-soles}
    
    {&OPEN-QUERY-BRW-dolares}
       
    RUN calcula.
    
    DISPLAY x-totaD x-totaS x-totcD x-totcS x-totsD x-totsiD x-totsiS x-totsS 
            x-pintames x-pinta_ano WITH FRAME F-maestro.
    IF NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calcula W-master 
PROCEDURE Calcula :
GET FIRST BRW-dolares NO-LOCK.

DO WHILE AVAIL ( integral.cb-ctas):
    x-totaD = x-totaD + x-saldoAD.
    x-totcD = x-totcD + x-saldoCD.
    x-totsD = x-totsD + x-saldoSD.
    x-totsiD = x-totsiD + x-saldoID.
    GET NEXT BRW-dolares NO-LOCK.
END.

GET FIRST BRW-soles NO-LOCK.

DO WHILE AVAIL ( integral.cb-ctas):
    x-totaS = x-totaS + x-saldoAS.
    x-totcS = x-totcS + x-saldoCS.
    x-totsS = x-totsS + x-saldoSS.
    x-totsiS = x-totsiS + x-saldoIS.
    GET NEXT BRW-soles NO-LOCK.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-master  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-master)
  THEN DELETE WIDGET W-master.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-master  _DEFAULT-ENABLE
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
  DISPLAY x-totsiS x-totcS x-totaS x-totsS x-totsiD x-totcD x-totaD x-totsD 
          x-pintames x-pinta_ano 
      WITH FRAME F-maestro IN WINDOW W-master.
  ENABLE R-maestro2 R-maestro3 R-maestro1 BRW-soles BRW-dolares B-Imprimir 
         B-salir 
      WITH FRAME F-maestro IN WINDOW W-master.
  {&OPEN-BROWSERS-IN-QUERY-F-maestro}
  VIEW W-master.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPRIMIR W-master 
PROCEDURE IMPRIMIR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.   
       
    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

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
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5a} + CHR(66) + {&Prn3}.
        RUN REPORTE.
        PAGE STREAM REPORT.
        OUTPUT STREAM REPORT CLOSE.
    END.
    OUTPUT STREAM REPORT CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            FRAME {&FRAME-NAME}:SENSITIVE = FALSE.
            RUN LIB/W-README.R(s-print-file).
            FRAME {&FRAME-NAME}:SENSITIVE = TRUE.
            IF s-salida-impresion = 1 THEN
                OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE REPORTE W-master 
PROCEDURE REPORTE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR fIImport AS DECIMAL FORMAT "ZZ,ZZZ,ZZ9.99-" EXTENT 4.
  DEFINE VAR iCodMon  AS INTEGER.
  DEFINE VAR sCodMon  AS CHAR.

  DEFINE FRAME f-cab
         cb-ctas.CodCta COLUMN-LABEL "Cuenta!Contable"
         cb-ctas.NomCta FORMAT "X(35)" COLUMN-LABEL "Descripción de Cuenta"
         fIImport[1] COLUMN-LABEL "Saldo!Inicial"
         fIImport[2] COLUMN-LABEL "Cargos"
         fIImport[3] COLUMN-LABEL "Abonos"
         fIImport[4] COLUMN-LABEL "Saldo!Final"
  HEADER
         s-NomCia SKIP  
         "CONSULTA DE BANCOS" SKIP
         TODAY "-" STRING(TIME,"HH:MM:SS")
         SKIP(2)
  WITH WIDTH 120 NO-BOX DOWN STREAM-IO.

/*MLR* 15/11/07 ***
  CASE s-salida-impresion:
       WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
       WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
       WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
  END CASE.
  
 PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5a} + CHR(66) + {&Prn3}.
* ***/

 FOR EACH CB-CTAS WHERE cb-ctas.CodCia = cb-CodCia AND
                        LENGTH(cb-ctas.Codcta) = Maxnivel AND
                        ( cb-ctas.Codcta BEGINS cb-cfga.ctacredito OR
                        cb-ctas.Codcta BEGINS cb-cfga.ctaahorro ) AND
                        cb-ctas.activo = TRUE  
                        BREAK BY cb-ctas.Codmon BY cb-ctas.CodCta :
                        
     IF FIRST-OF (cb-ctas.Codmon) THEN DO :
        iCodMon = cb-ctas.Codmon.
        
        IF iCodMon = 1 THEN sCodMon = "NUEVOS SOLES (S/.)".
           ELSE sCodMon = "DOLARES AMERICANOS (US$.)".
           
        DOWN STREAM REPORT WITH FRAME F-CAB.    
        
        DISPLAY STREAM REPORT "CUENTAS EN " + sCodMon @ cb-ctas.NomCta
                              WITH FRAME F-CAB.
                              
        DOWN 1 STREAM REPORT WITH FRAME F-CAB.                       
        
        UNDERLINE STREAM REPORT cb-ctas.NomCta WITH FRAME F-CAB.

     END.
     
     IF iCodMon = 1 THEN ASSIGN fIImport[1] = X-SALDOIS
                                fIImport[2] = X-SALDOCS
                                fIImport[3] = X-SALDOAS
                                fIImport[4] = X-SALDOSS.
                                
     ELSE ASSIGN fIImport[1] = X-SALDOID
                 fIImport[2] = X-SALDOCD
                 fIImport[3] = X-SALDOAD
                 fIImport[4] = X-SALDOSD. 
          
     DISPLAY STREAM REPORT cb-ctas.CodCta
                           cb-ctas.NomCta
                           fIImport[1]
                           fIImport[2]
                           fIImport[3]
                           fIImport[4]
                           WITH FRAME F-CAB.
     
     ACCUMULATE fIImport[1] ( SUB-TOTAL BY cb-ctas.CodMon ).
     ACCUMULATE fIImport[2] ( SUB-TOTAL BY cb-ctas.CodMon ).
     ACCUMULATE fIImport[3] ( SUB-TOTAL BY cb-ctas.CodMon ).
     ACCUMULATE fIImport[4] ( SUB-TOTAL BY cb-ctas.CodMon ).
     
     IF LAST-OF (cb-ctas.Codmon) THEN DO :
        
        UNDERLINE STREAM REPORT fIImport[1]
                                fIImport[2]
                                fIImport[3]
                                fIImport[4] WITH FRAME F-CAB.
                                
        DOWN 1 STREAM REPORT WITH FRAME F-CAB. 
        
        DISPLAY STREAM REPORT "TOTAL CUENTAS " + SCODMON @ cb-ctas.NomCta
                              ACCUM SUB-TOTAL BY cb-ctas.CodMon fIImport[1] @ fIImport[1]
                              ACCUM SUB-TOTAL BY cb-ctas.CodMon fIImport[2] @ fIImport[2]
                              ACCUM SUB-TOTAL BY cb-ctas.CodMon fIImport[3] @ fIImport[3]
                              ACCUM SUB-TOTAL BY cb-ctas.CodMon fIImport[4] @ fIImport[4]
                              WITH FRAME F-CAB.
                              
        DOWN 1 STREAM REPORT WITH FRAME F-CAB. 
                              
        UNDERLINE STREAM REPORT fIImport[1]
                                fIImport[2]
                                fIImport[3]
                                fIImport[4] WITH FRAME F-CAB.
                      
     END.                  
 END.

/*MLR* 15/11/07 ***
 OUTPUT STREAM REPORT CLOSE.
* ***/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

