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

DEFINE SHARED VAR s-codcia AS INT.

DEFINE STREAM REPORTE.

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-Fecha-1 FILL-IN-Fecha-2 RADIO-SET-1 ~
BUTTON-2 BtnDone 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Mensaje FILL-IN-Fecha-1 ~
FILL-IN-Fecha-2 RADIO-SET-1 rdPrecios 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "&Done" 
     SIZE 15 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "Button 2" 
     SIZE 15 BY 1.54.

DEFINE VARIABLE FILL-IN-Fecha-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 73 BY 1 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "EXCEL", 1,
"TEXTO", 2
     SIZE 12 BY 2.12 NO-UNDO.

DEFINE VARIABLE rdPrecios AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Mayorista", 1,
"Minorista", 2
     SIZE 22 BY 1.73 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     FILL-IN-Mensaje AT ROW 6.38 COL 3 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     FILL-IN-Fecha-1 AT ROW 1.58 COL 10 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-Fecha-2 AT ROW 2.73 COL 10 COLON-ALIGNED WIDGET-ID 8
     RADIO-SET-1 AT ROW 3.88 COL 12 NO-LABEL WIDGET-ID 10
     rdPrecios AT ROW 4.08 COL 32 NO-LABEL WIDGET-ID 16
     BUTTON-2 AT ROW 1.19 COL 63 WIDGET-ID 4
     BtnDone AT ROW 2.73 COL 63 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 6.88 WIDGET-ID 100.


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
         TITLE              = "REPORTE DE PRECIOS ACTUALIZADOS - MAYORISTA GENERAL"
         HEIGHT             = 6.88
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
   FRAME-NAME L-To-R,COLUMNS                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET rdPrecios IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* REPORTE DE PRECIOS ACTUALIZADOS - MAYORISTA GENERAL */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* REPORTE DE PRECIOS ACTUALIZADOS - MAYORISTA GENERAL */
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
      FILL-IN-Fecha-1 FILL-IN-Fecha-2 RADIO-SET-1 rdPrecios .
  IF rdPrecios = 1 THEN DO:
      /*
      IF RADIO-SET-1 = 1 THEN RUN Excel.
      IF RADIO-SET-1 = 2 THEN RUN Texto.
      */
  END.
  ELSE DO:
      IF RADIO-SET-1 = 1 THEN RUN ue-excel-minorista.
      IF RADIO-SET-1 = 2 THEN RUN Texto.
  END.
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
  DISPLAY FILL-IN-Mensaje FILL-IN-Fecha-1 FILL-IN-Fecha-2 RADIO-SET-1 rdPrecios 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE FILL-IN-Fecha-1 FILL-IN-Fecha-2 RADIO-SET-1 BUTTON-2 BtnDone 
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
DEF VAR x-Titulo AS CHAR FORMAT 'x(1000)' NO-UNDO.
DEF VAR x-Archivo AS CHAR NO-UNDO.


x-Archivo = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".txt".
x-Titulo = 'Articulo|Descripcion|Marca|Mon|TC|Max Dto|Und Base|Costo sin IGV|' +
            'Costo Lista Total|Precio Lista|%M Uti A|Precio A|UM A|%M Uti B|Precio B|UM B|'+
            '%M Uti C|Precio C|UM C|%M Uti Ofi|Precio Ofi|UM Ofi|' +
            'Fecha Modif|Usuario Modif'.

SESSION:SET-WAIT-STATE("general").
OUTPUT STREAM REPORTE TO VALUE (x-Archivo).
x-Titulo = REPLACE(x-Titulo, '|', CHR(9)).
PUT STREAM REPORTE UNFORMATTED x-Titulo SKIP.
FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia,
    LAST Logmmatg OF Almmmatg NO-LOCK WHERE logmmatg.LogDate >= FILL-IN-Fecha-1
    AND logmmatg.LogDate <= FILL-IN-Fecha-2:
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} =
        Almmmatg.CodMat + ' ' + Almmmatg.desmat.
    x-Llave = STRING (Almmmatg.codmat, '999999') + '|'.
    x-Llave = x-Llave + Almmmatg.desmat + '|'.
    x-Llave = x-Llave  + Almmmatg.desmar + '|'.
    x-Llave = x-Llave  + STRING (Logmmatg.monvta) + '|'.
    x-Llave = x-Llave  + STRING (Logmmatg.tpocmb) + '|'.
    x-Llave = x-Llave  + STRING (Logmmatg.pormax) + '|'.
    x-Llave = x-Llave  + Logmmatg.undbas + '|'.
    x-Llave = x-Llave  + STRING (Logmmatg.ctolis) + '|'.
    x-Llave = x-Llave  + STRING (Logmmatg.ctotot) + '|'.
    x-Llave = x-Llave  + STRING (Logmmatg.prevta[1]) + '|'.
    x-Llave = x-Llave  + (IF Logmmatg.mrguti-a <> ? THEN STRING (Logmmatg.mrguti-a) ELSE '') + '|'.
    x-Llave = x-Llave  + STRING (Logmmatg.prevta[2]) + '|'.
    x-Llave = x-Llave  + Logmmatg.unda + '|'.
    x-Llave = x-Llave  + (IF Logmmatg.mrguti-b <> ? THEN STRING (Logmmatg.mrguti-b) ELSE '') + '|'.
    x-Llave = x-Llave  + STRING (Logmmatg.prevta[3]) + '|'.
    x-Llave = x-Llave  + Logmmatg.undb + '|'.
    x-Llave = x-Llave  + (IF Logmmatg.mrguti-c <> ? THEN STRING (Logmmatg.mrguti-c) ELSE '') + '|'.
    x-Llave = x-Llave  + STRING (Logmmatg.prevta[4]) + '|'.
    x-Llave = x-Llave  + Logmmatg.undc + '|'.
    x-Llave = x-Llave  + (IF Logmmatg.dec__01 <> ? THEN STRING (Logmmatg.DEC__01) ELSE '') + '|'.
    x-Llave = x-Llave  + STRING (Logmmatg.preofi) + '|'.
    x-Llave = x-Llave  + Logmmatg.CHR__01 + '|'.
    x-Llave = x-Llave  +  STRING(logmmatg.LogDate, '99/99/9999') + '|' + logmmatg.LogUser.
    x-Llave = REPLACE(x-Llave, '|', CHR(9)).
    PUT STREAM REPORTE UNFORMATTED x-LLave SKIP.
END.
OUTPUT STREAM REPORTE CLOSE.
SESSION:SET-WAIT-STATE("").
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

/* CARGAMOS EL EXCEL */
RUN lib/filetext-to-excel(x-Archivo, 'Detallado', YES).



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
      FILL-IN-Fecha-1 = TODAY
      FILL-IN-Fecha-2 = TODAY.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Texto wWin 
PROCEDURE Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


DEF VAR x-Llave AS CHAR FORMAT 'x(1000)' NO-UNDO.
DEF VAR x-Titulo AS CHAR FORMAT 'x(1000)' NO-UNDO.
DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR lOk AS LOG NO-UNDO.

SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS "Texto *.txt" "*.txt"
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION ".txt"
    SAVE-AS
    UPDATE lOk.
IF lOk = NO THEN RETURN.

x-Titulo = 'Articulo'.

SESSION:SET-WAIT-STATE("general").
OUTPUT STREAM REPORTE TO VALUE (x-Archivo).
PUT STREAM REPORTE UNFORMATTED x-Titulo SKIP.
FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia,
    LAST Logmmatg OF Almmmatg NO-LOCK WHERE logmmatg.LogDate >= FILL-IN-Fecha-1
    AND logmmatg.LogDate <= FILL-IN-Fecha-2:
    PUT STREAM REPORTE Almmmatg.codmat SKIP.
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} =
        Almmmatg.CodMat + ' ' + Almmmatg.desmat.
END.
OUTPUT STREAM REPORTE CLOSE.
SESSION:SET-WAIT-STATE("").
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

MESSAGE 'Proceso Terminado'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-excel-minorista wWin 
PROCEDURE ue-excel-minorista :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR x-Llave AS CHAR FORMAT 'x(1000)' NO-UNDO.
DEF VAR x-Titulo AS CHAR FORMAT 'x(1000)' NO-UNDO.
DEF VAR x-Archivo AS CHAR NO-UNDO.


x-Archivo = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".txt".
x-Titulo = 'Articulo|Descripcion|CodFam|Familia|SubFam|Sub Familia|CodMarca|Marca|Mon|TC|%M Uti Ofi|Precio Ofi S/|UM Ofi|' +
            'Fecha Modif|Usuario Modif'.

SESSION:SET-WAIT-STATE("general").
OUTPUT STREAM REPORTE TO VALUE (x-Archivo).
x-Titulo = REPLACE(x-Titulo, '|', CHR(9)).
PUT STREAM REPORTE UNFORMATTED x-Titulo SKIP.
FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia,
    LAST LogListaMinGn OF Almmmatg NO-LOCK WHERE LogListaMinGn.LogDate >= FILL-IN-Fecha-1
    AND LogListaMinGn.LogDate <= FILL-IN-Fecha-2,
    FIRST almtfami OF almmmatg NO-LOCK,
    FIRST almsfami OF almmmatg NO-LOCK :

    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} =
        Almmmatg.CodMat + ' ' + Almmmatg.desmat.
    x-Llave = STRING (Almmmatg.codmat, '999999') + '|'.
    x-Llave = x-Llave + Almmmatg.desmat + '|'.
    x-Llave = x-Llave + Almmmatg.codfam + '|'.
    x-Llave = x-Llave + almtfami.desfam + '|'.
    x-Llave = x-Llave + Almmmatg.subfam + '|'.
    x-Llave = x-Llave + almsfam.dessub + '|'.
    x-Llave = x-Llave + Almmmatg.codmar + '|'.
    x-Llave = x-Llave  + Almmmatg.desmar + '|'.
    x-Llave = x-Llave  + STRING (LogListaMinGn.monvta) + '|'.
    x-Llave = x-Llave  + STRING (LogListaMinGn.tpocmb) + '|'.
    x-Llave = x-Llave  + (IF LogListaMinGn.dec__01 <> ? THEN STRING (LogListaMinGn.DEC__01) ELSE '') + '|'.
    x-Llave = x-Llave  + STRING ( LogListaMinGn.preofi  * (IF Almmmatg.MonVta = 1 THEN 1 ELSE Almmmatg.TpoCmb) ) + '|'.
    x-Llave = x-Llave  + LogListaMinGn.CHR__01 + '|'.
    x-Llave = x-Llave  +  STRING(LogListaMinGn.LogDate, '99/99/9999') + '|' + LogListaMinGn.LogUser.
    x-Llave = REPLACE(x-Llave, '|', CHR(9)).
    PUT STREAM REPORTE UNFORMATTED x-LLave SKIP.
END.
OUTPUT STREAM REPORTE CLOSE.
SESSION:SET-WAIT-STATE("").
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

/* CARGAMOS EL EXCEL */
RUN lib/filetext-to-excel(x-Archivo, 'Detallado', YES).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

