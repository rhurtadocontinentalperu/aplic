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

/* VARIABLES PARA EL RESUMEN */
DEF VAR x-CodDiv LIKE DimDivision.coddiv   NO-UNDO.
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
&Scoped-Define ENABLED-OBJECTS BUTTON-1 BtnDone COMBO-BOX-CodDiv ~
COMBO-BOX-CodFam COMBO-BOX-SubFam DesdeF HastaF 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Mensaje COMBO-BOX-CodDiv ~
COMBO-BOX-CodFam COMBO-BOX-SubFam DesdeF HastaF 

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

DEFINE VARIABLE COMBO-BOX-CodDiv AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Division" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 70 BY 1 NO-UNDO.

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

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 103 BY 1 NO-UNDO.

DEFINE VARIABLE HastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     BUTTON-1 AT ROW 1 COL 112 WIDGET-ID 24
     BtnDone AT ROW 1 COL 118 WIDGET-ID 28
     FILL-IN-Mensaje AT ROW 1.27 COL 6 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     COMBO-BOX-CodDiv AT ROW 3.15 COL 29 COLON-ALIGNED WIDGET-ID 30
     COMBO-BOX-CodFam AT ROW 4.23 COL 29 COLON-ALIGNED WIDGET-ID 36
     COMBO-BOX-SubFam AT ROW 5.31 COL 29 COLON-ALIGNED WIDGET-ID 38
     DesdeF AT ROW 6.38 COL 29 COLON-ALIGNED WIDGET-ID 10
     HastaF AT ROW 6.38 COL 49 COLON-ALIGNED WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 130.43 BY 8.46 WIDGET-ID 100.


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
         HEIGHT             = 8.46
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

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME fMain
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
        COMBO-BOX-CodDiv 
        COMBO-BOX-CodFam 
        COMBO-BOX-SubFam.
    ASSIGN
        DesdeF HastaF.

    SESSION:SET-WAIT-STATE('GENERAL').
    RUN Excel.
    SESSION:SET-WAIT-STATE('').

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
  DISPLAY FILL-IN-Mensaje COMBO-BOX-CodDiv COMBO-BOX-CodFam COMBO-BOX-SubFam 
          DesdeF HastaF 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE BUTTON-1 BtnDone COMBO-BOX-CodDiv COMBO-BOX-CodFam COMBO-BOX-SubFam 
         DesdeF HastaF 
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
DEF VAR x-Llave AS CHAR FORMAT 'x(1000)' NO-UNDO.
DEF VAR i-Campo AS INT INIT 1 NO-UNDO.
DEF VAR x-Campo AS CHAR NO-UNDO.
DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR x-Titulo AS CHAR FORMAT 'x(500)' NO-UNDO.
DEF VAR l-Titulo AS LOG INIT NO NO-UNDO.
DEF VAR x-Cuenta-Registros AS INT INIT 0 NO-UNDO.

x-Archivo = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".txt".

FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** GENERANDO EL EXCEL **".

ASSIGN
    x-CodDiv = ''
    x-CodFam = ''
    x-SubFam = ''.
IF NOT COMBO-BOX-CodDiv BEGINS 'Todos' THEN x-CodDiv = ENTRY(1, COMBO-BOX-CodDiv, ' - ').
IF NOT COMBO-BOX-CodFam BEGINS 'Todos' THEN x-CodFam = ENTRY(1, COMBO-BOX-CodFam, ' - ').
IF NOT COMBO-BOX-SubFam BEGINS 'Todos' THEN x-SubFam = ENTRY(1, COMBO-BOX-SubFam, ' - ').

OUTPUT STREAM REPORTE TO VALUE (x-Archivo).
ASSIGN
    x-Titulo = ''
    x-Titulo = 'DIVISION|DESTINO|'
    x-Titulo = x-Titulo + 'DOC|NUMERO' + '|'
    x-Titulo = x-Titulo + 'DateKey|'
    x-Titulo = x-Titulo + 'CONDVTA' + '|'
    x-Titulo = x-Titulo + 'CLIENTE|'
    x-Titulo = x-Titulo + 'VENDEDOR|'
    x-Titulo = x-Titulo + 'ARTICULO|LINEA|SUBLINEA|MARCA|UNIDAD|LICENCIA|'
    x-Titulo = x-Titulo + 'IMPORTE S/.|IMPORTE US$|CANTIDAD|'.
x-Titulo = REPLACE(x-Titulo, '|', CHR(9)).
PUT STREAM REPORTE UNFORMATTED x-Titulo SKIP.
FOR EACH Ventas_Cabecera NO-LOCK WHERE (x-CodDiv = "" OR Ventas_Cabecera.coddiv = x-CodDiv)
    AND Ventas_Cabecera.DateKey >= DesdeF
    AND Ventas_Cabecera.DateKey <= HastaF,
    EACH Ventas_Detalle OF Ventas_Cabecera NO-LOCK,
    FIRST DimProducto OF Ventas_Detalle NO-LOCK WHERE (x-CodFam = "" OR DimProducto.codfam = x-CodFam)
    AND (x-SubFam = "" OR DimProducto.subfam = x-SubFam):
    FIND FIRST DimLinea    OF DimProducto NO-LOCK NO-ERROR.
    FIND FIRST DimSubLinea OF DimProducto NO-LOCK NO-ERROR.
    FIND FIRST DimLicencia OF DimProducto NO-LOCK NO-ERROR.
    x-LLave = ''.
    x-Llave = Ventas_Cabecera.coddiv.
    FIND DimDivision WHERE DimDivision.coddiv = Ventas_Cabecera.coddiv
        NO-LOCK.
    x-Llave = TRIM(x-Llave) + ' - ' + TRIM(DimDivision.DesDiv) + '|'.
    /* Division destino */
    x-Llave = x-Llave + Ventas_Cabecera.DivDes.
    FIND DimDivision WHERE DimDivision.coddiv = Ventas_Cabecera.divdes NO-LOCK NO-ERROR.
    IF AVAILABLE DimDivision THEN x-Llave = TRIM(x-Llave) + ' - ' + TRIM(DimDivision.DesDiv) + '|'.
    ELSE x-Llave = TRIM(x-Llave) + '|'.
    /* **************** */
    x-Llave = x-Llave + Ventas_Cabecera.CodDoc + '|' + Ventas_Cabecera.NroDoc + '|'.
    x-Llave = x-Llave + STRING(Ventas_Cabecera.DateKey, '99/99/9999') + '|'.

    x-Llave = x-Llave + Ventas_Cabecera.FmaPgo.
    FIND gn-ConVt WHERE gn-ConVt.Codig = Ventas_Cabecera.FmaPgo NO-LOCK NO-ERROR.
    IF AVAILABLE gn-ConVt THEN x-Llave = TRIM(x-Llave) + ' - ' + gn-ConVt.Nombr + '|'.
    ELSE x-Llave = TRIM(x-Llave) + '|'.

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
    FIND DimCliente WHERE DimCliente.codcli = Ventas_Cabecera.codcli NO-LOCK NO-ERROR.
    IF AVAILABLE DimCliente THEN DO:
        x-Llave = x-Llave + Ventas_Cabecera.codcli + ' - '  + TRIM (DimCliente.nomcli) + '|'.
    END.
    ELSE x-Llave = x-Llave + Ventas_Cabecera.codcli + ' - ' + '|'.
    /* VENDEDOR */
    x-Llave = x-Llave + Ventas_Cabecera.CodVen.
    FIND DimVendedor WHERE DimVendedor.codven = Ventas_Cabecera.CodVen NO-LOCK NO-ERROR.
    IF AVAILABLE DimVendedor THEN x-Llave = x-LLave + ' - ' + TRIM(DimVendedor.NomVen) + '|'.
    ELSE x-Llave = x-LLave + ' - ' + '|'.

    /* ARTICULO */
    x-Llave = x-Llave + Ventas_Detalle.codmat.
    x-Llave = x-LLave + ' - ' + TRIM(DimProducto.desmat) + '|'.
    x-Llave = x-Llave + DimProducto.codfam + ' - ' + (IF AVAILABLE DimLinea THEN DimLinea.NomFam ELSE '') + '|'.
    x-Llave = x-Llave + DimProducto.subfam + ' - ' + (IF AVAILABLE DimSubLinea THEN DimSubLinea.NomSubFam ELSE '') + '|'.
    x-Llave = x-Llave + DimProducto.desmar + '|'.
    x-Llave = x-Llave + DimProducto.undstk + '|'.
    x-Llave = x-Llave + DimProducto.licencia + ' - ' + (IF AVAILABLE DimLicencia THEN DimLicencia.Descripcion ELSE '') + '|'.

    /* TOTALES */
    x-Llave = x-Llave + STRING(Ventas_Detalle.ImpNacCIGV, '->>>>>>>>9.99') + '|' +
        STRING(Ventas_Detalle.ImpExtCIGV, '->>>>>>>>9.99') + '|'.
    x-Llave = x-Llave + STRING(Ventas_Detalle.Cantidad, '->>>>>>>>9.99') + '|'.

    x-Llave = REPLACE(x-Llave, '|', CHR(9)).
    PUT STREAM REPORTE UNFORMATTED x-Llave SKIP.
    /* RHC 01.04.11 control de registros */
    x-Cuenta-Registros = x-Cuenta-Registros + 1.
/*     IF x-Cuenta-Registros > 65000 THEN DO:                                           */
/*         MESSAGE 'Se ha llegado al tope de 65000 registros que soporta el Excel' SKIP */
/*             'Carga abortada' VIEW-AS ALERT-BOX WARNING.                              */
/*         LEAVE.                                                                       */
/*     END.                                                                             */
END.
OUTPUT STREAM REPORTE CLOSE.
/* CARGAMOS EL EXCEL */
RUN lib/filetext-to-excel(x-Archivo, 'Anexo 1', YES).
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
    DesdeF = TODAY - DAY(TODAY) + 1
    HastaF = TODAY.
  FOR EACH DimDivision NO-LOCK:
      COMBO-BOX-CodDiv:ADD-LAST(DimDivision.coddiv + ' - ' + DimDivision.DesDiv) IN FRAME {&FRAME-NAME}.
  END.
  FOR EACH DimLinea NO-LOCK BREAK BY DimLinea.codfam:
      IF FIRST-OF(DimLinea.codfam) THEN
      COMBO-BOX-CodFam:ADD-LAST(DimLinea.codfam + ' - ' + DimLinea.nomfam) IN FRAME {&FRAME-NAME}.
  END.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

