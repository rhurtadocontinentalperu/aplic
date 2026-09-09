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

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-nomcia AS CHAR.

DEF VAR s-task-no AS INT NO-UNDO.
DEF VAR cl-codcli AS INT NO-UNDO.
DEF VAR cl-codpro AS INT NO-UNDO.

FIND Empresas WHERE Empresas.codcia = s-codcia NO-LOCK NO-ERROR.

IF NOT Empresas.Campo-CodCli THEN cl-codcli = s-codcia.
IF NOT Empresas.Campo-CodPro THEN cl-codpro = s-codcia.

DEF FRAME f-Mensaje
    SPACE(1) SKIP
    "CLIENTE:" VtaDActi.CodCli
    SPACE(1) SKIP
    WITH OVERLAY CENTERED VIEW-AS DIALOG-BOX NO-LABELS TITLE 'Procesando...'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-1 x-CodActi x-Fecha-1 x-Fecha-2 ~
x-CodPro-1 x-CodPro-2 x-CodPro-3 x-CodPro-4 x-CodPro-5 x-CodMon BUTTON-3 ~
BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS F-Division x-CodActi x-Fecha-1 x-Fecha-2 ~
x-CodPro-1 x-CodPro-2 x-CodPro-3 x-CodPro-4 x-CodPro-5 x-CodMon x-NomPro-1 ~
x-NomPro-2 x-NomPro-3 x-NomPro-4 x-NomPro-5 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\print1":U
     LABEL "Button 1" 
     SIZE 11 BY 1.92.

DEFINE BUTTON BUTTON-2 
     LABEL "..." 
     SIZE 3 BY .77.

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img\exit":U
     LABEL "Button 3" 
     SIZE 11 BY 1.92.

DEFINE VARIABLE F-Division AS CHARACTER FORMAT "X(60)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE x-CodActi AS CHARACTER FORMAT "X(20)":U 
     LABEL "Actividad" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81 NO-UNDO.

DEFINE VARIABLE x-CodPro-1 AS CHARACTER FORMAT "X(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE x-CodPro-2 AS CHARACTER FORMAT "X(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE x-CodPro-3 AS CHARACTER FORMAT "X(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE x-CodPro-4 AS CHARACTER FORMAT "X(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE x-CodPro-5 AS CHARACTER FORMAT "X(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE x-Fecha-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-Fecha-2 AS DATE FORMAT "99/99/99":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomPro-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomPro-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomPro-3 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomPro-4 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomPro-5 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81 NO-UNDO.

DEFINE VARIABLE x-CodMon AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "S/.", 1,
"US$", 2
     SIZE 15 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-1 AT ROW 12.15 COL 7
     F-Division AT ROW 1.58 COL 16 COLON-ALIGNED
     x-CodActi AT ROW 2.54 COL 16 COLON-ALIGNED
     x-Fecha-1 AT ROW 3.5 COL 16 COLON-ALIGNED
     x-Fecha-2 AT ROW 4.46 COL 16 COLON-ALIGNED
     x-CodPro-1 AT ROW 5.42 COL 16 COLON-ALIGNED
     x-CodPro-2 AT ROW 6.38 COL 16 COLON-ALIGNED
     x-CodPro-3 AT ROW 7.35 COL 16 COLON-ALIGNED
     x-CodPro-4 AT ROW 8.31 COL 16 COLON-ALIGNED
     x-CodPro-5 AT ROW 9.27 COL 16 COLON-ALIGNED
     x-CodMon AT ROW 10.23 COL 18 NO-LABEL
     BUTTON-3 AT ROW 12.15 COL 19
     x-NomPro-1 AT ROW 5.42 COL 28 COLON-ALIGNED NO-LABEL
     x-NomPro-2 AT ROW 6.38 COL 28 COLON-ALIGNED NO-LABEL
     x-NomPro-3 AT ROW 7.35 COL 28 COLON-ALIGNED NO-LABEL
     x-NomPro-4 AT ROW 8.31 COL 28 COLON-ALIGNED NO-LABEL
     x-NomPro-5 AT ROW 9.27 COL 28 COLON-ALIGNED NO-LABEL
     BUTTON-2 AT ROW 1.58 COL 62
     "Valorizado en:" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 10.23 COL 8
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
         TITLE              = "Ventas por Proveedor por Actividad"
         HEIGHT             = 14.81
         WIDTH              = 71.86
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
/* SETTINGS FOR FILL-IN F-Division IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomPro-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomPro-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomPro-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomPro-4 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomPro-5 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/bin/_prns.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Ventas por Proveedor por Actividad */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Ventas por Proveedor por Actividad */
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
  ASSIGN
    F-Division
    x-CodActi 
    x-CodPro-1 x-CodPro-2 x-CodPro-3 x-CodPro-4 x-CodPro-5 
    x-Fecha-1 x-Fecha-2
    x-CodMon.
  RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* ... */
DO:
  DEF VAR x-Divisiones AS CHAR.
  x-Divisiones = f-Division:SCREEN-VALUE.
  RUN vta/d-repo06 (INPUT-OUTPUT x-Divisiones).
  f-Division:SCREEN-VALUE = x-Divisiones.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
  RUN dispatch IN THIS-PROCEDURE ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Division W-Win
ON LEAVE OF F-Division IN FRAME F-Main /* Division */
DO:
/*    Find gn-divi where gn-divi.codcia = s-codcia and gn-divi.coddiv = F-Division:screen-value no-lock no-error.
 *     If available gn-divi then
 *         F-DesDiv:screen-value = gn-divi.desdiv.
 *     else
 *         F-DesDiv:screen-value = "".*/
    ASSIGN F-Division.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodPro-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodPro-1 W-Win
ON LEAVE OF x-CodPro-1 IN FRAME F-Main /* Proveedor */
DO:
  FIND GN-PROV WHERE GN-PROV.codcia = cl-codpro
    AND GN-PROV.codpro = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE GN-PROV
  THEN x-NomPro-1:SCREEN-VALUE = GN-PROV.nompro.
  ELSE x-NomPro-1:SCREEN-VALUE = ''.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodPro-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodPro-2 W-Win
ON LEAVE OF x-CodPro-2 IN FRAME F-Main /* Proveedor */
DO:
  FIND GN-PROV WHERE GN-PROV.codcia = cl-codpro
    AND GN-PROV.codpro = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE GN-PROV
  THEN x-NomPro-2:SCREEN-VALUE = GN-PROV.nompro.
  ELSE x-NomPro-3:SCREEN-VALUE = ''.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodPro-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodPro-3 W-Win
ON LEAVE OF x-CodPro-3 IN FRAME F-Main /* Proveedor */
DO:
  FIND GN-PROV WHERE GN-PROV.codcia = cl-codpro
    AND GN-PROV.codpro = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE GN-PROV
  THEN x-NomPro-3:SCREEN-VALUE = GN-PROV.nompro.
  ELSE x-NomPro-3:SCREEN-VALUE = ''.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodPro-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodPro-4 W-Win
ON LEAVE OF x-CodPro-4 IN FRAME F-Main /* Proveedor */
DO:
  FIND GN-PROV WHERE GN-PROV.codcia = cl-codpro
    AND GN-PROV.codpro = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE GN-PROV
  THEN x-NomPro-4:SCREEN-VALUE = GN-PROV.nompro.
  ELSE x-NomPro-4:SCREEN-VALUE = ''.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodPro-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodPro-5 W-Win
ON LEAVE OF x-CodPro-5 IN FRAME F-Main /* Proveedor */
DO:
  FIND GN-PROV WHERE GN-PROV.codcia = cl-codpro
    AND GN-PROV.codpro = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE GN-PROV
  THEN x-NomPro-5:SCREEN-VALUE = GN-PROV.nompro.
  ELSE x-NomPro-5:SCREEN-VALUE = ''.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
/*{src/adm/template/cntnrwin.i}*/

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
  DEF VAR x-Proveedor AS CHAR NO-UNDO.
  DEF VAR x-Division  AS CHAR NO-UNDO.
  DEF VAR x-NroFch-1  AS INT NO-UNDO.
  DEF VAR x-NroFch-2  AS INT NO-UNDO.
  DEF VAR i AS INT NO-UNDO.
  DEF VAR j AS INT NO-UNDO.
  DEF VAR k AS INT NO-UNDO.
  DEF VAR x-CodMes AS INT NO-UNDO.
  DEF VAR x-CodAno AS INT NO-UNDO.
  DEF VAR X-CODDIA AS INTEGER INIT 1.
  DEF VAR x-Fecha  AS DATE NO-UNDO.
  DEFINE VAR T-Vtamn   AS DECI INIT 0.
  DEFINE VAR T-Vtame   AS DECI INIT 0.
  
  ASSIGN
    x-NroFch-1 = YEAR(x-Fecha-1) * 100 + MONTH(x-Fecha-1)
    x-NroFch-2 = YEAR(x-Fecha-2) * 100 + MONTH(x-Fecha-2)
    x-Division = f-Division.
  IF x-Division = '' THEN DO:
    FOR EACH Gn-divi WHERE Gn-divi.codcia = s-codcia NO-LOCK:
        IF x-Division = ''
        THEN x-Division = TRIM(Gn-divi.coddiv).
        ELSE x-Division = x-Division + ',' + TRIM(Gn-divi.coddiv).
    END.
  END.
  
  IF x-CodPro-1 <> ''
  THEN IF x-Proveedor = ''
        THEN x-Proveedor = TRIM(x-CodPro-1).
        ELSE x-Proveedor = x-Proveedor + ',' + TRIM(x-CodPro-1).
  IF x-CodPro-2 <> ''
  THEN IF x-Proveedor = ''
        THEN x-Proveedor = TRIM(x-CodPro-2).
        ELSE x-Proveedor = x-Proveedor + ',' + TRIM(x-CodPro-2).
  IF x-CodPro-3 <> ''
  THEN IF x-Proveedor = ''
        THEN x-Proveedor = TRIM(x-CodPro-3).
        ELSE x-Proveedor = x-Proveedor + ',' + TRIM(x-CodPro-3).
  IF x-CodPro-4 <> ''
  THEN IF x-Proveedor = ''
        THEN x-Proveedor = TRIM(x-CodPro-4).
        ELSE x-Proveedor = x-Proveedor + ',' + TRIM(x-CodPro-4).
  IF x-CodPro-5 <> ''
  THEN IF x-Proveedor = ''
        THEN x-Proveedor = TRIM(x-CodPro-5).
        ELSE x-Proveedor = x-Proveedor + ',' + TRIM(x-CodPro-5).

  REPEAT:
    s-task-no = RANDOM(1, 999998).
    FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN LEAVE.
  END.
  
  DO j = 1 TO NUM-ENTRIES(x-Division):
    FOR EACH VtaDActi NO-LOCK WHERE VtaDActi.codcia = s-codcia  
            AND VtaDActi.CodActi = x-CodActi:
        DISPLAY VtaDActi.codcli WITH FRAME f-Mensaje.
        FOR EACH EvtClArti NO-LOCK WHERE EvtClArti.codcia = s-codcia
                AND EvtClArti.coddiv = ENTRY(j, x-Division)
                AND EvtClArti.nrofch >= x-NroFch-1
                AND EvtClArti.nrofch <= x-NroFch-2
                AND EvtClArti.codcli = VtaDActi.CodCli,
                FIRST Gn-clie NO-LOCK WHERE Gn-clie.codcia = cl-codcli
                    AND gn-clie.codcli = Evtclarti.codcli,
                FIRST Almmmatg OF Evtclarti NO-LOCK WHERE LOOKUP(TRIM(Almmmatg.codpr1), x-Proveedor) > 0:
            /*****************Capturando el Mes siguiente *******************/
            IF Evtclarti.Codmes < 12 THEN DO:
                ASSIGN
                    X-CODMES = EvtClArti.Codmes + 1
                    X-CODANO = EvtClArti.Codano.
            END.
            ELSE DO: 
                ASSIGN
                    X-CODMES = 01
                    X-CODANO = EvtClArti.Codano + 1.
            END.
            /**********************************************************************/
            /*********************** Calculo Para Obtener los datos diarios ************/
            DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :
                X-FECHA = DATE(STRING(I,"99") + "/" + STRING(Evtclarti.Codmes,"99") + "/" + STRING(Evtclarti.Codano,"9999")).
                IF X-FECHA >= x-Fecha-1 AND X-FECHA <= x-Fecha-2 THEN DO:
                    FIND Gn-tcmb WHERE Gn-tcmb.Fecha = X-FECHA NO-LOCK NO-ERROR.
                    IF AVAILABLE Gn-tcmb THEN DO: 
                        T-Vtamn   = Evtclarti.Vtaxdiamn[I] + Evtclarti.Vtaxdiame[I] * Gn-Tcmb.Venta.
                        T-Vtame   = Evtclarti.Vtaxdiame[I] + Evtclarti.Vtaxdiamn[I] / Gn-Tcmb.Compra.
                        FIND w-report WHERE w-report.task-no = s-task-no
                            AND w-report.llave-c = Evtclarti.codcli
                            EXCLUSIVE-LOCK NO-ERROR.
                        IF NOT AVAILABLE w-report THEN DO:
                            CREATE w-report.
                            ASSIGN 
                                w-report.task-no = s-task-no
                                w-report.llave-c = Evtclarti.codcli
                                w-report.campo-c[1] = gn-clie.nomcli
                                w-report.campo-c[2] = gn-clie.NroCard.
                        END.
                        ASSIGN
                            k = LOOKUP(Almmmatg.codpr1, x-Proveedor)
                            w-report.campo-f[k] = w-report.campo-f[k] + ( IF x-codmon = 1 THEN t-VtaMn ELSE t-VtaMe ).
                    END.
                END.
            END.
        END.
    END.  
  END.
  HIDE FRAME f-Mensaje.
        
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
  DISPLAY F-Division x-CodActi x-Fecha-1 x-Fecha-2 x-CodPro-1 x-CodPro-2 
          x-CodPro-3 x-CodPro-4 x-CodPro-5 x-CodMon x-NomPro-1 x-NomPro-2 
          x-NomPro-3 x-NomPro-4 x-NomPro-5 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-1 x-CodActi x-Fecha-1 x-Fecha-2 x-CodPro-1 x-CodPro-2 
         x-CodPro-3 x-CodPro-4 x-CodPro-5 x-CodMon BUTTON-3 BUTTON-2 
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
  DEF VAR x-Moneda AS CHAR FORMAT 'x(20)' NO-UNDO.
  DEF VAR x-Linea-1 AS CHAR FORMAT 'x(135)' NO-UNDO.

  IF x-CodMon = 1
  THEN x-Moneda = 'Nuevos Soles'.
  ELSE x-Moneda = 'Dolares Americanos'.
  
  x-Linea-1 = "Codigo      Tarjeta    Nombre o razon social                    " +
                FILL(' ', 13 - LENGTH(x-CodPro-1)) + x-CodPro-1 + " " +
                FILL(' ', 13 - LENGTH(x-CodPro-1)) + x-CodPro-2 + " " +
                FILL(' ', 13 - LENGTH(x-CodPro-1)) + x-CodPro-3 + " " +
                FILL(' ', 13 - LENGTH(x-CodPro-1)) + x-CodPro-4 + " " +
                FILL(' ', 13 - LENGTH(x-CodPro-1)) + x-CodPro-5 + " ".
  
  DEFINE FRAME F-REPORTE
    w-report.llave-c    FORMAT 'x(11)'      COLUMN-LABEL 'Codigo'
    w-report.campo-c[2] FORMAT 'x(10)'      COLUMN-LABEL 'Tarjeta'
    w-report.campo-c[1] FORMAT 'x(40)'      COLUMN-LABEL 'Nombre o razon social'
    w-report.campo-f[1] FORMAT '->,>>>,>>9.99' 
    w-report.campo-f[2] FORMAT '->,>>>,>>9.99' 
    w-report.campo-f[3] FORMAT '->,>>>,>>9.99' 
    w-report.campo-f[4] FORMAT '->,>>>,>>9.99' 
    w-report.campo-f[5] FORMAT '->,>>>,>>9.99' 
    WITH WIDTH 200 NO-BOX NO-LABELS STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
    HEADER
    S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
    "VENTA POR PROVEEDOR POR ACTIVIDAD" AT 20 
    "Pagina : " TO 130 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
    "Fecha  :" TO 135 TODAY TO 147 FORMAT "99/99/9999" SKIP
    "Divisiones:" f-Division SKIP
    "Actividad :" x-CodActi SKIP
    "     Desde:" x-Fecha-1 "Hasta:" x-Fecha-2 SKIP
    "Moneda    :" x-Moneda SKIP
    x-Linea-1 SKIP
    FILL('=', 135) FORMAT 'x(135)' SKIP
/*            1         2         3         4         5         6         7         8         9        10        11        12
     1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
     12345678901 1234567890 1234567890123456789012345678901234567890 ->,>>>,>>9.99 ->,>>>,>>9.99 ->,>>>,>>9.99 ->,>>>,>>9.99 ->,>>>,>>9.99
*/    
    WITH PAGE-TOP WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH w-report NO-LOCK WHERE w-report.task-no = s-task-no:
      VIEW STREAM REPORT FRAME F-HEADER.

    DISPLAY STREAM REPORT 
        w-report.llave-c    
        w-report.campo-c[2] 
        w-report.campo-c[1] 
        w-report.campo-f[1] 
        w-report.campo-f[2] 
        w-report.campo-f[3] 
        w-report.campo-f[4] 
        w-report.campo-f[5] 
        WITH FRAME F-REPORTE.
  END.
  HIDE FRAME F-PROCESO.

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
/*  RUN bin/_prnctr.p.*/
  RUN lib/imprimir2.
  IF s-salida-impresion = 0 THEN RETURN.

  RUN Carga-Temporal.
  
  /* Captura parametros de impresion */
  /* s-pagina-inicial,  s-pagina-final,  s-printer-name,  s-print-file,  s-nro-copias */
  
/*  RUN aderb/_prlist.p(
 *       OUTPUT s-printer-list,
 *       OUTPUT s-port-list,
 *       OUTPUT s-printer-count).
 *   s-port-name = ENTRY(LOOKUP(s-printer-name, s-printer-list), s-port-list).
 *   s-port-name = REPLACE(S-PORT-NAME, ":", "").*/

  IF s-salida-impresion = 1 THEN 
     s-print-file = SESSION:TEMP-DIRECTORY + "report.prn".
  
  CASE s-salida-impresion:
        WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
/*        WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */*/
        WHEN 2 THEN OUTPUT STREAM REPORT TO PRINTER             PAGED PAGE-SIZE 62. /* Impresora */
        WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
  END CASE.
  
  RUN Formato.  
  
  PAGE STREAM REPORT.
  OUTPUT STREAM REPORT CLOSE.
  CASE s-salida-impresion:
       WHEN 1 OR WHEN 3 THEN RUN LIB/W-README.R(s-print-file).
  END CASE. 
  
  FOR EACH w-report WHERE w-report.task-no = s-task-no:
    DELETE w-report.
  END.

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
  ASSIGN
    x-Fecha-1 = TODAY - DAY(TODAY) + 1
    x-Fecha-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-parametros W-Win 
PROCEDURE Procesa-parametros :
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
        WHEN "x-CodActi" THEN 
            ASSIGN
                input-var-1 = STRING(s-codcia)
                input-var-2 = ""
                input-var-3 = "".
    END CASE.

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


