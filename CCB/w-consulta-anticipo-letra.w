&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-CcbCDocu NO-UNDO LIKE INTEGRAL.CcbCDocu.
DEFINE TEMP-TABLE tt-CcbDCaja NO-UNDO LIKE INTEGRAL.CcbDCaja.
DEFINE TEMP-TABLE tt-ccbdmov NO-UNDO LIKE INTEGRAL.CCBDMOV.



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

DEFINE SHARED VAR s-codcia AS INT.

{src/adm2/widgetprto.i}

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
&Scoped-define BROWSE-NAME BROWSE-5

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-CcbCDocu tt-ccbdmov tt-CcbDCaja

/* Definitions for BROWSE BROWSE-5                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-5 tt-CcbCDocu.CodDoc ~
tt-CcbCDocu.NroDoc tt-CcbCDocu.FchDoc tt-CcbCDocu.FchVto ~
if(tt-ccbcdocu.CodMon = 1) then 'S/.' else '$. ' tt-CcbCDocu.TpoCmb ~
tt-CcbCDocu.ImpTot ~
if(tt-ccbcdocu.codmon = 1) then tt-ccbcdocu.impTot else tt-ccbcdocu.impTot * tt-ccbcdocu.TpoCmb 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5 
&Scoped-define QUERY-STRING-BROWSE-5 FOR EACH tt-CcbCDocu NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY BROWSE-5 FOR EACH tt-CcbCDocu NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 tt-CcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 tt-CcbCDocu


/* Definitions for BROWSE BROWSE-7                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-7 tt-ccbdmov.CodDiv tt-ccbdmov.CodRef ~
tt-ccbdmov.NroRef if(tt-ccbdmov.codmon = 1) then 'S/.' else '$. ' ~
tt-ccbdmov.TpoCmb tt-ccbdmov.ImpTot ~
if(tt-ccbdmov.codmon = 1) then tt-ccbdmov.Imptot else tt-ccbdmov.imptot * tt-ccbdmov.tpocmb 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-7 
&Scoped-define QUERY-STRING-BROWSE-7 FOR EACH tt-ccbdmov NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-7 OPEN QUERY BROWSE-7 FOR EACH tt-ccbdmov NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-7 tt-ccbdmov
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-7 tt-ccbdmov


/* Definitions for BROWSE BROWSE-8                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-8 tt-CcbDCaja.CodDiv ~
tt-CcbDCaja.CodDoc tt-CcbDCaja.NroDoc tt-CcbDCaja.CodRef tt-CcbDCaja.NroRef ~
if(tt-ccbdcaja.codmon = 1) then 'S/.' else '$. ' tt-CcbDCaja.TpoCmb ~
tt-CcbDCaja.ImpTot ~
if(tt-ccbdcaja.codmon = 1) then tt-ccbdcaja.imptot else tt-ccbdcaja.imptot * tt-ccbdcaja.tpocmb 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-8 
&Scoped-define QUERY-STRING-BROWSE-8 FOR EACH tt-CcbDCaja NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-8 OPEN QUERY BROWSE-8 FOR EACH tt-CcbDCaja NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-8 tt-CcbDCaja
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-8 tt-CcbDCaja


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-BROWSE-5}~
    ~{&OPEN-QUERY-BROWSE-7}~
    ~{&OPEN-QUERY-BROWSE-8}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS txtCliente txtLetra btnBuscar BROWSE-5 ~
BROWSE-8 BROWSE-7 
&Scoped-Define DISPLAYED-OBJECTS txtCliente txtLetra txtDscCliente 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnBuscar 
     LABEL "Buscar" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE txtCliente AS CHARACTER FORMAT "X(12)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE txtDscCliente AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 69 BY 1
     FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE txtLetra AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nro de Letra" 
     VIEW-AS FILL-IN 
     SIZE 18 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-5 FOR 
      tt-CcbCDocu SCROLLING.

DEFINE QUERY BROWSE-7 FOR 
      tt-ccbdmov SCROLLING.

DEFINE QUERY BROWSE-8 FOR 
      tt-CcbDCaja SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 wWin _STRUCTURED
  QUERY BROWSE-5 NO-LOCK DISPLAY
      tt-CcbCDocu.CodDoc FORMAT "x(3)":U WIDTH 6.43
      tt-CcbCDocu.NroDoc FORMAT "X(9)":U WIDTH 11.43
      tt-CcbCDocu.FchDoc COLUMN-LABEL "Emision" FORMAT "99/99/9999":U
            WIDTH 11.43
      tt-CcbCDocu.FchVto COLUMN-LABEL "Vencimiento" FORMAT "99/99/9999":U
      if(tt-ccbcdocu.CodMon = 1) then 'S/.' else '$. ' COLUMN-LABEL "Mone"
            WIDTH 6.29
      tt-CcbCDocu.TpoCmb FORMAT "Z,ZZ9.9999":U
      tt-CcbCDocu.ImpTot COLUMN-LABEL "Importe" FORMAT "->>,>>>,>>9.99":U
            WIDTH 11.57
      if(tt-ccbcdocu.codmon = 1) then tt-ccbcdocu.impTot else tt-ccbcdocu.impTot * tt-ccbcdocu.TpoCmb COLUMN-LABEL "Soles (S/.)"
            WIDTH 11.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 86 BY 3.27 ROW-HEIGHT-CHARS .5 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-7 wWin _STRUCTURED
  QUERY BROWSE-7 NO-LOCK DISPLAY
      tt-ccbdmov.CodDiv FORMAT "x(5)":U
      tt-ccbdmov.CodRef FORMAT "X(10)":U
      tt-ccbdmov.NroRef FORMAT "X(10)":U
      if(tt-ccbdmov.codmon = 1) then 'S/.' else '$. ' COLUMN-LABEL "Mone"
      tt-ccbdmov.TpoCmb FORMAT "Z,ZZ9.9999":U
      tt-ccbdmov.ImpTot FORMAT "->>,>>>,>>9.99":U
      if(tt-ccbdmov.codmon = 1) then tt-ccbdmov.Imptot else tt-ccbdmov.imptot * tt-ccbdmov.tpocmb COLUMN-LABEL "Soles (S/.)"
            WIDTH 18.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 81 BY 4.5 ROW-HEIGHT-CHARS .73 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-8 wWin _STRUCTURED
  QUERY BROWSE-8 NO-LOCK DISPLAY
      tt-CcbDCaja.CodDiv FORMAT "x(5)":U
      tt-CcbDCaja.CodDoc FORMAT "x(3)":U
      tt-CcbDCaja.NroDoc COLUMN-LABEL "Nro Ingreso" FORMAT "X(9)":U
      tt-CcbDCaja.CodRef COLUMN-LABEL "CodDoc" FORMAT "x(3)":U
      tt-CcbDCaja.NroRef FORMAT "X(9)":U
      if(tt-ccbdcaja.codmon = 1) then 'S/.' else '$. ' COLUMN-LABEL "Mone"
      tt-CcbDCaja.TpoCmb FORMAT "Z,ZZ9.9999":U
      tt-CcbDCaja.ImpTot FORMAT "->>,>>>,>>9.99":U
      if(tt-ccbdcaja.codmon = 1) then tt-ccbdcaja.imptot else tt-ccbdcaja.imptot * tt-ccbdcaja.tpocmb COLUMN-LABEL "Soles (S/.)"
            WIDTH 11.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 86 BY 5.08 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     txtCliente AT ROW 1.77 COL 13 COLON-ALIGNED WIDGET-ID 2
     txtLetra AT ROW 2.92 COL 13 COLON-ALIGNED WIDGET-ID 4
     btnBuscar AT ROW 2.15 COL 53 WIDGET-ID 6
     txtDscCliente AT ROW 4.27 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     BROWSE-5 AT ROW 5.62 COL 3 WIDGET-ID 200
     BROWSE-8 AT ROW 15.73 COL 3 WIDGET-ID 400
     BROWSE-7 AT ROW 10.04 COL 3 WIDGET-ID 300
     "Anticipos" VIEW-AS TEXT
          SIZE 12 BY 1 AT ROW 4.58 COL 3 WIDGET-ID 8
     "Ingresos a Caja" VIEW-AS TEXT
          SIZE 14.57 BY .62 AT ROW 9.35 COL 3.43 WIDGET-ID 10
     "Documentos canjeados" VIEW-AS TEXT
          SIZE 22 BY .62 AT ROW 15.04 COL 3.57 WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 94.72 BY 20.31 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE APPSERVER
   Temp-Tables and Buffers:
      TABLE: tt-CcbCDocu T "?" NO-UNDO INTEGRAL CcbCDocu
      TABLE: tt-CcbDCaja T "?" NO-UNDO INTEGRAL CcbDCaja
      TABLE: tt-ccbdmov T "?" NO-UNDO INTEGRAL CCBDMOV
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "Consulta de Letras Adelantas y sus canjes"
         HEIGHT             = 20.31
         WIDTH              = 94.72
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
/* BROWSE-TAB BROWSE-5 txtDscCliente fMain */
/* BROWSE-TAB BROWSE-8 BROWSE-5 fMain */
/* BROWSE-TAB BROWSE-7 BROWSE-8 fMain */
/* SETTINGS FOR FILL-IN txtDscCliente IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-5
/* Query rebuild information for BROWSE BROWSE-5
     _TblList          = "Temp-Tables.tt-CcbCDocu"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-CcbCDocu.CodDoc
"tt-CcbCDocu.CodDoc" ? ? "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-CcbCDocu.NroDoc
"tt-CcbCDocu.NroDoc" ? ? "character" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-CcbCDocu.FchDoc
"tt-CcbCDocu.FchDoc" "Emision" ? "date" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-CcbCDocu.FchVto
"tt-CcbCDocu.FchVto" "Vencimiento" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"if(tt-ccbcdocu.CodMon = 1) then 'S/.' else '$. '" "Mone" ? ? ? ? ? ? ? ? no ? no no "6.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   = Temp-Tables.tt-CcbCDocu.TpoCmb
     _FldNameList[7]   > Temp-Tables.tt-CcbCDocu.ImpTot
"tt-CcbCDocu.ImpTot" "Importe" ? "decimal" ? ? ? ? ? ? no ? no no "11.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"if(tt-ccbcdocu.codmon = 1) then tt-ccbcdocu.impTot else tt-ccbcdocu.impTot * tt-ccbcdocu.TpoCmb" "Soles (S/.)" ? ? ? ? ? ? ? ? no ? no no "11.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-5 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-7
/* Query rebuild information for BROWSE BROWSE-7
     _TblList          = "Temp-Tables.tt-ccbdmov"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   = Temp-Tables.tt-ccbdmov.CodDiv
     _FldNameList[2]   = Temp-Tables.tt-ccbdmov.CodRef
     _FldNameList[3]   = Temp-Tables.tt-ccbdmov.NroRef
     _FldNameList[4]   > "_<CALC>"
"if(tt-ccbdmov.codmon = 1) then 'S/.' else '$. '" "Mone" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = Temp-Tables.tt-ccbdmov.TpoCmb
     _FldNameList[6]   = Temp-Tables.tt-ccbdmov.ImpTot
     _FldNameList[7]   > "_<CALC>"
"if(tt-ccbdmov.codmon = 1) then tt-ccbdmov.Imptot else tt-ccbdmov.imptot * tt-ccbdmov.tpocmb" "Soles (S/.)" ? ? ? ? ? ? ? ? no ? no no "18.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-7 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-8
/* Query rebuild information for BROWSE BROWSE-8
     _TblList          = "Temp-Tables.tt-CcbDCaja"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   = Temp-Tables.tt-CcbDCaja.CodDiv
     _FldNameList[2]   = Temp-Tables.tt-CcbDCaja.CodDoc
     _FldNameList[3]   > Temp-Tables.tt-CcbDCaja.NroDoc
"tt-CcbDCaja.NroDoc" "Nro Ingreso" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-CcbDCaja.CodRef
"tt-CcbDCaja.CodRef" "CodDoc" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = Temp-Tables.tt-CcbDCaja.NroRef
     _FldNameList[6]   > "_<CALC>"
"if(tt-ccbdcaja.codmon = 1) then 'S/.' else '$. '" "Mone" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = Temp-Tables.tt-CcbDCaja.TpoCmb
     _FldNameList[8]   = Temp-Tables.tt-CcbDCaja.ImpTot
     _FldNameList[9]   > "_<CALC>"
"if(tt-ccbdcaja.codmon = 1) then tt-ccbdcaja.imptot else tt-ccbdcaja.imptot * tt-ccbdcaja.tpocmb" "Soles (S/.)" ? ? ? ? ? ? ? ? no ? no no "11.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-8 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* Consulta de Letras Adelantas y sus canjes */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Consulta de Letras Adelantas y sus canjes */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnBuscar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnBuscar wWin
ON CHOOSE OF btnBuscar IN FRAME fMain /* Buscar */
DO:
    DO WITH FRAME {&FRAME-NAME}.
       TxtDscCliente:SCREEN-VALUE = '' .
    END.
    
    EMPTY TEMP-TABLE tt-ccbdmov.
    EMPTY TEMP-TABLE tt-ccbdcaja.
    EMPTY TEMP-TABLE tt-ccbcdocu.

    {&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}

  ASSIGN txtCliente txtLetra.
  IF txtCliente = '' OR txtCliente = '' THEN DO:
    APPLY 'ENTRY':U TO txtCliente.
    RETURN NO-APPLY.
  END.
  IF txtLetra = '' OR txtLetra = '' THEN DO:
    APPLY 'ENTRY':U TO txtLetra.
    RETURN NO-APPLY.
  END.

  RUN um-procesar.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-5
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
  DISPLAY txtCliente txtLetra txtDscCliente 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE txtCliente txtLetra btnBuscar BROWSE-5 BROWSE-8 BROWSE-7 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE um-procesar wWin 
PROCEDURE um-procesar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lNroAnticipo AS CHAR.
DEFINE VAR lNroIngresoCaja AS CHAR.
DEFINE VAR lNroCanje AS CHAR.

FIND FIRST gn-clie WHERE codcia = 0 AND codcli = txtCliente NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-clie THEN DO:
    MESSAGE 'Cliente NO Existe'.
    RETURN NO-APPLY.
END.

    DO WITH FRAME {&FRAME-NAME}.
         TxtDscCliente:SCREEN-VALUE = gn-clie.nomcli .
    END.


/* Busco el anticipo segun la letra y cliente */
FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND ccbcdocu.coddoc = 'LET' AND
    ccbcdocu.nrodoc = txtLetra AND ccbcdocu.codcli = txtCliente AND 
    ccbcdocu.codref = 'CLA' NO-LOCK NO-ERROR.

IF NOT AVAILABLE ccbcdocu THEN DO:
    MESSAGE 'No existe Letra...'.
    RETURN NO-APPLY.
END.

/* Nro de Canje */
lNroCanje = ccbcdocu.nroref.

/* Busco el Nro de Anticipo */
FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND ccbcdocu.codref = 'CLA' AND 
    ccbcdocu.nroref = lNroCanje AND ccbcdocu.coddoc = 'A/R' AND 
    ccbcdocu.codcli = txtCliente NO-LOCK NO-ERROR.

CREATE tt-ccbcdocu.
    BUFFER-COPY ccbcdocu TO tt-ccbcdocu.

lNroAnticipo = ccbcdocu.nrodoc.

/* Busco el I/C con que guardado el Anticipo */
FOR EACH ccbdmov WHERE ccbdmov.codcia = s-codcia AND ccbdmov.coddoc = 'A/R' AND
        ccbdmov.nrodoc = lNroAnticipo NO-LOCK :
    CREATE tt-ccbdmov.
            BUFFER-COPY ccbdmov TO tt-ccbdmov.
END.

/* Busco los Documento involucrados en los Ingresos a Caja */
FOR EACH tt-ccbdmov NO-LOCK:
    lNroIngresoCaja = tt-ccbdmov.nroref.
    FOR EACH ccbdcaja WHERE ccbdcaja.codcia = s-codcia AND ccbdcaja.coddoc = 'I/C' AND 
        ccbdcaja.nrodoc = lNroIngresoCaja NO-LOCK:
        CREATE tt-ccbdcaja.
            BUFFER-COPY ccbdcaja TO tt-ccbdcaja.
    END.
END.
  
  {&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

