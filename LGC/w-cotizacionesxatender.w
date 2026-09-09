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

DEFINE SHARED VAR s-codcia AS INT.
DEFINE VAR lFechaTope AS DATE.
DEFINE VAR lFechaActual AS DATE.
DEFINE VAR lDivisiones AS CHAR.
DEFINE VAR lTotCotizaciones AS DEC.

DEFINE TEMP-TABLE tt-cot-dtl
        FIELDS tt-divi AS CHAR
        FIELDS tt-nrocot AS CHAR
        FIELDS tt-codmat AS CHAR
        FIELDS tt-cant AS DEC       
    
        INDEX idx01 IS PRIMARY tt-divi tt-nrocot tt-codmat.

DEFINE TEMP-TABLE tt-cot-hdr
        FIELDS tt-divi AS CHAR
        FIELD tt-nrocot AS CHAR
        FIELDS tt-alm AS CHAR
        FIELDS tt-ubigeo AS CHAR
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
&Scoped-Define ENABLED-OBJECTS chbDetalleCot ChbxGrabaCot rdBtnCual ~
txtDesde txtFechaTope txtAlmOtros txtDivisiones btnProcesar txtListaPrecio 
&Scoped-Define DISPLAYED-OBJECTS chbDetalleCot ChbxGrabaCot rdBtnCual ~
txtDesde txtHasta txtFechaTope txtAlmOtros txtDivisiones txtMsg ~
txtListaPrecio 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnProcesar 
     LABEL "Procesar" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE txtAlmOtros AS CHARACTER FORMAT "X(5)":U INITIAL "11e" 
     LABEL "Las Cotizaciones sin Punto de Salida deben ser atendidos del" 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE txtAlmPesoMaximo AS CHARACTER FORMAT "X(5)":U INITIAL "21" 
     LABEL "Almacen asignar para Cotizaciones mayores de 10,000" 
     VIEW-AS FILL-IN 
     SIZE 6.29 BY 1 NO-UNDO.

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

DEFINE VARIABLE rdBtnCual AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Faltantes", 1,
"Excedentes", 2
     SIZE 29 BY .77 NO-UNDO.

DEFINE VARIABLE chbDetalleCot AS LOGICAL INITIAL no 
     LABEL "Generar el Excel con detalle de las cotizaciones" 
     VIEW-AS TOGGLE-BOX
     SIZE 44 BY .77 NO-UNDO.

DEFINE VARIABLE ChbxGrabaCot AS LOGICAL INITIAL no 
     LABEL "Marcar las cotizacion como PROCESADAS y grabar fecha TOPE" 
     VIEW-AS TOGGLE-BOX
     SIZE 60.14 BY .77
     FGCOLOR 4  NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     chbDetalleCot AT ROW 14.65 COL 10 WIDGET-ID 36
     ChbxGrabaCot AT ROW 13.62 COL 15.86 WIDGET-ID 32
     rdBtnCual AT ROW 15.96 COL 7.43 NO-LABEL WIDGET-ID 26
     txtDesde AT ROW 2.12 COL 13.57 COLON-ALIGNED WIDGET-ID 2
     txtHasta AT ROW 2.12 COL 35 COLON-ALIGNED WIDGET-ID 12
     txtFechaTope AT ROW 3.31 COL 36 COLON-ALIGNED WIDGET-ID 14
     txtAlmPesoMaximo AT ROW 4.85 COL 53.86 COLON-ALIGNED WIDGET-ID 16
     txtAlmOtros AT ROW 6.19 COL 53.86 COLON-ALIGNED WIDGET-ID 18
     txtDivisiones AT ROW 8.81 COL 5 NO-LABEL WIDGET-ID 8
     btnProcesar AT ROW 15.81 COL 55 WIDGET-ID 4
     txtMsg AT ROW 12.23 COL 3.14 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     txtListaPrecio AT ROW 10.96 COL 5 NO-LABEL WIDGET-ID 20
     "Divisiones a considerar" VIEW-AS TEXT
          SIZE 28.57 BY .88 AT ROW 7.85 COL 5.43 WIDGET-ID 10
          FGCOLOR 4 FONT 9
     "Con estas LISTA de PRECIOS" VIEW-AS TEXT
          SIZE 43.57 BY .81 AT ROW 10.12 COL 5.29 WIDGET-ID 22
          FGCOLOR 9 FONT 9
     "Canal Moderno (00017) va ir x el 21e" VIEW-AS TEXT
          SIZE 34 BY .77 AT ROW 7.88 COL 37.57 WIDGET-ID 24
          FGCOLOR 1 
     "Considerar todas las cotizaciones cuya fecha de emision sea" VIEW-AS TEXT
          SIZE 53.72 BY .62 AT ROW 1.35 COL 4.72 WIDGET-ID 30
          FGCOLOR 4 
     "Fecha TOPE" VIEW-AS TEXT
          SIZE 17.57 BY .96 AT ROW 3.31 COL 52.43 WIDGET-ID 34
          FGCOLOR 9 FONT 11
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 76 BY 16.42 WIDGET-ID 100.


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
         TITLE              = "Cotizaciones por Atender"
         HEIGHT             = 16.42
         WIDTH              = 76
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
   FRAME-NAME Custom                                                    */
ASSIGN 
       txtAlmOtros:HIDDEN IN FRAME fMain           = TRUE.

/* SETTINGS FOR FILL-IN txtAlmPesoMaximo IN FRAME fMain
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       txtAlmPesoMaximo:HIDDEN IN FRAME fMain           = TRUE.

/* SETTINGS FOR FILL-IN txtDivisiones IN FRAME fMain
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN txtHasta IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtListaPrecio IN FRAME fMain
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN txtMsg IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
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


&Scoped-define SELF-NAME btnProcesar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnProcesar wWin
ON CHOOSE OF btnProcesar IN FRAME fMain /* Procesar */
DO:
  ASSIGN txtDesde txthasta txtDivisiones txtFechaTope txtAlmPesoMaximo 
      txtAlmOtros txtListaPrecio rdBtnCual ChbxGrabaCot ChbDetalleCot.

  IF txtDesde > txtHasta THEN DO:
      MESSAGE "Fechas Erradas".
      RETURN NO-APPLY.
  END.
  IF txtDivisiones="" OR txtDivisiones = ? THEN DO:
      MESSAGE "Ingrese alguna Division".
      RETURN NO-APPLY.
  END.
  IF txtAlmPesoMaximo = "" OR txtAlmPesoMaximo = ?  THEN DO:
      MESSAGE "Ingrese Almacen para Cotizaciones pesadas".
      RETURN NO-APPLY.
  END.
  IF txtAlmOtros = "" OR txtAlmOtros = ? THEN DO:
      MESSAGE "Ingrese Almacen Ubigeos errados".
      RETURN NO-APPLY.
  END.

  IF txtFechaTope < txtDesde THEN DO:
      MESSAGE "Fecha de entrega debe ser mayor/igual a fecha DESDE".
      RETURN NO-APPLY.
  END.

  FIND FIRST almacen WHERE almacen.codcia = s-codcia AND 
                    almacen.codalm = txtAlmPesoMaximo NO-LOCK NO-ERROR.
  IF NOT AVAILABLE almacen THEN DO:
      MESSAGE "Almacen para Cotizaciones pesadas NO EXISTE".
      RETURN NO-APPLY.
  END.

  FIND FIRST almacen WHERE almacen.codcia = s-codcia AND 
                    almacen.codalm = txtAlmOtros NO-LOCK NO-ERROR.
  IF NOT AVAILABLE almacen THEN DO:
      MESSAGE "Almacen Ubigeos errados NO EXISE".
      RETURN NO-APPLY.
  END.

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
  DISPLAY chbDetalleCot ChbxGrabaCot rdBtnCual txtDesde txtHasta txtFechaTope 
          txtAlmOtros txtDivisiones txtMsg txtListaPrecio 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE chbDetalleCot ChbxGrabaCot rdBtnCual txtDesde txtFechaTope txtAlmOtros 
         txtDivisiones btnProcesar txtListaPrecio 
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
DEFINE VAR lUbigeo AS CHAR.
DEFINE VAR lUbigeoX AS CHAR.

DEFINE VAR lCodAlm AS CHAR.
DEFINE VAR lCodMat AS CHAR.
DEFINE VAR lStk AS DEC.
DEFINE VAR lStkRsrv AS DEC.
DEFINE VAR lStkRepo AS DEC.
DEFINE VAR lQtyxRecepcionar AS DEC.

DEFINE VAR lSumaAtendida AS DEC.
DEFINE VAR lEstado AS CHAR FORMAT 'x(30)'.
DEFINE VAR lProcesadoDtl AS LOG.

DEFINE VAR lCotizaciones AS CHAR.

lFechaX =  lFechaTope.
txtListaPrecio = TRIM(txtListaPRecio).

SESSION:SET-WAIT-STATE('GENERAL').

txtmsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Cotizaciones" .

/* Sumando las Cotizaciones que no esten anuladas */

FOR EACH faccpedi WHERE faccpedi.codcia = s-codcia AND 
    faccpedi.coddoc = 'COT' AND 
    (faccpedi.fchped  >= txtDesde AND faccpedi.fchped <= lFechaActual ) AND
    faccpedi.fchent <= lFechaTope AND 
    /*faccpedi.nroped = '018143024' AND */
    LOOKUP (faccpedi.coddiv,lDivisiones) > 0 NO-LOCK :       
/*
lCotizaciones = '015181002,015181041,015181123,018180033'.

FOR EACH faccpedi WHERE faccpedi.codcia = s-codcia AND 
    faccpedi.coddoc = 'COT' AND 
    LOOKUP(faccpedi.nroped,lCotizaciones) > 0 NO-LOCK:
*/
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
/*
    FOR EACH facdpedi OF faccpedi WHERE (facdpedi.canped - facdpedi.canate ) > 0 NO-LOCK,
        FIRST almmmatg OF facdpedi:
*/        
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

/* Ic - 01Dic2016, Considerar Cotizaciones Excepcion */
RUN ue-proc-expocot.
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
                ASSIGN tt-cot-final.tt-alm  = lCodAlm
                        tt-cot-final.tt-codmat = tt-cot-dtl.tt-codmat
                        tt-cot-final.tt-desmat = IF(AVAILABLE almmmatg) THEN almmmatg.desmat ELSE ""
                        tt-cot-final.tt-inner = IF(AVAILABLE almmmatg) THEN almmmatg.StkRep ELSE 1
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
        RUN vta2/stock-comprometido-v2.r(INPUT lcodmat, INPUT lCodAlm,  OUTPUT lStkRsrv).

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

/* Marco las COTIZACIONES como procesadas */
IF chbxGrabaCot = YES THEN DO:
    txtmsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Marcando la COTIZACION como PROCESADO" .

    DEFINE BUFFER b-faccpedi FOR faccpedi.

    FOR EACH tt-cot-hdr :
        FIND FIRST b-faccpedi WHERE b-faccpedi.codcia = s-codcia AND 
                                b-faccpedi.coddoc = 'COT' AND 
                                b-faccpedi.nroped = tt-cot-hdr.tt-nrocot NO-ERROR.
        IF AVAILABLE b-faccpedi THEN DO:
            ASSIGN b-faccpedi.libre_c02 = 'PROCESADO'.
        END.        
    END.
    RELEASE b-faccpedi.
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
            vtatabla.rango_fecha[1] = TODAY.
    
    RELEASE vtatabla.
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

SESSION:SET-WAIT-STATE('GENERAL').

lFileXls = "".          /* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */
lNuevoFile = YES.       /* YES : Si va crear un nuevo archivo o abrir */

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
    RUN vta2/stock-comprometido-v2.r(INPUT tt-cot-final.tt-codmat, INPUT '11',  OUTPUT lStkReservado).
    FIND FIRST almmmate WHERE almmmate.codcia = s-codcia AND
                        almmmate.codalm = '11' AND 
                        almmmate.codmat = tt-cot-final.tt-codmat NO-LOCK NO-ERROR.
    IF AVAILABLE almmmate THEN DO:
        cRange = "Q" + cColumn.
        chWorkSheet:Range(cRange):Value = IF ((almmmate.stkact - lStkReservado) < 0) THEN 0 ELSE (almmmate.stkact - lStkReservado).
    END.

    lStkReservado = 0.
    RUN vta2/stock-comprometido-v2.r(INPUT tt-cot-final.tt-codmat, INPUT '21',  OUTPUT lStkReservado).
    FIND FIRST almmmate WHERE almmmate.codcia = s-codcia AND
                        almmmate.codalm = '21' AND 
                        almmmate.codmat = tt-cot-final.tt-codmat NO-LOCK NO-ERROR.
    IF AVAILABLE almmmate THEN DO:
        cRange = "R" + cColumn.
        chWorkSheet:Range(cRange):Value = IF ((almmmate.stkact - lStkReservado) < 0) THEN 0 ELSE (almmmate.stkact - lStkReservado).
    END.

    lStkReservado = 0.
    RUN vta2/stock-comprometido-v2.r(INPUT tt-cot-final.tt-codmat, INPUT '14',  OUTPUT lStkReservado).
    FIND FIRST almmmate WHERE almmmate.codcia = s-codcia AND
                        almmmate.codalm = '14' AND 
                        almmmate.codmat = tt-cot-final.tt-codmat NO-LOCK NO-ERROR.
    IF AVAILABLE almmmate THEN DO:
        cRange = "S" + cColumn.
        chWorkSheet:Range(cRange):Value = IF ((almmmate.stkact - lStkReservado) < 0) THEN 0 ELSE (almmmate.stkact - lStkReservado).
    END.

    lStkReservado = 0.
    RUN vta2/stock-comprometido-v2.r(INPUT tt-cot-final.tt-codmat, INPUT '35',  OUTPUT lStkReservado).
    FIND FIRST almmmate WHERE almmmate.codcia = s-codcia AND
                        almmmate.codalm = '35' AND 
                        almmmate.codmat = tt-cot-final.tt-codmat NO-LOCK NO-ERROR.
    IF AVAILABLE almmmate THEN DO:
        cRange = "T" + cColumn.
        chWorkSheet:Range(cRange):Value = IF ((almmmate.stkact - lStkReservado) < 0) THEN 0 ELSE (almmmate.stkact - lStkReservado).
    END.

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
    
    FOR EACH tt-cot-dtl NO-LOCK:
        FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
                                    almmmatg.codmat = tt-cot-dtl.tt-codmat NO-LOCK NO-ERROR.
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
    END.
END.

/*

            CREATE tt-cot-dtl.
                ASSIGN tt-cot-dtl.tt-divi = faccpedi.coddiv
                        tt-cot-dtl.tt-nrocot = faccpedi.nroped
                        tt-cot-dtl.tt-codmat = facdpedi.codmat
                        tt-cot-dtl.tt-cant = 0.

 */

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
txtmsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "...Terminoo" .

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

