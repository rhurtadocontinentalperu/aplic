&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
          estavtas         PROGRESS
*/
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER PEDIDO FOR INTEGRAL.FacCPedi.
DEFINE BUFFER PRODUCTOS FOR INTEGRAL.Almmmatg.
DEFINE TEMP-TABLE TDivision NO-UNDO LIKE estavtas.DimDivision.
DEFINE TEMP-TABLE TLinea NO-UNDO LIKE estavtas.DimLinea.



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

DEF VAR s-ConCostos             AS LOG INIT NO NO-UNDO.
DEF VAR s-TodasLasDivisiones    AS LOG INIT NO NO-UNDO.
DEF VAR s-Familia010            AS LOG INIT NO NO-UNDO.

FIND EstadTabla WHERE EstadTabla.Tabla = 'EST'
    AND EstadTabla.Codigo = s-user-id
    NO-LOCK NO-ERROR.
IF AVAILABLE EstadTabla THEN
    ASSIGN
        s-ConCostos =  EstadTabla.Campo-Logical[1] 
        s-TodasLasDivisiones = EstadTabla.Campo-Logical[2] 
        s-Familia010 = EstadTabla.Campo-Logical[3].


/* TABLA GENERAL ACUMULADOS */
DEF TEMP-TABLE detalle
    FIELD coddiv AS CHAR FORMAT 'x(6)'          LABEL 'Division'
    FIELD lisbas AS CHAR FORMAT 'x(6)'          LABEL 'Lista Base'
    FIELD nroped AS CHAR FORMAT '999999999'     LABEL 'Cotizacion'
    FIELD fchped AS DATE FORMAT '99/99/9999'    LABEL 'Emision'
    FIELD fchven AS DATE FORMAT '99/99/9999'    LABEL 'Vencimiento'
    FIELD fchent AS DATE FORMAT '99/99/9999'    LABEL 'Entrega'
    FIELD fmapgo LIKE faccpedi.fmapgo           
    FIELD despgo AS CHAR FORMAT 'x(40)'         LABEL 'Forma de Pago'
    FIELD codcia AS INT         
    FIELD codcli LIKE faccpedi.codcli
    FIELD nomcli LIKE gn-clie.nomcli            LABEL 'Cliente'
    FIELD clfcli AS CHAR FORMAT 'x(5)'          LABEL 'Clasificacion'
    FIELD codven LIKE faccpedi.codven
    FIELD nomven AS CHAR FORMAT 'x(30)'         LABEL 'Vendedor'
    FIELD codpro LIKE gn-prov.codpro
    FIELD nompro LIKE gn-prov.nompro            LABEL 'Proveedor'
    FIELD codmat LIKE almmmatg.codmat           LABEL 'Producto'
    FIELD desmat AS CHAR FORMAT 'x(60)'
    FIELD desmar LIKE almmmatg.desmar           LABEL 'Marca'
    FIELD codfam LIKE almmmatg.codfam
    FIELD desfam AS CHAR FORMAT 'x(40)'         LABEL 'Linea'
    FIELD subfam LIKE almmmatg.subfam
    FIELD dessub AS CHAR FORMAT 'x(40)'         LABEL 'SubLinea'
    FIELD licencia AS CHAR FORMAT 'x(20)'       LABEL 'Licencia'
    FIELD undbas AS CHAR FORMAT 'x(6)'          LABEL 'Unidad'
    FIELD canped AS DEC FORMAT '->>>,>>>,>>9.99'        LABEL 'Cantidad Pedida'
    FIELD implin AS DEC FORMAT '->>>,>>>,>>9.99'        LABEL 'Importe'
    FIELD canate AS DEC FORMAT '->>>,>>>,>>9.99'        LABEL 'Cantidad Atendida'
    FIELD impate AS DEC FORMAT '->>>,>>>,>>9.99'        LABEL 'Importe Atendido'
    FIELD saldo  AS DEC FORMAT '->>>,>>>,>>9.99'        LABEL 'Cantidad Pendiente'
    FIELD impsal AS DEC FORMAT '->>>,>>>,>>9.99'        LABEL 'Importe Pendiente'
    FIELD canfac AS DEC FORMAT '->>>,>>>,>>9.99'        LABEL 'Cantidad Facturada'
    FIELD impfac AS DEC FORMAT '->>>,>>>,>>9.99'        LABEL 'Importe Facturado'
    FIELD flgest AS CHAR FORMAT 'x(20)'         LABEL 'Estado'
    FIELD coddept LIKE gn-clie.CodDept 
    FIELD departamento AS CHAR FORMAT 'x(20)'   LABEL 'Departamento'
    FIELD codprov LIKE gn-clie.CodProv 
    FIELD provincia AS CHAR FORMAT 'x(20)'      LABEL 'Provincia'
    FIELD coddist LIKE gn-clie.CodDist
    FIELD distrito AS CHAR FORMAT 'x(20)'       LABEL 'Distrito'
    FIELD subtipo  AS CHAR FORMAT 'x(30)'       LABEL 'SubTipo'
    FIELD pesmat AS DEC FORMAT ">>>>,>>9.9999" LABEL "Peso Unitario"
    FIELD volume AS DEC FORMAT ">>>>,>>9.9999" LABEL "Vol.Unitario"
    FIELD almsalida AS CHAR FORMAT 'x(5)' LABEL "Pto Salida"
    FIELD usuario AS CHAR FORMAT 'x(15)' LABEL 'Usuario'

    INDEX llave01 AS PRIMARY codcia nroped codmat
    INDEX llave02 codcia nroped codcli codfam subfam
    INDEX llave03 codcia nroped codcli
    INDEX llave04 codcia nroped codven codcli codmat.

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
RADIO-SET-1 BUTTON-1 BtnDone 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Mensaje FILL-IN-Fecha-1 ~
FILL-IN-Fecha-2 RADIO-SET-1 

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

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Resumen por Producto", 1,
"Resumen por Cliente vs Lineas", 2,
"Resumen por Cliente", 3,
"Resumen por Producto vs Proveedor", 4,
"Resumen por Vendedor vs Cliente vs Producto vs Pago", 5,
"Resumen por Proveedor", 6
     SIZE 45 BY 5.12 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      TDivision SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 wWin _STRUCTURED
  QUERY BROWSE-1 NO-LOCK DISPLAY
      TDivision.CodDiv COLUMN-LABEL "División" FORMAT "x(5)":U
      TDivision.DesDiv FORMAT "x(50)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 53 BY 7.69
         FONT 4
         TITLE "SELECCIONE LA(S) DIVISION(ES)" ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     BROWSE-1 AT ROW 2.92 COL 4 WIDGET-ID 200
     FILL-IN-Mensaje AT ROW 11 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 102
     FILL-IN-Fecha-1 AT ROW 1.19 COL 7 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-Fecha-2 AT ROW 1.96 COL 7 COLON-ALIGNED WIDGET-ID 112
     RADIO-SET-1 AT ROW 4.08 COL 60 NO-LABEL WIDGET-ID 104
     BUTTON-1 AT ROW 1.19 COL 88 WIDGET-ID 24
     BtnDone AT ROW 1.19 COL 94 WIDGET-ID 28
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
      TABLE: TDivision T "?" NO-UNDO estavtas DimDivision
      TABLE: TLinea T "?" NO-UNDO estavtas DimLinea
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
         WIDTH              = 106
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
        FILL-IN-Fecha-1 FILL-IN-Fecha-2 RADIO-SET-1
        pOptions = "".
    /* CONSISTENCIA */
    IF browse-1:NUM-SELECTED-ROWS = 0 THEN DO:
        MESSAGE 'Debe seleccionar al menos una Divisón' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    RUN lib/tt-file-to-text-01 (OUTPUT pOptions, OUTPUT pArchivo).
    IF pOptions = "" THEN RETURN NO-APPLY.

    SESSION:SET-WAIT-STATE('GENERAL').
    /*SESSION:DATE-FORMAT = "mdy".*/
    RUN Carga-Temporal.
    /*SESSION:DATE-FORMAT = "dmy".*/
    SESSION:SET-WAIT-STATE('').

    FIND FIRST Detalle NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Detalle THEN DO:
        MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.

    /* El archivo se va a generar en un archivo temporal de trabajo antes 
    de enviarlo a su directorio destino */
    cArchivo = LC(pArchivo).
    SESSION:SET-WAIT-STATE('GENERAL').
    SESSION:DATE-FORMAT = "mdy".
    RUN lib/tt-filev2 (TEMP-TABLE Detalle:HANDLE, cArchivo, pOptions).
    SESSION:DATE-FORMAT = "dmy".
    SESSION:SET-WAIT-STATE('').
    /* ******************************************************* */

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
DEFINE VAR lDivErr AS CHAR.

lDivErr = '00015,10060,20015'.
EMPTY TEMP-TABLE Detalle.
x-Cuenta = 0.
ESTADISTICAS:
DO k = 1 TO {&browse-name}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
    IF {&browse-name}:FETCH-SELECTED-ROW(k) THEN DO:
        FOR EACH faccpedi NO-LOCK WHERE faccpedi.codcia = s-codcia
            /*AND faccpedi.usuario <> 'ADMIN'*/
            AND faccpedi.coddoc = 'COT' 
            AND faccpedi.coddiv = TDivision.CodDiv 
            AND faccpedi.fchped >= FILL-IN-Fecha-1 
            AND faccpedi.fchped <= FILL-IN-Fecha-2,
            FIRST gn-clie NO-LOCK WHERE gn-clie.codcia = cl-codcia
                    AND gn-clie.codcli = faccpedi.codcli:
            /* 04Nov2014 - Ic */
            IF (faccpedi.fchped >= 09/23/2014 AND faccpedi.fchped < 11/01/2014) THEN DO:
                IF LOOKUP(faccpedi.coddiv,lDivErr) > 0  THEN DO:
                    IF CAPS(faccpedi.usuario) = 'ADMIN' OR CAPS(SUBSTRING(faccpedi.codcli,1,3))="SYS" THEN NEXT.
                END.
            END.
            /* Fin 04Nov2014 - Ic */
            IF Faccpedi.flgest = "A" OR Faccpedi.flgest = "W" THEN NEXT.
            FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** RESUMIENDO ** " +
                "COTIZACION " + faccpedi.nroped.
            FOR EACH facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
                CASE RADIO-SET-1:
                    WHEN 1 THEN DO:
                        RUN Rutina-1.
                    END.
                    WHEN 2 THEN DO:
                        RUN Rutina-2.
                    END.
                    WHEN 3 THEN DO:
                        RUN Rutina-3.
                    END.
                    WHEN 4 THEN DO:
                        RUN Rutina-4.
                    END.
                    WHEN 5 THEN DO:
                        RUN Rutina-5.
                    END.
                    WHEN 6 THEN DO:
                        RUN Rutina-6.
                    END.
                END CASE.
            END.
        END.
    END.
END.

/* DEFINIMOS CAMPOS A IMPRIMIR */
ASSIGN
    lOptions = "FieldList:".

CASE RADIO-SET-1:
    WHEN 1 THEN DO:
        lOptions = lOptions + "coddiv,lisbas,nroped,fchped,fchven,fchent,desmat,desmar,desfam,dessub,subtipo,licencia,nompro,canped,undbas,implin,canfac,impfac,pesmat,volumen,almsalida".
        FOR EACH detalle, FIRST almmmatg OF detalle NO-LOCK,
            FIRST almtfami OF almmmatg NO-LOCK, FIRST almsfami OF almmmatg NO-LOCK:
            x-nompro = 'NN'.
            FIND gn-prov WHERE gn-prov.codcia = pv-codcia
                AND gn-prov.codpro = almmmatg.codpr1
                NO-LOCK NO-ERROR.
            IF AVAILABLE gn-prov THEN x-nompro = gn-prov.nompro.
            ASSIGN
                detalle.desmat = detalle.codmat + ' ' + almmmatg.desmat
                detalle.desfam = almmmatg.codfam + ' ' + Almtfami.desfam
                detalle.dessub = almmmatg.subfam + ' ' + AlmSFami.dessub
                detalle.nompro = almmmatg.codpr1 + ' ' + x-nompro
                detalle.undbas = Almmmatg.UndBas.
        END.
    END.
    WHEN 2 THEN DO:
        lOptions = lOptions + 'coddiv,lisbas,nroped,fchped,fchven,fchent,nomcli,clfcli,desfam,dessub,implin,impfac,almsalida'.
        FOR EACH detalle,
            FIRST gn-clie NO-LOCK WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = detalle.codcli,
            FIRST almtfami OF detalle NO-LOCK,
            FIRST almsfami OF detalle NO-LOCK:
            ASSIGN
                detalle.nomcli = detalle.codcli + ' ' + gn-clie.nomcli
                detalle.clfcli = gn-clie.clfcli
                detalle.desfam = detalle.codfam + ' ' + Almtfami.desfam 
                detalle.dessub = detalle.subfam + ' ' + AlmSFami.dessub.
        END.
    END.
    WHEN 3 THEN DO:
        lOptions = lOptions + 'coddiv,lisbas,nroped,fchped,fchven,fchent,nomcli,clfcli,implin,impfac,almsalida'.
        FOR EACH detalle,
            FIRST gn-clie NO-LOCK WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = detalle.codcli:
            ASSIGN
                detalle.nomcli = detalle.codcli + ' ' + gn-clie.nomcli
                detalle.clfcli = gn-clie.clfcli.
        END.
    END.
    WHEN 4 THEN DO:
        lOptions = lOptions + 'coddiv,lisbas,nroped,fchped,fchven,fchent,desmat,desmar,desfam,dessub,subtipo,licencia,nompro,canped,undbas,implin,canfac,impfac,pesmat,volumen,almsalida'.
        FOR EACH detalle,
            FIRST almmmatg OF detalle NO-LOCK,
            FIRST almtfami OF detalle NO-LOCK,
            FIRST almsfami OF detalle NO-LOCK:
            x-nompro = 'NN'.
            FIND gn-prov WHERE gn-prov.codcia = pv-codcia
                AND gn-prov.codpro = almmmatg.codpr1
                NO-LOCK NO-ERROR.
            IF AVAILABLE gn-prov THEN x-nompro = gn-prov.nompro.
            ASSIGN
                detalle.desmat = detalle.codmat + ' ' + Almmmatg.desmat
                detalle.desmar = almmmatg.desmar
                detalle.desfam = detalle.codfam + ' ' + Almtfami.desfam
                detalle.dessub = detalle.subfam + ' ' + AlmSFami.dessub 
                detalle.nompro = almmmatg.codpr1 + ' ' + x-nompro
                detalle.undbas = Almmmatg.UndBas.
        END.
    END.
    WHEN 5 THEN DO:
        lOptions = lOptions + 'coddiv,lisbas,despgo,nroped,fchped,fchven,fchent,nomven,nomcli,clfcli,desmat,desmar,desfam,dessub,subtipo,undbas,canped,implin,canate,impate,saldo,impsal,canfac,impfac,flgest,departamento,provincia,distrito,pesmat,volumen,almsalida'.
        FOR EACH detalle,
            FIRST gn-clie NO-LOCK WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = detalle.codcli,
            FIRST almmmatg OF detalle NO-LOCK,
            FIRST almtfami OF almmmatg NO-LOCK,
            FIRST almsfami OF almmmatg NO-LOCK:
            ASSIGN
                x-nompro = 'NN'
                x-nomven = 'NN'
                x-coddept = detalle.coddept
                x-codprov = detalle.codprov
                x-coddist = detalle.coddist.
            FIND gn-prov WHERE gn-prov.codcia = pv-codcia AND gn-prov.codpro = almmmatg.codpr1 NO-LOCK NO-ERROR.
            IF AVAILABLE gn-prov THEN x-nompro = gn-prov.nompro.

            FIND gn-ven OF detalle NO-LOCK NO-ERROR.
            IF AVAILABLE gn-ven THEN x-nomven = gn-ven.nomven.

            FIND TabDepto WHERE TabDepto.CodDepto = detalle.coddept NO-LOCK NO-ERROR.
            IF AVAILABLE TabDepto THEN x-coddept = TRIM(x-coddept) + ' ' + TabDepto.NomDepto.

            FIND TabProvi WHERE TabProvi.CodDepto = detalle.coddept AND TabProvi.CodProvi = detalle.codprov NO-LOCK NO-ERROR.
            IF AVAILABLE TabProvi THEN x-codprov = TRIM(x-codprov) + ' ' + TabProvi.NomProvi.

            FIND TabDistr WHERE TabDistr.CodDepto = detalle.coddept
                AND TabDistr.CodProvi = detalle.codprov
                AND TabDistr.CodDistr = detalle.coddist NO-LOCK NO-ERROR.
            IF AVAILABLE TabDistr THEN x-coddist = TRIM(x-coddist) + ' ' + TabDistr.NomDistr.

            FIND FIRST gn-convt WHERE gn-ConVt.Codig = detalle.fmapgo NO-LOCK NO-ERROR.
            RUN vta2/p-faccpedi-flgest (detalle.flgest, "COT", OUTPUT x-Estado).

            ASSIGN detalle.despgo = detalle.fmapgo + ' ' + (IF AVAILABLE gn-convt THEN gn-ConVt.Nombr ELSE '')
                detalle.nomven = detalle.codven + ' ' + x-nomven
                detalle.nomcli = detalle.codcli + ' ' + gn-clie.nomcli
                detalle.clfcli = gn-clie.clfcli
                detalle.desmat = detalle.codmat + ' ' + Almmmatg.desmat
                detalle.desmar = almmmatg.desmar
                detalle.desfam = detalle.codfam + ' ' + Almtfami.desfam
                detalle.dessub = detalle.subfam + ' ' + AlmSFami.dessub
                detalle.undbas = Almmmatg.UndBas
                detalle.departamento = x-coddept
                detalle.provincia = x-codprov
                detalle.distrito = x-coddist
                detalle.flgest = x-estado
                detalle.saldo = detalle.canped - detalle.canate.
            /* RHC CALCULOS FINALES */                                                                                                        
            ASSIGN
                detalle.impate = detalle.canate * (detalle.implin / detalle.canped)
                detalle.impsal = detalle.saldo * (detalle.implin / detalle.canped).
            IF detalle.canate >= detalle.canped THEN
                ASSIGN
                detalle.impate = detalle.implin
                detalle.canate = detalle.canped
                detalle.saldo = 0
                detalle.impsal = 0.
        END.
    END.
    WHEN 6 THEN DO:
        lOptions = lOptions + 'coddiv,lisbas,nroped,fchped,fchven,fchent,nompro,implin,impfac,almsalida'.
        FOR EACH detalle:
            x-nompro = 'NN'.
            FIND gn-prov WHERE gn-prov.codcia = pv-codcia
                AND gn-prov.codpro = detalle.codpro
                NO-LOCK NO-ERROR.
            IF AVAILABLE gn-prov THEN x-nompro = gn-prov.nompro.
            ASSIGN
                detalle.nompro = detalle.codpro + ' ' + x-nompro.
        END.
    END.
END CASE.
lOptions = lOptions + ',usuario'.
ASSIGN
    pOptions = pOptions + CHR(1) + lOptions.
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** FIN DEL PROCESO ** ".

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
  DISPLAY FILL-IN-Mensaje FILL-IN-Fecha-1 FILL-IN-Fecha-2 RADIO-SET-1 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE BROWSE-1 FILL-IN-Fecha-1 FILL-IN-Fecha-2 RADIO-SET-1 BUTTON-1 BtnDone 
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
          FIRST DimDivision OF EstadUserDiv NO-LOCK:
          CREATE TDivision.
          BUFFER-COPY DimDivision TO TDivision.
      END.
  END.
  ELSE DO:
      FOR EACH DimDivision NO-LOCK:
          CREATE TDivision.
          BUFFER-COPY DimDivision TO TDivision.
      END.
  END.
  FOR EACH DimLinea NO-LOCK:
      CREATE TLinea.
      BUFFER-COPY DimLinea TO TLinea.
  END.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Rutina-1 wWin 
PROCEDURE Rutina-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND detalle WHERE detalle.codcia = facdpedi.codcia AND detalle.nroped = facdpedi.nroped AND detalle.codmat = facdpedi.codmat NO-ERROR.
    IF NOT AVAILABLE detalle THEN DO:
        CREATE detalle.
        ASSIGN detalle.coddiv = faccpedi.coddiv
            detalle.lisbas = faccpedi.libre_c01
            detalle.codcia = facdpedi.codcia
            detalle.nroped = facdpedi.nroped
            detalle.fchped = faccpedi.fchped
            detalle.fchven = faccpedi.fchven
            detalle.fchent = faccpedi.fchent 
            detalle.codmat = facdpedi.codmat
            detalle.flgest = faccpedi.flgest
            detalle.pesmat = almmmatg.pesmat
            detalle.volume = almmmatg.libre_d02
            detalle.almsalida = faccpedi.lugent2
            detalle.usuario = faccpedi.usuario.

        FIND almtabla WHERE almtabla.Tabla = "LC" AND almtabla.Codigo = Almmmatg.Licencia[1] NO-LOCK NO-ERROR.
        IF AVAILABLE almtabla THEN detalle.licencia = almtabla.Nombre.
        FIND almtabla WHERE almtabla.Tabla = "ST" AND almtabla.Codigo = Almmmatg.Libre_c01 NO-LOCK NO-ERROR.
        IF AVAILABLE almtabla THEN detalle.subtipo = almtabla.Nombre.
        x-Cuenta = x-Cuenta + 1.
    END.
    ASSIGN
        detalle.canped = detalle.canped + facdpedi.canped * facdpedi.factor
        detalle.implin = detalle.implin + facdpedi.implin.
    /* Agregamos lo facturado */
    FOR EACH PEDIDO NO-LOCK WHERE PEDIDO.codcia = Faccpedi.codcia
        AND PEDIDO.coddoc = "PED"
        AND PEDIDO.coddiv = Faccpedi.coddiv
        AND PEDIDO.fchped >= Faccpedi.fchped
        AND PEDIDO.codref = Faccpedi.coddoc
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
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Rutina-2 wWin 
PROCEDURE Rutina-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND detalle WHERE detalle.codcia = facdpedi.codcia AND detalle.nroped = facdpedi.nroped
        AND detalle.codcli = faccpedi.codcli AND detalle.codfam = almmmatg.codfam AND detalle.subfam = almmmatg.subfam
        NO-ERROR.
    IF NOT AVAILABLE detalle THEN DO:
        CREATE detalle.
        ASSIGN detalle.coddiv = faccpedi.coddiv
            detalle.lisbas = faccpedi.libre_c01
            detalle.codcia = facdpedi.codcia
            detalle.nroped = facdpedi.nroped
            detalle.fchped = faccpedi.fchped
            detalle.fchven = faccpedi.fchven
            detalle.fchent = faccpedi.fchent
            detalle.codcli = faccpedi.codcli
            detalle.codfam = almmmatg.codfam
            detalle.subfam = almmmatg.subfam
            detalle.flgest = faccpedi.flgest
            detalle.almsalida = faccpedi.lugent2
            detalle.usuario = faccpedi.usuario.
        x-Cuenta = x-Cuenta + 1.
    END.
    ASSIGN
        detalle.canped = detalle.canped + facdpedi.canped * facdpedi.factor
        detalle.implin = detalle.implin + facdpedi.implin.

    /* Agregamos lo facturado */
    FOR EACH PEDIDO NO-LOCK WHERE PEDIDO.codcia = Faccpedi.codcia
        AND PEDIDO.coddoc = "PED"
        AND PEDIDO.coddiv = Faccpedi.coddiv
        AND PEDIDO.fchped >= Faccpedi.fchped
        AND PEDIDO.codref = Faccpedi.coddoc
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
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Rutina-3 wWin 
PROCEDURE Rutina-3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND detalle WHERE detalle.codcia = facdpedi.codcia AND detalle.nroped = facdpedi.nroped
        AND detalle.codcli = faccpedi.codcli NO-ERROR.
    IF NOT AVAILABLE detalle THEN DO:
        CREATE detalle.
        ASSIGN detalle.coddiv = faccpedi.coddiv
            detalle.lisbas = faccpedi.libre_c01
            detalle.codcia = facdpedi.codcia
            detalle.nroped = facdpedi.nroped
            detalle.fchped = faccpedi.fchped
            detalle.fchven = faccpedi.fchven
            detalle.fchent = faccpedi.fchent
            detalle.codcli = faccpedi.codcli
            detalle.flgest = faccpedi.flgest
            detalle.almsalida = faccpedi.lugent2
            detalle.usuario = faccpedi.usuario.
        x-Cuenta = x-Cuenta + 1.
    END.
    ASSIGN detalle.implin = detalle.implin + facdpedi.implin.
    /* Agregamos lo facturado */
    FOR EACH PEDIDO NO-LOCK WHERE PEDIDO.codcia = Faccpedi.codcia
        AND PEDIDO.coddoc = "PED"
        AND PEDIDO.coddiv = Faccpedi.coddiv
        AND PEDIDO.fchped >= Faccpedi.fchped
        AND PEDIDO.codref = Faccpedi.coddoc
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
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Rutina-4 wWin 
PROCEDURE Rutina-4 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND detalle WHERE detalle.codcia = facdpedi.codcia AND detalle.nroped = facdpedi.nroped
        AND detalle.codcli = faccpedi.codcli AND detalle.codmat = facdpedi.codmat NO-ERROR.
    IF NOT AVAILABLE detalle THEN DO:
        CREATE detalle.
        ASSIGN detalle.coddiv = faccpedi.coddiv
            detalle.lisbas = faccpedi.libre_c01
            detalle.codcia = facdpedi.codcia
            detalle.nroped = facdpedi.nroped
            detalle.fchped = faccpedi.fchped
            detalle.fchven = faccpedi.fchven
            detalle.fchent = faccpedi.fchent
            detalle.codcli = faccpedi.codcli
            detalle.codmat = facdpedi.codmat
            detalle.codfam = almmmatg.codfam
            detalle.subfam = almmmatg.subfam
            detalle.flgest = faccpedi.flgest
            detalle.pesmat = almmmatg.pesmat
            detalle.volume = almmmatg.libre_d02
            detalle.almsalida = faccpedi.lugent2
            detalle.usuario = faccpedi.usuario.
    
        FIND almtabla WHERE almtabla.Tabla = "LC" AND almtabla.Codigo = Almmmatg.Licencia[1] NO-LOCK NO-ERROR.
        IF AVAILABLE almtabla THEN detalle.licencia = almtabla.Nombre.
        FIND almtabla WHERE almtabla.Tabla = "ST" AND almtabla.Codigo = Almmmatg.Libre_c01 NO-LOCK NO-ERROR.
        IF AVAILABLE almtabla THEN detalle.subtipo = almtabla.Nombre.
        x-Cuenta = x-Cuenta + 1.
    END.
    ASSIGN detalle.canped = detalle.canped + facdpedi.canped * facdpedi.factor
        detalle.implin = detalle.implin + facdpedi.implin.
    /* Agregamos lo facturado */
    FOR EACH PEDIDO NO-LOCK WHERE PEDIDO.codcia = Faccpedi.codcia
        AND PEDIDO.coddoc = "PED"
        AND PEDIDO.coddiv = Faccpedi.coddiv
        AND PEDIDO.fchped >= Faccpedi.fchped
        AND PEDIDO.codref = Faccpedi.coddoc
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
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Rutina-5 wWin 
PROCEDURE Rutina-5 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND detalle WHERE detalle.codcia = facdpedi.codcia AND detalle.nroped = facdpedi.nroped
        AND detalle.codven = faccpedi.codven AND detalle.codcli = faccpedi.codcli
        AND detalle.codmat = facdpedi.codmat AND detalle.fmapgo = faccpedi.fmapgo NO-ERROR.
    IF NOT AVAILABLE detalle THEN DO:
        CREATE detalle.
        ASSIGN detalle.coddiv = faccpedi.coddiv
            detalle.lisbas = faccpedi.libre_c01
            detalle.codcia = facdpedi.codcia
            detalle.fmapgo = faccpedi.fmapgo
            detalle.nroped = faccpedi.nroped
            detalle.fchped = faccpedi.fchped
            detalle.fchven = faccpedi.fchven
            detalle.fchent = faccpedi.fchent
            detalle.codven = faccpedi.codven
            detalle.codcli = faccpedi.codcli
            detalle.codmat = facdpedi.codmat
            detalle.codfam = almmmatg.codfam
            detalle.subfam = almmmatg.subfam
            detalle.flgest = faccpedi.flgest
            detalle.coddept = gn-clie.CodDept 
            detalle.codprov = gn-clie.CodProv 
            detalle.coddist = gn-clie.CodDist
            detalle.pesmat = almmmatg.pesmat
            detalle.volume = almmmatg.libre_d02
            detalle.almsalida = faccpedi.lugent2
            detalle.usuario = faccpedi.usuario.
    
        FIND almtabla WHERE almtabla.Tabla = "ST" AND almtabla.Codigo = Almmmatg.Libre_c01 NO-LOCK NO-ERROR.
        IF AVAILABLE almtabla THEN detalle.subtipo = almtabla.Nombre.
        x-Cuenta = x-Cuenta + 1.
    END.
    ASSIGN detalle.canped = detalle.canped + facdpedi.canped * facdpedi.factor
        detalle.canate = detalle.canate + facdpedi.canate * facdpedi.factor
        detalle.implin = detalle.implin + facdpedi.implin.

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
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Rutina-6 wWin 
PROCEDURE Rutina-6 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND detalle WHERE detalle.codcia = facdpedi.codcia AND detalle.nroped = facdpedi.nroped
        AND detalle.codpro = almmmatg.codpr1 NO-ERROR.
    IF NOT AVAILABLE detalle THEN DO:
        CREATE detalle.
        ASSIGN detalle.coddiv = faccpedi.coddiv
            detalle.lisbas = faccpedi.libre_c01
            detalle.codcia = facdpedi.codcia
            detalle.nroped = facdpedi.nroped
            detalle.fchped = faccpedi.fchped
            detalle.fchven = faccpedi.fchven
            detalle.fchent = faccpedi.fchent
            detalle.codpro = almmmatg.codpr1
            detalle.flgest = faccpedi.flgest
            detalle.almsalida = faccpedi.lugent2
            detalle.usuario = faccpedi.usuario.
        x-Cuenta = x-Cuenta + 1.
    END.
    ASSIGN detalle.canped = detalle.canped + facdpedi.canped * facdpedi.factor
        detalle.implin = detalle.implin + facdpedi.implin.
    /* Agregamos lo facturado */
    FOR EACH PEDIDO NO-LOCK WHERE PEDIDO.codcia = Faccpedi.codcia
        AND PEDIDO.coddoc = "PED"
        AND PEDIDO.coddiv = Faccpedi.coddiv
        AND PEDIDO.fchped >= Faccpedi.fchped
        AND PEDIDO.codref = Faccpedi.coddoc
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
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

