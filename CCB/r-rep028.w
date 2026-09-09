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

DEF VAR pDivisiones AS CHAR NO-UNDO.

DEF TEMP-TABLE Detalle
    FIELD Division  AS CHAR                 LABEL 'DIVISION'        FORMAT 'x(50)'
    FIELD Tipo      AS CHAR                 LABEL 'TIPO'
    FIELD Concepto  AS CHAR                 LABEL 'CONCEPTO'        FORMAT 'x(40)'
    FIELD FmaPgo    AS CHAR                 LABEL 'FORMA DE PAGO'   FORMAT 'x(30)'
    FIELD Usuario   LIKE ccbccaja.usuario   LABEL 'CAJERO'
    FIELD FchCie    LIKE ccbccaja.fchcie    LABEL 'FECHA CIERRE'
    FIELD HorCie    LIKE ccbccaja.horcie    LABEL 'HORA CIERRE'
    FIELD ImpNac    AS DEC                  LABEL 'IMPORTE S/.'     FORMAT '->>>,>>>,>>9.99'
    FIELD ImpUsa    AS DEC                  LABEL 'IMPORTE US$'     FORMAT '->>>,>>>,>>9.99'
    FIELD TpoCmb    LIKE ccbccaja.tpocmb    LABEL 'TC'
    .

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
&Scoped-define INTERNAL-TABLES GN-DIVI CcbCCaja CcbCierr

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 GN-DIVI.CodDiv GN-DIVI.DesDiv 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH GN-DIVI ~
      WHERE GN-DIVI.CodCia = s-codcia NO-LOCK, ~
      FIRST CcbCCaja OF GN-DIVI ~
      WHERE LOOKUP(CcbCCaja.CodDoc, 'I/C,E/C') > 0 ~
 AND CcbCCaja.FlgCie = "C" ~
 AND CcbCCaja.FchCie >= FILL-IN-FchCie-1 ~
 AND CcbCCaja.FchCie <= FILL-IN-FchCie-2 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH GN-DIVI ~
      WHERE GN-DIVI.CodCia = s-codcia NO-LOCK, ~
      FIRST CcbCCaja OF GN-DIVI ~
      WHERE LOOKUP(CcbCCaja.CodDoc, 'I/C,E/C') > 0 ~
 AND CcbCCaja.FlgCie = "C" ~
 AND CcbCCaja.FchCie >= FILL-IN-FchCie-1 ~
 AND CcbCCaja.FchCie <= FILL-IN-FchCie-2 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 GN-DIVI CcbCCaja
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 GN-DIVI
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 CcbCCaja


/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 CcbCierr.FchCie CcbCierr.usuario ~
CcbCierr.HorCie 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH CcbCierr ~
      WHERE CcbCierr.CodCia = s-codcia ~
 AND CcbCierr.FchCie >= FILL-IN-FchCie-1 ~
 AND CcbCierr.FchCie <= FILL-IN-FchCie-2 NO-LOCK ~
    BY CcbCierr.FchCie ~
       BY CcbCierr.HorCie INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH CcbCierr ~
      WHERE CcbCierr.CodCia = s-codcia ~
 AND CcbCierr.FchCie >= FILL-IN-FchCie-1 ~
 AND CcbCierr.FchCie <= FILL-IN-FchCie-2 NO-LOCK ~
    BY CcbCierr.FchCie ~
       BY CcbCierr.HorCie INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 CcbCierr
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 CcbCierr


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-BROWSE-2}~
    ~{&OPEN-QUERY-BROWSE-3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-FchCie-1 FILL-IN-FchCie-2 BROWSE-2 ~
BROWSE-3 BUTTON-1 BtnDone 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-FchCie-1 FILL-IN-FchCie-2 

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
     SIZE 7 BY 1.73
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 1" 
     SIZE 8 BY 1.73.

DEFINE VARIABLE FILL-IN-FchCie-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Cerrados desde el" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchCie-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "hasta el" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      GN-DIVI, 
      CcbCCaja SCROLLING.

DEFINE QUERY BROWSE-3 FOR 
      CcbCierr SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 wWin _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      GN-DIVI.CodDiv COLUMN-LABEL "División" FORMAT "x(5)":U
      GN-DIVI.DesDiv COLUMN-LABEL "Descripción" FORMAT "X(40)":U
            WIDTH 38.29
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 49 BY 12.69
         FONT 4
         TITLE "SELECCIONE UNA O VARIAS DIVISIONES" FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 wWin _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      CcbCierr.FchCie COLUMN-LABEL "Fecha de Cierre" FORMAT "99/99/9999":U
      CcbCierr.usuario COLUMN-LABEL "Cajero" FORMAT "x(10)":U
      CcbCierr.HorCie COLUMN-LABEL "Hora de Cierre" FORMAT "x(5)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 43 BY 12.69
         FONT 4
         TITLE "SELECCIONE UNO O MAS CAJEROS" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     FILL-IN-FchCie-1 AT ROW 1.96 COL 14 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-FchCie-2 AT ROW 1.96 COL 33 COLON-ALIGNED WIDGET-ID 4
     BROWSE-2 AT ROW 3.12 COL 3 WIDGET-ID 200
     BROWSE-3 AT ROW 3.12 COL 53 WIDGET-ID 400
     BUTTON-1 AT ROW 1.19 COL 79 WIDGET-ID 6
     BtnDone AT ROW 1.19 COL 87 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 96.43 BY 15.85
         FONT 4 WIDGET-ID 100.


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
         TITLE              = "CONTROL DE CIERRES DE CAJA"
         HEIGHT             = 15.85
         WIDTH              = 96.43
         MAX-HEIGHT         = 28.81
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 28.81
         VIRTUAL-WIDTH      = 146.29
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
/* BROWSE-TAB BROWSE-2 FILL-IN-FchCie-2 fMain */
/* BROWSE-TAB BROWSE-3 BROWSE-2 fMain */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.GN-DIVI,INTEGRAL.CcbCCaja OF INTEGRAL.GN-DIVI"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST"
     _Where[1]         = "GN-DIVI.CodCia = s-codcia"
     _Where[2]         = "LOOKUP(CcbCCaja.CodDoc, 'I/C,E/C') > 0
 AND CcbCCaja.FlgCie = ""C""
 AND CcbCCaja.FchCie >= FILL-IN-FchCie-1
 AND CcbCCaja.FchCie <= FILL-IN-FchCie-2"
     _FldNameList[1]   > INTEGRAL.GN-DIVI.CodDiv
"GN-DIVI.CodDiv" "División" "x(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.GN-DIVI.DesDiv
"GN-DIVI.DesDiv" "Descripción" ? "character" ? ? ? ? ? ? no ? no no "38.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "INTEGRAL.CcbCierr"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "INTEGRAL.CcbCierr.FchCie|yes,INTEGRAL.CcbCierr.HorCie|yes"
     _Where[1]         = "CcbCierr.CodCia = s-codcia
 AND CcbCierr.FchCie >= FILL-IN-FchCie-1
 AND CcbCierr.FchCie <= FILL-IN-FchCie-2"
     _FldNameList[1]   > INTEGRAL.CcbCierr.FchCie
"CcbCierr.FchCie" "Fecha de Cierre" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.CcbCierr.usuario
"CcbCierr.usuario" "Cajero" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.CcbCierr.HorCie
"CcbCierr.HorCie" "Hora de Cierre" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* CONTROL DE CIERRES DE CAJA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* CONTROL DE CIERRES DE CAJA */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&Scoped-define SELF-NAME BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 wWin
ON VALUE-CHANGED OF BROWSE-2 IN FRAME fMain /* SELECCIONE UNA O VARIAS DIVISIONES */
DO:
  /*RUN Open-Cajeros.*/
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
    DEF VAR pOptions AS CHAR.
    DEF VAR pArchivo AS CHAR.

    RUN lib/tt-file-to-text-01 (OUTPUT pOptions, OUTPUT pArchivo).
    IF pOptions = "" THEN RETURN NO-APPLY.

    SESSION:SET-WAIT-STATE('GENERAL').
    RUN Carga-Temporal.
    SESSION:SET-WAIT-STATE('').

    FIND FIRST Detalle NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Detalle THEN DO:
        MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    /*pOptions = pOptions + CHR(1) + "FieldList:CodDoc,NroDoc,NomCli,Bultos,FchDoc,Chr_02,NomPer,Dte_01,Chr_03,Tiempo".*/

    RUN lib/tt-file (TEMP-TABLE Detalle:HANDLE, pArchivo, pOptions).

    MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.
    RUN Open-Cajeros.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-FchCie-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-FchCie-1 wWin
ON LEAVE OF FILL-IN-FchCie-1 IN FRAME fMain /* Cerrados desde el */
DO:
  ASSIGN {&self-name}.
  RUN Open-Cajeros.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-FchCie-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-FchCie-2 wWin
ON LEAVE OF FILL-IN-FchCie-2 IN FRAME fMain /* hasta el */
DO:
  ASSIGN {&self-name}.
  RUN Open-Cajeros.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal wWin 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR j AS INT NO-UNDO.
DEF VAR k AS INT NO-UNDO.
DEF VAR xConcepto AS CHAR NO-UNDO.

EMPTY TEMP-TABLE Detalle.
DO k = 1 TO BROWSE-3:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
    IF NOT BROWSE-3:FETCH-SELECTED-ROW(k) THEN NEXT.
    DO j = 1 TO BROWSE-2:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
        IF NOT BROWSE-2:FETCH-SELECTED-ROW(j) THEN NEXT.
        FOR EACH ccbccaja WHERE ccbccaja.codcia = s-codcia AND
            ccbccaja.coddiv = gn-divi.coddiv AND
            ccbccaja.coddoc = "I/C" AND
            ccbccaja.usuario = Ccbcierr.usuario AND
            ccbccaja.flgcie = "C" AND
            ccbccaja.fchcie = Ccbcierr.fchcie AND
            ccbccaja.horcie = Ccbcierr.horcie AND
            ccbccaja.flgest NE "A"
            NO-LOCK:
            CASE ccbccaja.tipo:
                WHEN "SENCILLO"     THEN xConcepto = "FONDO DE CAJA".
                WHEN "ANTREC"       THEN xConcepto = "ANTICIPOS".
                WHEN "CANCELACION"  THEN xConcepto = "CANCELACIONES".
                WHEN "MOSTRADOR"    THEN xConcepto = "MOSTRADOR".
                OTHERWISE xConcepto = "OTROS".
            END CASE.
            RUN Carga-Temporal-Detalle ( "INGRESOS",
                                         xConcepto,
                                         "EFECTIVO",
                                         ccbccaja.usuario,
                                         ccbccaja.fchcie,
                                         ccbccaja.horcie,
                                         Ccbccaja.ImpNac[1] - CcbCCaja.VueNac,
                                         Ccbccaja.ImpUsa[1] - CcbCCaja.VueUsa,
                                         CcbCCaja.TpoCmb,
                                         gn-divi.coddiv + ' ' + gn-divi.desdiv).
            RUN Carga-Temporal-Detalle ( "INGRESOS",
                                         xConcepto,
                                         "CHEQUES DEL DIA",
                                         ccbccaja.usuario,
                                         ccbccaja.fchcie,
                                         ccbccaja.horcie,
                                         Ccbccaja.ImpNac[2],
                                         Ccbccaja.ImpUsa[2],
                                         CcbCCaja.TpoCmb,
                                         gn-divi.coddiv + ' ' + gn-divi.desdiv).
            RUN Carga-Temporal-Detalle ( "INGRESOS",
                                         xConcepto,
                                         "CHEQUES DIFERIDOS",
                                         ccbccaja.usuario,
                                         ccbccaja.fchcie,
                                         ccbccaja.horcie,
                                         Ccbccaja.ImpNac[3],
                                         Ccbccaja.ImpUsa[3],
                                         CcbCCaja.TpoCmb,
                                         gn-divi.coddiv + ' ' + gn-divi.desdiv).
            RUN Carga-Temporal-Detalle ( "INGRESOS",
                                         xConcepto,
                                         "TARJETAS DE CREDITO",
                                         ccbccaja.usuario,
                                         ccbccaja.fchcie,
                                         ccbccaja.horcie,
                                         Ccbccaja.ImpNac[4],
                                         Ccbccaja.ImpUsa[4],
                                         CcbCCaja.TpoCmb,
                                         gn-divi.coddiv + ' ' + gn-divi.desdiv).
            RUN Carga-Temporal-Detalle ( "INGRESOS",
                                         xConcepto,
                                         "BOLETAS DE DEPOSITO",
                                         ccbccaja.usuario,
                                         ccbccaja.fchcie,
                                         ccbccaja.horcie,
                                         Ccbccaja.ImpNac[5],
                                         Ccbccaja.ImpUsa[5],
                                         CcbCCaja.TpoCmb,
                                         gn-divi.coddiv + ' ' + gn-divi.desdiv).
            RUN Carga-Temporal-Detalle ( "INGRESOS",
                                         xConcepto,
                                         "NOTAS DE CREDITO",
                                         ccbccaja.usuario,
                                         ccbccaja.fchcie,
                                         ccbccaja.horcie,
                                         Ccbccaja.ImpNac[6],
                                         Ccbccaja.ImpUsa[6],
                                         CcbCCaja.TpoCmb,
                                         gn-divi.coddiv + ' ' + gn-divi.desdiv).
            RUN Carga-Temporal-Detalle ( "INGRESOS",
                                         xConcepto,
                                         "ANTICIPOS",
                                         ccbccaja.usuario,
                                         ccbccaja.fchcie,
                                         ccbccaja.horcie,
                                         Ccbccaja.ImpNac[7],
                                         Ccbccaja.ImpUsa[7],
                                         CcbCCaja.TpoCmb,
                                         gn-divi.coddiv + ' ' + gn-divi.desdiv).
            RUN Carga-Temporal-Detalle ( "INGRESOS",
                                         xConcepto,
                                         "COMISION FACTORING",
                                         ccbccaja.usuario,
                                         ccbccaja.fchcie,
                                         ccbccaja.horcie,
                                         Ccbccaja.ImpNac[8],
                                         Ccbccaja.ImpUsa[8],
                                         CcbCCaja.TpoCmb,
                                         gn-divi.coddiv + ' ' + gn-divi.desdiv).
            RUN Carga-Temporal-Detalle ( "INGRESOS",
                                         xConcepto,
                                         "RETENCIONES",
                                         ccbccaja.usuario,
                                         ccbccaja.fchcie,
                                         ccbccaja.horcie,
                                         Ccbccaja.ImpNac[9],
                                         Ccbccaja.ImpUsa[9],
                                         CcbCCaja.TpoCmb,
                                         gn-divi.coddiv + ' ' + gn-divi.desdiv).
            RUN Carga-Temporal-Detalle ( "INGRESOS",
                                         xConcepto,
                                         "VALES DE CONSUMO",
                                         ccbccaja.usuario,
                                         ccbccaja.fchcie,
                                         ccbccaja.horcie,
                                         Ccbccaja.ImpNac[10],
                                         Ccbccaja.ImpUsa[10],
                                         CcbCCaja.TpoCmb,
                                         gn-divi.coddiv + ' ' + gn-divi.desdiv).
        END.
    END.
    DO j = 1 TO BROWSE-2:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
        IF NOT BROWSE-2:FETCH-SELECTED-ROW(j) THEN NEXT.
        FOR EACH ccbccaja WHERE ccbccaja.codcia = s-codcia AND
            ccbccaja.coddiv = gn-divi.coddiv AND
            ccbccaja.coddoc = "E/C" AND
            ccbccaja.usuario = Ccbcierr.usuario AND
            ccbccaja.flgcie = "C" AND
            ccbccaja.fchcie = Ccbcierr.fchcie AND
            ccbccaja.horcie = Ccbcierr.horcie AND
            ccbccaja.flgest NE "A" 
            NO-LOCK:
            CASE ccbccaja.tipo:
                WHEN "REMEBOV"      THEN xConcepto = "REMESA A BOVEDA".
                WHEN "REMECJC"      THEN xConcepto = "REMESA A CAJA CENTRAL".
                WHEN "ANTREC"       THEN xConcepto = "DEVOLUCION EFECTIVO (ANTICIPO)".
                WHEN "DEVONC"       THEN xConcepto = "DEVOLUCIÓN EFECTIVO (N/C)".
                WHEN "SENCILLO"     THEN xConcepto = "SENCILLO".
                OTHERWISE xConcepto = "OTROS".
            END CASE.
            RUN Carga-Temporal-Detalle ( "EGRESOS",
                                         xConcepto,
                                         "EFECTIVO",
                                         ccbccaja.usuario,
                                         ccbccaja.fchcie,
                                         ccbccaja.horcie,
                                         (Ccbccaja.ImpNac[1] - CcbCCaja.VueNac) * -1,
                                         (Ccbccaja.ImpUsa[1] - CcbCCaja.VueUsa) * -1,
                                         CcbCCaja.TpoCmb,
                                         gn-divi.coddiv + ' ' + gn-divi.desdiv).
        END.
    END.
END.


END PROCEDURE.

/* ***************************** */
PROCEDURE Carga-Temporal-Detalle:
/* ***************************** */

    DEF INPUT PARAMETER pTipo AS CHAR.
    DEF INPUT PARAMETER pConcepto AS CHAR.
    DEF INPUT PARAMETER pFmaPgo AS CHAR.
    DEF INPUT PARAMETER pUsuario AS CHAR.
    DEF INPUT PARAMETER pFchCie AS DATE.
    DEF INPUT PARAMETER pHorCie AS CHAR.
    DEF INPUT PARAMETER pImpNac AS DEC.
    DEF INPUT PARAMETER pImpUsa AS DEC.
    DEF INPUT PARAMETER pTpoCmb AS DEC.
    DEF INPUT PARAMETER pDivision AS CHAR.

    IF pImpNac <> 0 OR pImpUsa <> 0 THEN DO:
        CREATE Detalle.
        ASSIGN
            Detalle.Tipo = pTipo
            Detalle.Concepto = pConcepto
            Detalle.FmaPgo   = pFmaPgo
            Detalle.Usuario = pUsuario
            Detalle.FchCie  = pFchCie
            Detalle.HorCie = pHorCie
            Detalle.ImpNac = pImpNac
            Detalle.ImpUsa = pImpUsa
            Detalle.TpoCmb = pTpoCmb
            Detalle.Division = pDivision.
        /* EN CASO DE INGRESOS DUPLICAS LOS REGISTROS CON SIGNO CONTRARIO */
        IF pTipo = "INGRESOS" AND pConcepto = "CANCELACIONES" THEN DO:
            CREATE Detalle.
            ASSIGN
                Detalle.Tipo = pTipo
                Detalle.Concepto = pConcepto
                Detalle.FmaPgo   = pFmaPgo
                Detalle.Usuario = pUsuario
                Detalle.FchCie  = pFchCie
                Detalle.HorCie = pHorCie
                Detalle.ImpNac = -1 * pImpNac
                Detalle.ImpUsa = -1 * pImpUsa
                Detalle.TpoCmb = pTpoCmb
                Detalle.Division = pDivision.
        END.
    END.

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
  DISPLAY FILL-IN-FchCie-1 FILL-IN-FchCie-2 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE FILL-IN-FchCie-1 FILL-IN-FchCie-2 BROWSE-2 BROWSE-3 BUTTON-1 BtnDone 
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

RUN Carga-Temporal.
IF NOT CAN-FIND(FIRST Detalle) THEN DO:
    MESSAGE 'Fin de archivo' VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.

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
      FILL-IN-FchCie-1 = TODAY - 1 
      FILL-IN-FchCie-2 = TODAY - 1.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Open-Cajeros wWin 
PROCEDURE Open-Cajeros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* pDivisiones = "".                                                                             */
/*                                                                                               */
/* DEF VAR k AS INT NO-UNDO.                                                                     */
/*                                                                                               */
/* DO k = 1 TO browse-2:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:                                */
/*     IF browse-2:FETCH-SELECTED-ROW(k) THEN DO:                                                */
/*         pDivisiones = pDivisiones + (IF pDivisiones = '' THEN '' ELSE ',' ) + GN-DIVI.CodDiv. */
/*     END.                                                                                      */
/* END.               */
{&OPEN-QUERY-BROWSE-2}                                                                           
{&OPEN-QUERY-BROWSE-3}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

