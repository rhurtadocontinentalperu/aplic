&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ORDENES LIKE FacCPedi
       FIELD Libre_d03 LIKE Faccpedi.Libre_d02.
DEFINE BUFFER x-Faccpedi FOR FacCPedi.



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
DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-coddiv AS CHAR.

/* Local Variable Definitions ---                                       */

{src/adm2/widgetprto.i}

DEFINE TEMP-TABLE Detalle
    FIELD Situacion     AS CHAR     FORMAT 'x(30)'  LABEL 'Situación'
    FIELD SitPedido     AS CHAR     FORMAT 'x(30)'  LABEL 'Estado Pedido'
    FIELD NroHPK        AS CHAR     FORMAT 'x(15)'  LABEL 'Nro HPK'
    FIELD SitHPK        AS CHAR     FORMAT 'x(30)'  LABEL 'Estado HPK'
    FIELD CodPed        AS CHAR     FORMAT 'x(3)'   LABEL 'Código'
    FIELD NroPed        AS CHAR     FORMAT 'x(15)'  LABEL 'Número'
    FIELD CodOrigen     AS CHAR     FORMAT 'x(15)'  LABEL 'Cod. Origen'
    FIELD NroOrigen     AS CHAR     FORMAT 'x(20)'  LABEL 'Det. Origen'
    FIELD FchPed        AS DATE     FORMAT '99/99/9999' LABEL 'Emisión'
    FIELD Hora          AS CHAR     FORMAT 'x(8)'   LABEL 'Hora'
    FIELD FchEnt        AS DATE     FORMAT '99/99/9999' LABEL 'Fecha de Entrega'
    FIELD Origen        AS CHAR     FORMAT 'x(5)'   LABEL 'Origen'
    FIELD NomCli        AS CHAR     FORMAT 'x(50)'  LABEL 'Cliente'
    FIELD Peso          AS DEC      FORMAT '>>>,>>9.99' LABEL 'Peso kg'
    FIELD Volumen       AS DEC      FORMAT '>>>,>>9.99' LABEL 'Volumen en m3'
    FIELD UsrImpOD      AS CHAR     FORMAT 'x(8)'   LABEL 'Impreso por'
    FIELD FchImpOD      AS DATETIME FORMAT '99/99/9999 HH:MM' LABEL 'Fecha y hora de impresión'
    FIELD Items         AS INT      FORMAT '>>9'    LABEL 'Items'
    FIELD Glosa         AS CHAR     FORMAT 'x(50)'  LABEL 'Glosa'
    FIELD ImpMn         AS DEC      FORMAT '->>>,>>>,>>9.99' LABEL 'Importe PEN'
    FIELD ImpMe         AS DEC      FORMAT '->>>,>>>,>>9.99' LABEL 'Importe USD'
    FIELD nomPos        AS CHAR     FORMAT 'x(40)'  LABEL 'Distrito'
    .

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
&Scoped-Define ENABLED-OBJECTS txtDesde txtHasta BUTTON-15 BtnDone 
&Scoped-Define DISPLAYED-OBJECTS txtDesde txtHasta FILL-IN-Mensaje 

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
     SIZE 10 BY 1.88
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-15 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 15" 
     SIZE 10 BY 1.88.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY 1 NO-UNDO.

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
     txtDesde AT ROW 3.15 COL 19 COLON-ALIGNED WIDGET-ID 16
     txtHasta AT ROW 3.15 COL 41 COLON-ALIGNED WIDGET-ID 20
     BUTTON-15 AT ROW 6.38 COL 3 WIDGET-ID 22
     BtnDone AT ROW 6.38 COL 14 WIDGET-ID 26
     FILL-IN-Mensaje AT ROW 7.19 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 24
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 7.69 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE APPSERVER
   Temp-Tables and Buffers:
      TABLE: ORDENES T "?" ? INTEGRAL FacCPedi
      ADDITIONAL-FIELDS:
          FIELD Libre_d03 LIKE Faccpedi.Libre_d02
      END-FIELDS.
      TABLE: x-Faccpedi B "?" ? INTEGRAL FacCPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "REPORTE DE ESTADOS DE PEDIDOS"
         HEIGHT             = 7.69
         WIDTH              = 80
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
ON END-ERROR OF wWin /* REPORTE DE ESTADOS DE PEDIDOS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* REPORTE DE ESTADOS DE PEDIDOS */
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


&Scoped-define SELF-NAME BUTTON-15
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-15 wWin
ON CHOOSE OF BUTTON-15 IN FRAME fMain /* Button 15 */
DO:
    ASSIGN txtDesde txtHasta.
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
    RUN Carga-Temporal.

    /* Programas que generan el Excel */
    RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER Detalle:HANDLE,
                                      INPUT c-xls-file,
                                      OUTPUT c-csv-file) .

    RUN pi-crea-archivo-xls IN hProc (INPUT BUFFER Detalle:handle,
                                      INPUT  c-csv-file,
                                      OUTPUT c-xls-file) .

    /* Borramos librerias de la memoria */
    DELETE PROCEDURE hProc.
    SESSION:SET-WAIT-STATE('').
    MESSAGE 'Proceso Concluido' VIEW-AS ALERT-BOX INFORMATION.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal wWin 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE ORDENES.

DEFINE VAR lOrdenCompra AS CHAR INIT ''.
DEFINE VAR lUserImpresion AS CHAR.

DEFINE VAR lSectores AS INT.
DEFINE VAR lSecImp AS INT.
DEFINE VAR lSecAsig AS INT.
DEFINE VAR lSecDev AS INT.
DEFINE VAR lSecxAsig AS INT.
DEFINE VAR lCodDoc AS CHAR NO-UNDO.
DEFINE VAR k AS INT NO-UNDO.

lCodDoc = 'O/D,O/M,OTR'.

/* --- */
DEFINE VAR x-items AS INT.
DEFINE VAR x-peso AS DEC.
DEFINE VAR x-volumen AS DEC.
DEFINE VAR x-docproc AS CHAR.
DEFINE VAR pSoloImpresos AS LOGICAL INIT NO.
DEFINE VAR s-CodDoc AS CHAR INIT "Todos".

&SCOPED-DEFINE CONDICION ( Faccpedi.codcia = s-codcia ~
AND Faccpedi.divdes = s-coddiv ~
AND faccpedi.coddoc = x-docproc ~
AND Faccpedi.FlgEst <> "A"  ~
AND (Faccpedi.fchped >= txtDesde AND Faccpedi.fchped <= txtHasta) )

DO k = 1 TO NUM-ENTRIES(lCodDoc):
    x-docproc = ENTRY(k,lCodDoc).
    FOR EACH Faccpedi USE-INDEX llave08 NO-LOCK WHERE {&Condicion} ,
        FIRST GN-DIVI OF Faccpedi NO-LOCK:
        lUserImpresion = Faccpedi.UsrImpOD.
        lUserImpresion = IF (lUserImpresion = ?) THEN '' ELSE TRIM(lUserImpresion).

        RUN ue-sectores(INPUT Faccpedi.coddoc, 
                        INPUT Faccpedi.nroped,
                        OUTPUT lSectores, 
                        OUTPUT lSecImp, 
                        OUTPUT lSecAsig,
                        OUTPUT lSecDev).

        x-items = 0.
        X-peso = 0.
        x-volumen = 0.

        RUN items-pesos(OUTPUT x-items, OUTPUT x-peso, OUTPUT x-volumen).

        CREATE ORDENES.
        BUFFER-COPY Faccpedi TO ORDENES.
        ASSIGN
            ORDENES.Libre_c01 = gn-divi.desdiv
            ORDENES.Libre_d01 = x-peso  /*fPeso()*/
            ORDENES.Libre_c02 = ""
            ORDENES.Libre_d02 = x-items.  /*fNroItm()*/
        ORDENES.Libre_d03 = x-volumen.  /*(m3)*/

        ORDENES.UsrImpOD = ENTRY(1, Faccpedi.Libre_c02, '|').
        ORDENES.FchImpOD = (IF NUM-ENTRIES(Faccpedi.Libre_c02, '|') > 1 THEN 
                        DATETIME(ENTRY(2, Faccpedi.Libre_c02, '|')) ELSE ?).
        CASE s-CodDoc:
            WHEN 'O/D' OR WHEN 'O/M' OR WHEN 'ODC' THEN DO:
                ORDENES.Libre_c01 = gn-divi.desdiv.
            END.
            WHEN 'OTR' THEN DO:
                ORDENES.Libre_c01 = Faccpedi.codcli.
            END.
        END CASE.

        RUN ue-sectores(INPUT Ordenes.coddoc, INPUT Ordenes.nroped,
                        OUTPUT lSectores, OUTPUT lSecImp, OUTPUT lSecAsig,
                        OUTPUT lSecDev).
        ASSIGN  
            Ordenes.acubon[1] = lSectores
            Ordenes.acubon[2] = lSecImp
            Ordenes.acubon[3] = lSecAsig
            Ordenes.acubon[4] = lSecDev
            Ordenes.acubon[5] = lSectores - lSecAsig.

            ORDENES.Libre_c02 = "SIN EMPEZAR".

        IF lSectores = lSecDev THEN ORDENES.Libre_c02 = "COMPLETADO".
        IF lSecImp > 0 AND lSecImp < lSectores AND lSecAsig = 0 THEN ORDENES.Libre_c02 = "PARCIALMENTE IMPRESOS".
        IF lSecImp > 0 AND lSecAsig = 0 AND lSectores = lSecImp AND lSecDev = 0 THEN ORDENES.Libre_c02 = "SOLO IMPRESOS".
        IF lSecAsig > 0 AND lSecDev > 0 AND lSecDev <> lSectores THEN ORDENES.Libre_c02 = "AVANCE PARCIAL".
        IF lSecAsig > 0 AND lSecDev = 0 AND lSecAsig = lSectores THEN ORDENES.Libre_c02 = "SOLO ASIGNADOS".
        IF lSecAsig > 0 AND lSecDev = 0 AND lSecAsig <> lSectores THEN ORDENES.Libre_c02 = "ASIGNADO PARCIAL".
        IF faccpedi.flgest = 'C' THEN ORDENES.Libre_c02 = "FACTURADO/G.REMISION".
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ORDENES.coddoc + ' ' + ORDENES.nroped.
    END.
END.

EMPTY TEMP-TABLE Detalle.
DEF VAR xNomCli AS CHAR NO-UNDO.

FOR EACH ORDENES NO-LOCK, FIRST Faccpedi OF ORDENES NO-LOCK:
    CREATE Detalle.
    ASSIGN
        Detalle.Situacion = ORDENES.Libre_c02
        Detalle.CodPed    = ORDENES.CodDoc
        Detalle.NroPed    = ORDENES.NroPed
        Detalle.CodOrigen = ORDENES.CodOrigen
        Detalle.NroOrigen = ORDENES.NroOrigen
        Detalle.FchPed    = ORDENES.FchPed
        Detalle.Hora      = ORDENES.Hora
        Detalle.FchEnt    = ORDENES.FchEnt
        Detalle.Origen    = ORDENES.Libre_c01
        Detalle.NomCli    = ORDENES.NomCli
        Detalle.Peso      = ORDENES.Libre_d01
        Detalle.Volumen   = ORDENES.Libre_d03
        Detalle.UsrImpOD   = Faccpedi.UsrImpOD
        Detalle.FchImpOD   = Faccpedi.FchImpOD
        Detalle.Items      = ORDENES.Libre_d02
        Detalle.Glosa      = Faccpedi.Glosa
        .
    RUN lib/limpiar-texto-contains (Detalle.NomCli,' ',OUTPUT xNomCli).
    Detalle.NomCli = xNomCli.

    /* Postal  - PEDIDO*/
    FIND FIRST x-Faccpedi WHERE x-Faccpedi.codcia = s-codcia AND
        x-Faccpedi.coddoc = Faccpedi.CodRef AND 
        x-Faccpedi.nroped = Faccpedi.NroRef NO-LOCK NO-ERROR.
    IF AVAILABLE x-faccpedi THEN DO:
        FIND FIRST almtabla WHERE almtabla.tabla = 'CP' AND 
            almtabla.codigo = Faccpedi.codpos NO-LOCK NO-ERROR.
        IF AVAILABLE almtabla THEN ASSIGN detalle.nompos = almtabla.nombre.
        IF x-Faccpedi.CodDoc = "PED" THEN 
            ASSIGN 
            Detalle.ImpMn = (IF x-Faccpedi.codmon = 1 THEN x-Faccpedi.ImpTot ELSE 0)
            Detalle.ImpMe = (IF x-Faccpedi.codmon = 2 THEN x-Faccpedi.ImpTot ELSE 0)
            .
    END.
    ELSE DO:
        IF Faccpedi.CodRef = 'R/A' THEN DO:
            FIND FIRST almacen WHERE almacen.codcia = s-codcia AND 
                                        almacen.codalm = Faccpedi.codcli
                                        NO-LOCK NO-ERROR.
            IF AVAILABLE almacen THEN DO:
                FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND 
                                            gn-divi.coddiv = almacen.coddiv
                                            NO-LOCK NO-ERROR.
                IF AVAILABLE gn-divi THEN DO:
                    FIND FIRST tabdistr WHERE tabdistr.coddepto = gn-divi.campo-char[3] AND 
                                                tabdistr.codprovi = gn-divi.campo-char[4] AND 
                                                tabdistr.coddistr = gn-divi.campo-char[5] 
                                                NO-LOCK NO-ERROR.
                    IF AVAILABLE tabdistr THEN DO:
                        ASSIGN detalle.nompos      = tabdistr.nomdistr.
                    END.
                END.
            END.
        END.
    END.

    /* Situación de Pedidos */
    FOR EACH LogTrkDocs NO-LOCK WHERE LogTrkDocs.CodCia = s-codcia AND
        LogTrkDocs.CodDoc = ORDENES.CodDoc AND
        LogTrkDocs.NroDoc = ORDENES.NroPed AND
        LogTrkDocs.Clave = "TRCKPED",
        FIRST TabTrkDocs WHERE TabTrkDocs.CodCia = s-codcia AND
        TabTrkDocs.Clave = LogTrkDocs.Clave AND 
        TabTrkDocs.Codigo = LogTrkDocs.Codigo
        BY LogTrkDocs.Fecha DESC:
        Detalle.SitPedido = TabTrkDocs.NomCorto.
        LEAVE.
    END.

    /* Situacion por HPK */
    FOR EACH Vtacdocu NO-LOCK WHERE Vtacdocu.codcia = s-codcia AND
        Vtacdocu.codped = 'HPK' AND
        Vtacdocu.codref = ORDENES.coddoc AND
        Vtacdocu.nroref = ORDENES.nroped AND
        Vtacdocu.flgest <> 'A'
        BY Vtacdocu.fchped DESC:
        ASSIGN
            Detalle.NroHPK = Vtacdocu.NroPed.
        FIND LAST LogTrkDocs USE-INDEX Idx01 WHERE LogTrkDocs.CodCia = s-codcia AND
            LogTrkDocs.CodDoc = Vtacdocu.CodPed AND
            LogTrkDocs.NroDoc = Vtacdocu.NroPed AND
            LogTrkDocs.Clave = "TRCKHPK" NO-LOCK NO-ERROR.
        IF AVAILABLE LogTrkDocs THEN DO:
            FIND FIRST TabTrkDocs WHERE TabTrkDocs.CodCia = s-codcia AND
                TabTrkDocs.Clave = LogTrkDocs.Clave AND 
                TabTrkDocs.Codigo = LogTrkDocs.Codigo NO-LOCK NO-ERROR.
            IF AVAILABLE LogTrkDocs THEN Detalle.SitHPK = TabTrkDocs.NomCorto.
        END.
        LEAVE.
    END.
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Detalle:' + ORDENES.coddoc + ' ' + ORDENES.nroped.
END.
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

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
  DISPLAY txtDesde txtHasta FILL-IN-Mensaje 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE txtDesde txtHasta BUTTON-15 BtnDone 
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
  txtDesde = TODAY - 1.
  txtHasta = TODAY.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE items-pesos wWin 
PROCEDURE items-pesos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER pItems AS INT.
DEFINE OUTPUT PARAMETER pPeso AS DEC.
DEFINE OUTPUT PARAMETER pVolumen AS DEC.

    
DEFINE VAR lPeso AS DEC.
DEFINE VAR lVolumen AS DEC.
DEFINE VAR lItems AS INT.

DEFINE BUFFER b-facdpedi FOR facdpedi.

lPeso = 0.
lVolumen = 0.
lItems = 0.

FOR EACH b-facdpedi OF faccpedi NO-LOCK, FIRST almmmatg OF b-facdpedi NO-LOCK :

    lItems = lItems + 1.

    IF almmmatg.pesmat <> ? AND almmmatg.pesmat > 0 THEN DO:
        lPeso = lPeso + (b-facdpedi.canped * b-facdpedi.factor * almmmatg.pesmat).
    END.       
    IF almmmatg.libre_d02 <> ? AND almmmatg.libre_d02 > 0 THEN DO:
        lVolumen = lVolumen + (b-facdpedi.canped * b-facdpedi.factor * almmmatg.libre_d02 / 1000000).
    END.       

END.
RELEASE b-facdpedi.

pItems = lItems.
pVolumen = lVolumen.
pPeso = lPeso.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-sectores wWin 
PROCEDURE ue-sectores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.
DEFINE OUTPUT PARAMETER pSectores AS INT.
DEFINE OUTPUT PARAMETER pSecImp AS INT.
DEFINE OUTPUT PARAMETER pSecAsig AS INT.
DEFINE OUTPUT PARAMETER pSecDev AS INT.

DEFINE VAR nSectores AS INT INIT 0.
DEFINE VAR nSectoresImp AS INT  INIT 0.
DEFINE VAR nSectoresAsig AS INT  INIT 0.
DEFINE VAR nSectoresReto AS INT  INIT 0.
DEFINE VAR nSectoresSinAsig AS INT  INIT 0.

FOR EACH VtaCDocu WHERE VtaCDocu.codcia = s-codcia 
    AND VtaCDocu.codped = pCodDoc 
    AND VtaCDocu.nroped BEGINS pNroDoc NO-LOCK:
    /*AND ENTRY(1,VtaCDocu.nroped,"-") = pNroDoc NO-LOCK:*/
    nSectores = nSectores + 1.
    IF NOT (TRUE <> (VtaCDocu.UsrImpOD > ""))   THEN DO:
        nSectoresImp = nSectoresImp + 1.
    END.
    IF NOT (TRUE <> (VtaCDocu.UsrSac > ""))   THEN DO:
        nSectoresAsig = nSectoresAsig + 1.
    END.
    IF NOT (TRUE <> (VtaCDocu.UsrSacRecep > ""))   THEN DO:
        nSectoresReto = nSectoresReto + 1.
    END.
END.

pSectores = nSectores.
pSecImp = nSectoresImp.
pSecAsig = nSectoresAsig.
pSecDev = nSectoresReto.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

