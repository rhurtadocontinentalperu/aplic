&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER PEDIDO FOR FacCPedi.
DEFINE BUFFER PRODUCTOS FOR Almmmatg.
DEFINE TEMP-TABLE TDivision NO-UNDO LIKE GN-DIVI.



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

{lib/tt-file.i}


/* VARIABLES PARA EL RESUMEN */
DEF VAR x-CuentaReg  AS INT             NO-UNDO.    /* Contador de registros */
DEF VAR x-MuestraReg AS INT             NO-UNDO.    /* Tope para mostrar registros */

/* VARIABLES PARA EL EXCEL O TEXTO */
DEF VAR iContador AS INT NO-UNDO.
DEF VAR iLimite   AS INT NO-UNDO.

/* Configuracion de opciones del reporte por usuario */
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR pv-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-aplic-id AS CHAR.

/* TABLA GENERAL ACUMULADOS */

DEF VAR pOptions AS CHAR.
DEF VAR pArchivo AS CHAR.
DEF VAR cArchivo AS CHAR.
DEF VAR zArchivo AS CHAR.
DEF VAR cComando AS CHAR.
DEF VAR pDirectorio AS CHAR.
DEF VAR lOptions AS CHAR.
DEF VAR cListaDivisiones AS CHAR.

DEF VAR x-Cuenta AS INT NO-UNDO.

DEFINE BUFFER b-ccbcdocu FOR ccbcdocu.
DEFINE BUFFER b-ccbddocu FOR ccbddocu.

DEF TEMP-TABLE detalle
    FIELD coddiv    AS CHAR                             COLUMN-LABEL 'División'
    FIELD listaprecio AS CHAR FORMAT "x(6)"             COLUMN-LABEL "Lista de Precio"
    FIELD nroped    AS CHAR     FORMAT '999999999'      COLUMN-LABEL 'Cotizacion'
    FIELD fchped    AS DATE     FORMAT '99/99/9999'     COLUMN-LABEL 'Emision'
    FIELD fchven    AS DATE     FORMAT '99/99/9999'     COLUMN-LABEL 'Vencimiento'
    FIELD fchent    AS DATE     FORMAT '99/99/9999'     COLUMN-LABEL 'Entrega'
    FIELD fmapgo    AS CHAR     FORMAT "x(50)"          COLUMN-LABEL "Forma de Pago"
    FIELD codcli    AS CHAR                             COLUMN-LABEL 'Cliente'
    FIELD clfcli    AS CHAR                             COLUMN-LABEL 'Clasificación'
    FIELD codven    AS CHAR                             COLUMN-LABEL 'Vendedor'
    FIELD codmat    AS CHAR                             COLUMN-LABEL 'Producto'
    FIELD desmar    AS CHAR                             COLUMN-LABEL 'Marca'
    FIELD codfam    AS CHAR                             COLUMN-LABEL 'Linea'
    FIELD subfam    AS CHAR                             COLUMN-LABEL 'SubLinea'
    FIELD undvta    LIKE facdpedi.undvta                COLUMN-LABEL 'Unidad'
    FIELD canped    AS DEC FORMAT "->>>,>>9.99"         COLUMN-LABEL 'Cantidad Pedida'
    FIELD implin    AS DEC FORMAT "->>>,>>9.99"         COLUMN-LABEL 'Importe'
    FIELD canate    AS DEC FORMAT "->>>,>>9.99"         COLUMN-LABEL 'Cantidad Atendida'
    FIELD impate AS DEC FORMAT '->>>,>>>,>>9.99'        COLUMN-LABEL 'Importe Atendido'
    FIELD saldo  AS DEC FORMAT '->>>,>>>,>>9.99'        COLUMN-LABEL 'Cantidad Pendiente'
    FIELD impsal AS DEC FORMAT '->>>,>>>,>>9.99'        COLUMN-LABEL 'Importe Pendiente'
    FIELD canfac AS DEC FORMAT '->>>,>>>,>>9.99'        COLUMN-LABEL 'Cantidad Facturada'
    FIELD impfac AS DEC FORMAT '->>>,>>>,>>9.99'        COLUMN-LABEL 'Importe Facturado'
    FIELD flgest    AS CHAR                             COLUMN-LABEL 'Estado'
    FIELD coddept   AS CHAR                             COLUMN-LABEL 'Departamento'
    FIELD codprov   AS CHAR                             COLUMN-LABEL 'Provincia'
    FIELD coddist   AS CHAR                             COLUMN-LABEL 'Distrito'
    FIELD codpro    AS CHAR                             COLUMN-LABEL 'Proveedor Producto'
    FIELD pesmat    AS DEC FORMAT ">>,>>9.9999"         COLUMN-LABEL "Peso Unitario"
    FIELD volumen   AS DEC FORMAT ">>,>>9.9999"         COLUMN-LABEL "Vol.Unitario"
    FIELD licencia  AS CHAR                             COLUMN-LABEL 'Licencia'
    FIELD FlagAut   AS CHAR FORMAT 'x(20)'              COLUMN-LABEL 'Línea de Crédito'
    INDEX llave01 AS PRIMARY nroped codmat
    INDEX llave02 nroped codcli codfam subfam
    INDEX llave03 nroped codcli
    INDEX llave04 nroped codven codcli codmat.

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
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES TDivision

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 TDivision.CodDiv TDivision.DesDiv 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define QUERY-STRING-BROWSE-1 FOR EACH TDivision NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH TDivision NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 TDivision
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 TDivision


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-1 FILL-IN-Fecha-1 FILL-IN-Fecha-2 ~
COMBO-BOX-Lista BUTTON-1 BtnDone 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Mensaje FILL-IN-Fecha-1 ~
FILL-IN-Fecha-2 COMBO-BOX-Lista 

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
     SIZE 6 BY 1.62 TOOLTIP "Salir"
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 1" 
     SIZE 6 BY 1.62 TOOLTIP "MIgrar a Excel".

DEFINE VARIABLE COMBO-BOX-Lista AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Lista de Precios" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todas" 
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .77 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .77 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      TDivision SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 wWin _STRUCTURED
  QUERY BROWSE-1 NO-LOCK DISPLAY
      TDivision.CodDiv COLUMN-LABEL "División" FORMAT "XX-XXX":U
      TDivision.DesDiv FORMAT "X(40)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 53 BY 7.69
         FONT 4
         TITLE "SELECCIONE LA(S) DIVISION(ES)" ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     BROWSE-1 AT ROW 3.15 COL 4 WIDGET-ID 200
     FILL-IN-Mensaje AT ROW 11 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 102
     FILL-IN-Fecha-1 AT ROW 1.27 COL 7 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-Fecha-2 AT ROW 2.08 COL 7 COLON-ALIGNED WIDGET-ID 112
     COMBO-BOX-Lista AT ROW 2.08 COL 36 COLON-ALIGNED WIDGET-ID 20
     BUTTON-1 AT ROW 1.27 COL 61 WIDGET-ID 24
     BtnDone AT ROW 1.27 COL 67 WIDGET-ID 28
     "..." VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 10.81 COL 81 WIDGET-ID 114
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 118.57 BY 11.92
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE APPSERVER
   Temp-Tables and Buffers:
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
      TABLE: PRODUCTOS B "?" ? INTEGRAL Almmmatg
      TABLE: TDivision T "?" NO-UNDO INTEGRAL GN-DIVI
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "ESTADISTICAS DE COTIZACIONES"
         HEIGHT             = 12
         WIDTH              = 75.72
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
   FRAME-NAME L-To-R,COLUMNS                                            */
/* BROWSE-TAB BROWSE-1 TEXT-1 fMain */
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "Temp-Tables.TDivision"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.TDivision.CodDiv
"TDivision.CodDiv" "División" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = Temp-Tables.TDivision.DesDiv
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* ESTADISTICAS DE COTIZACIONES */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* ESTADISTICAS DE COTIZACIONES */
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


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 wWin
ON CHOOSE OF BUTTON-1 IN FRAME fMain /* Button 1 */
DO:
    ASSIGN
        FILL-IN-Fecha-1 FILL-IN-Fecha-2 pOptions = "" COMBO-BOX-Lista.
    /* CONSISTENCIA */
    IF browse-1:NUM-SELECTED-ROWS = 0 THEN DO:
        MESSAGE 'Debe seleccionar al menos una Divisón' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

    RUN Excel.

    MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.
    {&OPEN-QUERY-BROWSE-1}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
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

DEF VAR k AS INT NO-UNDO.
DEF VAR x-NomPro LIKE gn-prov.nompro NO-UNDO.
DEF VAR x-NomVen LIKE gn-ven.nomven NO-UNDO.
DEF VAR x-CodDept AS CHAR NO-UNDO.
DEF VAR x-CodProv AS CHAR NO-UNDO.
DEF VAR x-CodDist AS CHAR NO-UNDO.
DEF VAR x-Estado  AS CHAR NO-UNDO.

EMPTY TEMP-TABLE Detalle.
x-Cuenta = 0.
ESTADISTICAS:
DO k = 1 TO {&browse-name}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
    IF {&browse-name}:FETCH-SELECTED-ROW(k) THEN DO:
        FOR EACH faccpedi NO-LOCK WHERE faccpedi.codcia = s-codcia
            AND faccpedi.coddiv = TDivision.CodDiv 
            AND faccpedi.coddoc = 'COT' 
            AND faccpedi.fchped >= FILL-IN-Fecha-1 
            AND faccpedi.fchped <= FILL-IN-Fecha-2
            AND (COMBO-BOX-Lista = 'Todas' OR FacCPedi.Libre_C01 = COMBO-BOX-Lista),
            FIRST gn-clie NO-LOCK WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = faccpedi.codcli:
            IF CAPS(faccpedi.usuario) = 'ADMIN' OR CAPS(SUBSTRING(faccpedi.codcli,1,3))="SYS" THEN NEXT.
            /* Fin 04Nov2014 - Ic */
            IF Faccpedi.flgest = "A" OR Faccpedi.flgest = "W" THEN NEXT.
            /* Ic - 24Ago2017, Pedidos de PRUEBA no van */
            IF CAPS(SUBSTRING(faccpedi.codcli,1,3))="SYS" THEN NEXT.

            FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** RESUMIENDO ** " +
                "COTIZACION " + faccpedi.nroped.
            FOR EACH facdpedi OF Faccpedi NO-LOCK, 
                FIRST Almmmatg OF Facdpedi NO-LOCK, 
                FIRST Almtfami OF Almmmatg NO-LOCK,
                FIRST Almsfami OF Almmmatg NO-LOCK,
                FIRST gn-ConVt NO-LOCK WHERE gn-ConVt.Codig = Faccpedi.fmapgo:
                CREATE detalle.
                ASSIGN
                    detalle.coddiv = faccpedi.coddiv
                    detalle.listaprecio = faccpedi.libre_c01
                    detalle.nroped = faccpedi.nroped
                    detalle.fchped = faccpedi.fchped
                    detalle.fchven = faccpedi.fchven
                    detalle.fchent = faccpedi.fchent
                    detalle.fmapgo = gn-ConVt.Codig + ' ' + gn-ConVt.Nombr
                    detalle.codcli = faccpedi.codcli + ' '  + gn-clie.nomcli
                    detalle.clfcli = gn-clie.clfcli
                    detalle.codven = faccpedi.codven
                    detalle.codmat = facdpedi.codmat + ' '  + almmmatg.desmat
                    detalle.desmar = almmmatg.desmar
                    detalle.codfam = almmmatg.codfam + ' ' + almtfami.desfam
                    detalle.subfam = almmmatg.subfam + ' ' + almsfami.dessub
                    detalle.coddept = gn-clie.CodDept 
                    detalle.codprov = gn-clie.CodProv 
                    detalle.coddist = gn-clie.CodDist
                    detalle.pesmat = almmmatg.pesmat
                    detalle.volume = almmmatg.libre_d02
                    detalle.flgest = faccpedi.flgest
                    .
                detalle.codpro  = almmmatg.codpr1.
                /* Licencia */
                FIND almtabla WHERE almtabla.Tabla = "LC" AND
                    almtabla.Codigo = Almmmatg.Licencia[1] NO-LOCK NO-ERROR.
                IF AVAILABLE almtabla THEN detalle.licencia = almtabla.Nombre.
                /* Datos faltantes */
                ASSIGN
                    x-nompro = 'NN'
                    x-nomven = 'NN'
                    x-coddept = detalle.coddept
                    x-codprov = detalle.codprov
                    x-coddist = detalle.coddist.
                FIND gn-prov WHERE gn-prov.codcia = pv-codcia
                    AND gn-prov.codpro = almmmatg.codpr1
                    NO-LOCK NO-ERROR.
                IF AVAILABLE gn-prov THEN x-nompro = gn-prov.nompro.
                FIND gn-ven WHERE gn-ven.codcia = s-codcia AND gn-ven.codven = detalle.codven NO-LOCK NO-ERROR.
                IF AVAILABLE gn-ven THEN x-nomven = gn-ven.nomven.
                FIND TabDepto WHERE TabDepto.CodDepto = detalle.coddept NO-LOCK NO-ERROR.
                IF AVAILABLE TabDepto THEN x-coddept = TRIM(x-coddept) + ' ' + TabDepto.NomDepto.
                FIND TabProvi WHERE TabProvi.CodDepto = detalle.coddept
                    AND TabProvi.CodProvi = detalle.codprov NO-LOCK NO-ERROR.
                IF AVAILABLE TabProvi THEN x-codprov = TRIM(x-codprov) + ' ' + TabProvi.NomProvi.
                FIND TabDistr WHERE TabDistr.CodDepto = detalle.coddept
                    AND TabDistr.CodProvi = detalle.codprov
                    AND TabDistr.CodDistr = detalle.coddist NO-LOCK NO-ERROR.
                IF AVAILABLE TabDistr THEN x-coddist = TRIM(x-coddist) + ' ' + TabDistr.NomDistr.
                ASSIGN
                    detalle.codpro = detalle.codpro + ' ' + x-nompro
                    detalle.codven = detalle.codven + ' ' + x-nomven
                    detalle.coddept = x-coddept
                    detalle.codprov = x-codprov
                    detalle.coddist = x-coddist
                    .
                ASSIGN
                    detalle.undvta = almmmatg.undbas        /*facdpedi.undvta*/
                    detalle.canped = facdpedi.canped * facdpedi.factor
                    detalle.canate = facdpedi.canate * facdpedi.factor
                    detalle.implin = facdpedi.implin.
                RUN vta2/p-faccpedi-flgest (detalle.flgest, "COT", OUTPUT x-Estado).
                detalle.flgest = x-Estado.

                /* Agregamos lo facturado */
                FOR EACH PEDIDO NO-LOCK WHERE PEDIDO.codcia = Faccpedi.codcia
                    AND PEDIDO.coddoc = "PED"
                    AND PEDIDO.coddiv = Faccpedi.coddiv
                    AND PEDIDO.fchped >= Faccpedi.fchped
                    AND PEDIDO.codref = Faccpedi.coddoc    /* Cotizaciones */
                    AND PEDIDO.nroref = Faccpedi.nroped
                    AND PEDIDO.flgest <> "A",
                    EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = PEDIDO.codcia
                    AND LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL') > 0
                    AND Ccbcdocu.codped = PEDIDO.coddoc
                    AND Ccbcdocu.nroped = PEDIDO.nroped
                    AND Ccbcdocu.flgest <> "A",
                    EACH Ccbddocu OF Ccbcdocu NO-LOCK WHERE Ccbddocu.codmat = Facdpedi.codmat:
                    ASSIGN
                        detalle.canfac = detalle.canfac + Ccbddocu.candes * Ccbddocu.factor
                        detalle.impfac = detalle.impfac + Ccbddocu.implin.
                    /* Ic - 09Mar2015, considerar N/C y que no esten anuladas */
                    FOR EACH b-ccbcdocu USE-INDEX llave07 WHERE b-ccbcdocu.codcia = s-codcia AND 
                        b-ccbcdocu.codref = ccbcdocu.coddoc AND 
                        b-ccbcdocu.nroref = ccbcdocu.nrodoc AND 
                        b-ccbcdocu.coddoc = 'N/C'  AND 
                        b-ccbcdocu.flgest <> 'A' NO-LOCK,
                        EACH b-ccbddocu OF b-ccbcdocu NO-LOCK WHERE b-Ccbddocu.codmat = Facdpedi.codmat :
                        ASSIGN 
                            detalle.canfac = detalle.canfac + ((Ccbddocu.candes * Ccbddocu.factor ) * -1)
                            detalle.impfac = detalle.impfac + (Ccbddocu.implin * -1).
                    END.
                END.    /* EACH PEDIDO */
                /* RHC CALCULOS FINALES */                                                                                                        
                ASSIGN 
                    detalle.saldo = detalle.canped - detalle.canate
                    detalle.impate = detalle.canate * (detalle.implin / detalle.canped)
                    detalle.impsal = detalle.saldo * (detalle.implin / detalle.canped).
                IF detalle.canate >= detalle.canped THEN
                    ASSIGN
                    detalle.impate = detalle.implin
                    detalle.canate = detalle.canped
                    detalle.saldo = 0
                    detalle.impsal = 0.
            END.    /*EACH facdpedi */
        END.    /* EACH faccpedi */
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
  DISPLAY FILL-IN-Mensaje FILL-IN-Fecha-1 FILL-IN-Fecha-2 COMBO-BOX-Lista 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE BROWSE-1 FILL-IN-Fecha-1 FILL-IN-Fecha-2 COMBO-BOX-Lista BUTTON-1 
         BtnDone 
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

DEF VAR x-Llave AS CHAR FORMAT 'x(800)' NO-UNDO.
DEF VAR x-Titulo AS CHAR FORMAT 'x(800)' NO-UNDO.
DEF VAR x-Archivo AS CHAR NO-UNDO.

/* Archivo de Salida */
DEF VAR c-csv-file AS CHAR NO-UNDO.
DEF VAR c-xls-file AS CHAR INIT 'Archivo_Excel' NO-UNDO.
DEF VAR rpta AS LOG INIT NO NO-UNDO.

SYSTEM-DIALOG GET-FILE c-xls-file
    FILTERS 'Libro de Excel' '*.xlsx'
    INITIAL-FILTER 1
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION ".xlsx"
    SAVE-AS
    TITLE "Guardar como"
    USE-FILENAME
    UPDATE rpta.
IF rpta = NO THEN RETURN.

SESSION:SET-WAIT-STATE('GENERAL').
/* Variable de memoria */
DEFINE VAR hProc AS HANDLE NO-UNDO.
/* Levantamos la libreria a memoria */
RUN lib\Tools-to-excel PERSISTENT SET hProc.
/* Cargamos la informacion al temporal */
EMPTY TEMP-TABLE Detalle.
RUN Carga-Temporal.
/* Programas que generan el Excel */
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** GENERANDO EL EXCEL **".
RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER Detalle:HANDLE,
                                  INPUT c-xls-file,
                                  OUTPUT c-csv-file) .

RUN pi-crea-archivo-xls IN hProc (INPUT BUFFER Detalle:handle,
                                  INPUT  c-csv-file,
                                  OUTPUT c-xls-file) .

/* Borramos librerias de la memoria */
DELETE PROCEDURE hProc.
SESSION:SET-WAIT-STATE('').

FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** FIN DEL PROCESO **".

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
      FILL-IN-Fecha-1 = TODAY
      FILL-IN-Fecha-2 = TODAY
      cListaDivisiones = 'Todos'.
  /* Bucamos si tiene divisiones registradas */
  FIND FIRST estavtas.EstadUserDiv WHERE estavtas.EstadUserDiv.user-id = s-user-id
      AND estavtas.EstadUserDiv.aplic-id = s-aplic-id
      NO-LOCK NO-ERROR.
  IF AVAILABLE EstadUserDiv THEN DO:
      FOR EACH EstadUserDiv NO-LOCK WHERE EstadUserDiv.user-id = s-user-id
          AND EstadUserDiv.aplic-id = s-aplic-id,
          FIRST gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia
          AND gn-divi.coddiv = estavtas.EstadUserDiv.coddiv:
          CREATE TDivision.
          BUFFER-COPY gn-divi TO TDivision.
      END.
  END.
  ELSE DO:
      FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia:
          CREATE TDivision.
          BUFFER-COPY gn-divi TO TDivision.
      END.
  END.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia AND
                            (gn-divi.campo-char[1] = 'L' OR gn-divi.campo-char[1] = 'A' )
      WITH FRAME {&FRAME-NAME}:
      COMBO-BOX-Lista:ADD-LAST(gn-divi.coddiv, '999999') NO-ERROR.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

