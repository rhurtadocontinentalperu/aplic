&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDOCU FOR CcbCDocu.
DEFINE BUFFER B-DOCU FOR CcbCDocu.
DEFINE BUFFER COTIZACION FOR FacCPedi.
DEFINE BUFFER PEDIDO FOR FacCPedi.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : r-impgui.p
    Purpose     : Impresion de Guias

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE INPUT PARAMETER X-ROWID AS ROWID.
DEFINE INPUT PARAMETER pTipo AS INT.

/* pTipo = 1 NORMAL 
   pTipo = 2 EAN 
   */
IF NOT (pTipo = 1 OR pTipo = 2) THEN RETURN.

DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR CL-codcia  AS INT.
DEF SHARED VAR PV-codcia  AS INT.
DEF SHARED VAR s-coddiv  LIKE gn-divi.coddiv.
DEF SHARED VAR s-codter  LIKE ccbcterm.codter.
DEF SHARED VAR s-user-id LIKE ccbcterm.codter.
DEF SHARED VAR X-NUMORD  AS CHAR.
DEF SHARED VAR X-obser  AS CHAR format "x(80)".

DEF VAR X-EnLetras AS CHAR FORMAT "x(100)" NO-UNDO.
DEF VAR I-NroItm AS INTEGER.
DEF VAR S-TOTPES AS DECIMAL.
DEF VAR X-senal  AS CHAR.
DEF VAR X-LugPar LIKE Almacen.DirAlm.
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
/* ************************************** */
DEFINE SHARED VARIABLE X-CTRANS  AS CHAR. 
DEFINE SHARED VARIABLE X-RTRANS  AS CHAR. 
DEFINE SHARED VARIABLE X-DTRANS  AS CHAR. 

DEFINE VAR dPesTot AS DEC NO-UNDO.

FIND ccbcdocu WHERE ROWID(ccbcdocu) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbcdocu THEN RETURN.

FIND gn-clie WHERE gn-clie.codcia = CL-CODCIA 
    AND gn-clie.codcli = ccbcdocu.codcli 
    NO-LOCK NO-ERROR.
    
/************************  PUNTEROS EN POSICION  *******************************/
RUN bin/_numero(ccbcdocu.imptot, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = X-EnLetras + (IF ccbcdocu.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").

/************************  DEFINICION DE FRAMES  *******************************/

DEF VAR x-PuntoPartida AS CHAR NO-UNDO.
DEF VAR x-PuntoLlegada AS CHAR NO-UNDO.
DEF VAR x-Nombre       AS CHAR NO-UNDO.
DEF VAR x-NomTra       AS CHAR NO-UNDO.
DEF VAR x-Ruc          AS CHAR NO-UNDO.
DEF VAR x-RucTra       AS CHAR NO-UNDO.
DEF VAR x-CodCli       AS CHAR NO-UNDO.

RUN Carga-Variables.

/* 11/09/2020 Nro TOPAZ */
/* Solo para MI BANCO y BCP */
DEF VAR x-Grupo-Topaz AS CHAR FORMAT 'x(35)' NO-UNDO.
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

DEFINE FRAME F-FtrGui
    HEADER
    "LA MERCADERIA VIAJA POR CUENTA Y RIESGO DEL CLIENTE, EL DESPACHO DE MERCADERIA ABARCA HASTA LA AGENCIA DE TRANSPORTE" SKIP(1)
    x-Grupo-Topaz
    x-Bultos AT 50 FORMAT '>>,>>>' x-Peso AT 60 FORMAT '>>>,>>>.99' SKIP
    'Contacto : ' X-CONTC FORMAT 'X(25)' 'Hora Aten :' X-HORA FORMAT 'X(10)'SKIP
    'PRIMER TRAMO  : '     SKIP
    'Transport: ' X-NomTra FORMAT 'X(50)' SKIP
    'RUC      : ' X-RucTra    FORMAT 'X(11)' /*dPesTot AT 58 SKIP*/
    'Dirección: ' X-DIREC  FORMAT 'X(50)' SKIP
    'SEGUNDO TRAMO  : '    SKIP
    'Destino  : ' X-LUGAR  FORMAT 'X(50)' SKIP
    'Observ   : ' CcbCDocu.Glosa VIEW-AS TEXT FORMAT "X(60)" 
    ' ' AT 75 SKIP
    WITH PAGE-BOTTOM NO-LABELS NO-UNDERLINE NO-BOX STREAM-IO WIDTH 200.

DEFINE FRAME F-FtrGui2
    HEADER
    "LA MERCADERIA VIAJA POR CUENTA Y RIESGO DEL CLIENTE, EL DESPACHO DE MERCADERIA ABARCA HASTA LA AGENCIA DE TRANSPORTE" skip(1)
    x-Grupo-Topaz
    x-Bultos AT 50 FORMAT '>>,>>>' x-Peso AT 60 FORMAT '>>>,>>>.99' SKIP(4)
    WITH PAGE-BOTTOM NO-LABELS NO-UNDERLINE NO-BOX STREAM-IO WIDTH 200.

DEFINE FRAME F-FtrGui3
    HEADER
    "LA MERCADERIA VIAJA POR CUENTA Y RIESGO DEL CLIENTE, EL DESPACHO DE MERCADERIA ABARCA HASTA LA AGENCIA DE TRANSPORTE" skip(1)
    x-Grupo-Topaz
    x-Bultos AT 50 FORMAT '>>,>>>' x-Peso AT 60 FORMAT '>>>,>>>.99' SKIP
    'PRIMER TRAMO  : '     SKIP
    'Transport: ' X-NomTra FORMAT 'X(50)' SKIP
    'RUC      : ' X-RucTra    FORMAT 'X(11)' SKIP
    'Dirección: ' X-DIREC  FORMAT 'X(50)' SKIP
    WITH PAGE-BOTTOM NO-LABELS NO-UNDERLINE NO-BOX STREAM-IO WIDTH 200.

DEFINE FRAME F-FtrGui4
    HEADER
    "LA MERCADERIA VIAJA POR CUENTA Y RIESGO DEL CLIENTE, EL DESPACHO DE MERCADERIA ABARCA HASTA LA AGENCIA DE TRANSPORTE" skip(1)  
    x-Grupo-Topaz
    x-Bultos AT 50 FORMAT '>>,>>>' x-Peso AT 60 FORMAT '>>>,>>>.99' SKIP
    'SEGUNDO TRAMO  : '    SKIP
    'Destino  : ' X-LUGAR  FORMAT 'X(50)' SKIP
    'Observ   : ' CcbCDocu.Glosa VIEW-AS TEXT FORMAT "X(60)" SKIP
    'Contacto : ' X-CONTC FORMAT 'X(25)' 'Hora Aten :' X-HORA FORMAT 'X(10)'SKIP
    WITH PAGE-BOTTOM NO-LABELS NO-UNDERLINE NO-BOX STREAM-IO WIDTH 200.

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
         HEIGHT             = 6
         WIDTH              = 53.29.
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
DEFINE VAR pStatus AS LOG NO-UNDO.
SYSTEM-DIALOG PRINTER-SETUP UPDATE pStatus.
IF pStatus = NO THEN RETURN.


/* Ic - 28Ene2016, para valesUtilex*/
/* Busco la cotizacion */
DEFINE VAR cEsValeUtilex AS LOG INIT NO.
DEFINE VAR cNroVales AS CHAR.

DEFINE BUFFER b-faccpedi FOR faccpedi.
DEFINE BUFFER c-faccpedi FOR faccpedi.

FIND FIRST b-faccpedi WHERE b-faccpedi.codcia = s-codcia AND
    b-faccpedi.coddoc = 'PED' AND
    b-faccpedi.nroped = ccbcdocu.nroped NO-LOCK NO-ERROR.
IF AVAILABLE b-faccpedi THEN DO:
    FIND FIRST c-faccpedi WHERE c-faccpedi.codcia = s-codcia AND
        c-faccpedi.coddoc = 'COT' AND
        c-faccpedi.nroped = b-faccpedi.nroref NO-LOCK NO-ERROR.
    IF AVAILABLE c-faccpedi THEN DO:
        IF c-faccpedi.tpoped = 'VU' THEN cEsValeUtilex = YES.
    END.
END.

CASE pTipo:
    WHEN 1 THEN RUN Formato-Normal.
    WHEN 2 THEN RUN Formato-Ean.
END CASE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Carga-Variables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Variables Procedure 
PROCEDURE Carga-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN
    x-PuntoLlegada = Ccbcdocu.lugent    /* Sede del cliente o del transportista */
    x-Nombre       = Ccbcdocu.nomcli
    x-Ruc          = Ccbcdocu.ruccli
    x-CodCli       = Ccbcdocu.codcli.
/* Buscamos Agencia de Transporte */
IF CcbCDocu.CodAge > '' THEN DO:
    FIND FIRST gn-prov WHERE gn-prov.CodCia = pv-codcia AND
        gn-prov.CodPro = CcbCDocu.CodAge NO-LOCK NO-ERROR.
    IF AVAILABLE gn-prov THEN
        ASSIGN
        x-PuntoLlegada = Ccbcdocu.LugEnt2
        .
END.
/* RHC 16/06/2019 Lugar de entrega (* O/D)*/
RUN logis/p-lugar-de-entrega (Ccbcdocu.Libre_c01, Ccbcdocu.Libre_c02, OUTPUT x-PuntoLlegada).
IF NUM-ENTRIES(x-PuntoLlegada,'|') >= 2 THEN x-PuntoLlegada = TRIM(ENTRY(2, x-PuntoLlegada, '|')).
/* Parche por compatibilidad */
IF TRUE <> (x-PuntoLlegada > '') THEN x-PuntoLlegada = Ccbcdocu.DirCli.
/* ************************* */

ASSIGN
    X-senal  = "X".

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
FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK,
    FIRST Almmmatg OF Ccbddocu NO-LOCK:
    x-Peso = x-Peso + (Ccbddocu.candes * Ccbddocu.factor * Almmmatg.pesmat).

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Formato-Ean) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-Ean Procedure 
PROCEDURE Formato-Ean :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE FRAME F-HdrGui-Ean
    HEADER
    SKIP(6.75)
    x-PuntoPartida  AT 12 FORMAT 'x(100)' SKIP
    x-PuntoLlegada  AT 12 FORMAT "X(100)" SKIP
    x-Nombre        AT 12 FORMAT "X(70)" SKIP
    x-Ruc           AT 12 FORMAT "X(11)" 
    x-CodCli        AT 12 FORMAT "X(11)" 
    f-NomTra        AT 90 FORMAT "X(40)" SKIP
    "O/DESPACHO # "     AT 17 CcbCDocu.NroPed 
    "( " AT 50 CcbCDocu.CodRef CcbCDocu.NroRef FORMAT "XXX-XXXXXXXXX" X-FchRef  " )"
    f-RucAge        AT 87 FORMAT "X(11)" 
    f-Marca         AT 120 SKIP
    f-NroLicencia   AT 90 FORMAT 'x(15)'
    f-Placa         AT 115 SKIP(1)
    /*x-Senal         AT 1 FORMAT 'x' */
    f-Certificado   AT 95 f-Certificado FORMAT 'x(30)' SKIP(1)
    CcbCDocu.CodVen AT 85 FORMAT "X(3)"
    "G/R "          AT 91 
    ccbcdocu.nrodoc AT 95 FORMAT "XXX-XXXXXX"
    ccbcdocu.fchdoc AT 119
    SKIP(1) 
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 200.

DEFINE FRAME F-DetaGui-Ean
    ccbcdocu.codalm  AT 01 FORMAT "99"
    I-NroItm         AT 04 FORMAT "Z9"
    /*ccbddocu.codmat  AT 10 FORMAT "999999"*/
    almmmatg.codbrr  AT 11 FORMAT 'x(15)'
    almmmatg.desmat  AT 27 FORMAT "X(40)"
    almmmatg.desmar  AT 96 FORMAT "X(10)"
    ccbddocu.candes  AT 108 FORMAT ">>>,>>9.99"
    ccbddocu.UndVta  AT 119 FORMAT "X(8)"
    WITH NO-LABELS NO-BOX NO-UNDERLINE STREAM-IO WIDTH 200.

OUTPUT TO PRINTER PAGE-SIZE 43.
PUT CONTROL {&PRN0} + {&PRN5A} + CHR(48) + {&PRN3}.     

/*Peso Totales*/
ASSIGN
    dPesTot = 0
    I-NroItm = 0.
/* RHC 28/04/2020 NO imprimir FLETE (fam. 100 catcont SV ) */
FOR EACH Ccbddocu  OF Ccbcdocu NO-LOCK, 
    FIRST almmmatg OF ccbddocu NO-LOCK,
    FIRST Almtfami OF Almmmatg NO-LOCK WHERE Almtfami.Libre_c01 <> "SV"
    BREAK BY ccbddocu.nrodoc BY ccbddocu.nroitm:
    VIEW FRAME F-HdrGui-Ean.
    dPesTot = dPesTot + CcbDDocu.pesmat.
    IF X-TRANS <> '' AND  X-LUGAR <> '' THEN VIEW FRAME F-FtrGui.
    IF X-TRANS <> '' AND X-LUGAR = '' THEN VIEW FRAME F-FtrGui3.
    IF X-TRANS = '' AND X-LUGAR <> '' THEN VIEW FRAME F-FtrGui4.
    IF X-TRANS = '' AND X-LUGAR = '' THEN VIEW FRAME F-FtrGui2.
    I-NroItm = I-NroItm + 1.     

        DISPLAY ccbcdocu.codalm
                I-NroItm 
                /*ccbddocu.codmat */
                almmmatg.codbrr
                almmmatg.desmat 
                almmmatg.desmar
                ccbddocu.candes 
                ccbddocu.undvta 
                WITH FRAME F-DetaGui-Ean.
    IF LAST-OF(ccbddocu.nrodoc) THEN PAGE.
END.
OUTPUT CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Formato-Normal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-Normal Procedure 
PROCEDURE Formato-Normal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE FRAME F-HdrGui
    HEADER
    SKIP(6.75)
    x-PuntoPartida  AT 12 FORMAT 'x(100)' SKIP
    x-PuntoLlegada  AT 12 FORMAT "X(100)" SKIP
    x-Nombre        AT 12 FORMAT "X(70)" SKIP
    x-Ruc           AT 12 FORMAT "X(11)" 
    x-CodCli        AT 12 FORMAT "X(11)" 
    f-NomTra        AT 90 FORMAT "X(40)" SKIP
    ccbcdocu.nrodoc AT 35 FORMAT "XXX-XXXXXXXX" 
    ccbcdocu.libre_c01 AT 50 FORMAT "X(3)" ccbcdocu.libre_c02 FORMAT "XXX-XXXXXXXX"
    f-RucAge        AT 87 FORMAT "X(11)" 
    f-Marca         AT 120 SKIP
    f-NroLicencia   AT 90 FORMAT 'x(15)'
    f-Placa         AT 115 SKIP(1)
    /*x-Senal         AT 1 FORMAT 'x' */
    f-Certificado   AT 95 f-Certificado FORMAT 'x(30)' SKIP(1)
    CcbCDocu.CodVen AT 85 FORMAT "X(3)"
    CcbCDocu.NroRef AT 99 FORMAT "XXX-XXXXXXXX" 
    ccbcdocu.fchdoc AT 119
    SKIP(1) 
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 200.

DEFINE FRAME F-DetaGui
    ccbcdocu.codalm  AT 01 FORMAT "99"
    I-NroItm         AT 04 FORMAT "Z9"
    ccbddocu.codmat  AT 11 FORMAT "999999"
    almmmatg.desmat  AT 27 FORMAT "X(40)"
    almmmatg.desmar  AT 98 FORMAT "X(10)"
    ccbddocu.candes  AT 108 FORMAT ">>,>>9.99"
    ccbddocu.UndVta  AT 119 FORMAT "X(8)"
    WITH NO-LABELS NO-BOX NO-UNDERLINE STREAM-IO WIDTH 200.

OUTPUT TO PRINTER PAGE-SIZE 43.
PUT CONTROL {&PRN0} + {&PRN5A} + CHR(48) + {&PRN3}.     
/*Peso Totales*/
ASSIGN
    dPesTot = 0
    I-NroItm = 0.
/* RHC 28/04/2020 NO imprimir FLETE (fam. 100 catcont SV ) */
DETALLE:
FOR EACH Ccbddocu  OF Ccbcdocu NO-LOCK, 
    FIRST almmmatg OF ccbddocu NO-LOCK,
    FIRST Almtfami OF Almmmatg NO-LOCK WHERE Almtfami.Libre_c01 <> "SV"
    BREAK BY ccbddocu.nrodoc BY ccbddocu.nroitm:
    VIEW FRAME F-HdrGui.
    dPesTot = dPesTot + CcbDDocu.pesmat.
    IF X-TRANS <> '' AND  X-LUGAR <> '' THEN VIEW FRAME F-FtrGui.
    IF X-TRANS <> '' AND X-LUGAR = '' THEN VIEW FRAME F-FtrGui3.
    IF X-TRANS = '' AND X-LUGAR <> '' THEN VIEW FRAME F-FtrGui4.
    IF X-TRANS = '' AND X-LUGAR = '' THEN VIEW FRAME F-FtrGui2.
    I-NroItm = I-NroItm + 1.     

    /* Ic - 28Ene2016 ValesUtiles */
    cNroVales = ''.
    IF cEsValeUtilex = YES THEN DO:
        cNroVales = "  (del " + STRING(ccbddocu.impdcto_adelanto[1],">>>>>>>>>9") + 
                    "  al " + STRING(ccbddocu.impdcto_adelanto[2],">>>>>>>>>9") + ")".
    END.

    DISPLAY 
        ccbcdocu.codalm
        I-NroItm 
        ccbddocu.codmat 
        almmmatg.desmat + ' ' + cNroVales @ almmmatg.desmat
        almmmatg.desmar
        ccbddocu.candes 
        ccbddocu.undvta 
        WITH FRAME F-DetaGui.
    IF LAST-OF(ccbddocu.nrodoc) THEN PAGE.
END.
OUTPUT CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

