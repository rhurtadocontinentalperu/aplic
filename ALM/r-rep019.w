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
DEF STREAM REPORTE.

DEF TEMP-TABLE detalle
    FIELD linea AS CHAR
    FIELD stkact AS DEC EXTENT 400
    FIELD ultmov AS CHAR EXTENT 400
    FIELD fchmov AS DATE EXTENT 400
    FIELD ctopro AS DEC EXTENT 400.

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
&Scoped-Define ENABLED-OBJECTS BUTTON-2 BtnDone COMBO-BOX-Familias 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Tiempo COMBO-BOX-Familias ~
FILL-IN-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for OCX Containers                            */
DEFINE VARIABLE CtrlFrame AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE chCtrlFrame AS COMPONENT-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 6 BY 1.38
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 2" 
     SIZE 6 BY 1.35.

DEFINE VARIABLE COMBO-BOX-Familias AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Familia" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todas" 
     DROP-DOWN-LIST
     SIZE 60 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Tiempo AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Meses" 
     VIEW-AS FILL-IN 
     SIZE 4 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     BUTTON-2 AT ROW 1.27 COL 61 WIDGET-ID 8
     BtnDone AT ROW 1.27 COL 67 WIDGET-ID 6
     FILL-IN-Tiempo AT ROW 1.54 COL 9 COLON-ALIGNED WIDGET-ID 4
     COMBO-BOX-Familias AT ROW 2.88 COL 9 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-Mensaje AT ROW 6.38 COL 9 COLON-ALIGNED NO-LABEL WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 6.77 WIDGET-ID 100.


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
         TITLE              = "ARTICULOS CON STOCK Y SIN MOVIMIENTOS"
         HEIGHT             = 6.77
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
/* SETTINGS FOR FILL-IN FILL-IN-Tiempo IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


/* **********************  Create OCX Containers  ********************** */

&ANALYZE-SUSPEND _CREATE-DYNAMIC

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN

CREATE CONTROL-FRAME CtrlFrame ASSIGN
       FRAME           = FRAME fMain:HANDLE
       ROW             = 1.54
       COLUMN          = 15
       HEIGHT          = 1.08
       WIDTH           = 4
       WIDGET-ID       = 2
       HIDDEN          = no
       SENSITIVE       = yes.

PROCEDURE adm-create-controls:
      CtrlFrame:NAME = "CtrlFrame":U .
/* CtrlFrame OCXINFO:CREATE-CONTROL from: {EAF26C8F-9586-101B-9306-0020AF234C9D} type: CSSpin */
      CtrlFrame:MOVE-AFTER(FILL-IN-Tiempo:HANDLE IN FRAME fMain).

END PROCEDURE.

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* ARTICULOS CON STOCK Y SIN MOVIMIENTOS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* ARTICULOS CON STOCK Y SIN MOVIMIENTOS */
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


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 wWin
ON CHOOSE OF BUTTON-2 IN FRAME fMain /* Button 2 */
DO:
  ASSIGN
      FILL-IN-Tiempo COMBO-BOX-Familias.
  RUN Excel02.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CtrlFrame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CtrlFrame wWin OCX.SpinDown
PROCEDURE CtrlFrame.CSSpin.SpinDown .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  None required for OCX.
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(FILL-IN-Tiempo:SCREEN-VALUE) > 1 
    THEN ASSIGN
            FILL-IN-Tiempo:SCREEN-VALUE = STRING(INTEGER(FILL-IN-Tiempo:SCREEN-VALUE) - 1).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CtrlFrame wWin OCX.SpinUp
PROCEDURE CtrlFrame.CSSpin.SpinUp .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  None required for OCX.
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN FILL-IN-Tiempo:SCREEN-VALUE = STRING(INTEGER(FILL-IN-Tiempo:SCREEN-VALUE) + 1).
END.


END PROCEDURE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE control_load wWin  _CONTROL-LOAD
PROCEDURE control_load :
/*------------------------------------------------------------------------------
  Purpose:     Load the OCXs    
  Parameters:  <none>
  Notes:       Here we load, initialize and make visible the 
               OCXs in the interface.                        
------------------------------------------------------------------------------*/

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN
DEFINE VARIABLE UIB_S    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE OCXFile  AS CHARACTER  NO-UNDO.

OCXFile = SEARCH( "r-rep019.wrx":U ).
IF OCXFile = ? THEN
  OCXFile = SEARCH(SUBSTRING(THIS-PROCEDURE:FILE-NAME, 1,
                     R-INDEX(THIS-PROCEDURE:FILE-NAME, ".":U), "CHARACTER":U) + "wrx":U).

IF OCXFile <> ? THEN
DO:
  ASSIGN
    chCtrlFrame = CtrlFrame:COM-HANDLE
    UIB_S = chCtrlFrame:LoadControls( OCXFile, "CtrlFrame":U)
  .
  RUN initialize-controls IN THIS-PROCEDURE NO-ERROR.
END.
ELSE MESSAGE "r-rep019.wrx":U SKIP(1)
             "The binary control file could not be found. The controls cannot be loaded."
             VIEW-AS ALERT-BOX TITLE "Controls Not Loaded".

&ENDIF

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
  DISPLAY FILL-IN-Tiempo COMBO-BOX-Familias FILL-IN-Mensaje 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE BUTTON-2 BtnDone COMBO-BOX-Familias 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel wWin 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR x-stkact AS DEC NO-UNDO.
DEF VAR x-stkcol AS DEC NO-UNDO.
DEF VAR x-linea AS CHAR NO-UNDO.
DEF VAR x-almacenes AS CHAR NO-UNDO.
DEF VAR x-Titulo AS CHAR NO-UNDO.
DEF VAR x-Titulo2 AS CHAR NO-UNDO.
DEF VAR j AS INT NO-UNDO.
DEF VAR sw AS LOG NO-UNDO.
DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR x-CodFam AS CHAR NO-UNDO.

x-Archivo = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".txt".

FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** GENERANDO EL EXCEL **".
OUTPUT STREAM REPORTE TO VALUE (x-Archivo).

x-Titulo = 'Codigo|Descripcion|Marca|Familia|Subfamilia|Unidad|'.
x-Almacenes = ''.
IF COMBO-BOX-Familias = 'Todas' THEN x-CodFam = ''.
ELSE x-CodFam = ENTRY(1, COMBO-BOX-Familias, ' - ').

FOR EACH almmmatg NO-LOCK WHERE codcia = s-codcia AND codfam BEGINS x-codfam:
    x-stkact = 0.
    sw = NO.
    FOR EACH almmmate NO-LOCK WHERE Almmmate.codcia = s-codcia
        AND Almmmate.codmat = Almmmatg.codmat:
        x-stkact = x-stkact + almmmate.stkact.
    END.
    IF x-stkact <= 0 THEN NEXT.
    FIND LAST almdmov USE-INDEX almd07
        WHERE almdmov.codcia = s-codcia
        AND almdmov.codmat = almmmatg.codmat
        AND LOOKUP(STRING(almdmov.codmov, '99'), '03,12') = 0
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE almdmov THEN NEXT.
    IF almdmov.fchdoc > ( TODAY  - (30 * FILL-IN-Tiempo) ) THEN NEXT.
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "CODIGO: " + almmmatg.codmat + " " +
        almmmatg.desmat.
    x-linea = almmmatg.codmat + '|' +
        almmmatg.desmat + '|' +
        almmmatg.desmar + '|' +
        almmmatg.codfam + '|' +
        almmmatg.subfam + '|' +
        almmmatg.undstk + '|'.
    FOR EACH almacen NO-LOCK WHERE almacen.codcia = s-codcia:
        x-stkact = 0.
        FIND almmmate WHERE almmmate.codcia = s-codcia
            AND almmmate.codalm = almacen.codalm
            AND almmmate.codmat = almmmatg.codmat
            NO-LOCK NO-ERROR.
        IF AVAILABLE almmmate THEN x-stkact = almmmate.stkact.
        IF x-stkact > 0 THEN DO:
            IF sw = NO THEN DO:
                CREATE detalle.
                detalle.linea = x-linea.
                sw = YES.
            END.
            IF LOOKUP(almacen.codalm, x-Almacenes, '|') = 0 THEN DO:
                x-Almacenes = x-Almacenes + almacen.codalm + '|'.
            END.
            j = LOOKUP(almacen.codalm, x-Almacenes, '|').
            detalle.stkact[j] = x-stkact.
            /* ultimo movimiento por el almacen */
            FIND LAST almdmov USE-INDEX almd03
                WHERE almdmov.codcia = s-codcia
                AND almdmov.codalm = almacen.codalm
                AND almdmov.codmat = almmmatg.codmat
                AND LOOKUP(STRING(almdmov.codmov, '99'), '03,12') = 0
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Almdmov THEN FIND LAST almdmov USE-INDEX almd03
                WHERE almdmov.codcia = s-codcia
                AND almdmov.codalm = almacen.codalm
                AND almdmov.codmat = almmmatg.codmat
                NO-LOCK NO-ERROR.
            IF AVAILABLE almdmov THEN DO:
                detalle.ultmov[j] = STRING(almdmov.tipmov, 'XX') + STRING(almdmov.codmov, '99').
                detalle.fchmov[j] = almdmov.fchdoc.
                FIND LAST almstkge WHERE almstkge.codcia = s-codcia
                    AND almstkge.codmat = almmmatg.codmat
                    AND almstkge.fecha <= almdmov.fchdoc
                    NO-LOCK NO-ERROR.
                IF AVAILABLE almstkge THEN detalle.ctopro[j] = AlmStkge.CtoUni.
            END.
        END.
    END.
END.

x-Titulo2 = ''.
DO j = 1 TO NUM-ENTRIES(x-Almacenes, '|'):
    x-Titulo2 = x-Titulo2 + 'Alm.' + ENTRY(j, x-Almacenes, '|') + '|' + 
                'Mov.|Fch.Mov|Costo|'.
END.
x-Titulo = x-Titulo + x-Titulo2.
x-Titulo = REPLACE(x-Titulo, '|', CHR(9)).
PUT STREAM REPORTE x-Titulo FORMAT 'x(600)' SKIP.

FOR EACH detalle:
    x-linea = TRIM(detalle.linea).
    DO j = 1 TO NUM-ENTRIES(x-Almacenes, '|'):
        x-linea = x-linea + STRING(detalle.stkact[j], '>>>>>9.99') + '|' +
            STRING(detalle.ultmov[j], 'x(5)') + '|'.
        IF detalle.fchmov[j] = ? 
        THEN x-linea = x-linea + " " + '|'.
        ELSE x-linea = x-linea + STRING(detalle.fchmov[j], '99/99/9999') + '|'.
        x-linea = x-linea + STRING(detalle.ctopro[j], '->>>>>>9.99') + '|'.
    END.
    x-linea = REPLACE(x-linea, '|', CHR(9)).
    PUT STREAM REPORTE x-linea FORMAT 'x(600)' SKIP.
END.
OUTPUT STREAM REPORTE CLOSE.
/* CARGAMOS EL EXCEL */
RUN lib/filetext-to-excel(x-Archivo, 'Detallado', YES).
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** FIN DEL PROCESO **".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel02 wWin 
PROCEDURE Excel02 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR x-stkact AS DEC NO-UNDO.
DEF VAR x-stkcol AS DEC NO-UNDO.
DEF VAR x-linea AS CHAR NO-UNDO.
DEF VAR x-almacenes AS CHAR NO-UNDO.
DEF VAR x-Titulo AS CHAR NO-UNDO.
DEF VAR x-Titulo2 AS CHAR NO-UNDO.
DEF VAR j AS INT NO-UNDO.
DEF VAR sw AS LOG NO-UNDO.
DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR x-CodFam AS CHAR NO-UNDO.

x-Archivo = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".txt".

FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** GENERANDO EL EXCEL **".
OUTPUT STREAM REPORTE TO VALUE (x-Archivo).

x-Titulo = 'Codigo|Descripcion|Marca|Familia|Subfamilia|Unidad|Cat.Contable|Almacen|Stock|Mov.|Fecha|Costo|'.
x-Almacenes = ''.
IF COMBO-BOX-Familias = 'Todas' THEN x-CodFam = ''.
ELSE x-CodFam = ENTRY(1, COMBO-BOX-Familias, ' - ').

FOR EACH almmmatg NO-LOCK WHERE codcia = s-codcia AND codfam BEGINS x-codfam:
    x-stkact = 0.
    sw = NO.
    FOR EACH almmmate NO-LOCK WHERE Almmmate.codcia = s-codcia
        AND Almmmate.codmat = Almmmatg.codmat:
        x-stkact = x-stkact + almmmate.stkact.
    END.
    IF x-stkact <= 0 THEN NEXT.
    FIND LAST almdmov USE-INDEX ALMD02      /* almd07 */
        WHERE almdmov.codcia = s-codcia
        AND almdmov.codmat = almmmatg.codmat
        AND LOOKUP(STRING(almdmov.codmov, '99'), '03,12') = 0
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE almdmov THEN NEXT.
    IF almdmov.fchdoc > ( TODAY  - (30 * FILL-IN-Tiempo) ) THEN NEXT.
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "CODIGO: " + almmmatg.codmat + " " +
        almmmatg.desmat.
    FOR EACH almacen NO-LOCK WHERE almacen.codcia = s-codcia:
        x-stkact = 0.
        FIND almmmate WHERE almmmate.codcia = s-codcia
            AND almmmate.codalm = almacen.codalm
            AND almmmate.codmat = almmmatg.codmat
            NO-LOCK NO-ERROR.
        IF AVAILABLE almmmate THEN x-stkact = almmmate.stkact.
        IF x-stkact > 0 THEN DO:
            x-linea = almmmatg.codmat + '|' +
                almmmatg.desmat + '|' +
                almmmatg.desmar + '|' +
                almmmatg.codfam + '|' +
                almmmatg.subfam + '|' +
                almmmatg.undstk + '|' + 
                almmmatg.catconta[1] + '|' + 
                almmmate.codalm + '|' .
            CREATE detalle.
            ASSIGN 
                detalle.linea = x-linea
                detalle.stkact[1] = x-stkact.

            /* ultimo movimiento por el almacen */
            FIND LAST almdmov USE-INDEX almd03
                WHERE almdmov.codcia = s-codcia
                AND almdmov.codalm = almacen.codalm
                AND almdmov.codmat = almmmatg.codmat
                /*AND LOOKUP(STRING(almdmov.codmov, '99'), '03,12') = 0*/
                NO-LOCK NO-ERROR.
            IF AVAILABLE almdmov THEN DO:
                detalle.ultmov[1] = STRING(almdmov.tipmov, 'XX') + STRING(almdmov.codmov, '99').
                detalle.fchmov[1] = almdmov.fchdoc.
                FIND LAST almstkge WHERE almstkge.codcia = s-codcia
                    AND almstkge.codmat = almmmatg.codmat
                    AND almstkge.fecha <= almdmov.fchdoc
                    NO-LOCK NO-ERROR.
                IF AVAILABLE almstkge THEN detalle.ctopro[1] = AlmStkge.CtoUni.
            END.
        END.
    END.
END.

x-Titulo2 = ''.
DO j = 1 TO NUM-ENTRIES(x-Almacenes, '|'):
    x-Titulo2 = x-Titulo2 + 'Alm.' + 'Mov.|Fch.Mov|Costo|'.
END.
x-Titulo = x-Titulo + x-Titulo2.
x-Titulo = REPLACE(x-Titulo, '|', CHR(9)).
PUT STREAM REPORTE x-Titulo FORMAT 'x(600)' SKIP.

FOR EACH detalle:
    x-linea = TRIM(detalle.linea).

    DO j = 1 TO 1:
        x-linea = x-linea + STRING(detalle.stkact[1], '>>>>>9.99') + '|' +
            STRING(detalle.ultmov[1], 'x(5)') + '|'.
        IF detalle.fchmov[1] = ? 
        THEN x-linea = x-linea + " " + '|'.
        ELSE x-linea = x-linea + STRING(detalle.fchmov[1], '99/99/9999') + '|'.
        x-linea = x-linea + STRING(detalle.ctopro[1], '->>>>>>9.99') + '|'.
    END.
    x-linea = REPLACE(x-linea, '|', CHR(9)).
    PUT STREAM REPORTE x-linea FORMAT 'x(600)' SKIP.
END.
OUTPUT STREAM REPORTE CLOSE.
/* CARGAMOS EL EXCEL */
RUN lib/filetext-to-excel(x-Archivo, 'Detallado', YES).
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** FIN DEL PROCESO **".


END PROCEDURE.

/*
DEF VAR x-stkact AS DEC NO-UNDO.
DEF VAR x-stkcol AS DEC NO-UNDO.
DEF VAR x-linea AS CHAR NO-UNDO.
DEF VAR x-almacenes AS CHAR NO-UNDO.
DEF VAR x-Titulo AS CHAR NO-UNDO.
DEF VAR x-Titulo2 AS CHAR NO-UNDO.
DEF VAR j AS INT NO-UNDO.
DEF VAR sw AS LOG NO-UNDO.
DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR x-CodFam AS CHAR NO-UNDO.

x-Archivo = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".txt".

FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** GENERANDO EL EXCEL **".
OUTPUT STREAM REPORTE TO VALUE (x-Archivo).

x-Titulo = 'Codigo|Descripcion|Marca|Familia|Subfamilia|Unidad|Cat.Contable|Almacen|Stock|Mov.|Fecha|Costo|'.
x-Almacenes = ''.
IF COMBO-BOX-Familias = 'Todas' THEN x-CodFam = ''.
ELSE x-CodFam = ENTRY(1, COMBO-BOX-Familias, ' - ').

FOR EACH almmmatg NO-LOCK WHERE codcia = s-codcia AND codfam BEGINS x-codfam:
    x-stkact = 0.
    sw = NO.
    FOR EACH almmmate NO-LOCK WHERE Almmmate.codcia = s-codcia
        AND Almmmate.codmat = Almmmatg.codmat:
        x-stkact = x-stkact + almmmate.stkact.
    END.
    IF x-stkact <= 0 THEN NEXT.
    FIND LAST almdmov USE-INDEX almd07
        WHERE almdmov.codcia = s-codcia
        AND almdmov.codmat = almmmatg.codmat
        AND LOOKUP(STRING(almdmov.codmov, '99'), '03,12') = 0
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE almdmov THEN NEXT.
    IF almdmov.fchdoc > ( TODAY  - (30 * FILL-IN-Tiempo) ) THEN NEXT.
    FIND LAST almdmov USE-INDEX almd02
        WHERE almdmov.codcia = s-codcia
        AND almdmov.codmat = almmmatg.codmat
        NO-LOCK NO-ERROR.
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "CODIGO: " + almmmatg.codmat + " " +
        almmmatg.desmat.
    FOR EACH almacen NO-LOCK WHERE almacen.codcia = s-codcia:
        x-stkact = 0.
        FIND almmmate WHERE almmmate.codcia = s-codcia
            AND almmmate.codalm = almacen.codalm
            AND almmmate.codmat = almmmatg.codmat
            NO-LOCK NO-ERROR.
        IF AVAILABLE almmmate THEN x-stkact = almmmate.stkact.
        IF x-stkact > 0 THEN DO:

            x-linea = almmmatg.codmat + '|' +
                almmmatg.desmat + '|' +
                almmmatg.desmar + '|' +
                almmmatg.codfam + '|' +
                almmmatg.subfam + '|' +
                almmmatg.undstk + '|' + 
                almmmatg.catconta[1] + '|' + 
                almmmate.codalm + '|' .

            CREATE detalle.
            ASSIGN 
                detalle.linea = x-linea
                detalle.stkact[1] = x-stkact.

            /* ultimo movimiento por el almacen */
/*             FIND LAST almdmov USE-INDEX almd03                        */
/*                 WHERE almdmov.codcia = s-codcia                       */
/*                 AND almdmov.codalm = almacen.codalm                   */
/*                 AND almdmov.codmat = almmmatg.codmat                  */
/*                 AND LOOKUP(STRING(almdmov.codmov, '99'), '03,12') = 0 */
/*                 NO-LOCK NO-ERROR.                                     */
            IF AVAILABLE almdmov THEN DO:
                detalle.ultmov[1] = STRING(almdmov.tipmov, 'XX') + STRING(almdmov.codmov, '99').
                detalle.fchmov[1] = almdmov.fchdoc.
                FIND LAST almstkge WHERE almstkge.codcia = s-codcia
                    AND almstkge.codmat = almmmatg.codmat
                    AND almstkge.fecha <= almdmov.fchdoc
                    NO-LOCK NO-ERROR.
                IF AVAILABLE almstkge THEN detalle.ctopro[1] = AlmStkge.CtoUni.
            END.
        END.
    END.
END.

x-Titulo2 = ''.
DO j = 1 TO NUM-ENTRIES(x-Almacenes, '|'):
    x-Titulo2 = x-Titulo2 + 'Alm.' + 'Mov.|Fch.Mov|Costo|'.
END.
x-Titulo = x-Titulo + x-Titulo2.
x-Titulo = REPLACE(x-Titulo, '|', CHR(9)).
PUT STREAM REPORTE x-Titulo FORMAT 'x(600)' SKIP.

FOR EACH detalle:
    x-linea = TRIM(detalle.linea).

    DO j = 1 TO 1:
        x-linea = x-linea + STRING(detalle.stkact[1], '>>>>>9.99') + '|' +
            STRING(detalle.ultmov[1], 'x(5)') + '|'.
        IF detalle.fchmov[1] = ? 
        THEN x-linea = x-linea + " " + '|'.
        ELSE x-linea = x-linea + STRING(detalle.fchmov[1], '99/99/9999') + '|'.
        x-linea = x-linea + STRING(detalle.ctopro[1], '->>>>>>9.99') + '|'.
    END.
    x-linea = REPLACE(x-linea, '|', CHR(9)).
    PUT STREAM REPORTE x-linea FORMAT 'x(600)' SKIP.
END.
OUTPUT STREAM REPORTE CLOSE.
/* CARGAMOS EL EXCEL */
RUN lib/filetext-to-excel(x-Archivo, 'Detallado', YES).
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** FIN DEL PROCESO **".
*/

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
  FILL-IN-Tiempo = 2.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      FOR EACH almtfami NO-LOCK WHERE almtfami.codcia = s-codcia.
          COMBO-BOX-Familias:ADD-LAST(almtfami.codfam + " - " + almtfami.desfam).
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

