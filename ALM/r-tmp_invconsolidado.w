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

DEF TEMP-TABLE Detalle
    FIELD codcia AS INT 
    FIELD codmat AS CHAR FORMAT 'x(6)' LABEL 'Codigo'
    FIELD desmat AS CHAR FORMAT 'x(60)' LABEL 'Descripcion'
    FIELD undstk AS CHAR FORMAT 'x(6)' LABEL 'Unidad'
    FIELD ubicacion AS CHAR FORMAT 'x(30)' LABEL 'Ubicación'
    FIELD caninv AS DEC FORMAT '>>>,>>9.99' LABEL 'Inventariado'
    FIELD conti-11 AS DEC FORMAT '>>>,>>9.99' LABEL 'Stock-Conti-Alm11'
    FIELD conti-22 AS DEC FORMAT '>>>,>>9.99' LABEL 'Stock-Conti-Alm22'
    FIELD conti-85 AS DEC FORMAT '>>>,>>9.99' LABEL 'Stock-Conti-Alm85'
    FIELD cissac-11 AS DEC FORMAT '>>>,>>9.99' LABEL 'Stock-Cissac-Alm11'
    FIELD cissac-22 AS DEC FORMAT '>>>,>>9.99' LABEL 'Stock-Cissac-Alm22'
    FIELD cissac-85 AS DEC FORMAT '>>>,>>9.99' LABEL 'Stock-Cissac-Alm85'
    FIELD ctoprom AS DEC FORMAT '>>>,>>9.99' LABEL 'Costo-Promedio-Unitario'
    INDEX Llave01 AS PRIMARY UNIQUE codcia codmat.
DEF SHARED VAR s-codcia AS INT.

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
&Scoped-Define ENABLED-OBJECTS BUTTON-1 BtnDone 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Mensaje 

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

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     FILL-IN-Mensaje AT ROW 1.54 COL 9 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     BUTTON-1 AT ROW 3.69 COL 50 WIDGET-ID 2
     BtnDone AT ROW 3.69 COL 65 WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 4.88 WIDGET-ID 100.


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
         TITLE              = "CONSOLIDADO DE INVENTARIOS"
         HEIGHT             = 4.88
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
ON END-ERROR OF wWin /* CONSOLIDADO DE INVENTARIOS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* CONSOLIDADO DE INVENTARIOS */
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
  RUN Imprimir.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal wWin 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR x-StkAct AS DEC.
DEF VAR x-conti-11 AS DEC.
DEF VAR x-conti-22 AS DEC.
DEF VAR x-conti-85 AS DEC.
DEF VAR x-cissac-11 AS DEC.
DEF VAR x-cissac-22 AS DEC.
DEF VAR x-cissac-85 AS DEC.
DEF VAR x-FchInv AS DATE.

x-FchInv = 03/23/2012.

EMPTY TEMP-TABLE Detalle.
/* consolidamos lo inventariado */
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'CONSOLIDANDO'.
FOR EACH tmp_invconteo NO-LOCK WHERE tmp_invconteo.CodCia = s-codcia,
    FIRST integral.Almmmatg OF tmp_invconteo NO-LOCK:
    FIND detalle OF tmp_invconteo NO-ERROR.
    IF NOT AVAILABLE detalle THEN DO:
        CREATE detalle.
        ASSIGN
            detalle.codcia = s-codcia
            detalle.codmat = tmp_invconteo.codmat
            detalle.desmat = integral.Almmmatg.desmat
            detalle.undstk = integral.Almmmatg.undstk.
        FIND LAST integral.almstkge WHERE integral.almstkge.codcia = s-codcia
            AND integral.almstkge.codmat = tmp_invconteo.codmat
            AND integral.almstkge.fecha <= x-FchInv
            NO-LOCK NO-ERROR.
        IF AVAILABLE integral.almstkge THEN detalle.ctoprom = integral.almstkge.CtoUni.
    END.
    ASSIGN
        detalle.caninv = detalle.caninv + tmp_invconteo.CanInv.
END.
/* stocks de lo inventariado */
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'STOCKS'.
FOR EACH detalle:
    FIND LAST integral.almstkal OF detalle WHERE integral.almstkal.fecha <= x-FchInv AND integral.almstkal.codalm = '11' NO-LOCK NO-ERROR.
    IF AVAILABLE integral.almstkal THEN detalle.conti-11 = integral.almstkal.stkact.
    FIND LAST integral.almstkal OF detalle WHERE integral.almstkal.fecha <= x-FchInv AND integral.almstkal.codalm = '22' NO-LOCK NO-ERROR.
    IF AVAILABLE integral.almstkal THEN detalle.conti-22 = integral.almstkal.stkact.
    FIND LAST integral.almstkal OF detalle WHERE integral.almstkal.fecha <= x-FchInv AND integral.almstkal.codalm = '85' NO-LOCK NO-ERROR.
    IF AVAILABLE integral.almstkal THEN detalle.conti-85 = integral.almstkal.stkact.
    FIND LAST cissac.almstkal OF detalle WHERE cissac.almstkal.fecha <= x-FchInv AND cissac.almstkal.codalm = '11' NO-LOCK NO-ERROR.
    IF AVAILABLE cissac.almstkal THEN detalle.cissac-11 = cissac.almstkal.stkact.
    FIND LAST cissac.almstkal OF detalle WHERE cissac.almstkal.fecha <= x-FchInv AND cissac.almstkal.codalm = '22' NO-LOCK NO-ERROR.
    IF AVAILABLE cissac.almstkal THEN detalle.cissac-22 = cissac.almstkal.stkact.
    FIND LAST cissac.almstkal OF detalle WHERE cissac.almstkal.fecha <= x-FchInv AND cissac.almstkal.codalm = '85' NO-LOCK NO-ERROR.
    IF AVAILABLE cissac.almstkal THEN detalle.cissac-85 = cissac.almstkal.stkact.
END.
/* stocks de lo no inventariado */
FOR EACH integral.almmmatg NO-LOCK WHERE integral.almmmatg.codcia = s-codcia:
    FIND FIRST detalle OF integral.almmmatg NO-LOCK NO-ERROR.
    IF AVAILABLE detalle THEN NEXT.
    ASSIGN
        x-StkAct = 0
        x-conti-11 = 0
        x-conti-22 = 0
        x-conti-85 = 0
        x-cissac-11 = 0
        x-cissac-22 = 0
        x-cissac-85 = 0.
    FIND LAST integral.almstkal OF integral.almmmatg WHERE integral.almstkal.fecha <= x-FchInv AND integral.almstkal.codalm = '11' NO-LOCK NO-ERROR.
    IF AVAILABLE integral.almstkal THEN x-conti-11 = integral.almstkal.stkact.
    FIND LAST integral.almstkal OF integral.almmmatg WHERE integral.almstkal.fecha <= x-FchInv AND integral.almstkal.codalm = '22' NO-LOCK NO-ERROR.
    IF AVAILABLE integral.almstkal THEN x-conti-22 = integral.almstkal.stkact.
    FIND LAST integral.almstkal OF integral.almmmatg WHERE integral.almstkal.fecha <= x-FchInv AND integral.almstkal.codalm = '85' NO-LOCK NO-ERROR.
    IF AVAILABLE integral.almstkal THEN x-conti-85 = integral.almstkal.stkact.
    FIND LAST cissac.almstkal OF integral.almmmatg WHERE cissac.almstkal.fecha <= x-FchInv AND cissac.almstkal.codalm = '11' NO-LOCK NO-ERROR.
    IF AVAILABLE cissac.almstkal THEN x-cissac-11 = cissac.almstkal.stkact.
    FIND LAST cissac.almstkal OF integral.almmmatg WHERE cissac.almstkal.fecha <= x-FchInv AND cissac.almstkal.codalm = '22' NO-LOCK NO-ERROR.
    IF AVAILABLE cissac.almstkal THEN x-cissac-22 = cissac.almstkal.stkact.
    FIND LAST cissac.almstkal OF integral.almmmatg WHERE cissac.almstkal.fecha <= x-FchInv AND cissac.almstkal.codalm = '85' NO-LOCK NO-ERROR.
    IF AVAILABLE cissac.almstkal THEN x-cissac-85 = cissac.almstkal.stkact.
    x-StkAct = abs(x-conti-11) + abs(x-conti-22) + abs(x-conti-85) + 
        abs(x-cissac-11) + abs(x-cissac-22) + abs(x-cissac-85).
    IF x-StkAct <> 0 THEN DO:
        CREATE Detalle.
        ASSIGN
            detalle.codcia = s-codcia
            detalle.codmat = integral.almmmatg.codmat
            detalle.desmat = integral.Almmmatg.desmat
            detalle.undstk = integral.Almmmatg.undstk
            detalle.conti-11 = x-conti-11
            detalle.conti-22 = x-conti-22
            detalle.conti-85 = x-conti-85
            detalle.cissac-11 = x-cissac-11
            detalle.cissac-22 = x-cissac-22
            detalle.cissac-85 = x-cissac-85.
        FIND LAST integral.almstkge WHERE integral.almstkge.codcia = s-codcia
            AND integral.almstkge.codmat = integral.almmmatg.codmat
            NO-LOCK NO-ERROR.
        IF AVAILABLE integral.almstkge THEN detalle.ctoprom = integral.almstkge.CtoUni.
    END.
END.
/* ubicaciones */
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'UBICACION'.
FOR EACH detalle:
    FOR EACH tmp_invconteo NO-LOCK WHERE tmp_invconteo.CodCia = s-codcia
        AND tmp_invconteo.codmat = detalle.codmat:
        detalle.ubicacion = detalle.ubicacion + (IF detalle.ubicacion = '' THEN '' ELSE ',') +
                            tmp_invconteo.Ubicacion.
    END.
END.
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.

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
  DISPLAY FILL-IN-Mensaje 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE BUTTON-1 BtnDone 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir wWin 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR pOptions AS CHAR.
DEF VAR pArchivo AS CHAR.
DEF VAR lOptions AS CHAR.

    RUN lib/tt-file-to-text (OUTPUT pOptions, OUTPUT pArchivo).
    IF pOptions = "" THEN RETURN.

    SESSION:SET-WAIT-STATE('GENERAL').
    RUN Carga-Temporal.
    SESSION:SET-WAIT-STATE('').

    FIND FIRST Detalle NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Detalle THEN DO:
        MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.
    pOptions = pOptions + CHR(1) + "SkipList:CodCia".

    RUN lib/tt-file (TEMP-TABLE Detalle:HANDLE, pArchivo, pOptions).

    MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

