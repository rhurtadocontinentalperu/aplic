&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-nomcia AS CHAR.
DEF SHARED VAR pv-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-coddoc AS CHAR INIT 'O/D,O/M'.
DEF VAR s-flgest AS CHAR INIT 'P'.
DEF VAR s-flgsit AS CHAR INIT 'P'.

/* &SCOPED-DEFINE CONDICION faccpedi.codcia = s-codcia ~ */
/* AND LOOKUP(faccpedi.coddoc, s-coddoc) > 0 ~           */
/* AND faccpedi.divdes = s-coddiv ~                      */
/* AND faccpedi.flgest = s-flgest ~                      */
/* AND faccpedi.flgsit <> s-flgsit ~                     */
/* AND faccpedi.fchped >= FILL-IN-Fecha-1 ~              */
/* AND faccpedi.fchped <= FILL-IN-Fecha-2 ~              */
/* AND faccpedi.flgimpod = RADIO-SET-FlgImpOD            */

&SCOPED-DEFINE CONDICION faccpedi.codcia = s-codcia ~
AND LOOKUP(faccpedi.coddoc, s-coddoc) > 0 ~
AND faccpedi.divdes = s-coddiv ~
AND faccpedi.flgest = 'P' ~
AND faccpedi.flgsit <> 'C' ~
AND faccpedi.flgimpod = RADIO-SET-FlgImpOD

DEFINE TEMP-TABLE Reporte
    FIELD CodDoc    LIKE FacCPedi.CodDoc
    FIELDS NroPed   LIKE FacCPedi.NroPed
    FIELDS CodAlm   LIKE Facdpedi.almdes
    FIELDS CodMat   LIKE FacDPedi.CodMat
    FIELDS DesMat   LIKE Almmmatg.DesMat
    FIELDS DesMar   LIKE Almmmatg.DesMar
    FIELDS UndBas   LIKE Almmmatg.UndBas
    FIELDS CanPed   LIKE FacDPedi.CanPed
    FIELDS CodUbi   LIKE Almmmate.CodUbi
    FIELDS CodZona  LIKE Almtubic.CodZona
    FIELDS X-TRANS  LIKE FacCPedi.Libre_c01
    FIELDS X-DIREC  LIKE FACCPEDI.Libre_c02
    FIELDS X-LUGAR  LIKE FACCPEDI.Libre_c03
    FIELDS X-CONTC  LIKE FACCPEDI.Libre_c04
    FIELDS X-HORA   LIKE FACCPEDI.Libre_c05
    FIELDS X-FECHA  LIKE FACCPEDI.Libre_f01
    FIELDS X-OBSER  LIKE FACCPEDI.Observa
    FIELDS X-Glosa  LIKE FACCPEDI.Glosa
    FIELDS X-codcli LIKE FACCPEDI.CodCli
    FIELDS X-NomCli LIKE FACCPEDI.NomCli.

DEFINE BUFFER b-reporte FOR Reporte.


DEF STREAM REPORT.

{src/bin/_prns.i}

DEFINE VARIABLE conta          AS INTEGER NO-UNDO INIT 0.
DEFINE VARIABLE ped            AS CHARACTER.
DEFINE VARIABLE npage          AS INTEGER  NO-UNDO.
DEFINE VARIABLE c-items        AS INTEGER  NO-UNDO.

DEF NEW SHARED VAR s-task-no AS INT.

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
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES FacCPedi GN-DIVI

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 GN-DIVI.DesDiv FacCPedi.CodDoc ~
FacCPedi.NroPed FacCPedi.FchPed FacCPedi.Hora FacCPedi.NomCli ~
FacCPedi.UsrImpOD FacCPedi.FchImpOD 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH FacCPedi ~
      WHERE {&CONDICION} NO-LOCK, ~
      EACH GN-DIVI OF FacCPedi NO-LOCK ~
    BY FacCPedi.FchPed DESCENDING ~
       BY FacCPedi.Hora DESCENDING INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH FacCPedi ~
      WHERE {&CONDICION} NO-LOCK, ~
      EACH GN-DIVI OF FacCPedi NO-LOCK ~
    BY FacCPedi.FchPed DESCENDING ~
       BY FacCPedi.Hora DESCENDING INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 FacCPedi GN-DIVI
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 FacCPedi
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 GN-DIVI


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RADIO-SET-FlgImpOD BROWSE-2 BUTTON-12 ~
BUTTON-11 BtnDone 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-FlgImpOD 

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
     SIZE 9 BY 1.62 TOOLTIP "Salir"
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-11 
     IMAGE-UP FILE "img/print (2).ico":U
     LABEL "Button 11" 
     SIZE 9 BY 1.62 TOOLTIP "Imprimir".

DEFINE BUTTON BUTTON-12 
     LABEL "REFRESCAR" 
     SIZE 15 BY 1.62 TOOLTIP "Refrescar datos".

DEFINE VARIABLE RADIO-SET-FlgImpOD AS LOGICAL 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impresos", yes,
"No Impresos", no
     SIZE 30 BY 1.08 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      FacCPedi, 
      GN-DIVI SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 wWin _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      GN-DIVI.DesDiv COLUMN-LABEL "Origen" FORMAT "X(30)":U
      FacCPedi.CodDoc FORMAT "x(3)":U
      FacCPedi.NroPed COLUMN-LABEL "Numero" FORMAT "X(9)":U
      FacCPedi.FchPed COLUMN-LABEL "Emision" FORMAT "99/99/9999":U
      FacCPedi.Hora FORMAT "X(5)":U
      FacCPedi.NomCli COLUMN-LABEL "Cliente" FORMAT "x(50)":U WIDTH 52.86
      FacCPedi.UsrImpOD COLUMN-LABEL "Impreso por" FORMAT "x(8)":U
      FacCPedi.FchImpOD COLUMN-LABEL "Fecha-Hora" FORMAT "99/99/9999 HH:MM:SS":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 140 BY 14 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     RADIO-SET-FlgImpOD AT ROW 1.54 COL 18 NO-LABEL WIDGET-ID 6
     BROWSE-2 AT ROW 3.15 COL 3 WIDGET-ID 200
     BUTTON-12 AT ROW 1.27 COL 128 WIDGET-ID 12
     BUTTON-11 AT ROW 1.27 COL 110 WIDGET-ID 10
     BtnDone AT ROW 1.27 COL 119 WIDGET-ID 16
     "FILTRAR POR:" VIEW-AS TEXT
          SIZE 13 BY .62 AT ROW 1.81 COL 3 WIDGET-ID 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 143.57 BY 17 WIDGET-ID 100.


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
         TITLE              = "Impresión de Ordenes de Despacho"
         HEIGHT             = 17
         WIDTH              = 143.57
         MAX-HEIGHT         = 32.23
         MAX-WIDTH          = 205.72
         VIRTUAL-HEIGHT     = 32.23
         VIRTUAL-WIDTH      = 205.72
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
/* BROWSE-TAB BROWSE-2 RADIO-SET-FlgImpOD fMain */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.FacCPedi,INTEGRAL.GN-DIVI OF INTEGRAL.FacCPedi"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "INTEGRAL.FacCPedi.FchPed|no,INTEGRAL.FacCPedi.Hora|no"
     _Where[1]         = "{&CONDICION}"
     _FldNameList[1]   > INTEGRAL.GN-DIVI.DesDiv
"GN-DIVI.DesDiv" "Origen" "X(30)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = INTEGRAL.FacCPedi.CodDoc
     _FldNameList[3]   > INTEGRAL.FacCPedi.NroPed
"FacCPedi.NroPed" "Numero" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.FacCPedi.FchPed
"FacCPedi.FchPed" "Emision" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = INTEGRAL.FacCPedi.Hora
     _FldNameList[6]   > INTEGRAL.FacCPedi.NomCli
"FacCPedi.NomCli" "Cliente" ? "character" ? ? ? ? ? ? no ? no no "52.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.FacCPedi.UsrImpOD
"FacCPedi.UsrImpOD" "Impreso por" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.FacCPedi.FchImpOD
"FacCPedi.FchImpOD" "Fecha-Hora" "99/99/9999 HH:MM:SS" "datetime" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 


/* **********************  Create OCX Containers  ********************** */

&ANALYZE-SUSPEND _CREATE-DYNAMIC

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN

CREATE CONTROL-FRAME CtrlFrame ASSIGN
       FRAME           = FRAME fMain:HANDLE
       ROW             = 1
       COLUMN          = 87
       HEIGHT          = 3.85
       WIDTH           = 14.29
       WIDGET-ID       = 20
       HIDDEN          = yes
       SENSITIVE       = yes.

PROCEDURE adm-create-controls:
      CtrlFrame:NAME = "CtrlFrame":U .
/* CtrlFrame OCXINFO:CREATE-CONTROL from: {F0B88A90-F5DA-11CF-B545-0020AF6ED35A} type: PSTimer */

END PROCEDURE.

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* Impresión de Ordenes de Despacho */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Impresión de Ordenes de Despacho */
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


&Scoped-define SELF-NAME BUTTON-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-11 wWin
ON CHOOSE OF BUTTON-11 IN FRAME fMain /* Button 11 */
DO:
  MESSAGE 'Desea imprimir la Orden de Despacho?'
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
      UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.
  RUN Imprimir-Rb.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-12 wWin
ON CHOOSE OF BUTTON-12 IN FRAME fMain /* REFRESCAR */
DO:
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CtrlFrame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CtrlFrame wWin OCX.Tick
PROCEDURE CtrlFrame.PSTimer.Tick .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  None required for OCX.
  Notes:       
------------------------------------------------------------------------------*/

    {&OPEN-QUERY-{&BROWSE-NAME}}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-FlgImpOD
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-FlgImpOD wWin
ON VALUE-CHANGED OF RADIO-SET-FlgImpOD IN FRAME fMain
DO:
    ASSIGN {&self-name}.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
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

DEF INPUT PARAMETER cFamilia AS CHAR.

DEF VAR xFamilia AS CHAR.

CASE cFamilia:
    WHEN '+' THEN DO:
        xFamilia = '010'.
    END.
    WHEN '-' THEN DO:
        FOR EACH Almtfami NO-LOCK WHERE Almtfami.codcia = s-codcia
            AND Almtfami.codfam <> '010':
            IF xFamilia = '' THEN xFamilia = TRIM(Almtfami.codfam).
            ELSE xFamilia = xFamilia + ',' + TRIM(Almtfami.codfam).
        END.
    END.
    OTHERWISE DO:
        FOR EACH Almtfami NO-LOCK WHERE Almtfami.codcia = s-codcia:
            IF xFamilia = '' THEN xFamilia = TRIM(Almtfami.codfam).
            ELSE xFamilia = xFamilia + ',' + TRIM(Almtfami.codfam).
        END.
    END.
END CASE.

EMPTY TEMP-TABLE Reporte.

/* contamos los items */
c-items = 0.
conta = 0.
FOR EACH Facdpedi OF Faccpedi NO-LOCK:
    c-items = c-items + 1.
END.

FOR EACH FacDPedi OF FacCPedi NO-LOCK,
    FIRST Almmmatg NO-LOCK WHERE Almmmatg.CodCia = FacCPedi.CodCia
    AND Almmmatg.CodMat = FacDPedi.CodMat
    AND LOOKUP(Almmmatg.codfam, xFamilia) > 0,
    FIRST Almmmate NO-LOCK WHERE Almmmate.CodCia = FacCPedi.CodCia
    AND Almmmate.CodAlm = Facdpedi.AlmDes
    AND Almmmate.CodMat = FacDPedi.CodMat:
    conta = conta + 1.
    CREATE Reporte.
    ASSIGN 
        Reporte.NroPed   = FacCPedi.NroPed
        Reporte.CodAlm   = Facdpedi.AlmDes
        Reporte.CodMat   = FacDPedi.CodMat
        Reporte.DesMat   = Almmmatg.DesMat
        Reporte.DesMar   = Almmmatg.DesMar
        Reporte.UndBas   = Almmmatg.UndBas
        Reporte.CanPed   = FacDPedi.CanPed
        Reporte.CodUbi   = Almmmate.CodUbi
        Reporte.X-TRANS  = FacCPedi.Libre_c01
        Reporte.X-DIREC  = FacCPedi.Libre_c02
        Reporte.X-LUGAR  = FacCPedi.Libre_c03
        Reporte.X-CONTC  = FacCPedi.Libre_c04
        Reporte.X-HORA   = FacCPedi.Libre_c05
        Reporte.X-FECHA  = FacCPedi.Libre_f01
        Reporte.X-OBSER  = FacCPedi.Observa
        Reporte.X-Glosa  = FacCPedi.Glosa
        Reporte.X-nomcli = FacCPedi.codcli
        Reporte.X-NomCli = FacCPedi.NomCli.
END.
npage = DECIMAL(conta / c-items ) - INTEGER(conta / c-items).
IF npage < 0 THEN npage = INTEGER(conta / c-items).
ELSE npage = INTEGER(conta / c-items) + 1. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-Rb wWin 
PROCEDURE Carga-Temporal-Rb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE lKit AS LOGICAL     NO-UNDO.

EMPTY TEMP-TABLE Reporte.
FOR EACH FacDPedi OF FacCPedi NO-LOCK,
    FIRST Almmmatg NO-LOCK WHERE Almmmatg.CodCia = FacCPedi.CodCia
    AND Almmmatg.CodMat = FacDPedi.CodMat:
    CREATE Reporte.
    ASSIGN 
        Reporte.CodDoc = FacCPedi.CodDoc
        Reporte.NroPed = FacCPedi.NroPed
        Reporte.CodMat = FacDPedi.CodMat
        Reporte.DesMat = Almmmatg.DesMat
        Reporte.DesMar = Almmmatg.DesMar
        Reporte.UndBas = Almmmatg.UndBas
        Reporte.CanPed = FacDPedi.CanPed * FacDPedi.Factor
        Reporte.CodAlm = FacCPedi.CodAlm
        Reporte.CodUbi = "G-0"
        Reporte.CodZona = "G-0".
    FIND FIRST Almmmate WHERE Almmmate.CodCia = FacCPedi.CodCia
        AND Almmmate.CodAlm = FacDPedi.AlmDes
        AND Almmmate.CodMat = FacDPedi.CodMat
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmate THEN DO:
        CREATE Reporte.
        ASSIGN 
            Reporte.CodUbi = Almmmate.CodUbi.
        FIND Almtubic WHERE Almtubic.codcia = s-codcia
            AND Almtubic.codubi = Almmmate.codubi
            AND Almtubic.codalm = Almmmate.codalm
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almtubic THEN Reporte.CodZona = Almtubic.CodZona.
    END.
END.

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

OCXFile = SEARCH( "w-impod.wrx":U ).
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
ELSE MESSAGE "w-impod.wrx":U SKIP(1)
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
  DISPLAY RADIO-SET-FlgImpOD 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE RADIO-SET-FlgImpOD BROWSE-2 BUTTON-12 BUTTON-11 BtnDone 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-Rb wWin 
PROCEDURE Formato-Rb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE conta   AS INTEGER NO-UNDO INIT 1.    

c-items = 13.       /* por pagina */
npage = 0.          /* # de paginas */
conta = 1.
FOR EACH Reporte BREAK BY Reporte.CodZon BY Reporte.CodUbi BY Reporte.CodMat:
    conta = conta + 1.
    IF conta > c-items OR LAST-OF(Reporte.CodZon) THEN DO:
        npage = npage + 1.
        conta = 1.
    END.
END.

DEFINE FRAME f-cab
        Reporte.CodMat FORMAT 'X(7)'
        Reporte.DesMat FORMAT 'x(60)'
        Reporte.DesMar FORMAT 'X(24)'
        Reporte.UndBas
        Reporte.CanPed FORMAT ">>,>>>,>>9.9999"
        Reporte.CodUbi FORMAT "x(10)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + s-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" 
        {&PRN3} + {&PRN7A} + {&PRN6B} + "Pagina: " AT 85 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9"
        {&PRN4} + {&PRN7A} + {&PRN6B} + "/" + string(npage) AT 104 FORMAT "X(15)" SKIP(1)
        {&PRN4} + {&PRN6A} + " Fecha : " AT 1 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" 
        {&PRN3} + {&PRN7A} + {&PRN6B} + "N° Pedido: " + Reporte.CodDoc + ' ' + Reporte.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 90 FORMAT "X(30)" SKIP  
        {&PRN4} + {&PRN6A} + "Cliente: " + Faccpedi.nomcli + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(50)" SKIP  
        {&PRN4} + {&PRN6B} + "Hora  : " AT 1 FORMAT "X(15)" STRING(TIME,"HH:MM") FORMAT "X(12)" SKIP
        /*{&PRN4} + {&PRN7A} + {&PRN6B} + "N° Pedido: " + Reporte.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 1 FORMAT "X(30)" SKIP   */
        "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "Código  Descripción                                                    Marca                  Unidad      Cantidad Ubicación  Observaciones            " SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/***     999999  123456789012345678901234567890123456789012345678901234567890 12345678901234567890 123456789  >>,>>>,>>9.9999 56789012345              ***/
         WITH WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

conta = 1.
FOR EACH Reporte BREAK BY Reporte.CodZon BY Reporte.CodUbi BY Reporte.CodMat:
    DISPLAY STREAM Report 
        Reporte.CodMat 
        Reporte.DesMat
        Reporte.DesMar
        Reporte.UndBas
        Reporte.CanPed
        Reporte.CodUbi
        "________________________"
        WITH FRAME f-cab.
    conta = conta + 1.
/*     IF conta > c-items OR LAST-OF(Reporte.CodZon) THEN DO: */
/*         PAGE STREAM Report.                                */
/*         conta = 1.                                         */
/*     END.                                                   */
    IF LAST-OF(Reporte.CodZon) THEN DO:
        PAGE STREAM Report.
        conta = 1.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato1 wWin 
PROCEDURE Formato1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE conta    AS INTEGER NO-UNDO INIT 1.    
DEFINE VARIABLE X-Nombre LIKE gn-prov.NomPro.
DEFINE VARIABLE X-ruc    LIKE gn-prov.Ruc.
DEFINE VARIABLE x-Postal AS CHAR NO-UNDO.
DEFINE VARIABLE x-Tit AS CHAR.

FIND almtabla WHERE almtabla.tabla = 'CP'
    AND almtabla.codigo = faccpedi.codpos
    NO-LOCK NO-ERROR.
IF AVAILABLE almtabla
THEN x-Postal = almtabla.nombre.
ELSE x-Postal = ''.

IF FacCPedi.FlgImpOD = YES THEN x-Tit = "R E I M P R E S I O N".
ELSE x-Tit = ''.

FIND gn-prov WHERE 
          gn-prov.CodCia = PV-CODCIA AND
          gn-prov.CodPro = Reporte.X-TRANS 
          NO-LOCK NO-ERROR.
IF AVAILABLE gn-prov THEN                                     
          ASSIGN 
                X-Nombre = gn-prov.NomPro
                X-ruc    = gn-prov.Ruc.
DEFINE FRAME F-FtrPed
       HEADER
       'PRIMER TRAMO  : '    
       'SEGUNDO TRAMO  : '  AT 83 SKIP
       'Transport: ' X-Nombre FORMAT 'X(50)'
       'Destino  : ' AT 83 Reporte.X-LUGAR  FORMAT 'X(50)' SKIP
       'RUC      : ' X-ruc    FORMAT 'X(11)'
       'Contacto : ' AT 83 Reporte.X-CONTC FORMAT 'X(35)' SKIP
       'Dirección: ' Reporte.X-DIREC  FORMAT 'X(50)' 
       'Hora Aten :' AT 83 Reporte.X-HORA FORMAT 'X(10)' {&PRN6A} "Fecha Entrega : "  Reporte.X-FECHA {&PRN6B} SKIP /*{&PRN4} + {&PRN6A} + "Fecha Entrega : " + Reporte.X-FECHA + {&PRN6B} + {&PRN3} SKIP*/
       "OBSERVACIONES : " Reporte.X-OBSER VIEW-AS TEXT FORMAT "X(80)" SKIP
       "  TOTAL ITEMS : " c-items SKIP
       "GLOSA         : " Reporte.X-Glosa VIEW-AS TEXT FORMAT "X(80)" SKIP
       "                                                  " SKIP
       "                                                  " SKIP
       "                                                  " SKIP
       "                                                      -------------------     -------------------    -------------------" SKIP
       "                                                          Operador(a)         VoBo Jefe de Ventas       VoBo Cta.Cte.   " SKIP
       "HORA : " AT 1 STRING(TIME,"HH:MM")  S-USER-ID TO 67 SKIP(1) 
       WITH PAGE-BOTTOM NO-LABELS NO-BOX STREAM-IO WIDTH 160.

DEFINE FRAME f-cab
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN7A} + {&PRN6A} + x-Tit + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT 'x(30)' SKIP
        {&PRN4} + {&PRN6A} + " Fecha : " AT 1 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" 
        {&PRN3} + {&PRN7A} + {&PRN6B} + "N° Pedido: " + Reporte.NroPed  + {&PRN6B} + {&PRN7B} + {&PRN3} AT 90 FORMAT "X(30)" SKIP  
        "Fecha del Pedido: " AT 10 Faccpedi.fchped SKIP
        "Codigo: " AT 10 faccpedi.CodCli FORMAT "x(15)" "Cliente: " AT 35 FacCPedi.NomCli SKIP
        "Postal: " AT 10 x-Postal FORMAT 'x(30)' SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "Código  Descripción                                                    Marca                  Unidad      Cantidad Almacen Ubicación    " SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------" SKIP
/***     999999  123456789012345678901234567890123456789012345678901234567890 12345678901234567890 123456789  >>,>>>,>>9.9999 123 56789012345              ***/
         WITH PAGE-TOP WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

DEFINE FRAME f-det
        Reporte.CodMat FORMAT 'X(7)'
        Reporte.DesMat FORMAT 'x(60)'
        Reporte.DesMar FORMAT 'X(24)'
        Reporte.UndBas
        Reporte.CanPed FORMAT ">>,>>>,>>9.9999"
        Reporte.CodAlm FORMAT 'x(3)'
        Reporte.CodUbi FORMAT "x(10)"
         WITH WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
FOR EACH Reporte BREAK BY Reporte.NroPed BY Reporte.CodAlm BY Reporte.CodUbi:
         VIEW STREAM Report FRAME F-Cab.
         VIEW STREAM Report FRAME F-FtrPed. 
         DISPLAY STREAM Report 
                Reporte.CodMat 
                Reporte.DesMat
                Reporte.DesMar
                Reporte.UndBas
                Reporte.CanPed
                Reporte.CodAlm
                Reporte.CodUbi
                WITH FRAME f-det.
         IF LAST-OF(Reporte.NroPed) THEN DO:
                PAGE STREAM Report.
                HIDE STREAM REPORT FRAME F-FtrPed .
         END.
END.

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

/* rutina de impresion */
DEF VAR iCopias AS INT.
DEF VAR k AS INT NO-UNDO.

FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAILABLE Faccpedi THEN RETURN.

DEF VAR x-Ok AS LOG INIT NO NO-UNDO.

SYSTEM-DIALOG PRINTER-SETUP NUM-COPIES iCopias UPDATE x-Ok.
IF x-Ok = NO THEN RETURN.
IF iCopias = 0 THEN iCopias = 1.

/* RHC 04.12.09 VAMOS A HACER 2 IMPRESIONES:
Una con la familia 010 y otra con las demás familias
*/

DO k = 1 TO iCopias:
    RUN Carga-Temporal ('+').
    FIND FIRST Reporte NO-LOCK NO-ERROR.
    IF AVAILABLE Reporte THEN DO:
        OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 60.
        PUT STREAM report CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        RUN Formato1.
        OUTPUT STREAM report CLOSE.
    END.
    RUN Carga-Temporal ('-').
    FIND FIRST Reporte NO-LOCK NO-ERROR.
    IF AVAILABLE Reporte THEN DO:
        OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 60.
        PUT STREAM report CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        RUN Formato1.
        OUTPUT STREAM report CLOSE.
    END.
END.

ASSIGN
    FacCPedi.FlgImpOD = YES
    FacCPedi.UsrImpOD = s-user-id
    FacCPedi.FchImpOD = DATETIME(TODAY, MTIME).
FIND CURRENT Faccpedi NO-LOCK NO-ERROR.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir-Rb wWin 
PROCEDURE Imprimir-Rb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


/* Impresión por Zonas y Ubicaciones */
DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

RUN lib/Imprimir2.
IF s-salida-impresion = 0 THEN RETURN.

RUN Carga-Temporal-Rb.

FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAILABLE Faccpedi THEN RETURN.

IF s-salida-impresion = 1 THEN 
    s-print-file = SESSION:TEMP-DIRECTORY +
    STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN
            OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 30.
        WHEN 2 THEN
            OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 30. /* Impresora */
    END CASE.
    PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(33) + {&Prn4} .
    RUN Formato-Rb.
    PAGE STREAM REPORT.
    OUTPUT STREAM REPORT CLOSE.
END.
OUTPUT CLOSE.

CASE s-salida-impresion:
    WHEN 1 OR WHEN 3 THEN DO:
        RUN LIB/W-README.R(s-print-file).
        IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
    END.
END CASE.


ASSIGN
    FacCPedi.FlgImpOD = YES
    FacCPedi.UsrImpOD = s-user-id
    FacCPedi.FchImpOD = DATETIME(TODAY, MTIME).
FIND CURRENT Faccpedi NO-LOCK NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

