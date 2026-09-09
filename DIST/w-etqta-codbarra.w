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

/*{src/adm2/widgetprto.i}*/

DEF STREAM REPORTE.

DEFINE TEMP-TABLE tt-filer
    FIELD   t-codigo    AS CHAR     FORMAT 'x(25)' INIT ''
    FIELD   t-dato      AS CHAR     FORMAT 'x(60)' INIT ''
    FIELD   t-dato2     AS CHAR     FORMAT 'x(60)' INIT ''.

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
&Scoped-Define ENABLED-OBJECTS txtCuantas btnFile BUTTON-2 btn 
&Scoped-Define DISPLAYED-OBJECTS txtCuantas txtFile 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btn 
     LABEL "Imprimir" 
     SIZE 15 BY 1.12.

DEFINE BUTTON btnFile 
     LABEL "..." 
     SIZE 3.57 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "Limpiar file" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE txtCuantas AS CHARACTER FORMAT "X(20)":U 
     LABEL "Codigo a Imprimir" 
     VIEW-AS FILL-IN 
     SIZE 31 BY 1 NO-UNDO.

DEFINE VARIABLE txtFile AS CHARACTER FORMAT "X(256)":U 
     LABEL "File" 
     VIEW-AS FILL-IN 
     SIZE 76 BY 1
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     txtCuantas AT ROW 2.54 COL 21 COLON-ALIGNED WIDGET-ID 2
     txtFile AT ROW 3.88 COL 4.57 COLON-ALIGNED WIDGET-ID 8
     btnFile AT ROW 3.85 COL 82.72 WIDGET-ID 10
     BUTTON-2 AT ROW 5.04 COL 38 WIDGET-ID 12
     btn AT ROW 6.96 COL 68 WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 86.29 BY 7.35 WIDGET-ID 100.


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
         TITLE              = "Generacion de Codigo de Barras 128 (RRHH)"
         HEIGHT             = 7.35
         WIDTH              = 86.29
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
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN txtFile IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* Generacion de Codigo de Barras 128 (RRHH) */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Generacion de Codigo de Barras 128 (RRHH) */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn wWin
ON CHOOSE OF btn IN FRAME fMain /* Imprimir */
DO:
  ASSIGN txtCuantas txtFile.
  IF txtCuantas <> '' OR txtFile <> ''  THEN DO:
    RUN ue-gen-etq.
  END.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnFile wWin
ON CHOOSE OF btnFile IN FRAME fMain /* ... */
DO:
    DEFINE VAR X-archivo AS CHAR.
    DEFINE VAR rpta AS LOG.

        SYSTEM-DIALOG GET-FILE x-Archivo
            FILTERS 'Excel (*.xls?)' '*.xls,*.xlsx'
            DEFAULT-EXTENSION '.xls'
            RETURN-TO-START-DIR
            TITLE 'Importar Excel'
            UPDATE rpta.
        IF rpta = NO OR x-Archivo = '' THEN RETURN.

    txtFile:SCREEN-VALUE = x-archivo.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 wWin
ON CHOOSE OF BUTTON-2 IN FRAME fMain /* Limpiar file */
DO:
  txtFile:SCREEN-VALUE = "".
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
  DISPLAY txtCuantas txtFile 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE txtCuantas btnFile BUTTON-2 btn 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-gen-etq wWin 
PROCEDURE ue-gen-etq :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lCorre AS INT.
DEF VAR v-datetime-tz as DATETIME-TZ. 
DEF VAR lbarra AS CHAR.
DEFINE VAR rpta AS LOG.
DEFINE VAR lFileXls AS CHAR.

DEFINE VAR lEtq AS INT.

EMPTY TEMP-TABLE tt-filer.

IF txtCuantas <> '' THEN DO:
    CREATE tt-filer.
        ASSIGN tt-filer.t-codigo = txtCuantas.
END.
ELSE DO:
    IF txtFile <> '' THEN DO:
        RUN ue-lee-desde-excel.
    END.
END.
/**/

SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
IF rpta = NO THEN RETURN.

OUTPUT STREAM REPORTE TO PRINTER.

lEtq = 1.
FOR EACH tt-filer.
    IF lEtq = 1 THEN PUT STREAM REPORTE '^XA^LH000,012'               SKIP.   /* Inicia formato */
    IF lEtq = 2 THEN PUT STREAM REPORTE '^LH210,012'                  SKIP.
    IF lEtq = 3 THEN PUT STREAM REPORTE '^LH420,012'                  SKIP.
    IF lEtq = 4 THEN PUT STREAM REPORTE '^LH630,012'                  SKIP.

    /*MESSAGE lEtq.*/

    RUN ue-imp-etq(tt-filer.t-codigo).

    IF lEtq = 4 THEN DO:
        lEtq = 0.
        PUT STREAM REPORTE '^PQ' + TRIM(STRING(1)) SKIP.  /* Cantidad a imprimir */
        PUT STREAM REPORTE '^PR' + '4'                   SKIP.   /* Velocidad de impresion Pulg/seg */
        PUT STREAM REPORTE '^XZ'                         SKIP.   /* Fin de formato */
    END.
    lEtq = lEtq + 1.
END.

IF lEtq > 1 THEN DO:
    PUT STREAM REPORTE '^PQ' + TRIM(STRING(1)) SKIP.  /* Cantidad a imprimir */
    PUT STREAM REPORTE '^PR' + '4'                   SKIP.   /* Velocidad de impresion Pulg/seg */
    PUT STREAM REPORTE '^XZ'                         SKIP.   /* Fin de formato */
END.

OUTPUT STREAM REPORTE CLOSE.

END PROCEDURE.

/*
    PUT STREAM REPORTE '^XA^LH000,012'               SKIP.   /* Inicia formato */
    {alm/ean13.i}
  
    PUT STREAM REPORTE '^LH210,012'                  SKIP.   /* Inicia formato */
    {alm/ean13.i}
  
    PUT STREAM REPORTE '^LH420,012'                  SKIP.   /* Inicia formato */
    {alm/ean13.i}
    
    PUT STREAM REPORTE '^LH630,012'                  SKIP.   /* Inicia formato */
    {alm/ean13.i}
    
    PUT STREAM REPORTE '^PQ' + TRIM(STRING(x-Copias)) SKIP.  /* Cantidad a imprimir */
    PUT STREAM REPORTE '^PR' + '4'                   SKIP.   /* Velocidad de impresion Pulg/seg */
    PUT STREAM REPORTE '^XZ'                         SKIP.   /* Fin de formato */

*/

/*
DEFINE VAR lCodigo AS CHAR.
DEFINE VAR lHora AS CHAR.              
DEFINE VAR ltodo AS CHAR.
DEFINE VAR rpta AS LOG.

lCodigo = STRING(TODAY,"99-99-9999").
/*lHora = STRING(NOW,"HH:MM:SS").*/

lTodo = lCodigo + lHora.

DEF VAR v-datetime as DATETIME.
DEF VAR v-datetime-tz as DATETIME-TZ. 

v-datetime = NOW.
v-datetime-tz = NOW.

ltodo = STRING(v-datetime-tz,"99-99-9999 HH:MM:SS").

ltodo = REPLACE(lTodo,"-","").
ltodo = REPLACE(lTodo,":","").

ltodo = "CO" + ltodo.

DISPLAY ltodo FORMAT "x(20)" .

SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
IF rpta = NO THEN RETURN.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-imp-etq wWin 
PROCEDURE ue-imp-etq :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p-CodBarra AS CHAR    NO-UNDO.

DEFINE VAR x-Copias AS INT. 
DEFINE VAR lNada AS CHAR.

lnada = p-CodBarra.


x-Copias = 1.
/*
PUT STREAM REPORTE '^XA^LH000,012'                 SKIP.   /* Inicio de formato */
PUT STREAM REPORTE '^FO150,15'                     SKIP.   /* Coordenadas de origen campo1 */
PUT STREAM REPORTE '^ADN,30,15'                    SKIP.
PUT STREAM REPORTE '^FD'.
PUT STREAM REPORTE lnada  FORMAT 'x(20)'            SKIP.
PUT STREAM REPORTE '^FS'                           SKIP.   /* Fin de Campo1 */
PUT STREAM REPORTE '^FO60,50'                      SKIP.   /* Coordenadas de origen barras */

PUT STREAM REPORTE '^BCN,100,N,N,N'            SKIP.   /* Codigo 128 */
PUT STREAM REPORTE '^FD'.
PUT STREAM REPORTE p-CodBarra FORMAT 'x(20)'   SKIP.

PUT STREAM REPORTE '^FS'                       SKIP.   /* Fin de Campo2 */
PUT STREAM REPORTE '^PQ' + TRIM(STRING(x-Copias)) SKIP.  /* Cantidad a imprimir */
PUT STREAM REPORTE '^PR' + '6'                   SKIP.   /* Velocidad de impresion Pulg/seg */
PUT STREAM REPORTE '^XZ'                         SKIP.   /* Fin de formato */

*/

/*
  PUT STREAM REPORTE '^FO155,00'                   SKIP.   /* Coordenadas de origen */
  PUT STREAM REPORTE '^A0R,25,15'                  SKIP.   /* Coordenada de impresion */
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE SUBSTRING(Desmat,1,40) FORMAT 'x(40)' SKIP.   /* Descripcion */
  PUT STREAM REPORTE '^FS'                         SKIP.   /* Fin de Campo1 */
  PUT STREAM REPORTE '^FO125,00'                   SKIP.   /* Coordenadas de origen campo2 */
  PUT STREAM REPORTE '^A0R,25,15'                  SKIP.
  PUT STREAM REPORTE '^FD'.
  PUT STREAM REPORTE SUBSTRING(Desmar,1,26) FORMAT 'x(26)' SKIP.
  PUT STREAM REPORTE '^FS'                         SKIP.   /* Fin de Campo2 */
  PUT STREAM REPORTE '^FO50,30'                    SKIP.   /* Coordenadas de origen barras */
  IF x-Tipo = 1 THEN DO:
    PUT STREAM REPORTE '^BCR,70'                     SKIP.   /* Codigo 128 */
    PUT STREAM REPORTE '^FD'.
    PUT STREAM REPORTE Almmmatg.CodMat FORMAT 'x(6)' SKIP.
  END.
  ELSE DO:
    PUT STREAM REPORTE '^BER,70'                SKIP.   /* Codigo 128 */
    PUT STREAM REPORTE '^FD'.
    PUT STREAM REPORTE Almmmatg.CodBrr FORMAT 'x(13)' SKIP.
  END.
  PUT STREAM REPORTE '^FS'                         SKIP.   /* Fin de Campo2 */

*/

PUT STREAM REPORTE '^FO50,30'                    SKIP.   /* Coordenadas de origen barras */
PUT STREAM REPORTE '^BCR,70'                     SKIP.   /* Codigo 128 */
PUT STREAM REPORTE '^FD'.
PUT STREAM REPORTE p-CodBarra FORMAT 'x(6)' SKIP.
PUT STREAM REPORTE '^FS'                         SKIP.   /* Fin de Campo2 */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-lee-desde-excel wWin 
PROCEDURE ue-lee-desde-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE lFileXls                 AS CHARACTER.
        DEFINE VARIABLE lNuevoFile               AS LOG.

    DEFINE VAR xCodMat AS CHAR.
    DEFINE VAR lLinea AS INT.
    DEFINE VAR dValor AS DEC.
    DEFINE VAR lTpoCmb AS DEC.

        lFileXls = txtFile.             /* Nombre el archivo a abrir o crear, vacio solo para nuevos */
        lNuevoFile = NO.                            /* Si va crear un nuevo archivo o abrir */

        {lib\excel-open-file.i}
        lMensajeAlTerminar = NO. /*  */
        lCerrarAlTerminar = YES.        /* Si permanece abierto el Excel luego de concluir el proceso */


    /* Adiciono  */
   /* chWorkbook = chExcelApplication:Workbooks:Add().*/

        iColumn = 1.
    lLinea = 1.

    cColumn = STRING(lLinea).
    REPEAT iColumn = 2 TO 65000 :
        cColumn = STRING(iColumn).

        cRange = "A" + cColumn.
        xCodmat = chWorkSheet:Range(cRange):VALUE.

        IF xCodmat = "" OR xCodMat = ? THEN LEAVE.    /* FIN DE DATOS */

        CREATE tt-filer.
            ASSIGN tt-filer.t-codigo = xCodmat.
    END.


        {lib\excel-close-file.i}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

