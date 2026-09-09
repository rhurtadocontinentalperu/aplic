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
DEF SHARED VAR pv-codcia AS INTE.
DEF SHARED VAR cl-codcia AS INTE.
DEF SHARED VAR s-codcia AS INTE.

/* Local Variable Definitions ---                                       */
DEFINE VAR cProveedor AS CHAR.
DEFINE VAR dProveedor AS CHAR.
DEFINE VAR dResponsable AS CHAR.
DEFINE VAR dDivisionHR AS CHAR.

DEFINE VAR qCapMinima AS DEC.
DEFINE VAR qCapMaxima AS DEC.
DEFINE VAR qVolumen AS DEC.

DEFINE BUFFER ord-faccpedi FOR faccpedi.
DEFINE BUFFER ord-facdpedi FOR facdpedi.
DEFINE BUFFER cmp-ccbcdocu FOR ccbcdocu.

DEFINE TEMP-TABLE tHojaRuta
    FIELD   chojaruta       AS  CHAR    FORMAT 'x(5)'   LABEL "Codigo"
    FIELD   nhojaruta       AS  CHAR    FORMAT 'x(15)'  LABEL "No de H/R"
    FIELD   femision        AS  DATE                    LABEL "Emision H/R"
    FIELD   ctipo           AS  CHAR    FORMAT 'x(50)'  LABEL "Tipo"
    /**/
    FIELD   nplaca          AS  CHAR   FORMAT 'x(15)'   LABEL "Placa de vehiculo"
    FIELD   qcapminima      AS  DEC    FORMAT '->>,>>>,>>9.9999' LABEL "Capacidad Minima" DECIMALS 6
    FIELD   qcapmaxima      AS  DEC    FORMAT '->>,>>>,>>9.9999' LABEL "Capacidad Maxima" DECIMALS 6
    FIELD   qvolumen        AS  DEC    FORMAT '->>,>>>,>>9.9999' LABEL "Volumen" DECIMALS 6
    /**/
    FIELD   dResponsable    AS  CHAR   FORMAT 'x(100)'  LABEL "Responsable"
    FIELD   cdivision       AS  CHAR   FORMAT 'x(10)'   LABEL "Division de despacho"
    FIELD   ddivision       AS  CHAR   FORMAT 'x(100)'  LABEL "Nombre Division de despacho"
    FIELD   calmacen        AS  CHAR   FORMAT 'x(10)'   LABEL "Almacen despacho"
    FIELD   calmacendest    AS  CHAR   FORMAT 'x(10)'   LABEL "Almacen Destino"
    FIELD   fsalida         AS  DATE                    LABEL "Salida vehiculo"
    FIELD   hsalida         AS  CHAR   FORMAT 'x(10)'   LABEL "Hora salida vehiculo"
    FIELD   cproveedor      AS  CHAR   FORMAT 'x(15)'   LABEL "Transportista"
    /* 14/04/2026: Solicitado por Felix Perez */
    FIELD   AuxReparto      AS CHAR    FORMAT 'x(100)'  LABEL 'Auxiliar de reparto'
    FIELD   CantEstiba      AS INTE     FORMAT '>>9'    LABEL 'Cantidad estibadores'
    /**/
    FIELD   nguiatrans      AS  CHAR   FORMAT 'x(50)'   LABEL "G/R Transportista"
    /**/
    FIELD   cdivisioncom    AS  CHAR   FORMAT 'x(10)'   LABEL "Division venta"
    FIELD   ddivisioncom    AS  CHAR   FORMAT 'x(10)'   LABEL "Nombre Division venta"
    FIELD   cpedidocomercial    AS  CHAR   FORMAT 'x(5)'    LABEL "Cod.Pedido"
    FIELD   npedidocomercial    AS  CHAR   FORMAT 'x(15)'   LABEL "Pedido Comercial"
    FIELD   femisionpedcom  AS  DATE                        LABEL "Emision Pedido comercial"
    FIELD   cmonedapedcom   AS  CHAR    FORMAT 'x(15)'      LABEL "Moneda Pedido Comercial"
    FIELD   ipedcom         AS  DEC    FORMAT '->>,>>>,>>9.99' LABEL "Importe pedido comercial"
    FIELD   codclie         AS  CHAR    FORMAT 'x(15)'      LABEL "CodigoClie"
    FIELD   nomcli          AS  CHAR    FORMAT 'x(100)'     LABEL "Razon social"
    /**/
    FIELD   ccomprobante    AS  CHAR   FORMAT 'x(5)'    LABEL "Cod. Cmpbnte"
    FIELD   ncomprobante    AS  CHAR   FORMAT 'x(15)'   LABEL "No. Cmpbnte"
    FIELD   femisioncmpte   AS  DATE                    LABEL "Emision Cmpbnte"
    /* 14/04/2026: Solicitado por Felix Perez */
    FIELD   hemisioncmpte   AS  CHAR    FORMAT 'x(10)'  LABEL 'Hora emision comprobante'
    FIELD   icmptesoles     AS  DECI    FORMAT '->>,>>>,>>9.99' LABEL 'Importe moneda soles'
    FIELD   icmptedolares   AS  DECI    FORMAT '->>,>>>,>>9.99' LABEL 'Importe moneda dolares'
    /**/
/*     FIELD   cmoneda         AS  CHAR    FORMAT 'x(15)' LABEL "Moneda Cmpbnte"          */
/*     FIELD   icmpte          AS  DEC    FORMAT '->>,>>>,>>9.99' LABEL "Importe Cmpbnte" */
    FIELD   cpedidologistico    AS  CHAR    FORMAT 'x(5)'       LABEL "Pedido logistico"
    FIELD   npedidologistico    AS  CHAR    FORMAT 'x(15)'      LABEL "No. pedido logistico"
    FIELD   cordendespacho      AS  CHAR    FORMAT 'x(5)'       LABEL "Orden despacho"
    FIELD   nordendespacho      AS  CHAR    FORMAT 'x(15)'      LABEL "No. Orden despacho"
    FIELD   femisionorden       AS  DATE                        LABEL "Fecha emision Orden"
    /* 14/04/2026: Solicitado por Felix Perez */
    FIELD   hemisionorden       AS  CHAR    FORMAT 'x(10)'      LABEL 'Hora emision OD/OTR'
    /**/
    FIELD   qpeso           AS  DEC    FORMAT '->>,>>>,>>9.9999'    LABEL "Peso" DECIMALS 6
    FIELD   qvol            AS  DEC    FORMAT '->>,>>>,>>9.999999'  LABEL "Volumen" DECIMALS 6
    FIELD   qitems          AS  DEC    FORMAT '->>,>>>,>>9.99'      LABEL "Items"
    FIELD   qart            AS  DEC    FORMAT '->>,>>>,>>9.99'      LABEL "Cantidad de articulos"
    FIELD   stcmpte         AS  CHAR   FORMAT 'x(25)'               LABEL "Estado del cmpte"
    /**/
    FIELD   cguiaremision   AS  CHAR   FORMAT 'x(5)'    LABEL "Cod. Guia remision"
    FIELD   nguiaremision   AS  CHAR   FORMAT 'x(15)'   LABEL "No. Guia remision"
    /* 14/04/2026: Solicitado por Felix Perez */
    FIELD   fguiaremision   AS DATE                     LABEL 'Fecha de GR'
    FIELD   hguiaremision   AS CHAR     FORMAT 'x(10)'  LABEL 'Hora de GR'
    /**/
    FIELD   destadoenvio    AS  CHAR   FORMAT 'x(50)'   LABEL "Cierre de H/R"
    /* 14/04/2026: Solicitado por Felix Perez */
    FIELD   fcierrehr       AS  CHAR    FORMAT 'x(20)'  LABEL 'Fecha de cierre de HR'
    FIELD   impdvuelto      AS  DECI    FORMAT '->>>,>>>,>>9.99'    LABEL 'Importe devuelto'
    /**/
    FIELD   dmotivo         AS  CHAR   FORMAT 'x(50)'   LABEL "Motivo del NO ENTREGADO"
    FIELD   creprogramado   AS  CHAR   FORMAT 'x(50)'   LABEL "Reprogramacion"
    /* 14/04/2026: Solicitado por Felix Perez */
    FIELD   freprogramado   AS DATE                     LABEL 'Fecha de reprogramacion'
    /**/
    FIELD   ddpto           AS  CHAR   FORMAT 'x(50)'   LABEL "Departamento"
    FIELD   dprov           AS  CHAR   FORMAT 'x(50)'   LABEL "Provincia"
    FIELD   ddist           AS  CHAR   FORMAT 'x(50)'   LABEL "Distrito"
    /**/

    INDEX idx01 chojaruta nhojaruta cordendespacho nordendespacho
    .

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
&Scoped-Define ENABLED-OBJECTS BUTTON-2 BtnDone fDesde fHasta 
&Scoped-Define DISPLAYED-OBJECTS fDesde fHasta FILL-IN_Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fMotivoNoEntregado W-Win 
FUNCTION fMotivoNoEntregado RETURNS CHARACTER
  ( pCodMotivo AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fResultadodEnvio W-Win 
FUNCTION fResultadodEnvio RETURNS CHARACTER
  ( pEstado AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD limpiar-texto W-Win 
FUNCTION limpiar-texto RETURNS CHARACTER
  (  pTexto AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 9 BY 2.15
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/tbldat.ico":U
     LABEL "Button 2" 
     SIZE 9 BY 2.15 TOOLTIP "Exportar a Texto".

DEFINE VARIABLE fDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE fHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 61 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-2 AT ROW 1.27 COL 73 WIDGET-ID 8
     BtnDone AT ROW 1.27 COL 82 WIDGET-ID 6
     fDesde AT ROW 1.54 COL 19 COLON-ALIGNED WIDGET-ID 2
     fHasta AT ROW 2.62 COL 19 COLON-ALIGNED WIDGET-ID 4
     FILL-IN_Mensaje AT ROW 4.23 COL 9 COLON-ALIGNED NO-LABEL WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 92.57 BY 5.62
         FONT 4 WIDGET-ID 100.


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
         TITLE              = "INDICADOR DE HOJAS DE RUTA"
         HEIGHT             = 5.62
         WIDTH              = 92.57
         MAX-HEIGHT         = 26.15
         MAX-WIDTH          = 191.29
         VIRTUAL-HEIGHT     = 26.15
         VIRTUAL-WIDTH      = 191.29
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
/* SETTINGS FOR FILL-IN FILL-IN_Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* INDICADOR DE HOJAS DE RUTA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* INDICADOR DE HOJAS DE RUTA */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone W-Win
ON CHOOSE OF BtnDone IN FRAME F-Main /* Done */
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


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  ASSIGN fDesde fHasta.

  /* Pantalla de Impresión */
  DEF VAR pOptions AS CHAR.
  DEF VAR pArchivo AS CHAR.
  DEF VAR cArchivo AS CHAR.
  DEFINE VAR cFechaHora AS CHAR.

  RUN lib/tt-file-to-onlytext (OUTPUT pOptions, OUTPUT pArchivo).
  IF TRUE <> (pOptions > "") THEN RETURN.

  SESSION:SET-WAIT-STATE('GENERAL').
  RUN procesar.
  SESSION:SET-WAIT-STATE('').
  IF NOT CAN-FIND(FIRST tHojaRuta NO-LOCK) THEN DO:
      MESSAGE 'NO hay registros que exportar' VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.

  cArchivo = LC(pArchivo).
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN lib/tt-filev2 (TEMP-TABLE tHojaRuta:HANDLE, cArchivo, pOptions).

  MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.
  FILL-IN_Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

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

    /* Pedido logistico */
    FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND 
        faccpedi.coddoc = ccbcdocu.codped AND
        faccpedi.nroped = ccbcdocu.nroped NO-LOCK NO-ERROR.    
    IF AVAILABLE faccpedi THEN npedidocomercial = faccpedi.nroref.

    /* Pedido Comercial */
    FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND faccpedi.coddoc = 'cot' AND
        faccpedi.nroped = npedidocomercial NO-LOCK NO-ERROR.
    IF AVAILABLE faccpedi THEN DO:
        /**/
        ASSIGN 
            tHojaRuta.cdivisioncom = faccpedi.coddiv.
        FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = faccpedi.coddiv NO-LOCK NO-ERROR.
        IF AVAILABLE gn-divi THEN ASSIGN tHojaRuta.ddivisioncom = gn-divi.desdiv.
        ASSIGN
            tHojaRuta.cpedidocomercial = faccpedi.coddoc
            tHojaRuta.npedidocomercial = faccpedi.nroped
            tHojaRuta.femisionpedcom = faccpedi.fchped
            tHojaRuta.cmonedapedcom = IF (faccpedi.codmon = 2) THEN 'Dolares' ELSE 'Soles'
            tHojaRuta.ipedcom = faccpedi.TotalPrecioVenta
                .
    END.

    /* Orden de despacho */
    FIND ord-faccpedi WHERE ord-faccpedi.codcia = s-codcia AND 
        ord-faccpedi.coddoc = ccbcdocu.libre_c01 AND
        ord-faccpedi.nroped = ccbcdocu.libre_c02 NO-LOCK NO-ERROR.
    IF AVAILABLE ord-faccpedi THEN DO:
        dPeso = ord-faccpedi.peso.
        dVol = ord-faccpedi.volumen.
        FOR EACH ord-facdpedi OF ord-faccpedi NO-LOCK:
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

    ASSIGN
        tHojaRuta.codclie = ccbcdocu.codcli
        tHojaRuta.nomcli = limpiar-texto(ccbcdocu.nomcli)
        tHojaRuta.ccomprobante = ccbcdocu.codref
        tHojaRuta.ncomprobante = ccbcdocu.nroref
        tHojaRuta.femisioncmpte = ccbcdocu.fchdoc
        tHojaRuta.hemisioncmpte = CcbCDocu.HorCie
        tHojaRuta.icmptesoles = (IF Ccbcdocu.codmon = 1 THEN ccbcdocu.TotalPrecioVenta ELSE 0)
        tHojaRuta.icmptedolares = (IF Ccbcdocu.codmon = 2 THEN ccbcdocu.TotalPrecioVenta ELSE 0)
        tHojaRuta.cpedidologistico = ccbcdocu.codped
        tHojaRuta.npedidologistico = ccbcdocu.nroped
        tHojaRuta.cordendespacho = ccbcdocu.libre_c01
        tHojaRuta.nordendespacho = ccbcdocu.libre_c02
        tHojaRuta.femisionorden = IF (AVAILABLE ord-faccpedi) THEN ord-faccpedi.fchped ELSE ?
        tHojaRuta.hemisionorden = IF (AVAILABLE ord-faccpedi) THEN ord-faccpedi.hora ELSE ''
        tHojaRuta.qpeso = dPeso
        tHojaRuta.qvol = dVol
        tHojaRuta.qitems = iTotalItems
        tHojaRuta.qart = iTotalCantidad
        tHojaRuta.stcmpte = IF (ccbcdocu.flgest = 'A') THEN 'CMPTE ANULADO' ELSE ''
        .
    ASSIGN
        tHojaRuta.cguiaremision = di-rutaD.codref
        tHojaRuta.nguiaremision = di-rutaD.nroref
        .
    FIND gre_header WHERE gre_header.serieGuia = INTEGER(SUBSTRING(di-rutaD.nroref,1,3)) AND
        gre_header.numeroGuia = INTEGER(SUBSTRING(di-rutaD.nroref,4)) NO-LOCK NO-ERROR.
    IF AVAILABLE gre_header THEN
        ASSIGN
        tHojaRuta.fguiaremision = gre_header.fechaEmisionGuia
        tHojaRuta.hguiaremision = gre_header.horaEmisionGuia
        .

    ASSIGN
        dEstadoReparto = fResultadodEnvio(di-rutaD.flgest)
        tHojaRuta.destadoenvio = dEstadoReparto
        .
    IF Di-RutaD.flgest = "N" THEN DO:   /* NO entregado */
        FIND cmp-ccbcdocu WHERE cmp-ccbcdocu.codcia = s-codcia AND
            cmp-ccbcdocu.coddoc = di-rutad.codref AND
            cmp-ccbcdocu.nrodoc = di-rutad.nroref NO-LOCK NO-ERROR.
        IF AVAILABLE cmp-ccbcdocu THEN tHojaRuta.impdvuelto = cmp-ccbcdocu.imptot.
        ASSIGN
            tHojaRuta.dmotivo = fMotivoNoEntregado(Di-RutaD.FlgEstDet)
            tHojaRuta.creprogramado = (IF (Di-RutaD.Libre_c02 = 'R') THEN 'Reprogramar' ELSE 'No reprogramar')
            .
        FIND Almcdocu WHERE Almcdocu.codcia = s-codcia AND
            Almcdocu.codllave = di-rutac.coddiv AND
            Almcdocu.coddoc = 'O/D' AND
            Almcdocu.libre_c01 = di-rutac.coddoc AND        /* H/R */
            Almcdocu.libre_c02 = di-rutac.nrodoc AND
            Almcdocu.flgest = "C" NO-LOCK NO-ERROR.
        IF AVAILABLE Almcdocu THEN tHojaRuta.freprogramado = AlmCDocu.FchAprobacion.
    END.

    ASSIGN
        tHojaRuta.ddpto = Ddpto
        tHojaRuta.dprov = dProv
        tHojaRuta.ddist = dDist
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
    
    cOrden = almcmov.codref.
    nOrden = almcmov.nroref.

    /* Orden de despacho */
    FIND FIRST ord-faccpedi WHERE ord-faccpedi.codcia = s-codcia AND ord-faccpedi.coddoc = cOrden AND     /* OTR */
                                ord-faccpedi.nroped = nOrden NO-LOCK NO-ERROR.
    IF AVAILABLE ord-faccpedi THEN DO:
        dPeso = ord-faccpedi.peso.
        dVol = ord-faccpedi.volumen.
        x-codcli = ord-faccpedi.codcli.
        x-nomcli = limpiar-texto(ord-faccpedi.nomcli).
        FOR EACH ord-facdpedi OF ord-faccpedi NO-LOCK:
            iTotalItems = iTotalItems + 1.
            iTotalCantidad = iTotalCantidad + (ord-facdpedi.canat * ord-facdpedi.factor).
            /* Buscamos el costo KARDEX */
            FIND LAST almstkge USE-INDEX Llave01 WHERE almstkge.codcia = s-codcia AND 
                almstkge.codmat = ord-facdpedi.codmat AND
                almstkge.fecha <= ord-faccpedi.fchped NO-LOCK NO-ERROR.
            IF AVAILABLE almstkge THEN iOrden = iOrden + ((ord-facdpedi.canat * ord-facdpedi.factor) * almstkge.ctouni).
        END.
        ASSIGN 
            tHojaRuta.codclie = x-codcli
            tHojaRuta.nomcli = x-nomcli
            tHojaRuta.cdivisioncom = ord-faccpedi.coddiv.
        FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = ord-faccpedi.coddiv NO-LOCK NO-ERROR.
        IF AVAILABLE gn-divi THEN ASSIGN tHojaRuta.ddivisioncom = gn-divi.desdiv.
    END.
    
    FIND almacen WHERE almacen.codcia = s-codcia AND almacen.codalm = almcmov.almdes NO-LOCK NO-ERROR.
    IF AVAILABLE almacen THEN DO:
        FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = almacen.coddiv NO-LOCK NO-ERROR.
        IF AVAILABLE gn-divi THEN DO:
            cDpto = gn-divi.campo-char[3].
            cProv = gn-divi.campo-char[4].
            cDist = gn-divi.campo-char[5].
        END.
    END.

    FIND TabDepto WHERE TabDepto.codDepto = cDpto NO-LOCK NO-ERROR.
    IF AVAILABLE tabdepto THEN dDpto = TRIM(tabdepto.nomdepto).

    FIND TabProvi WHERE TabProvi.codDepto = cDpto AND
                                tabProvi.codprovi = cProv NO-LOCK NO-ERROR.
    IF AVAILABLE tabprovi THEN dProv =  TRIM(tabprovi.nomprovi).

    FIND TabDistr WHERE TabDistr.codDepto = cDpto AND
                                tabDistr.codprovi = cProv AND 
                                tabDistr.coddistr = cDist NO-LOCK NO-ERROR.
    IF AVAILABLE tabdistr THEN dDist = TRIM(tabdistr.nomdistr).

    ASSIGN 
        tHojaRuta.calmacendest = almcmov.almdes
        .

    ASSIGN
        tHojaRuta.ccomprobante = "G/R"
        tHojaRuta.ncomprobante = STRING(almcmov.nroser,"999") + STRING(almcmov.nrodoc,"99999999")
        tHojaRuta.femisioncmpte = almcmov.fchdoc
        tHojaRuta.hemisioncmpte = CcbCDocu.HorCie
        tHojaRuta.icmptesoles = iOrden
        tHojaRuta.icmptedolares = 0
        tHojaRuta.cpedidologistico = ""
        tHojaRuta.npedidologistico = ""
        tHojaRuta.cordendespacho = almcmov.codref  /*ccbcdocu.libre_c01*/
        tHojaRuta.nordendespacho = almcmov.nroref  /*ccbcdocu.libre_c02*/
        tHojaRuta.femisionorden = IF (AVAILABLE ord-faccpedi) THEN ord-faccpedi.fchped ELSE ?
        tHojaRuta.hemisionorden = IF (AVAILABLE ord-faccpedi) THEN ord-faccpedi.hora ELSE ''
        tHojaRuta.qpeso = dPeso
        tHojaRuta.qvol = dVol
        tHojaRuta.qitems = iTotalItems
        tHojaRuta.qart = iTotalCantidad
        tHojaRuta.stcmpte = ""
        tHojaRuta.cguiaremision = "G/R"
        tHojaRuta.nguiaremision = STRING(almcmov.nroser,"999") + STRING(almcmov.nrodoc,"99999999")
        .
    FIND gre_header WHERE gre_header.serieGuia = almcmov.nroser AND
        gre_header.numeroGuia = almcmov.nrodoc NO-LOCK NO-ERROR.
    IF AVAILABLE gre_header THEN
        ASSIGN
        tHojaRuta.fguiaremision = gre_header.fechaEmisionGuia
        tHojaRuta.hguiaremision = gre_header.horaEmisionGuia.
    /**/
    ASSIGN
        dEstadoReparto = fResultadodEnvio(di-rutaG.flgest)
        tHojaRuta.destadoenvio = dEstadoReparto.
    IF Di-RutaG.flgest = "N" THEN DO:
        ASSIGN
            tHojaRuta.dmotivo = fMotivoNoEntregado(Di-RutaG.FlgEstDet).
        ASSIGN 
            tHojaRuta.creprogramado = IF (Di-RutaG.Libre_c02 = 'R') THEN 'Reprogramar' ELSE 'No reprogramar'.
    END.
    ASSIGN
        tHojaRuta.ddpto = Ddpto
        tHojaRuta.dprov = dProv
        tHojaRuta.ddist = dDist
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
  DISPLAY fDesde fHasta FILL-IN_Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-2 BtnDone fDesde fHasta 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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
  fDesde = DATE(01,01,YEAR(TODAY)).
  fHasta = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

DEF VAR pNombre AS CHAR NO-UNDO.
DEF VAR pOrigen AS CHAR NO-UNDO.

qCapMaxima = 0.
qVolumen = 0.

EMPTY TEMP-TABLE tHojaRuta.

FOR EACH di-rutaC WHERE di-rutaC.codcia = s-codcia AND 
        di-rutaC.coddoc = 'H/R' AND
        (di-rutaC.fchdoc >= fDesde AND di-rutaC.fchdoc <= fHasta) AND
        di-rutaC.flgest <> 'A' NO-LOCK:
    FILL-IN_Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
        "VENTAS: " +
        STRING(di-rutac.fchdoc,'99/99/9999') + " " +
        di-rutac.nrodoc.
    cProveedor = di-rutaC.codpro.
    dProveedor = "".
    dDivisionHR = "".
    qCapMinima = 0.
    qCapMaxima = 0.
    qVolumen = 0.
    FIND FIRST gn-prov WHERE gn-prov.codcia = pv-codcia AND gn-prov.codpro = DI-RutaC.codPro NO-LOCK NO-ERROR.
    IF AVAILABLE gn-prov THEN dProveedor = gn-prov.nompro.
    dResponsable = "".
    FIND FIRST pl-pers WHERE pl-pers.nrodocid = di-rutaC.responsable NO-LOCK NO-ERROR.
    IF AVAILABLE pl-pers THEN dResponsable = pl-pers.patper + " " + pl-pers.matper + " " + pl-pers.nomper.

    FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = di-rutaC.coddiv NO-LOCK NO-ERROR.
    IF AVAILABLE gn-divi THEN dDivisionHR = gn-divi.desdiv.

    FIND FIRST gn-vehic WHERE gn-vehic.codcia = s-codcia AND gn-vehic.placa = di-rutaC.codveh NO-LOCK NO-ERROR.
    IF AVAILABLE gn-vehic THEN DO:
        qCapMinima = gn-vehic.libre_d01.
        qCapMaxima = gn-vehic.carga.
        qVolumen = gn-vehic.volumen.
    END.
    RUN logis/p-busca-por-dni ( INPUT DI-RutaC.responsable,
                                OUTPUT pNombre,
                                OUTPUT pOrigen).
    /* ************************* */
    /* AHORA BARREMOS EL DETALLE */
    /* ************************* */
    FOR EACH di-rutaD NO-LOCK WHERE DI-RutaD.CodCia = di-rutac.codcia AND 
        DI-RutaD.CodDiv = di-rutac.coddiv AND
        DI-RutaD.CodDoc = di-rutac.coddoc AND
        DI-RutaD.NroDoc = di-rutac.nrodoc,
        FIRST ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia AND 
            ccbcdocu.coddoc = di-rutaD.codref AND       /* G/R */
            ccbcdocu.nrodoc = di-rutaD.nroref:
        /* DATOS GENERALES DE LA CABECERA */
        CREATE tHojaRuta.
        ASSIGN 
            tHojaRuta.chojaruta = di-rutaC.coddoc
            tHojaRuta.nhojaruta = di-rutaC.nrodoc
            tHojaRuta.femision = di-rutaC.fchdoc
            tHojaRuta.ctipo = 'VENTAS'
            tHojaRuta.nplaca = di-rutaC.codveh.
        ASSIGN
            tHojaRuta.qcapminima = qCapMinima
            tHojaRuta.qcapmaxima = qCapMaxima
            tHojaRuta.qVolumen = qVolumen.
        ASSIGN
            tHojaRuta.dResponsable = dResponsable
            tHojaRuta.cdivision = di-rutaC.coddiv
            tHojaRuta.ddivision = dDivisionHR
            tHojaRuta.calmacen = ccbcdocu.codalm
            tHojaRuta.fsalida = di-rutaC.fchsal
            tHojaRuta.hsalida = SUBSTRING(DI-RutaC.HorSal, 1, 2) + ":" + SUBSTRING(DI-RutaC.HorSal, 3, 2)       
            tHojaRuta.cproveedor = cProveedor + " " + dProveedor.

        ASSIGN
            tHojaRuta.AuxReparto = pNombre.
        IF di-rutac.ayudante-1 > '' THEN tHojaRuta.CantEstiba = tHojaRuta.CantEstiba + 1.
        IF di-rutac.ayudante-2 > '' THEN tHojaRuta.CantEstiba = tHojaRuta.CantEstiba + 1.
        IF di-rutac.ayudante-3 > '' THEN tHojaRuta.CantEstiba = tHojaRuta.CantEstiba + 1.
        IF di-rutac.ayudante-4 > '' THEN tHojaRuta.CantEstiba = tHojaRuta.CantEstiba + 1.
        IF di-rutac.ayudante-5 > '' THEN tHojaRuta.CantEstiba = tHojaRuta.CantEstiba + 1.
        IF di-rutac.ayudante-6 > '' THEN tHojaRuta.CantEstiba = tHojaRuta.CantEstiba + 1.
        IF di-rutac.ayudante-7 > '' THEN tHojaRuta.CantEstiba = tHojaRuta.CantEstiba + 1.

        ASSIGN
            tHojaRuta.nguiatrans = di-rutac.GuiaTransportista
            tHojaRuta.fcierrehr = DI-RutaC.FchCierre.
        /* DATOS DEL DETALLE */
        RUN carga-ventas.
    END.
END.

/* Transferencias NO GRE */
FOR EACH di-rutaC WHERE di-rutaC.codcia = s-codcia AND 
        di-rutaC.coddoc = 'H/R' AND
        (di-rutaC.fchdoc >= fDesde AND di-rutaC.fchdoc <= fHasta) AND
        di-rutaC.flgest <> 'A' NO-LOCK:
    FILL-IN_Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
        "TRANSFERENCIAS: " +
        STRING(di-rutac.fchdoc,'99/99/9999') + " " +
        di-rutac.nrodoc.
    cProveedor = di-rutaC.codpro.
    dProveedor = "".
    dDivisionHR = "".
    qCapMinima = 0.
    qCapMaxima = 0.
    qVolumen = 0.
    FIND FIRST gn-prov WHERE gn-prov.codcia = pv-codcia AND gn-prov.codpro = DI-RutaC.codPro NO-LOCK NO-ERROR.
    IF AVAILABLE gn-prov THEN dProveedor = gn-prov.nompro.
    dResponsable = "".
    FIND FIRST pl-pers WHERE pl-pers.nrodocid = di-rutaC.responsable NO-LOCK NO-ERROR.
    IF AVAILABLE pl-pers THEN dResponsable = pl-pers.patper + " " + pl-pers.matper + " " + pl-pers.nomper.

    FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = di-rutaC.coddiv NO-LOCK NO-ERROR.
    IF AVAILABLE gn-divi THEN dDivisionHR = gn-divi.desdiv.

    FIND FIRST gn-vehic WHERE gn-vehic.codcia = s-codcia AND gn-vehic.placa = di-rutaC.codveh NO-LOCK NO-ERROR.
    IF AVAILABLE gn-vehic THEN DO:
        qCapMinima = gn-vehic.libre_d01.
        qCapMaxima = gn-vehic.carga.
        qVolumen = gn-vehic.volumen.
    END.
    RUN logis/p-busca-por-dni ( INPUT DI-RutaC.responsable,
                                OUTPUT pNombre,
                                OUTPUT pOrigen).
    /* ************************* */
    /* AHORA BARREMOS EL DETALLE */
    /* ************************* */
    FOR EACH di-rutaG NO-LOCK WHERE DI-RutaG.CodCia = di-rutac.codcia AND 
        DI-RutaG.CodDiv = di-rutac.coddiv AND
        DI-RutaG.CodDoc = di-rutac.coddoc AND
        DI-RutaG.NroDoc = di-rutac.nrodoc,
        FIRST almcmov NO-LOCK WHERE almcmov.codcia = s-codcia AND 
            almcmov.tipmov = di-rutaG.tipmov AND
            almcmov.codmov = di-rutaG.codmov AND 
            almcmov.codalm = di-rutaG.codalm AND
            almcmov.nroser = di-rutaG.serref AND 
            almcmov.nrodoc = di-rutaG.nroref:
        /* DATOS GENERALES DE LA CABECERA */
        CREATE tHojaRuta.
        ASSIGN 
            tHojaRuta.chojaruta = di-rutaC.coddoc
            tHojaRuta.nhojaruta = di-rutaC.nrodoc
            tHojaRuta.femision = di-rutaC.fchdoc
            tHojaRuta.ctipo = 'TRANSFERENCIAS'
            tHojaRuta.nplaca = di-rutaC.codveh.
        ASSIGN
            tHojaRuta.qcapminima = qCapMinima
            tHojaRuta.qcapmaxima = qCapMaxima
            tHojaRuta.qVolumen = qVolumen.
        ASSIGN
            tHojaRuta.dResponsable = dResponsable
            tHojaRuta.cdivision = di-rutaC.coddiv
            tHojaRuta.ddivision = dDivisionHR
            tHojaRuta.calmacen = ccbcdocu.codalm
            tHojaRuta.fsalida = di-rutaC.fchsal
            tHojaRuta.hsalida = SUBSTRING(DI-RutaC.HorSal, 1, 2) + ":" + SUBSTRING(DI-RutaC.HorSal, 3, 2)       
            tHojaRuta.cproveedor = cProveedor + " " + dProveedor.

        ASSIGN
            tHojaRuta.AuxReparto = pNombre.
        IF di-rutac.ayudante-1 > '' THEN tHojaRuta.CantEstiba = tHojaRuta.CantEstiba + 1.
        IF di-rutac.ayudante-2 > '' THEN tHojaRuta.CantEstiba = tHojaRuta.CantEstiba + 1.
        IF di-rutac.ayudante-3 > '' THEN tHojaRuta.CantEstiba = tHojaRuta.CantEstiba + 1.
        IF di-rutac.ayudante-4 > '' THEN tHojaRuta.CantEstiba = tHojaRuta.CantEstiba + 1.
        IF di-rutac.ayudante-5 > '' THEN tHojaRuta.CantEstiba = tHojaRuta.CantEstiba + 1.
        IF di-rutac.ayudante-6 > '' THEN tHojaRuta.CantEstiba = tHojaRuta.CantEstiba + 1.
        IF di-rutac.ayudante-7 > '' THEN tHojaRuta.CantEstiba = tHojaRuta.CantEstiba + 1.

        ASSIGN
            tHojaRuta.nguiatrans = di-rutac.GuiaTransportista
            tHojaRuta.fcierrehr = DI-RutaC.FchCierre.

        /* DATOS DEL DETALLE */
        RUN cargar-transferencias.
    END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fMotivoNoEntregado W-Win 
FUNCTION fMotivoNoEntregado RETURNS CHARACTER
  ( pCodMotivo AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR dRetVal AS CHAR.

    dRetVal = pCodMotivo.

    FIND FIRST almtabla WHERE almtabla.tabla = 'HR' and almtabla.codigo = pCodMotivo /*AND 
                            almtabla.nomant = 'N' and almtabla.codcta1 <> 'I'*/ NO-LOCK NO-ERROR.
    IF AVAILABLE almtabla THEN DO:
        dRetval = dRetVal + " " + almtabla.nombre.
    END.

  RETURN dRetval.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fResultadodEnvio W-Win 
FUNCTION fResultadodEnvio RETURNS CHARACTER
  ( pEstado AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR dRetVal AS CHAR.

    dRetVal = pEstado.

    IF pEstado = 'P' THEN dRetVal = dRetval + " Por entregar".
    IF pEstado = 'C' THEN dRetVal = dRetval + " Entregado".
    IF pEstado = 'N' THEN dRetVal = dRetval + " No entregado".
    IF pEstado = 'T' THEN dRetVal = dRetval + " Dejado en tienda".
    IF pEstado = 'R' THEN dRetVal = dRetval + " Error".
    IF pEstado = 'NR' THEN dRetVal = dRetval + " No recibido".


  RETURN dRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

