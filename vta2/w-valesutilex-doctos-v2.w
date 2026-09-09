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
DEFINE SHARED VAR s-codcia AS INT.

DEFINE VAR lxFileXls AS CHAR.
DEFINE TEMP-TABLE tt-ccbcdocu
    FIELDS fchdoc LIKE ccbcdocu.fchdoc  COLUMN-LABEL "Fecha Emision"
    FIELDS nrodoc LIKE ccbcdocu.nrodoc  COLUMN-LABEL "Nro.Fac.Interna"
    FIELDS codcli LIKE ccbcdocu.codcli  COLUMN-LABEL "CodigoCliente"
    FIELDS nomcli LIKE ccbcdocu.nomcli  COLUMN-LABEL "Nombre del Cliente"
    FIELDS candes LIKE ccbddocu.candes  COLUMN-LABEL "Cantidad"
    FIELDS PreUni LIKE ccbddocu.PreUni  COLUMN-LABEL "Denominacion"
    FIELDS implin LIKE ccbddocu.implin  COLUMN-LABEL "Total"
    FIELDS entregado AS DATE        COLUMN-LABEL "Entregado"
    FIELDS Activado AS DATE         COLUMN-LABEL "Activado"
    FIELDS nrodel AS INT INIT 0     COLUMN-LABEL "Desde"
    FIELDS nroal AS INT INIT 0     COLUMN-LABEL "Hasta".

DEFINE VAR x-campana AS INT.

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
&Scoped-define BROWSE-NAME BROWSE-4

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES VtaCTickets

/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 VtaCTickets.Producto ~
VtaCTickets.Libre_c05 year(VtaCTickets.FchFin) @ x-campana ~
VtaCTickets.FchIni VtaCTickets.FchFin 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4 
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH VtaCTickets ~
      WHERE vtactickets.codcia = s-codcia and  ~
vtactickets.codpro = '10003814' NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY BROWSE-4 FOR EACH VtaCTickets ~
      WHERE vtactickets.codcia = s-codcia and  ~
vtactickets.codpro = '10003814' NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-4 VtaCTickets
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 VtaCTickets


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-BROWSE-4}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-4 txtDesde txtHasta BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS txtDesde txtHasta txtProveedor txtProducto 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Aceptar" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE txtDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtProducto AS CHARACTER FORMAT "X(6)":U 
     LABEL "Producto" 
     VIEW-AS FILL-IN 
     SIZE 7 BY 1
     FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE txtProveedor AS CHARACTER FORMAT "X(80)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 49.14 BY 1
     FGCOLOR 4  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-4 FOR 
      VtaCTickets SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 wWin _STRUCTURED
  QUERY BROWSE-4 NO-LOCK DISPLAY
      VtaCTickets.Producto FORMAT "x(8)":U COLUMN-FGCOLOR 4 COLUMN-FONT 6
      VtaCTickets.Libre_c05 COLUMN-LABEL "Proveedor" FORMAT "x(60)":U
            WIDTH 33.86
      year(VtaCTickets.FchFin) @ x-campana COLUMN-LABEL "Campaña" FORMAT "9999":U
      VtaCTickets.FchIni FORMAT "99/99/9999":U
      VtaCTickets.FchFin FORMAT "99/99/9999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 74 BY 7.31 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     BROWSE-4 AT ROW 2.15 COL 4 WIDGET-ID 200
     txtDesde AT ROW 9.85 COL 20 COLON-ALIGNED WIDGET-ID 2
     txtHasta AT ROW 9.85 COL 42.86 COLON-ALIGNED WIDGET-ID 4
     txtProveedor AT ROW 11.5 COL 28.86 COLON-ALIGNED WIDGET-ID 14
     txtProducto AT ROW 11.58 COL 10.72 COLON-ALIGNED WIDGET-ID 12
     BUTTON-1 AT ROW 13.31 COL 64 WIDGET-ID 6
     "Seleccione el producto" VIEW-AS TEXT
          SIZE 73.86 BY 1.04 AT ROW 1.08 COL 4 WIDGET-ID 8
          BGCOLOR 9 FGCOLOR 15 FONT 11
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80.29 BY 13.92 WIDGET-ID 100.


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
         TITLE              = "Listado de Documentos emitidos - VALES UTILEX"
         HEIGHT             = 13.92
         WIDTH              = 80.29
         MAX-HEIGHT         = 39.12
         MAX-WIDTH          = 274.29
         VIRTUAL-HEIGHT     = 39.12
         VIRTUAL-WIDTH      = 274.29
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
/* BROWSE-TAB BROWSE-4 TEXT-1 fMain */
/* SETTINGS FOR FILL-IN txtProducto IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtProveedor IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _TblList          = "INTEGRAL.VtaCTickets"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "vtactickets.codcia = s-codcia and 
vtactickets.codpro = '10003814'"
     _FldNameList[1]   > INTEGRAL.VtaCTickets.Producto
"VtaCTickets.Producto" ? ? "character" ? 4 6 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.VtaCTickets.Libre_c05
"VtaCTickets.Libre_c05" "Proveedor" ? "character" ? ? ? ? ? ? no ? no no "33.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"year(VtaCTickets.FchFin) @ x-campana" "Campaña" "9999" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = INTEGRAL.VtaCTickets.FchIni
     _FldNameList[5]   = INTEGRAL.VtaCTickets.FchFin
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* Listado de Documentos emitidos - VALES UTILEX */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Listado de Documentos emitidos - VALES UTILEX */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-4
&Scoped-define SELF-NAME BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-4 wWin
ON ENTRY OF BROWSE-4 IN FRAME fMain
DO:
    IF AVAILABLE vtactickets THEN DO:
        txtProducto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = vtactickets.producto.
        txtProveedor:SCREEN-VALUE IN FRAME {&FRAME-NAME} = vtactickets.libre_c05.
    END.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-4 wWin
ON VALUE-CHANGED OF BROWSE-4 IN FRAME fMain
DO:
    IF AVAILABLE vtactickets THEN DO:
        txtProducto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = vtactickets.producto.
        txtProveedor:SCREEN-VALUE IN FRAME {&FRAME-NAME} = vtactickets.libre_c05.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 wWin
ON CHOOSE OF BUTTON-1 IN FRAME fMain /* Aceptar */
DO:
  ASSIGN txtDesde txtHasta txtProducto .

  IF txtDesde > txtHasta THEN DO:
      MESSAGE "Rango de Fechas Errado".
      RETURN NO-APPLY.
  END.

  DEFINE VAR rpta AS LOG.

        SYSTEM-DIALOG GET-FILE lxFileXls
            FILTERS 'Excel (*.xlsx)' '*.xlsx'
            ASK-OVERWRITE
            CREATE-TEST-FILE
            DEFAULT-EXTENSION '.xlsx'
            RETURN-TO-START-DIR
            SAVE-AS
            TITLE 'Exportar a Excel'
            UPDATE rpta.
        IF rpta = NO OR lxFileXls = '' THEN RETURN.

      
  RUN ue-procesar.

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
  DISPLAY txtDesde txtHasta txtProveedor txtProducto 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE BROWSE-4 txtDesde txtHasta BUTTON-1 
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
  txtDesde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(NOW,"99/99/9999").
  txtHasta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(NOW,"99/99/9999").


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-carga-temporal wWin 
PROCEDURE ue-carga-temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE BUFFER i-faccpedi FOR faccpedi.
DEFINE BUFFER ii-faccpedi FOR faccpedi.

DEFINE VAR lxEntregado AS DATE.
DEFINE VAR lxActivado AS DATE.
DEFINE VAR x-nrovale AS CHAR.
DEFINE VAR x-work AS LOG INIT NO.

SESSION:SET-WAIT-STATE('GENERAL').

EMPTY TEMP-TABLE tt-ccbcdocu.

IF txtProducto <> '0007' THEN DO:
    FOR EACH ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND 
                            ccbcdocu.coddoc = 'FAI' AND                         
                            (ccbcdocu.fchdoc >= txtDesde AND ccbcdocu.fchdoc <= txtHasta) AND
                            ccbcdocu.flgest <> 'A' NO-LOCK,
            EACH ccbddocu OF ccbcdocu NO-LOCK , 
        FIRST i-faccpedi WHERE i-faccpedi.codcia = s-codcia AND
                                i-faccpedi.coddoc = ccbcdocu.codped AND 
                                i-faccpedi.nroped = ccbcdocu.nroped
                                NO-LOCK,
        FIRST ii-faccpedi WHERE ii-faccpedi.codcia = s-codcia AND
                                ii-faccpedi.coddoc = i-faccpedi.codref AND 
                                ii-faccpedi.nroped = i-faccpedi.nroref AND
                                ii-faccpedi.tpoped = 'VU' /* ValesUtilex */
                                NO-LOCK :

        lxEntregado = ?.
        lxActivado = ?.
        IF NUM-ENTRIES(ccbcdocu.sede,"|") > 1 THEN lxEntregado = DATE(ENTRY(2,ccbcdocu.sede,"|")).
        IF NUM-ENTRIES(ccbcdocu.nroast,"|") > 1 THEN lxActivado = DATE(ENTRY(2,ccbcdocu.nroast,"|")).

        /* Verificamos que el Ticket sea del producto seleccionado */
        x-nrovale = STRING(ccbddocu.impdcto_adelanto[1],"999999999").
        FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND 
                                    vtatabla.tabla = "VUTILEXTCK" AND 
                                    vtatabla.llave_c2 = '10003814' AND
                                    vtatabla.llave_c3 = txtProducto AND
                                    vtatabla.llave_c5 = x-nrovale 
                                    NO-LOCK NO-ERROR.
        IF AVAILABLE vtatabla THEN DO:
            x-work = YES.
            CREATE tt-ccbcdocu.
                ASSIGN  tt-ccbcdocu.fchdoc  = ccbcdocu.fchdoc
                        tt-ccbcdocu.nrodoc  = ccbcdocu.nrodoc
                        tt-ccbcdocu.codcli  = ccbcdocu.codcli
                        tt-ccbcdocu.nomcli  = ccbcdocu.nomcli
                        tt-ccbcdocu.candes  = ccbddocu.candes
                        tt-ccbcdocu.PreUni  = ccbddocu.Preuni
                        tt-ccbcdocu.implin  = ccbddocu.implin
                        tt-ccbcdocu.Entregado   = lxEntregado
                        tt-ccbcdocu.Activado    = lxActivado
                        tt-ccbcdocu.nrodel   = ccbddocu.impdcto_adelanto[1]
                        tt-ccbcdocu.nroal   = ccbddocu.impdcto_adelanto[2].
        END.               
    END.
END.
IF x-work = NO THEN DO:

    DEFINE BUFFER x-vtatabla FOR vtatabla.
    DEFINE VAR x-sec AS INT INIT 0.

    FOR EACH vtatabla WHERE vtatabla.codcia = s-codcia AND 
                            vtatabla.tabla = 'VUTILEX' AND
                            vtatabla.libre_c03 = "DETALLE" AND
                            vtatabla.llave_c2 = '10003814' AND
                            vtatabla.llave_c3 = txtProducto NO-LOCK:

        IF (DATE(vtatabla.llave_c7) >= txtDesde AND DATE(vtatabla.llave_c7) <= txtHasta ) THEN DO:
            x-sec = 0.
            FOR EACH x-vtatabla WHERE x-vtatabla.codcia = vtatabla.codcia AND 
                                        x-vtatabla.tabla = 'VUTILEXTCK' AND
                                        x-vtatabla.llave_c2 = vtatabla.llave_c2 AND
                                        x-vtatabla.llave_c3 = vtatabla.llave_c3 AND 
                                        x-vtatabla.llave_c4 = vtatabla.llave_c4 AND     /* Valor */
                                        x-vtatabla.llave_c6 = vtatabla.llave_c1 AND
                                        (x-vtatabla.libre_c01 <> ? OR x-vtatabla.libre_c01 <> '') AND
                                        (x-vtatabla.libre_c03 <> ? OR x-vtatabla.libre_c03 <> 'ANULADO') 
                                        NO-LOCK :
                   x-sec = x-sec + 1.                     
            END.
            IF x-sec > 0 THEN DO:
                CREATE tt-ccbcdocu.
                    ASSIGN  tt-ccbcdocu.fchdoc  = DATE(vtatabla.llave_c7)
                            tt-ccbcdocu.nrodoc  = ""
                            tt-ccbcdocu.codcli  = vtatabla.libre_c01
                            tt-ccbcdocu.nomcli  = vtatabla.libre_c02
                            tt-ccbcdocu.candes  = x-sec
                            tt-ccbcdocu.PreUni  = INTEGER(vtatabla.llave_c4) / 100
                            tt-ccbcdocu.implin  = tt-ccbcdocu.PreUni * x-sec
                            tt-ccbcdocu.Entregado   = DATE(vtatabla.llave_c7)
                            tt-ccbcdocu.Activado    = DATE(vtatabla.llave_c7)
                            tt-ccbcdocu.nrodel   = INTEGER(vtatabla.llave_c5)
                            tt-ccbcdocu.nroal   = INTEGER(vtatabla.llave_c6).
            END.
        END.
    END.
END.



RELEASE i-faccpedi.
RELEASE ii-faccpedi.

SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-procesar wWin 
PROCEDURE ue-procesar PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN ue-carga-temporal.

FIND FIRST tt-ccbcdocu NO-LOCK NO-ERROR.

IF NOT AVAILABLE tt-ccbcdocu THEN DO:
    MESSAGE "No existe DATA".
    RETURN "ADM-ERROR".
END.

DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */

c-xls-file = lxFileXls.

run pi-crea-archivo-csv IN hProc (input  buffer tt-ccbcdocu:handle,
                        c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer tt-ccbcdocu:handle,
                        input  c-csv-file,
                        output c-xls-file) .

DELETE PROCEDURE hProc.

MESSAGE "Proceso Concluido".

/*
DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.
DEFINE VAR cValue AS CHAR.

DEFINE VAR lxEntregado AS CHAR.
DEFINE VAR lxActivado AS CHAR.

lFileXls = "".          /* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */
lNuevoFile = YES.       /* YES : Si va crear un nuevo archivo o abrir */
        

{lib\excel-open-file.i}

chExcelApplication:Visible = YES.

lMensajeAlTerminar = YES. /*  */
lCerrarAlTerminar = NO. /* Si permanece abierto el Excel luego de concluir el proceso */

chWorkSheet = chExcelApplication:Sheets:Item(1). 
iColumn = 1.
cRange = "A" + TRIM(STRING(iColumn)).
chWorkSheet:Range(cRange):VALUE = "Fecha Emision".
cRange = "B" + TRIM(STRING(iColumn)).
chWorkSheet:Range(cRange):VALUE = "Nro.Fac.Interna".
cRange = "C" + TRIM(STRING(iColumn)).
chWorkSheet:Range(cRange):VALUE = "CodigoCliente".
cRange = "D" + TRIM(STRING(iColumn)).
chWorkSheet:Range(cRange):VALUE = "Nombre del Cliente".
cRange = "E" + TRIM(STRING(iColumn)).
chWorkSheet:Range(cRange):VALUE = "Cantidad".
cRange = "F" + TRIM(STRING(iColumn)).
chWorkSheet:Range(cRange):VALUE = "Denominacion".
cRange = "G" + TRIM(STRING(iColumn)).
chWorkSheet:Range(cRange):VALUE = "Total".
cRange = "H" + TRIM(STRING(iColumn)).
chWorkSheet:Range(cRange):VALUE = "Entregado".
cRange = "I" + TRIM(STRING(iColumn)).
chWorkSheet:Range(cRange):VALUE = "Activado".
cRange = "J" + TRIM(STRING(iColumn)).
chWorkSheet:Range(cRange):VALUE = "Desde".
cRange = "K" + TRIM(STRING(iColumn)).
chWorkSheet:Range(cRange):VALUE = "Hasta".

SESSION:SET-WAIT-STATE('GENERAL').

iColumn = 2.

FOR EACH ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND 
                        ccbcdocu.coddoc = 'FAI' AND                         
                        (ccbcdocu.fchdoc >= txtDesde AND ccbcdocu.fchdoc <= txtHasta) AND
                        ccbcdocu.flgest <> 'A' NO-LOCK,
        EACH ccbddocu OF ccbcdocu NO-LOCK , 
        FIRST i-faccpedi WHERE i-faccpedi.codcia = s-codcia AND
                                i-faccpedi.coddoc = ccbcdocu.codped AND 
                                i-faccpedi.nroped = ccbcdocu.nroped
                                NO-LOCK,
        FIRST ii-faccpedi WHERE ii-faccpedi.codcia = s-codcia AND
                                ii-faccpedi.coddoc = i-faccpedi.codref AND 
                                ii-faccpedi.nroped = i-faccpedi.nroref AND
                                ii-faccpedi.tpoped = 'VU' /* ValesUtilex */
                                NO-LOCK :

    lxEntregado = ''.
    lxActivado = ''.

    IF NUM-ENTRIES(ccbcdocu.sede,"|") > 1 THEN lxEntregado = ENTRY(2,ccbcdocu.sede,"|").
    IF NUM-ENTRIES(ccbcdocu.nroast,"|") > 1 THEN lxActivado = ENTRY(2,ccbcdocu.nroast,"|").

            cRange = "A" + TRIM(STRING(iColumn)).
            chWorkSheet:Range(cRange):VALUE = ccbcdocu.fchdoc.
            cRange = "B" + TRIM(STRING(iColumn)).
            chWorkSheet:Range(cRange):VALUE = "'" + ccbcdocu.nrodoc.
            cRange = "C" + TRIM(STRING(iColumn)).
            chWorkSheet:Range(cRange):VALUE = "'" + ccbcdocu.codcli.
            cRange = "D" + TRIM(STRING(iColumn)).
            chWorkSheet:Range(cRange):VALUE = "'" + ccbcdocu.nomcli.
            cRange = "E" + TRIM(STRING(iColumn)).
            chWorkSheet:Range(cRange):VALUE = ccbddocu.candes.
            cRange = "F" + TRIM(STRING(iColumn)).
            chWorkSheet:Range(cRange):VALUE = ccbddocu.PreUni.
            cRange = "G" + TRIM(STRING(iColumn)).
            chWorkSheet:Range(cRange):VALUE = ccbddocu.implin.
            cRange = "H" + TRIM(STRING(iColumn)).
            chWorkSheet:Range(cRange):VALUE = lxEntregado.
            cRange = "I" + TRIM(STRING(iColumn)).
            chWorkSheet:Range(cRange):VALUE = lxActivado.
            cRange = "J" + TRIM(STRING(iColumn)).
            chWorkSheet:Range(cRange):VALUE = ccbddocu.impdcto_adelanto[1].
            cRange = "K" + TRIM(STRING(iColumn)).
            chWorkSheet:Range(cRange):VALUE = ccbddocu.impdcto_adelanto[2].

        iColumn = iColumn + 1.
    
END.

SESSION:SET-WAIT-STATE('').

{lib\excel-close-file.i}

RELEASE i-faccpedi.
RELEASE ii-faccpedi.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

