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
DEF VAR x-CodDiv LIKE gn-divi.coddiv   NO-UNDO.
DEF VAR x-CodCli LIKE gn-clie.codcli   NO-UNDO.
DEF VAR x-CodMat LIKE almmmatg.codmat  NO-UNDO.
DEF VAR x-CodPro LIKE gn-prov.codpro   NO-UNDO.
DEF VAR x-CodVen LIKE gn-ven.codven    NO-UNDO.
DEF VAR x-CodFam LIKE almmmatg.codfam  NO-UNDO.
DEF VAR x-SubFam LIKE almmmatg.subfam  NO-UNDO.
DEF VAR x-CanalVenta LIKE gn-divi.CanalVenta NO-UNDO.
DEF VAR x-Canal  LIKE gn-clie.canal    NO-UNDO.
DEF VAR x-Giro   LIKE gn-clie.gircli   NO-UNDO.
DEF VAR x-NroCard LIKE gn-clie.nrocard NO-UNDO.
DEF VAR x-Zona   AS CHAR               NO-UNDO.
DEF VAR x-CodDept LIKE gn-clie.coddept NO-UNDO.
DEF VAR x-CodProv LIKE gn-clie.codprov NO-UNDO.
DEF VAR x-CodDist LIKE gn-clie.coddist NO-UNDO.
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
     SIZE 43 BY .92 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-SubFam AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Sub-linea" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 43 BY .92 NO-UNDO.

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
        FOR EACH Almsfami NO-LOCK WHERE Almsfami.codcia = s-codcia
            AND Almsfami.codfam = ENTRY(1, SELF:SCREEN-VALUE, ' - '):
            COMBO-BOX-SubFam:ADD-LAST(Almsfami.subfam + ' - '+ AlmSFami.dessub).
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
    /*x-Titulo = 'DIVISION|CANAL-VENTA|'*/
    x-Titulo = 'DIVISION|'
    x-Titulo = x-Titulo + 'DOC|NUMERO' + '|'
    x-Titulo = x-Titulo + 'FECHA|'
    x-Titulo = x-Titulo + 'CLIENTE|'
    /*x-Titulo = x-Titulo + 'CANAL|TARJETA-CLIENTE|DEPARTAMENTO|PROVINCIA|DISTRITO|ZONA|VENDEDOR|'*/
    x-Titulo = x-Titulo + 'VENDEDOR|'
    /*x-Titulo = x-Titulo + 'ARTICULO|LINEA|SUBLINEA|MARCA|UNIDAD|LICENCIA|PROVEEDOR|'*/
    x-Titulo = x-Titulo + 'ARTICULO|LINEA|SUBLINEA|MARCA|UNIDAD|LICENCIA|'
    x-Titulo = x-Titulo + 'IMPORTE S/.|IMPORTE US$|CANTIDAD|'.
x-Titulo = REPLACE(x-Titulo, '|', CHR(9)).
PUT STREAM REPORTE UNFORMATTED x-Titulo SKIP.
FOR EACH dwh_ventas_cab NO-LOCK WHERE dwh_ventas_cab.codcia = s-codcia
    AND dwh_ventas_cab.coddiv BEGINS x-CodDiv
    AND dwh_ventas_cab.fecha >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99") + STRING(DAY(DesdeF), "99"))
    AND dwh_ventas_cab.fecha <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99") + STRING(DAY(HastaF), "99")),
    EACH dwh_ventas_det OF dwh_ventas_cab NO-LOCK,
    FIRST Almmmatg OF dwh_ventas_det NO-LOCK WHERE Almmmatg.codfam BEGINS x-CodFam
    AND Almmmatg.subfam BEGINS x-SubFam:
    x-LLave = ''.

    x-Llave = dwh_ventas_cab.coddiv.
    FIND gn-divi WHERE gn-divi.codcia = s-codcia
        AND gn-divi.coddiv = dwh_ventas_cab.coddiv
        NO-LOCK.
    x-Llave = TRIM(x-Llave) + ' - ' + TRIM(GN-DIVI.DesDiv) + '|'.
/*     x-Llave = x-Llave + gn-divi.CanalVenta.                                                */
/*     FIND vtamcanal WHERE Vtamcanal.Codcia = s-codcia                                       */
/*         AND Vtamcanal.CanalVenta = gn-divi.CanalVenta                                      */
/*         NO-LOCK NO-ERROR.                                                                  */
/*     IF AVAILABLE vtamcanal THEN x-Llave = x-Llave + ' - ' + TRIM(Vtamcanal.Descrip) + '|'. */
/*     ELSE x-Llave = x-Llave + 'SIN CANAL' + '|'.                                            */

    x-Llave = x-Llave + dwh_ventas_cab.CodDoc + '|' + dwh_ventas_cab.NroDoc + '|'.
    x-Llave = x-Llave + SUBSTRING ( STRING(dwh_ventas_cab.Fecha, '99999999') , 7, 2) + '/' +
                SUBSTRING ( STRING(dwh_ventas_cab.Fecha, '99999999') , 5, 2) + '/' +
                SUBSTRING ( STRING(dwh_ventas_cab.Fecha, '99999999') , 1, 4) + '|'.

    IF x-Cuenta-Registros MODULO 1000 = 0 THEN 
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = dwh_ventas_cab.coddiv + ' ' +
        dwh_ventas_cab.CodDoc + ' ' + dwh_ventas_cab.NroDoc + ' ' +
        SUBSTRING ( STRING(dwh_ventas_cab.Fecha, '99999999') , 7, 2) + '/' +
                SUBSTRING ( STRING(dwh_ventas_cab.Fecha, '99999999') , 5, 2) + '/' +
                SUBSTRING ( STRING(dwh_ventas_cab.Fecha, '99999999') , 1, 4).
    /* CLIENTE */
    ASSIGN
        x-Canal   = ''
        x-Giro    = ''
        x-NroCard = ''
        x-Zona    = ''
        x-CodDept = ''
        x-CodProv = ''
        x-CodDist = ''.
    FIND gn-clie WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = dwh_ventas_cab.codcli
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie THEN DO:
        x-Llave = x-Llave + dwh_ventas_cab.codcli + ' - '  + TRIM (gn-clie.nomcli) + '|'.
        ASSIGN
            x-Canal   = gn-clie.canal
            x-Giro    = gn-clie.gircli
            x-NroCard = gn-clie.nrocard
            x-CodDept = gn-clie.coddept
            x-CodProv = gn-clie.codprov
            x-CodDist = gn-clie.coddist.
        /* ZONA */
        FIND TabDepto WHERE TabDepto.CodDepto = gn-clie.CodDept NO-LOCK NO-ERROR.
        IF AVAILABLE TabDepto THEN x-Zona = TabDepto.Zona.
        IF gn-clie.CodDept = '15' AND gn-clie.CodProv = '01' THEN x-Zona = 'LMC'.
    END.
    ELSE x-Llave = x-Llave + dwh_ventas_cab.codcli + ' - ' + '|'.
    /* CANAL CLIENTE */
    FIND almtabla WHERE almtabla.Tabla = 'CN' AND almtabla.Codigo = x-Canal NO-LOCK NO-ERROR.
    IF AVAILABLE almtabla THEN x-Canal = x-Canal + ' - ' + TRIM(almtabla.Nombre).
    ELSE x-Canal = x-Canal + ' - '.
    /* Tarjeta Cliente Exclusivo */
    FIND gn-card WHERE gn-card.NroCard = x-NroCard NO-LOCK NO-ERROR.
    IF AVAILABLE gn-card THEN x-NroCard = x-NroCard + ' - ' + TRIM(gn-card.NomCard).
    ELSE x-NroCard = x-NroCard + ' - '.
    /* DEPARTAMENTO */
    FIND TabDepto WHERE TabDepto.CodDepto = x-CodDept NO-LOCK NO-ERROR.
    /* PROVINCIA */
    FIND Tabprovi WHERE Tabprovi.CodDepto = x-CodDept AND Tabprovi.Codprovi = x-CodProv NO-LOCK NO-ERROR.
    /* DISTRITO */
    FIND Tabdistr WHERE Tabdistr.CodDepto = x-CodDept AND Tabdistr.Codprovi = x-codprov
        AND Tabdistr.Coddistr = x-coddist NO-LOCK NO-ERROR.
    /* ZONA */
    FIND FacTabla WHERE FacTabla.CodCia = s-codcia
        AND FacTabla.Tabla = 'ZN'
        AND FacTabla.Codigo = x-Zona NO-LOCK NO-ERROR.
    IF AVAILABLE FacTabla THEN x-Zona = x-Zona + ' - ' + TRIM(FacTabla.Nombre).
    ELSE x-Zona = x-Zona + ' - '.
    
    IF AVAILABLE TabDepto THEN x-CodDept = x-CodDept + ' - ' + TRIM(TabDepto.NomDepto).
    ELSE x-CodDept = x-CodDept + ' - '.
    IF AVAILABLE Tabprovi THEN x-CodProv = x-CodProv + ' - ' + TRIM(Tabprovi.Nomprovi).
    ELSE x-CodProv = x-CodProv + ' - '.
    IF AVAILABLE Tabdistr THEN x-CodDist = x-CodDist + ' - ' + TRIM(Tabdistr.Nomdistr).
    ELSE x-CodDist = x-CodDist + ' - '.
/*     x-Llave = x-Llave + x-canal + '|'.   */
/*     x-Llave = x-Llave + x-nrocard + '|'. */
/*     x-Llave = x-Llave + x-coddept + '|'. */
/*     x-Llave = x-Llave + x-codprov + '|'. */
/*     x-Llave = x-Llave + x-coddist + '|'. */
/*     x-Llave = x-Llave + x-zona + '|'.    */
    /* ******* */
                        
    /* VENDEDOR */
    x-Llave = x-Llave + dwh_ventas_cab.CodVen.
    FIND gn-ven WHERE gn-ven.codcia = s-codcia
        AND gn-ven.codven = dwh_ventas_cab.CodVen
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-ven THEN x-Llave = x-LLave + ' - ' + TRIM(gn-ven.NomVen) + '|'.
    ELSE x-Llave = x-LLave + ' - ' + '|'.

    /* ARTICULO */
    x-Llave = x-Llave + dwh_ventas_det.codmat.
    x-Llave = x-LLave + ' - ' + TRIM(Almmmatg.desmat) + '|'.
    x-Llave = x-Llave + Almmmatg.codfam.
    FIND Almtfami WHERE Almtfami.codcia = s-codcia
        AND Almtfami.codfam = Almmmatg.codfam
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almtfami THEN x-Llave = x-Llave + ' - ' + TRIM(Almtfami.desfam) + '|'.
    ELSE x-Llave = x-Llave + ' - ' + '|'.
    x-Llave = x-Llave + Almmmatg.subfam.
    FIND Almsfami WHERE Almsfami.codcia = s-codcia
        AND Almsfami.codfam = Almmmatg.codfam
        AND Almsfami.subfam = Almmmatg.subfam
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almsfami THEN x-Llave = x-Llave + ' - ' + TRIM(AlmSFami.dessub) + '|'.
    ELSE x-Llave = x-Llave + ' - ' + '|'.
    x-Llave = x-Llave + Almmmatg.desmar + '|'.
    x-Llave = x-Llave + Almmmatg.undbas + '|'.
    x-Llave = x-Llave + Almmmatg.licencia[1].
    FIND almtabla WHERE almtabla.Tabla = "LC" 
        AND almtabla.Codigo = Almmmatg.licencia[1] NO-LOCK NO-ERROR.
    IF AVAILABLE Almtabla THEN x-Llave = x-Llave + ' - ' + TRIM(almtabla.Nombre) + '|'.
    ELSE x-Llave = x-Llave + ' - ' + '|'.
/*     x-Llave = x-Llave + Almmmatg.codpr1.                                              */
/*     FIND gn-prov WHERE gn-prov.codcia = pv-codcia                                     */
/*         AND gn-prov.codpro = Almmmatg.codpr1                                          */
/*         NO-LOCK NO-ERROR.                                                             */
/*     IF AVAILABLE gn-prov THEN x-Llave = x-LLave + ' - ' + TRIM(gn-prov.NomPro) + '|'. */
/*     ELSE x-Llave = x-LLave + ' - ' + '|'.                                             */

    /* TOTALES */
    x-Llave = x-Llave + STRING(dwh_ventas_det.ImpNacCIGV, '->>>>>>>>9.99') + '|' +
        STRING(dwh_ventas_det.ImpExtCIGV, '->>>>>>>>9.99') + '|'.
    x-Llave = x-Llave + STRING(dwh_ventas_det.Cantidad, '->>>>>>>>9.99') + '|'.

    x-Llave = REPLACE(x-Llave, '|', CHR(9)).
    PUT STREAM REPORTE UNFORMATTED x-Llave SKIP.
    /* RHC 01.04.11 control de registros */
    x-Cuenta-Registros = x-Cuenta-Registros + 1.
    IF x-Cuenta-Registros > 65000 THEN DO:
        MESSAGE 'Se ha llegado al tope de 65000 registros que soporta el Excel' SKIP
            'Carga abortada' VIEW-AS ALERT-BOX WARNING.
        LEAVE.
    END.
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
  FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia:
      COMBO-BOX-CodDiv:ADD-LAST(gn-divi.coddiv + ' - ' + GN-DIVI.DesDiv) IN FRAME {&FRAME-NAME}.
  END.
  FOR EACH Almtfami NO-LOCK WHERE Almtfami.CodCia = s-codcia:
      COMBO-BOX-CodFam:ADD-LAST(Almtfami.codfam + ' - ' + Almtfami.desfam) IN FRAME {&FRAME-NAME}.
  END.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

