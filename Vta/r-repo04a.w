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

/*DEF TEMP-TABLE DETALLE LIKE CcbCDocu
 *     FIELD Fotocopia AS DEC FORMAT '->>>,>>>,>>9.99'.*/

DEF TEMP-TABLE DETALLE
    FIELD NroCard LIKE Gn-Card.NroCard
    FIELD NomCli  LIKE Gn-Card.NomCli[1]
    FIELD Imp01   AS DEC EXTENT 2
    FIELD Imp02   AS DEC EXTENT 2
    FIELD Imp03   AS DEC EXTENT 2
    FIELD Imp14   AS DEC EXTENT 2
    FIELD Imp08   AS DEC EXTENT 2
    FIELD Imp15   AS DEC EXTENT 2
    FIELD Imp05   AS DEC EXTENT 2
    FIELD Imp16   AS DEC EXTENT 2
    FIELD ImpOtro AS DEC EXTENT 2
    FIELD Punto01 AS DEC
    FIELD Punto02 AS DEC
    FIELD Punto03 AS DEC
    FIELD Punto14 AS DEC
    FIELD Punto08 AS DEC
    FIELD Punto15 AS DEC
    FIELD Punto05 AS DEC
    FIELD Punto16 AS DEC
    FIELD PuntoOtro AS DEC.
    
DEF BUFFER B-CDOCU FOR CcbCDocu.
DEF BUFFER B-DDOCU FOR CcbDDocu.

DEF VAR s-CliCia AS INT INIT 0.

FIND Empresas WHERE Empresas.codcia = s-codcia NO-LOCK.
IF NOT Empresas.Campo-CodCli THEN s-CliCia = s-CodCia.

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
&Scoped-Define ENABLED-OBJECTS x-NroCard x-Fecha-1 x-Fecha-2 Btn_OK ~
Btn_Done 
&Scoped-Define DISPLAYED-OBJECTS x-NroCard x-NomCli x-Fecha-1 x-Fecha-2 ~
x-mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Done DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Salir" 
     SIZE 9 BY 1.88
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO DEFAULT 
     IMAGE-UP FILE "img/print.ico":U
     LABEL "Imprimir" 
     SIZE 9 BY 1.88
     BGCOLOR 8 .

DEFINE VARIABLE x-Fecha-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-Fecha-2 AS DATE FORMAT "99/99/99":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 61 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81 NO-UNDO.

DEFINE VARIABLE x-NroCard AS CHARACTER FORMAT "x(6)":U 
     LABEL "Tarjeta" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-NroCard AT ROW 1.85 COL 8 COLON-ALIGNED
     x-NomCli AT ROW 1.85 COL 20 COLON-ALIGNED NO-LABEL
     x-Fecha-1 AT ROW 2.81 COL 8 COLON-ALIGNED
     x-Fecha-2 AT ROW 3.77 COL 8 COLON-ALIGNED
     x-mensaje AT ROW 5.58 COL 3 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     Btn_OK AT ROW 6.92 COL 6
     Btn_Done AT ROW 6.92 COL 16
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 70.57 BY 8.58
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
         TITLE              = "REPORTE DE CONTIPUNTOS"
         HEIGHT             = 8.58
         WIDTH              = 70.57
         MAX-HEIGHT         = 8.58
         MAX-WIDTH          = 70.57
         VIRTUAL-HEIGHT     = 8.58
         VIRTUAL-WIDTH      = 70.57
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
/* SETTINGS FOR FILL-IN x-mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REPORTE DE CONTIPUNTOS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REPORTE DE CONTIPUNTOS */
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


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Imprimir */
DO:
  ASSIGN
    x-NroCard x-Fecha-1 x-Fecha-2.
  RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-NroCard
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-NroCard W-Win
ON LEAVE OF x-NroCard IN FRAME F-Main /* Tarjeta */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  ASSIGN
    SELF:SCREEN-VALUE = STRING(DECIMAL(SELF:SCREEN-VALUE), '999999')
    NO-ERROR.
  FIND GN-CARD WHERE gn-card.NroCard = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE GN-CARD THEN x-NomCli:SCREEN-VALUE = GN-CARD.nomcli[1].
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF FRAME f-Mensaje
    SPACE(1) SKIP
    ccbcdocu.codcli ccbcdocu.coddoc ccbcdocu.nrodoc SKIP
    'Un momento por favor....' SKIP(1)
    SPACE(1) SKIP
    WITH NO-LABELS CENTERED OVERLAY VIEW-AS DIALOG-BOX TITLE 'PROCESANDO'.

  FOR EACH DETALLE:
    DELETE DETALLE.
  END.
  FOR EACH Ccbcdocu WHERE ccbcdocu.codcia = s-codcia
        AND LOOKUP(TRIM(ccbcdocu.coddoc), 'FAC,BOL') > 0
        AND ccbcdocu.nrocard <> ''
        AND ccbcdocu.nrocard BEGINS x-nrocard
        AND ccbcdocu.fchdoc >= x-fecha-1
        AND ccbcdocu.fchdoc <= x-fecha-2
        AND ccbcdocu.flgest <> 'A' NO-LOCK,
        FIRST GN-CARD WHERE gn-card.NroCard = ccbcdocu.nrocard NO-LOCK:
    IF ccbcdocu.puntos <= 0 THEN NEXT.
    IF ccbcdocu.nrocard = '' AND ccbcdocu.coddiv <> '00000' THEN NEXT.      /* Forzado para la division 00000 */
    /*
    DISPLAY ccbcdocu.codcli ccbcdocu.coddoc ccbcdocu.nrodoc
        WITH FRAME F-mensaje.
    */

    DISPLAY ccbcdocu.codcli + " " + ccbcdocu.coddoc + "-" + ccbcdocu.nrodoc
        @ x-mensaje WITH FRAME {&FRAME-NAME}.

    FIND DETALLE WHERE DETALLE.NroCard = Gn-Card.NroCard EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE DETALLE THEN DO:
        CREATE DETALLE.
        ASSIGN
            DETALLE.NroCard = Gn-Card.NroCard
            DETALLE.NomCli  = Gn-Card.NomCli[1].
    END.
    CASE Ccbcdocu.coddiv:
        WHEN '00001' THEN DO:
            IF Ccbcdocu.codmon = 1
            THEN DETALLE.Imp01[1] = DETALLE.Imp01[1] + Ccbcdocu.imptot.
            ELSE DETALLE.Imp01[2] = DETALLE.Imp01[2] + Ccbcdocu.imptot.
            DETALLE.Punto01 = DETALLE.Punto01 + Ccbcdocu.puntos.
        END.
        WHEN '00002' THEN DO:
            IF Ccbcdocu.codmon = 1
            THEN DETALLE.Imp02[1] = DETALLE.Imp02[1] + Ccbcdocu.imptot.
            ELSE DETALLE.Imp02[2] = DETALLE.Imp02[2] + Ccbcdocu.imptot.
            DETALLE.Punto02 = DETALLE.Punto02 + Ccbcdocu.puntos.
        END.
        WHEN '00003' THEN DO:
            IF Ccbcdocu.codmon = 1
            THEN DETALLE.Imp03[1] = DETALLE.Imp03[1] + Ccbcdocu.imptot.
            ELSE DETALLE.Imp03[2] = DETALLE.Imp03[2] + Ccbcdocu.imptot.
            DETALLE.Punto03 = DETALLE.Punto03 + Ccbcdocu.puntos.
        END.
        WHEN '00014' THEN DO:
            IF Ccbcdocu.codmon = 1
            THEN DETALLE.Imp14[1] = DETALLE.Imp14[1] + Ccbcdocu.imptot.
            ELSE DETALLE.Imp14[2] = DETALLE.Imp14[2] + Ccbcdocu.imptot.
            DETALLE.Punto14 = DETALLE.Punto14 + Ccbcdocu.puntos.
        END.
        WHEN '00008' THEN DO:
            IF Ccbcdocu.codmon = 1
            THEN DETALLE.Imp08[1] = DETALLE.Imp08[1] + Ccbcdocu.imptot.
            ELSE DETALLE.Imp08[2] = DETALLE.Imp08[2] + Ccbcdocu.imptot.
            DETALLE.Punto08 = DETALLE.Punto08 + Ccbcdocu.puntos.
        END.
        WHEN '00015' THEN DO:
            IF Ccbcdocu.codmon = 1
            THEN DETALLE.Imp15[1] = DETALLE.Imp15[1] + Ccbcdocu.imptot.
            ELSE DETALLE.Imp15[2] = DETALLE.Imp15[2] + Ccbcdocu.imptot.
            DETALLE.Punto15 = DETALLE.Punto15 + Ccbcdocu.puntos.
        END.
        WHEN '00005' THEN DO:
            IF Ccbcdocu.codmon = 1
            THEN DETALLE.Imp05[1] = DETALLE.Imp05[1] + Ccbcdocu.imptot.
            ELSE DETALLE.Imp05[2] = DETALLE.Imp05[2] + Ccbcdocu.imptot.
            DETALLE.Punto05 = DETALLE.Punto05 + Ccbcdocu.puntos.
        END.
        WHEN '00016' THEN DO:
            IF Ccbcdocu.codmon = 1
            THEN DETALLE.Imp16[1] = DETALLE.Imp16[1] + Ccbcdocu.imptot.
            ELSE DETALLE.Imp16[2] = DETALLE.Imp16[2] + Ccbcdocu.imptot.
            DETALLE.Punto16 = DETALLE.Punto16 + Ccbcdocu.puntos.
        END.
        OTHERWISE DO:
            IF Ccbcdocu.codmon = 1
            THEN DETALLE.ImpOtro[1] = DETALLE.ImpOtro[1] + Ccbcdocu.imptot.
            ELSE DETALLE.ImpOtro[2] = DETALLE.ImpOtro[2] + Ccbcdocu.imptot.
            DETALLE.PuntoOtro = DETALLE.PuntoOtro + Ccbcdocu.puntos.
        END.
    END CASE.
    /* buscamos la nota de credito por devolucion */
    FOR EACH B-CDOCU WHERE B-CDOCU.codcia = s-codcia
            AND B-CDOCU.coddoc = 'N/C'
            AND B-CDOCU.codref = Ccbcdocu.coddoc
            AND B-CDOCU.nroref = Ccbcdocu.nrodoc
            AND B-CDOCU.flgest <> 'A'
            NO-LOCK:
        CASE Ccbcdocu.coddiv:
            WHEN '00001' THEN DO:
                IF Ccbcdocu.codmon = 1
                THEN DETALLE.Imp01[1] = DETALLE.Imp01[1] - B-CDOCU.imptot.
                ELSE DETALLE.Imp01[2] = DETALLE.Imp01[2] - B-CDOCU.imptot.
                DETALLE.Punto01 = DETALLE.Punto01 - B-CDOCU.puntos.
            END.
            WHEN '00002' THEN DO:
                IF Ccbcdocu.codmon = 1
                THEN DETALLE.Imp02[1] = DETALLE.Imp02[1] - B-CDOCU.imptot.
                ELSE DETALLE.Imp02[2] = DETALLE.Imp02[2] - B-CDOCU.imptot.
                DETALLE.Punto02 = DETALLE.Punto02 - B-CDOCU.puntos.
            END.
            WHEN '00003' THEN DO:
                IF Ccbcdocu.codmon = 1
                THEN DETALLE.Imp03[1] = DETALLE.Imp03[1] - B-CDOCU.imptot.
                ELSE DETALLE.Imp03[2] = DETALLE.Imp03[2] - B-CDOCU.imptot.
                DETALLE.Punto03 = DETALLE.Punto03 - B-CDOCU.puntos.
            END.
            WHEN '00014' THEN DO:
                IF Ccbcdocu.codmon = 1
                THEN DETALLE.Imp14[1] = DETALLE.Imp14[1] - B-CDOCU.imptot.
                ELSE DETALLE.Imp14[2] = DETALLE.Imp14[2] - B-CDOCU.imptot.
                DETALLE.Punto14 = DETALLE.Punto14 - B-CDOCU.puntos.
            END.
            WHEN '00008' THEN DO:
                IF Ccbcdocu.codmon = 1
                THEN DETALLE.Imp08[1] = DETALLE.Imp08[1] - B-CDOCU.imptot.
                ELSE DETALLE.Imp08[2] = DETALLE.Imp08[2] - B-CDOCU.imptot.
                DETALLE.Punto08 = DETALLE.Punto08 - B-CDOCU.puntos.
            END.
            WHEN '00015' THEN DO:
                IF Ccbcdocu.codmon = 1
                THEN DETALLE.Imp15[1] = DETALLE.Imp15[1] - B-CDOCU.imptot.
                ELSE DETALLE.Imp15[2] = DETALLE.Imp15[2] - B-CDOCU.imptot.
                DETALLE.Punto15 = DETALLE.Punto15 - B-CDOCU.puntos.
            END.
            WHEN '00005' THEN DO:
                IF Ccbcdocu.codmon = 1
                THEN DETALLE.Imp05[1] = DETALLE.Imp05[1] - B-CDOCU.imptot.
                ELSE DETALLE.Imp05[2] = DETALLE.Imp05[2] - B-CDOCU.imptot.
                DETALLE.Punto05 = DETALLE.Punto05 - B-CDOCU.puntos.
            END.
            WHEN '00016' THEN DO:
                IF Ccbcdocu.codmon = 1
                THEN DETALLE.Imp16[1] = DETALLE.Imp16[1] - B-CDOCU.imptot.
                ELSE DETALLE.Imp16[2] = DETALLE.Imp16[2] - B-CDOCU.imptot.
                DETALLE.Punto16 = DETALLE.Punto16 - B-CDOCU.puntos.
            END.
            OTHERWISE DO:
                IF Ccbcdocu.codmon = 1
                THEN DETALLE.ImpOtro[1] = DETALLE.ImpOtro[1] - B-CDOCU.imptot.
                ELSE DETALLE.ImpOtro[2] = DETALLE.ImpOtro[2] - B-CDOCU.imptot.
                DETALLE.PuntoOtro = DETALLE.PuntoOtro - B-CDOCU.puntos.
            END.
        END CASE.
    END.        
  END.
  /*
  HIDE FRAME F-Mensaje.
  */

  DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.

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
  DISPLAY x-NroCard x-NomCli x-Fecha-1 x-Fecha-2 x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE x-NroCard x-Fecha-1 x-Fecha-2 Btn_OK Btn_Done 
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
  DEF VAR x-ImpNac AS DEC FORMAT '>>>,>>>,>>9.99'.
  DEF VAR x-ImpUsa AS DEC FORMAT '>>>,>>>,>>9.99'.
  
  DEFINE FRAME F-REPORTE
    DETALLE.nrocard                             COLUMN-LABEL 'Cliente'
    DETALLE.nomcli      FORMAT 'x(45)'          COLUMN-LABEL 'Nombre'
    DETALLE.punto01     FORMAT '->>>>>9'         COLUMN-LABEL '00001'
    DETALLE.punto02     FORMAT '->>>>>9'         COLUMN-LABEL '00002'
    DETALLE.punto03     FORMAT '->>>>>9'         COLUMN-LABEL '00003'
    DETALLE.punto14     FORMAT '->>>>>9'         COLUMN-LABEL '00014'
    DETALLE.punto08     FORMAT '->>>>>9'         COLUMN-LABEL '00008'
    DETALLE.punto15     FORMAT '->>>>>9'         COLUMN-LABEL '00015'
    DETALLE.punto05     FORMAT '->>>>>9'         COLUMN-LABEL '00005'
    DETALLE.punto16     FORMAT '->>>>>9'         COLUMN-LABEL '00016'
    DETALLE.puntoOtro   FORMAT '->>>>>9'         COLUMN-LABEL 'Otros'
    x-ImpNac            FORMAT '->>>,>>9.99'     COLUMN-LABEL 'Total S/.'
    x-ImpUsa            FORMAT '->>>,>>9.99'     COLUMN-LABEL 'Total US$'
    HEADER
         S-NOMCIA FORMAT "X(50)" SKIP
         "Pagina : " TO 90 PAGE-NUMBER(REPORT) TO 100 FORMAT "ZZZZZ9" SKIP
         "CONTIPUNTOS" AT 30
         " Fecha : " TO 90 TODAY TO 100 FORMAT "99/99/9999" SKIP
         "  Hora : " TO 90 STRING(TIME,"HH:MM:SS") TO 100 SKIP
         "DESDE EL" x-Fecha-1 "HASTA EL" x-Fecha-2 SKIP(1)
  WITH WIDTH 200 NO-BOX STREAM-IO DOWN.

  FOR EACH DETALLE BY DETALLE.NroCard:
    ASSIGN
        x-ImpNac = DETALLE.Imp01[1] + DETALLE.Imp02[1] + DETALLE.Imp03[1] +
                    DETALLE.Imp14[1] + DETALLE.Imp08[1] + DETALLE.Imp15[1] +
                    DETALLE.Imp05[1] + DETALLE.Imp16[1] + DETALLE.ImpOtro[1]
        x-ImpUsa = DETALLE.Imp01[2] + DETALLE.Imp02[2] + DETALLE.Imp03[2] +
                    DETALLE.Imp14[2] + DETALLE.Imp08[2] + DETALLE.Imp15[2] +
                    DETALLE.Imp05[2] + DETALLE.Imp16[2] + DETALLE.ImpOtro[2].
    DISPLAY STREAM REPORT
        DETALLE.nrocard   
        DETALLE.nomcli    
        DETALLE.punto01   
        DETALLE.punto02   
        DETALLE.punto03   
        DETALLE.punto14   
        DETALLE.punto08     
        DETALLE.punto15     
        DETALLE.punto05     
        DETALLE.punto16     
        DETALLE.puntoOtro   
        x-ImpNac
        x-ImpUsa
        WITH FRAME F-REPORTE.
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

    RUN Carga-Temporal.
    FIND FIRST DETALLE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE DETALLE THEN DO:
        MESSAGE
            'NO hay información a imprimir'
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.

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
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        RUN Formato.
        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            FRAME {&FRAME-NAME}:SENSITIVE = FALSE.
            RUN LIB/W-README.R(s-print-file).
            IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
            FRAME {&FRAME-NAME}:SENSITIVE = TRUE.
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
    x-Fecha-2 = TODAY
    x-Fecha-1 = TODAY - DAY(TODAY) + 1.

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

