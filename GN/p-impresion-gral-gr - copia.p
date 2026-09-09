&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER b-Almacen FOR Almacen.
DEFINE BUFFER B-CDOCU FOR CcbCDocu.
DEFINE BUFFER B-DOCU FOR CcbCDocu.
DEFINE BUFFER COTIZACION FOR FacCPedi.
DEFINE BUFFER PEDIDO FOR FacCPedi.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* RHC 18/09/2020 Rutina General de Impresión de Guias de Remisión del Almacén */

DEF INPUT PARAMETER pOrigen AS CHAR.
/* Valores posibles:
    G/R: Guía de Remisión por Ventas 
    ALM: Guía de Remisión del Almacén por otras transferencias */
IF LOOKUP(pOrigen, 'G/R,ALM,TRF') = 0 THEN RETURN.

DEF INPUT PARAMETER pRowid AS ROWID.    
/* El ROWID de la tabla:
    G/R: de la tabla ccbcdocu
    ALM: de la tabla almcmov
    */

DEF INPUT PARAMETER pFormato AS INTE.
/* 1: Impresión con códigos de artículos internos
   2: Impresión con códigos EAN de los artículos 
   */
IF NOT (pFormato = 1 OR pFormato = 2) THEN RETURN.


DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR pv-codcia AS INTE.
DEF SHARED VAR cl-codcia AS INTE.
DEF SHARED VAR s-coddiv AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: b-Almacen B "?" ? INTEGRAL Almacen
      TABLE: B-CDOCU B "?" ? INTEGRAL CcbCDocu
      TABLE: B-DOCU B "?" ? INTEGRAL CcbCDocu
      TABLE: COTIZACION B "?" ? INTEGRAL FacCPedi
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 7.27
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/* Solicita Impresora */
DEFINE VAR pStatus AS LOG NO-UNDO.
SYSTEM-DIALOG PRINTER-SETUP UPDATE pStatus.
IF pStatus = NO THEN RETURN.

/* Lógica Principal */
DEF VAR  x-PuntoPartida AS CHAR NO-UNDO.
DEF VAR  x-PuntoLlegada AS CHAR NO-UNDO.
DEF VAR  x-Nombre       AS CHAR NO-UNDO.
DEF VAR  x-Ruc          AS CHAR NO-UNDO.
DEF VAR  x-CodCli       AS CHAR NO-UNDO.
DEF VAR  x-TitDoc       AS CHAR NO-UNDO.
DEF VAR  x-NroDoc       AS CHAR NO-UNDO.
DEF VAR  x-NroPed       AS CHAR NO-UNDO.
DEF VAR  x-CodVen       AS CHAR NO-UNDO.
DEF VAR  x-CodRef       AS CHAR NO-UNDO.
DEF VAR  x-NroRef       AS CHAR NO-UNDO.
DEF VAR  x-FchDoc       AS DATE NO-UNDO.

DEF VAR X-LugPar LIKE Almacen.DirAlm.
DEF VAR X-LugDes LIKE Almacen.DirAlm.
DEF VAR X-TRANS  LIKE FACCPEDI.Libre_c01.
DEF VAR X-DIREC  LIKE FACCPEDI.Libre_c02.
DEF VAR X-LUGAR  LIKE FACCPEDI.Libre_c03.
DEF VAR X-CONTC  LIKE FACCPEDI.Libre_c04.
DEF VAR X-HORA   LIKE FACCPEDI.Libre_c05.
DEF VAR X-FchRef LIKE ccbcdocu.fchdoc.

DEF VAR x-Bultos AS INT NO-UNDO.
DEF VAR x-Peso   AS DEC NO-UNDO.

/* RHC 20/07/2015 DATOS DEL TRANSPORTISTA */
DEF VAR f-CodAge AS CHAR NO-UNDO.
DEF VAR f-NomTra AS CHAR NO-UNDO.
DEF VAR f-RucAge AS CHAR NO-UNDO.
DEF VAR f-Marca  AS CHAR NO-UNDO.
DEF VAR f-NroLicencia AS CHAR NO-UNDO.
DEF VAR f-Placa  AS CHAR NO-UNDO.
DEF VAR f-Certificado AS CHAR NO-UNDO.
DEF VAR x-inicio-traslado AS CHAR FORMAT 'x(10)'.

DEF VAR x-NomTra       AS CHAR NO-UNDO.
DEF VAR x-RucTra       AS CHAR NO-UNDO.

/* 11/09/2020 Nro TOPAZ */
/* Solo para MI BANCO y BCP */
DEF VAR x-Grupo-Topaz AS CHAR FORMAT 'x(35)' NO-UNDO.

/* Variable de pie de página */
DEF VAR ftr-Glosa1 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa2 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa3 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa4 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa5 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa6 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa7 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa8 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa9 AS CHAR NO-UNDO.
DEF VAR ftr-Valor1 AS DECI NO-UNDO.
DEF VAR ftr-Valor2 AS DECI NO-UNDO.

/* Definimos Detalle de Impresión */
DEF TEMP-TABLE Detalle
    FIELD codcia AS INTE
    FIELD codalm AS CHAR FORMAT 'x(6)'
    FIELD nroitm AS INTE FORMAT '>>9'
    FIELD codmat AS CHAR FORMAT 'x(15)'
    FIELD desmat AS CHAR FORMAT 'x(40)'
    FIELD desmar AS CHAR FORMAT 'x(10)'
    FIELD candes AS DECI FORMAT '>>,>>9.99'
    FIELD undvta AS CHAR FORMAT 'x(8)'
    INDEX idx00 AS PRIMARY nroitm.

/* Cargamos temporales de acuerdo al origen */
CASE pOrigen:
    WHEN "G/R" THEN DO:
        FIND ccbcdocu WHERE ROWID(ccbcdocu) = pRowid NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ccbcdocu THEN RETURN.
        RUN Carga-GR.
    END.
    WHEN "ALM" THEN DO:
        FIND Almcmov WHERE ROWID(Almcmov) = pRowid NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almcmov THEN RETURN.
        RUN Carga-ALM.
    END.
    WHEN "TRF" THEN DO:
        FIND Almcmov WHERE ROWID(Almcmov) = pRowid NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almcmov THEN RETURN.
        RUN Carga-TRF.
    END.
END CASE.

/* ***************************************************************************** */
/* Definimos Encabezado */
/* ***************************************************************************** */
DEFINE FRAME F-HdrGui
    HEADER
    SKIP(6.75)
    x-PuntoPartida  AT 12 FORMAT 'x(100)' SKIP
    x-PuntoLlegada  AT 12 FORMAT "X(100)" SKIP
    x-Nombre        AT 12 FORMAT "X(70)"  SKIP
    x-Ruc           AT 12 FORMAT "X(11)" 
    x-CodCli        AT 12 FORMAT "X(11)" 
    f-NomTra        AT 90 FORMAT "X(40)"  SKIP

    x-TitDoc        AT 17 FORMAT 'x(15)'
    x-NroDoc        AT 35 FORMAT 'x(12)'
    x-NroPed        AT 50 FORMAT 'x(40)'

    f-RucAge        AT 87 FORMAT "X(11)" 
    f-Marca         AT 120 FORMAT 'x(20)' SKIP
    f-NroLicencia   AT 90 FORMAT 'x(15)'
    f-Placa         AT 115 FORMAT 'x(8)' SKIP(1)
    f-Certificado   AT 95 f-Certificado FORMAT 'x(20)' 
    x-Inicio-Traslado AT 120 SKIP
    x-CodVen        AT 85 FORMAT "X(3)"
    x-CodRef        AT 91 FORMAT 'x(3)'
    x-NroRef        /*AT 99*/ FORMAT "XXX-XXXXXXXX" 
    x-FchDoc        AT 119 FORMAT '99/99/9999'
    SKIP(1)
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 200.
/* ***************************************************************************** */
/* Definición de Pies de Página */
/* ***************************************************************************** */
/* DEFINE FRAME F-FtrGui                                                                                                              */
/*     HEADER                                                                                                                         */
/*     "LA MERCADERIA VIAJA POR CUENTA Y RIESGO DEL CLIENTE, EL DESPACHO DE MERCADERIA ABARCA HASTA LA AGENCIA DE TRANSPORTE" SKIP(1) */
/*     x-Grupo-Topaz                                                                                                                  */
/*     x-Bultos AT 50 FORMAT '>>,>>>' x-Peso AT 60 FORMAT '>>>,>>>.99' SKIP                                                           */
/*     'Contacto : ' X-CONTC FORMAT 'X(25)' 'Hora Aten :' X-HORA FORMAT 'X(10)'SKIP                                                   */
/*     'PRIMER TRAMO  : '     SKIP                                                                                                    */
/*     'Transport: ' X-NomTra FORMAT 'X(50)' SKIP                                                                                     */
/*     'RUC      : ' X-RucTra    FORMAT 'X(11)'                                                                                       */
/*     'Dirección: ' X-DIREC  FORMAT 'X(50)' SKIP                                                                                     */
/*     'SEGUNDO TRAMO  : '    SKIP                                                                                                    */
/*     'Destino  : ' X-LUGAR  FORMAT 'X(50)' SKIP                                                                                     */
/*     'Observ   : ' CcbCDocu.Glosa VIEW-AS TEXT FORMAT "X(60)"                                                                       */
/*     ' ' AT 75 SKIP                                                                                                                 */
/*     WITH PAGE-BOTTOM NO-LABELS NO-UNDERLINE NO-BOX STREAM-IO WIDTH 200.                                                            */
/*                                                                                                                                    */
/* DEFINE FRAME F-FtrGui2                                                                                                             */
/*     HEADER                                                                                                                         */
/*     "LA MERCADERIA VIAJA POR CUENTA Y RIESGO DEL CLIENTE, EL DESPACHO DE MERCADERIA ABARCA HASTA LA AGENCIA DE TRANSPORTE" skip(1) */
/*     x-Grupo-Topaz                                                                                                                  */
/*     x-Bultos AT 50 FORMAT '>>,>>>' x-Peso AT 60 FORMAT '>>>,>>>.99' SKIP(4)                                                        */
/*     WITH PAGE-BOTTOM NO-LABELS NO-UNDERLINE NO-BOX STREAM-IO WIDTH 200.                                                            */
/*                                                                                                                                    */
/* DEFINE FRAME F-FtrGui3                                                                                                             */
/*     HEADER                                                                                                                         */
/*     "LA MERCADERIA VIAJA POR CUENTA Y RIESGO DEL CLIENTE, EL DESPACHO DE MERCADERIA ABARCA HASTA LA AGENCIA DE TRANSPORTE" skip(1) */
/*     x-Grupo-Topaz                                                                                                                  */
/*     x-Bultos AT 50 FORMAT '>>,>>>' x-Peso AT 60 FORMAT '>>>,>>>.99' SKIP                                                           */
/*     'PRIMER TRAMO  : '     SKIP                                                                                                    */
/*     'Transport: ' X-NomTra FORMAT 'X(50)' SKIP                                                                                     */
/*     'RUC      : ' X-RucTra    FORMAT 'X(11)' SKIP                                                                                  */
/*     'Dirección: ' X-DIREC  FORMAT 'X(50)' SKIP                                                                                     */
/*     WITH PAGE-BOTTOM NO-LABELS NO-UNDERLINE NO-BOX STREAM-IO WIDTH 200.                                                            */
/*                                                                                                                                    */
/* DEFINE FRAME F-FtrGui4                                                                                                             */
/*     HEADER                                                                                                                         */
/*     "LA MERCADERIA VIAJA POR CUENTA Y RIESGO DEL CLIENTE, EL DESPACHO DE MERCADERIA ABARCA HASTA LA AGENCIA DE TRANSPORTE" skip(1) */
/*     x-Grupo-Topaz                                                                                                                  */
/*     x-Bultos AT 50 FORMAT '>>,>>>' x-Peso AT 60 FORMAT '>>>,>>>.99' SKIP                                                           */
/*     'SEGUNDO TRAMO  : '    SKIP                                                                                                    */
/*     'Destino  : ' X-LUGAR  FORMAT 'X(50)' SKIP                                                                                     */
/*     'Observ   : ' CcbCDocu.Glosa VIEW-AS TEXT FORMAT "X(60)" SKIP                                                                  */
/*     'Contacto : ' X-CONTC FORMAT 'X(25)' 'Hora Aten :' X-HORA FORMAT 'X(10)'SKIP                                                   */
/*     WITH PAGE-BOTTOM NO-LABELS NO-UNDERLINE NO-BOX STREAM-IO WIDTH 200.                                                            */

DEFINE FRAME F-FtrGui
    HEADER
    ftr-Glosa1 FORMAT 'x(130)' SKIP(1)
    ftr-Glosa2 FORMAT 'x(40)'
    ftr-Valor1 AT 50 FORMAT '>>,>>>' ftr-Valor2 AT 60 FORMAT '>>>,>>>.99' SKIP
    ftr-Glosa3 FORMAT 'x(100)' SKIP
    ftr-Glosa4 FORMAT 'x(100)' SKIP
    ftr-Glosa5 FORMAT 'x(100)' SKIP
    ftr-Glosa6 FORMAT 'x(100)' SKIP
    /*ftr-Glosa7 FORMAT 'x(100)' SKIP
    ftr-Glosa8 FORMAT 'x(100)' SKIP
    ftr-Glosa9 FORMAT 'x(100)' SKIP*/
    WITH PAGE-BOTTOM NO-LABELS NO-UNDERLINE NO-BOX STREAM-IO WIDTH 200.

/* ***************************************************************************** */
/* Definición de Detalle */
/* ***************************************************************************** */
DEFINE FRAME F-DetaGui
    Detalle.codalm  AT 01 
    Detalle.NroItm  AT 07 
    Detalle.codmat  AT 11 
    Detalle.desmat  AT 27 
    Detalle.desmar  AT 98 
    Detalle.candes  AT 108 
    Detalle.UndVta  AT 119 
    WITH NO-LABELS NO-BOX NO-UNDERLINE STREAM-IO WIDTH 200.

/* Imprimimos de acuerdo al formato seleccionado */
OUTPUT TO PRINTER PAGE-SIZE 43.
PUT CONTROL {&PRN0} + {&PRN5A} + CHR(48) + {&PRN3}.     
/* RHC 28/04/2020 NO imprimir FLETE (fam. 100 catcont SV ) */
FOR EACH Detalle NO-LOCK BREAK BY Detalle.codcia BY Detalle.nroitm:
    VIEW FRAME F-HdrGui.
    VIEW FRAME F-FtrGui.
/*     IF X-TRANS <> '' AND  X-LUGAR <> '' THEN VIEW FRAME F-FtrGui. */
/*     IF X-TRANS <> '' AND X-LUGAR = '' THEN VIEW FRAME F-FtrGui3.  */
/*     IF X-TRANS = '' AND X-LUGAR <> '' THEN VIEW FRAME F-FtrGui4.  */
/*     IF X-TRANS = '' AND X-LUGAR = '' THEN VIEW FRAME F-FtrGui2.   */
    DISPLAY 
        Detalle.codalm
        Detalle.NroItm 
        Detalle.codmat
        Detalle.desmat 
        Detalle.desmar
        Detalle.candes 
        Detalle.undvta 
        WITH FRAME F-DetaGui.
    IF LAST-OF(Detalle.codcia) THEN PAGE.
END.
OUTPUT CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Carga-ALM) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-ALM Procedure 
PROCEDURE Carga-ALM :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* ***************************************************************************** */
/* Valores de cabecera */
/* ***************************************************************************** */
ASSIGN
    x-FchDoc = Almcmov.FchDoc.
FIND Almacen WHERE Almacen.CodCia = Almcmov.CodCia 
    AND  Almacen.CodAlm = Almcmov.CodAlm 
    NO-LOCK NO-ERROR.
IF AVAILABLE Almacen THEN x-PuntoPartida = Almacen.DirAlm.
/* Buscamos Agencia de Transporte */
FIND admrutas WHERE admruta.CodPro = Almcmov.CodTra NO-LOCK NO-ERROR.
IF AVAILABLE admrutas THEN f-NomTra = admrutas.NomTra.
ASSIGN
    f-RucAge = Almcmov.CodTra.
/* Valores de acuerdo al movimiento de salida */
FIND Almtmovm WHERE Almtmovm.CodCia = Almcmov.CodCia
    AND Almtmovm.Tipmov = Almcmov.TipMov
    AND Almtmovm.Codmov = Almcmov.CodMov
    NO-LOCK.
IF Almtmovm.PidPro = YES THEN DO:
    FIND gn-prov WHERE gn-prov.codcia = pv-codcia 
        AND  gn-prov.codpro = Almcmov.codpro 
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-prov THEN 
        ASSIGN 
        x-PuntoLlegada = gn-prov.DirPro
        x-Nombre = gn-prov.NomPro
        x-Ruc = gn-prov.ruc.
END.
IF Almtmovm.ReqGuia = YES THEN DO:
    ASSIGN
        x-CodRef = "G/R"
        x-NroRef = STRING(Almcmov.NroSer,"999") + STRING(Almcmov.NroDoc,"999999").
END.
/* ***************************************************************************** */
/* Valores del Detalle */
/* ***************************************************************************** */
EMPTY TEMP-TABLE Detalle.
DEF VAR x-Item AS INTE INIT 1 NO-UNDO.
FOR EACH Almdmov OF Almcmov NO-LOCK, FIRST almmmatg OF Almdmov NO-LOCK
    BREAK BY Almdmov.nrodoc BY Almdmov.NroItm BY Almdmov.codmat:
    CREATE Detalle.
    ASSIGN
        Detalle.CodAlm = Almdmov.CodAlm
        Detalle.NroItm = x-Item
        Detalle.CodMat = Almdmov.CodMat
        Detalle.DesMat = Almmmatg.DesMat
        Detalle.DesMar = Almmmatg.DesMar
        Detalle.CanDes = Almdmov.CanDes
        Detalle.UndVta = Almdmov.CodUnd.
    x-Item = x-Item + 1.
    ftr-Valor2 = ftr-Valor2 + (Almdmov.candes * Almdmov.factor * Almmmatg.pesmat).
END.

DEFINE BUFFER B-ALMACEN FOR Almacen.
FIND b-Almacen WHERE b-Almacen.CodCia = Almcmov.CodCia 
    AND  b-Almacen.CodAlm = Almcmov.AlmDes
    NO-LOCK NO-ERROR.
IF AVAILABLE Almacen THEN X-LugDes = Almacen.DirAlm.
CASE TRUE:
    WHEN x-PuntoPartida > '' AND x-LugDes > '' THEN DO:
        ASSIGN
            ftr-Glosa1 = ''
            ftr-Glosa2 = ''
            ftr-Glosa3 = ''
            ftr-Glosa4 = 'TRASLADO'
            ftr-Glosa5 = 'SALIDA  : ' + Almcmov.CodAlm + "-" + x-PuntoPartida
            ftr-Glosa6 = 'DESTINO : ' + Almcmov.AlmDes + "-" + x-LugDes
            ftr-Glosa7 = 'SEGUNDO TRAMO  : '
            ftr-Glosa8 = 'Glosa   : ' + STRING(Almcmov.Observ,'X(50)')
            ftr-Glosa9 = ''.
    END.
END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Carga-GR) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-GR Procedure 
PROCEDURE Carga-GR PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* ***************************************************************************** */
/* Valores de cabecera */
/* ***************************************************************************** */
ASSIGN
    x-PuntoLlegada = Ccbcdocu.lugent    /* Sede del cliente o del transportista */
    x-Nombre       = Ccbcdocu.nomcli
    x-Ruc          = Ccbcdocu.ruccli
    x-CodCli       = Ccbcdocu.codcli.
/* Buscamos Agencia de Transporte */
IF CcbCDocu.CodAge > '' THEN DO:
    FIND FIRST gn-prov WHERE gn-prov.CodCia = pv-codcia AND
        gn-prov.CodPro = CcbCDocu.CodAge NO-LOCK NO-ERROR.
    IF AVAILABLE gn-prov THEN ASSIGN x-PuntoLlegada = Ccbcdocu.LugEnt2.
END.
/* RHC 16/06/2019 Lugar de entrega (* O/D)*/
RUN logis/p-lugar-de-entrega (Ccbcdocu.Libre_c01, Ccbcdocu.Libre_c02, OUTPUT x-PuntoLlegada).
IF NUM-ENTRIES(x-PuntoLlegada,'|') >= 2 THEN x-PuntoLlegada = TRIM(ENTRY(2, x-PuntoLlegada, '|')).
/* Parche por compatibilidad */
IF TRUE <> (x-PuntoLlegada > '') THEN x-PuntoLlegada = Ccbcdocu.DirCli.
/* ************************* */
FIND Ccbadocu OF Ccbcdocu NO-LOCK NO-ERROR.
IF AVAILABLE Ccbadocu THEN DO:
    /* Primer Tramo */
    ASSIGN
        x-Trans = CcbADocu.Libre_C[9]
        x-Direc = CcbADocu.Libre_C[12].
    /* Segundo Tramo */
    ASSIGN
        x-Lugar = CcbADocu.Libre_C[13]
        x-Contc = CcbADocu.Libre_C[14]
        x-Hora  = CcbADocu.Libre_C[15].
    /* Datos del Transportista/Conductor */
    ASSIGN
        f-CodAge = Ccbadocu.Libre_C[3]
        f-NomTra = Ccbadocu.Libre_C[4]
        f-RucAge = Ccbadocu.Libre_C[5]
        f-Marca  = Ccbadocu.Libre_C[2]
        f-NroLicencia = Ccbadocu.Libre_C[6]
        f-Placa  = Ccbadocu.Libre_C[1]
        f-Certificado = CcbADocu.Libre_C[17].
END.
FIND gn-prov WHERE gn-prov.CodCia = PV-CODCIA
    AND gn-prov.CodPro = X-TRANS
    NO-LOCK NO-ERROR.
IF AVAILABLE gn-prov THEN
     ASSIGN
           X-NomTra = gn-prov.NomPro
           X-RucTra = gn-prov.Ruc.

FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = Ccbcdocu.coddiv
    NO-LOCK NO-ERROR.
IF AVAILABLE gn-divi THEN x-PuntoPartida = TRIM(GN-DIVI.DirDiv) + " " + gn-divi.faxdiv.

FIND B-DOCU WHERE B-DOCU.CODCIA = ccbcdocu.CodCia 
    AND  B-DOCU.CodDoc = ccbcdocu.CodRef 
    AND  B-DOCU.NroDoc = ccbcdocu.NroRef 
    NO-LOCK NO-ERROR.
IF AVAILABLE B-DOCU THEN X-FchRef = B-DOCU.FchDoc.
ELSE X-FchRef = ?.

/* Los Bultos SOLAMENTE se imprimen en la primera guia */
/* Bultos */
FOR EACH CcbCBult WHERE CcbCBult.CodCia = Ccbcdocu.codcia AND
    CcbCBult.CodDiv = Ccbcdocu.coddiv AND 
    CcbCBult.CodDoc = ccbcdocu.libre_c01 AND
    CcbCBult.NroDoc = ccbcdocu.libre_c02
    NO-LOCK:
    x-Bultos = x-Bultos + CcbCBult.Bultos.
END.
DEF VAR x-Cuenta AS INT NO-UNDO.
x-Cuenta = 0.
FOR EACH B-CDOCU NO-LOCK WHERE B-CDOCU.CodCia = Ccbcdocu.CodCia AND
    B-CDOCU.CodDoc = Ccbcdocu.CodDoc AND
    B-CDOCU.CodDiv = Ccbcdocu.CodDiv AND
    B-CDOCU.Libre_c01 = Ccbcdocu.Libre_c01 AND  /* O/D */
    B-CDOCU.Libre_c02 = Ccbcdocu.Libre_c02 AND
    B-CDOCU.FlgEst <> 'A' BY B-CDOCU.NroDoc:
    x-Cuenta = x-Cuenta + 1.
    IF B-CDOCU.NroDoc = Ccbcdocu.NroDoc THEN LEAVE.
END.
IF x-Cuenta > 1 THEN x-Bultos = 0.

/* Peso */
FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK, FIRST Almmmatg OF Ccbddocu NO-LOCK:
    x-Peso = x-Peso + (Ccbddocu.candes * Ccbddocu.factor * Almmmatg.pesmat).
END.

/* ***************************************************************************** */
/* 11/09/2020 Nro TOPAZ */
/* Solo para MI BANCO y BCP */
/* ***************************************************************************** */
IF LOOKUP(Ccbcdocu.CodCli, '20382036655,20100047218') > 0 THEN DO:
    FIND PEDIDO WHERE PEDIDO.codcia = Ccbcdocu.codcia
        AND PEDIDO.coddoc = Ccbcdocu.codped
        AND PEDIDO.nroped = Ccbcdocu.nroped
        NO-LOCK NO-ERROR.
    IF AVAILABLE PEDIDO THEN DO:
        FIND COTIZACION WHERE COTIZACION.codcia = PEDIDO.codcia
            AND COTIZACION.coddoc = PEDIDO.codref
            AND COTIZACION.nroped = PEDIDO.nroref
            NO-LOCK NO-ERROR.
        IF AVAILABLE COTIZACION THEN DO:
            IF COTIZACION.CodCli = '20382036655' THEN x-Grupo-Topaz = 'Grupo/Topaz: ' + COTIZACION.OfficeCustomer.
            IF COTIZACION.CodCli = '20100047218' THEN x-Grupo-Topaz = 'Grupo/Topaz: ' + COTIZACION.InvoiceCustomerGroup.
        END.
    END.
END.
/* ***************************************************************************** */
ASSIGN
    x-CodVen = Ccbcdocu.codven
    x-FchDoc = Ccbcdocu.FchDoc.
CASE pFormato:
    WHEN 1 THEN DO:
        x-NroDoc = STRING(ccbcdocu.nrodoc, "XXX-XXXXXXXX").
        x-NroPed = STRING(ccbcdocu.libre_c01, "X(3)") + " " + STRING(ccbcdocu.libre_c02, "XXX-XXXXXXXX").
        x-NroRef = Ccbcdocu.NroRef.
    END.
    WHEN 2 THEN DO:
        x-TitDoc = "O/DESPACHO # ".
        x-NroDoc = CcbCDocu.NroPed.
        x-NroPed = "( " + CcbCDocu.CodRef + " " + STRING(CcbCDocu.NroRef, "XXX-XXXXXXXXX") + " " +
            STRING(X-FchRef) + " )".
        x-CodRef = "G/R".
        x-NroRef = Ccbcdocu.NroDoc.
    END.
END CASE.

/* ***************************************************************************** */
/* Valores del Detalle */
/* ***************************************************************************** */
EMPTY TEMP-TABLE Detalle.
DEF VAR x-Item AS INTE INIT 1 NO-UNDO.
FOR EACH Ccbddocu  OF Ccbcdocu NO-LOCK, 
    FIRST almmmatg OF ccbddocu NO-LOCK,
    FIRST Almtfami OF Almmmatg NO-LOCK WHERE Almtfami.Libre_c01 <> "SV"
    BY ccbddocu.nroitm:
    CREATE Detalle.
    ASSIGN
        Detalle.CodAlm = Ccbcdocu.CodAlm
        Detalle.NroItm = x-Item.
    CASE pFormato:
        WHEN 1 THEN Detalle.CodMat = Almmmatg.CodMat.
        WHEN 2 THEN Detalle.CodMat = Almmmatg.CodBrr.
    END CASE.
    ASSIGN
        Detalle.DesMat = Almmmatg.DesMat
        Detalle.DesMar = Almmmatg.DesMar
        Detalle.CanDes = Ccbddocu.CanDes
        Detalle.UndVta = Ccbddocu.UndVta.
    x-Item = x-Item + 1.
END.

ASSIGN
    ftr-Valor1 = x-Bultos
    ftr-Valor2 = x-Peso.

CASE TRUE:
    WHEN X-TRANS > '' AND X-LUGAR > '' THEN DO:
        ASSIGN
            ftr-Glosa1 = "LA MERCADERIA VIAJA POR CUENTA Y RIESGO DEL CLIENTE, EL DESPACHO DE MERCADERIA ABARCA HASTA LA AGENCIA DE TRANSPORTE"
            ftr-Glosa2 = x-Grupo-Topaz
            ftr-Glosa3 = 'Contacto : ' + STRING(X-CONTC,'X(25)') + 'Hora Aten :' + STRING(X-HORA,'X(10)')
            ftr-Glosa4 = 'PRIMER TRAMO  : '
            ftr-Glosa5 = 'Transport: ' + STRING(X-NomTra,'X(50)')
            ftr-Glosa6 = 'RUC      : ' + STRING(X-RucTra,'X(11)') + 'Dirección: ' + STRING(X-DIREC,'X(50)')
            ftr-Glosa7 = 'SEGUNDO TRAMO  : '
            ftr-Glosa8 = 'Destino  : ' + STRING(X-LUGAR,'X(50)')
            ftr-Glosa9 = 'Observ   : ' + STRING(CcbCDocu.Glosa,"X(60)").
    END.
    WHEN X-TRANS > '' AND TRUE <> (X-LUGAR > '') THEN DO:
        ASSIGN
            ftr-Glosa1 = "LA MERCADERIA VIAJA POR CUENTA Y RIESGO DEL CLIENTE, EL DESPACHO DE MERCADERIA ABARCA HASTA LA AGENCIA DE TRANSPORTE"
            ftr-Glosa2 = x-Grupo-Topaz
            ftr-Glosa3 = ''
            ftr-Glosa4 = 'PRIMER TRAMO  : '
            ftr-Glosa5 = 'Transport: ' + STRING(X-NomTra,'X(50)')
            ftr-Glosa6 = 'RUC      : ' + STRING(X-RucTra,'X(11)')
            ftr-Glosa7 = 'Dirección: ' + STRING(X-DIREC,'X(50)')
            ftr-Glosa8 = ''
            ftr-Glosa9 = ''.
    END.
    WHEN TRUE <> (X-TRANS > '') AND X-LUGAR > '' THEN DO:
        ASSIGN
            ftr-Glosa1 = "LA MERCADERIA VIAJA POR CUENTA Y RIESGO DEL CLIENTE, EL DESPACHO DE MERCADERIA ABARCA HASTA LA AGENCIA DE TRANSPORTE"
            ftr-Glosa2 = x-Grupo-Topaz
            ftr-Glosa3 = ''
            ftr-Glosa4 = ''
            ftr-Glosa5 = ''
            ftr-Glosa6 = 'SEGUNDO TRAMO  : '
            ftr-Glosa7 = 'Destino  : ' + STRING(X-LUGAR,'X(50)')
            ftr-Glosa8 = 'Observ   : ' + STRING(CcbCDocu.Glosa,"X(60)")
            ftr-Glosa9 = 'Contacto : ' + STRING(X-CONTC,'X(25)') + 'Hora Aten :' + STRING(X-HORA,'X(10)').
    END.
    OTHERWISE DO:
        ASSIGN
            ftr-Glosa1 = "LA MERCADERIA VIAJA POR CUENTA Y RIESGO DEL CLIENTE, EL DESPACHO DE MERCADERIA ABARCA HASTA LA AGENCIA DE TRANSPORTE"
            ftr-Glosa2 = x-Grupo-Topaz.
    END.
END CASE.

END PROCEDURE.

/*
DEF VAR ftr-Glosa1 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa2 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa3 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa4 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa5 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa6 AS CHAR NO-UNDO.
DEF VAR ftr-Valor1 AS DECI NO-UNDO.
DEF VAR ftr-Valor2 AS DECI NO-UNDO.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Carga-TRF) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-TRF Procedure 
PROCEDURE Carga-TRF :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* ***************************************************************************** */
/* Valores de cabecera */
/* ***************************************************************************** */
FIND Almacen WHERE Almacen.CodCia = Almcmov.CodCia 
              AND  Almacen.CodAlm = Almcmov.CodAlm 
             NO-LOCK NO-ERROR.
IF AVAILABLE Almacen THEN x-PuntoPartida = Almacen.DirAlm.
/* Almacen DESTINO */
FIND b-Almacen WHERE b-Almacen.CodCia = Almcmov.CodCia 
    AND  b-Almacen.CodAlm = Almcmov.AlmDes
    NO-LOCK NO-ERROR.
IF AVAILABLE b-Almacen THEN x-PuntoLlegada = b-Almacen.DirAlm.

ASSIGN
    x-Nombre       = b-Almacen.Descripcion
    x-Ruc          = b-Almacen.CodCli
    x-CodCli       = ''.
/* Transportista */
DEF VAR lNroDoc AS CHAR NO-UNDO.
FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND 
    faccpedi.coddoc = almcmov.codref AND 
    faccpedi.nroped = almcmov.nroref NO-LOCK NO-ERROR.
IF AVAILABLE faccpedi THEN DO:
    lNroDoc = STRING(almcmov.nroser,"999") + STRING(almcmov.nrodoc,"999999").
    /* Datos del transportista */
    FIND Ccbadocu WHERE Ccbadocu.codcia = s-codcia
        AND Ccbadocu.coddiv = faccpedi.coddiv
        AND Ccbadocu.coddoc = 'G/R'
        AND Ccbadocu.nrodoc = lNroDoc
        NO-LOCK NO-ERROR.
    IF AVAILABLE Ccbadocu THEN DO:
        f-NomTra = CcbADocu.Libre_C[4].
        f-RucAge = CcbADocu.Libre_C[5].
        f-Marca = CcbADocu.Libre_C[2].
        f-NroLicencia = CcbADocu.Libre_C[6].
        f-Placa = CcbADocu.Libre_C[1].
        IF CcbADocu.Libre_C[18] > '' THEN f-Placa = CcbADocu.Libre_C[1] + " / " + CcbADocu.Libre_C[18].
        f-Certificado = CcbADocu.Libre_C[17].
        x-Inicio-Traslado = STRING(CcbADocu.Libre_F[1],"99/99/9999").
    END.
END.
/* Ic - 11Set2018, correo de Max Ramos */
DEFINE VAR x-origen-crossdocking AS LOG.
x-NroDoc = almcmov.codref.
x-NroPed = almcmov.nroref.
x-origen-crossdocking = NO.
DEFINE BUFFER y-faccpedi FOR faccpedi.
FIND FIRST y-faccpedi WHERE y-faccpedi.codcia = s-codcia AND 
    y-faccpedi.coddoc = x-NroDoc AND 
    y-faccpedi.nroped = x-NroPed NO-LOCK NO-ERROR.
IF AVAILABLE y-faccpedi THEN DO:
    IF Almcmov.crossdocking = YES THEN DO:
        /* Crossdocking primer salida */
        x-NroDoc = y-faccpedi.codref.
        x-NroPed = y-faccpedi.nroref + " (" + almcmov.codref + " " + almcmov.nroref + ")".
    END.
    ELSE DO:
        /* Verificar si es crossdocking 2da salida */
        IF y-faccpedi.crossdocking = NO AND y-faccpedi.tpoped = 'XD' THEN DO:
            x-NroDoc = y-faccpedi.codref.
            x-NroPed = y-faccpedi.nroref + " (" + almcmov.codref + " " + almcmov.nroref + ")".
            x-origen-crossdocking = YES.
        END.
    END.
END.
/* ***************************************************************************** */
ASSIGN
    x-CodRef = "G/R"
    x-NroRef = STRING(Almcmov.NroSer,"999") + STRING(Almcmov.NroDoc,"999999")
    x-FchDoc = Almcmov.FchDoc.
/* Bultos de la OTR */
RUN logis/p-numero-de-bultos (INPUT s-CodDiv,
                              INPUT Almcmov.CodRef,
                              INPUT Almcmov.NroRef,
                              OUTPUT x-Bultos).
/* Ic - 28Feb2018, si es OTR que salga solo en la primera G/R de la OTR */
IF Almcmov.codref = 'OTR' THEN DO:
    DEFINE BUFFER x-almcmov FOR almcmov.
    DEFINE VAR x-nrodoc AS INT64.

    x-nrodoc = 9999999999.
    FOR EACH x-almcmov WHERE x-almcmov.codcia = s-codcia AND 
        x-almcmov.codref = almcmov.codref AND 
        x-almcmov.nroref = almcmov.nroref AND
        x-almcmov.flgest <> 'A'
        NO-LOCK :
        IF x-almcmov.nrodoc < x-nrodoc THEN x-nrodoc = x-almcmov.nrodoc.
    END.
    IF x-nrodoc <> 9999999999 THEN DO:
        IF x-nrodoc <> almcmov.nrodoc THEN x-bultos = 0.
    END.
END.

/* ***************************************************************************** */
/* Valores del Detalle */
/* ***************************************************************************** */
EMPTY TEMP-TABLE Detalle.
DEF VAR x-Item AS INTE INIT 1 NO-UNDO.
FOR EACH Almdmov OF Almcmov NO-LOCK , 
    FIRST almmmatg OF Almdmov NO-LOCK
    BREAK BY Almdmov.nrodoc BY Almdmov.NroItm BY Almdmov.codmat:
    CREATE Detalle.
    ASSIGN
        Detalle.NroItm = x-Item.
    FIND FIRST almmmate WHERE almmmate.codcia = almcmov.codcia
        AND almmmate.codalm = almdmov.codalm
        AND almmmate.codmat = almdmov.codmat NO-LOCK NO-ERROR.
    IF AVAILABLE almmmate THEN Detalle.CodAlm = almmmate.codubi.
    CASE pFormato:
        WHEN 1 THEN Detalle.CodMat = Almmmatg.CodMat.
        WHEN 2 THEN Detalle.CodMat = Almmmatg.CodBrr.
    END CASE.
    ASSIGN
        Detalle.DesMat = Almmmatg.DesMat
        Detalle.DesMar = Almmmatg.DesMar
        Detalle.CanDes = Almdmov.CanDes
        Detalle.UndVta = Almdmov.CodUnd.
    x-Item = x-Item + 1.
    x-Peso = x-Peso + (Almdmov.CanDes * Almdmov.Factor * Almmmatg.PesMat).
END.

ASSIGN
    ftr-Valor1 = x-Bultos
    ftr-Valor2 = x-Peso.

/* Cross Docking */
DEF VAR x-CrossDocking AS CHAR NO-UNDO.
DEF VAR x-AlmDesp AS CHAR NO-UNDO.
DEF VAR x-AlmInt AS CHAR NO-UNDO.
DEF VAR x-AlmDest AS CHAR NO-UNDO.
DEF VAR x-AlmFiler AS CHAR NO-UNDO.
DEFINE BUFFER y-ALMACEN FOR Almacen.

IF Almcmov.CrossDocking = YES THEN DO:
    x-CrossDocking = "CROSS-DOCKING".
    x-AlmFiler = x-AlmInt.
    x-AlmInt = x-AlmDest.
    /* RHC 21/05/2018 */
    x-AlmDest = x-AlmFiler.
END.    
ELSE DO:
    IF x-origen-crossdocking = YES THEN DO:        
        x-CrossDocking = "CROSS-DOCKING".
        x-AlmInt = x-AlmDesp.
        x-AlmDesp = "".
        /* Buscar el almacen de despacho de origen */ 
        FIND FIRST y-faccpedi WHERE y-faccpedi.codcia = s-codcia AND 
                                    y-faccpedi.codref = x-codref AND 
                                    y-faccpedi.nroref = x-nroref AND
                                    y-faccpedi.tpoped <> "XD" NO-LOCK NO-ERROR.
        IF AVAILABLE y-faccpedi THEN DO:
            FIND y-Almacen WHERE y-Almacen.CodCia = Almcmov.CodCia 
                AND  y-Almacen.CodAlm = y-faccpedi.codalm NO-LOCK NO-ERROR.
            IF AVAILABLE y-Almacen THEN x-AlmDesp = TRIM(y-faccpedi.codalm) + " " + TRIM(y-almacen.descripcion).
        END.
    END.
END.

ASSIGN
    ftr-Glosa5 = x-CrossDocking
    ftr-Glosa6 = 'Glosa   : ' + Almcmov.Observ.

END PROCEDURE.

/*
DEF VAR ftr-Glosa1 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa2 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa3 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa4 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa5 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa6 AS CHAR NO-UNDO.
DEF VAR ftr-Valor1 AS DECI NO-UNDO.
DEF VAR ftr-Valor2 AS DECI NO-UNDO.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Impresion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Impresion Procedure 
PROCEDURE Impresion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

OUTPUT TO PRINTER PAGE-SIZE 43.
PUT CONTROL {&PRN0} + {&PRN5A} + CHR(48) + {&PRN3}.     
/* RHC 28/04/2020 NO imprimir FLETE (fam. 100 catcont SV ) */
FOR EACH Detalle NO-LOCK BREAK BY Detalle.codcia BY Detalle.nroitm:
    VIEW FRAME F-HdrGui.
    IF X-TRANS <> '' AND  X-LUGAR <> '' THEN VIEW FRAME F-FtrGui.
    IF X-TRANS <> '' AND X-LUGAR = '' THEN VIEW FRAME F-FtrGui3.
    IF X-TRANS = '' AND X-LUGAR <> '' THEN VIEW FRAME F-FtrGui4.
    IF X-TRANS = '' AND X-LUGAR = '' THEN VIEW FRAME F-FtrGui2.
    DISPLAY 
        Detalle.codalm
        Detalle.NroItm 
        Detalle.codmat
        Detalle.desmat 
        Detalle.desmar
        Detalle.candes 
        Detalle.undvta 
        WITH FRAME F-DetaGui.
    IF LAST-OF(Detalle.codcia) THEN PAGE.
END.
OUTPUT CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

