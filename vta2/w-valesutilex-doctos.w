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
&Scoped-Define ENABLED-OBJECTS txtDesde txtHasta BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS txtDesde txtHasta 

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


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     txtDesde AT ROW 2.15 COL 12 COLON-ALIGNED WIDGET-ID 2
     txtHasta AT ROW 2.15 COL 38.72 COLON-ALIGNED WIDGET-ID 4
     BUTTON-1 AT ROW 4.85 COL 39 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 61.72 BY 6.62 WIDGET-ID 100.


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
         HEIGHT             = 6.62
         WIDTH              = 61.72
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
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


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 wWin
ON CHOOSE OF BUTTON-1 IN FRAME fMain /* Aceptar */
DO:
  ASSIGN txtDesde txtHasta.

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
  DISPLAY txtDesde txtHasta 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE txtDesde txtHasta BUTTON-1 
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

SESSION:SET-WAIT-STATE('GENERAL').

EMPTY TEMP-TABLE tt-ccbcdocu.

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

RELEASE i-faccpedi.
RELEASE ii-faccpedi.

SESSION:SET-WAIT-STATE('').

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

