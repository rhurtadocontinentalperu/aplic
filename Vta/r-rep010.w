&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWin 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: New V9 Version - January 15, 1998
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AB.              */
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

{src/adm2/widgetprto.i}

DEF SHARED VAR s-codcia AS INT.

DEF VAR s-task-no AS INT.

DEF TEMP-TABLE Detalle
    FIELD coddiv AS CHAR FORMAT 'x(5)' LABEL 'División'
    FIELD coddoc LIKE ccbcdocu.coddoc LABEL 'Documento'
    FIELD nrodoc LIKE ccbcdocu.nrodoc LABEL 'Número'
    FIELD fchdoc LIKE ccbcdocu.fchdoc LABEL 'Emisión'
    FIELD codmat LIKE almmmatg.codmat LABEL 'Producto'
    FIELD desmat AS CHAR FORMAT 'x(60)' LABEL 'Descripción'
    FIELD prevta AS DEC FORMAT '>>>,>>>,>>9.99' LABEL 'Unitario de Venta'
    FIELD undvta AS CHAR FORMAT 'x(6)' LABEL 'Unidad de Venta'
    FIELD prebas AS DEC FORMAT '>>>,>>>,>>9.99' LABEL 'Unitario Lista Precios'
    FIELD undbas AS CHAR FORMAT 'x(6)' LABEL 'Unidad Lista Precios'
    FIELD univta AS DEC FORMAT '>>>,>>>,>>9.99' LABEL 'Unitario Absoluto Venta'
    FIELD unibas AS DEC FORMAT '>>>,>>>,>>9.99' LABEL 'Unitario Absoluto Lista'
    FIELD undstk AS CHAR FORMAT 'x(5)' LABEL 'Unidad Absoluta'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-Division FILL-IN-FchDoc-1 ~
FILL-IN-FchDoc-2 FILL-IN-Factor BUTTON-1 BtnDone 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Division FILL-IN-FchDoc-1 ~
FILL-IN-FchDoc-2 FILL-IN-Factor FILL-IN-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 15 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/print (2).ico":U
     LABEL "Button 1" 
     SIZE 15 BY 1.62.

DEFINE VARIABLE COMBO-BOX-Division AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "División" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todas" 
     DROP-DOWN-LIST
     SIZE 50 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Factor AS DECIMAL FORMAT ">>9.99":U INITIAL .2 
     LABEL "Diferencia en %" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde el" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta el" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     COMBO-BOX-Division AT ROW 2.08 COL 19 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-FchDoc-1 AT ROW 3.15 COL 19 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-FchDoc-2 AT ROW 4.23 COL 19 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-Factor AT ROW 5.31 COL 19 COLON-ALIGNED WIDGET-ID 8
     FILL-IN-Mensaje AT ROW 6.38 COL 6 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     BUTTON-1 AT ROW 7.73 COL 46 WIDGET-ID 10
     BtnDone AT ROW 7.73 COL 61 WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 8.77 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "DIFERENCIAS DE PRECIOS COMPROBANTES MANUALES UTILEX"
         HEIGHT             = 8.77
         WIDTH              = 80
         MAX-HEIGHT         = 28.81
         MAX-WIDTH          = 146.14
         VIRTUAL-HEIGHT     = 28.81
         VIRTUAL-WIDTH      = 146.14
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* DIFERENCIAS DE PRECIOS COMPROBANTES MANUALES UTILEX */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* DIFERENCIAS DE PRECIOS COMPROBANTES MANUALES UTILEX */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone wWin
ON CHOOSE OF BtnDone IN FRAME fMain /* Done */
DO:
  &IF "{&PROCEDURE-TYPE}" EQ "SmartPanel" &THEN
    &IF "{&ADM-VERSION}" EQ "ADM1.1" &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
    &ELSE
      RUN exitObject.
    &ENDIF
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 wWin
ON CHOOSE OF BUTTON-1 IN FRAME fMain /* Button 1 */
DO:
  ASSIGN COMBO-BOX-Division FILL-IN-Factor FILL-IN-FchDoc-1 FILL-IN-FchDoc-2.
  RUN Carga-temporal.
  FIND FIRST Detalle NO-ERROR.
  IF NOT AVAILABLE Detalle THEN DO:
      MESSAGE 'No hay registros a imprimir' VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.

  DEF VAR pOptions AS CHAR INIT ''.
  DEF VAR pArchivo AS CHAR INIT ''.

  RUN lib/tt-file-to-text (OUTPUT pOptions, OUTPUT pArchivo).
  IF pArchivo = '' THEN RETURN NO-APPLY.
  RUN lib/tt-file (TEMP-TABLE Detalle:HANDLE, pArchivo, pOptions).

  MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-temporal wWin 
PROCEDURE Carga-temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-PreUni AS DEC.
DEF VAR x-PreLis AS DEC.

DEF VAR f-CanPed AS DEC.
DEF VAR s-UndVta AS CHAR.
DEF VAR f-Factor AS DEC.
DEF VAR f-PreBas AS DEC.
DEF VAR f-PreVta AS DEC.
DEF VAR f-Dsctos AS DEC.
DEF VAR y-Dsctos AS DEC.
DEF VAR z-Dsctos AS DEC.
DEF VAR x-TipDto AS CHAR.

EMPTY TEMP-TABLE Detalle.
FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia
    AND ( COMBO-BOX-Division = 'Todas' OR gn-divi.coddiv = ENTRY(1, COMBO-BOX-Division, ' - ') ):
    FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia
        AND ccbcdocu.coddiv = gn-divi.coddiv
        AND LOOKUP(ccbcdocu.coddoc, 'FAC,BOL') > 0
        AND ccbcdocu.fchdoc >= FILL-IN-FchDoc-1 
        AND ccbcdocu.fchdoc <= FILL-IN-FchDoc-2
        AND ccbcdocu.flgest <> "A"
        AND ccbcdocu.tpofac = "M":
         FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} =
             'PROCESANDO ' + STRING(ccbcdocu.coddiv, 'x(5)') + ' ' +
             ccbcdocu.coddoc + ' ' + ccbcdocu.nrodoc.
        FOR EACH ccbddocu OF ccbcdocu NO-LOCK, FIRST Almmmatg OF ccbddocu NO-LOCK:
            /* buscamos el precio de venta por lista de precios minorista general */
            /* todas las ventas son en SOLES */
            RUN PrecioListaMinorista (
                ccbcdocu.CodDiv,
                ccbcdocu.CodMon,
                OUTPUT s-UndVta,
                OUTPUT f-Factor,
                ccbddocu.CodMat,
                ccbddocu.CanDes,
                4,
                ccbcdocu.flgsit,       /* s-codbko, */
                OUTPUT f-PreBas
                ).
/*             RUN vtagn/PrecioListaMinorista-1 (                         */
/*                                 ccbcdocu.CodDiv,                       */
/*                                 ccbcdocu.CodMon,                       */
/*                                 ccbcdocu.TpoCmb,                       */
/*                                 OUTPUT s-UndVta,                       */
/*                                 OUTPUT f-Factor,                       */
/*                                 ccbddocu.CodMat,                       */
/*                                 ccbddocu.CanDes,                       */
/*                                 4,                                     */
/*                                 ccbcdocu.flgsit,       /* s-codbko, */ */
/*                                 OUTPUT f-PreBas,                       */
/*                                 OUTPUT f-PreVta,                       */
/*                                 OUTPUT f-Dsctos,                       */
/*                                 OUTPUT y-Dsctos,                       */
/*                                 OUTPUT z-Dsctos,                       */
/*                                 OUTPUT x-TipDto                        */
/*                                 ).                                     */
            /* todos los precios unitarios deben representarse a una sola unidad */
            ASSIGN
                x-PreUni = ccbddocu.preuni / ccbddocu.factor
                x-PreLis = f-PreBas / f-Factor.
            IF ( ABS(x-PreUni - f-PreBas) / x-PreLis ) > ( FILL-IN-Factor / 100 ) THEN DO:
                CREATE Detalle.
                ASSIGN
                    Detalle.coddiv = ccbcdocu.coddiv
                    Detalle.coddoc = ccbcdocu.coddoc
                    Detalle.nrodoc = ccbcdocu.nrodoc
                    Detalle.fchdoc = ccbcdocu.fchdoc
                    Detalle.codmat = ccbddocu.codmat
                    Detalle.desmat = almmmatg.desmat
                    Detalle.prevta = ccbddocu.preuni
                    Detalle.undvta = ccbddocu.undvta
                    Detalle.prebas = f-PreBas
                    Detalle.undbas = s-UndVta
                    Detalle.univta = x-PreUni
                    Detalle.unibas = x-PreLis
                    Detalle.undstk = Almmmatg.UndStk.
            END.
        END.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWin  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
  THEN DELETE WIDGET wWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWin  _DEFAULT-ENABLE
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
  DISPLAY COMBO-BOX-Division FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 FILL-IN-Factor 
          FILL-IN-Mensaje 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE COMBO-BOX-Division FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 FILL-IN-Factor 
         BUTTON-1 BtnDone 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject wWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DO WITH FRAME {&FRAME-NAME}:
      FOR EACH gn-divi NO-LOCK WHERE codcia = s-codcia AND 
          gn-divi.desdiv BEGINS "UTILEX":
          COMBO-BOX-Division:ADD-LAST(gn-divi.coddiv + ' - ' + GN-DIVI.DesDiv).
      END.
      ASSIGN
          FILL-IN-FchDoc-1 = TODAY - DAY(TODAY) + 1
          FILL-IN-FchDoc-2 = TODAY.
  END.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PrecioListaMinorista wWin 
PROCEDURE PrecioListaMinorista :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER S-CODDIV AS CHAR.
DEF INPUT PARAMETER S-CODMON AS INT.
DEF OUTPUT PARAMETER S-UNDVTA AS CHAR.
DEF OUTPUT PARAMETER f-Factor AS DEC.
DEF INPUT PARAMETER S-CODMAT AS CHAR.
DEF INPUT PARAMETER X-CANPED AS DEC.
DEF INPUT PARAMETER x-NroDec AS INT.
DEF INPUT PARAMETER s-FlgSit AS CHAR.
DEF OUTPUT PARAMETER F-PREBAS AS DEC.

DEF VAR s-TpoCmb AS DEC.

/* CONFIGURACIONES DE LA DIVISION */
FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = s-coddiv NO-LOCK.

/* LISTAS DE PRECIOS */
CASE gn-divi.VentaMinorista:
    WHEN 1 THEN DO:
        FIND FIRST VtaListaMinGn OF Almmmatg NO-LOCK NO-ERROR.
        IF NOT AVAILABLE VtaListaMinGn THEN RETURN.
        ASSIGN
            s-UndVta = VtaListaMinGn.Chr__01.

        /* FACTOR DE EQUIVALENCIA */
        FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
            AND Almtconv.Codalter = s-undvta
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almtconv THEN RETURN.
        F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.

        /* RHC 12.06.08 tipo de cambio de la familia */
        s-tpocmb = VtaListaMinGn.TpoCmb.     /* ¿? */

        /* PRECIO BASE  */
        IF S-CODMON = 1 THEN DO:
            IF VtaListaMinGn.MonVta = 1 
            THEN ASSIGN F-PREBAS = VtaListaMinGn.PreOfi.
            ELSE ASSIGN F-PREBAS = VtaListaMinGn.PreOfi * S-TPOCMB.
        END.
        IF S-CODMON = 2 THEN DO:
            IF VtaListaMinGn.MonVta = 2 
            THEN ASSIGN F-PREBAS = VtaListaMinGn.PreOfi.
            ELSE ASSIGN F-PREBAS = (VtaListaMinGn.PreOfi / S-TPOCMB).
        END.
    END.
    WHEN 2 THEN DO:
        FIND FIRST VtaListaMin OF Almmmatg WHERE VtaListaMin.CodDiv = s-CodDiv NO-LOCK NO-ERROR.
        IF NOT AVAILABLE VtaListaMin THEN RETURN.
        ASSIGN
            s-UndVta = VtaListaMin.Chr__01.
        /* FACTOR DE EQUIVALENCIA */
        FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
            AND Almtconv.Codalter = s-undvta
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almtconv THEN RETURN.
        F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.

        /* RHC 12.06.08 tipo de cambio de la familia */
        s-tpocmb = VtaListaMin.TpoCmb.     /* ¿? */

        /* PRECIO BASE  */
        IF S-CODMON = 1 THEN DO:
            IF VtaListaMin.MonVta = 1 
            THEN ASSIGN F-PREBAS = VtaListaMin.PreOfi.
            ELSE ASSIGN F-PREBAS = VtaListaMin.PreOfi * S-TPOCMB.
        END.
        IF S-CODMON = 2 THEN DO:
            IF VtaListaMin.MonVta = 2 
            THEN ASSIGN F-PREBAS = VtaListaMin.PreOfi.
            ELSE ASSIGN F-PREBAS = (VtaListaMin.PreOfi / S-TPOCMB).
        END.
    END.
END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

