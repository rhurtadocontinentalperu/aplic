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
&Scoped-Define ENABLED-OBJECTS txtSector txtPasaje txtPasaje-2 txtPos ~
txtPos-2 txtPiso btn 
&Scoped-Define DISPLAYED-OBJECTS txtSector txtPasaje txtPasaje-2 txtPos ~
txtPos-2 txtPiso 

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

DEFINE VARIABLE txtPasaje AS INTEGER FORMAT ">9":U INITIAL 1 
     LABEL "Pasaje del" 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE txtPasaje-2 AS INTEGER FORMAT ">9":U INITIAL 1 
     LABEL "Al" 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE txtPiso AS INTEGER FORMAT "9":U INITIAL 1 
     LABEL "Piso/Nivel" 
     VIEW-AS FILL-IN 
     SIZE 5 BY 1 NO-UNDO.

DEFINE VARIABLE txtPos AS INTEGER FORMAT ">9":U INITIAL 1 
     LABEL "Posicion del" 
     VIEW-AS FILL-IN 
     SIZE 5 BY 1 NO-UNDO.

DEFINE VARIABLE txtPos-2 AS INTEGER FORMAT ">9":U INITIAL 1 
     LABEL "Posicion al" 
     VIEW-AS FILL-IN 
     SIZE 5 BY 1 NO-UNDO.

DEFINE VARIABLE txtSector AS INTEGER FORMAT ">9":U INITIAL 1 
     LABEL "Sector" 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     txtSector AT ROW 1.88 COL 19.29 COLON-ALIGNED WIDGET-ID 2
     txtPasaje AT ROW 3.15 COL 19.29 COLON-ALIGNED WIDGET-ID 8
     txtPasaje-2 AT ROW 3.15 COL 33.72 COLON-ALIGNED WIDGET-ID 16
     txtPos AT ROW 4.31 COL 19.29 COLON-ALIGNED WIDGET-ID 10
     txtPos-2 AT ROW 4.31 COL 33.86 COLON-ALIGNED WIDGET-ID 18
     txtPiso AT ROW 5.54 COL 19.29 COLON-ALIGNED WIDGET-ID 12
     btn AT ROW 7.46 COL 26.29 WIDGET-ID 4
     "1..6 (1:A, 2:A...B, 3:A...C, 4:A...D, 5:A...E, 6:A...F)" VIEW-AS TEXT
          SIZE 43.72 BY .62 AT ROW 5.73 COL 27.29 WIDGET-ID 14
          FGCOLOR 9 FONT 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 72 BY 9.04 WIDGET-ID 100.


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
         TITLE              = "Generacion de Codigo de Barras ZONAS DEL ALMACEN"
         HEIGHT             = 9.04
         WIDTH              = 72
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
ON END-ERROR OF wWin /* Generacion de Codigo de Barras ZONAS DEL ALMACEN */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Generacion de Codigo de Barras ZONAS DEL ALMACEN */
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
  ASSIGN txtSector txtPasaje txtPos txtPiso txtPos-2 txtPasaje-2.
  IF txtSector > 0 AND
      ( txtPasaje > 0 AND txtPasaje-2 > 0 AND txtPasaje-2 >= txtPasaje) AND 
       ( txtPos > 0 AND txtPos-2 > 0 AND txtPos-2 >= txtPos)  
      AND (txtPiso > 0 AND txtPiso < 7) THEN DO:
    RUN ue-gen-etq.
  END.
  ELSE DO:
      MESSAGE "Rangos ERRADOS".
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
  DISPLAY txtSector txtPasaje txtPasaje-2 txtPos txtPos-2 txtPiso 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE txtSector txtPasaje txtPasaje-2 txtPos txtPos-2 txtPiso btn 
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

DEFINE VAR lPasaje AS INT.
DEFINE VAR lPos AS INT.
DEFINE VAR lNivel AS INT.

SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
IF rpta = NO THEN RETURN.
OUTPUT STREAM REPORTE TO PRINTER.

REPEAT lCorre = txtSector TO txtSector:
    REPEAT lPasaje = txtPasaje TO txtPasaje-2:
        REPEAT lPos = txtPos TO txtPos-2:
            REPEAT lNivel = 1 TO txtPiso:

                lbarra = STRING(lCorre,"99") + STRING(lPasaje,"99") + STRING(lPos,"99").

                IF lNivel = 1 THEN lbarra = lBarra + "A".
                IF lNivel = 2 THEN lbarra = lBarra + "B".
                IF lNivel = 3 THEN lbarra = lBarra + "C".
                IF lNivel = 4 THEN lbarra = lBarra + "D".
                IF lNivel = 5 THEN lbarra = lBarra + "E".
                IF lNivel = 6 THEN lbarra = lBarra + "F".

                RUN ue-imp-etq(lbarra).

            END.
        END.
    END.
    /*
    v-datetime-tz = NOW.
    lbarra = STRING(v-datetime-tz,"99-99-9999 HH:MM:SS").      
    lbarra = REPLACE(lbarra,"-","").
    lbarra = REPLACE(lbarra,":","").
    lbarra = REPLACE(lbarra," ","").
    lbarra = "CO" + lbarra + STRING(lCorre,"999").    
    lbarra = SUBSTRING(lbarra,1,6) +  SUBSTRING(lbarra,10).

    lbarra = STRING(lCorre,"99") + "0108A".

    RUN ue-imp-etq(lbarra).
    */
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

DEFINE VAR x-Copias AS INT. 
DEFINE VAR lNada AS CHAR.

lnada = p-CodBarra.

x-Copias = 1.

PUT STREAM REPORTE '^XA^LH000,012'                 SKIP.   /* Inicio de formato */
/*
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
*/

PUT STREAM REPORTE '^FO180,30'                      SKIP.   /* Coordenadas de origen barras */
PUT STREAM REPORTE '^BCN,100,N,N,N'            SKIP.   /* Codigo 128 */
PUT STREAM REPORTE '^FD'.
PUT STREAM REPORTE p-CodBarra FORMAT 'x(20)'   SKIP.
PUT STREAM REPORTE '^FS'                       SKIP.   /* Fin de Campo2 */

PUT STREAM REPORTE '^FO350,140'                     SKIP.   /* Coordenadas de origen campo1 */
PUT STREAM REPORTE '^ADN,30,15'                    SKIP.
PUT STREAM REPORTE '^FD'.
PUT STREAM REPORTE lnada  FORMAT 'x(20)'            SKIP.
PUT STREAM REPORTE '^FS'                           SKIP.   /* Fin de Campo1 */

PUT STREAM REPORTE '^PQ' + TRIM(STRING(x-Copias)) SKIP.  /* Cantidad a imprimir */
PUT STREAM REPORTE '^PR' + '6'                   SKIP.   /* Velocidad de impresion Pulg/seg */
PUT STREAM REPORTE '^XZ'                         SKIP.   /* Fin de formato */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

