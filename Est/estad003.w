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
DEF SHARED VAR pv-codcia AS INT.

DEF TEMP-TABLE detalle LIKE almdmov
    FIELD Fecha AS INT FORMAT '99999'
    FIELD Importe AS DEC FORMAT '->>>,>>>,>>9.99'
    INDEX Llave01 AS PRIMARY codcia fecha codmat tipmov codmov.

DEFINE TEMP-TABLE tt-articulo
    FIELDS codmat LIKE almmmatg.codmat
    FIELDS desmat LIKE almmmatg.desmat
    INDEX idx01 IS PRIMARY codmat.

DEF VAR x-CuentaReg  AS INT             NO-UNDO.    /* Contador de registros */
DEF VAR x-MuestraReg AS INT             NO-UNDO.    /* Tope para mostrar registros */
DEF VAR x-CodMat LIKE almmmatg.codmat  NO-UNDO.
DEF VAR x-CodFam LIKE almmmatg.codfam  NO-UNDO.
DEF VAR x-SubFam LIKE almmmatg.subfam  NO-UNDO.

DEF STREAM REPORTE.

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 ~
FILL-IN-CodMat BUTTON-6 COMBO-BOX-CodFam COMBO-BOX-SubFam BUTTON-1 BtnDone 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 ~
FILL-IN-CodMat FILL-IN-DesMat FILL-IN-file-2 COMBO-BOX-CodFam ~
COMBO-BOX-SubFam FILL-IN-Mensaje 

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
     SIZE 6 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 1" 
     SIZE 6 BY 1.62.

DEFINE BUTTON BUTTON-6 
     LABEL "..." 
     SIZE 5 BY 1.

DEFINE VARIABLE COMBO-BOX-CodFam AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Linea" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 43 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-SubFam AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Sub-linea" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 43 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodMat AS CHARACTER FORMAT "X(6)":U 
     LABEL "Codigo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-DesMat AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 75 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-file-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 76 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 90 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     FILL-IN-FchDoc-1 AT ROW 1.81 COL 9 COLON-ALIGNED WIDGET-ID 32
     FILL-IN-FchDoc-2 AT ROW 1.81 COL 35 COLON-ALIGNED WIDGET-ID 34
     FILL-IN-CodMat AT ROW 2.88 COL 9.14 COLON-ALIGNED WIDGET-ID 70
     FILL-IN-DesMat AT ROW 2.88 COL 24 COLON-ALIGNED NO-LABEL WIDGET-ID 72
     FILL-IN-file-2 AT ROW 3.96 COL 9 COLON-ALIGNED NO-LABEL WIDGET-ID 76
     BUTTON-6 AT ROW 3.92 COL 88 WIDGET-ID 74
     COMBO-BOX-CodFam AT ROW 5.04 COL 9 COLON-ALIGNED WIDGET-ID 36
     COMBO-BOX-SubFam AT ROW 6.12 COL 9 COLON-ALIGNED WIDGET-ID 38
     FILL-IN-Mensaje AT ROW 7.46 COL 9 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     BUTTON-1 AT ROW 1 COL 88 WIDGET-ID 24
     BtnDone AT ROW 1 COL 95 WIDGET-ID 28
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 101.72 BY 8.12 WIDGET-ID 100.


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
         TITLE              = "MOVIMIENTOS POR ARTICULO"
         HEIGHT             = 8.12
         WIDTH              = 101.72
         MAX-HEIGHT         = 31.62
         MAX-WIDTH          = 146.14
         VIRTUAL-HEIGHT     = 31.62
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
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-DesMat IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-file-2 IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* MOVIMIENTOS POR ARTICULO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* MOVIMIENTOS POR ARTICULO */
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
    ASSIGN
        COMBO-BOX-CodFam 
        COMBO-BOX-SubFam 
        FILL-IN-CodMat 
        FILL-IN-FchDoc-1 
        FILL-IN-FchDoc-2 
        FILL-IN-file-2.
   RUN Carga-Temporal.
   FIND FIRST detalle NO-ERROR.
   IF NOT AVAILABLE detalle THEN DO:
       MESSAGE 'No hay registros' VIEW-AS ALERT-BOX WARNING.
       RETURN NO-APPLY.
   END.
   SESSION:SET-WAIT-STATE('GENERAL').
   RUN Excel.
   SESSION:SET-WAIT-STATE('').
   ASSIGN
       FILL-IN-file-2 = ''.
   DISPLAY FILL-IN-file-2 WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 wWin
ON CHOOSE OF BUTTON-6 IN FRAME fMain /* ... */
DO:

    DEFINE VARIABLE OKpressed AS LOGICAL NO-UNDO.

    SYSTEM-DIALOG GET-FILE FILL-IN-file-2
        FILTERS
            "Archivos Texto (*.txt)" "*.txt"
        TITLE
            "Archivo(s) de Carga..."
        MUST-EXIST
        USE-FILENAME
        UPDATE OKpressed.

    IF OKpressed = TRUE THEN
        FILL-IN-file-2:SCREEN-VALUE = FILL-IN-file-2.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-CodFam wWin
ON VALUE-CHANGED OF COMBO-BOX-CodFam IN FRAME fMain /* Linea */
DO:
    COMBO-BOX-SubFam:DELETE(COMBO-BOX-SubFam:LIST-ITEMS).
    COMBO-BOX-SubFam:ADD-LAST('Todos').
    COMBO-BOX-SubFam:SCREEN-VALUE = 'Todos'.
    IF SELF:SCREEN-VALUE <> 'Todos' THEN DO:
        FOR EACH Almsfami NO-LOCK WHERE Almsfami.codcia = s-codcia
            AND Almsfami.codfam = ENTRY(1, SELF:SCREEN-VALUE, ' - '):
            COMBO-BOX-SubFam:ADD-LAST(Almsfami.subfam + ' - '+ AlmSFami.dessub).
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodMat wWin
ON LEAVE OF FILL-IN-CodMat IN FRAME fMain /* Codigo */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  FIND almmmatg WHERE almmmatg.codcia = s-codcia
      AND almmmatg.codmat = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE almmmatg THEN DO:
      MESSAGE 'Articulo Inválido' VIEW-AS ALERT-BOX ERROR.
      SELF:SCREEN-VALUE = ''.
      RETURN NO-APPLY.
  END.
  FILL-IN-DesMat:SCREEN-VALUE = almmmatg.desmat.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Lista-Articulos wWin 
PROCEDURE Carga-Lista-Articulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE tt-articulo.

    /* Carga de Excel */
    DEF VAR x-codmat LIKE Almmmatg.codmat NO-UNDO.

    IF SEARCH(FILL-IN-file-2) <> ? THEN DO:
        INPUT FROM VALUE(FILL-IN-file-2).
        REPEAT:
            IMPORT UNFORMATTED x-codmat.
            IF x-codmat <> '' THEN DO:
                FIND tt-articulo WHERE tt-articulo.codmat = x-codmat NO-ERROR.
                IF NOT AVAILABLE tt-articulo THEN CREATE tt-articulo.
                tt-articulo.codmat = x-codmat.
            END.
        END.
        INPUT CLOSE.
    END.
    FIND FIRST tt-articulo NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-articulo THEN DO:
        CREATE tt-articulo.
        ASSIGN tt-articulo.codmat = FILL-IN-CodMat.
    END.

    /*Carga Tabla Articulos*/
    FOR EACH tt-articulo:
        FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
            AND Almmmatg.codmat = tt-articulo.codmat
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmatg THEN DO:
            DELETE tt-articulo.
            NEXT.
        END.
    END.

    x-CodMat = ''.
    FOR EACH tt-articulo:
        IF x-CodMat = '' THEN x-CodMat = tt-articulo.codmat.
        ELSE x-CodMat = x-CodMat + ',' + tt-articulo.codmat.
    END.

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

DEF VAR iFecha AS INT NO-UNDO.

EMPTY TEMP-TABLE detalle.
SESSION:SET-WAIT-STATE('GENERAL').

ASSIGN
    x-CodFam = ''
    x-SubFam = ''
    x-CodMat = ''
    x-CuentaReg = 0
    x-MuestraReg = 1000.    /* cada 1000 registros */
x-CodMat = FILL-IN-CodMat.
IF NOT COMBO-BOX-CodFam BEGINS 'Todos' THEN x-CodFam = ENTRY(1, COMBO-BOX-CodFam, ' - ').
IF NOT COMBO-BOX-SubFam BEGINS 'Todos' THEN x-SubFam = ENTRY(1, COMBO-BOX-SubFam, ' - ').

RUN Carga-Lista-Articulos.

FOR EACH Almacen NO-LOCK WHERE Almacen.codcia = s-codcia:
    FOR EACH Almdmov USE-INDEX Almd04 NO-LOCK WHERE Almdmov.codcia = s-codcia
        AND Almdmov.codalm = Almacen.codalm
        AND Almdmov.fchdoc >= FILL-IN-FchDoc-1
        AND Almdmov.fchdoc <= FILL-IN-FchDoc-2
        AND (x-CodMat = '' OR LOOKUP (Almdmov.codmat, x-CodMat) > 0),
        FIRST Almmmatg OF Almdmov NO-LOCK WHERE Almmmatg.codfam BEGINS x-CodFam
        AND Almmmatg.subfam BEGINS x-SubFam:
        IF x-CuentaReg = 0 OR ( x-CuentaReg MODULO x-MuestraReg ) = 0 THEN
            FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '** PROCESANDO' +
            ' FECHA ' + STRING (Almdmov.fchdoc) +
            ' ALMACEN ' + Almdmov.codalm +
            ' PRODUCTO ' + Almdmov.codmat.
        x-CuentaReg = x-CuentaReg + 1.
        iFecha = YEAR(almdmov.fchdoc) * 100 + MONTH(almdmov.fchdoc).
        FIND detalle WHERE detalle.codcia = almdmov.codcia
            AND detalle.fecha = iFecha
            AND detalle.codmat = almdmov.codmat
            AND detalle.tipmov = almdmov.tipmov
            AND detalle.codmov = almdmov.codmov
            NO-ERROR.
        IF NOT AVAILABLE detalle THEN DO:
            CREATE detalle.
            ASSIGN
                detalle.fecha = iFecha
                detalle.codcia = almdmov.codcia
                detalle.codmat = almdmov.codmat
                detalle.tipmov = almdmov.tipmov
                detalle.codmov = almdmov.codmov.
        END.
        ASSIGN
            detalle.candes = detalle.candes + ( almdmov.candes * almdmov.factor )
            detalle.importe = detalle.importe + ( almdmov.vctomn1 * almdmov.candes * almdmov.factor ).
    END.
END.

SESSION:SET-WAIT-STATE('').

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
  DISPLAY FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 FILL-IN-CodMat FILL-IN-DesMat 
          FILL-IN-file-2 COMBO-BOX-CodFam COMBO-BOX-SubFam FILL-IN-Mensaje 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 FILL-IN-CodMat BUTTON-6 
         COMBO-BOX-CodFam COMBO-BOX-SubFam BUTTON-1 BtnDone 
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

DEF VAR x-Llave AS CHAR FORMAT 'x(1000)' NO-UNDO.
DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR x-Titulo AS CHAR FORMAT 'x(500)' NO-UNDO.
DEF VAR x-Cuenta-Registros AS INT INIT 0 NO-UNDO.

x-Archivo = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".txt".

FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** GENERANDO EL EXCEL **".
OUTPUT STREAM REPORTE TO VALUE (x-Archivo).
x-Titulo = 'Periodo|Mes|Producto|Linea|Sublinea|Proveedor|Movimiento|Cantidad|Unidad|Promedio|'.
x-Titulo = REPLACE(x-Titulo, '|', CHR(9)).
PUT STREAM REPORTE x-Titulo SKIP.
FOR EACH detalle, FIRST Almmmatg OF detalle NO-LOCK,
    FIRST Almtfami OF Almmmatg NO-LOCK, FIRST Almsfami OF Almmmatg NO-LOCK:
    x-Llave = SUBSTRING(STRING(detalle.Fecha, '999999'),1,4) + '|'.
    x-Llave = x-Llave + SUBSTRING(STRING(detalle.Fecha, '999999'),5,2) + '|'.
    x-Llave = x-llave + detalle.codmat + ' ' + almmmatg.desmat + '|'.
    x-Llave = x-Llave + almmmatg.codfam + ' ' + Almtfami.desfam + '|'.
    x-Llave = x-Llave + almmmatg.subfam + ' ' + AlmSFami.dessub + '|'.
    FIND gn-prov WHERE gn-prov.codcia = pv-codcia
        AND gn-prov.codpro = Almmmatg.codpr1
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-prov 
        THEN x-Llave = x-Llave + gn-prov.CodPro + ' ' + gn-prov.NomPro + '|'.
    ELSE x-Llave = x-Llave + ' |'.
    x-Llave = x-Llave + TRIM(detalle.tipmov) + '-' + STRING(detalle.codmov,'99') + '|'.
    x-Llave = x-Llave + STRING(detalle.candes, '->>>,>>>,>>9.99') + '|'.
    x-Llave = x-Llave + Almmmatg.undbas + '|'.
    x-Llave = x-Llave + STRING(detalle.importe, '>>>,>>>,>>9.99') + '|'.
    x-Llave = REPLACE(x-Llave, '|', CHR(9)).
    PUT STREAM REPORTE x-LLave SKIP.
    /* RHC 01.04.11 control de registros */
    x-Cuenta-Registros = x-Cuenta-Registros + 1.
    IF x-Cuenta-Registros > 65000 THEN DO:
        MESSAGE 'Se ha llegado al tope de 65000 registros que soporta el Excel' SKIP
            'Carga abortada' VIEW-AS ALERT-BOX WARNING.
        LEAVE.
    END.
END.
OUTPUT STREAM REPORTE CLOSE.
/* CARGAMOS EL EXCEL */
RUN lib/filetext-to-excel(x-Archivo, 'Detallado', YES).
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** FIN DEL PROCESO **".

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
  ASSIGN
    FILL-IN-FchDoc-1 = TODAY - DAY(TODAY) + 1
    FILL-IN-FchDoc-2 = TODAY.
  FOR EACH Almtfami NO-LOCK WHERE Almtfami.CodCia = s-codcia:
      COMBO-BOX-CodFam:ADD-LAST(Almtfami.codfam + ' - ' + Almtfami.desfam) IN FRAME {&FRAME-NAME}.
  END.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

