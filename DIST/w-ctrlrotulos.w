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
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-codalm AS CHAR.

DEF VAR s-task-no AS INT.
DEFINE VAR i-nro        AS INTEGER NO-UNDO.

DEF VAR x-Tiempo AS CHAR.

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
&Scoped-define INTERNAL-TABLES CcbCBult pl-pers

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 CcbCBult.CodDoc CcbCBult.NroDoc CcbCBult.NomCli CcbCBult.Bultos CcbCBult.FchDoc CcbCBult.Chr_02 pl-pers.patper pl-pers.matper pl-pers.nomper CcbCBult.Dte_01 CcbCBult.Chr_03 fTiempo() @ x-Tiempo   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2   
&Scoped-define SELF-NAME BROWSE-2
&Scoped-define OPEN-QUERY-BROWSE-2  ASSIGN txtDesde txtHasta.  SESSION:SET-WAIT-STATE('GENERAL').  CASE COMBO-BOX-1:     WHEN "Nombres que inicien con" THEN DO:         OPEN QUERY {&SELF-NAME} FOR EACH CcbCBult             WHERE CcbCBult.CodCia = s-codcia             AND CcbCBult.CodDiv = s-coddiv             AND (CcbCBult.fchdoc >= txtDesde AND CcbCBult.fchdoc <= txtHasta)             AND (CcbCBult.CodDoc = "O/D"                  OR CcbCBult.CodDoc = "O/M"                  OR CcbCBult.CodDoc = "OTR"                  OR CcbCBult.CodDoc = "G/R"                  OR CcbCBult.CodDoc = "TRA")             AND CcbCBult.NomCli BEGINS FILL-IN-NomCli NO-LOCK, ~
                   FIRST pl-pers NO-LOCK WHERE pl-pers.codcia = s-codcia             AND pl-pers.codper =  CcbCBult.Chr_02 OUTER-JOIN             BY CcbCBult.FchDoc DESC INDEXED-REPOSITION.     END.     WHEN "Nombres que contengan" THEN DO:         OPEN QUERY {&SELF-NAME} FOR EACH CcbCBult             WHERE CcbCBult.CodCia = s-codcia             AND CcbCBult.CodDiv = s-coddiv             AND (CcbCBult.fchdoc >= txtDesde AND CcbCBult.fchdoc <= txtHasta)             AND (CcbCBult.CodDoc = "O/D"                  OR CcbCBult.CodDoc = "O/M"                  OR CcbCBult.CodDoc = "OTR"                  OR CcbCBult.CodDoc = "G/R"                  OR CcbCBult.CodDoc = "TRA")             AND CcbCBult.NomCli CONTAINS FILL-IN-NomCli NO-LOCK, ~
                   FIRST pl-pers NO-LOCK WHERE pl-pers.codcia = s-codcia             AND pl-pers.codper =  CcbCBult.Chr_02 OUTER-JOIN             BY CcbCBult.FchDoc DESC INDEXED-REPOSITION.     END.     OTHERWISE OPEN QUERY {&SELF-NAME} FOR EACH CcbCBult         WHERE CcbCBult.CodCia = s-codcia         AND CcbCBult.CodDiv = s-coddiv         AND (CcbCBult.fchdoc >= txtDesde AND CcbCBult.fchdoc <= txtHasta)         AND (CcbCBult.CodDoc = "O/D"              OR CcbCBult.CodDoc = "O/M"              OR CcbCBult.CodDoc = "OTR"              OR CcbCBult.CodDoc = "G/R"              OR CcbCBult.CodDoc = "TRA") NO-LOCK, ~
                   FIRST pl-pers NO-LOCK WHERE pl-pers.codcia = s-codcia             AND pl-pers.codper =  CcbCBult.Chr_02 OUTER-JOIN         BY CcbCBult.FchDoc DESC INDEXED-REPOSITION. END CASE.  SESSION:SET-WAIT-STATE('').
&Scoped-define TABLES-IN-QUERY-BROWSE-2 CcbCBult pl-pers
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 CcbCBult
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 pl-pers


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-2 BUTTON-3 BtnDone btn-excel ~
COMBO-BOX-1 FILL-IN-NomCli txtDesde txtHasta BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-1 FILL-IN-NomCli txtDesde ~
txtHasta 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fTiempo wWin 
FUNCTION fTiempo RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btn-excel 
     LABEL "Excel" 
     SIZE 15 BY 1.35.

DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 8 BY 1.35
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-2 
     LABEL "NUEVO ROTULO" 
     SIZE 18 BY 1.35.

DEFINE BUTTON BUTTON-3 
     LABEL "REIMPRIMIR ROTULO" 
     SIZE 18 BY 1.35.

DEFINE VARIABLE COMBO-BOX-1 AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "Todos","Nombres que inicien con","Nombres que contengan" 
     DROP-DOWN-LIST
     SIZE 21 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .81 NO-UNDO.

DEFINE VARIABLE txtDesde AS DATE FORMAT "99/99/9999":U INITIAL 01/01/00 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE txtHasta AS DATE FORMAT "99/99/9999":U INITIAL 01/01/00 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      CcbCBult, 
      pl-pers SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 wWin _FREEFORM
  QUERY BROWSE-2 NO-LOCK DISPLAY
      CcbCBult.CodDoc FORMAT "x(3)":U
      CcbCBult.NroDoc FORMAT "X(9)":U WIDTH 9.57
      CcbCBult.NomCli FORMAT "x(45)":U
      CcbCBult.Bultos FORMAT ">>>9":U
      CcbCBult.FchDoc COLUMN-LABEL "Fecha de Rotulado" FORMAT "99/99/9999":U
      CcbCBult.Chr_02 FORMAT "x(8)" COLUMN-LABEL "Chequeador"
      pl-pers.patper FORMAT "x(15)" COLUMN-LABEL "Apellido Paterno"
      pl-pers.matper FORMAT "x(15)" COLUMN-LABEL "Apellido Materno"
      pl-pers.nomper FORMAT "x(15)" COLUMN-LABEL "Nombres"
      CcbCBult.Dte_01 FORMAT "99/99/9999" COLUMN-LABEL "Dia chequeo"
      CcbCBult.Chr_03 FORMAT "X(8)" COLUMN-LABEL "Hora" 
      fTiempo() @ x-Tiempo COLUMN-LABEL "Tiempo" FORMAT "x(15)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 136 BY 15.08
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     BUTTON-2 AT ROW 1.12 COL 95 WIDGET-ID 2
     BUTTON-3 AT ROW 1.12 COL 113 WIDGET-ID 4
     BtnDone AT ROW 1.12 COL 131 WIDGET-ID 22
     btn-excel AT ROW 1.15 COL 75 WIDGET-ID 28
     COMBO-BOX-1 AT ROW 1.27 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     FILL-IN-NomCli AT ROW 1.27 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     txtDesde AT ROW 2.54 COL 5 COLON-ALIGNED WIDGET-ID 30
     txtHasta AT ROW 2.54 COL 23.72 COLON-ALIGNED WIDGET-ID 32
     BROWSE-2 AT ROW 3.96 COL 3 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 138.57 BY 19.19
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Design Page: 1
   Other Settings: COMPILE APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "CONTROL DE BULTOS POR ORDENES DE DESPACHO"
         HEIGHT             = 19.19
         WIDTH              = 138.57
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
/* BROWSE-TAB BROWSE-2 txtHasta fMain */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _START_FREEFORM

ASSIGN txtDesde txtHasta.

SESSION:SET-WAIT-STATE('GENERAL').

CASE COMBO-BOX-1:
    WHEN "Nombres que inicien con" THEN DO:
        OPEN QUERY {&SELF-NAME} FOR EACH CcbCBult
            WHERE CcbCBult.CodCia = s-codcia
            AND CcbCBult.CodDiv = s-coddiv
            AND (CcbCBult.fchdoc >= txtDesde AND CcbCBult.fchdoc <= txtHasta)
            AND (CcbCBult.CodDoc = "O/D"
                 OR CcbCBult.CodDoc = "O/M"
                 OR CcbCBult.CodDoc = "OTR"
                 OR CcbCBult.CodDoc = "G/R"
                 OR CcbCBult.CodDoc = "TRA")
            AND CcbCBult.NomCli BEGINS FILL-IN-NomCli NO-LOCK,
            FIRST pl-pers NO-LOCK WHERE pl-pers.codcia = s-codcia
            AND pl-pers.codper =  CcbCBult.Chr_02 OUTER-JOIN
            BY CcbCBult.FchDoc DESC INDEXED-REPOSITION.
    END.
    WHEN "Nombres que contengan" THEN DO:
        OPEN QUERY {&SELF-NAME} FOR EACH CcbCBult
            WHERE CcbCBult.CodCia = s-codcia
            AND CcbCBult.CodDiv = s-coddiv
            AND (CcbCBult.fchdoc >= txtDesde AND CcbCBult.fchdoc <= txtHasta)
            AND (CcbCBult.CodDoc = "O/D"
                 OR CcbCBult.CodDoc = "O/M"
                 OR CcbCBult.CodDoc = "OTR"
                 OR CcbCBult.CodDoc = "G/R"
                 OR CcbCBult.CodDoc = "TRA")
            AND CcbCBult.NomCli CONTAINS FILL-IN-NomCli NO-LOCK,
            FIRST pl-pers NO-LOCK WHERE pl-pers.codcia = s-codcia
            AND pl-pers.codper =  CcbCBult.Chr_02 OUTER-JOIN
            BY CcbCBult.FchDoc DESC INDEXED-REPOSITION.
    END.
    OTHERWISE OPEN QUERY {&SELF-NAME} FOR EACH CcbCBult
        WHERE CcbCBult.CodCia = s-codcia
        AND CcbCBult.CodDiv = s-coddiv
        AND (CcbCBult.fchdoc >= txtDesde AND CcbCBult.fchdoc <= txtHasta)
        AND (CcbCBult.CodDoc = "O/D"
             OR CcbCBult.CodDoc = "O/M"
             OR CcbCBult.CodDoc = "OTR"
             OR CcbCBult.CodDoc = "G/R"
             OR CcbCBult.CodDoc = "TRA") NO-LOCK,
            FIRST pl-pers NO-LOCK WHERE pl-pers.codcia = s-codcia
            AND pl-pers.codper =  CcbCBult.Chr_02 OUTER-JOIN
        BY CcbCBult.FchDoc DESC INDEXED-REPOSITION.
END CASE.

SESSION:SET-WAIT-STATE('').
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "INTEGRAL.CcbCBult.CodCia = s-codcia
 AND INTEGRAL.CcbCBult.CodDiv = s-coddiv
 AND (INTEGRAL.CcbCBult.CodDoc = ""PED""
  OR INTEGRAL.CcbCBult.CodDoc = ""P/M"")"
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* CONTROL DE BULTOS POR ORDENES DE DESPACHO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* CONTROL DE BULTOS POR ORDENES DE DESPACHO */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-excel wWin
ON CHOOSE OF btn-excel IN FRAME fMain /* Excel */
DO:
  RUN gen-excel.
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
ON CHOOSE OF BUTTON-2 IN FRAME fMain /* NUEVO ROTULO */
DO:
    DEF VAR pCodDoc AS CHAR.
    DEF VAR pNroDoc AS CHAR.
    DEF VAR pBultos AS INT.

    RUN dist/w-rotxped-01 (OUTPUT pCodDoc, OUTPUT pNroDoc, OUTPUT pBultos).
    IF pNroDoc = '' THEN RETURN NO-APPLY.
    CASE pCodDoc:
        WHEN 'O/D' OR WHEN 'O/M' OR WHEN 'OTR' THEN DO:
            FIND Faccpedi WHERE Faccpedi.codcia = s-codcia
                AND Faccpedi.divdes = s-coddiv
                AND Faccpedi.coddoc = pcoddoc
                AND Faccpedi.nroped = pnrodoc
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Faccpedi THEN RETURN NO-APPLY.
            IF CAN-FIND(FIRST Ccbcbult WHERE Ccbcbult.codcia = s-codcia
                        AND Ccbcbult.coddoc = Faccpedi.coddoc
                        AND Ccbcbult.nrodoc = Faccpedi.nroped
                        AND Ccbcbult.CHR_01 = "P"
                        NO-LOCK) THEN DO:
                MESSAGE 'Este documento YA fue rotulado' VIEW-AS ALERT-BOX ERROR.
                RETURN NO-APPLY.
            END.
            CREATE CcbCBult.
            ASSIGN
                CcbCBult.CodCia = s-codcia
                CcbCBult.CodDiv = s-coddiv
                CcbCBult.CodDoc = Faccpedi.coddoc
                CcbCBult.NroDoc = Faccpedi.nroped
                CcbCBult.Bultos = pBultos
                CcbCBult.CodCli = Faccpedi.codcli
                CcbCBult.FchDoc = TODAY
                CcbCBult.NomCli = Faccpedi.nomcli
                CcbCBult.CHR_01 = "P"       /* Emitido */
                CcbCBult.usuario = s-user-id
                CcbCBult.Chr_02 = Faccpedi.usrchq
                CcbCBult.Chr_03 = Faccpedi.horchq
                CcbCBult.Dte_01 = Faccpedi.fchchq
                CcbCBult.Chr_04 = Faccpedi.horsac
                CcbCBult.Dte_02 = Faccpedi.fecsac.
            RELEASE Ccbcbult.
        END.
        WHEN 'TRA' THEN DO:
            FOR EACH Almacen NO-LOCK WHERE Almacen.codcia = s-codcia
                AND Almacen.coddiv = s-coddiv:
                FIND almcmov WHERE almcmov.codcia = s-codcia
                    AND almcmov.codalm = Almacen.codalm
                    AND almcmov.tipmov = 'S'
                    AND almcmov.codmov = 03
                    AND almcmov.nroser = INTEGER(SUBSTRING (pnrodoc, 1, 3) )
                    AND almcmov.nrodoc = INTEGER(SUBSTRING (pnrodoc, 4) )
                    NO-LOCK NO-ERROR.
                IF AVAILABLE almcmov THEN LEAVE.
            END.
            IF NOT AVAILABLE Almcmov THEN RETURN NO-APPLY.
            IF CAN-FIND(FIRST Ccbcbult WHERE Ccbcbult.codcia = s-codcia
                        AND Ccbcbult.coddoc = pcoddoc
                        AND Ccbcbult.nrodoc = pnrodoc
                        AND Ccbcbult.CHR_01 = "P"
                        NO-LOCK) THEN DO:
                MESSAGE 'Este documento YA fue rotulado' VIEW-AS ALERT-BOX ERROR.
                RETURN NO-APPLY.
            END.
            CREATE CcbCBult.
            ASSIGN
                CcbCBult.CodCia = s-codcia
                CcbCBult.CodDiv = s-coddiv
                CcbCBult.CodDoc = pcoddoc
                CcbCBult.NroDoc = pnrodoc
                CcbCBult.Bultos = pBultos
                CcbCBult.CodCli = Almcmov.codalm
                CcbCBult.FchDoc = TODAY
                CcbCBult.NomCli = Almacen.Descripcion
                CcbCBult.CHR_01 = "P"       /* Emitido */
                CcbCBult.usuario = s-user-id
                CcbCBult.Chr_02 = Almcmov.Libre_c03
                CcbCBult.Chr_03 = Almcmov.Libre_c04
                CcbCBult.Dte_01 = Almcmov.Libre_f01
                CcbCBult.Chr_04 = Almcmov.Libre_c05
                CcbCBult.Dte_02 = Almcmov.Libre_f02.
            IF NUM-ENTRIES(Almcmov.Libre_c03,'|') = 5
                THEN ASSIGN
                CcbCBult.Chr_02 = ENTRY(1,Almcmov.Libre_c03,'|')
                CcbCBult.Chr_03 = ENTRY(3,Almcmov.Libre_c03,'|')
                CcbCBult.Dte_01 = DATE(ENTRY(2,Almcmov.Libre_c03,'|'))
                CcbCBult.Chr_04 = ENTRY(5,Almcmov.Libre_c03,'|')
                CcbCBult.Dte_02 = DATE(ENTRY(4,Almcmov.Libre_c03,'|')).

            RELEASE Ccbcbult.
        END.
        WHEN 'G/R' THEN DO:
            FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia
                AND ccbcdocu.coddiv = s-coddiv
                AND ccbcdocu.coddoc = pcoddoc
                AND ccbcdocu.nrodoc = pnrodoc NO-LOCK NO-ERROR.
            IF NOT AVAIL ccbcdocu THEN RETURN NO-APPLY.
            CREATE CcbCBult.
            ASSIGN
                CcbCBult.CodCia = s-codcia
                CcbCBult.CodDiv = s-coddiv
                CcbCBult.CodDoc = pcoddoc
                CcbCBult.NroDoc = pnrodoc
                CcbCBult.Bultos = pBultos
                CcbCBult.CodCli = Ccbcdocu.codcli
                CcbCBult.FchDoc = TODAY
                CcbCBult.NomCli = Ccbcdocu.nomcli
                CcbCBult.CHR_01 = "P"       /* Emitido */
                CcbCBult.usuario = s-user-id.
            RELEASE Ccbcbult.
        END.
    END CASE.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 wWin
ON CHOOSE OF BUTTON-3 IN FRAME fMain /* REIMPRIMIR ROTULO */
DO:
    IF NOT AVAILABLE CcbCBult THEN RETURN.
    DEFINE VARIABLE iInt      AS INTEGER          NO-UNDO.
    DEFINE VARIABLE L-Ubica   AS LOGICAL INIT YES NO-UNDO.        

    REPEAT WHILE L-Ubica:
           s-task-no = RANDOM(900000,999999).
           FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
           IF NOT AVAILABLE w-report THEN L-Ubica = NO.
    END.

    DO iint = 1 TO CcbCBult.Bultos:
        i-nro = iint.
        RUN Carga-Datos.
    END.

    /* Code placed here will execute PRIOR to standard behavior. */
    DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
    DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
    DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
    DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
    DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */

    GET-KEY-VALUE SECTION 'Startup' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
    RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'vta/rbvta.prl'.
    /*RB-REPORT-NAME = 'RotuloxPedidos-1'.*/
    RB-REPORT-NAME = 'RotuloxPedidos'.
    RB-INCLUDE-RECORDS = 'O'.

    RB-FILTER = "w-report.task-no = " + STRING(s-task-no).
    RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                       RB-REPORT-NAME,
                       RB-INCLUDE-RECORDS,
                       RB-FILTER,
                       RB-OTHER-PARAMETERS).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-1 wWin
ON VALUE-CHANGED OF COMBO-BOX-1 IN FRAME fMain
DO:
  ASSIGN {&self-name}.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NomCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NomCli wWin
ON LEAVE OF FILL-IN-NomCli IN FRAME fMain
DO:
  ASSIGN {&self-name}.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtDesde
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtDesde wWin
ON LEAVE OF txtDesde IN FRAME fMain /* Desde */
DO:
    ASSIGN {&self-name}.
    {&OPEN-QUERY-{&BROWSE-NAME}}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtHasta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtHasta wWin
ON LEAVE OF txtHasta IN FRAME fMain /* Hasta */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Datos wWin 
PROCEDURE Carga-Datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VAR dPeso        AS INTEGER   NO-UNDO.
    DEFINE VAR cNomChq      AS CHARACTER NO-UNDO.
    DEFINE VAR cDir         AS CHARACTER NO-UNDO.
    DEFINE VAR cSede        AS CHARACTER NO-UNDO.
    DEFINE VAR dFactor      AS DECIMAL   NO-UNDO.

    cNomCHq = "".
    IF CcbCBult.Chr_02 <> "" THEN DO:
        FIND FIRST Pl-pers WHERE pl-pers.codcia = s-codcia
            AND Pl-pers.codper = CcbCBult.Chr_02 NO-LOCK NO-ERROR.
        IF AVAILABLE Pl-pers 
            THEN cNomCHq = Pl-pers.codper + "-" + TRIM(Pl-pers.patper) + ' ' +
                TRIM(Pl-pers.matper) + ',' + TRIM(PL-pers.nomper).                
    END.
    CASE Ccbcbult.coddoc:
        WHEN "O/D" OR WHEN "O/M" OR WHEN "OTR" THEN DO:
            FIND faccpedi WHERE faccpedi.codcia = s-codcia
                AND faccpedi.divdes = s-coddiv
                AND faccpedi.coddoc = Ccbcbult.coddoc
                AND faccpedi.nroped = Ccbcbult.nrodoc NO-LOCK NO-ERROR.
            IF NOT AVAIL faccpedi THEN DO:
                MESSAGE "Documento no registrado"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                RETURN "adm-error".
            END.

            dPeso = 0.
            FOR EACH facdpedi OF faccpedi NO-LOCK,
                FIRST almmmatg OF facdpedi NO-LOCK:
              dPeso = dPeso + (facdpedi.canped * almmmatg.pesmat).
            END.

            /*Datos Sede de Venta*/
            FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia
                AND gn-divi.coddiv = faccpedi.coddiv NO-LOCK NO-ERROR.
            IF AVAIL gn-divi THEN 
                ASSIGN 
                    cDir = INTEGRAL.GN-DIVI.DirDiv
                    cSede = INTEGRAL.GN-DIVI.DesDiv.
            FIND Almacen WHERE Almacen.codcia = s-codcia
                AND Almacen.codalm = s-CodAlm
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almacen THEN cDir = Almacen.DirAlm.
            
            CREATE w-report.
            ASSIGN 
                w-report.Task-No  = s-task-no
                w-report.Llave-C  = "01" + faccpedi.nroped
                w-report.Campo-C[1] = faccpedi.ruc
                w-report.Campo-C[2] = faccpedi.nomcli
                w-report.Campo-C[3] = faccpedi.dircli
                w-report.Campo-C[4] = cNomChq
                w-report.Campo-D[1] = faccpedi.fchped
                w-report.Campo-C[5] = STRING(Ccbcbult.bultos)
                w-report.Campo-F[1] = dPeso
                w-report.Campo-C[7] = faccpedi.nroped
                w-report.Campo-I[1] = i-nro
                w-report.Campo-C[8] = cDir
                w-report.Campo-C[9] = cSede.
        END.
        WHEN "TRA" THEN DO:
/*             FOR EACH Almacen NO-LOCK WHERE Almacen.codcia = s-codcia                 */
/*                 AND Almacen.coddiv = s-coddiv:                                       */
/*                 FIND almcmov WHERE almcmov.codcia = s-codcia                         */
/*                     AND almcmov.codalm = Almacen.codalm                              */
/*                     AND almcmov.tipmov = 'S'                                         */
/*                     AND almcmov.codmov = 03                                          */
/*                     AND almcmov.nroser = INTEGER(SUBSTRING (Ccbcbult.nrodoc, 1, 3) ) */
/*                     AND almcmov.nrodoc = INTEGER(SUBSTRING (Ccbcbult.nrodoc, 4) )    */
/*                     NO-LOCK NO-ERROR.                                                */
/*                 IF AVAILABLE almcmov THEN LEAVE.                                     */
/*             END.                                                                     */
            FIND Almcmov WHERE Almcmov.codcia = s-codcia
                AND Almcmov.codalm = Ccbcbult.codcli
                AND almcmov.tipmov = 'S'
                AND almcmov.codmov = 03
                AND almcmov.nroser = INTEGER(SUBSTRING (Ccbcbult.nrodoc, 1, 3) )
                AND almcmov.nrodoc = INTEGER(SUBSTRING (Ccbcbult.nrodoc, 4) )
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE almcmov
            THEN DO:
                MESSAGE 'Guia de transferencia no encontrada'
                    VIEW-AS ALERT-BOX ERROR.
                RETURN 'ADM-ERROR'.
            END.
            dPeso = 0.
            FOR EACH Almdmov OF Almcmov NO-LOCK, FIRST Almmmatg OF Almdmov NO-LOCK:
              dPeso = dPeso + (almdmov.candes * almdmov.factor * almmmatg.pesmat).
            END.
            /*Datos Sede de Venta*/
            FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia
                AND gn-divi.coddiv = s-coddiv NO-LOCK NO-ERROR.
            IF AVAIL gn-divi THEN 
                ASSIGN 
                    cDir = INTEGRAL.GN-DIVI.DirDiv
                    cSede = INTEGRAL.GN-DIVI.DesDiv.
            FIND Almacen WHERE Almacen.codcia = s-codcia
                AND Almacen.codalm = Almcmov.AlmDes
                NO-LOCK NO-ERROR.
            CREATE w-report.
            ASSIGN 
                w-report.Task-No  = s-task-no
                w-report.Llave-C  = "03" + STRING(Almcmov.nroser, '999') + STRING(Almcmov.nrodoc, '999999')
                w-report.Campo-C[1] = ""
                w-report.Campo-C[2] = Almacen.Descripcion
                w-report.Campo-C[3] = Almacen.DirAlm
                w-report.Campo-C[4] = cNomChq
                w-report.Campo-D[1] = almcmov.fchdoc
                w-report.Campo-C[5] = STRING(Ccbcbult.bultos)
                w-report.Campo-F[1] = dPeso
                w-report.Campo-C[7] = Ccbcbult.nrodoc
                w-report.Campo-I[1] = i-nro
                w-report.Campo-C[8] = cDir
                w-report.Campo-C[9] = cSede.
        END.
        WHEN "G/R" THEN DO:
            FIND ccbcdocu WHERE ccbcdocu.codcia = s-codcia
                AND ccbcdocu.coddiv = s-coddiv
                AND ccbcdocu.coddoc = Ccbcbult.coddoc
                AND ccbcdocu.nrodoc = Ccbcbult.nrodoc NO-LOCK NO-ERROR.
            IF NOT AVAIL ccbcdocu THEN DO:
                MESSAGE "Documento no registrado"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                RETURN "adm-error".
            END.

            dPeso = 0.
            FOR EACH ccbddocu OF ccbcdocu NO-LOCK,
                FIRST almmmatg OF ccbddocu NO-LOCK:
                /*Busca Factor de Venta */
                FIND almtconv WHERE almtconv.codunid = almmmatg.undbas
                    AND almtconv.codalter = ccbddocu.undvta NO-LOCK NO-ERROR.
                IF AVAIL almtconv THEN dfactor = almtconv.equival.
                ELSE dfactor = 1.
                /************************/
              dPeso = dPeso + (CcbDDocu.CanDes * almmmatg.pesmat * dFactor).
            END.
            /*Datos Punto de Partida*/
            FIND FIRST almacen WHERE almacen.codcia = s-codcia
                AND almacen.codalm = ccbcdocu.codalm NO-LOCK NO-ERROR.
            IF AVAIL almacen THEN 
                ASSIGN 
                    cDir = Almacen.DirAlm
                    cSede = Almacen.Descripcion.
            
            CREATE w-report.
            ASSIGN 
                w-report.Task-No  = s-task-no
                w-report.Llave-C  = ccbcdocu.nroped
                w-report.Campo-C[1] = ccbcdocu.ruc
                w-report.Campo-C[2] = ccbcdocu.nomcli
                w-report.Campo-C[3] = ccbcdocu.dircli
                w-report.Campo-C[4] = cNomChq
                w-report.Campo-D[1] = ccbcdocu.libre_f02
                w-report.Campo-C[5] = STRING(Ccbcbult.bultos)
                w-report.Campo-F[1] = dPeso
                w-report.Campo-C[7] = ccbcdocu.nroped
                w-report.Campo-I[1] = i-nro
                w-report.Campo-C[8] = cDir
                w-report.Campo-C[9] = cSede.
        END.

    END CASE.

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
  DISPLAY COMBO-BOX-1 FILL-IN-NomCli txtDesde txtHasta 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE BUTTON-2 BUTTON-3 BtnDone btn-excel COMBO-BOX-1 FILL-IN-NomCli 
         txtDesde txtHasta BROWSE-2 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gen-excel wWin 
PROCEDURE gen-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

        DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
        DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
        DEFINE VARIABLE chWorksheet             AS COM-HANDLE.

        DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.

        DEFINE VARIABLE iCount                  AS INTEGER init 1.
        DEFINE VARIABLE iIndex                  AS INTEGER.
        DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 1.
        DEFINE VARIABLE cColumn                 AS CHARACTER.
        DEFINE VARIABLE cRange                  AS CHARACTER.
        DEFINE VARIABLE x-signo                 AS DECI.

        /* create a new Excel Application object */
        CREATE "Excel.Application" chExcelApplication.

        /* launch Excel so it is visible to the user */
        chExcelApplication:Visible = TRUE.

        /* Para crear a new Workbook */
        chWorkbook = chExcelApplication:Workbooks:Add().

        /* get the active Worksheet */
        chWorkSheet = chExcelApplication:Sheets:Item(1).

        chWorkSheet:Range("A1:R1"):Font:Bold = TRUE.
        chWorkSheet:Range("A1"):Value = "CODIGO".
        chWorkSheet:Range("B1"):Value = "Numero".
        chWorkSheet:Range("C1"):Value = "Nombre".
        chWorkSheet:Range("D1"):Value = "Bultos".
        chWorkSheet:Range("E1"):Value = "Fecha Rotulado".
        chWorkSheet:Range("F1"):Value = "Chequedor".
        chWorkSheet:Range("G1"):Value = "AP. Paterno".
        chWorkSheet:Range("H1"):Value = "Ap. Materno".
    chWorkSheet:Range("I1"):Value = "Nombres".
        chWorkSheet:Range("J1"):Value = "Dia Chequeo".
        chWorkSheet:Range("K1"):Value = "Hora".
        chWorkSheet:Range("L1"):Value = "Tiempo".


        chExcelApplication:DisplayAlerts = False.
/*      chExcelApplication:Quit().*/

    iColumn = 1.        
    GET FIRST {&BROWSE-NAME}.
    DO  WHILE AVAILABLE CcbCBult:
    
             iColumn = iColumn + 1.
             cColumn = STRING(iColumn).

             cRange = "A" + cColumn.
             chWorkSheet:Range(cRange):Value = "'" + CcbCBult.CodDoc.
         cRange = "B" + cColumn.
         chWorkSheet:Range(cRange):Value = "'" + CcbCBult.NroDoc.
         cRange = "C" + cColumn.
         chWorkSheet:Range(cRange):Value = CcbCBult.NomCli.
         cRange = "D" + cColumn.
         chWorkSheet:Range(cRange):Value = CcbCBult.Bultos.
         cRange = "E" + cColumn.
         chWorkSheet:Range(cRange):Value = CcbCBult.FchDoc.
         cRange = "F" + cColumn.
         chWorkSheet:Range(cRange):Value = "'" + CcbCBult.Chr_02.
         cRange = "G" + cColumn.
         chWorkSheet:Range(cRange):Value = pl-pers.patper.
         cRange = "H" + cColumn.
         chWorkSheet:Range(cRange):Value = pl-pers.matper.
         cRange = "I" + cColumn.
         chWorkSheet:Range(cRange):Value = pl-pers.nomper.
         cRange = "J" + cColumn.
         chWorkSheet:Range(cRange):Value = CcbCBult.Dte_01.
         cRange = "K" + cColumn.
         chWorkSheet:Range(cRange):Value = CcbCBult.Chr_03.

         x-Tiempo = ''.
         RUN lib/_time-passed ( DATETIME(STRING(Ccbcbult.dte_02) + ' ' + STRING(Ccbcbult.CHR_04)),
                                     DATETIME(STRING(Ccbcbult.dte_01) + ' ' + STRING(Ccbcbult.CHR_03)), OUTPUT x-Tiempo).

         cRange = "L" + cColumn.
         chWorkSheet:Range(cRange):Value = "'" + x-Tiempo.


        GET NEXT {&BROWSE-NAME}.
    END.  
          

        /* release com-handles */
        RELEASE OBJECT chExcelApplication NO-ERROR.      
        RELEASE OBJECT chWorkbook NO-ERROR.
        RELEASE OBJECT chWorksheet NO-ERROR.
        RELEASE OBJECT chWorksheetRange NO-ERROR. 

        MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.


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
  txtDesde = TODAY - DAY(TODAY) + 1.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    txtHasta:SCREEN-VALUE = STRING(TODAY,"99/99/9999").
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fTiempo wWin 
FUNCTION fTiempo RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RUN lib/_time-passed ( DATETIME(STRING(Ccbcbult.dte_02) + ' ' + STRING(Ccbcbult.CHR_04)),
                              DATETIME(STRING(Ccbcbult.dte_01) + ' ' + STRING(Ccbcbult.CHR_03)), OUTPUT x-Tiempo).
  RETURN x-Tiempo.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

