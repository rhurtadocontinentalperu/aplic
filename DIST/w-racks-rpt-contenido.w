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

/* para el peso  */
DEFINE VAR lAlmacen AS CHAR.
DEFINE VAR lTipoOrden AS CHAR.
DEFINE VAR lNroOrden AS CHAR.

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
&Scoped-Define ENABLED-OBJECTS txtCD txtDesde txtHasta txtCodClie ~
optgrpCuales btnProcesar 
&Scoped-Define DISPLAYED-OBJECTS txtCD txtNomCD txtDesde txtHasta ~
txtCodClie txtDesClie optgrpCuales 

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

DEFINE VARIABLE txtCD AS CHARACTER FORMAT "X(5)":U 
     LABEL "Centro de Distribucion" 
     VIEW-AS FILL-IN 
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE txtCodClie AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtDesClie AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 52 BY 1 NO-UNDO.

DEFINE VARIABLE txtDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtNomCD AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY 1 NO-UNDO.

DEFINE VARIABLE optgrpCuales AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Mercaderia en RACK", 1,
"Historial", 2,
"Ambos", 3
     SIZE 50 BY 1.31 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     txtCD AT ROW 1.54 COL 20.14 COLON-ALIGNED WIDGET-ID 18
     txtNomCD AT ROW 1.54 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     txtDesde AT ROW 3.42 COL 9.57 COLON-ALIGNED WIDGET-ID 8
     txtHasta AT ROW 3.38 COL 32 COLON-ALIGNED WIDGET-ID 10
     txtCodClie AT ROW 4.96 COL 10 COLON-ALIGNED WIDGET-ID 2
     txtDesClie AT ROW 4.96 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     optgrpCuales AT ROW 7.27 COL 7 NO-LABEL WIDGET-ID 14
     btnProcesar AT ROW 8.77 COL 68 WIDGET-ID 6
     "Vacio : Todos" VIEW-AS TEXT
          SIZE 15 BY .62 AT ROW 6.27 COL 16 WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 85.86 BY 10 WIDGET-ID 100.


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
         TITLE              = "Mercaderias en RACKs"
         HEIGHT             = 10
         WIDTH              = 85.86
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
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN txtDesClie IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtNomCD IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* Mercaderias en RACKs */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Mercaderias en RACKs */
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
  ASSIGN txtCodClie txtDesClie txtDesde txtHasta optgrpCuales txtCD.

  DEFINE VAR lxCD AS CHAR.
  DEFINE VAR lOk AS LOG.

  lxCD = txtCD:SCREEN-VALUE.
  txtNomCD:SCREEN-VALUE = "".
  IF lxCD <> "" THEN DO:    
      FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND 
            gn-divi.coddiv = lxCD NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-divi THEN DO:
          RETURN NO-APPLY.
      END.
      txtNomCD:SCREEN-VALUE = gn-divi.desdiv.
  END.

  IF lxCD = ""  OR AVAILABLE gn-divi THEN DO:
      RUN ue-procesar.
  END.
  ELSE DO:
      MESSAGE "CENTRO DE DIVISION ERRADO..." VIEW-AS ALERT-BOX.
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtCD
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtCD wWin
ON LEAVE OF txtCD IN FRAME fMain /* Centro de Distribucion */
DO:
  DEFINE VAR lxCD AS CHAR.

  lxCD = txtCD:SCREEN-VALUE.
  txtNomCD:SCREEN-VALUE = "".

  IF lxCD <> "" THEN DO:
    
      FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND 
            gn-divi.coddiv = lxCD NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-divi THEN DO:
          RETURN NO-APPLY.
      END.
    
      txtNomCD:SCREEN-VALUE = gn-divi.desdiv.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtCodClie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtCodClie wWin
ON LEAVE OF txtCodClie IN FRAME fMain /* Cliente */
DO:
    DEFINE VAR lcodCLie AS CHAR.

    txtDesClie:SCREEN-VALUE = "".
    lCodClie = txtCodClie:SCREEN-VALUE.

    IF lCodClie <> ""  THEN DO:
        /*txtDesClie:SCREEN-VALUE = gn-clie.nomcli.*/
        FIND FIRST vtadtabla WHERE vtadtabla.codcia = s-codcia AND
            vtadtabla.libre_c04 = lCodClie NO-LOCK NO-ERROR.
        IF AVAILABLE vtadtabla THEN DO:
            FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND
                gn-clie.codcli = lCodClie NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clie THEN DO:
                txtDesClie:SCREEN-VALUE = gn-clie.nomcli.
            END.
            ELSE DO:
                /**/
                FIND FIRST ccbcbult WHERE ccbcbult.codcia = s-codcia AND
                        ccbcbult.coddoc = vtadtabla.libre_c03 AND
                        ccbcbult.nrodoc = vtadtabla.llavedetalle
                         NO-LOCK NO-ERROR.
                IF AVAILABLE ccbcbult THEN DO:
                    txtDesClie:SCREEN-VALUE = ccbcbult.nomcli.
                END.
            END.
        END.
        ELSE DO:
            MESSAGE "Cliente no tiene Ordenes en RACKs" VIEW-AS ALERT-BOX.
            RETURN NO-APPLY.
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
  DISPLAY txtCD txtNomCD txtDesde txtHasta txtCodClie txtDesClie optgrpCuales 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE txtCD txtDesde txtHasta txtCodClie optgrpCuales btnProcesar 
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

  txtDesde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY - 15,"99/99/9999").
  txtHasta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY,"99/99/9999").

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-cabecera wWin 
PROCEDURE ue-cabecera :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-peso wWin 
PROCEDURE ue-peso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
DEFINE INPUT PARAMETER pTipoOrden AS CHAR    NO-UNDO.
DEFINE INPUT PARAMETER pNroOrden AS CHAR    NO-UNDO.
*/
DEFINE OUTPUT PARAMETER pPeso AS DEC    NO-UNDO.

DEFINE VAR lSer AS INT.
DEFINE VAR lnroDoc AS INT.

pPeso = 0.
IF lTipoOrden = 'TRA' THEN DO:
    /* Transferencias */
    lSer = INT(SUBSTRING(lNroOrden,1,3)).
    lNroDoc = INT(SUBSTRING(lNroOrden,4,6)).    
    FOR EACH almdmov WHERE almdmov.codcia  = s-codcia and almdmov.codalm = lAlmacen 
        and almdmov.tipmov = 'S' and almdmov.codmov = 3 and 
        almdmov.nroser = lSer and almdmov.nrodoc = lnroDoc NO-LOCK,
        FIRST almmmatg OF almdmov NO-LOCK:
        pPeso = pPeso + (almdmov.candes * almmmatg.pesmat).
    END.
END.
ELSE DO:
    FOR EACH facdpedi WHERE facdpedi.codcia = s-codcia AND 
        facdpedi.coddoc = lTipoOrden AND 
        facdpedi.nroped = lNroOrden NO-LOCK,
        FIRST almmmatg OF facdpedi NO-LOCK:
      pPeso = pPeso + (facdpedi.canped * almmmatg.pesmat).
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

DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.

lFileXls = "".          /* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */
lNuevoFile = YES.       /* YES : Si va crear un nuevo archivo o abrir */

{lib\excel-open-file.i}

DEFINE VAR lEmision AS DATETIME.
DEFINE VAR lActual AS DATETIME.
DEFINE VAR lDifHora AS CHAR.

DEFINE VAR lPeso AS DEC.

iColumn = 1.
cColumn = STRING(iColumn).

cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Datos del Cliente".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "RACK".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "Tipo".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "No.Orden".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "Bultos".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Peso Aprox.".
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "Fec.Ingreso".
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = "Hora Ingreso".
cRange = "I" + cColumn.
chWorkSheet:Range(cRange):Value = "Fec.Salida".
cRange = "J" + cColumn.
chWorkSheet:Range(cRange):Value = "Hora Salida".
cRange = "K" + cColumn.
chWorkSheet:Range(cRange):Value = "Retraso".
cRange = "L" + cColumn.
chWorkSheet:Range(cRange):Value = "C.D.".


FOR EACH vtadtabla WHERE vtadtabla.codcia = s-codcia  AND 
    (txtCD = "" OR vtadtabla.llave = txtCD ) AND 
    (vtadtabla.fchcreacion >= txtDesde AND vtadtabla.fchcreacion <= txtHasta) AND
    (txtCodClie = "" OR vtadtabla.libre_c04 = txtCodClie) NO-LOCK ,
    FIRST vtactabla WHERE vtactabla.codcia = s-codcia AND 
        vtactabla.llave BEGINS vtadtabla.llave AND 
        vtactabla.libre_c02  = vtadtabla.tipo NO-LOCK 
    BREAK BY vtactabla.libre_c01:

    IF optgrpCuales = 3 OR (optgrpCuales = 2 AND vtactabla.libre_f02 <> ?) OR 
        (optgrpCuales = 1 AND vtactabla.libre_f02 = ?)  THEN DO:
        FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND
            gn-clie.codcli = vtadtabla.libre_c04 NO-LOCK NO-ERROR.

        FIND FIRST ccbcbult WHERE ccbcbult.codcia = s-codcia AND
            ccbcbult.coddoc = vtadtabla.libre_c03 AND
            ccbcbult.nrodoc = vtadtabla.llavedetalle
             NO-LOCK NO-ERROR.


        iColumn = iColumn + 1.
        cColumn = STRING(iColumn).

        cColumn = STRING(iColumn).
        cRange = "A" + cColumn.    
        IF AVAILABLE gn-clie THEN DO:
            chWorkSheet:Range(cRange):Value = "'" + vtadtabla.libre_c04 + " " + gn-clie.nomcli.
        END.    
        IF (NOT AVAILABLE gn-clie) AND AVAILABLE ccbcbult THEN DO:
            chWorkSheet:Range(cRange):Value = "'" + vtadtabla.libre_c04 + " " + ccbcbult.nomcli.
        END.


        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + vtactabla.libre_c01.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + vtadtabla.libre_c03.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + vtadtabla.llavedetalle.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = vtadtabla.libre_d01.

        lAlmacen = vtadtabla.libre_c04.
        lTipoOrden = vtadtabla.libre_c03.
        lNroOrden = vtadtabla.llaveDetalle.
        lPeso = vtadtabla.libre_d03.
        IF lPeso <= 0 THEN DO:
            RUN ue-peso (OUTPUT lpeso).
        END.
        
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = lPeso.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = vtadtabla.fchcreacion.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + vtadtabla.libre_c02.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = vtactabla.libre_f02.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + vtactabla.libre_c04.

        IF vtactabla.libre_f02 = ?  THEN DO:
            lActual = DATETIME(TODAY, MTIME).
        END.
        ELSE DO:
            lActual = DATETIME(STRING(vtactabla.libre_f02,"99-99-9999") + " " + vtactabla.libre_c04) .
        END.

        lEMision = DATETIME(STRING(vtadtabla.fchcreacion,"99-99-9999") + " " + vtadtabla.libre_c02) .

        RUN lib\_time-passed.p (lEmision, lActual, OUTPUT lDifHora).
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + lDifHora.
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + vtadtabla.llave.

    END.

END.



{lib\excel-close-file.i}

              
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

