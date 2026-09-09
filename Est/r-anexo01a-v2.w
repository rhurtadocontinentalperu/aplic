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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR pv-codcia AS INT.
DEFINE SHARED VAR s-user-id AS CHAR.

/* VARIABLES PARA EL RESUMEN */
/*DEF VAR x-CodDiv LIKE DimDivision.coddiv   NO-UNDO.*/
DEF VAR x-CodCli LIKE DimCliente.codcli   NO-UNDO.
DEF VAR x-CodMat LIKE DimProducto.codmat  NO-UNDO.
DEF VAR x-CodPro LIKE DimProveedor.codpro   NO-UNDO.
DEF VAR x-CodVen LIKE DimVendedor.codven    NO-UNDO.
DEF VAR x-CodFam LIKE DimProducto.codfam  NO-UNDO.
DEF VAR x-SubFam LIKE DimProducto.subfam  NO-UNDO.
DEF VAR x-CanalVenta LIKE DimDivision.CanalVenta NO-UNDO.
DEF VAR x-Canal  LIKE DimCliente.canal    NO-UNDO.
DEF VAR x-Giro   LIKE DimCliente.gircli   NO-UNDO.
DEF VAR x-NroCard LIKE DimCliente.nrocard NO-UNDO.
DEF VAR x-Zona   AS CHAR               NO-UNDO.
DEF VAR x-CodDept LIKE DimCliente.coddept NO-UNDO.
DEF VAR x-CodProv LIKE DimCliente.codprov NO-UNDO.
DEF VAR x-CodDist LIKE DimCliente.coddist NO-UNDO.
DEF VAR x-CuentaReg  AS INT             NO-UNDO.    /* Contador de registros */
DEF VAR x-MuestraReg AS INT             NO-UNDO.    /* Tope para mostrar registros */

DEF VAR iContador AS INT NO-UNDO.

DEFINE VAR x-Llave AS CHAR.
DEF STREAM REPORTE.

DEF VAR pOptions AS CHAR.
DEF VAR pArchivo AS CHAR.
DEF VAR cArchivo AS CHAR.
DEF VAR zArchivo AS CHAR.
DEF VAR cComando AS CHAR.
DEF VAR pDirectorio AS CHAR.
DEF VAR lOptions AS CHAR.

DEF TEMP-TABLE Detalle
    FIELD CodDiv LIKE Ventas_Cabecera.coddiv    LABEL 'DIVISION'
    FIELD DesDiv LIKE DimDivision.DesDiv        LABEL 'DIVISION'
    FIELD DivDes LIKE Ventas_Cabecera.DivDes    LABEL 'DESTINO'
    FIELD DesDivDes LIKE DimDivision.DesDiv     LABEL 'DESTINO'
    FIELD CodDoc LIKE Ventas_Cabecera.CodDoc    LABEL 'DOC'     FORMAT 'x(5)'
    FIELD NroDoc LIKE Ventas_Cabecera.NroDoc    LABEL 'NUMERO'
    FIELD FchDoc AS DATE                        LABEL 'FECHA'
    FIELD FmaPgo LIKE Ventas_Cabecera.FmaPgo    LABEL 'COND VENTA'
    FIELD DesFmaPgo LIKE gn-ConVt.Nombr         LABEL 'COND VENTA'
    FIELD CodCli LIKE Ventas_Cabecera.codcli    LABEL 'CLIENTE'
    FIELD NomCli LIKE DimCliente.nomcli         LABEL 'CLIENTE'
    FIELD CodVen LIKE Ventas_Cabecera.CodVen    LABEL 'VENDEDOR'
    FIELD NomVen LIKE DimVendedor.NomVen        LABEL 'VENDEDOR'
    FIELD CodMat LIKE Ventas_Detalle.codmat     LABEL 'ARTICULO'
    FIELD DesMat LIKE DimProducto.desmat        LABEL 'ARTICULO'
    FIELD CodFam LIKE DimProducto.codfam        LABEL 'LINEA'
    FIELD NomFam LIKE DimLinea.NomFam           LABEL 'LINEA'
    FIELD SubFam LIKE DimProducto.subfam        LABEL 'SUBLINEA'
    FIELD NomSubFam LIKE DimSubLinea.NomSubFam  LABEL 'SUBLINEA'
    FIELD DesMar LIKE DimProducto.desmar        LABEL 'MARCA'
    FIELD UndStk LIKE DimProducto.undstk        LABEL 'UNIDAD'
    FIELD Licencia LIKE DimProducto.licencia    LABEL 'LICENCIA'
    FIELD DesLicencia LIKE DimLicencia.Descripcion  LABEL 'LICENCIA'
    FIELD ImpNacCIGV LIKE Ventas_Detalle.ImpNacCIGV LABEL 'IMPORTE S/.'
    FIELD ImpExtCIGV LIKE Ventas_Detalle.ImpExtCIGV LABEL 'IMPORTE US$'
    FIELD CostoUniKrdx LIKE Ventas_Detalle.ImpExtCIGV LABEL 'COSTO UNITARIO KARDEX S/.'
    FIELD CostoTotKrdx LIKE Ventas_Detalle.ImpExtCIGV LABEL 'COSTO KARDEX S/.'
    FIELD Cantidad LIKE Ventas_Detalle.Cantidad LABEL 'CANTIDAD'.

/*Tabla Clientes*/
DEFINE TEMP-TABLE tt-cliente
    FIELDS tt-codcli LIKE DimCliente.codcli
    FIELDS tt-nomcli LIKE DimCliente.nomcli
    INDEX idx01 IS PRIMARY tt-codcli.

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
&Scoped-Define ENABLED-OBJECTS BUTTON-1 BtnDone BUTTON-Division ~
COMBO-BOX-CodFam COMBO-BOX-SubFam FILL-IN-CodCli BUTTON-5 DesdeF HastaF 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Mensaje x-CodDiv COMBO-BOX-CodFam ~
COMBO-BOX-SubFam FILL-IN-CodCli FILL-IN-NomCli FILL-IN-file DesdeF HastaF 

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
     SIZE 6 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 1" 
     SIZE 6 BY 1.62.

DEFINE BUTTON BUTTON-5 
     LABEL "..." 
     SIZE 5 BY 1.

DEFINE BUTTON BUTTON-Division 
     LABEL "..." 
     SIZE 4 BY 1 TOOLTIP "Selecciona Divisiones".

DEFINE VARIABLE COMBO-BOX-CodFam AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Linea" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 43 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-SubFam AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Sub-linea" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 43 BY 1 NO-UNDO.

DEFINE VARIABLE x-CodDiv AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 63 BY 3.08
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodCli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-file AS CHARACTER FORMAT "X(256)":U 
     LABEL "Archivo de Clientes" 
     VIEW-AS FILL-IN 
     SIZE 76 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 103 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 65 BY 1 NO-UNDO.

DEFINE VARIABLE HastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     BUTTON-1 AT ROW 1 COL 112 WIDGET-ID 24
     BtnDone AT ROW 1 COL 118 WIDGET-ID 28
     FILL-IN-Mensaje AT ROW 1.27 COL 6 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     x-CodDiv AT ROW 3.12 COL 31 NO-LABEL WIDGET-ID 78
     BUTTON-Division AT ROW 3.15 COL 94 WIDGET-ID 76
     COMBO-BOX-CodFam AT ROW 6.38 COL 29 COLON-ALIGNED WIDGET-ID 36
     COMBO-BOX-SubFam AT ROW 7.46 COL 29 COLON-ALIGNED WIDGET-ID 38
     FILL-IN-CodCli AT ROW 8.54 COL 29 COLON-ALIGNED WIDGET-ID 40
     FILL-IN-NomCli AT ROW 8.54 COL 44 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     BUTTON-5 AT ROW 9.69 COL 108 WIDGET-ID 66
     FILL-IN-file AT ROW 9.73 COL 29 COLON-ALIGNED WIDGET-ID 68
     DesdeF AT ROW 10.85 COL 29 COLON-ALIGNED WIDGET-ID 10
     HastaF AT ROW 10.85 COL 51 COLON-ALIGNED WIDGET-ID 12
     "División Origen:" VIEW-AS TEXT
          SIZE 14 BY .62 AT ROW 3.31 COL 17 WIDGET-ID 80
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 130.43 BY 11.85 WIDGET-ID 100.


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
         TITLE              = "ANEXO ESTADISTICAS - DETALLE DE DOCUMENTOS"
         HEIGHT             = 11.85
         WIDTH              = 130.43
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

{src/adm-vm/method/vmviewer.i}
{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN FILL-IN-file IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomCli IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR EDITOR x-CodDiv IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* ANEXO ESTADISTICAS - DETALLE DE DOCUMENTOS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* ANEXO ESTADISTICAS - DETALLE DE DOCUMENTOS */
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
        /*COMBO-BOX-CodDiv */
        x-CodDiv
        COMBO-BOX-CodFam 
        COMBO-BOX-SubFam
        FILL-IN-CodCli 
        FILL-IN-NomCli.
    ASSIGN
        DesdeF HastaF.

    RUN lib/tt-file-to-text-7zip (OUTPUT pOptions, OUTPUT pArchivo, OUTPUT pDirectorio).
    IF pOptions = "" THEN RETURN NO-APPLY.

    SESSION:SET-WAIT-STATE('GENERAL').
    IF INDEX(pOptions, 'FileType:XLS') > 0 THEN SESSION:DATE-FORMAT = "mdy".
    RUN Carga-Temporal.
    SESSION:DATE-FORMAT = "dmy".
    SESSION:SET-WAIT-STATE('').

    FIND FIRST Detalle NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Detalle THEN DO:
        MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.

    /* El archivo se va a generar en un archivo temporal de trabajo antes 
    de enviarlo a su directorio destino */
    pArchivo = REPLACE(pArchivo, '.', STRING(RANDOM(1,9999), '9999') + ".").
    cArchivo = LC(SESSION:TEMP-DIRECTORY + pArchivo).
    SESSION:SET-WAIT-STATE('GENERAL').
    /*SESSION:DATE-FORMAT = "mdy".*/
    RUN lib/tt-file (TEMP-TABLE Detalle:HANDLE, cArchivo, pOptions).
    /*SESSION:DATE-FORMAT = "dmy".*/
    SESSION:SET-WAIT-STATE('').

    /* Secuencia de comandos para encriptar el archivo con 7zip */
    IF INDEX(cArchivo, ".xls") > 0 THEN zArchivo = REPLACE(cArchivo, ".xls", ".zip").
    IF INDEX(cArchivo, ".txt") > 0 THEN zArchivo = REPLACE(cArchivo, ".txt", ".zip").
    cComando = '"C:\Archivos de programa\7-Zip\7z.exe" a ' + zArchivo + ' ' + cArchivo.
    OS-COMMAND 
        SILENT 
        VALUE ( cComando ).
    IF SEARCH(zArchivo) = ? THEN DO:
        MESSAGE 'NO se pudo encriptar el archivo' SKIP
            'Avise a sistemas'
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
    OS-DELETE VALUE(cArchivo).

    IF INDEX(cArchivo, '.xls') > 0 THEN cArchivo = REPLACE(pArchivo, ".xls", ".zip").
    IF INDEX(cArchivo, '.txt') > 0 THEN cArchivo = REPLACE(pArchivo, ".txt", ".zip").
    cComando = "copy " + zArchivo + ' ' + TRIM(pDirectorio) + TRIM(cArchivo).
    OS-COMMAND 
        SILENT 
        /*NO-WAIT */
        /*NO-CONSOLE */
        VALUE(cComando).
    OS-DELETE VALUE(zArchivo).
    /* ******************************************************* */
    MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 wWin
ON CHOOSE OF BUTTON-5 IN FRAME fMain /* ... */
DO:

    DEFINE VARIABLE OKpressed AS LOGICAL NO-UNDO.

    SYSTEM-DIALOG GET-FILE FILL-IN-file
        FILTERS
            "Archivos Texto (*.txt)" "*.txt"
        TITLE
            "Archivo(s) de Carga..."
        MUST-EXIST
        USE-FILENAME
        UPDATE OKpressed.

    IF OKpressed = TRUE THEN
        FILL-IN-file:SCREEN-VALUE = FILL-IN-file.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Division wWin
ON CHOOSE OF BUTTON-Division IN FRAME fMain /* ... */
DO:
    ASSIGN x-CodDiv.
    RUN gn/d-filtro-divisiones (INPUT-OUTPUT x-CodDiv, "SELECCIONE LAS DIVISIONES").
    DISPLAY x-CodDiv WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-CodFam wWin
ON VALUE-CHANGED OF COMBO-BOX-CodFam IN FRAME fMain /* Linea */
DO:
    COMBO-BOX-SubFam:DELETE(COMBO-BOX-SubFam:LIST-ITEMS).
    COMBO-BOX-SubFam:ADD-LAST('Todos').
    COMBO-BOX-SubFam:SCREEN-VALUE = 'Todos'.
    IF SELF:SCREEN-VALUE <> 'Todos' THEN DO:
        FOR EACH DimSubLinea NO-LOCK WHERE DimSubLinea.codfam = ENTRY(1, SELF:SCREEN-VALUE, ' - '):
            COMBO-BOX-SubFam:ADD-LAST(DimSubLinea.subfam + ' - '+ DimSubLinea.nomsubfam).
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodCli wWin
ON LEAVE OF FILL-IN-CodCli IN FRAME fMain /* Cliente */
DO:
  FIND gn-clie WHERE codcia = cl-codcia
      AND codcli = SELF:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-clie THEN FILL-IN-NomCli:SCREEN-VALUE = gn-clie.nomcli.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Lista-Clientes wWin 
PROCEDURE Carga-Lista-Clientes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR x-linea LIKE DimCliente.codcli.

    EMPTY TEMP-TABLE tt-cliente.

    /* Carga de Excel */
    IF SEARCH(FILL-IN-file) <> ? THEN DO:
        INPUT FROM VALUE(FILL-IN-file).
        REPEAT:
            IMPORT UNFORMATTED x-linea.
            FIND tt-cliente WHERE tt-cliente.tt-codcli = x-linea NO-ERROR.
            IF NOT AVAILABLE tt-cliente THEN CREATE tt-cliente.
            tt-cliente.tt-codcli = x-linea.
        END.
        INPUT CLOSE.
    END.
    
    FOR EACH tt-cliente WHERE tt-cliente.tt-codcli = '':
        DELETE tt-cliente.
    END.

    FIND FIRST tt-cliente NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-cliente THEN DO:
        CREATE tt-cliente.        
        ASSIGN tt-codcli = fill-in-codcli.
    END.

    FOR EACH tt-cliente:
        FIND DimCliente WHERE DimCliente.codcli = tt-cliente.tt-codcli
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE DimCliente THEN DELETE tt-cliente.
    END.

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

DEF VAR x-Cuenta-Registros AS INT INIT 0 NO-UNDO.

DEFINE VAR x-UserVerCostos AS LOG.

FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** GENERANDO EL EXCEL **".

/* Ic - 13Nov2017, Mostrar costo kardex, chequea si usuario esta habilitado */
x-UserVerCostos = NO.

FIND FIRST estadtabla WHERE estadtabla.tabla = 'EST' AND
                            estadtabla.codigo = s-user-id NO-LOCK NO-ERROR.
IF AVAILABLE estadtabla THEN DO:
    x-UserVerCostos = estadtabla.campo-logical[1].
END.
x-UserVerCostos = IF(s-user-id = 'ADMIN') THEN YES ELSE x-UserVerCostos.

ASSIGN
    /*x-CodDiv = ''*/
    x-CodFam = ''
    x-SubFam = ''
    x-CodCli = ''.
/*IF NOT COMBO-BOX-CodDiv BEGINS 'Todos' THEN x-CodDiv = ENTRY(1, COMBO-BOX-CodDiv, ' - ').*/
IF NOT COMBO-BOX-CodFam BEGINS 'Todos' THEN x-CodFam = ENTRY(1, COMBO-BOX-CodFam, ' - ').
IF NOT COMBO-BOX-SubFam BEGINS 'Todos' THEN x-SubFam = ENTRY(1, COMBO-BOX-SubFam, ' - ').

RUN Carga-Lista-Clientes.
/* Lista de clientes final */
FOR EACH tt-cliente:
    x-CodCli = x-CodCli + (IF x-CodCli = '' THEN '' ELSE ',') + tt-cliente.tt-codcli.
END.
IF FILL-IN-CodCli <> '' AND INDEX(x-CodCli, FILL-IN-CodCli) = 0 
    THEN x-CodCli = x-CodCli + (IF x-CodCli = '' THEN '' ELSE ',') + FILL-IN-CodCli.

EMPTY TEMP-TABLE Detalle.
FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia
    AND (x-CodDiv = '' OR LOOKUP(gn-divi.coddiv, x-CodDiv) > 0),
    EACH Ventas_Cabecera NO-LOCK WHERE Ventas_Cabecera.coddiv = gn-divi.coddiv
    AND (x-CodCli = "" OR LOOKUP(Ventas_Cabecera.CodCli, x-CodCli) > 0)
    AND Ventas_Cabecera.DateKey >= DesdeF
    AND Ventas_Cabecera.DateKey <= HastaF,
    EACH Ventas_Detalle OF Ventas_Cabecera NO-LOCK,
    FIRST DimProducto OF Ventas_Detalle NO-LOCK WHERE (x-CodFam = "" OR DimProducto.codfam = x-CodFam)
    AND (x-SubFam = "" OR DimProducto.subfam = x-SubFam):
    FIND FIRST DimLinea    OF DimProducto NO-LOCK NO-ERROR.
    FIND FIRST DimSubLinea OF DimProducto NO-LOCK NO-ERROR.
    FIND FIRST DimLicencia OF DimProducto NO-LOCK NO-ERROR.
    CREATE Detalle.
    ASSIGN
        Detalle.coddiv = Ventas_Cabecera.coddiv.
    FIND DimDivision WHERE DimDivision.coddiv = Ventas_Cabecera.coddiv
        NO-LOCK.
    ASSIGN
        Detalle.desdiv = DimDivision.DesDiv
        Detalle.divdes = Ventas_Cabecera.DivDes. 
    /* Division destino */
    FIND DimDivision WHERE DimDivision.coddiv = Ventas_Cabecera.divdes NO-LOCK NO-ERROR.
    IF AVAILABLE DimDivision THEN Detalle.desdivdes = DimDivision.DesDiv.
    /* **************** */
    ASSIGN
        Detalle.coddoc = Ventas_Cabecera.CodDoc
        Detalle.nrodoc = Ventas_Cabecera.NroDoc
        Detalle.fchdoc = DATE(Ventas_Cabecera.DateKey)
        Detalle.fmapgo = Ventas_Cabecera.FmaPgo.
    FIND gn-ConVt WHERE gn-ConVt.Codig = Ventas_Cabecera.FmaPgo NO-LOCK NO-ERROR.
    IF AVAILABLE gn-ConVt THEN Detalle.desfmapgo = gn-ConVt.Nombr.

    IF x-Cuenta-Registros MODULO 1000 = 0 THEN 
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = Ventas_Cabecera.coddiv + ' ' +
        Ventas_Cabecera.CodDoc + ' ' + Ventas_Cabecera.NroDoc + ' ' + 
        STRING(Ventas_Cabecera.DateKey, '99/99/9999').

    /* CLIENTE */
    ASSIGN
        x-Canal   = ''
        x-Giro    = ''
        x-NroCard = ''
        x-Zona    = ''
        x-CodDept = ''
        x-CodProv = ''
        x-CodDist = ''.
    ASSIGN
        Detalle.codcli = Ventas_Cabecera.codcli.
    FIND DimCliente WHERE DimCliente.codcli = Ventas_Cabecera.codcli NO-LOCK NO-ERROR.
    IF AVAILABLE DimCliente THEN Detalle.nomcli = DimCliente.nomcli.
    /* VENDEDOR */
    ASSIGN
        Detalle.codven = Ventas_Cabecera.CodVen.
    FIND DimVendedor WHERE DimVendedor.codven = Ventas_Cabecera.CodVen NO-LOCK NO-ERROR.
    IF AVAILABLE DimVendedor THEN Detalle.nomven = DimVendedor.NomVen.
    /* ARTICULO */
    ASSIGN
        Detalle.codmat = Ventas_Detalle.codmat
        Detalle.desmat = DimProducto.desmat
        Detalle.codfam = DimProducto.codfam
        Detalle.nomfam = (IF AVAILABLE DimLinea THEN DimLinea.NomFam ELSE '')
        Detalle.subfam = DimProducto.subfam
        Detalle.nomsubfam = (IF AVAILABLE DimSubLinea THEN DimSubLinea.NomSubFam ELSE '')
        Detalle.desmar = DimProducto.desmar
        Detalle.undstk = DimProducto.undstk
        Detalle.licencia = DimProducto.licencia
        Detalle.deslicencia = (IF AVAILABLE DimLicencia THEN DimLicencia.Descripcion ELSE '').
    /* TOTALES */
    ASSIGN
        Detalle.impnaccigv = Ventas_Detalle.ImpNacCIGV
        Detalle.impextcigv = Ventas_Detalle.ImpExtCIGV
        Detalle.cantidad = Ventas_Detalle.Cantidad
        Detalle.CostoUniKrdx = 0
        Detalle.CostoTotKrdx = 0
        .
    /* Ver Costos */
    IF x-UserVerCostos = YES THEN DO:
        ASSIGN
            /*Detalle.CostoTotKrdx = Ventas_Detalle.ImpNacSIGV*/
            Detalle.CostoTotKrdx = Ventas_Detalle.PromNacSIGV
            /*Detalle.CostoUniKrdx = (IF Ventas_Detalle.Cantidad <> 0 THEN Ventas_Detalle.ImpNacSIGV / Ventas_Detalle.Cantidad ELSE 0)*/
            Detalle.CostoUniKrdx = (IF Ventas_Detalle.Cantidad <> 0 THEN Ventas_Detalle.PromNacSIGV / Ventas_Detalle.Cantidad ELSE 0)
            .
/*         FIND LAST almstkge WHERE almstkge.codcia = s-codcia AND                                      */
/*                                     almstkge.codmat = ventas_detalle.codmat AND                      */
/*                                     almstkge.fecha <= (ventas_detalle.DATEkey - 1) NO-LOCK NO-ERROR. */
/*         IF AVAILABLE almstkge THEN DO:                                                               */
/*             Detalle.CostoUniKrdx = almstkge.ctouni.                                                  */
/*             Detalle.CostoTotKrdx = almstkge.ctouni * Ventas_Detalle.Cantidad.                        */
/*         END.                                                                                         */
    END.
    /* RHC 01.04.11 control de registros */
    x-Cuenta-Registros = x-Cuenta-Registros + 1.
END.
FOR EACH Detalle.
    ASSIGN
        detalle.desdiv = detalle.coddiv + ' - ' + detalle.desdiv
        detalle.desdivdes = detalle.divdes + ' - ' + detalle.desdivdes
        detalle.desfmapgo = detalle.fmapgo + ' - ' + detalle.desfmapgo
        detalle.nomcli = detalle.codcli + ' - ' + detalle.nomcli
        detalle.nomven = detalle.codven + ' - ' + detalle.nomven
        detalle.desmat = detalle.codmat + ' - ' + detalle.desmat
        detalle.nomfam = detalle.codfam + ' - ' + detalle.nomfam
        detalle.nomsubfam = detalle.subfam + ' - ' + detalle.nomsubfam 
        detalle.deslicencia = detalle.licencia + ' - ' + detalle.deslicencia.
END.
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

IF x-UserVerCostos = YES THEN DO:
    ASSIGN
        pOptions = pOptions + CHR(1) + "FieldList:" + "desdiv,desdivdes,coddoc,nrodoc,"
        + "fchdoc,desfmapgo,nomcli,nomven,DesMat,NomFam,NomSubFam,DesMar,UndStk,DesLicencia,"
        + "ImpNacCIGV,ImpExtCIGV,CostoUniKrdx,CostoTotKrdx,Cantidad".
END.
ELSE DO:
    ASSIGN
        pOptions = pOptions + CHR(1) + "FieldList:" + "desdiv,desdivdes,coddoc,nrodoc,"
        + "fchdoc,desfmapgo,nomcli,nomven,DesMat,NomFam,NomSubFam,DesMar,UndStk,DesLicencia,"
        + "ImpNacCIGV,ImpExtCIGV,Cantidad".
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
  DISPLAY FILL-IN-Mensaje x-CodDiv COMBO-BOX-CodFam COMBO-BOX-SubFam 
          FILL-IN-CodCli FILL-IN-NomCli FILL-IN-file DesdeF HastaF 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE BUTTON-1 BtnDone BUTTON-Division COMBO-BOX-CodFam COMBO-BOX-SubFam 
         FILL-IN-CodCli BUTTON-5 DesdeF HastaF 
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
    DesdeF = TODAY - DAY(TODAY) + 1
    HastaF = TODAY.
/*   FOR EACH DimDivision NO-LOCK:                                                                          */
/*       COMBO-BOX-CodDiv:ADD-LAST(DimDivision.coddiv + ' - ' + DimDivision.DesDiv) IN FRAME {&FRAME-NAME}. */
/*   END.                                                                                                   */
  FOR EACH DimLinea NO-LOCK BREAK BY DimLinea.codfam:
      IF FIRST-OF(DimLinea.codfam) THEN
      COMBO-BOX-CodFam:ADD-LAST(DimLinea.codfam + ' - ' + DimLinea.nomfam) IN FRAME {&FRAME-NAME}.
  END.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros wWin 
PROCEDURE procesa-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    output-var-1 como ROWID
    output-var-2 como CHARACTER
    output-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros wWin 
PROCEDURE recoge-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    input-var-1 como CHARACTER
    input-var-2 como CHARACTER
    input-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
         */      
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

