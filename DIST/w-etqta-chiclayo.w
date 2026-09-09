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
&Scoped-Define ENABLED-OBJECTS txtCuantas btn 
&Scoped-Define DISPLAYED-OBJECTS txtCuantas 

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

DEFINE VARIABLE txtCuantas AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Cuantas Etiquetas" 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     txtCuantas AT ROW 2.54 COL 21 COLON-ALIGNED WIDGET-ID 2
     btn AT ROW 5.04 COL 26 WIDGET-ID 4
     "Tope 999 Etiquetas" VIEW-AS TEXT
          SIZE 16 BY .62 AT ROW 2.81 COL 29.86 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 57.29 BY 7.27 WIDGET-ID 100.


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
         TITLE              = "Generacion de Etiquetas - Chiclayo"
         HEIGHT             = 7.27
         WIDTH              = 57.29
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* Generacion de Etiquetas - Chiclayo */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Generacion de Etiquetas - Chiclayo */
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
  ASSIGN txtCuantas.
  IF txtCuantas > 0  THEN DO:
    RUN ue-gen-etq.
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
  DISPLAY txtCuantas 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE txtCuantas btn 
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

DEFINE VAR x-Copias AS INT.
DEFINE VAR lmeses AS CHAR.

SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
IF rpta = NO THEN RETURN.
OUTPUT STREAM REPORTE TO PRINTER.

lMeses = "1,2,3,4,5,6,7,8,9,A,B,C".

x-Copias = 1.

REPEAT lCorre = 1 TO txtCuantas:
    v-datetime-tz = NOW.
    lbarra = STRING(v-datetime-tz,"99-99-9999 HH:MM:SS").      
    lbarra = REPLACE(lbarra,"-","").
    lbarra = REPLACE(lbarra,":","").
    lbarra = REPLACE(lbarra," ","").
    lbarra = lbarra + STRING(lCorre,"999").    


    lbarra = SUBSTRING(lbarra,1,4) +  SUBSTRING(lbarra,8).

    PUT STREAM REPORTE '^XA^LH000,012'               SKIP.   /* Inicia formato */
    /*{alm/ean13-2.i}*/
    RUN ue-imp-etq(lbarra,"CLIENTE").
    
    /*PUT STREAM REPORTE '^LH210,012'                  SKIP.   /* Inicia formato */*/
    PUT STREAM REPORTE '^LH380,012'                  SKIP.   /* Inicia formato */
    /*{alm/ean13-2.i}*/
    RUN ue-imp-etq(lbarra,"CANASTA").
    
    /*    
    PUT STREAM REPORTE '^LH420,012'                  SKIP.   /* Inicia formato */
    {alm/ean13-2.i}
    
    PUT STREAM REPORTE '^LH630,012'                  SKIP.   /* Inicia formato */
    {alm/ean13-2.i}
    */
    PUT STREAM REPORTE '^PQ' + TRIM(STRING(x-Copias)) SKIP.  /* Cantidad a imprimir */
    PUT STREAM REPORTE '^PR' + '4'                   SKIP.   /* Velocidad de impresion Pulg/seg */
    PUT STREAM REPORTE '^XZ'                         SKIP.   /* Fin de formato */


    
END.
OUTPUT STREAM REPORTE CLOSE.

END PROCEDURE.

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
DEFINE INPUT PARAMETER p-desc AS CHAR NO-UNDO.

DEFINE VAR x-Copias AS INT. 
DEFINE VAR ldesc AS CHAR.

ldesc = p-desc.

x-Copias = 1.

/*PUT STREAM REPORTE '^FO170,00'                     SKIP.   /* Coordenadas de origen campo1 */*/
PUT STREAM REPORTE '^FO060,00'                     SKIP.   /* Coordenadas de origen campo1 */
PUT STREAM REPORTE '^A0N,25,15'                    SKIP.
PUT STREAM REPORTE '^FD'.
PUT STREAM REPORTE lDesc                        SKIP.
PUT STREAM REPORTE '^FS'                           SKIP.   /* Fin de Campo1 */
/*PUT STREAM REPORTE '^FO80,30'                      SKIP.   /* Coordenadas de origen barras */*/
PUT STREAM REPORTE '^FO60,30'                      SKIP.   /* Coordenadas de origen barras */

/*PUT STREAM REPORTE '^BY2^BCR,80,Y,N,N'         SKIP.   /* Codigo 128 */*/
PUT STREAM REPORTE '^BY3^BCN,100,Y,N,N'        SKIP.   /* Codigo 128 */
PUT STREAM REPORTE '^FD>;'.
PUT STREAM REPORTE p-codbarra FORMAT 'x(14)' SKIP.
/*
IF x-Tipo = 1 THEN DO:
    PUT STREAM REPORTE '^FD'.
    PUT STREAM REPORTE Almmmatg.CodMat FORMAT 'x(6)' SKIP.
END.
ELSE DO:
    PUT STREAM REPORTE '^FD>;'.
    PUT STREAM REPORTE Barras[x-Barras - 1] FORMAT 'x(14)' SKIP.
END.
*/
PUT STREAM REPORTE '^FS'                       SKIP.   /* Fin de Campo2 */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

