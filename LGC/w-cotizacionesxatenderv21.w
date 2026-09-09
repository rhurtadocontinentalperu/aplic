&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER b-gn-divi FOR GN-DIVI.
DEFINE TEMP-TABLE BONIFICACION LIKE FacDPedi.
DEFINE TEMP-TABLE ITEM LIKE FacDPedi.
DEFINE TEMP-TABLE tt-w-report NO-UNDO LIKE w-report.



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
DEFINE SHARED VAR cl-codcia AS INT.
DEFINE VAR lFechaTope AS DATE.
DEFINE VAR lFechaActual AS DATE.
DEFINE VAR lDivisiones AS CHAR.
DEFINE VAR lTotCotizaciones AS DEC.

DEFINE TEMP-TABLE tt-cot-dtl
        FIELDS tt-divi AS CHAR
        FIELDS tt-nrocot AS CHAR
        FIELDS tt-codmat AS CHAR
        FIELDS tt-cant AS DEC       
        FIELDS tt-item AS INT INIT 0
        FIELDS tt-caso AS CHAR INIT ""
        FIELDS tt-puni AS DEC INIT 0
        FIELDS tt-plista AS CHAR INIT ""
        FIELDS tt-nomclie AS CHAR INIT ""
        FIELDS tt-pdd AS CHAR INIT ""
        FIELDS tt-vend AS CHAR INIT ""
        FIELDS tt-origen AS CHAR INIT ""
        INDEX idx01 IS PRIMARY tt-divi tt-nrocot tt-codmat.

DEFINE TEMP-TABLE tt-cot-hdr
        FIELDS tt-divi AS CHAR
        FIELD tt-nrocot AS CHAR
        FIELDS tt-alm AS CHAR
        FIELDS tt-ubigeo AS CHAR
        FIELDS tt-dubigeo AS CHAR
        FIELD tt-peso AS DEC INIT 0
        FIELD tt-peso-tot AS DEC INIT 0
        FIELD tt-fchped LIKE faccpedi.fchped
        FIELD tt-fchven LIKE faccpedi.fchven
        FIELD tt-fchent LIKE faccpedi.fchent
        FIELD tt-nomcli LIKE faccpedi.nomcli
        FIELD tt-impvta LIKE faccpedi.impvta
        FIELD tt-impigv LIKE faccpedi.impigv
        FIELD tt-imptot LIKE faccpedi.imptot
        FIELD tt-flgest LIKE faccpedi.flgest
        FIELD tt-avance AS DEC FORMAT '>>,>>9.99'
        FIELD tt-ptodsp AS CHAR FORMAT 'x(30)'
        FIELD tt-expocot AS CHAR FORMAT 'x(2)'
        FIELD tt-almacenes AS CHAR FORMAT 'x(10)'
        FIELD tt-es-caso AS CHAR FORMAT 'x(1)' INIT ""
        FIELD tt-listaprecio AS CHAR FORMAT 'x(10)'

        INDEX idx01 IS PRIMARY tt-divi tt-nrocot.
        
DEFINE TEMP-TABLE tt-cot-final
        FIELDS tt-alm AS CHAR
        FIELD tt-codmat AS CHAR
        FIELD tt-desmat AS CHAR
        FIELD tt-cant AS DEC
        FIELDS tt-msg AS CHAR
        FIELDS tt-xatender AS DEC
        FIELDS tt-StkAlm AS DEC
        FIELDS tt-reserva AS DEC
        FIELDS tt-xrecep AS DEC
        FIELDS tt-inner AS DEC

        INDEX idx01 IS PRIMARY tt-alm tt-codmat.

DEFINE TEMP-TABLE tmp-tabla
    FIELD t-CodAlm LIKE Almacen.codalm  FORMAT 'x(3)'
    FIELD t-CodDoc LIKE FacDPedi.CodDoc FORMAT "XXX"
    FIELD t-Nroped LIKE FacDPedi.NroPed FORMAT "XXX-XXXXXXXX"
    FIELD t-CodDiv LIKE FacCPedi.CodDiv FORMAT 'x(5)'
    FIELD t-FchPed LIKE FacDPedi.FchPed
    FIELD t-NomCli LIKE FacCPedi.NomCli COLUMN-LABEL "Cliente" FORMAT "x(35)"
    FIELD t-CodMat LIKE FacDPedi.codmat
    FIELD t-Canped LIKE FacDPedi.CanPed.

DEFINE TEMP-TABLE tt-facdpedi LIKE facdpedi FIELD origen AS CHAR INIT "".
DEFINE TEMP-TABLE tt-faccpedi LIKE faccpedi.

DEFINE VAR lUbigeo AS CHAR.
DEFINE VAR lUbigeoX AS CHAR.
DEFINE VAR lDUbigeo AS CHAR.

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
&Scoped-define INTERNAL-TABLES tt-w-report

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 tt-w-report.Campo-C[1] ~
tt-w-report.Campo-C[2] tt-w-report.Campo-C[3] tt-w-report.Campo-C[4] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH tt-w-report NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH tt-w-report NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 tt-w-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 tt-w-report


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 txtDesde txtHasta txtFechaTope ~
txtAlmOtros BROWSE-2 Alm01 Tonelaje01 Alm01b Alm02 Tonelaje02 Alm02b Alm03 ~
Tonelaje03 Alm03b Alm04 txtDivisiones txtListaPrecio ChbxGrabaCot ~
chbDetalleCot TOGGLE-Bonificaciones nbtnProcesar rdBtnCual 
&Scoped-Define DISPLAYED-OBJECTS txtUltFechaTope txtDesde txtHasta ~
txtFechaTope txtCaso txtAlmOtros CodFami01 Alm01 Tonelaje01 Alm01b ~
CodFami02 Alm02 Tonelaje02 Alm02b CodFami03 Alm03 Tonelaje03 Alm03b ~
CodFami04 Alm04 Tonelaje04 Alm04b txtDivisiones txtListaPrecio txtMsg ~
ChbxGrabaCot chbDetalleCot TOGGLE-Bonificaciones rdBtnCual 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON nbtnProcesar 
     LABEL "Procesar" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE Alm01 AS CHARACTER FORMAT "X(3)":U INITIAL "11E" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .96 NO-UNDO.

DEFINE VARIABLE Alm01b AS CHARACTER FORMAT "X(3)":U INITIAL "11E" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .96 NO-UNDO.

DEFINE VARIABLE Alm02 AS CHARACTER FORMAT "X(3)":U INITIAL "11E" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .96 NO-UNDO.

DEFINE VARIABLE Alm02b AS CHARACTER FORMAT "X(3)":U INITIAL "11E" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .96 NO-UNDO.

DEFINE VARIABLE Alm03 AS CHARACTER FORMAT "X(3)":U INITIAL "11E" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .96 NO-UNDO.

DEFINE VARIABLE Alm03b AS CHARACTER FORMAT "X(3)":U INITIAL "11E" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .96 NO-UNDO.

DEFINE VARIABLE Alm04 AS CHARACTER FORMAT "X(3)":U INITIAL "11E" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .96 NO-UNDO.

DEFINE VARIABLE Alm04b AS CHARACTER FORMAT "X(3)":U INITIAL "11E" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .96 NO-UNDO.

DEFINE VARIABLE CodFami01 AS CHARACTER FORMAT "X(3)":U INITIAL "A" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .96
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE CodFami02 AS CHARACTER FORMAT "X(3)":U INITIAL "B" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .96
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE CodFami03 AS CHARACTER FORMAT "X(3)":U INITIAL "C" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .96
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE CodFami04 AS CHARACTER FORMAT "X(3)":U INITIAL "D" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .96
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE Tonelaje01 AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 7.72 BY .96 NO-UNDO.

DEFINE VARIABLE Tonelaje02 AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 7.72 BY .96 NO-UNDO.

DEFINE VARIABLE Tonelaje03 AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 7.72 BY .96 NO-UNDO.

DEFINE VARIABLE Tonelaje04 AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 7.72 BY .96 NO-UNDO.

DEFINE VARIABLE txtAlmOtros AS CHARACTER FORMAT "X(5)":U INITIAL "11e" 
     LABEL "Las Cotizaciones sin Punto de Salida deben ser atendidos del" 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE txtCaso AS CHARACTER FORMAT "X(5)":U INITIAL " A" 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 7.86 BY 1.96
     BGCOLOR 15 FGCOLOR 9 FONT 8 NO-UNDO.

DEFINE VARIABLE txtDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtDivisiones AS CHARACTER FORMAT "X(256)":U INITIAL "00015,00018,10060" 
     VIEW-AS FILL-IN 
     SIZE 64.14 BY 1 NO-UNDO.

DEFINE VARIABLE txtFechaTope AS DATE FORMAT "99/99/9999":U 
     LABEL "Fechas de entrega sea menor/igual a" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtListaPrecio AS CHARACTER FORMAT "X(256)":U INITIAL "00015,20015,20060" 
     VIEW-AS FILL-IN 
     SIZE 64.14 BY 1 NO-UNDO.

DEFINE VARIABLE txtMsg AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 49 BY 1 NO-UNDO.

DEFINE VARIABLE txtUltFechaTope AS CHARACTER FORMAT "X(15)":U 
     LABEL "Ultima fecha tope" 
     VIEW-AS FILL-IN 
     SIZE 18 BY 1
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE rdBtnCual AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Faltantes", 1,
"Excedentes", 2
     SIZE 29 BY .77 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 31 BY 5
     BGCOLOR 14 .

DEFINE VARIABLE chbDetalleCot AS LOGICAL INITIAL no 
     LABEL "Generar el Excel con detalle de las cotizaciones" 
     VIEW-AS TOGGLE-BOX
     SIZE 44 BY .77 NO-UNDO.

DEFINE VARIABLE ChbxGrabaCot AS LOGICAL INITIAL no 
     LABEL "Marcar las cotizacion como PROCESADAS y grabar fecha TOPE" 
     VIEW-AS TOGGLE-BOX
     SIZE 60.14 BY .77
     FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE TOGGLE-Bonificaciones AS LOGICAL INITIAL no 
     LABEL "Incluir Bonificaciones" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .77
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      tt-w-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 wWin _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      tt-w-report.Campo-C[1] COLUMN-LABEL "Fam." FORMAT "X(3)":U
            WIDTH 4
      tt-w-report.Campo-C[2] COLUMN-LABEL "Nombre Familia" FORMAT "X(40)":U
            WIDTH 23.43
      tt-w-report.Campo-C[3] COLUMN-LABEL "SubFam" FORMAT "X(3)":U
            WIDTH 7.43
      tt-w-report.Campo-C[4] COLUMN-LABEL "Nombre de Sub Familia" FORMAT "X(40)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 65.57 BY 4.96 ROW-HEIGHT-CHARS .5 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     txtUltFechaTope AT ROW 1.38 COL 76 COLON-ALIGNED WIDGET-ID 94
     txtDesde AT ROW 2.12 COL 13.57 COLON-ALIGNED WIDGET-ID 2
     txtHasta AT ROW 2.12 COL 35 COLON-ALIGNED WIDGET-ID 12
     txtFechaTope AT ROW 3.31 COL 36 COLON-ALIGNED WIDGET-ID 14
     txtCaso AT ROW 3.73 COL 88 COLON-ALIGNED WIDGET-ID 92
     txtAlmOtros AT ROW 4.5 COL 71.29 COLON-ALIGNED WIDGET-ID 18
     BROWSE-2 AT ROW 5.81 COL 34.14 WIDGET-ID 200
     CodFami01 AT ROW 6.77 COL 2.43 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     Alm01 AT ROW 6.77 COL 8.43 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     Tonelaje01 AT ROW 6.77 COL 15.43 COLON-ALIGNED NO-LABEL WIDGET-ID 48
     Alm01b AT ROW 6.77 COL 25.29 COLON-ALIGNED NO-LABEL WIDGET-ID 52
     CodFami02 AT ROW 7.62 COL 2.43 COLON-ALIGNED NO-LABEL WIDGET-ID 60
     Alm02 AT ROW 7.62 COL 8.43 COLON-ALIGNED NO-LABEL WIDGET-ID 56
     Tonelaje02 AT ROW 7.62 COL 15.43 COLON-ALIGNED NO-LABEL WIDGET-ID 64
     Alm02b AT ROW 7.62 COL 25.29 COLON-ALIGNED NO-LABEL WIDGET-ID 58
     CodFami03 AT ROW 8.5 COL 2.43 COLON-ALIGNED NO-LABEL WIDGET-ID 70
     Alm03 AT ROW 8.5 COL 8.43 COLON-ALIGNED NO-LABEL WIDGET-ID 66
     Tonelaje03 AT ROW 8.5 COL 15.43 COLON-ALIGNED NO-LABEL WIDGET-ID 74
     Alm03b AT ROW 8.5 COL 25.29 COLON-ALIGNED NO-LABEL WIDGET-ID 68
     CodFami04 AT ROW 9.38 COL 2.43 COLON-ALIGNED NO-LABEL WIDGET-ID 80
     Alm04 AT ROW 9.38 COL 8.43 COLON-ALIGNED NO-LABEL WIDGET-ID 76
     Tonelaje04 AT ROW 9.38 COL 15.43 COLON-ALIGNED NO-LABEL WIDGET-ID 84
     Alm04b AT ROW 9.38 COL 25.29 COLON-ALIGNED NO-LABEL WIDGET-ID 78
     txtDivisiones AT ROW 12.35 COL 4 NO-LABEL WIDGET-ID 8
     txtListaPrecio AT ROW 14.5 COL 4 NO-LABEL WIDGET-ID 20
     txtMsg AT ROW 15.77 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     ChbxGrabaCot AT ROW 17.12 COL 4 WIDGET-ID 32
     chbDetalleCot AT ROW 17.92 COL 4 WIDGET-ID 36
     TOGGLE-Bonificaciones AT ROW 17.96 COL 52 WIDGET-ID 96
     nbtnProcesar AT ROW 19.23 COL 57 WIDGET-ID 4
     rdBtnCual AT ROW 19.42 COL 22 NO-LABEL WIDGET-ID 26
     "ALM 2" VIEW-AS TEXT
          SIZE 6.29 BY .62 AT ROW 6.12 COL 26.72 WIDGET-ID 54
          BGCOLOR 7 FGCOLOR 15 FONT 6
     "Canal Moderno (00017) va ir x el 21e" VIEW-AS TEXT
          SIZE 34 BY .77 AT ROW 11.42 COL 36.57 WIDGET-ID 24
          FGCOLOR 1 
     "Considerar todas las cotizaciones cuya fecha de emision sea" VIEW-AS TEXT
          SIZE 53.72 BY .62 AT ROW 1.35 COL 4.72 WIDGET-ID 30
          FGCOLOR 4 
     "Fecha TOPE" VIEW-AS TEXT
          SIZE 17.57 BY .96 AT ROW 3.31 COL 52.43 WIDGET-ID 34
          FGCOLOR 9 FONT 11
     "CASO" VIEW-AS TEXT
          SIZE 5.57 BY .62 AT ROW 6.12 COL 4.14 WIDGET-ID 38
          BGCOLOR 7 FGCOLOR 15 FONT 6
     "Divisiones a considerar" VIEW-AS TEXT
          SIZE 28.57 BY .88 AT ROW 11.38 COL 4.14 WIDGET-ID 10
          FGCOLOR 4 FONT 9
     "Con estas LISTA de PRECIOS" VIEW-AS TEXT
          SIZE 43.57 BY .81 AT ROW 13.65 COL 4.14 WIDGET-ID 22
          FGCOLOR 9 FONT 9
     " A L M" VIEW-AS TEXT
          SIZE 6 BY .62 AT ROW 6.12 COL 10 WIDGET-ID 46
          BGCOLOR 7 FGCOLOR 15 FONT 6
     " TONELAJE" VIEW-AS TEXT
          SIZE 10.14 BY .62 AT ROW 6.12 COL 16.29 WIDGET-ID 50
          BGCOLOR 7 FGCOLOR 15 FONT 6
     RECT-1 AT ROW 5.81 COL 3 WIDGET-ID 86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 99.43 BY 19.62 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE APPSERVER
   Temp-Tables and Buffers:
      TABLE: b-gn-divi B "?" ? INTEGRAL GN-DIVI
      TABLE: BONIFICACION T "?" ? INTEGRAL FacDPedi
      TABLE: ITEM T "?" ? INTEGRAL FacDPedi
      TABLE: tt-w-report T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "Cotizaciones por Atender"
         HEIGHT             = 19.62
         WIDTH              = 99.43
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
   FRAME-NAME L-To-R                                                    */
/* BROWSE-TAB BROWSE-2 txtAlmOtros fMain */
/* SETTINGS FOR FILL-IN Alm04b IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CodFami01 IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CodFami02 IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CodFami03 IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CodFami04 IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Tonelaje04 IN FRAME fMain
   NO-ENABLE                                                            */
ASSIGN 
       txtAlmOtros:HIDDEN IN FRAME fMain           = TRUE.

/* SETTINGS FOR FILL-IN txtCaso IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtDivisiones IN FRAME fMain
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN txtListaPrecio IN FRAME fMain
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN txtMsg IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtUltFechaTope IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.tt-w-report"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-w-report.Campo-C[1]
"tt-w-report.Campo-C[1]" "Fam." "X(3)" "character" ? ? ? ? ? ? no ? no no "4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-w-report.Campo-C[2]
"tt-w-report.Campo-C[2]" "Nombre Familia" "X(40)" "character" ? ? ? ? ? ? no ? no no "23.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-w-report.Campo-C[3]
"tt-w-report.Campo-C[3]" "SubFam" "X(3)" "character" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-w-report.Campo-C[4]
"tt-w-report.Campo-C[4]" "Nombre de Sub Familia" "X(40)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* Cotizaciones por Atender */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Cotizaciones por Atender */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Alm01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Alm01 wWin
ON ENTRY OF Alm01 IN FRAME fMain
DO:
  RUN cargar-caso(INPUT "A").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Alm01b
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Alm01b wWin
ON ENTRY OF Alm01b IN FRAME fMain
DO:
  RUN cargar-caso(INPUT "A").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Alm02
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Alm02 wWin
ON ENTRY OF Alm02 IN FRAME fMain
DO:
  RUN cargar-caso(INPUT "B").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Alm02b
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Alm02b wWin
ON ENTRY OF Alm02b IN FRAME fMain
DO:
  RUN cargar-caso(INPUT "B").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Alm03
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Alm03 wWin
ON ENTRY OF Alm03 IN FRAME fMain
DO:
  RUN cargar-caso(INPUT "C").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Alm03b
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Alm03b wWin
ON ENTRY OF Alm03b IN FRAME fMain
DO:
  RUN cargar-caso(INPUT "C").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Alm04
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Alm04 wWin
ON ENTRY OF Alm04 IN FRAME fMain
DO:
  RUN cargar-caso(INPUT "D").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Alm04b
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Alm04b wWin
ON ENTRY OF Alm04b IN FRAME fMain
DO:
  RUN cargar-caso(INPUT "D").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME nbtnProcesar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL nbtnProcesar wWin
ON CHOOSE OF nbtnProcesar IN FRAME fMain /* Procesar */
DO:
  ASSIGN txtDesde txthasta txtDivisiones txtFechaTope /*txtAlmPesoMaximo */
      txtAlmOtros txtListaPrecio rdBtnCual ChbxGrabaCot ChbDetalleCot
      CodFami01 Alm01 Tonelaje01 Alm01b
      CodFami02 Alm02 Tonelaje02 Alm02b
      CodFami03 Alm03 Tonelaje03 Alm03b
      CodFami04 Alm04 Tonelaje04 Alm04b
      TOGGLE-Bonificaciones
      .

  IF txtDesde > txtHasta THEN DO:
      MESSAGE "Fechas Erradas".
      RETURN NO-APPLY.
  END.
  IF txtDivisiones="" OR txtDivisiones = ? THEN DO:
      MESSAGE "Ingrese alguna Division".
      RETURN NO-APPLY.
  END.
  /*
  IF txtAlmPesoMaximo = "" OR txtAlmPesoMaximo = ?  THEN DO:
      MESSAGE "Ingrese Almacen para Cotizaciones pesadas".
      RETURN NO-APPLY.
  END.
  */
  IF txtAlmOtros = "" OR txtAlmOtros = ? THEN DO:
      MESSAGE "Ingrese Almacen Ubigeos errados".
      RETURN NO-APPLY.
  END.

  IF txtFechaTope < txtDesde THEN DO:
      MESSAGE "Fecha de entrega debe ser mayor/igual a fecha DESDE".
      RETURN NO-APPLY.
  END.

  /*
  FIND FIRST almacen WHERE almacen.codcia = s-codcia AND 
                    almacen.codalm = txtAlmPesoMaximo NO-LOCK NO-ERROR.
  IF NOT AVAILABLE almacen THEN DO:
      MESSAGE "Almacen para Cotizaciones pesadas NO EXISTE".
      RETURN NO-APPLY.
  END.
  */

  FIND FIRST almacen WHERE almacen.codcia = s-codcia AND 
                    almacen.codalm = txtAlmOtros NO-LOCK NO-ERROR.
  IF NOT AVAILABLE almacen THEN DO:
      MESSAGE "Almacen Ubigeos errados NO EXISE".
      RETURN NO-APPLY.
  END.

  /* FAMILIA 010 */
  FIND FIRST almacen WHERE almacen.codcia = s-codcia AND 
                  almacen.codalm = Alm01 NO-LOCK NO-ERROR.
    IF NOT AVAILABLE almacen THEN DO:
        MESSAGE "Almacen para CASO (" + CodFami01 + ") NO EXISTE".
        RETURN NO-APPLY.
    END.
    IF Tonelaje01 < 0 THEN DO:
        MESSAGE "TONELAJE para CASO (" + CodFami01 + ") esta ERRADO".
        RETURN NO-APPLY.
    END.
    FIND FIRST almacen WHERE almacen.codcia = s-codcia AND 
                    almacen.codalm = Alm01b NO-LOCK NO-ERROR.
      IF NOT AVAILABLE almacen THEN DO:
          MESSAGE "Almacen segun TONELAJE para CASO (" + CodFami01 + ") NO EXISTE".
          RETURN NO-APPLY.
      END.
      /* FAMILIA 011 */
      FIND FIRST almacen WHERE almacen.codcia = s-codcia AND 
                      almacen.codalm = Alm02 NO-LOCK NO-ERROR.
        IF NOT AVAILABLE almacen THEN DO:
            MESSAGE "Almacen para CASO (" + CodFami02 + ") NO EXISTE".
            RETURN NO-APPLY.
        END.
        IF Tonelaje02 < 0 THEN DO:
            MESSAGE "TONELAJE para CASO (" + CodFami02 + ") esta ERRADO".
            RETURN NO-APPLY.
        END.
        FIND FIRST almacen WHERE almacen.codcia = s-codcia AND 
                        almacen.codalm = Alm02b NO-LOCK NO-ERROR.
          IF NOT AVAILABLE almacen THEN DO:
              MESSAGE "Almacen segun TONELAJE para CASO (" + CodFami02 + ") NO EXISTE".
              RETURN NO-APPLY.
          END.
          /* FAMILIA 017 */
          FIND FIRST almacen WHERE almacen.codcia = s-codcia AND 
                          almacen.codalm = Alm03 NO-LOCK NO-ERROR.
            IF NOT AVAILABLE almacen THEN DO:
                MESSAGE "Almacen para CASO (" + CodFami03 + ") NO EXISTE".
                RETURN NO-APPLY.
            END.
            IF Tonelaje02 < 0 THEN DO:
                MESSAGE "TONELAJE para CASO (" + CodFami03 + ") esta ERRADO".
                RETURN NO-APPLY.
            END.
            FIND FIRST almacen WHERE almacen.codcia = s-codcia AND 
                            almacen.codalm = Alm03b NO-LOCK NO-ERROR.
              IF NOT AVAILABLE almacen THEN DO:
                  MESSAGE "Almacen segun TONELAJE para CASO (" + CodFami03 + ") NO EXISTE".
                  RETURN NO-APPLY.
              END.
              /* RESTO */
              FIND FIRST almacen WHERE almacen.codcia = s-codcia AND 
                              almacen.codalm = Alm04 NO-LOCK NO-ERROR.
                IF NOT AVAILABLE almacen THEN DO:
                    MESSAGE "Almacen para CASO (" + CodFami04 + ") NO EXISTE".
                    RETURN NO-APPLY.
                END.
                /*
                IF Tonelaje02 < 0 THEN DO:
                    MESSAGE "TONELAJE para " + DesFami04 + " esta ERRADO".
                    RETURN NO-APPLY.
                END.
                FIND FIRST almacen WHERE almacen.codcia = s-codcia AND 
                                almacen.codalm = Alm04b NO-LOCK NO-ERROR.
                  IF NOT AVAILABLE almacen THEN DO:
                      MESSAGE "Almacen segun TONELAJE para " + DesFami03 + " NO EXISTE".
                      RETURN NO-APPLY.
                  END.
                */

  IF chbxGrabaCot = YES THEN DO:
      /**/
      FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND 
                              vtatabla.tabla = 'DSTRB' AND
                              vtatabla.llave_c1 = '2016' 
                              NO-LOCK NO-ERROR.
      IF AVAILABLE vtatabla THEN DO:
          IF txtFechaTope < vtatabla.rango_fecha[2] THEN DO:
              MESSAGE "No puede poner la fecha TOPE menor a la del proceso anterior".
              RETURN NO-APPLY.
          END.
      END.
  END.

  RUN ue-procesar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Tonelaje01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Tonelaje01 wWin
ON ENTRY OF Tonelaje01 IN FRAME fMain
DO:
  RUN cargar-caso(INPUT "A").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Tonelaje02
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Tonelaje02 wWin
ON ENTRY OF Tonelaje02 IN FRAME fMain
DO:
  RUN cargar-caso(INPUT "B").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Tonelaje03
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Tonelaje03 wWin
ON ENTRY OF Tonelaje03 IN FRAME fMain
DO:
  RUN cargar-caso(INPUT "C").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Tonelaje04
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Tonelaje04 wWin
ON ENTRY OF Tonelaje04 IN FRAME fMain
DO:
  RUN cargar-caso(INPUT "D").
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE blaquear-procesadas wWin 
PROCEDURE blaquear-procesadas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE BUFFER ic-faccpedi FOR faccpedi.

FOR EACH faccpedi WHERE faccpedi.codcia = s-codcia AND 
    faccpedi.coddoc = 'COT' AND 
    (faccpedi.fchped  >= txtDesde AND faccpedi.fchped <= lFechaActual ) AND
    faccpedi.fchent > lFechaTope AND /* x encima de la fecha de entrega */
    faccpedi.libre_c02 = 'PROCESADO' AND    /* Solo procesados */
    LOOKUP (faccpedi.coddiv,lDivisiones) > 0 NO-LOCK :

    /* Lista de Precio */
    IF LOOKUP(faccpedi.libre_c01,txtlistaPrecio) = 0  THEN NEXT.

    /* Cotizaciones de Pruebas */
    IF substring(faccpedi.codcli,1,3) = 'SYS' THEN NEXT.  

    /* Solo APROBADO, ATENDIDO, x APROBAR */
    IF faccpedi.flgest <> "P" AND faccpedi.flgest <> "C"  AND faccpedi.flgest <> "E" THEN NEXT .

    /* Blanqueamos */   

    FIND FIRST ic-faccpedi WHERE ic-faccpedi.codcia = s-codcia AND 
                        ic-faccpedi.coddoc = 'COT' AND 
                        ic-faccpedi.nroped = faccpedi.nroped NO-ERROR.
    IF AVAILABLE ic-faccpedi THEN DO:
        ASSIGN ic-faccpedi.libre_c02 = ''.
    END.
END.

RELEASE ic-faccpedi.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-caso wWin 
PROCEDURE cargar-caso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCaso AS CHAR.

EMPTY TEMP-TABLE tt-w-report.

FOR EACH tabgener WHERE tabgener.codcia = s-codcia AND 
                        tabgener.clave = "ALMDSPEVENTOS" AND 
                        tabgener.codigo = pCaso NO-LOCK:
    CREATE tt-w-report.
    ASSIGN tt-w-report.campo-c[1] = tabgener.libre_c01
            tt-w-report.campo-c[2] = "< Familia NO EXISTE >"
            tt-w-report.campo-c[3] = tabgener.libre_c02
            tt-w-report.campo-c[4] = if(tabgener.libre_c02 = "") THEN "< Todas las SubFamilias >" ELSE "< Sub Familia NO EXISTE >".

    FIND FIRST almtfam WHERE almtfam.codcia = s-codcia AND 
                                almtfam.codfam = tabgener.libre_c01
                                NO-LOCK NO-ERROR.
    IF AVAILABLE almtfami THEN tt-w-report.campo-c[2] = almtfami.desfam.

    FIND FIRST almsfam WHERE almsfam.codcia = s-codcia AND 
                                almsfam.codfam = tabgener.libre_c01 AND
                                almsfam.subfam = tabgener.libre_c02
                                NO-LOCK NO-ERROR.
    IF AVAILABLE almsfami THEN tt-w-report.campo-c[4] = almsfami.dessub.
    

END.

{&OPEN-QUERY-BROWSE-2}

txtCaso:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " " + pCaso.

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
  DISPLAY txtUltFechaTope txtDesde txtHasta txtFechaTope txtCaso txtAlmOtros 
          CodFami01 Alm01 Tonelaje01 Alm01b CodFami02 Alm02 Tonelaje02 Alm02b 
          CodFami03 Alm03 Tonelaje03 Alm03b CodFami04 Alm04 Tonelaje04 Alm04b 
          txtDivisiones txtListaPrecio txtMsg ChbxGrabaCot chbDetalleCot 
          TOGGLE-Bonificaciones rdBtnCual 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE RECT-1 txtDesde txtHasta txtFechaTope txtAlmOtros BROWSE-2 Alm01 
         Tonelaje01 Alm01b Alm02 Tonelaje02 Alm02b Alm03 Tonelaje03 Alm03b 
         Alm04 txtDivisiones txtListaPrecio ChbxGrabaCot chbDetalleCot 
         TOGGLE-Bonificaciones nbtnProcesar rdBtnCual 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject wWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  
  txtDesde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "01/07/2017".
  txtHasta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY,"99/99/99999").

  RUN ue-fecha-tope (INPUT TODAY, OUTPUT lFechaTope).

  txtFechaTope:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(lFechaTope,"99/99/99999").
/*
  FIND FIRST almtfam WHERE almtfam.codcia = s-codcia AND
                            almtfam.codfam = CodFami01:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
  IF AVAILABLE almtfam THEN DO:
      Desfami01:SCREEN-VALUE IN FRAME {&FRAME-NAME} = almtfam.desfam.
  END.
  FIND FIRST almtfam WHERE almtfam.codcia = s-codcia AND
                            almtfam.codfam = CodFami02:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
  IF AVAILABLE almtfam THEN DO:
      Desfami02:SCREEN-VALUE IN FRAME {&FRAME-NAME} = almtfam.desfam.
  END.
  FIND FIRST almtfam WHERE almtfam.codcia = s-codcia AND
                            almtfam.codfam = CodFami03:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
  IF AVAILABLE almtfam THEN DO:
      Desfami03:SCREEN-VALUE IN FRAME {&FRAME-NAME} = almtfam.desfam.
  END.
*/
  /* Parametros del Proceso Anterior */
  FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND 
                          vtatabla.tabla = 'DSTRB' AND
                          vtatabla.llave_c1 = '2016' 
                          NO-LOCK NO-ERROR.
  IF AVAILABLE vtatabla THEN DO:
      IF vtatabla.libre_c01 <> ? AND vtatabla.libre_c01 <> ""  THEN DO:
          Alm01:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ENTRY(1,vtatabla.libre_c01,",").
          Alm02:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ENTRY(2,vtatabla.libre_c01,",").
          Alm03:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ENTRY(3,vtatabla.libre_c01,",").
          Alm04:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ENTRY(4,vtatabla.libre_c01,",").
      END.

      IF vtatabla.libre_c02 <> ? AND vtatabla.libre_c02 <> ""  THEN DO:
          Alm01b:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ENTRY(1,vtatabla.libre_c02,",").
          Alm02b:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ENTRY(2,vtatabla.libre_c02,",").
          Alm03b:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ENTRY(3,vtatabla.libre_c02,",").
          Alm04b:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ENTRY(4,vtatabla.libre_c02,",").
      END.
      
      IF vtatabla.llave_c7 <> ? AND vtatabla.llave_c7 <> "" THEN DO:
          txtDivisiones:SCREEN-VALUE IN FRAME {&FRAME-NAME} = vtatabla.llave_c7.
      END.
      IF vtatabla.llave_c8 <> ? AND vtatabla.llave_c8 <> "" THEN DO:
          txtListaPrecio:SCREEN-VALUE IN FRAME {&FRAME-NAME} = vtatabla.llave_c8.
      END.
      
      tonelaje01:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(vtatabla.valor[1],"999,999").
      tonelaje02:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(vtatabla.valor[2],"999,999").
      tonelaje03:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(vtatabla.valor[3],"999,999").
      tonelaje04:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(vtatabla.valor[4],"999,999").

      txtUltFechaTope:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(vtatabla.rango_fecha[2],"99/99/9999").
      
  END.

  RUN cargar-caso(INPUT "A").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE separa-cotizacion wWin 
PROCEDURE separa-cotizacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE tt-faccpedi.
EMPTY TEMP-TABLE tt-facdpedi.

DEFINE VAR x-caso AS CHAR.

DEFINE VAR xPesoCasoA AS DEC INIT 0.
DEFINE VAR xPesoCasoB AS DEC INIT 0.
DEFINE VAR xPesoCasoC AS DEC INIT 0.
DEFINE VAR xPesoCasoD AS DEC INIT 0.

DEFINE VAR xAlmCasoA AS CHAR INIT "".
DEFINE VAR xAlmCasoB AS CHAR INIT "".
DEFINE VAR xAlmCasoC AS CHAR INIT "".
DEFINE VAR xAlmCasoD AS CHAR INIT "".

DEFINE VAR xNroCotxCaso AS CHAR.

DEFINE VAR xEntregar AS DEC.

FOR EACH facdpedi OF faccpedi NO-LOCK, FIRST almmmatg OF facdpedi NO-LOCK :
    x-caso = 'D'.
    /* Buscamos segun FAMILIA y SUBFAMILIA en que CASO encaja */
    FIND FIRST tabgener WHERE tabgener.codcia = s-codcia AND 
                                tabgener.clave = 'ALMDSPEVENTOS' AND 
                                tabgener.libre_c01 = almmmatg.codfam AND 
                                tabgener.libre_C02 = almmmatg.subfam NO-LOCK NO-ERROR.
    IF AVAILABLE tabgener THEN x-caso = tabgener.codigo.
    IF NOT AVAILABLE tabgener THEN DO:
        /* Buscamos segun FAMILIA en que CASO encaja */
        FIND FIRST tabgener WHERE tabgener.codcia = s-codcia AND 
                                    tabgener.clave = 'ALMDSPEVENTOS' AND 
                                    tabgener.libre_c01 = almmmatg.codfam AND 
                                    tabgener.libre_C02 = "" NO-LOCK NO-ERROR.
        IF AVAILABLE tabgener THEN x-caso = tabgener.codigo.
    END.
    x-caso = CAPS(x-caso).
    xEntregar = (facdpedi.canped - facdpedi.canate) * facdpedi.factor.
    xEntregar = IF(xEntregar < 0) THEN 0 ELSE xEntregar.
    /* Peso  */
    xEntregar = xEntregar * IF(almmmatg.pesmat = ? OR almmmatg.pesmat <= 0) THEN 0 ELSE almmmatg.pesmat.
    IF x-caso = 'A' THEN xPesoCasoA = xPesoCasoA + xEntregar.
    IF x-caso = 'B' THEN xPesoCasoB = xPesoCasoB + xEntregar.
    IF x-caso = 'C' THEN xPesoCasoC = xPesoCasoC + xEntregar.
    IF x-caso = 'D' THEN xPesoCasoD = xPesoCasoD + xEntregar.
    xNroCotxCaso = facdpedi.nroped + "-" + x-Caso.
    FIND FIRST tt-faccpedi WHERE tt-faccpedi.nroped = xNroCotxCaso NO-ERROR.
    IF NOT AVAILABLE tt-faccpedi THEN DO:
        CREATE tt-faccpedi.
        BUFFER-COPY faccpedi TO tt-faccpedi.
                ASSIGN tt-faccpedi.nroped = xNroCotxCaso
                    tt-faccpedi.flgest = x-caso.
    END.
    /* -- */
    CREATE tt-facdpedi.
    BUFFER-COPY facdpedi TO tt-facdpedi.
    ASSIGN 
        tt-facdpedi.tipvta = x-Caso
        tt-facdpedi.nroped = xNroCotxCaso.
END.
/* BONIFICACIONES */
FOR EACH BONIFICACION NO-LOCK, FIRST almmmatg OF BONIFICACION NO-LOCK :
    x-caso = 'D'.
    /* Buscamos segun FAMILIA y SUBFAMILIA en que CASO encaja */
    FIND FIRST tabgener WHERE tabgener.codcia = s-codcia AND 
                                tabgener.clave = 'ALMDSPEVENTOS' AND 
                                tabgener.libre_c01 = almmmatg.codfam AND 
                                tabgener.libre_C02 = almmmatg.subfam NO-LOCK NO-ERROR.
    IF AVAILABLE tabgener THEN x-caso = tabgener.codigo.
    IF NOT AVAILABLE tabgener THEN DO:
        /* Buscamos segun FAMILIA en que CASO encaja */
        FIND FIRST tabgener WHERE tabgener.codcia = s-codcia AND 
                                    tabgener.clave = 'ALMDSPEVENTOS' AND 
                                    tabgener.libre_c01 = almmmatg.codfam AND 
                                    tabgener.libre_C02 = "" NO-LOCK NO-ERROR.
        IF AVAILABLE tabgener THEN x-caso = tabgener.codigo.
    END.
    x-caso = CAPS(x-caso).
    xEntregar = (BONIFICACION.canped - BONIFICACION.canate) * BONIFICACION.factor.
    xEntregar = IF(xEntregar < 0) THEN 0 ELSE xEntregar.
    /* Peso  */
    xEntregar = xEntregar * IF(almmmatg.pesmat = ? OR almmmatg.pesmat <= 0) THEN 0 ELSE almmmatg.pesmat.
    IF x-caso = 'A' THEN xPesoCasoA = xPesoCasoA + xEntregar.
    IF x-caso = 'B' THEN xPesoCasoB = xPesoCasoB + xEntregar.
    IF x-caso = 'C' THEN xPesoCasoC = xPesoCasoC + xEntregar.
    IF x-caso = 'D' THEN xPesoCasoD = xPesoCasoD + xEntregar.
    
    /*xNroCotxCaso = Faccpedi.nroped + "-" + x-Caso.*/
    xNroCotxCaso = Faccpedi.nroped + "-BONIFICACION".
    FIND FIRST tt-faccpedi WHERE tt-faccpedi.nroped = xNroCotxCaso NO-ERROR.
    IF NOT AVAILABLE tt-faccpedi THEN DO:
        CREATE tt-faccpedi.
        BUFFER-COPY faccpedi TO tt-faccpedi
            ASSIGN 
            tt-faccpedi.nroped = xNroCotxCaso
            tt-faccpedi.flgest = x-caso.
    END.
    /* -- */
    CREATE tt-facdpedi.
    BUFFER-COPY BONIFICACION TO tt-facdpedi.
    ASSIGN 
        tt-facdpedi.coddiv = tt-faccpedi.coddiv
        tt-facdpedi.coddoc = tt-faccpedi.coddoc
        tt-facdpedi.tipvta = x-Caso
        tt-facdpedi.nroped = xNroCotxCaso
        tt-facdpedi.origen = "BONIFICACION"
        .
END.
/* Asignamos Almacenes */
FOR EACH tt-faccpedi :
    IF tt-faccpedi.flgest = 'A' THEN DO:
        ASSIGN tt-faccpedi.lugent2 = Alm01.
        IF Tonelaje01 > 0 THEN DO:
            IF xPesoCasoA >= (Tonelaje01 * 1000) THEN ASSIGN tt-faccpedi.lugent2 = Alm01b.
        END.        
        xAlmCasoA = tt-faccpedi.lugent2.
    END.
    IF tt-faccpedi.flgest = 'B' THEN DO:
        ASSIGN tt-faccpedi.lugent2 = Alm02.
        IF Tonelaje02 > 0 THEN DO:
            IF xPesoCasoB >= (Tonelaje02 * 1000) THEN ASSIGN tt-faccpedi.lugent2 = Alm02b.
        END.        
        xAlmCasoB = tt-faccpedi.lugent2.
    END.
    IF tt-faccpedi.flgest = 'C' THEN DO:
        ASSIGN tt-faccpedi.lugent2 = Alm03.
        IF Tonelaje03 > 0 THEN DO:
            IF xPesoCasoC >= (Tonelaje03 * 1000) THEN ASSIGN tt-faccpedi.lugent2 = Alm03b.
        END.     
        xAlmCasoC = tt-faccpedi.lugent2.
    END.
    IF tt-faccpedi.flgest = 'D' THEN DO:
        ASSIGN tt-faccpedi.lugent2 = Alm04.
        xAlmCasoD = tt-faccpedi.lugent2.
    END.
END.
FOR EACH tt-faccpedi :
    ASSIGN tt-faccpedi.glosa = xAlmCasoA + "," + xAlmCasoB + "," + xAlmCasoC + "," + xAlmCasoD.
END.

/* CASOS */
RUN separa-cotizacion-caso.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE separa-cotizacion-caso wWin 
PROCEDURE separa-cotizacion-caso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lSumaAtendida AS DEC.
DEFINE VAR lProcesadoDtl AS LOG.
DEFINE VAR lEstado AS CHAR.

lSumaAtendida = 0.
lProcesadoDtl = NO.

/* Toma el FLAG de la FACCPEDI (ojo no b-faccpedi) */
CASE faccpedi.flgest:
    WHEN 'E' THEN lEstado = "POR APROBAR".
    WHEN 'P' THEN lEstado = "PENDIENTE".
    WHEN 'PP' THEN lEstado = "EN PROCESO".
    WHEN 'V' THEN lEstado = "VENCIDA".
    WHEN 'R' THEN lEstado = "RECHAZADO".
    WHEN 'A' THEN lEstado = "ANULADO".
    WHEN 'C' THEN lEstado = "ATENDIDA TOTAL".
    WHEN 'S' THEN lEstado = "SUSPENDIDA".
    WHEN 'X' THEN lEstado = "CERRADA MANUALMENTE".
    WHEN 'T' THEN lEstado = "EN REVISION".
    WHEN 'ST' THEN lEstado = "SALDO TRANSFERIDO".
END CASE.

FOR EACH tt-faccpedi :
    FIND FIRST tt-cot-hdr WHERE tt-cot-hdr.tt-divi = tt-faccpedi.coddiv AND
        tt-cot-hdr.tt-nrocot = tt-faccpedi.nroped EXCLUSIVE NO-ERROR.
    IF NOT AVAILABLE tt-cot-hdr THEN DO:
        CREATE tt-cot-hdr.
        ASSIGN 
            tt-cot-hdr.tt-divi      = tt-faccpedi.coddiv
            tt-cot-hdr.tt-nrocot   = tt-faccpedi.nroped
            tt-cot-hdr.tt-alm      = IF(tt-faccpedi.lugent2 = "" OR tt-faccpedi.lugent2 = ? ) THEN txtAlmOtros ELSE tt-faccpedi.lugent2
            tt-cot-hdr.tt-ubigeo   = lUbigeo
            tt-cot-hdr.tt-dubigeo   = lDUbigeo
            tt-cot-hdr.tt-listaprecio = tt-faccpedi.libre_c01
            tt-cot-hdr.tt-peso     = 0
            tt-cot-hdr.tt-peso-tot = 0 /*faccpedi.libre_d02*/
            tt-cot-hdr.tt-fchped = tt-faccpedi.fchped
            tt-cot-hdr.tt-fchven = tt-faccpedi.fchven
            tt-cot-hdr.tt-fchent = tt-faccpedi.fchent
            tt-cot-hdr.tt-nomcli = tt-faccpedi.nomcli
            tt-cot-hdr.tt-impvta = tt-faccpedi.impvta
            tt-cot-hdr.tt-impigv = tt-faccpedi.impigv
            tt-cot-hdr.tt-imptot = tt-faccpedi.imptot
            tt-cot-hdr.tt-flgest = lEstado
            tt-cot-hdr.tt-avance = 0
            tt-cot-hdr.tt-ptodsp = IF(tt-faccpedi.lugent2 = "" OR tt-faccpedi.lugent2 = ? ) THEN txtAlmOtros ELSE tt-faccpedi.lugent2
            tt-cot-hdr.tt-almacenes = tt-faccpedi.glosa  /* Alm A,B,C,D */
            tt-cot-hdr.tt-es-caso = tt-faccpedi.flgest.
    END.        
    FOR EACH tt-facdpedi OF tt-faccpedi NO-LOCK, FIRST almmmatg OF tt-facdpedi NO-LOCK :
        lProcesadoDtl = YES.
        /* Lo Atendido */
        IF tt-facdpedi.canate >= tt-facdpedi.canped THEN DO:
            lSumaAtendida = lSumaAtendida + tt-facdpedi.implin.
        END.
        ELSE DO:
            /* La fraccion del despacho */
            IF tt-facdpedi.canate > 0 THEN DO:
                lSumaAtendida = lSumaAtendida + (ROUND((tt-facdpedi.implin) * ROUND(tt-facdpedi.canate / tt-facdpedi.canped,4) , 2)).
            END.            
        END.
        
        ASSIGN tt-cot-hdr.tt-peso-tot = tt-cot-hdr.tt-peso-tot + ((tt-facdpedi.canped * tt-facdpedi.factor) * almmmatg.pesmat).
    
        IF (tt-facdpedi.canped - tt-facdpedi.canate ) <= 0 THEN NEXT .
    
        ASSIGN tt-cot-hdr.tt-peso = tt-cot-hdr.tt-peso + 
            (((tt-facdpedi.canped - tt-facdpedi.canate) * tt-facdpedi.factor) * almmmatg.pesmat)
                /*tt-cot-hdr.tt-peso-tot = tt-cot-hdr.tt-peso-tot + ((facdpedi.canped * facdpedi.factor) * almmmatg.pesmat)*/.
    
        /* Canal Moderno */
        IF (tt-faccpedi.coddiv = '00017') THEN DO:
            ASSIGN tt-cot-hdr.tt-alm = '21e'.
        END.        
        /*
            24Ene2015 - Lucy Mesia, dejar sin efecto esta condicion
        IF (faccpedi.coddiv = '10060') THEN DO:
            ASSIGN tt-cot-hdr.tt-alm = '60'.
        END.
        */
        FIND FIRST tt-cot-dtl WHERE tt-cot-dtl.tt-divi = tt-faccpedi.coddiv AND
                                    tt-cot-dtl.tt-nrocot  = tt-faccpedi.nroped AND
                                    tt-cot-dtl.tt-codmat = tt-facdpedi.codmat EXCLUSIVE NO-ERROR.
        IF NOT AVAILABL tt-cot-dtl THEN DO:
            CREATE tt-cot-dtl.
                ASSIGN tt-cot-dtl.tt-divi = tt-faccpedi.coddiv
                        tt-cot-dtl.tt-nrocot = tt-faccpedi.nroped
                        tt-cot-dtl.tt-codmat = tt-facdpedi.codmat
                        tt-cot-dtl.tt-cant = 0
                        tt-cot-dtl.tt-item = tt-facdpedi.nroitm
                        tt-cot-dtl.tt-caso = tt-facdpedi.tipvta
                        tt-cot-dtl.tt-plista = tt-faccpedi.libre_c01
                        tt-cot-dtl.tt-nomclie = tt-faccpedi.nomcli
                        tt-cot-dtl.tt-vend = tt-faccpedi.codven
                        tt-cot-dtl.tt-pdd = tt-cot-hdr.tt-ptodsp
                        tt-cot-dtl.tt-origen = tt-facdpedi.origen
                    .
            FIND FIRST gn-ven WHERE gn-ven.codcia = s-codcia AND 
                                    gn-ven.codven = tt-faccpedi.codven NO-LOCK NO-ERROR.
            IF AVAILABLE gn-ven THEN tt-cot-dtl.tt-vend = tt-cot-dtl.tt-vend + " " + gn-ven.nomven.

        END.
        ASSIGN tt-cot-dtl.tt-cant = tt-cot-dtl.tt-cant + (((tt-facdpedi.canped - tt-facdpedi.canate ) * 1) * 1).
    END.
    IF lProcesadoDtl = YES THEN DO:
        /* Avance */
        IF lSumaAtendida > 0 THEN DO:
            ASSIGN tt-cot-hdr.tt-avance = ROUND((lSumaAtendida / tt-faccpedi.imptot) * 100,2).
        END.
        ELSE ASSIGN tt-cot-hdr.tt-avance = 0.00.
    
        IF tt-cot-hdr.tt-avance > 0 THEN DO:
            ASSIGN tt-cot-hdr.tt-flgest = "EN PROCESO".
            IF tt-cot-hdr.tt-avance >= 100 THEN DO:
                ASSIGN tt-cot-hdr.tt-flgest = "ATENDIDA TOTAL".
            END.
        END.       
    END.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-cotizaciones wWin 
PROCEDURE ue-cotizaciones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lSec AS INT.
DEFINE VAR lSec1 AS INT.
DEFINE VAR lDia AS DATE.

DEFINE VAR lFechaX AS DATE.  /* Fecha Tope */

DEFINE VAR lNroCot AS CHAR.
DEFINE VAR lCodAlm AS CHAR.
DEFINE VAR lCodMat AS CHAR.
DEFINE VAR lStk AS DEC.
DEFINE VAR lStkRsrv AS DEC.
DEFINE VAR lStkRepo AS DEC.
DEFINE VAR lQtyxRecepcionar AS DEC.

DEFINE VAR lSumaAtendida AS DEC.
DEFINE VAR lEstado AS CHAR FORMAT 'x(30)'.
DEFINE VAR lProcesadoDtl AS LOG.

lFechaX =  lFechaTope.
txtListaPrecio = TRIM(txtListaPRecio).

SESSION:SET-WAIT-STATE('GENERAL').

txtmsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Cotizaciones" .

EMPTY TEMP-TABLE tt-cot-hdr.
EMPTY TEMP-TABLE tt-cot-dtl.
EMPTY TEMP-TABLE tt-cot-final.
EMPTY TEMP-TABLE tmp-tabla.

/* Sumando las Cotizaciones que no esten anuladas */
FOR EACH b-gn-divi NO-LOCK WHERE b-gn-divi.codcia = s-codcia AND
    LOOKUP(b-gn-divi.coddiv, lDivisiones) > 0,
    EACH faccpedi NO-LOCK WHERE faccpedi.codcia = s-codcia AND 
    faccpedi.coddiv = b-gn-divi.coddiv AND
    faccpedi.coddoc = 'COT' AND 
    (faccpedi.fchped  >= txtDesde AND faccpedi.fchped <= lFechaActual ) AND
    faccpedi.fchent <= lFechaTope:
    /* Lista de Precio */
    IF LOOKUP(faccpedi.libre_c01,txtlistaPrecio) = 0  THEN NEXT.

    /* Cotizaciones de Pruebas */
    IF substring(faccpedi.codcli,1,3) = 'SYS' THEN NEXT.  

    /* Solo APROBADO, ATENDIDO, x APROBAR */
    IF LOOKUP(Faccpedi.FlgEst, 'P,C,E') = 0 THEN NEXT.

    txtmsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Cotizacion(" + faccpedi.nroped + ")".

    FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia AND 
        gn-clie.codcli = faccpedi.codcli NO-LOCK NO-ERROR.
    /* Ubigeo segun el Cliente */
    lUbigeo = "".
    lDUbigeo = "".
    IF AVAILABLE gn-clie THEN DO:
        lUbigeo = IF (gn-clie.coddept = ? OR trim(gn-clie.coddept)="") THEN "XX" ELSE gn-clie.coddept.
        lUbigeo = lUbigeo + IF (gn-clie.codprov = ? OR trim(gn-clie.codprov)="") THEN "XX" ELSE gn-clie.codprov.
        lUbigeo = lUbigeo + IF (gn-clie.coddist = ? OR trim(gn-clie.coddist)="") THEN "XX" ELSE gn-clie.coddist.
    END.   
    lUbigeoX = REPLACE(lUbigeo,"X","").
    
    /* Departamento */
    FIND FIRST ubigeo WHERE ubgCod = Substring(lUbigeo,1,2) NO-LOCK NO-ERROR.
    lDUbigeo = IF(AVAILABLE ubigeo) THEN ubigeo.ubgnom ELSE "NO EXISTE".
    
    /* Provincia */
    FIND FIRST ubigeo WHERE ubgCod = Substring(lUbigeo,1,4) NO-LOCK NO-ERROR.
    lDUbigeo = lDUbigeo + " - " + IF(AVAILABLE ubigeo) THEN ubigeo.ubgnom ELSE "NO EXISTE".

    /* Distrito */
    FIND FIRST ubigeo WHERE ubgCod = Substring(lUbigeo,1,6) NO-LOCK NO-ERROR.
    lDUbigeo = lDUbigeo + " - " + IF(AVAILABLE ubigeo) THEN ubigeo.ubgnom ELSE "NO EXISTE".

    /* */
    lSumaAtendida = 0.
    lProcesadoDtl = NO.
    /* Detalle de las cotizaciones */
    CASE faccpedi.flgest:
        WHEN 'E' THEN lEstado = "POR APROBAR".
        WHEN 'P' THEN lEstado = "PENDIENTE".
        WHEN 'PP' THEN lEstado = "EN PROCESO".
        WHEN 'V' THEN lEstado = "VENCIDA".
        WHEN 'R' THEN lEstado = "RECHAZADO".
        WHEN 'A' THEN lEstado = "ANULADO".
        WHEN 'C' THEN lEstado = "ATENDIDA TOTAL".
        WHEN 'S' THEN lEstado = "SUSPENDIDA".
        WHEN 'X' THEN lEstado = "CERRADA MANUALMENTE".
        WHEN 'T' THEN lEstado = "EN REVISION".
        WHEN 'ST' THEN lEstado = "SALDO TRANSFERIDO".
    END CASE.
    /* ***************************** */
    /* RHC 08/01/2019 BONIFICACIONES */
    /* ***************************** */
    EMPTY TEMP-TABLE BONIFICACION.
    EMPTY TEMP-TABLE ITEM.
    IF TOGGLE-Bonificaciones = YES THEN DO:
        DEF VAR pError AS CHAR NO-UNDO.
        FOR EACH Facdpedi OF Faccpedi NO-LOCK:
            CREATE ITEM.
            BUFFER-COPY Facdpedi TO ITEM.
        END.
        IF CAN-FIND(FIRST ITEM NO-LOCK) THEN DO:
            RUN vtagn/p-promocion-general (INPUT Faccpedi.coddiv,
                                           INPUT TRIM(Faccpedi.coddoc) + "*",
                                           INPUT Faccpedi.nroped,
                                           INPUT TABLE ITEM,
                                           OUTPUT TABLE BONIFICACION,
                                           OUTPUT pError).
        END.
    END.
    /* 
        Verificar la cotizacion si cuya lista de Precio, 
        proviene de EVENTO, para separarla en CASO A, B, C, D
    */
    FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND 
                            gn-divi.coddiv = faccpedi.libre_c01
                            NO-LOCK NO-ERROR.
/*     IF AVAILABLE gn-divi AND gn-divi.canalventa = 'FER' THEN DO: */
/*         /* Partimos la COTIZACION */                             */
/*         RUN separa-cotizacion.                                   */
/*         NEXT.       /* SIGUIENTE */                              */
/*     END.                                                         */
    CREATE tt-cot-hdr.
    ASSIGN 
        tt-cot-hdr.tt-divi      = faccpedi.coddiv
        tt-cot-hdr.tt-nrocot   = faccpedi.nroped
        tt-cot-hdr.tt-alm      = IF(faccpedi.lugent2 = "" OR faccpedi.lugent2 = ? ) THEN txtAlmOtros ELSE faccpedi.lugent2
        tt-cot-hdr.tt-ubigeo   = lUbigeo
        tt-cot-hdr.tt-dubigeo   = lDUbigeo
        tt-cot-hdr.tt-listaprecio = faccpedi.libre_c01
        tt-cot-hdr.tt-peso     = 0
        tt-cot-hdr.tt-peso-tot = 0 /*faccpedi.libre_d02*/
        tt-cot-hdr.tt-fchped = faccpedi.fchped
        tt-cot-hdr.tt-fchven = faccpedi.fchven
        tt-cot-hdr.tt-fchent = faccpedi.fchent
        tt-cot-hdr.tt-nomcli = faccpedi.nomcli
        tt-cot-hdr.tt-impvta = faccpedi.impvta
        tt-cot-hdr.tt-impigv = faccpedi.impigv
        tt-cot-hdr.tt-imptot = faccpedi.imptot
        tt-cot-hdr.tt-flgest = lEstado
        tt-cot-hdr.tt-avance = 0
        tt-cot-hdr.tt-ptodsp = IF(faccpedi.lugent2 = "" OR faccpedi.lugent2 = ? ) THEN txtAlmOtros ELSE faccpedi.lugent2 /*faccpedi.lugent2*/
        tt-cot-hdr.tt-almacenes = tt-cot-hdr.tt-ptodsp.
    FOR EACH facdpedi OF faccpedi NO-LOCK, FIRST almmmatg OF facdpedi NO-LOCK :
        lProcesadoDtl = YES.
        FIND FIRST tt-cot-hdr WHERE tt-cot-hdr.tt-divi = faccpedi.coddiv AND
                                        tt-cot-hdr.tt-nrocot = faccpedi.nroped EXCLUSIVE NO-ERROR.
        /* Lo Atendido */
        IF facdpedi.canate >= facdpedi.canped THEN DO:
            lSumaAtendida = lSumaAtendida + facdpedi.implin.
        END.
        ELSE DO:
            /* La fraccion del despacho */
            IF facdpedi.canate > 0 THEN DO:
                lSumaAtendida = lSumaAtendida + (ROUND((facdpedi.implin) * ROUND(facdpedi.canate / facdpedi.canped,4) , 2)).
            END.            
        END.
        ASSIGN tt-cot-hdr.tt-peso-tot = tt-cot-hdr.tt-peso-tot + ((facdpedi.canped * facdpedi.factor) * almmmatg.pesmat).
        IF (facdpedi.canped - facdpedi.canate ) <= 0 THEN NEXT .
        ASSIGN tt-cot-hdr.tt-peso = tt-cot-hdr.tt-peso + 
            (((facdpedi.canped - facdpedi.canate) * facdpedi.factor) * almmmatg.pesmat).
        /* Canal Moderno */
        IF (faccpedi.coddiv = '00017') THEN DO:
            ASSIGN tt-cot-hdr.tt-alm = '21e'.
        END.        
        FIND FIRST tt-cot-dtl WHERE tt-cot-dtl.tt-divi = faccpedi.coddiv AND
                                    tt-cot-dtl.tt-nrocot  = faccpedi.nroped AND
                                    tt-cot-dtl.tt-codmat = facdpedi.codmat EXCLUSIVE NO-ERROR.
        IF NOT AVAILABL tt-cot-dtl THEN DO:
            CREATE tt-cot-dtl.
                ASSIGN tt-cot-dtl.tt-divi = faccpedi.coddiv
                        tt-cot-dtl.tt-nrocot = faccpedi.nroped
                        tt-cot-dtl.tt-codmat = facdpedi.codmat
                        tt-cot-dtl.tt-cant = 0
                        tt-cot-dtl.tt-item = facdpedi.nroitm
                        tt-cot-dtl.tt-caso = ''
                        tt-cot-dtl.tt-plista = faccpedi.libre_c01
                        tt-cot-dtl.tt-nomclie = faccpedi.nomcli
                        tt-cot-dtl.tt-vend = faccpedi.codven
                        tt-cot-dtl.tt-pdd = tt-cot-hdr.tt-ptodsp
                        .
                FIND FIRST gn-ven WHERE gn-ven.codcia = s-codcia AND 
                                        gn-ven.codven = faccpedi.codven NO-LOCK NO-ERROR.
                IF AVAILABLE gn-ven THEN tt-cot-dtl.tt-vend = tt-cot-dtl.tt-vend + " " + gn-ven.nomven.
        END.
        /*ASSIGN tt-cot-dtl.tt-cant = tt-cot-dtl.tt-cant + (((facdpedi.canped - facdpedi.canate ) * facdpedi.factor) * facdpedi.factor).*/
        ASSIGN tt-cot-dtl.tt-cant = tt-cot-dtl.tt-cant + (((facdpedi.canped - facdpedi.canate ) * 1) * 1).

    END.
    /* BONIFICACIONES */
    FOR EACH BONIFICACION, FIRST Almmmatg OF BONIFICACION NO-LOCK:
        lProcesadoDtl = YES.
        ASSIGN 
            tt-cot-hdr.tt-peso-tot = tt-cot-hdr.tt-peso-tot + ((BONIFICACION.canped * BONIFICACION.factor) * Almmmatg.pesmat).
        IF (BONIFICACION.canped - BONIFICACION.canate ) <= 0 THEN NEXT .
        ASSIGN 
            tt-cot-hdr.tt-peso = tt-cot-hdr.tt-peso + 
            (((BONIFICACION.canped - BONIFICACION.canate) * BONIFICACION.factor) * almmmatg.pesmat).
        /* Canal Moderno */
        IF (faccpedi.coddiv = '00017') THEN DO:
            ASSIGN tt-cot-hdr.tt-alm = '21e'.
        END.        
        CREATE tt-cot-dtl.
        ASSIGN tt-cot-dtl.tt-divi = faccpedi.coddiv
                tt-cot-dtl.tt-nrocot = faccpedi.nroped
                tt-cot-dtl.tt-codmat = BONIFICACION.codmat
                tt-cot-dtl.tt-cant = 0
                tt-cot-dtl.tt-item = BONIFICACION.nroitm
                tt-cot-dtl.tt-caso = ''
                tt-cot-dtl.tt-plista = faccpedi.libre_c01
                tt-cot-dtl.tt-nomclie = faccpedi.nomcli
                tt-cot-dtl.tt-vend = faccpedi.codven
                tt-cot-dtl.tt-pdd = tt-cot-hdr.tt-ptodsp
                tt-cot-dtl.tt-origen = "BONIFICACION"
                .
        FIND FIRST gn-ven WHERE gn-ven.codcia = s-codcia AND 
                                gn-ven.codven = faccpedi.codven NO-LOCK NO-ERROR.
        IF AVAILABLE gn-ven THEN tt-cot-dtl.tt-vend = tt-cot-dtl.tt-vend + " " + gn-ven.nomven.
        ASSIGN 
            tt-cot-dtl.tt-cant = tt-cot-dtl.tt-cant + (((BONIFICACION.canped - BONIFICACION.canate ) * 1) * 1).
    END.
    IF lProcesadoDtl = YES THEN DO:
        /* Avance */
        IF lSumaAtendida > 0 THEN DO:
            ASSIGN tt-cot-hdr.tt-avance = ROUND((lSumaAtendida / faccpedi.imptot) * 100,2).
        END.
        ELSE ASSIGN tt-cot-hdr.tt-avance = 0.00.

        IF tt-cot-hdr.tt-avance > 0 THEN DO:
            ASSIGN tt-cot-hdr.tt-flgest = "EN PROCESO".
            IF tt-cot-hdr.tt-avance >= 100 THEN DO:
                ASSIGN tt-cot-hdr.tt-flgest = "ATENDIDA TOTAL".
            END.
        END.       
    END.
END.

/* Ic - 01Dic2016, Considerar Cotizaciones Excepcion */
/*RUN ue-proc-expocot.*/

/* Ic - 01Dic2016 - FIN */

txtmsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Resumen x Articulo" .
FOR EACH tt-cot-hdr NO-LOCK:
    FOR EACH tt-cot-dtl WHERE tt-cot-dtl.tt-divi = tt-cot-hdr.tt-divi AND
                            tt-cot-dtl.tt-nrocot = tt-cot-hdr.tt-nrocot NO-LOCK:

        lCodAlm = tt-cot-hdr.tt-alm.
        FIND FIRST Almmmatg WHERE almmmatg.codcia = s-codcia AND
                                almmmatg.codmat = tt-cot-dtl.tt-codmat NO-LOCK NO-ERROR.
        /* Excepcion */
        /* 
            Correo Lucy Mesia del 10Nov2016 se quita la Excepion
        
            IF almmmatg.codfam = '011' OR almmmatg.codfam = '012' OR almmmatg.codfam = '013' THEN DO:
                lCodAlm = '11e'.
            END.
        */

        FIND FIRST tt-cot-final WHERE tt-cot-final.tt-alm = lCodAlm AND
                        tt-cot-final.tt-codmat = tt-cot-dtl.tt-codmat EXCLUSIVE NO-ERROR.
        IF NOT AVAILABLE tt-cot-final THEN DO:
            CREATE tt-cot-final.
                FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND
                                        almmmatg.codmat = tt-cot-dtl.tt-codmat NO-LOCK NO-ERROR.
                /* Ic - 03Ocy2017, segun Lucy Mesia Stock Repo de Andhuaylas (inner) */
                FIND FIRST almmmate WHERE almmmate.codcia = s-codcia AND 
                                            almmmate.codalm = '04' AND 
                                            almmmate.codmat = tt-cot-dtl.tt-codmat NO-LOCK NO-ERROR.                                        
                ASSIGN tt-cot-final.tt-alm  = lCodAlm
                        tt-cot-final.tt-codmat = tt-cot-dtl.tt-codmat
                        tt-cot-final.tt-desmat = IF(AVAILABLE almmmatg) THEN almmmatg.desmat ELSE ""
                        tt-cot-final.tt-inner = IF(AVAILABLE Almmmate) THEN almmmate.stkmax ELSE 1
                        tt-cot-final.tt-cant = 0.
                IF tt-cot-final.tt-inner < 1 THEN ASSIGN tt-cot-final.tt-inner = 1.
        END.
        tt-cot-final.tt-cant = tt-cot-final.tt-cant + tt-cot-dtl.tt-cant.
    END.
END.
txtmsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Verificando con saldos de Stocks del almacen" .
FOR EACH tt-cot-final WHERE tt-cot-final.tt-cant > 0 EXCLUSIVE :
    FIND FIRST almmmate WHERE almmmate.codcia = s-codcia AND
                        almmmate.codalm = tt-cot-final.tt-alm AND 
                        almmmate.codmat = tt-cot-final.tt-codmat NO-LOCK NO-ERROR.
    IF AVAILABLE almmmate THEN DO:
        lCodAlm     = tt-cot-final.tt-alm.
        lCodMat     = tt-cot-final.tt-codmat.

        /* Reservado */
        /*RUN vta2/stock-comprometido-v2.r(INPUT lcodmat, INPUT lCodAlm,  OUTPUT lStkRsrv).*/
        RUN gn/stock-comprometido-v2.r(INPUT lcodmat, INPUT lCodAlm,  OUTPUT lStkRsrv).

        lQtyxRecepcionar = 0.
        /* Transferencias x Recepcionar */
        RUN ue-transf-x-recepcionar(INPUT lCodAlm, INPUT lcodmat, OUTPUT lQtyxRecepcionar).

        lStk = almmmate.stkact - lStkRsrv + lQtyxRecepcionar.

        ASSIGN tt-xatender = tt-cot-final.tt-cant
                tt-stkalm = almmmate.stkact
                tt-reserva = lStkRsrv
                tt-xrecep = lQtyxRecepcionar.

        /* Si es negativo ponerlo en CERO */
        lStk = IF(lStk < 0 ) THEN 0 ELSE (almmmate.stkact - lStkRsrv + lQtyxRecepcionar).

        IF tt-cot-final.tt-cant > lStk  THEN DO:
            /* Insuficiente Stock para Atender */
            IF rdBtnCual = 1 THEN DO:
                /* Faltante */
                lStkRepo = tt-cot-final.tt-cant - lStk.
            END.
            ELSE DO:
                lStkRepo = 0.
                /* Excedente */
            END.
            /* x el INNER */
            IF lStkRepo > 0 THEN DO:
                IF (lStkRepo MODULO tt-cot-final.tt-inner) = 0  THEN DO:
                    lStkRepo = TRUNCATE(lStkRepo / tt-cot-final.tt-inner,0).
                END.
                ELSE lStkRepo = TRUNCATE(lStkRepo / tt-cot-final.tt-inner,0) + 1.
            END.
            lStkRepo = lStkRepo * tt-cot-final.tt-inner.
            ASSIGN tt-cot-final.tt-cant = lStkRepo.

        END.
        ELSE DO:
            /* Stock Completo no hay q pedir nada */
            IF rdBtnCual = 1 THEN DO:
                /* Faltante */
                ASSIGN tt-cot-final.tt-cant = 0.
            END.
            ELSE DO:    
                lStkRepo = lStk - tt-cot-final.tt-cant.
                ASSIGN tt-cot-final.tt-cant = lStkRepo.
            END.
        END.
        /* Inner */
    END.
    ELSE DO:
        ASSIGN tt-cot-final.tt-msg = "No existe en Almacen".
    END.
END.
/* Marco las COTIZACIONES como procesadas siempre y cuando el proceso sea x FALTANTES */
IF chbxGrabaCot = YES AND rdBtnCual = 1 THEN DO:
    txtmsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Marcando la COTIZACION como PROCESADO" .

    DEFINE BUFFER ic-faccpedi FOR faccpedi.

    FOR EACH tt-cot-hdr :
        lNroCot = tt-cot-hdr.tt-nrocot.
        lNroCot = REPLACE(lNroCot,"-A","").
        lNroCot = REPLACE(lNroCot,"-B","").
        lNroCot = REPLACE(lNroCot,"-C","").
        lNroCot = REPLACE(lNroCot,"-D","").

        FIND FIRST ic-faccpedi WHERE ic-faccpedi.codcia = s-codcia AND 
                                ic-faccpedi.coddoc = 'COT' AND 
                                ic-faccpedi.nroped = lNroCot NO-ERROR.
        IF AVAILABLE ic-faccpedi THEN DO:
            ASSIGN ic-faccpedi.libre_c02 = 'PROCESADO'.
            /* Grabo los Almacenes */
            IF tt-cot-hdr.tt-es-caso <> "" THEN DO:
                ASSIGN ic-faccpedi.lugent2 = tt-cot-hdr.tt-almacenes.
            END.
        END.        
    END.
    RELEASE ic-faccpedi.

    DEFINE BUFFER ic-facdpedi FOR facdpedi.

    FOR EACH tt-cot-dtl :
        lNroCot = tt-cot-dtl.tt-nrocot.
        lNroCot = REPLACE(lNroCot,"-A","").
        lNroCot = REPLACE(lNroCot,"-B","").
        lNroCot = REPLACE(lNroCot,"-C","").
        lNroCot = REPLACE(lNroCot,"-D","").

        FIND FIRST ic-facdpedi WHERE ic-facdpedi.codcia = s-codcia AND 
                                    ic-facdpedi.coddoc = 'COT' AND 
                                    ic-facdpedi.nroped = lNroCot AND 
                                    ic-facdpedi.nroitm = tt-cot-dtl.tt-item NO-ERROR.

        IF AVAILABLE ic-facdpedi THEN ASSIGN ic-facdpedi.tipvta = tt-cot-dtl.tt-caso.
    END.

    RELEASE ic-facdpedi.

    /**/
    FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND 
                            vtatabla.tabla = 'DSTRB' AND
                            vtatabla.llave_c1 = '2016' 
                            NO-ERROR.
    IF NOT AVAILABLE vtatabla THEN DO:
        CREATE vtatabla.
            ASSIGN vtatabla.codcia = s-codcia
                    vtatabla.tabla = 'DSTRB'
                    vtatabla.llave_c1 = '2016'.
    END.

    ASSIGN vtatabla.rango_fecha[2] = txtFechaTope
            vtatabla.rango_fecha[1] = TODAY
            vtatabla.libre_c01 = Alm01 + "," + alm02 + "," + alm03 + "," + alm04
            vtatabla.libre_c02 = Alm01b + "," + alm02b + "," + alm03b + "," + alm04b
            vtatabla.valor[1] = Tonelaje01
            vtatabla.valor[2] = Tonelaje02
            vtatabla.valor[3] = Tonelaje03
            vtatabla.valor[4] = Tonelaje04
            vtatabla.llave_c7 = txtDivisiones
            vtatabla.llave_c8 = TxtListaPrecio.
    
    RELEASE vtatabla.

    /* 
        Blanquear cotizaciones que estuvieron en el proceso anterior y que no
        no se van a considerar en este proceso
    */
    RUN blaquear-procesadas.
END.

txtmsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Eliminando las registros en CERO" .
FOR EACH tt-cot-final EXCLUSIVE :
    IF tt-cot-final.tt-cant = 0 THEN DO:
       DELETE tt-cot-final.
    END.
END.

txtmsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Terminadooooo" .

SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-excel wWin 
PROCEDURE ue-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.
DEFINE VAR lStkReservado AS DEC.

lFileXls = "".          /* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */
lNuevoFile = YES.       /* YES : Si va crear un nuevo archivo o abrir */

SESSION:SET-WAIT-STATE('GENERAL').

{lib\excel-open-file.i}

iColumn = 1.
cColumn = STRING(iColumn).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Almacen".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Cod.Articulo".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "Descripcion".
cRange = "D" + cColumn.
IF rdBtnCual = 1 THEN DO:
    chWorkSheet:Range(cRange):Value = "Faltantes".
END.
ELSE DO:
    chWorkSheet:Range(cRange):Value = "Excedente".
END.
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "Observaciones".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Familia".
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "Descripcion Familia".
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = "SubFamilia".
cRange = "I" + cColumn.
chWorkSheet:Range(cRange):Value = "Descripcion SubFamilia".
cRange = "J" + cColumn.
chWorkSheet:Range(cRange):Value = "xAtender".
cRange = "K" + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Almacen".
cRange = "L" + cColumn.
chWorkSheet:Range(cRange):Value = "Reservado".
cRange = "M" + cColumn.
chWorkSheet:Range(cRange):Value = "x Recepcionar".
cRange = "N" + cColumn.
chWorkSheet:Range(cRange):Value = "Inner".
cRange = "O" + cColumn.
chWorkSheet:Range(cRange):Value = "Marca".
cRange = "P" + cColumn.
chWorkSheet:Range(cRange):Value = "U.Med".
cRange = "Q" + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Disponible Alm 11 (stk - reservado)".
cRange = "R" + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Disponible Alm 21 (stk - reservado)".
cRange = "S" + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Disponible 14 (stk - reservado)".
cRange = "T" + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Disponible 35 (stk - reservado)".
cRange = "U" + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Disponible 75 (stk - reservado)".
cRange = "V" + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Disponible 14F (stk - reservado)".
cRange = "W" + cColumn.
chWorkSheet:Range(cRange):Value = "Master".

FOR EACH tt-cot-final NO-LOCK :
    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
                almmmatg.codmat = tt-cot-final.tt-codmat NO-LOCK NO-ERROR.
    FIND FIRST almtfam WHERE almtfam.codcia = s-codcia AND almtfam.codfam = almmmatg.codfam NO-LOCK NO-ERROR.
    FIND FIRST almsfam WHERE almsfam.codcia = s-codcia AND almsfam.codfam = almmmatg.codfam AND 
                    almsfam.subfam = almmmatg.subfam NO-LOCK NO-ERROR.
    FIND FIRST almtabla WHERE almtabla.tabla = 'MK' AND almtabla.codigo = almmmatg.codmar NO-LOCK NO-ERROR.
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + tt-cot-final.tt-alm /*REPLACE(tt-cot-final.tt-alm,"e","")*/.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + tt-cot-final.tt-codmat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + tt-cot-final.tt-desmat.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-cot-final.tt-cant.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + tt-cot-final.tt-msg.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + almmmatg.codfam.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + almtfam.desfam.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + almmmatg.subfam.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + almsfam.dessub .
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-cot-final.tt-xatender.
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-cot-final.tt-StkAlm.
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-cot-final.tt-reserva .
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-cot-final.tt-xrecep .
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-cot-final.tt-inner .
    IF AVAILABLE almtabla THEN DO:
        cRange = "O" + cColumn.
        chWorkSheet:Range(cRange):Value = almtabla.nombre .
    END.
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.undstk.

    lStkReservado = 0.
    /*RUN vta2/stock-comprometido-v2.r(INPUT tt-cot-final.tt-codmat, INPUT '11',  OUTPUT lStkReservado).*/
    RUN gn/stock-comprometido-v2.r(INPUT tt-cot-final.tt-codmat, INPUT '11',  OUTPUT lStkReservado).
    FIND FIRST almmmate WHERE almmmate.codcia = s-codcia AND
                        almmmate.codalm = '11' AND 
                        almmmate.codmat = tt-cot-final.tt-codmat NO-LOCK NO-ERROR.
    IF AVAILABLE almmmate THEN DO:
        cRange = "Q" + cColumn.
        chWorkSheet:Range(cRange):Value = IF ((almmmate.stkact - lStkReservado) < 0) THEN 0 ELSE (almmmate.stkact - lStkReservado).
    END.

    lStkReservado = 0.
    /*RUN vta2/stock-comprometido-v2.r(INPUT tt-cot-final.tt-codmat, INPUT '21',  OUTPUT lStkReservado).*/
    RUN gn/stock-comprometido-v2.r(INPUT tt-cot-final.tt-codmat, INPUT '21',  OUTPUT lStkReservado).
    FIND FIRST almmmate WHERE almmmate.codcia = s-codcia AND
                        almmmate.codalm = '21' AND 
                        almmmate.codmat = tt-cot-final.tt-codmat NO-LOCK NO-ERROR.
    IF AVAILABLE almmmate THEN DO:
        cRange = "R" + cColumn.
        chWorkSheet:Range(cRange):Value = IF ((almmmate.stkact - lStkReservado) < 0) THEN 0 ELSE (almmmate.stkact - lStkReservado).
    END.

    lStkReservado = 0.
    /*RUN vta2/stock-comprometido-v2.r(INPUT tt-cot-final.tt-codmat, INPUT '14',  OUTPUT lStkReservado).*/
    RUN gn/stock-comprometido-v2.r(INPUT tt-cot-final.tt-codmat, INPUT '14',  OUTPUT lStkReservado).
    FIND FIRST almmmate WHERE almmmate.codcia = s-codcia AND
                        almmmate.codalm = '14' AND 
                        almmmate.codmat = tt-cot-final.tt-codmat NO-LOCK NO-ERROR.
    IF AVAILABLE almmmate THEN DO:
        cRange = "S" + cColumn.
        chWorkSheet:Range(cRange):Value = IF ((almmmate.stkact - lStkReservado) < 0) THEN 0 ELSE (almmmate.stkact - lStkReservado).
    END.

    lStkReservado = 0.
    /*RUN vta2/stock-comprometido-v2.r(INPUT tt-cot-final.tt-codmat, INPUT '35',  OUTPUT lStkReservado).*/
    RUN gn/stock-comprometido-v2.r(INPUT tt-cot-final.tt-codmat, INPUT '35',  OUTPUT lStkReservado).
    FIND FIRST almmmate WHERE almmmate.codcia = s-codcia AND
                        almmmate.codalm = '35' AND 
                        almmmate.codmat = tt-cot-final.tt-codmat NO-LOCK NO-ERROR.
    IF AVAILABLE almmmate THEN DO:
        cRange = "T" + cColumn.
        chWorkSheet:Range(cRange):Value = IF ((almmmate.stkact - lStkReservado) < 0) THEN 0 ELSE (almmmate.stkact - lStkReservado).
    END.

    lStkReservado = 0.
    /*RUN vta2/stock-comprometido-v2.r(INPUT tt-cot-final.tt-codmat, INPUT '75',  OUTPUT lStkReservado).*/
    RUN gn/stock-comprometido-v2.r(INPUT tt-cot-final.tt-codmat, INPUT '75',  OUTPUT lStkReservado).
    FIND FIRST almmmate WHERE almmmate.codcia = s-codcia AND
                        almmmate.codalm = '75' AND 
                        almmmate.codmat = tt-cot-final.tt-codmat NO-LOCK NO-ERROR.
    IF AVAILABLE almmmate THEN DO:
        cRange = "U" + cColumn.
        chWorkSheet:Range(cRange):Value = IF ((almmmate.stkact - lStkReservado) < 0) THEN 0 ELSE (almmmate.stkact - lStkReservado).
    END.

/*     lStkReservado = 0.                                                                                                              */
/*     RUN vta2/stock-comprometido-v2.r(INPUT tt-cot-final.tt-codmat, INPUT '14F',  OUTPUT lStkReservado).                             */
/*     FIND FIRST almmmate WHERE almmmate.codcia = s-codcia AND                                                                        */
/*                         almmmate.codalm = '14F' AND                                                                                 */
/*                         almmmate.codmat = tt-cot-final.tt-codmat NO-LOCK NO-ERROR.                                                  */
/*     IF AVAILABLE almmmate THEN DO:                                                                                                  */
/*         cRange = "V" + cColumn.                                                                                                     */
/*         chWorkSheet:Range(cRange):Value = IF ((almmmate.stkact - lStkReservado) < 0) THEN 0 ELSE (almmmate.stkact - lStkReservado). */
/*     END.                                                                                                                            */

    cRange = "W" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.canemp.
END.
/* FIN Detalle de Cotizaciones */


/* RESUMEN Detalle de Cotizaciones */
chWorkSheet = chExcelApplication:Sheets:Item(2). 
iColumn = 1.
cColumn = STRING(iColumn).

cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Div.Origen".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Nro Cotizacion".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "Fecha Emision".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "Vencimiento".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "Fecha entrega".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Razon Social".
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "Importe Venta".
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = "Importe IGV".
cRange = "I" + cColumn.
chWorkSheet:Range(cRange):Value = "Importe Neto".
cRange = "J" + cColumn.
chWorkSheet:Range(cRange):Value = "Estado".
cRange = "K" + cColumn.
chWorkSheet:Range(cRange):Value = "%Avance".
cRange = "L" + cColumn.
chWorkSheet:Range(cRange):Value = "PDD asignado".
cRange = "M" + cColumn.
chWorkSheet:Range(cRange):Value = "Peso Total".
cRange = "N" + cColumn.
chWorkSheet:Range(cRange):Value = "Peso Pendiente".
cRange = "O" + cColumn.
chWorkSheet:Range(cRange):Value = "Almacenes".
cRange = "P" + cColumn.
chWorkSheet:Range(cRange):Value = "Lista Precio".
cRange = "Q" + cColumn.
chWorkSheet:Range(cRange):Value = "Ubigeo".
cRange = "R" + cColumn.
chWorkSheet:Range(cRange):Value = "Dpto - Provincia - Distrito".

cRange = "X" + cColumn.
chWorkSheet:Range(cRange):Value = "TIPO".

FOR EACH tt-cot-hdr NO-LOCK :
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).

    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + tt-cot-hdr.tt-divi.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + tt-cot-hdr.tt-nrocot.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-cot-hdr.tt-fchped.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-cot-hdr.tt-fchven.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-cot-hdr.tt-fchent.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-cot-hdr.tt-nomcli.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-cot-hdr.tt-impvta.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-cot-hdr.tt-impigv.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-cot-hdr.tt-imptot.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-cot-hdr.tt-flgest.
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = string(tt-cot-hdr.tt-avance,">>,>>9.99") .
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + tt-cot-hdr.tt-ptodsp.
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-cot-hdr.tt-peso-tot.
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-cot-hdr.tt-peso.
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-cot-hdr.tt-almacenes.
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + tt-cot-hdr.tt-listaprecio.
    cRange = "Q" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + tt-cot-hdr.tt-ubigeo.
    cRange = "R" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + tt-cot-hdr.tt-dubigeo.

END.
/*  ----------------------------------------- */

IF ChbDetalleCot = YES THEN DO:

    /* Detalle total de Cotizaciones */
    chWorkSheet = chExcelApplication:Sheets:Item(3). 
    iColumn = 1.
    cColumn = STRING(iColumn).

    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Div.Origen".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Nro Cotizacion".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cod.Articulo".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "Descripcion Articulo".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "Marca".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cantidad".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "Caso".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "Precio (S/)".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "Lista".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "Nombre Cliente".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "PDD".
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "Vendedor".
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = "Tipo".
  
    FOR EACH tt-cot-dtl NO-LOCK:
        FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
                                    almmmatg.codmat = tt-cot-dtl.tt-codmat NO-LOCK NO-ERROR.
        FIND FIRST VtaListaMay WHERE VtaListaMay.codcia = s-codcia AND 
                                    VtaListaMay.coddiv = tt-cot-dtl.tt-plista AND 
                                    VtaListaMay.codmat = tt-cot-dtl.tt-codmat NO-LOCK NO-ERROR.
        iColumn = iColumn + 1.
        cColumn = STRING(iColumn).

        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-cot-dtl.tt-divi.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-cot-dtl.tt-nrocot.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-cot-dtl.tt-codmat.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = IF (AVAILABLE almmmatg) THEN almmmatg.desmat ELSE "".
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = IF (AVAILABLE almmmatg) THEN almmmatg.desmar ELSE "".
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-cot-dtl.tt-cant.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-cot-dtl.tt-caso.
        cRange = "H" + cColumn.
        IF AVAILABLE VtaListaMay THEN DO:
            chWorkSheet:Range(cRange):Value = VtaListaMay.preofi * 
                                (IF (vtalistamay.monvta = 2) THEN VtaListaMay.tpocmb ELSE 1).
        END.
        ELSE DO:
            IF AVAILABLE almmmatg THEN DO:
                chWorkSheet:Range(cRange):Value = almmmatg.prevta[1] * 
                                (IF (almmmatg.monvta = 2) THEN almmmatg.tpocmb ELSE 1).
            END.           
        END.
        
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-cot-dtl.tt-plista.       
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-cot-dtl.tt-nomclie.       
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-cot-dtl.tt-pdd.       
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-cot-dtl.tt-vend.       

        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-cot-dtl.tt-origen.
    END.
END.

SESSION:SET-WAIT-STATE('').

{lib\excel-close-file.i}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-fecha-tope wWin 
PROCEDURE ue-fecha-tope :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pFechaInicio AS DATE.
DEFINE OUTPUT PARAMETER pFechaProyectada AS DATE.

DEFINE VAR lQtyDom AS INT.
DEFINE VAR lDia AS DATE.
DEFINE VAR lCuantosDomingos AS INT.

lCuantosDomingos = 2.

lQtyDom = 0. /* Cuantos domingos paso */
DO lDia = pFechaInicio TO pFechaInicio + 100:
    pFechaProyectada = lDia.
    /* Es Domingo */
    IF WEEKDAY(lDia) = 1 THEN DO:
        lQtyDom = lQtyDom + 1.
    END.
    /* Ic - 20Ene2017, a pedido de C.Camus se cambio de 2 a 4 domingos */
    /*IF lQtyDom = 2 THEN DO:*/
    IF lQtyDom = lCuantosDomingos THEN DO:
        /* Ubico el siguiente proximo Domingo */
        LEAVE.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-proc-expocot wWin 
PROCEDURE ue-proc-expocot :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lSumaAtendida AS DEC.
DEFINE VAR lEstado AS CHAR FORMAT 'x(30)'.
DEFINE VAR lProcesadoDtl AS LOG.

FOR EACH vtatabla WHERE vtatabla.codcia = s-codcia AND 
                        vtatabla.tabla = 'EXPOCOT' NO-LOCK :
    FIND FIRST tt-cot-hdr WHERE tt-cot-hdr.tt-divi = vtatabla.llave_c4 AND
                                    tt-cot-hdr.tt-nrocot = vtatabla.llave_c3 NO-ERROR.
    /* Verifico si no ha sido procesado en el proceso regular */
    IF NOT AVAILABLE tt-cot-hdr THEN DO:
        FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND 
                                    faccpedi.coddoc = vtatabla.llave_c2 AND
                                    faccpedi.nroped = vtatabla.llave_c3 NO-ERROR.
        IF AVAILABLE faccpedi THEN DO:
            /* Solo APROBADO, ATENDIDO, x APROBAR */
            IF faccpedi.flgest <> "P" AND faccpedi.flgest <> "C"  AND faccpedi.flgest <> "E" THEN NEXT.
            txtmsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " ExpoCot - Cotizacion(" + faccpedi.nroped + ")".

            FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND gn-clie.codcli = faccpedi.codcli NO-LOCK NO-ERROR.
            lSumaAtendida = 0.
            lProcesadoDtl = NO.
            /* Detalle de las cotizaciones */
            FOR EACH facdpedi OF faccpedi NO-LOCK,
                    FIRST almmmatg OF facdpedi NO-LOCK :

                lProcesadoDtl = YES.

                FIND FIRST tt-cot-hdr WHERE tt-cot-hdr.tt-divi = faccpedi.coddiv AND
                                                tt-cot-hdr.tt-nrocot = faccpedi.nroped EXCLUSIVE NO-ERROR.

                IF NOT AVAILABLE tt-cot-hdr THEN DO:

                    /*RUN vta2/p-faccpedi-flgestv2.r(INPUT ROWID(faccpedi), OUTPUT lEstado).*/
                    CASE faccpedi.flgest:
                        WHEN 'E' THEN lEstado = "POR APROBAR".
                        WHEN 'P' THEN lEstado = "PENDIENTE".
                        WHEN 'PP' THEN lEstado = "EN PROCESO".
                        WHEN 'V' THEN lEstado = "VENCIDA".
                        WHEN 'R' THEN lEstado = "RECHAZADO".
                        WHEN 'A' THEN lEstado = "ANULADO".
                        WHEN 'C' THEN lEstado = "ATENDIDA TOTAL".
                        WHEN 'S' THEN lEstado = "SUSPENDIDA".
                        WHEN 'X' THEN lEstado = "CERRADA MANUALMENTE".
                        WHEN 'T' THEN lEstado = "EN REVISION".
                        WHEN 'ST' THEN lEstado = "SALDO TRANSFERIDO".
                    END CASE.

                    CREATE tt-cot-hdr.
                        ASSIGN tt-cot-hdr.tt-divi      = faccpedi.coddiv
                                tt-cot-hdr.tt-nrocot   = faccpedi.nroped
                                tt-cot-hdr.tt-alm      = IF(faccpedi.lugent2 = "" OR faccpedi.lugent2 = ? ) THEN txtAlmOtros ELSE faccpedi.lugent2
                                tt-cot-hdr.tt-ubigeo   = "" /*lUbigeo*/
                                tt-cot-hdr.tt-peso     = 0
                                tt-cot-hdr.tt-peso-tot = 0 /*faccpedi.libre_d02*/
                                tt-cot-hdr.tt-fchped = faccpedi.fchped
                                tt-cot-hdr.tt-fchven = faccpedi.fchven
                                tt-cot-hdr.tt-fchent = faccpedi.fchent
                                tt-cot-hdr.tt-nomcli = faccpedi.nomcli
                                tt-cot-hdr.tt-impvta = faccpedi.impvta
                                tt-cot-hdr.tt-impigv = faccpedi.impigv
                                tt-cot-hdr.tt-imptot = faccpedi.imptot
                                tt-cot-hdr.tt-flgest = lEstado
                                tt-cot-hdr.tt-avance = 0
                                tt-cot-hdr.tt-ptodsp = IF(faccpedi.lugent2 = "" OR faccpedi.lugent2 = ? ) THEN txtAlmOtros ELSE faccpedi.lugent2
                                tt-cot-hdr.tt-expocot = 'S'.
                END.        

                /* Lo Atendido */
                IF facdpedi.canate >= facdpedi.canped THEN DO:
                    lSumaAtendida = lSumaAtendida + facdpedi.implin.
                END.
                ELSE DO:
                    /* La fraccion del despacho */
                    IF facdpedi.canate > 0 THEN DO:
                        lSumaAtendida = lSumaAtendida + (ROUND((facdpedi.implin) * ROUND(facdpedi.canate / facdpedi.canped,4) , 2)).
                    END.            
                END.

                ASSIGN tt-cot-hdr.tt-peso-tot = tt-cot-hdr.tt-peso-tot + ((facdpedi.canped * facdpedi.factor) * almmmatg.pesmat).

                IF (facdpedi.canped - facdpedi.canate ) <= 0 THEN NEXT .

                ASSIGN tt-cot-hdr.tt-peso = tt-cot-hdr.tt-peso + 
                    (((facdpedi.canped - facdpedi.canate) * facdpedi.factor) * almmmatg.pesmat)
                        /*tt-cot-hdr.tt-peso-tot = tt-cot-hdr.tt-peso-tot + ((facdpedi.canped * facdpedi.factor) * almmmatg.pesmat)*/.

                /* Canal Moderno */
                IF (faccpedi.coddiv = '00017') THEN DO:
                    ASSIGN tt-cot-hdr.tt-alm = '21e'.
                END.        
                /*
                    24Ene2015 - Lucy Mesia, dejar sin efecto esta condicion
                IF (faccpedi.coddiv = '10060') THEN DO:
                    ASSIGN tt-cot-hdr.tt-alm = '60'.
                END.
                */
                FIND FIRST tt-cot-dtl WHERE tt-cot-dtl.tt-divi = faccpedi.coddiv AND
                                            tt-cot-dtl.tt-nrocot  = faccpedi.nroped AND
                                            tt-cot-dtl.tt-codmat = facdpedi.codmat EXCLUSIVE NO-ERROR.
                IF NOT AVAILABL tt-cot-dtl THEN DO:
                    CREATE tt-cot-dtl.
                        ASSIGN tt-cot-dtl.tt-divi = faccpedi.coddiv
                                tt-cot-dtl.tt-nrocot = faccpedi.nroped
                                tt-cot-dtl.tt-codmat = facdpedi.codmat
                                tt-cot-dtl.tt-cant = 0.
                END.
                ASSIGN tt-cot-dtl.tt-cant = tt-cot-dtl.tt-cant + (((facdpedi.canped - facdpedi.canate ) * 1) * 1).

            END.
            IF lProcesadoDtl = YES THEN DO:
                /* Avance */
                IF lSumaAtendida > 0 THEN DO:
                    ASSIGN tt-cot-hdr.tt-avance = ROUND((lSumaAtendida / faccpedi.imptot) * 100,2).
                END.
                ELSE ASSIGN tt-cot-hdr.tt-avance = 0.00.

                IF tt-cot-hdr.tt-avance > 0 THEN DO:
                    ASSIGN tt-cot-hdr.tt-flgest = "EN PROCESO".
                    IF tt-cot-hdr.tt-avance >= 100 THEN DO:
                        ASSIGN tt-cot-hdr.tt-flgest = "ATENDIDA TOTAL".
                    END.
                END.       
            END.
        END.
    END.
END.
/*
/* Sumando las Cotizaciones que no esten anuladas */
FOR EACH faccpedi WHERE faccpedi.codcia = s-codcia AND 
    faccpedi.coddoc = 'COT' AND 
    (faccpedi.fchped  >= txtDesde AND faccpedi.fchped <= lFechaActual ) AND
    faccpedi.fchent <= lFechaTope AND 
    /*faccpedi.nroped = '018143024' AND */
    LOOKUP (faccpedi.coddiv,lDivisiones) > 0 NO-LOCK :

    /* Lista de Precio */
    IF LOOKUP(faccpedi.libre_c01,txtlistaPrecio) = 0  THEN NEXT.

    /* Cotizaciones de Pruebas */
    IF substring(faccpedi.codcli,1,3) = 'SYS' THEN NEXT.  

    /* Solo APROBADO, ATENDIDO, x APROBAR */
    IF faccpedi.flgest <> "P" AND faccpedi.flgest <> "C"  AND faccpedi.flgest <> "E" THEN NEXT .

    txtmsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Cotizacion(" + faccpedi.nroped + ")".

    FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND gn-clie.codcli = faccpedi.codcli NO-LOCK NO-ERROR.

    /* Ubigeo segun el Cliente */
    /*
    lUbigeo = "".
    IF AVAILABLE gn-clie THEN DO:
        lUbigeo = IF (gn-clie.coddept = ? OR trim(gn-clie.coddept)="") THEN "XX" ELSE gn-clie.coddept.
        lUbigeo = lUbigeo + IF (gn-clie.codprov = ? OR trim(gn-clie.codprov)="") THEN "XX" ELSE gn-clie.codprov.
        lUbigeo = lUbigeo + IF (gn-clie.coddist = ? OR trim(gn-clie.coddist)="") THEN "XX" ELSE gn-clie.coddist.
    END.   
    lUbigeoX = REPLACE(lUbigeo,"X","").
    
    FIND FIRST ubigeo WHERE ubgCod = lUbigeo NO-LOCK NO-ERROR.
    */

    /* */
    lSumaAtendida = 0.
    lProcesadoDtl = NO.
    /* Detalle de las cotizaciones */
    FOR EACH facdpedi OF faccpedi NO-LOCK,
            FIRST almmmatg OF facdpedi NO-LOCK :

        lProcesadoDtl = YES.

        FIND FIRST tt-cot-hdr WHERE tt-cot-hdr.tt-divi = faccpedi.coddiv AND
                                        tt-cot-hdr.tt-nrocot = faccpedi.nroped EXCLUSIVE NO-ERROR.

        IF NOT AVAILABLE tt-cot-hdr THEN DO:

            /*RUN vta2/p-faccpedi-flgestv2.r(INPUT ROWID(faccpedi), OUTPUT lEstado).*/
            CASE faccpedi.flgest:
                WHEN 'E' THEN lEstado = "POR APROBAR".
                WHEN 'P' THEN lEstado = "PENDIENTE".
                WHEN 'PP' THEN lEstado = "EN PROCESO".
                WHEN 'V' THEN lEstado = "VENCIDA".
                WHEN 'R' THEN lEstado = "RECHAZADO".
                WHEN 'A' THEN lEstado = "ANULADO".
                WHEN 'C' THEN lEstado = "ATENDIDA TOTAL".
                WHEN 'S' THEN lEstado = "SUSPENDIDA".
                WHEN 'X' THEN lEstado = "CERRADA MANUALMENTE".
                WHEN 'T' THEN lEstado = "EN REVISION".
                WHEN 'ST' THEN lEstado = "SALDO TRANSFERIDO".
            END CASE.

            CREATE tt-cot-hdr.
                ASSIGN tt-cot-hdr.tt-divi      = faccpedi.coddiv
                        tt-cot-hdr.tt-nrocot   = faccpedi.nroped
                        tt-cot-hdr.tt-alm      = IF(faccpedi.lugent2 = "" OR faccpedi.lugent2 = ? ) THEN txtAlmOtros ELSE faccpedi.lugent2
                        tt-cot-hdr.tt-ubigeo   = "" /*lUbigeo*/
                        tt-cot-hdr.tt-peso     = 0
                        tt-cot-hdr.tt-peso-tot = 0 /*faccpedi.libre_d02*/
                        tt-cot-hdr.tt-fchped = faccpedi.fchped
                        tt-cot-hdr.tt-fchven = faccpedi.fchven
                        tt-cot-hdr.tt-fchent = faccpedi.fchent
                        tt-cot-hdr.tt-nomcli = faccpedi.nomcli
                        tt-cot-hdr.tt-impvta = faccpedi.impvta
                        tt-cot-hdr.tt-impigv = faccpedi.impigv
                        tt-cot-hdr.tt-imptot = faccpedi.imptot
                        tt-cot-hdr.tt-flgest = lEstado
                        tt-cot-hdr.tt-avance = 0
                        tt-cot-hdr.tt-ptodsp = IF(faccpedi.lugent2 = "" OR faccpedi.lugent2 = ? ) THEN txtAlmOtros ELSE faccpedi.lugent2 /*faccpedi.lugent2*/.
        END.        

        /* Lo Atendido */
        IF facdpedi.canate >= facdpedi.canped THEN DO:
            lSumaAtendida = lSumaAtendida + facdpedi.implin.
        END.
        ELSE DO:
            /* La fraccion del despacho */
            IF facdpedi.canate > 0 THEN DO:
                lSumaAtendida = lSumaAtendida + (ROUND((facdpedi.implin) * ROUND(facdpedi.canate / facdpedi.canped,4) , 2)).
            END.            
        END.
        
        ASSIGN tt-cot-hdr.tt-peso-tot = tt-cot-hdr.tt-peso-tot + ((facdpedi.canped * facdpedi.factor) * almmmatg.pesmat).

        IF (facdpedi.canped - facdpedi.canate ) <= 0 THEN NEXT .

        ASSIGN tt-cot-hdr.tt-peso = tt-cot-hdr.tt-peso + 
            (((facdpedi.canped - facdpedi.canate) * facdpedi.factor) * almmmatg.pesmat)
                /*tt-cot-hdr.tt-peso-tot = tt-cot-hdr.tt-peso-tot + ((facdpedi.canped * facdpedi.factor) * almmmatg.pesmat)*/.

        /* Canal Moderno */
        IF (faccpedi.coddiv = '00017') THEN DO:
            ASSIGN tt-cot-hdr.tt-alm = '21e'.
        END.        
        /*
            24Ene2015 - Lucy Mesia, dejar sin efecto esta condicion
        IF (faccpedi.coddiv = '10060') THEN DO:
            ASSIGN tt-cot-hdr.tt-alm = '60'.
        END.
        */
        FIND FIRST tt-cot-dtl WHERE tt-cot-dtl.tt-divi = faccpedi.coddiv AND
                                    tt-cot-dtl.tt-nrocot  = faccpedi.nroped AND
                                    tt-cot-dtl.tt-codmat = facdpedi.codmat EXCLUSIVE NO-ERROR.
        IF NOT AVAILABL tt-cot-dtl THEN DO:
            CREATE tt-cot-dtl.
                ASSIGN tt-cot-dtl.tt-divi = faccpedi.coddiv
                        tt-cot-dtl.tt-nrocot = faccpedi.nroped
                        tt-cot-dtl.tt-codmat = facdpedi.codmat
                        tt-cot-dtl.tt-cant = 0.
        END.
        /*ASSIGN tt-cot-dtl.tt-cant = tt-cot-dtl.tt-cant + (((facdpedi.canped - facdpedi.canate ) * facdpedi.factor) * facdpedi.factor).*/
        ASSIGN tt-cot-dtl.tt-cant = tt-cot-dtl.tt-cant + (((facdpedi.canped - facdpedi.canate ) * 1) * 1).

    END.
    IF lProcesadoDtl = YES THEN DO:
        /* Avance */
        IF lSumaAtendida > 0 THEN DO:
            ASSIGN tt-cot-hdr.tt-avance = ROUND((lSumaAtendida / faccpedi.imptot) * 100,2).
        END.
        ELSE ASSIGN tt-cot-hdr.tt-avance = 0.00.

        IF tt-cot-hdr.tt-avance > 0 THEN DO:
            ASSIGN tt-cot-hdr.tt-flgest = "EN PROCESO".
            IF tt-cot-hdr.tt-avance >= 100 THEN DO:
                ASSIGN tt-cot-hdr.tt-flgest = "ATENDIDA TOTAL".
            END.
        END.       
    END.
END.
*/

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

lFechaActual    = txtHasta.
lFechaTope      = txtFechaTope.
lDivisiones     = txtDivisiones.

RUN ue-cotizaciones.
txtmsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Generando Excel" .

RUN ue-excel.
txtmsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "...Termino" .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-transf-x-recepcionar wWin 
PROCEDURE ue-transf-x-recepcionar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


DEFINE INPUT PARAMETER pAlmacen AS CHAR    NO-UNDO.
DEFINE INPUT PARAMETER pArticulo AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pQty AS DECIMAL NO-UNDO.

RUN alm\p-articulo-en-transito (
        s-codcia,
        pAlmacen,
        pArticulo,
        INPUT-OUTPUT TABLE tmp-tabla,
        OUTPUT pQty).

/*

DEFINE VAR lFechaDesde AS DATE.
DEFINE VAR lFechaHasta AS DATE.

pQty = 0.
/* Reposiciones Automaticas aprobadas */
FOR EACH almdrepo USE-INDEX llave03 WHERE almdrepo.codcia = 1 AND almdrepo.codmat = pArticulo NO-LOCK,
        EACH almcrepo OF almdrepo WHERE almcrepo.flgest = 'P' AND 
                                (almcrepo.flgsit = 'A' OR almcrepo.flgsit = 'P') NO-LOCK:
    IF almcrepo.codalm = pAlmacen  THEN DO:
        pQty = pQty + almdrepo.canapro.
    END.
END.
/* Ordenes de Transferencias APROBABAS */
FOR EACH facdpedi USE-INDEX llave02  WHERE facdpedi.codcia = s-codcia AND 
        facdpedi.codmat = pArticulo AND facdpedi.coddoc = 'OTR' AND 
        facdpedi.flgest = 'P' NO-LOCK,
        EACH faccpedi OF facdpedi WHERE faccpedi.flgest = 'P' NO-LOCK:
    IF faccpedi.codcli = pAlmacen THEN DO:
        pQty = pQty + (facdpedi.Factor * (facdpedi.CanPed - facdpedi.canate)).
    END.    
END.

/* OTR sin RECEPCIONAR */
/*
        lSQL = "Select mh.codalm, md.codmat, md.candes, md.factor, mh.almdes " + ;
                "from pub.almdmov md " + ;
                "inner join pub.almcmov mh on(mh.codcia = 1 and mh.codalm = md.codalm and " + ;
                " mh.tipmov = md.tipmov and mh.codmov = md.codmov and " + ;
                " mh.nroser = md.nroser and mh.nrodoc = md.nrodoc ) " + ;
                "where md.codcia = 1 and md.codmat = '"+lCodMat+"' and " + ;
                " (md.fchdoc >= '"+lFecha1+"' and md.fchdoc <= '"+lFecha2+"') " + ;
                " and mh.flgest <> 'A' and mh.flgsit = 'T'"
 */
lFechaHasta = TODAY.
lFechaDesde = lFechaHasta - 90.
FOR EACH almdmov USE-INDEX almd02 WHERE almdmov.codcia = s-codcia AND almdmov.codmat = pArticulo AND 
        almdmov.fchdoc >= lFechaDesde AND almdmov.fchdoc <= lFechaHasta NO-LOCK,
    EACH almcmov OF almdmov WHERE almcmov.flgest <> 'A' AND almcmov.flgsit = 'T' NO-LOCK:
    IF almcmov.almdes = pAlmacen THEN DO:
        pQty = pQty + (almdmov.Factor * almdmov.candes).
    END.
END.

*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

