&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
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

DEFINE TEMP-TABLE tHojaRutaLog
FIELD   nhojaruta   AS  CHAR    FORMAT 'x(15)' COLUMN-LABEL "No de H/R"
FIELD   calmacen   AS  CHAR   FORMAT 'x(20)'    COLUMN-LABEL "Almacen"
FIELD   nplaca   AS  CHAR   FORMAT 'x(15)'    COLUMN-LABEL "Placa de vehiculo"
FIELD   lic_tran   AS  CHAR   FORMAT 'x(40)'    COLUMN-LABEL "DNI Responsable"
FIELD   nordendespacho   AS  CHAR   FORMAT 'x(40)' COLUMN-LABEL "No. Orden despacho"
FIELD   hor_cita   AS  CHAR   FORMAT 'x(40)' COLUMN-LABEL "Fecha/Hora salida"
FIELD   nroguia   AS  CHAR   FORMAT 'x(40)' COLUMN-LABEL "Guia remision"
FIELD   codcli   AS  CHAR   FORMAT 'x(20)' COLUMN-LABEL "Cod.Cliente"
FIELD   nomcli   AS  CHAR   FORMAT 'x(200)' COLUMN-LABEL "Nombre del cliente"
FIELD   dircli   AS  CHAR   FORMAT 'x(200)' COLUMN-LABEL "Direccion del cliente"
FIELD   refdir   AS  CHAR   FORMAT 'x(250)' COLUMN-LABEL "Referencia Direccion del cliente"
/**/
/*
FIELD   femision   AS  DATE    COLUMN-LABEL "Emision H/R"
FIELD   ctipo   AS  CHAR   FORMAT 'x(50)'    COLUMN-LABEL "Tipo"
FIELD   nplaca1   AS  CHAR   FORMAT 'x(15)'    COLUMN-LABEL "Placa de vehiculo"
FIELD   lic_tran1   AS  CHAR   FORMAT 'x(40)'    COLUMN-LABEL "Licencia Transportista"
*/
   .

DEFINE VAR fDesde AS DATE NO-UNDO.
DEFINE VAR fhasta AS DATE NO-UNDO.
DEFINE VAR cRutaExcel AS CHAR NO-UNDO.

DEFINE VAR cProveedor AS CHAR NO-UNDO.
DEFINE VAR dProveedor AS CHAR NO-UNDO.
DEFINE VAR dResponsable AS CHAR NO-UNDO.
DEFINE VAR dDivisionHR AS CHAR NO-UNDO.

DEFINE VAR qCapMinima AS DEC NO-UNDO.
DEFINE VAR qCapMaxima AS DEC NO-UNDO.
DEFINE VAR qVolumen AS DEC NO-UNDO.

DEFINE BUFFER ord-faccpedi FOR faccpedi.
DEFINE BUFFER ord-facdpedi FOR facdpedi.
DEFINE BUFFER cmp-ccbcdocu FOR ccbcdocu.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-16 RADIO-SET-cuales FILL-IN-cd ~
FILL-IN-desde FILL-IN-hasta BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-cuales FILL-IN-cd FILL-IN-desde ~
FILL-IN-hasta FILL-IN-cdname 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD limpiar-texto W-Win 
FUNCTION limpiar-texto RETURNS CHARACTER
  (  pTexto AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Procesar" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE FILL-IN-cd AS CHARACTER FORMAT "X(10)":U 
     LABEL "CD / Tienda" 
     VIEW-AS FILL-IN 
     SIZE 6.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-cdname AS CHARACTER FORMAT "X(100)":U 
      VIEW-AS TEXT 
     SIZE 32.14 BY .85
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Rango de Fechas" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-hasta AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-cuales AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos las CDs", 1,
"Un CD en particular", 2
     SIZE 33 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 51.43 BY 6.73.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     RADIO-SET-cuales AT ROW 1.46 COL 3.86 NO-LABEL WIDGET-ID 2
     FILL-IN-cd AT ROW 2.38 COL 10.14 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-desde AT ROW 3.62 COL 14 COLON-ALIGNED WIDGET-ID 10
     FILL-IN-hasta AT ROW 3.65 COL 27.72 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     BUTTON-1 AT ROW 6.15 COL 34 WIDGET-ID 16
     FILL-IN-cdname AT ROW 2.35 COL 17.86 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     RECT-16 AT ROW 1.19 COL 1.57 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 52.72 BY 15.23
         FONT 7 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Reporte (Excel) SmartTracing - H/R"
         HEIGHT             = 7.27
         WIDTH              = 52.86
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 80
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN FILL-IN-cdname IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       FILL-IN-cdname:READ-ONLY IN FRAME F-Main        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Reporte (Excel) SmartTracing - H/R */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte (Excel) SmartTracing - H/R */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Procesar */
DO:

    ASSIGN fill-in-cd fill-in-desde fill-in-hasta.

  fill-in-cdname:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

  IF radio-set-cuales = 2 THEN DO:
      
      FIND FIRST gn-divi WHERE gn-divi.codcia = 1 AND gn-divi.coddiv = fill-in-cd NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-divi THEN DO:
          MESSAGE "Centro de Distribucion ó tienda no existe no existe" VIEW-AS ALERT-BOX.
              RETURN NO-APPLY.
      END.
      fill-in-cdname:SCREEN-VALUE IN FRAME {&FRAME-NAME} = gn-divi.desdiv.
  END.

  IF fill-in-desde = ? OR fill-in-hasta = ? THEN DO:
      MESSAGE "Ingrese los rangos de fechas" VIEW-AS ALERT-BOX.
          RETURN NO-APPLY.
      
  END.

  IF fill-in-desde > fill-in-hasta THEN DO:
      MESSAGE "El rango de fechas no son las correctas" VIEW-AS ALERT-BOX.
          RETURN NO-APPLY.      
  END.

    fDesde = FILL-IN-desde.
    fHasta = fill-in-hasta.

    /**/
        DEFINE VAR lDirectorio AS CHAR.

        lDirectorio = "".

        SYSTEM-DIALOG GET-DIR lDirectorio  
           RETURN-TO-START-DIR 
           TITLE 'Directorio Files'.

    IF lDirectorio = "" THEN DO :
      MESSAGE "Debe elegir una carpeta en donde grabar el archivo Excel" VIEW-AS ALERT-BOX.
          RETURN NO-APPLY.
    END.

    cRutaExcel = lDirectorio.

    SESSION:SET-WAIT-STATE('GENERAL').
    EMPTY TEMP-TABLE tHojaRutaLog.
    RUN procesar.
    SESSION:SET-WAIT-STATE('').

    RUN generarExcel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-cd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-cd W-Win
ON LEAVE OF FILL-IN-cd IN FRAME F-Main /* CD / Tienda */
DO:
    fill-in-cdname:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

    ASSIGN fill-in-cd.
    FIND FIRST gn-divi WHERE gn-divi.codcia = 1 AND gn-divi.coddiv = fill-in-cd NO-LOCK NO-ERROR.
    IF AVAILABLE gn-divi THEN DO:
        fill-in-cdname:SCREEN-VALUE IN FRAME {&FRAME-NAME} = gn-divi.desdiv.
    END.
    ELSE DO:
        fill-in-cdname:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " ** INVALIDO CD ***".
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-cuales
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-cuales W-Win
ON VALUE-CHANGED OF RADIO-SET-cuales IN FRAME F-Main
DO:
  ASSIGN {&self-name}.
  IF radio-set-cuales = 1 THEN DO:
      fill-in-cd:VISIBLE = NO.
      fill-in-cdname:VISIBLE = NO.
  END.
  ELSE DO:
      fill-in-cd:VISIBLE = YES.
      fill-in-cdname:VISIBLE = YES.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-ventas W-Win 
PROCEDURE carga-ventas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VAR dEstadoReparto AS CHAR.

    DEFINE VAR iTotalItems AS INT.
    DEFINE VAR iTotalCantidad AS INT.
    DEFINE VAR dPeso AS DEC.
    DEFINE VAR dVol AS DEC.
    DEFINE VAR dDpto AS CHAR.
    DEFINE VAR dProv AS CHAR.
    DEFINE VAR dDist AS CHAR.

    DEFINE VAR npedidocomercial AS CHAR INIT '**'.

    /*
    /* Pedido logistico */
    FIND FIRST faccpedi WHERE faccpedi.codcia = 1 AND faccpedi.coddoc = ccbcdocu.codped AND
                                faccpedi.nroped = ccbcdocu.nroped NO-LOCK NO-ERROR.    
    IF AVAILABLE faccpedi THEN npedidocomercial = faccpedi.nroref.
    /* Pedido Comercial */
    FIND FIRST faccpedi WHERE faccpedi.codcia = 1 AND faccpedi.coddoc = 'cot' AND
                                faccpedi.nroped = npedidocomercial NO-LOCK NO-ERROR.
    /* Orden de despacho */
    FIND FIRST ord-faccpedi WHERE ord-faccpedi.codcia = 1 AND ord-faccpedi.coddoc = ccbcdocu.libre_c01 AND
                                ord-faccpedi.nroped = ccbcdocu.libre_c02 NO-LOCK NO-ERROR.
    IF AVAILABLE ord-faccpedi THEN DO:
        dPeso = ord-faccpedi.peso.
        dVol = ord-faccpedi.volumen.
        FOR EACH ord-facdpedi WHERE ord-facdpedi.codcia = 1 AND ord-facdpedi.coddoc = ccbcdocu.libre_c01 AND
                                    ord-facdpedi.nroped = ccbcdocu.libre_c02 NO-LOCK.
            iTotalItems = iTotalItems + 1.
            iTotalCantidad = iTotalCantidad + (ord-facdpedi.canat * ord-facdpedi.factor).
        END.
    END.
    
    FIND FIRST TabDepto WHERE TabDepto.codDepto = ccbcdocu.codDpto NO-LOCK NO-ERROR.
    IF AVAILABLE tabdepto THEN dDpto = TRIM(tabdepto.nomdepto).

    FIND FIRST TabProvi WHERE TabProvi.codDepto = ccbcdocu.codDpto AND
                                tabProvi.codprovi = ccbcdocu.codProv NO-LOCK NO-ERROR.
    IF AVAILABLE tabprovi THEN dProv =  TRIM(tabprovi.nomprovi).

    FIND FIRST TabDistr WHERE TabDistr.codDepto = ccbcdocu.codDpto AND
                                tabDistr.codprovi = ccbcdocu.codProv AND 
                                tabDistr.coddistr = ccbcdocu.coddist NO-LOCK NO-ERROR.
    IF AVAILABLE tabdistr THEN dDist = TRIM(tabdistr.nomdistr).
    */
    DEFINE VAR nSerieGuia AS INT.
    DEFINE VAR nGuia AS INT.

    nSerieGuia = int(substr(di-rutad.nroref,1,3)).
    nGuia = int(substr(di-rutad.nroref,4)).
    FIND FIRST gre_header WHERE gre_header.serieGuia = nSerieGuia AND gre_header.numeroGuia = nGuia NO-LOCK NO-ERROR.


    CREATE tHojaRutaLog.
        ASSIGN tHojaRutaLog.nhojaruta = di-rutaC.nrodoc
            tHojaRutaLog.calmacen = ccbcdocu.codalm
            tHojaRutaLog.nplaca = di-rutaC.codveh
            tHojaRutaLog.lic_tran = di-rutaC.responsable
            tHojaRutaLog.nordendespacho = ccbcdocu.nroped
            tHojaRutaLog.hor_cita = string(di-rutaC.fchsal,"99/99/9999") + " " + SUBSTRING(DI-RutaC.HorSal, 1, 2) + ":" + SUBSTRING(DI-RutaC.HorSal, 3, 2)
            tHojaRutaLog.nroguia = di-rutaD.nroref
            tHojaRutaLog.codcli = ccbcdocu.codcli
            tHojaRutaLog.nomcli = limpiar-texto(ccbcdocu.nomcli)
            tHojaRutaLog.dircli = limpiar-texto(ccbcdocu.lugent)   /*limpiar-texto(ccbcdocu.dircli)*/
            tHojaRutaLog.refdir = limpiar-texto(ccbcdocu.glosa)
            /*
            tHojaRutaLog.femision = di-rutaC.fchdoc            
            tHojaRutaLog.ctipo = "VENTAS"
            tHojaRutaLog.nplaca1 = IF (AVAILABLE gre_header) THEN gre_header.numeroPlacaVehiculoPrin ELSE ""
            tHojaRutaLog.lic_tran1 = IF (AVAILABLE gre_header) THEN gre_header.numerolicencia ELSE ""
            */
            .


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-transferencias W-Win 
PROCEDURE cargar-transferencias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VAR dEstadoReparto AS CHAR.

    DEFINE VAR iTotalItems AS INT.
    DEFINE VAR iTotalCantidad AS DEC.
    DEFINE VAR iOrden AS DEC.

    DEFINE VAR dPeso AS DEC.
    DEFINE VAR dVol AS DEC.
    DEFINE VAR dDpto AS CHAR.
    DEFINE VAR dProv AS CHAR.
    DEFINE VAR dDist AS CHAR.

    DEFINE VAR npedidocomercial AS CHAR INIT '**'.

    DEFINE VAR cOrden AS CHAR.
    DEFINE VAR nOrden AS CHAR.
    DEFINE VAR cDpto AS CHAR.
    DEFINE VAR cProv AS CHAR.
    DEFINE VAR cDist AS CHAR.
    DEFINE VAR x-codcli AS CHAR FORMAT 'x(15)'.
    DEFINE VAR x-nomcli AS CHAR FORMAT 'x(100)'.
    DEFINE VAR x-dircli AS CHAR FORMAT 'x(100)'.
    
    cOrden = almcmov.codref.
    nOrden = almcmov.nroref.

    DEFINE VAR nSerieGuia AS INT.
    DEFINE VAR nGuia AS INT.

    nSerieGuia = di-rutag.serref.
    nGuia = di-rutag.nroref.
    FIND FIRST gre_header WHERE gre_header.serieGuia = nSerieGuia AND gre_header.numeroGuia = nGuia NO-LOCK NO-ERROR.

    
    /* Orden de despacho */
    FIND FIRST ord-faccpedi WHERE ord-faccpedi.codcia = 1 AND ord-faccpedi.coddoc = cOrden AND     /* OTR */
                                ord-faccpedi.nroped = nOrden NO-LOCK NO-ERROR.
    IF AVAILABLE ord-faccpedi THEN DO:
        dPeso = ord-faccpedi.peso.
        dVol = ord-faccpedi.volumen.
        x-codcli = ord-faccpedi.codcli.
        x-nomcli = limpiar-texto(ord-faccpedi.nomcli).
        /*
        FOR EACH ord-facdpedi WHERE ord-facdpedi.codcia = 1 AND ord-facdpedi.coddoc = cOrden AND
                                    ord-facdpedi.nroped = nOrden NO-LOCK.
            iTotalItems = iTotalItems + 1.
            iTotalCantidad = iTotalCantidad + (ord-facdpedi.canat * ord-facdpedi.factor).
            /* Buscamos el costo KARDEX */
            FIND LAST almstkge WHERE almstkge.codcia = 1 AND almstkge.codmat = ord-facdpedi.codmat AND
                                    almstkge.fecha <= ord-faccpedi.fchped NO-LOCK NO-ERROR.
            IF AVAILABLE almstkge THEN iOrden = iOrden + ((ord-facdpedi.canat * ord-facdpedi.factor) * almstkge.ctouni).
        END.
        */
    END.
    
    FIND FIRST almacen WHERE almacen.codcia = 1 AND almacen.codalm = almcmov.almdes.
    IF AVAILABLE almacen THEN DO:
        x-dircli = almacen.diralm.
        FIND FIRST gn-divi WHERE gn-divi.codcia = 1 AND gn-divi.coddiv = almacen.coddiv NO-LOCK NO-ERROR.
        IF AVAILABLE gn-divi THEN DO:
            cDpto = gn-divi.campo-char[3].
            cProv = gn-divi.campo-char[4].
            cDist = gn-divi.campo-char[5].
        END.
    END.
    /*
    FIND FIRST TabDepto WHERE TabDepto.codDepto = cDpto NO-LOCK NO-ERROR.
    IF AVAILABLE tabdepto THEN dDpto = TRIM(tabdepto.nomdepto).

    FIND FIRST TabProvi WHERE TabProvi.codDepto = cDpto AND
                                tabProvi.codprovi = cProv NO-LOCK NO-ERROR.
    IF AVAILABLE tabprovi THEN dProv =  TRIM(tabprovi.nomprovi).

    FIND FIRST TabDistr WHERE TabDistr.codDepto = cDpto AND
                                tabDistr.codprovi = cProv AND 
                                tabDistr.coddistr = cDist NO-LOCK NO-ERROR.
    IF AVAILABLE tabdistr THEN dDist = TRIM(tabdistr.nomdistr).
    */

    CREATE tHojaRutaLog.
        ASSIGN tHojaRutaLog.nhojaruta = di-rutaC.nrodoc
            tHojaRutaLog.calmacen = almcmov.codalm
            tHojaRutaLog.nplaca = di-rutaC.codveh
            tHojaRutaLog.lic_tran = di-rutaC.responsable    /*di-rutaC.libre_c01*/
            tHojaRutaLog.nordendespacho = almcmov.nroref
            tHojaRutaLog.hor_cita = string(di-rutaC.fchsal,"99/99/9999") + " " + SUBSTRING(DI-RutaC.HorSal, 1, 2) + ":" + SUBSTRING(DI-RutaC.HorSal, 3, 2)
            tHojaRutaLog.nroguia = string(di-rutaG.serref,"999") + " - " + string(di-rutaG.nroref,"99999999")
            tHojaRutaLog.codcli = x-codcli
            tHojaRutaLog.nomcli = limpiar-texto(x-nomcli)
            tHojaRutaLog.dircli = limpiar-texto(X-dircli)   
            tHojaRutaLog.refdir = ""
            /*
            tHojaRutaLog.femision = di-rutaC.fchdoc            
            tHojaRutaLog.ctipo = 'TRANSFERENCIAS'
            tHojaRutaLog.nplaca1 = IF (AVAILABLE gre_header) THEN gre_header.numeroPlacaVehiculoPrin ELSE ""
            tHojaRutaLog.lic_tran1 = IF (AVAILABLE gre_header) THEN gre_header.numerolicencia ELSE ""
            */
            .


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win  _DEFAULT-ENABLE
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
  DISPLAY RADIO-SET-cuales FILL-IN-cd FILL-IN-desde FILL-IN-hasta FILL-IN-cdname 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-16 RADIO-SET-cuales FILL-IN-cd FILL-IN-desde FILL-IN-hasta 
         BUTTON-1 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generarExcel W-Win 
PROCEDURE generarExcel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo.

DEFINE VAR cFiler1 AS CHAR.
DEFINE VAR cFiler2 AS CHAR.

cFiler1 = STRING(fDesde,"99/99/9999").
cFiler1 = REPLACE(cFiler1,"/","-").
cFiler2 = STRING(fHasta,"99/99/9999").
cFiler2 = REPLACE(cFiler2,"/","-").

c-xls-file = cRutaExcel + '\H-RutasDataSmart_' + cFiler1 + "_" + cFiler2 + ".xlsx".

run pi-crea-archivo-csv IN hProc (input  buffer tHojaRutaLog:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer tHojaRutaLog:handle,
                        input  c-csv-file,
                        output c-xls-file) .


DELETE PROCEDURE hProc.

MESSAGE "Se genero el archivo " SKIP
        c-xls-file 
        VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      fill-in-desde:SCREEN-VALUE = STRING(TODAY - 15,"99/99/9999").
      fill-in-hasta:SCREEN-VALUE = STRING(TODAY,"99/99/9999").
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesar W-Win 
PROCEDURE procesar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

qCapMinima = 0.
qCapMaxima = 0.
qVolumen = 0.

FOR EACH di-rutaC WHERE di-rutaC.codcia = 1 AND 
                        di-rutaC.coddoc = 'H/R' AND
                        (di-rutaC.fchdoc >= fDesde AND di-rutaC.fchdoc <= fHasta) AND
                        (fill-in-cd = "" OR di-rutaC.coddiv = fill-in-cd) AND 
                        di-rutaC.flgest <> 'A' NO-LOCK,
                        EACH di-rutaD OF di-rutaC NO-LOCK,
                        FIRST ccbcdocu WHERE ccbcdocu.codcia = 1 AND 
                                            ccbcdocu.coddoc = di-rutaD.codref AND       /* G/R */
                                            ccbcdocu.nrodoc = di-rutaD.nroref NO-LOCK
                         BREAK BY di-rutaC.coddoc BY di-rutaC.nrodoc :
                        
            IF FIRST-OF(di-rutaC.coddoc) OR FIRST-OF(di-rutaC.nrodoc) THEN DO:
                /*
                cProveedor = di-rutaC.codpro.
                dProveedor = "".
                dDivisionHR = "".
                qCapMinima = 0.
                qCapMaxima = 0.
                qVolumen = 0.

                FIND FIRST gn-prov WHERE gn-prov.codcia = 0
                        AND gn-prov.codpro = DI-RutaC.codPro NO-LOCK NO-ERROR.

                IF AVAILABLE gn-prov THEN DO:        
                    dProveedor = gn-prov.nompro.
                END.

                dResponsable = "".
                FIND FIRST pl-pers WHERE pl-pers.nrodocid = di-rutaC.responsable NO-LOCK NO-ERROR.
                IF AVAILABLE pl-pers THEN dResponsable = pl-pers.patper + " " + pl-pers.matper + " " + pl-pers.nomper.

                FIND FIRST gn-divi WHERE gn-divi.codcia = 1 AND gn-divi.coddiv = di-rutaC.coddiv NO-LOCK NO-ERROR.
                IF AVAILABLE gn-divi THEN dDivisionHR = gn-divi.desdiv.

                FIND FIRST gn-vehic WHERE gn-vehic.codcia = 1 AND gn-vehic.placa = di-rutaC.codveh NO-LOCK NO-ERROR.
                IF AVAILABLE gn-vehic THEN DO:
                    qCapMinima = gn-vehic.libre_d01.
                    qCapMaxima = gn-vehic.carga.
                    qVolumen = gn-vehic.volumen.
                END.
                */
            END.

            RUN carga-ventas.
            
END.

/* Transferencias NO GRE */
FOR EACH di-rutaC WHERE di-rutaC.codcia = 1 AND 
                        di-rutaC.coddoc = 'H/R' AND
                        (di-rutaC.fchdoc >= fDesde AND di-rutaC.fchdoc <= fHasta) AND
                        (fill-in-cd = "" OR di-rutaC.coddiv = fill-in-cd) AND 
                        di-rutaC.flgest <> 'A' NO-LOCK,
                        EACH di-rutaG OF di-rutaC NO-LOCK,
                        FIRST almcmov WHERE almcmov.codcia = 1 AND almcmov.tipmov = di-rutaG.tipmov AND
                                            almcmov.codmov = di-rutaG.codmov AND almcmov.codalm = di-rutaG.codalm AND
                                            almcmov.nroser = di-rutaG.serref AND almcmov.nrodoc = di-rutaG.nroref NO-LOCK
                        BREAK BY di-rutaC.coddoc BY di-rutaC.nrodoc :
                        

            IF FIRST-OF(di-rutaC.coddoc) OR FIRST-OF(di-rutaC.nrodoc) THEN DO:
                /*
                cProveedor = di-rutaC.codpro.
                dProveedor = "".
                dDivisionHR = "".
                qCapMinima = 0.
                qCapMaxima = 0.
                qVolumen = 0.

                FIND FIRST gn-prov WHERE gn-prov.codcia = 0
                        AND gn-prov.codpro = DI-RutaC.codPro NO-LOCK NO-ERROR.

                IF AVAILABLE gn-prov THEN DO:        
                    dProveedor = gn-prov.nompro.
                END.

                dResponsable = "".
                FIND FIRST pl-pers WHERE pl-pers.nrodocid = di-rutaC.responsable NO-LOCK NO-ERROR.
                IF AVAILABLE pl-pers THEN dResponsable = pl-pers.patper + " " + pl-pers.matper + " " + pl-pers.nomper.

                FIND FIRST gn-divi WHERE gn-divi.codcia = 1 AND gn-divi.coddiv = di-rutaC.coddiv NO-LOCK NO-ERROR.
                IF AVAILABLE gn-divi THEN dDivisionHR = gn-divi.desdiv.

                FIND FIRST gn-vehic WHERE gn-vehic.codcia = 1 AND gn-vehic.placa = di-rutaC.codveh NO-LOCK NO-ERROR.
                IF AVAILABLE gn-vehic THEN DO:
                    qCapMinima = gn-vehic.libre_d01.
                    qCapMaxima = gn-vehic.carga.
                    qVolumen = gn-vehic.volumen.
                END.
                */

            END.       

            RUN cargar-transferencias.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION limpiar-texto W-Win 
FUNCTION limpiar-texto RETURNS CHARACTER
  (  pTexto AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEF VAR caracteresValidos AS CHAR NO-UNDO.
DEF VAR caracterActual AS CHAR NO-UNDO.
DEF VAR tamanoCadena AS INT NO-UNDO.
DEF VAR cadenaResultado AS CHAR NO-UNDO.
DEFINE VAR cadenaTexto AS CHAR.
DEF VAR i AS INT NO-UNDO.
DEF VAR sustituirPor AS CHAR INIT " ".

caracteresValidos = ' 0123456789abcdefghijklmnñopqrstuvwxyzABCDEFGHIJKLMNÑOPQRSTUVWXYZ-_.,'.
caracteresValidos = caracteresValidos + "/()#*+-$&%áéíóúÁÉÍÓÚ:¿?!¡=@".

        cadenaTexto = pTexto.
        tamanoCadena = LENGTH(cadenaTexto).
        cadenaResultado = "".
        DO i = 1 TO tamanoCadena:
            caracterActual = SUBSTRING(cadenaTexto, i, 1).
            IF INDEX(caracteresValidos, caracterActual) > 0 THEN
                cadenaResultado = cadenaResultado + caracterActual.
            ELSE 
                cadenaResultado = cadenaResultado + sustituirPor.
        END.

  RETURN cadenaresultado.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

