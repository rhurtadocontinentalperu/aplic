&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
*/
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

DEFINE TEMP-TABLE tt-tempo
    FIELDS tt-nrobanco AS CHAR FORMAT "x(10)"
    FIELDS tt-nrocedente AS CHAR FORMAT "x(20)"
    FIELDS tt-aceptante AS CHAR FORMAT "x(50)"
    FIELDS tt-fchingreso AS DATE 
    FIELDS tt-fchvcto AS DATE
    FIELDS tt-nominal AS DEC
    FIELDS tt-msg AS CHAR FORMAT "x(15)"
    FIELDS tt-nroletra AS CHAR FORMAT "x(11)"
    FIELDS tt-femision AS DATE FORMAT "99/99/9999"
    FIELDS tt-fvcto AS DATE FORMAT "99/99/9999"
    FIELDS tt-nomcli AS CHAR FORMAT "x(50)"
    FIELDS tt-importe AS DEC.

DEFINE VAR x-Archivo AS CHAR.
DEFINE SHARED VAR s-codcia AS INT.

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
&Scoped-define BROWSE-NAME BROWSE-3

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-tempo

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 tt-tempo.tt-nroletra tt-tempo.tt-femision tt-tempo.tt-fvcto tt-tempo.tt-nomcli tt-tempo.tt-importe tt-tempo.tt-msg tt-tempo.tt-nrobanco tt-tempo.tt-nrocedente tt-tempo.tt-aceptante tt-tempo.tt-fchingreso tt-tempo.tt-fchvcto tt-tempo.tt-nominal   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3   
&Scoped-define SELF-NAME BROWSE-3
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH tt-tempo
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY {&SELF-NAME} FOR EACH tt-tempo.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 tt-tempo
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 tt-tempo


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-BROWSE-3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BtnBuscar btnProcesar BROWSE-3 
&Scoped-Define DISPLAYED-OBJECTS txtFileXls 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnBuscar 
     LABEL "..." 
     SIZE 6.86 BY 1.12.

DEFINE BUTTON btnProcesar 
     LABEL "Procesar" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE txtFileXls AS CHARACTER FORMAT "X(256)":U 
     LABEL "File Excel" 
     VIEW-AS FILL-IN 
     SIZE 81.72 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      tt-tempo SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 wWin _FREEFORM
  QUERY BROWSE-3 DISPLAY
      tt-tempo.tt-nroletra COLUMN-LABEL "Nro Letra"
tt-tempo.tt-femision COLUMN-LABEL "Emision Letra"
tt-tempo.tt-fvcto COLUMN-LABEL "Vcto Letra"
tt-tempo.tt-nomcli COLUMN-LABEL "Cliente" WIDTH 25.00
tt-tempo.tt-importe COLUMN-LABEL "Impte Letra"
tt-tempo.tt-msg COLUMN-LABEL "Observa"
tt-tempo.tt-nrobanco COLUMN-LABEL "Nro Banco" FORMAT "x(10)"
tt-tempo.tt-nrocedente FORMAT "x(20)" COLUMN-LABEL "Nro Cedente"
tt-tempo.tt-aceptante FORMAT "x(50)" COLUMN-LABEL "Aceptante" WIDTH 25.00
tt-tempo.tt-fchingreso COLUMN-LABEL "Fec.Ingreso" FORMAT "99/99/9999"
tt-tempo.tt-fchvcto COLUMN-LABEL "Fec.Vcto" FORMAT "99/99/9999"
tt-tempo.tt-nominal FORMAT ">>,>>>,>>9.99" COLUMN-LABEL "Nominal" WIDTH 12.57
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 135 BY 20.58 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     txtFileXls AT ROW 1.58 COL 9.29 COLON-ALIGNED WIDGET-ID 2
     BtnBuscar AT ROW 1.58 COL 92.14 WIDGET-ID 4
     btnProcesar AT ROW 2.92 COL 73 WIDGET-ID 8
     BROWSE-3 AT ROW 4.65 COL 2 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 136.57 BY 25.42 WIDGET-ID 100.


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
         TITLE              = "Creditos y Cobranzas"
         HEIGHT             = 25.42
         WIDTH              = 136.57
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "SmartWindowCues" wWin _INLINE
/* Actions: adecomm/_so-cue.w ? adecomm/_so-cued.p ? adecomm/_so-cuew.p */
/* SmartWindow,ab,49271
Destroy on next read */
/* _UIB-CODE-BLOCK-END */
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
/* BROWSE-TAB BROWSE-3 btnProcesar fMain */
ASSIGN 
       BROWSE-3:COLUMN-RESIZABLE IN FRAME fMain       = TRUE.

/* SETTINGS FOR FILL-IN txtFileXls IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _START_FREEFORM

OPEN QUERY {&SELF-NAME} FOR EACH tt-tempo.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* Creditos y Cobranzas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Creditos y Cobranzas */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnBuscar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnBuscar wWin
ON CHOOSE OF BtnBuscar IN FRAME fMain /* ... */
DO:

    DEFINE VAR OKpressed AS LOG.

	  SYSTEM-DIALOG GET-FILE x-Archivo
	    FILTERS "Archivos Excel (*.xlsx)" "*.xls,*.xlsx"
	    MUST-EXIST
	    TITLE "Seleccione archivo..."
	    UPDATE OKpressed.   
	  IF OKpressed = NO THEN RETURN.

      txtFileXls:SCREEN-VALUE = X-archivo.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnProcesar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnProcesar wWin
ON CHOOSE OF btnProcesar IN FRAME fMain /* Procesar */
DO:
   ASSIGN txtFileXls.

   IF txtFileXls = ? OR txtFileXls = "" THEN DO:
       MESSAGE "Ingrese la ruta del Archivo XLS".
       RETURN NO-APPLY.
   END.

   X-archivo = txtFileXls.

    RUN ue-procesar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
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
  DISPLAY txtFileXls 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE BtnBuscar btnProcesar BROWSE-3 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-procesar wWin 
PROCEDURE ue-procesar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE tt-tempo.

DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.

lFileXls = X-archivo.		/* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */
lNuevoFile = NO.	/* YES : Si va crear un nuevo archivo o abrir */

{lib\excel-open-file.i}

chExcelApplication:Visible = FALSE.

DEFINE VAR cValue AS CHAR.
DEFINE VAR cMone AS INT.

IF CAPS(TRIM(chWorkSheet:Range("C6"):Value)) = "SOLES" THEN DO:
    cMone = 1.
END.
ELSE cMone = 2.

SESSION:SET-WAIT-STATE('GENERAL').

REPEAT iColumn = 9 TO 65000 :
    cColumn = STRING(iColumn).

     cRange = "A" + cColumn.
     cValue = chWorkSheet:Range(cRange):Value.

    IF cValue = "" OR cValue = ? THEN LEAVE.

    CREATE tt-tempo.
        ASSIGN tt-tempo.tt-nrobanco    = chWorkSheet:Range(cRange):VALUE
        cRange = "B" + cColumn.
        ASSIGN tt-tempo.tt-nrocedente  = chWorkSheet:Range(cRange):VALUE
        cRange = "C" + cColumn.
        ASSIGN tt-tempo.tt-aceptante   = chWorkSheet:Range(cRange):Value
        cRange = "D" + cColumn.
        ASSIGN tt-tempo.tt-fchingreso  = chWorkSheet:Range(cRange):Value
        cRange = "E" + cColumn.
        ASSIGN tt-tempo.tt-fchvcto     = chWorkSheet:Range(cRange):Value
        cRange = "F" + cColumn.
        ASSIGN tt-tempo.tt-nominal     = chWorkSheet:Range(cRange):Value.

    /* Buscar en el CCBCDOCU  */
        ASSIGN tt-tempo.tt-msg = "NO UBICADO".
        FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND 
            ccbcdocu.coddoc = 'LET' AND ccbcdocu.nrosal = tt-tempo.tt-nrobanco
            NO-LOCK NO-ERROR.
        IF AVAILABLE ccbcdocu THEN DO:
            ASSIGN tt-tempo.tt-msg = "REGISTRADO".
        END.
        ELSE DO:
            FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
                ccbcdocu.coddoc = 'LET' AND ccbcdocu.codmon = cmone AND
                ccbcdocu.fchvto = tt-tempo.tt-fchvcto AND 
                ccbcdocu.imptot = tt-tempo.tt-nominal NO-LOCK NO-ERROR.
            ASSIGN tt-tempo.tt-msg = "PROBABLE".
        END.
        IF AVAILABLE ccbcdocu THEN DO:
            ASSIGN tt-tempo.tt-nroletra = ccbcdocu.nrodoc
                    tt-tempo.tt-femision = ccbcdocu.fchdoc
                    tt-tempo.tt-fvcto    = ccbcdocu.fchvto
                    tt-tempo.tt-nomcli   = ccbcdocu.nomcli
                    tt-tempo.tt-importe   = ccbcdocu.imptot.
        END.
        /*
        FIELDS tt-msg AS CHAR FORMAT "x(30)"
        FIELDS tt-nroletra AS CHAR FORMAT "x(11)"
        FIELDS tt-femision AS DATE
        FIELDS tt-fvcto AS DATE
        FIELDS tt-nomcli AS CHAR FORMAT "x(50)"
        FIELDS tt-importe AS DEC.
        */
END.

{&OPEN-QUERY-BROWSE-3}
chExcelApplication:Visible = FALSE.

{lib\excel-close-file.i}

SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

