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

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-nomcia AS CHAR.

DEF TEMP-TABLE DETALLE LIKE Almmmatg
    FIELD VtaAnt-1 AS DEC
    FIELD VtaAnt-2 AS DEC
    FIELD VtaAct-1 AS DEC
    FIELD VtaAct-2 AS DEC
    FIELD StkAct   AS DEC
    FIELD Saldo    AS DEC
    FIELD CtoUni   AS DEC
    FIELD ValTot   AS DEC.

DEF VAR pv-codcia AS INT NO-UNDO.

FIND FIRST Empresas WHERE Empresas.codcia = s-codcia NO-LOCK NO-ERROR.
IF NOT Empresas.Campo-CodPro THEN pv-codcia = s-codcia.

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
&Scoped-Define ENABLED-OBJECTS RECT-64 RECT-65 x-FchAnt-1 x-FchAnt-2 ~
x-FchAct-1 x-FchAct-2 x-Fecha x-CodPro x-CodFam x-CodMon Btn_OK Btn_Excel ~
Btn_Done 
&Scoped-Define DISPLAYED-OBJECTS x-FchAnt-1 x-FchAnt-2 x-FchAct-1 ~
x-FchAct-2 x-Fecha x-CodPro x-NomPro x-CodFam x-DesFam x-SubFam x-DesSub ~
x-CodMon txt-msj 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Done DEFAULT 
     IMAGE-UP FILE "img\exit":U
     LABEL "&Salir" 
     SIZE 8 BY 1.92
     BGCOLOR 8 .

DEFINE BUTTON Btn_Excel AUTO-GO 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "&Salir" 
     SIZE 8 BY 1.92
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\print-2":U
     LABEL "&Imprimir" 
     SIZE 8 BY 1.92
     BGCOLOR 8 .

DEFINE VARIABLE x-CodFam AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Familia" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todas" 
     DROP-DOWN-LIST
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE x-SubFam AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Sub-familia" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todas" 
     DROP-DOWN-LIST
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE txt-msj AS CHARACTER FORMAT "X(256)":U INITIAL "Cargando Informacion....." 
     VIEW-AS FILL-IN 
     SIZE 34.29 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-CodPro AS CHARACTER FORMAT "x(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE x-DesFam AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .81 NO-UNDO.

DEFINE VARIABLE x-DesSub AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchAct-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Campaña Actual" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchAct-2 AS DATE FORMAT "99/99/99":U 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchAnt-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Campaña Anterior" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchAnt-2 AS DATE FORMAT "99/99/99":U 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-Fecha AS DATE FORMAT "99/99/99":U 
     LABEL "Fecha de Corte" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .81 NO-UNDO.

DEFINE VARIABLE x-CodMon AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "S/.", 1,
"US$", 2
     SIZE 13 BY .77 NO-UNDO.

DEFINE RECTANGLE RECT-64
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44 BY 2.69.

DEFINE RECTANGLE RECT-65
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 28 BY .77.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-FchAnt-1 AT ROW 2.73 COL 23 COLON-ALIGNED
     x-FchAnt-2 AT ROW 2.73 COL 40 COLON-ALIGNED NO-LABEL
     x-FchAct-1 AT ROW 3.69 COL 23 COLON-ALIGNED
     x-FchAct-2 AT ROW 3.69 COL 40 COLON-ALIGNED NO-LABEL
     x-Fecha AT ROW 5.23 COL 23 COLON-ALIGNED
     x-CodPro AT ROW 6.19 COL 23 COLON-ALIGNED
     x-NomPro AT ROW 6.19 COL 34 COLON-ALIGNED NO-LABEL
     x-CodFam AT ROW 7.15 COL 23 COLON-ALIGNED
     x-DesFam AT ROW 7.15 COL 33 COLON-ALIGNED NO-LABEL
     x-SubFam AT ROW 8.12 COL 23 COLON-ALIGNED
     x-DesSub AT ROW 8.12 COL 33 COLON-ALIGNED NO-LABEL
     x-CodMon AT ROW 9.08 COL 25 NO-LABEL
     Btn_OK AT ROW 10.65 COL 5
     Btn_Excel AT ROW 10.69 COL 14
     Btn_Done AT ROW 10.69 COL 23 WIDGET-ID 4
     txt-msj AT ROW 10.96 COL 37 NO-LABEL WIDGET-ID 2
     "Valorizado en:" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 9.08 COL 15
     "Inicio" VIEW-AS TEXT
          SIZE 4 BY .5 AT ROW 1.77 COL 27
     "Fin" VIEW-AS TEXT
          SIZE 4 BY .5 AT ROW 1.77 COL 44
     RECT-64 AT ROW 2.35 COL 9
     RECT-65 AT ROW 1.58 COL 25
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 71.86 BY 12.69
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
         TITLE              = "PROYECCION DE VENTAS CAMPAÑA"
         HEIGHT             = 12.69
         WIDTH              = 71.86
         MAX-HEIGHT         = 37.23
         MAX-WIDTH          = 163.57
         VIRTUAL-HEIGHT     = 37.23
         VIRTUAL-WIDTH      = 163.57
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
   FRAME-NAME L-To-R                                                    */
/* SETTINGS FOR FILL-IN txt-msj IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       txt-msj:HIDDEN IN FRAME F-Main           = TRUE
       txt-msj:READ-ONLY IN FRAME F-Main        = TRUE.

/* SETTINGS FOR FILL-IN x-DesFam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-DesSub IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX x-SubFam IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* PROYECCION DE VENTAS CAMPAÑA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* PROYECCION DE VENTAS CAMPAÑA */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Done
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Done W-Win
ON CHOOSE OF Btn_Done IN FRAME F-Main /* Salir */
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Excel W-Win
ON CHOOSE OF Btn_Excel IN FRAME F-Main /* Salir */
DO:
    ASSIGN
      x-FchAct-1 x-FchAct-2 x-FchAnt-1 x-FchAnt-2 x-Fecha x-CodFam x-SubFam x-CodPro
      x-CodMon.
    /* CONSISTENCIA */
    IF x-FchAct-1 = ? THEN DO:
      MESSAGE 'Ingrese la fecha' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO x-FchAct-1.
      RETURN NO-APPLY.
    END.
    IF x-FchAct-2 = ? THEN DO:
      MESSAGE 'Ingrese la fecha' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO x-FchAct-2.
      RETURN NO-APPLY.
    END.
    IF x-FchAnt-1 = ? THEN DO:
      MESSAGE 'Ingrese la fecha' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO x-FchAnt-1.
      RETURN NO-APPLY.
    END.
    IF x-FchAnt-2 = ? THEN DO:
      MESSAGE 'Ingrese la fecha' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO x-FchAnt-2.
      RETURN NO-APPLY.
    END.
    IF x-Fecha = ? THEN DO:
      MESSAGE 'Ingrese la fecha' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO x-Fecha.
      RETURN NO-APPLY.
    END.
    IF NOT (x-Fecha >= x-FchAct-1 AND x-Fecha <= x-FchAct-2)
    THEN DO:
      MESSAGE 'La fecha de corte debe estar entre' x-FchAct-1 'y' x-FchAct-2
          VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO x-Fecha.
      RETURN NO-APPLY.
    END.
    txt-msj:VISIBLE IN FRAME {&FRAME-NAME} = YES.
    RUN Excel.
    txt-msj:HIDDEN IN FRAME {&FRAME-NAME} = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Imprimir */
DO:
  ASSIGN
    x-FchAct-1 x-FchAct-2 x-FchAnt-1 x-FchAnt-2 x-Fecha x-CodFam x-SubFam x-CodPro
    x-CodMon.
  /* CONSISTENCIA */
  IF x-FchAct-1 = ? THEN DO:
    MESSAGE 'Ingrese la fecha' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO x-FchAct-1.
    RETURN NO-APPLY.
  END.
  IF x-FchAct-2 = ? THEN DO:
    MESSAGE 'Ingrese la fecha' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO x-FchAct-2.
    RETURN NO-APPLY.
  END.
  IF x-FchAnt-1 = ? THEN DO:
    MESSAGE 'Ingrese la fecha' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO x-FchAnt-1.
    RETURN NO-APPLY.
  END.
  IF x-FchAnt-2 = ? THEN DO:
    MESSAGE 'Ingrese la fecha' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO x-FchAnt-2.
    RETURN NO-APPLY.
  END.
  IF x-Fecha = ? THEN DO:
    MESSAGE 'Ingrese la fecha' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO x-Fecha.
    RETURN NO-APPLY.
  END.
  IF NOT (x-Fecha >= x-FchAct-1 AND x-Fecha <= x-FchAct-2)
  THEN DO:
    MESSAGE 'La fecha de corte debe estar entre' x-FchAct-1 'y' x-FchAct-2
        VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO x-Fecha.
    RETURN NO-APPLY.
  END.
  RUN Imprimir.
  txt-msj:HIDDEN IN FRAME {&FRAME-NAME} = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodFam W-Win
ON VALUE-CHANGED OF x-CodFam IN FRAME F-Main /* Familia */
DO:
  FIND Almtfami WHERE Almtfami.codcia = s-codcia
    AND Almtfami.codfam = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE Almtfami
  THEN x-DesFam:SCREEN-VALUE = Almtfami.desfam.
  ELSE x-DesFam:SCREEN-VALUE = ''.
  RUN Recarga-Subfamilia.
  IF SELF:SCREEN-VALUE = 'Todas'
  THEN ASSIGN
            x-SubFam:SCREEN-VALUE = 'Todas'
            x-DesSub:SCREEN-VALUE = ''
            x-SubFam:SENSITIVE = NO.
  ELSE ASSIGN
            x-SubFam:SCREEN-VALUE = 'Todas'
            x-DesSub:SCREEN-VALUE = ''
            x-SubFam:SENSITIVE = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodPro W-Win
ON LEAVE OF x-CodPro IN FRAME F-Main /* Proveedor */
DO:
  FIND Gn-prov WHERE Gn-prov.codcia = pv-codcia
    AND Gn-prov.codpro = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE Gn-prov
  THEN x-NomPro:SCREEN-VALUE = Gn-prov.nompro.
  ELSE x-NomPro:SCREEN-VALUE = ''.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-SubFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-SubFam W-Win
ON VALUE-CHANGED OF x-SubFam IN FRAME F-Main /* Sub-familia */
DO:
  FIND Almsfami WHERE Almsfami.codcia = s-codcia
    AND Almsfami.codfam = x-codfam:SCREEN-VALUE
    AND Almsfami.subfam = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE Almsfami
  THEN x-DesSub:SCREEN-VALUE = AlmSFami.dessub.
  ELSE x-DesSub:SCREEN-VALUE = ''.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Material W-Win 
PROCEDURE Carga-Material :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAMETER DesdeF AS DATE.
  DEF INPUT PARAMETER HastaF AS DATE.
  DEF OUTPUT PARAMETER F-Salida AS DEC.
  

  DEF VAR X-CODDIA AS INTEGER INIT 1.
  DEF VAR X-CODANO AS INTEGER.
  DEF VAR X-CODMES AS INTEGER.
  DEF VAR I AS INTEGER.
  DEF VAR X-FECHA AS DATE.
  
  /*****************Capturando el Mes siguiente *******************/
  IF Evtarti.Codmes < 12 THEN DO:
    ASSIGN
        X-CODMES = Evtarti.Codmes + 1
        X-CODANO = Evtarti.Codano .
  END.
  ELSE DO: 
    ASSIGN
        X-CODMES = 01
        X-CODANO = Evtarti.Codano + 1 .
  END.
  /**********************************************************************/
      
  /*********************** Calculo Para Obtener los datos diarios ************/
  DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        
    X-FECHA = DATE(STRING(I,"99") + "/" + STRING(Evtarti.Codmes,"99") + "/" + STRING(Evtarti.Codano,"9999")).
    IF X-FECHA >= DesdeF AND X-FECHA <= HastaF THEN DO:
        FIND Gn-tcmb WHERE Gn-tcmb.Fecha = DATE(STRING(I,"99") + "/" + STRING(Evtarti.Codmes,"99") + "/" + STRING(Evtarti.Codano,"9999")) NO-LOCK NO-ERROR.
        IF AVAILABLE Gn-tcmb THEN DO: 
            F-Salida  = F-Salida  + Evtarti.CanxDia[I].
        END.
    END.
  END.         
  /******************************************************************************/      

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-temporal W-Win 
PROCEDURE Carga-temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  /* Determinamos la fecha de corte de la campaña anterior */
  DEF VAR x-FchCorte AS DATE NO-UNDO.
  DEF VAR x-Factor AS DEC NO-UNDO.
  DEF VAR f-Cantidad AS DEC NO-UNDO.
  
  x-Factor = (x-Fecha - x-FchAct-1) / (x-FchAct-2 - x-FchAct-1).
  x-FchCorte = x-FchAnt-1 + ROUND((x-FchAnt-2 - x-FchAnt-1) * x-Factor, 0).

  FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.tpoart <> 'D'
        AND LOOKUP(TRIM(Almmmatg.codfam), '008,009') = 0
        AND (x-CodFam = 'Todas' OR Almmmatg.codfam = x-codfam)
        AND (x-SubFam = 'Todas' OR Almmmatg.subfam = x-subfam)
        AND (x-CodPro = '' OR Almmmatg.codpr1 = x-CodPro):
    /*
    DISPLAY
        'Procesando' Almmmatg.codmat
        WITH FRAME f-Mensaje CENTERED OVERLAY NO-LABELS.
    */    
    /* CAMPAÑA ANTERIOR */
    FOR EACH Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA:
        FOR EACH Evtarti NO-LOCK WHERE Evtarti.CodCia = S-CODCIA
                AND Evtarti.CodDiv = Gn-Divi.Coddiv
                AND Evtarti.Codmat = Almmmatg.codmat
                AND ( Evtarti.Nrofch >= INTEGER(STRING(YEAR(x-FchAnt-1),"9999") + STRING(MONTH(x-FchAnt-1),"99"))
                AND Evtarti.Nrofch <= INTEGER(STRING(YEAR(x-FchAnt-2),"9999") + STRING(MONTH(x-FchAnt-2),"99")) ):
            RUN Carga-Material (x-FchAnt-1, (x-FchCorte - 1), OUTPUT f-Cantidad).
            IF f-Cantidad <> 0 THEN DO:
                FIND Detalle OF Almmmatg EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE Detalle THEN CREATE Detalle.
                BUFFER-COPY Almmmatg TO Detalle.
                ASSIGN
                    Detalle.VtaAnt-1 = Detalle.VtaAnt-1 + f-Cantidad.
            END.
            RUN Carga-Material (x-FchCorte, x-FchAnt-2, OUTPUT f-Cantidad).
            IF f-Cantidad <> 0 THEN DO:
                FIND Detalle OF Almmmatg EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE Detalle THEN CREATE Detalle.
                BUFFER-COPY Almmmatg TO Detalle.
                ASSIGN
                    Detalle.VtaAnt-2 = Detalle.VtaAnt-2 + f-Cantidad.
            END.
        END.
    END.
    /* CAMPAÑA ACTUAL */
    FOR EACH Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA:
        FOR EACH Evtarti NO-LOCK WHERE Evtarti.CodCia = S-CODCIA
                AND Evtarti.CodDiv = Gn-Divi.Coddiv
                AND Evtarti.Codmat = Almmmatg.codmat
                AND ( Evtarti.Nrofch >= INTEGER(STRING(YEAR(x-FchAct-1),"9999") + STRING(MONTH(x-FchAct-1),"99"))
                AND Evtarti.Nrofch <= INTEGER(STRING(YEAR(x-FchAct-2),"9999") + STRING(MONTH(x-FchAct-2),"99")) ):
            RUN Carga-Material (x-FchAct-1, (x-Fecha - 1), OUTPUT f-Cantidad).
            IF f-Cantidad <> 0 THEN DO:
                FIND Detalle OF Almmmatg EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE Detalle THEN CREATE Detalle.
                BUFFER-COPY Almmmatg TO Detalle.
                ASSIGN
                    Detalle.VtaAct-1 = Detalle.VtaAct-1 + f-Cantidad.
            END.
/*            RUN Carga-Material (x-Fecha, x-FchAct-2, OUTPUT f-Cantidad).
 *             IF f-Cantidad <> 0 THEN DO:
 *                 FIND Detalle OF Almmmatg EXCLUSIVE-LOCK NO-ERROR.
 *                 IF NOT AVAILABLE Detalle THEN CREATE Detalle.
 *                 BUFFER-COPY Almmmatg TO Detalle.
 *                 ASSIGN
 *                     Detalle.VtaAct-2 = Detalle.VtaAct-2 + f-Cantidad.
 *             END.*/
        END.
    END.
  END.  
  /* PROYECCION DE LA CAMPAÑA ACTUAL */
  FOR EACH Detalle:
    IF Detalle.VtaAnt-1 = 0 
    THEN x-Factor = 1.
    ELSE x-Factor = Detalle.VtaAct-1 / Detalle.VtaAnt-1.
    Detalle.VtaAct-2 = Detalle.VtaAnt-2 * x-Factor.
    IF Detalle.VtaAnt-1 = 0 AND Detalle.VtaAnt-2 = 0 THEN DO:       /* Producto nuevo */
        x-Factor = (x-FchAct-2 - x-Fecha) / (x-Fecha - x-FchAct-1).
        Detalle.VtaAct-2 = x-Factor * Detalle.VtaAct-1.
    END.
    /* STOCK AL CORTE */
    FIND LAST Almstkge WHERE Almstkge.codcia = s-codcia
        AND Almstkge.codmat = Detalle.codmat
        AND Almstkge.fecha <= x-Fecha
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almstkge THEN Detalle.stkact = Almstkge.stkact.
    Detalle.Saldo = Detalle.StkAct - Detalle.VtaAct-2.
    /* VALORIZACION */
    IF Detalle.monvta = x-codmon
    THEN Detalle.ctouni = Detalle.CtoTot.
    ELSE IF Detalle.monvta = 2
            THEN Detalle.ctouni = Detalle.ctotot * Detalle.tpocmb.
            ELSE Detalle.ctouni = Detalle.ctotot / Detalle.tpocmb.
    Detalle.valtot = Detalle.saldo * Detalle.ctouni.
  END.
  /*
  HIDE FRAME f-Mensaje.
  */
  
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
  DISPLAY x-FchAnt-1 x-FchAnt-2 x-FchAct-1 x-FchAct-2 x-Fecha x-CodPro x-NomPro 
          x-CodFam x-DesFam x-SubFam x-DesSub x-CodMon txt-msj 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-64 RECT-65 x-FchAnt-1 x-FchAnt-2 x-FchAct-1 x-FchAct-2 x-Fecha 
         x-CodPro x-CodFam x-CodMon Btn_OK Btn_Excel Btn_Done 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel W-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 3.
DEFINE VARIABLE i-Column                AS INTEGER NO-UNDO.
DEFINE VARIABLE j-Column                AS INTEGER NO-UNDO.

DEFINE VARIABLE dTotCot                 AS DECIMAL NO-UNDO.
DEFINE VARIABLE dTotFac                 AS DECIMAL NO-UNDO.
DEFINE VARIABLE dTotLet                 AS DECIMAL NO-UNDO.

DEF VAR x-Texto-1 AS CHAR FORMAT 'x(20)' NO-UNDO.
x-Texto-1 = IF x-CodMon = 1 THEN "NUEVOS SOLES" ELSE "DOLARES AMERICANOS".

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/*Formato*/
chWorkSheet:Columns("A"):NumberFormat = "@".

RUN Carga-Temporal.

cColumn = STRING(t-Column).
chWorkSheet:Range("B2"):Value = S-NOMCIA.
chWorkSheet:Range("B3"):Value = "PROYECCION DE VENTAS".
chWorkSheet:Range("A4"):Value = "CAMPAÑA ANTERIOR: Desde el" +  STRING(x-FchAnt-1, '99/99/99').
chWorkSheet:Range("J4"):Value = "hasta el" +  STRING(x-FchAnt-2, '99/99/99').
chWorkSheet:Range("A5"):Value = "  CAMPAÑA ACTUAL: Desde el" +  STRING(x-FchAct-1, '99/99/99'). 
chWorkSheet:Range("J5"):Value = "hasta el" + STRING(x-FchAct-2, '99/99/99').
chWorkSheet:Range("A6"):Value = "  FECHA DE CORTE:" + STRING(x-Fecha, '99/99/99').
chWorkSheet:Range("I6"):Value = " IMPORTES VALORIZADOS EN " + x-Texto-1.

cColumn = STRING(t-Column).
chWorkSheet:Range("A8"):Value = "CODIGO".
chWorkSheet:Range("B8"):Value = "DESCRIPCION".
chWorkSheet:Range("C8"):Value = "UNIDAD".
chWorkSheet:Range("D8"):Value = "MARCA".
chWorkSheet:Range("E8"):Value = "ANTERIOR 1".
chWorkSheet:Range("F8"):Value = "ANTERIOR 2".
chWorkSheet:Range("G8"):Value = "ACTUAL 1".
chWorkSheet:Range("H8"):Value = "ACTUAL 2".
chWorkSheet:Range("I8"):Value = "STOCK AL " + STRING(x-Fecha, '99/99/99') .
chWorkSheet:Range("J8"):Value = "SALDO".
chWorkSheet:Range("K8"):Value = "UNITARIO".
chWorkSheet:Range("L8"):Value = "TOTAL".
chWorkSheet:Range("M8"):Value = "SOBRANTES".
chWorkSheet:Range("N8"):Value = "FALTANTES".


t-Column = 8.

FOR EACH DETALLE BY Detalle.Saldo DESC:
    t-Column = t-Column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.codmat.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.desmat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.undbas.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.desmar.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.vtaant-1.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.vtaant-2.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.vtaact-1.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.vtaact-2.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.stkact.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.saldo.
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.ctouni.
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.valtot.
    IF DETALLE.valtot > 0 THEN DO:
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = DETALLE.valtot.
    END.
    ELSE DO:
        cRange = "N" + cColumn.
        chWorkSheet:Range(cRange):Value = DETALLE.valtot.
    END.

END.


MESSAGE 'Proceso Terminado!!!'.

/* launch Excel so it is visible to the user */
 chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

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
  DEF VAR x-Texto-1 AS CHAR FORMAT 'x(20)' NO-UNDO.
  
  x-Texto-1 = IF x-CodMon = 1 THEN "NUEVOS SOLES" ELSE "DOLARES AMERICANOS".
  DEFINE FRAME F-DETALLE
    DETALLE.codmat      FORMAT "X(6)"
    DETALLE.desmat      FORMAT "X(50)"
    DETALLE.undbas      FORMAT "X(6)"
    DETALLE.desmar      FORMAT "X(20)"
    DETALLE.vtaant-1    FORMAT "(>>>>>,>>9.99)" 
    DETALLE.vtaant-2    FORMAT "(>>>>>,>>9.99)" 
    DETALLE.vtaact-1    FORMAT "(>>>>>,>>9.99)" 
    DETALLE.vtaact-2    FORMAT "(>>>>>,>>9.99)" 
    DETALLE.stkact      FORMAT "(>>>>>,>>9.99)"
    DETALLE.saldo       FORMAT "(>>>>>,>>9.99)"
    DETALLE.ctouni      FORMAT "(>>>>>,>>9.99)"
    DETALLE.valtot      FORMAT "(>>>>>,>>9.99)"
  WITH WIDTH 320 NO-BOX STREAM-IO NO-LABELS DOWN. 

  DEFINE FRAME F-HEADER
    HEADER
    S-NOMCIA FORMAT "X(50)" AT 1 SKIP
    "PROYECCION DE VENTAS" AT 50 
    "Pagina :" TO 120 PAGE-NUMBER(REPORT) FORMAT "ZZZZZ9" SKIP
    "Fecha :"  TO 120 TODAY FORMAT "99/99/9999" SKIP
    "CAMPAÑA ANTERIOR: Desde el" x-FchAnt-1 "hasta el" x-FchAnt-2 SKIP
    "  CAMPAÑA ACTUAL: Desde el" x-FchAct-1 "hasta el" x-FchAct-2 SKIP
    "  FECHA DE CORTE:" x-Fecha SKIP
    " IMPORTES VALORIZADOS EN" x-Texto-1 SKIP
    "                                                                                             CAMPAÑA ANTERIOR               CAMPAÑA ACTUAL            STOCK AL" SKIP
    "CODIGO DESCRIPCION                                        UNIDAD MARCA                    PERIODO 1      PERIODO 2      PERIODO 1      PERIODO 2      " 
    STRING(x-Fecha, '99/99/99') 
    "        SALDO        UNITARIO      TOTAL" SKIP
    FILL('=',205) FORMAT 'x(205)' SKIP
  WITH PAGE-TOP WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  FOR EACH DETALLE BY Detalle.Saldo DESC:
    VIEW STREAM REPORT FRAME F-HEADER.
        DISPLAY STREAM REPORT 
        DETALLE.codmat      
        DETALLE.desmat      
        DETALLE.undbas      
        DETALLE.desmar
        DETALLE.vtaant-1    
        DETALLE.vtaant-2    
        DETALLE.vtaact-1    
        DETALLE.vtaact-2    
        DETALLE.stkact
        DETALLE.saldo
        DETALLE.ctouni
        DETALLE.valtot
        WITH FRAME F-DETALLE.
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

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    txt-msj:VISIBLE IN FRAME {&FRAME-NAME} = YES.
    RUN Carga-Temporal.

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        RUN Formato.
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
  ASSIGN
    x-FchAnt-1 = DATE(01,01,YEAR(TODAY) - 1)
    x-FchAnt-2 = DATE(03,31,YEAR(TODAY) - 1)
    x-FchAct-1 = DATE(01,01,YEAR(TODAY))
    x-FchAct-2 = DATE(03,31,YEAR(TODAY))
    x-Fecha = DATE(02,01,YEAR(TODAY)).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  txt-msj:HIDDEN IN FRAME {&FRAME-NAME} = YES.
  DO WITH FRAME {&FRAME-NAME}:
    FOR EACH Almtfami NO-LOCK WHERE Almtfami.codcia = s-codcia
            AND LOOKUP(TRIM(Almtfami.codfam), '008,009,888') = 0:
        x-CodFam:ADD-LAST(Almtfami.codfam).
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros W-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recarga-subfamilia W-Win 
PROCEDURE Recarga-subfamilia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR i AS INT NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    x-SubFam:DELETE(x-SubFam:LIST-ITEMS).
    x-SubFam:ADD-LAST('Todas').
    FOR EACH Almsfami NO-LOCK WHERE AlmSFami.CodCia = s-codcia
            AND AlmSFami.codfam = x-codfam:SCREEN-VALUE:
        x-SubFam:ADD-LAST(AlmSFami.subfam).
    END.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros W-Win 
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

