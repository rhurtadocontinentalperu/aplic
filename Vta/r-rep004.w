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

DEF VAR s-task-no AS INT.

DEF VAR RB-REPORT-LIBRARY AS CHAR INITIAL "vta/rbvta.prl".
DEF VAR RB-REPORT-NAME AS CHAR INITIAL "".
DEF VAR RB-INCLUDE-RECORDS AS CHAR INITIAL "".
DEF VAR RB-FILTER AS CHAR INITIAL "".
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS x-CodFam x-SubFam x-TpoCmb Btn_OK Btn_Done 
&Scoped-Define DISPLAYED-OBJECTS x-CodFam x-DesFam x-SubFam x-DesSub ~
x-TpoCmb 

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

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\print-2":U
     LABEL "&Imprimir" 
     SIZE 8 BY 1.92
     BGCOLOR 8 .

DEFINE VARIABLE x-CodFam AS CHARACTER FORMAT "x(3)":U 
     LABEL "Familia" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

DEFINE VARIABLE x-DesFam AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .81 NO-UNDO.

DEFINE VARIABLE x-DesSub AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .81 NO-UNDO.

DEFINE VARIABLE x-SubFam AS CHARACTER FORMAT "x(3)":U 
     LABEL "Sub-Familia" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

DEFINE VARIABLE x-TpoCmb AS DECIMAL FORMAT ">>>,>>9.99":U INITIAL 0 
     LABEL "Tipo de Cambio" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-CodFam AT ROW 2.15 COL 16 COLON-ALIGNED
     x-DesFam AT ROW 2.15 COL 23 COLON-ALIGNED NO-LABEL
     x-SubFam AT ROW 3.31 COL 16 COLON-ALIGNED
     x-DesSub AT ROW 3.31 COL 23 COLON-ALIGNED NO-LABEL
     x-TpoCmb AT ROW 4.46 COL 16 COLON-ALIGNED
     Btn_OK AT ROW 6.19 COL 5
     Btn_Done AT ROW 6.19 COL 14
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
         TITLE              = "Reporte Daniel"
         HEIGHT             = 8.15
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
   L-To-R                                                               */
/* SETTINGS FOR FILL-IN x-DesFam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-DesSub IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Reporte Daniel */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte Daniel */
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
    x-CodFam x-SubFam x-TpoCmb.
  IF x-TpoCmb = 0 THEN DO:
    MESSAGE 'Ingrese el Tipo de Cambio' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO x-TpoCmb.
    RETURN NO-APPLY.
  END.
  RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodFam W-Win
ON LEAVE OF x-CodFam IN FRAME F-Main /* Familia */
DO:
  x-DesFam:SCREEN-VALUE = ''.
  FIND Almtfami WHERE Almtfami.codcia = s-codcia
    AND Almtfami.codfam = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE Almtfami THEN x-DesFam:SCREEN-VALUE = Almtfami.desfam.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-SubFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-SubFam W-Win
ON LEAVE OF x-SubFam IN FRAME F-Main /* Sub-Familia */
DO:
  x-DesSub:SCREEN-VALUE = ''.
  FIND Almsfami WHERE Almsfami.codcia = s-codcia
    AND Almsfami.codfam = x-CodFam:SCREEN-VALUE
    AND Almsfami.subfam = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE Almsfami THEN x-DesSub:SCREEN-VALUE = AlmSFami.dessub.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Stock W-Win 
PROCEDURE Carga-Stock :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAMETER pArray AS INT.
  

  FIND LAST Almstkal WHERE Almstkal.codcia = Almmmatg.codcia
    AND Almstkal.codmat = Almmmatg.codmat
    AND Almstkal.codalm = Almacen.codalm
    AND Almstkal.fecha <= TODAY
    NO-LOCK NO-ERROR.
  IF AVAILABLE Almstkal THEN DO:
    ASSIGN
        w-report.campo-f[pArray] = w-report.campo-f[pArray] + Almstkal.stkact.
  END.
  
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
  REPEAT:
    s-Task-No = RANDOM(1,999999).
    FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        LEAVE.
    END.
  END.
  
  FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codfam BEGINS x-CodFam
        AND Almmmatg.SubFam BEGINS x-SubFam:
    DISPLAY 'Procesando' Almmmatg.codmat SKIP
        WITH NO-LABELS CENTERED OVERLAY VIEW-AS DIALOG-BOX FRAME f-Mensaje.
    FIND w-report WHERE w-report.task-no = s-task-no
      AND w-report.campo-c[1] = Almmmatg.codmat
      EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN CREATE w-report.
    ASSIGN    
      w-report.task-no = s-task-no
      w-report.campo-c[1] = Almmmatg.codmat
      w-report.campo-c[2] = Almmmatg.desmat
      w-report.campo-c[3] = Almmmatg.codfam
      w-report.campo-c[4] = Almmmatg.subfam
      w-report.campo-c[5] = Almmmatg.desmar
      w-report.campo-c[6] = Almmmatg.undbas.
    IF Almmmatg.monvta = 1
    THEN w-report.campo-f[7] = Almmmatg.CtoTot / x-TpoCmb.
    ELSE w-report.campo-f[7] = Almmmatg.CtoTot.
    FIND LAST Almstkge WHERE Almstkge.codcia = Almmmatg.codcia
      AND Almstkge.codmat = Almmmatg.codmat
      AND Almstkge.fecha <= TODAY
      NO-LOCK NO-ERROR.
    IF AVAILABLE Almstkge THEN DO:
          w-report.campo-f[6] = AlmStkge.CtoUni / x-TpoCmb.
    END.
    /* ACUMULAMOS STOCK */
    FOR EACH Almacen NO-LOCK WHERE Almacen.codcia = s-codcia:
        CASE Almacen.coddiv:
            WHEN '00000' THEN RUN Carga-Stock (9).
            WHEN '00001' OR WHEN '00002' OR WHEN '00003' OR WHEN '00014'
                OR WHEN '00008' THEN RUN Carga-Stock (10).
            OTHERWISE RUN Carga-Stock (11).
        END CASE.
    END.
    /* VENTAS PROMEDIO */
    RUN Carga-Ventas.
  END.  
  
  FOR EACH w-report WHERE w-report.task-no = s-task-no:
    ASSIGN
        w-report.campo-f[8] = w-report.campo-f[9] + w-report.campo-f[10] + w-report.campo-f[11]
        w-report.campo-f[1] = (IF w-report.campo-f[16] <> 0 then w-report.campo-f[8] / w-report.campo-f[16] else 0)
        w-report.campo-f[2] = campo-f[8] * campo-f[6]
        w-report.campo-f[3] = campo-f[8] * campo-f[7].
    IF w-report.campo-f[18] <> 0 THEN
    ASSIGN
        w-report.campo-f[5] = ( w-report.campo-f[18] - w-report.campo-f[2]) / w-report.campo-f[18] * 100.
  END.
  
  HIDE FRAME f-Mensaje.
  
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Ventas W-Win 
PROCEDURE Carga-Ventas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR DesdeF AS DATE NO-UNDO.
  DEF VAR HastaF AS DATE NO-UNDO.
  DEF VAR t-VtaMe AS DEC NO-UNDO.
  DEF VAR f-Salida AS DEC NO-UNDO.
  
  /* ULTIMOS 12 MESES */
  DesdeF = TODAY - 365.
  HastaF = TODAY.

  RUN Carga-Ventas-2 (DesdeF, HastaF, OUTPUT f-Salida, OUTPUT t-VtaMe).

  IF t-VtaMe <> 0 OR f-Salida <> 0 THEN DO:
    ASSIGN    
        w-report.campo-f[16] = f-Salida
        w-report.campo-f[18] = t-VtaMe.
  END.
  /* ULTIMOS 3 MESES */
  DesdeF = TODAY - 90.
  HastaF = TODAY.

  RUN Carga-Ventas-2 (DesdeF, HastaF, OUTPUT f-Salida, OUTPUT t-VtaMe).

  IF t-VtaMe <> 0 OR f-Salida <> 0 THEN DO:
    ASSIGN    
        w-report.campo-f[17] = f-Salida
        w-report.campo-f[19] = t-VtaMe.
  END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Ventas-2 W-Win 
PROCEDURE Carga-Ventas-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAMETER DesdeF AS DATE.
  DEF INPUT PARAMETER HastaF AS DATE.
  DEF OUTPUT PARAMETER f-Salida AS DEC.
  DEF OUTPUT PARAMETER t-VtaMe AS DEC.
  
  DEF VAR x-CodMes AS INT NO-UNDO.
  DEF VAR x-CodAno AS INT NO-UNDO.
  DEF VAR x-CodDia AS INT INIT 1 NO-UNDO.
  DEF VAR x-Fecha AS DATE NO-UNDO.
  DEF VAR i AS INT NO-UNDO.
  
  ASSIGN
    f-Salida = 0
    t-VtaMe = 0.
  FOR EACH Gn-Divi NO-LOCK WHERE Gn-Divi.Codcia = S-CODCIA:
    FOR EACH Evtarti NO-LOCK WHERE Evtarti.CodCia = S-CODCIA
            AND Evtarti.CodDiv = Gn-Divi.Coddiv
            AND Evtarti.Codmat = Almmmatg.codmat
            AND (Evtarti.Nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99"))
            AND Evtarti.Nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99")) ):
        /*****************Capturando el Mes siguiente *******************/
        IF Evtarti.Codmes < 12 
        THEN ASSIGN
                X-CODMES = Evtarti.Codmes + 1
                X-CODANO = Evtarti.Codano .
        ELSE ASSIGN
                X-CODMES = 01
                X-CODANO = Evtarti.Codano + 1 .
        /*********************** Calculo Para Obtener los datos diarios ************/
        DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ): 
            X-FECHA = DATE(STRING(I,"99") + "/" + STRING(Evtarti.Codmes,"99") + "/" + STRING(Evtarti.Codano,"9999")).
            IF X-FECHA >= DesdeF AND X-FECHA <= HastaF THEN DO:
                FIND Gn-tcmb WHERE Gn-tcmb.Fecha = DATE(STRING(I,"99") + "/" + STRING(Evtarti.Codmes,"99") + "/" + STRING(Evtarti.Codano,"9999")) NO-LOCK NO-ERROR.
                IF AVAILABLE Gn-tcmb THEN DO: 
                    F-Salida  = F-Salida  + Evtarti.CanxDia[I].
                    T-Vtame   = T-Vtame   + Evtarti.Vtaxdiame[I] + Evtarti.Vtaxdiamn[I] / Gn-Tcmb.Compra.
                END.
            END.
        END.         
    END.
  END.

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
  DISPLAY x-CodFam x-DesFam x-SubFam x-DesSub x-TpoCmb 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE x-CodFam x-SubFam x-TpoCmb Btn_OK Btn_Done 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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

    RUN carga-temporal.
    HIDE FRAME f-mensaje NO-PAUSE.

    FIND FIRST w-report WHERE
        w-report.task-no = s-task-no NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        MESSAGE
            "No existen registros a imprimir"
            VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.

    GET-KEY-VALUE SECTION 'STARTUP' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
    ASSIGN
        RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "vta\rbvta.prl"
        RB-REPORT-NAME = 'Ventas Inventario y Margen'
        RB-INCLUDE-RECORDS = "O"
        RB-FILTER = "w-report.task-no = "+ STRING(s-task-no)
        RB-OTHER-PARAMETERS = 's-nomcia = ' + s-nomcia.

    RUN lib/_Imprime2(
        RB-REPORT-LIBRARY,
        RB-REPORT-NAME,
        RB-INCLUDE-RECORDS,
        RB-FILTER,
        RB-OTHER-PARAMETERS).

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-parametros W-Win 
PROCEDURE Recoge-parametros :
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
        WHEN "x-SubFam" THEN 
            ASSIGN
                input-var-1 = x-CodFam:SCREEN-VALUE IN FRAME {&FRAME-NAME}
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


