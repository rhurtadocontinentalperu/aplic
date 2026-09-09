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
&Scoped-Define ENABLED-OBJECTS Chkbxprevta-tru chbDetalleCot ChbxGrabaCot ~
rdBtnCual txtDesde txtFechaTope txtDivisiones btnProcesar Chkbxexpo-tru ~
Chkbxprevta-aqp Chkbxexpo-aqp 
&Scoped-Define DISPLAYED-OBJECTS Chkbxprevta-tru chbDetalleCot ChbxGrabaCot ~
rdBtnCual txtDesde txtHasta txtFechaTope txtAlmDespacho txtDivisiones ~
txtMsg txtListaPrecio txtUltFechaTope Chkbxexpo-tru Chkbxprevta-aqp ~
Chkbxexpo-aqp 

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

DEFINE VARIABLE txtAlmDespacho AS CHARACTER FORMAT "X(25)":U INITIAL "68E,60E" 
     LABEL "Almacen de despacho" 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1
     BGCOLOR 9 FGCOLOR 15 FONT 11 NO-UNDO.

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

DEFINE VARIABLE txtListaPrecio AS CHARACTER FORMAT "X(256)":U INITIAL "10067,20067,20060,10060" 
     VIEW-AS FILL-IN 
     SIZE 64.14 BY 1
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE txtMsg AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 49 BY 1 NO-UNDO.

DEFINE VARIABLE txtUltFechaTope AS CHARACTER FORMAT "X(15)":U 
     LABEL "Ultima fecha tope" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

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

DEFINE VARIABLE Chkbxexpo-aqp AS LOGICAL INITIAL yes 
     LABEL "Expolibreria Arequipa" 
     VIEW-AS TOGGLE-BOX
     SIZE 34 BY .77
     BGCOLOR 15 FGCOLOR 9 FONT 11 NO-UNDO.

DEFINE VARIABLE Chkbxexpo-tru AS LOGICAL INITIAL yes 
     LABEL "Expolibreria Trujillo" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .77
     BGCOLOR 15 FGCOLOR 9 FONT 11 NO-UNDO.

DEFINE VARIABLE Chkbxprevta-aqp AS LOGICAL INITIAL yes 
     LABEL "Preventa Arequipa" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .77
     BGCOLOR 15 FGCOLOR 9 FONT 11 NO-UNDO.

DEFINE VARIABLE Chkbxprevta-tru AS LOGICAL INITIAL yes 
     LABEL "Preventa Trujillo" 
     VIEW-AS TOGGLE-BOX
     SIZE 26.43 BY .77
     BGCOLOR 15 FGCOLOR 9 FONT 11 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     Chkbxprevta-tru AT ROW 5.04 COL 5 WIDGET-ID 96
     chbDetalleCot AT ROW 16.12 COL 12 WIDGET-ID 36
     ChbxGrabaCot AT ROW 15.15 COL 12.14 WIDGET-ID 32
     rdBtnCual AT ROW 17.35 COL 9.43 NO-LABEL WIDGET-ID 26
     txtDesde AT ROW 2.12 COL 6.57 COLON-ALIGNED WIDGET-ID 2
     txtHasta AT ROW 2.12 COL 27.43 COLON-ALIGNED WIDGET-ID 12
     txtFechaTope AT ROW 3.31 COL 32.14 COLON-ALIGNED WIDGET-ID 14
     txtAlmDespacho AT ROW 7.92 COL 40 COLON-ALIGNED WIDGET-ID 18
     txtDivisiones AT ROW 10.19 COL 7 NO-LABEL WIDGET-ID 8
     btnProcesar AT ROW 17.19 COL 57 WIDGET-ID 4
     txtMsg AT ROW 13.62 COL 5.14 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     txtListaPrecio AT ROW 12.35 COL 7 NO-LABEL WIDGET-ID 20
     txtUltFechaTope AT ROW 1.92 COL 59.29 COLON-ALIGNED WIDGET-ID 94
     Chkbxexpo-tru AT ROW 5.04 COL 39.43 WIDGET-ID 98
     Chkbxprevta-aqp AT ROW 6.19 COL 5 WIDGET-ID 100
     Chkbxexpo-aqp AT ROW 6.23 COL 39.43 WIDGET-ID 102
     "Divisiones a considerar" VIEW-AS TEXT
          SIZE 28.57 BY .88 AT ROW 9.23 COL 7.43 WIDGET-ID 10
          FGCOLOR 4 FONT 9
     "Con estas LISTA de PRECIOS" VIEW-AS TEXT
          SIZE 43.57 BY .81 AT ROW 11.5 COL 7.29 WIDGET-ID 22
          FGCOLOR 9 FONT 9
     "Canal Moderno (00017) va ir x el 21e" VIEW-AS TEXT
          SIZE 34 BY .77 AT ROW 9.27 COL 39.57 WIDGET-ID 24
          FGCOLOR 1 
     "Considerar todas las cotizaciones cuya fecha de emision sea" VIEW-AS TEXT
          SIZE 53.72 BY .62 AT ROW 1.23 COL 2 WIDGET-ID 30
          FGCOLOR 4 
     "Fecha TOPE" VIEW-AS TEXT
          SIZE 17.57 BY .96 AT ROW 3.38 COL 49.29 WIDGET-ID 34
          FGCOLOR 12 FONT 11
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 77.86 BY 17.85 WIDGET-ID 100.


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
         HEIGHT             = 17.85
         WIDTH              = 77.86
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
/* SETTINGS FOR FILL-IN txtAlmDespacho IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtDivisiones IN FRAME fMain
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN txtHasta IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtListaPrecio IN FRAME fMain
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN txtMsg IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtUltFechaTope IN FRAME fMain
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
  ASSIGN txtDesde txthasta txtDivisiones txtFechaTope 
      txtAlmDespacho txtListaPrecio rdBtnCual ChbxGrabaCot ChbDetalleCot.

  IF txtDesde > txtHasta THEN DO:
      MESSAGE "Fechas Erradas".
      RETURN NO-APPLY.
  END.
  IF txtDivisiones="" OR txtDivisiones = ? THEN DO:
      MESSAGE "Ingrese alguna Division".
      RETURN NO-APPLY.
  END.
  
  IF txtListaPrecio="" OR txtListaPrecio = ? THEN DO:
      MESSAGE "Ingrese lista de Precios".
      RETURN NO-APPLY.
  END.

  IF txtAlmDespacho = "" OR txtAlmDespacho = ? THEN DO:
      MESSAGE "Ingrese Almacen de Despacho".
      RETURN NO-APPLY.
  END.

  IF txtFechaTope < txtDesde THEN DO:
      MESSAGE "Fecha de entrega debe ser mayor/igual a fecha DESDE".
      RETURN NO-APPLY.
  END.
  /*
  FIND FIRST almacen WHERE almacen.codcia = s-codcia AND 
                    almacen.codalm = txtAlmDespacho NO-LOCK NO-ERROR.
  IF NOT AVAILABLE almacen THEN DO:
      MESSAGE "Almacen de Despacho NO EXISE".
      RETURN NO-APPLY.
  END.
  */
  IF chbxGrabaCot = YES THEN DO:
      /**/
      FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND 
                              vtatabla.tabla = 'DSTRB' AND
                              vtatabla.llave_c1 = 'PROV' 
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


&Scoped-define SELF-NAME Chkbxexpo-aqp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Chkbxexpo-aqp wWin
ON VALUE-CHANGED OF Chkbxexpo-aqp IN FRAME fMain /* Expolibreria Arequipa */
DO:
  RUN refresca-valores.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Chkbxexpo-tru
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Chkbxexpo-tru wWin
ON VALUE-CHANGED OF Chkbxexpo-tru IN FRAME fMain /* Expolibreria Trujillo */
DO:
  RUN refresca-valores.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Chkbxprevta-aqp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Chkbxprevta-aqp wWin
ON VALUE-CHANGED OF Chkbxprevta-aqp IN FRAME fMain /* Preventa Arequipa */
DO:
  RUN refresca-valores.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Chkbxprevta-tru
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Chkbxprevta-tru wWin
ON VALUE-CHANGED OF Chkbxprevta-tru IN FRAME fMain /* Preventa Trujillo */
DO:

    RUN refresca-valores.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE blanquear-cotizacion wWin 
PROCEDURE blanquear-cotizacion :
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
                        ic-faccpedi.nroped = ic-faccpedi.nroped NO-ERROR.
    IF AVAILABLE ic-faccpedi THEN DO:
        ASSIGN ic-faccpedi.libre_c02 = ''.
    END.
END.

RELEASE ic-faccpedi.


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
  DISPLAY Chkbxprevta-tru chbDetalleCot ChbxGrabaCot rdBtnCual txtDesde txtHasta 
          txtFechaTope txtAlmDespacho txtDivisiones txtMsg txtListaPrecio 
          txtUltFechaTope Chkbxexpo-tru Chkbxprevta-aqp Chkbxexpo-aqp 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE Chkbxprevta-tru chbDetalleCot ChbxGrabaCot rdBtnCual txtDesde 
         txtFechaTope txtDivisiones btnProcesar Chkbxexpo-tru Chkbxprevta-aqp 
         Chkbxexpo-aqp 
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

  FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND 
                          vtatabla.tabla = 'DSTRB' AND
                          vtatabla.llave_c1 = 'PROV' 
                          NO-LOCK NO-ERROR.
  IF AVAILABLE vtatabla THEN DO:
      txtUltFechaTope:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(vtatabla.rango_fecha[2],"99/99/9999").
  END.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refresca-valores wWin 
PROCEDURE refresca-valores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-lista-precios AS CHAR INIT "".
DEFINE VAR x-coma AS CHAR INIT "".
DEFINE VAR x-value AS CHAR.
DEFINE VAR x-alm-tru AS CHAR INIT "".
DEFINE VAR x-alm-aqp AS CHAR INIT "".
DEFINE VAR x-almacenes AS CHAR INIT "".

x-value = Chkbxprevta-tru:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
IF x-value = 'yes'  THEN DO:
    x-lista-precios = "20067".
    x-coma = ",".
    x-alm-tru = '68E'.
END. 

x-value = Chkbxexpo-tru:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
IF x-value = 'yes'  THEN DO:
    x-lista-precios = x-lista-precios + x-coma + "10067".
    x-coma = ",".
    x-alm-tru = '68E'.
END.    

x-value = Chkbxprevta-aqp:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
IF x-value = 'yes'  THEN DO:
    x-lista-precios = x-lista-precios + x-coma + "10060".
    x-coma = ",".
    x-alm-aqp = '60E'.
END.  

x-value = Chkbxexpo-aqp:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
IF x-value = 'yes'  THEN DO:
    x-lista-precios = x-lista-precios + x-coma + "20060".
    x-coma = ",".
    x-alm-aqp = '60E'.
END.
    
txtListaPrecio:SCREEN-VALUE IN FRAME {&FRAME-NAME} = X-lista-precios.

x-almacenes = x-alm-tru.
IF x-alm-tru <> "" AND x-alm-aqp <> ""  THEN x-almacenes = x-almacenes + ",".
x-almacenes = x-almacenes + x-alm-aqp.

txtAlmDespacho:SCREEN-VALUE IN FRAME {&FRAME-NAME} = x-almacenes.


/*
  IF x-opcion = '1' THEN txtAlmDespacho:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '68E'.
  IF x-opcion = '2' THEN txtAlmDespacho:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '60E'.
  IF x-opcion = '3' THEN txtAlmDespacho:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '68E,60E'.

  IF x-opcion = '1' THEN txtListaPrecio:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '10067,20067'.
  IF x-opcion = '2' THEN txtListaPrecio:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '20060,10060'.
  IF x-opcion = '3' THEN txtListaPrecio:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '10067,20067,20060,10060'.
 */


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

DEFINE VAR lListaPrecios AS CHAR.
DEFINE VAR lAlmDespachos AS CHAR.
DEFINE VAR lAlmacen AS CHAR.

lAlmDespachos = txtAlmDespacho.

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
    /*
    lAlmacen = lAlmDespachos.
    IF NUM-ENTRIES(txtlistaPrecio,",") > 1 THEN DO:
        lAlmacen = ENTRY(LOOKUP(faccpedi.libre_c01,txtlistaPrecio),lAlmDespachos).
    END.
    */
    IF faccpedi.libre_c01 = '10067' OR faccpedi.libre_c01 = '20067' THEN lAlmacen = "68E".
    IF faccpedi.libre_c01 = '10060' OR faccpedi.libre_c01 = '20060' THEN lAlmacen = "60E".

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

            CREATE tt-cot-hdr.
                ASSIGN tt-cot-hdr.tt-divi      = faccpedi.coddiv
                        tt-cot-hdr.tt-nrocot   = faccpedi.nroped
                        tt-cot-hdr.tt-alm      = lAlmacen
                        tt-cot-hdr.tt-ubigeo   = ""
                        tt-cot-hdr.tt-peso     = 0
                        tt-cot-hdr.tt-peso-tot = 0 
                        tt-cot-hdr.tt-fchped = faccpedi.fchped
                        tt-cot-hdr.tt-fchven = faccpedi.fchven
                        tt-cot-hdr.tt-fchent = faccpedi.fchent
                        tt-cot-hdr.tt-nomcli = faccpedi.nomcli
                        tt-cot-hdr.tt-impvta = faccpedi.impvta
                        tt-cot-hdr.tt-impigv = faccpedi.impigv
                        tt-cot-hdr.tt-imptot = faccpedi.imptot
                        tt-cot-hdr.tt-flgest = lEstado
                        tt-cot-hdr.tt-avance = 0
                        tt-cot-hdr.tt-ptodsp = lAlmacen. 
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
            (((facdpedi.canped - facdpedi.canate) * facdpedi.factor) * almmmatg.pesmat).                

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

txtmsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Resumen x Articulo" .
FOR EACH tt-cot-hdr NO-LOCK:
    FOR EACH tt-cot-dtl WHERE tt-cot-dtl.tt-divi = tt-cot-hdr.tt-divi AND
                            tt-cot-dtl.tt-nrocot = tt-cot-hdr.tt-nrocot NO-LOCK:

        lCodAlm = tt-cot-hdr.tt-alm.
        FIND FIRST Almmmatg WHERE almmmatg.codcia = s-codcia AND
                                almmmatg.codmat = tt-cot-dtl.tt-codmat NO-LOCK NO-ERROR.

        FIND FIRST tt-cot-final WHERE tt-cot-final.tt-alm = lCodAlm AND
                        tt-cot-final.tt-codmat = tt-cot-dtl.tt-codmat EXCLUSIVE NO-ERROR.
        IF NOT AVAILABLE tt-cot-final THEN DO:
            CREATE tt-cot-final.

                /* Ic - 03Ocy2017, segun Lucy Mesia Stock Repo de Andhuaylas (inner) */
                FIND FIRST almmmate WHERE almmmate.codcia = s-codcia AND 
                                            almmmate.codalm = '04' AND 
                                            almmmate.codmat = tt-cot-dtl.tt-codmat NO-LOCK NO-ERROR.                                        

                FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND
                                        almmmatg.codmat = tt-cot-dtl.tt-codmat NO-LOCK NO-ERROR.
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
                            vtatabla.llave_c1 = 'PROV' 
                            NO-ERROR.
    IF NOT AVAILABLE vtatabla THEN DO:
        CREATE vtatabla.
            ASSIGN vtatabla.codcia = s-codcia
                    vtatabla.tabla = 'DSTRB'
                    vtatabla.llave_c1 = 'PROV'.
    END.

    ASSIGN vtatabla.rango_fecha[2] = txtFechaTope
            vtatabla.rango_fecha[1] = TODAY.
    
    RELEASE vtatabla.

    /* Blanquear Cotizaciones */
    RUN blanquear-cotizacion.
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

cRange = "U" + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Disponible Alm 14F (stk - reservado)".
cRange = "V" + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Disponible Alm 60 (stk - reservado)".
cRange = "W" + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Disponible Alm 63 (stk - reservado)".
cRange = "X" + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Disponible Alm 68 (stk - reservado)".
cRange = "Y" + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Disponible Alm 67 (stk - reservado)".
cRange = "Z" + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Disponible Alm 69 (stk - reservado)".
cRange = "AA" + cColumn.
chWorkSheet:Range(cRange):Value = "OC en Transito".


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
    chWorkSheet:Range(cRange):Value = "'" + tt-cot-final.tt-alm .
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

    /* - */
    lStkReservado = 0.
    RUN vta2/stock-comprometido-v2.r(INPUT tt-cot-final.tt-codmat, INPUT '14F',  OUTPUT lStkReservado).
    FIND FIRST almmmate WHERE almmmate.codcia = s-codcia AND
                        almmmate.codalm = '14F' AND 
                        almmmate.codmat = tt-cot-final.tt-codmat NO-LOCK NO-ERROR.
    IF AVAILABLE almmmate THEN DO:
        cRange = "U" + cColumn.
        chWorkSheet:Range(cRange):Value = IF ((almmmate.stkact - lStkReservado) < 0) THEN 0 ELSE (almmmate.stkact - lStkReservado).
    END.

    lStkReservado = 0.
    RUN vta2/stock-comprometido-v2.r(INPUT tt-cot-final.tt-codmat, INPUT '60',  OUTPUT lStkReservado).
    FIND FIRST almmmate WHERE almmmate.codcia = s-codcia AND
                        almmmate.codalm = '60' AND 
                        almmmate.codmat = tt-cot-final.tt-codmat NO-LOCK NO-ERROR.
    IF AVAILABLE almmmate THEN DO:
        cRange = "V" + cColumn.
        chWorkSheet:Range(cRange):Value = IF ((almmmate.stkact - lStkReservado) < 0) THEN 0 ELSE (almmmate.stkact - lStkReservado).
    END.

    lStkReservado = 0.
    RUN vta2/stock-comprometido-v2.r(INPUT tt-cot-final.tt-codmat, INPUT '63',  OUTPUT lStkReservado).
    FIND FIRST almmmate WHERE almmmate.codcia = s-codcia AND
                        almmmate.codalm = '63' AND 
                        almmmate.codmat = tt-cot-final.tt-codmat NO-LOCK NO-ERROR.
    IF AVAILABLE almmmate THEN DO:
        cRange = "W" + cColumn.
        chWorkSheet:Range(cRange):Value = IF ((almmmate.stkact - lStkReservado) < 0) THEN 0 ELSE (almmmate.stkact - lStkReservado).
    END.

    lStkReservado = 0.
    RUN vta2/stock-comprometido-v2.r(INPUT tt-cot-final.tt-codmat, INPUT '68',  OUTPUT lStkReservado).
    FIND FIRST almmmate WHERE almmmate.codcia = s-codcia AND
                        almmmate.codalm = '68' AND 
                        almmmate.codmat = tt-cot-final.tt-codmat NO-LOCK NO-ERROR.
    IF AVAILABLE almmmate THEN DO:
        cRange = "X" + cColumn.
        chWorkSheet:Range(cRange):Value = IF ((almmmate.stkact - lStkReservado) < 0) THEN 0 ELSE (almmmate.stkact - lStkReservado).
    END.

    lStkReservado = 0.
    RUN vta2/stock-comprometido-v2.r(INPUT tt-cot-final.tt-codmat, INPUT '67',  OUTPUT lStkReservado).
    FIND FIRST almmmate WHERE almmmate.codcia = s-codcia AND
                        almmmate.codalm = '67' AND 
                        almmmate.codmat = tt-cot-final.tt-codmat NO-LOCK NO-ERROR.
    IF AVAILABLE almmmate THEN DO:
        cRange = "Y" + cColumn.
        chWorkSheet:Range(cRange):Value = IF ((almmmate.stkact - lStkReservado) < 0) THEN 0 ELSE (almmmate.stkact - lStkReservado).
    END.

    lStkReservado = 0.
    RUN vta2/stock-comprometido-v2.r(INPUT tt-cot-final.tt-codmat, INPUT '69',  OUTPUT lStkReservado).
    FIND FIRST almmmate WHERE almmmate.codcia = s-codcia AND
                        almmmate.codalm = '69' AND 
                        almmmate.codmat = tt-cot-final.tt-codmat NO-LOCK NO-ERROR.
    IF AVAILABLE almmmate THEN DO:
        cRange = "Z" + cColumn.
        chWorkSheet:Range(cRange):Value = IF ((almmmate.stkact - lStkReservado) < 0) THEN 0 ELSE (almmmate.stkact - lStkReservado).
    END.

    /* Compras en Transito */
    lStkReservado = 0.
    RUN gn/p-compras-en-transito.r(INPUT tt-cot-final.tt-alm, INPUT tt-cot-final.tt-codmat, OUTPUT lStkReservado).
    cRange = "AA" + cColumn.
    chWorkSheet:Range(cRange):Value = lStkReservado.

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

