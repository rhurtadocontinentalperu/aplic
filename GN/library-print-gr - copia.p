&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDOCU FOR CcbCDocu.
DEFINE BUFFER COTIZACION FOR FacCPedi.
DEFINE BUFFER fai_ccbcdocu FOR CcbCDocu.
DEFINE BUFFER fai_ccbddocu FOR CcbDDocu.
DEFINE BUFFER ORDENES FOR FacCPedi.
DEFINE BUFFER PEDIDO FOR FacCPedi.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description : Libreria general para la impresión de GR

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Solicitamos tipo de impresión */
DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR pv-codcia AS INTE.
DEF SHARED VAR cl-codcia AS INTE.
DEF SHARED VAR s-coddiv AS CHAR.

DEFINE VAR x-codcli-usa-agrupador AS CHAR.

x-codcli-usa-agrupador = "20100047218".     /* BCP */

/* Definimos Detalle de Impresión */
DEF TEMP-TABLE Detalle
    FIELD codcia AS INTE
    FIELD codalm AS CHAR FORMAT 'x(6)'
    FIELD nroitm AS INTE FORMAT '>>9'
    FIELD codmat AS CHAR FORMAT 'x(15)'
    FIELD desmat AS CHAR FORMAT 'x(70)'
    FIELD desmar AS CHAR FORMAT 'x(10)'
    FIELD candes AS DECI FORMAT '>>,>>9.99'
    FIELD undvta AS CHAR FORMAT 'x(8)'
    FIELD peso AS DECI FORMAT '>,>>>,>>9.9999' INIT ""
    FIELD codmat_cli AS CHAR FORMAT 'x(15)' INIT ""
    FIELD desmat_cli AS CHAR FORMAT 'x(70)' INIT ""
    INDEX idx00 AS PRIMARY nroitm.

DEF VAR  x-PuntoPartida AS CHAR NO-UNDO.
DEF VAR  x-PuntoLlegada AS CHAR NO-UNDO.
DEF VAR  x-PuntoLlegada2 AS CHAR NO-UNDO.
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

DEF VAR x-OD AS CHAR FORMAT 'x(15)' NO-UNDO.
DEF VAR x-OC AS CHAR FORMAT 'x(20)' NO-UNDO.
DEF VAR x-FmaPgo AS CHAR FORMAT 'x(5)' NO-UNDO.

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
DEF VAR x-Volumen   AS DEC NO-UNDO.

DEFINE VAR x-imprime-bcp AS CHAR.

/* RHC 20/07/2015 DATOS DEL TRANSPORTISTA */
DEF VAR f-CodAge AS CHAR NO-UNDO.
DEF VAR f-NomTra AS CHAR NO-UNDO.
DEF VAR f-RucAge AS CHAR NO-UNDO.
DEF VAR f-Marca  AS CHAR NO-UNDO.
DEF VAR f-Chofer AS CHAR NO-UNDO.
DEF VAR f-NroLicencia AS CHAR NO-UNDO.
DEF VAR f-Placa  AS CHAR NO-UNDO.
DEF VAR f-Certificado AS CHAR NO-UNDO.
DEF VAR x-inicio-traslado AS CHAR FORMAT 'x(10)'.

DEF VAR x-NomTra       AS CHAR NO-UNDO.
DEF VAR x-RucTra       AS CHAR NO-UNDO.
DEFINE VAR x-filer AS CHAR INIT "                ".
DEFINE VAR ftr-comprobante AS CHAR INIT "".
DEFINE VAR ftr-venta AS CHAR INIT "".

/* 11/09/2020 Nro TOPAZ */
/* Solo para MI BANCO y BCP */
DEF VAR x-Grupo-Topaz AS CHAR FORMAT 'x(35)' NO-UNDO.

DEFINE TEMP-TABLE tmpArtxProv
    FIELD tcodmat   AS  CHAR    FORMAT 'x(8)'
    FIELD tcodmatbcp    AS  CHAR    FORMAT 'x(25)'
    FIELD tdesmatbcp    AS  CHAR    FORMAT 'x(100)'
    INDEX idx01 tcodmat.

DEF VAR ftr-Valor1 AS DECI NO-UNDO.
DEF VAR ftr-Valor2 AS DECI NO-UNDO.
DEF VAR ftr-Glosa1 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa2 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa3 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa4 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa5 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa6 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa7 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa8 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa9 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa10 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa11 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa12 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa13 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa14 AS CHAR NO-UNDO.


/* Sintaxis 
DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN <libreria> PERSISTENT SET hProc.
RUN <libreria>.rutina_internaIN hProc (input  buffer tt-excel:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .
DELETE PROCEDURE hProc.
*/

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
      TABLE: COTIZACION B "?" ? INTEGRAL FacCPedi
      TABLE: fai_ccbcdocu B "?" ? INTEGRAL CcbCDocu
      TABLE: fai_ccbddocu B "?" ? INTEGRAL CcbDDocu
      TABLE: ORDENES B "?" ? INTEGRAL FacCPedi
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 10.62
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-GRIMP_Carga-Articulos-BCP) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GRIMP_Carga-Articulos-BCP Procedure 
PROCEDURE GRIMP_Carga-Articulos-BCP :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE BUFFER x-faccpedi FOR faccpedi.
DEFINE BUFFER x-facdpedi FOR facdpedi.
DEFINE BUFFER y-facdpedi FOR facdpedi.

EMPTY TEMP-TABLE tmpArtxProv.

DEFINE VAR x-encontro AS LOG.

x-encontro = NO.
/* Las FAIs de la G/R - PLANIFICADOS */
FOR EACH fai_ccbcdocu WHERE fai_ccbcdocu.codcia = s-codcia AND
                            fai_ccbcdocu.codref = ccbcdocu.coddoc AND /* G/R */
                            fai_ccbcdocu.nroref = ccbcdocu.nrodoc AND 
                            fai_ccbcdocu.coddoc = 'FAI' NO-LOCK:
    /* El pedido logistico */
    FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                                x-faccpedi.coddoc = fai_ccbcdocu.codped AND /* PED */
                                x-faccpedi.nroped = fai_ccbcdocu.nroped NO-LOCK NO-ERROR.
    IF AVAILABLE x-faccpedi THEN DO:
        /* detalle de las FAI */
        FOR EACH fai_ccbddocu OF fai_ccbcdocu NO-LOCK:
            FIND FIRST tmpArtxProv WHERE tmpArtxProv.tcodmat = fai_ccbddocu.codmat EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE tmpArtxProv  THEN DO:

                /* Descripcion de articulos del BCP */
                FIND FIRST x-facdpedi WHERE x-facdpedi.codcia = s-codcia AND
                                            x-facdpedi.coddoc = x-faccpedi.codref AND   /* Deberia ser COT */
                                            x-facdpedi.nroped = x-faccpedi.nroref AND
                                            x-facdpedi.codmat = fai_ccbddocu.codmat NO-LOCK NO-ERROR.
                IF AVAILABLE x-facdpedi THEN DO:
                    CREATE tmpArtxProv.
                        ASSIGN tmpArtxProv.tcodmat = fai_ccbddocu.codmat
                                tmpArtxProv.tcodmatbcp = x-facdpedi.customerArtCode
                                tmpArtxProv.tdesmatbcp = x-facdpedi.customerArtDescription.
                    x-encontro = YES.
                END.
            END.
        END.
    END.
END.

IF x-encontro = NO THEN DO:
    /* EXTRAORDINARIOS */
    
    FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                                x-faccpedi.coddoc = ccbcdocu.codped AND /* PED */
                                x-faccpedi.nroped = ccbcdocu.nroped NO-LOCK NO-ERROR.
    IF AVAILABLE x-faccpedi THEN DO:
        FOR EACH y-facdpedi WHERE y-facdpedi.codcia = s-codcia AND 
                            y-facdpedi.coddoc = x-faccpedi.codref AND   /* COT */
                            y-facdpedi.nroped = x-faccpedi.nroref NO-LOCK :

            FIND FIRST tmpArtxProv WHERE tmpArtxProv.tcodmat = fai_ccbddocu.codmat EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE tmpArtxProv  THEN DO:
                CREATE tmpArtxProv.
                    ASSIGN tmpArtxProv.tcodmat = y-facdpedi.codmat
                            tmpArtxProv.tcodmatbcp = y-facdpedi.customerArtCode
                            tmpArtxProv.tdesmatbcp = y-facdpedi.customerArtDescription.
            END.
        END.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GRIMP_Carga-Temporal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GRIMP_Carga-Temporal Procedure 
PROCEDURE GRIMP_Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pFormato AS INTE NO-UNDO.

DEFINE BUFFER B-DOCU FOR CcbCDocu.

/* ***************************************************************************** */
/* Valores de cabecera */
/* ***************************************************************************** */
ASSIGN
    x-PuntoLlegada = TRIM(Ccbcdocu.lugent)    /* Sede del cliente o del transportista */
    x-Nombre       = Ccbcdocu.nomcli
    x-Ruc          = Ccbcdocu.ruccli
    x-CodCli       = Ccbcdocu.codcli
    x-OC           = Ccbcdocu.NroOrd
    x-OD           = Ccbcdocu.Libre_c02
    x-FmaPgo       = Ccbcdocu.FmaPgo
    .
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

IF x-imprime-bcp = "SI" THEN DO:
    /* Caso G/R por grupo de reparto */
    RUN GRIMP_Carga-Articulos-BCP.

    IF LENGTH(x-PuntoLlegada) > 66 THEN DO:
        x-PuntoLlegada2 = SUBSTRING(x-PuntoLlegada,67).
        x-PuntoLlegada = SUBSTRING(x-PuntoLlegada,1,66).
    END.
END.
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
FIND FIRST gn-prov WHERE gn-prov.CodCia = PV-CODCIA
    AND gn-prov.CodPro = X-TRANS
    NO-LOCK NO-ERROR.
IF AVAILABLE gn-prov THEN
     ASSIGN
           X-NomTra = gn-prov.NomPro
           X-RucTra = gn-prov.Ruc.

FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = Ccbcdocu.coddiv
    NO-LOCK NO-ERROR.
IF AVAILABLE gn-divi THEN x-PuntoPartida = TRIM(GN-DIVI.DirDiv) + " " + gn-divi.faxdiv.

FIND FIRST B-DOCU WHERE B-DOCU.CODCIA = ccbcdocu.CodCia 
    AND  B-DOCU.CodDoc = ccbcdocu.CodRef 
    AND  B-DOCU.NroDoc = ccbcdocu.NroRef 
    NO-LOCK NO-ERROR.
IF AVAILABLE B-DOCU THEN X-FchRef = B-DOCU.FchDoc.
ELSE X-FchRef = ?.

/* Grupo de Reparto */
DEFINE VAR hProc AS HANDLE NO-UNDO.             /* Handle Libreria */

RUN logis\logis-librerias.p PERSISTENT SET hProc.

/* Procedimientos */
RUN GR_peso-volumen-bultos IN hProc (INPUT ccbcdocu.coddiv,
                                     INPUT ccbcdocu.coddoc, 
                                     INPUT ccbcdocu.nrodoc, 
                                     OUTPUT x-peso,
                                     OUTPUT x-volumen,
                                     OUTPUT x-bultos).  


DELETE PROCEDURE hProc.                 /* Release Libreria */
/*
/* Los Bultos SOLAMENTE se imprimen en la primera guia */
*/
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
/* ***************************************************************************** */
/* 11/09/2020 Nro TOPAZ */
/* Solo para MI BANCO y BCP */
/* ***************************************************************************** */
IF LOOKUP(Ccbcdocu.CodCli, '20382036655,20100047218') > 0 THEN DO:
    FIND FIRST PEDIDO WHERE PEDIDO.codcia = Ccbcdocu.codcia
        AND PEDIDO.coddoc = Ccbcdocu.codped
        AND PEDIDO.nroped = Ccbcdocu.nroped NO-LOCK NO-ERROR.
    IF AVAILABLE PEDIDO THEN DO:
        FIND COTIZACION WHERE COTIZACION.codcia = PEDIDO.codcia
            AND COTIZACION.coddoc = PEDIDO.codref
            AND COTIZACION.nroped = PEDIDO.nroref
            NO-LOCK NO-ERROR.
        IF AVAILABLE COTIZACION THEN DO:
            IF COTIZACION.CodCli = '20382036655' THEN x-Grupo-Topaz = 'Topaz: ' + COTIZACION.OfficeCustomer.
            IF COTIZACION.CodCli = '20100047218' THEN x-Grupo-Topaz = 'Grupo: ' + COTIZACION.DeliveryGroup.

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
DEF VAR x-NroSeries AS CHAR NO-UNDO.
DEF VAR x-Item AS INTE INIT 1 NO-UNDO.

EMPTY TEMP-TABLE Detalle.
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
    IF x-imprime-bcp = "SI" THEN DO:
        ASSIGN Detalle.peso = Ccbddocu.pesmat.
        FIND FIRST tmpArtxProv WHERE tmpArtxProv.tcodmat = Ccbddocu.codmat EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE tmpArtxProv  THEN DO:
            ASSIGN Detalle.DesMat_cli = tmpArtxProv.tdesmatbcp
                    Detalle.codMat_cli = tmpArtxProv.tcodmatbcp.
        END.
        ELSE DO:
            ASSIGN Detalle.DesMat_cli = 'NO EXISTE'
                    Detalle.codMat_cli = "NOMB. ARTICULO BCP NO EXISTE".
        END.
    END.
    /* ***************************************************************** */
    /* Acumulamos los # de serie: buscamos las HPK relacionadas a la O/D */
    /* ***************************************************************** */
    x-NroSeries = ''.
    FIND ORDENES WHERE ORDENES.codcia = Ccbcdocu.codcia 
        AND ORDENES.CodDoc = Ccbcdocu.Libre_c01     /* O/D */
        AND ORDENES.NroPed = Ccbcdocu.Libre_c02
        NO-LOCK NO-ERROR.
    IF AVAILABLE ORDENES THEN DO:
        /* Barremos las HPK */
        FOR EACH Vtacdocu NO-LOCK WHERE Vtacdocu.codcia = ORDENES.codcia
            AND Vtacdocu.codref = ORDENES.coddoc
            AND Vtacdocu.nroref = ORDENES.nroped
            AND Vtacdocu.codped = "HPK"
            AND Vtacdocu.flgest <> "A",
            EACH logisdchequeo NO-LOCK WHERE logisdchequeo.CodCia = Vtacdocu.codcia
            AND logisdchequeo.CodDiv = Vtacdocu.coddiv
            AND logisdchequeo.CodPed = Vtacdocu.codped      /* HPK */
            AND logisdchequeo.NroPed = Vtacdocu.nroped
            AND logisdchequeo.CodMat = Detalle.codmat       /* OJO */
            AND logisdchequeo.SerialNumber > '':                  /* OJO */
            IF TRUE <> (x-NroSeries > '') THEN x-NroSeries = 'Nro. Serie(s): ' + logisdchequeo.SerialNumber.
            ELSE x-NroSeries = x-NroSeries + ' / ' + logisdchequeo.SerialNumber.
        END.
        /* Solo se imprime si hay dato */
        IF x-NroSeries > '' THEN DO:
            CREATE Detalle.
            ASSIGN
                Detalle.NroItm = x-Item.
            ASSIGN
                Detalle.DesMat = x-NroSeries.
        END.
    END.
    /* ************************* */
    x-Item = x-Item + 1.
END.

ASSIGN
    ftr-Valor1 = x-Bultos
    ftr-Valor2 = x-Peso.

/* ***************************************************************** */
/* Para caso del BCP - 23Dic2021 - el articulo de ellos              */
/* ***************************************************************** */
IF x-imprime-bcp = "SI" THEN DO:
    FOR EACH Detalle:
        ASSIGN Detalle.codmat = TRIM(Detalle.codmat_cli)
                Detalle.desmat = Detalle.desmat_cli.
    END.
END.
/* CASE TRUE:                                                                                                                                      */
/*     WHEN X-TRANS > '' AND X-LUGAR > '' THEN DO:                                                                                                 */
/*         ASSIGN                                                                                                                                  */
/*             ftr-Glosa1 = "LA MERCADERIA VIAJA POR CUENTA Y RIESGO DEL CLIENTE, EL DESPACHO DE MERCADERIA ABARCA HASTA LA AGENCIA DE TRANSPORTE" */
/*             ftr-Glosa2 = 'PRIMER TRAMO  : '                                                                                                     */
/*             ftr-Glosa3 = 'Transport: ' + STRING(X-NomTra,'X(50)')                                                                               */
/*             ftr-Glosa4 = 'RUC      : ' + STRING(X-RucTra,'X(11)') + 'Dirección: ' + STRING(X-DIREC,'X(50)')                                     */
/*             ftr-Glosa5 = 'Direccion: ' + STRING(x-Direc,'x(50)')                                                                                */
/*             ftr-Glosa6 = x-Grupo-Topaz                                                                                                          */
/*             ftr-Glosa7 = 'Contacto : ' + STRING(X-CONTC,'X(25)') + 'Hora Aten :' + STRING(X-HORA,'X(10)')                                       */
/*             ftr-Glosa8 = 'SEGUNDO TRAMO  : '                                                                                                    */
/*             ftr-Glosa9 = 'Destino  : ' + STRING(X-LUGAR,'X(50)')                                                                                */
/*             ftr-Glosa10 = 'Observ   : ' + STRING(CcbCDocu.Glosa,"X(60)").                                                                       */
/*     END.                                                                                                                                        */
/*     WHEN X-TRANS > '' AND TRUE <> (X-LUGAR > '') THEN DO:                                                                                       */
/*         ASSIGN                                                                                                                                  */
/*             ftr-Glosa5 = "LA MERCADERIA VIAJA POR CUENTA Y RIESGO DEL CLIENTE, EL DESPACHO DE MERCADERIA ABARCA HASTA LA AGENCIA DE TRANSPORTE" */
/*             ftr-Glosa6 = x-Grupo-Topaz                                                                                                          */
/*             ftr-Glosa7 = 'PRIMER TRAMO  : '                                                                                                     */
/*             ftr-Glosa8 = 'Transport: ' + STRING(X-NomTra,'X(50)')                                                                               */
/*             ftr-Glosa9 = 'RUC      : ' + STRING(X-RucTra,'X(11)')                                                                               */
/*             ftr-Glosa10 = 'Dirección: ' + STRING(X-DIREC,'X(50)').                                                                              */
/*     END.                                                                                                                                        */
/*     WHEN TRUE <> (X-TRANS > '') AND X-LUGAR > '' THEN DO:                                                                                       */
/*         ASSIGN                                                                                                                                  */
/*             ftr-Glosa5 = "LA MERCADERIA VIAJA POR CUENTA Y RIESGO DEL CLIENTE, EL DESPACHO DE MERCADERIA ABARCA HASTA LA AGENCIA DE TRANSPORTE" */
/*             ftr-Glosa6 = x-Grupo-Topaz                                                                                                          */
/*             ftr-Glosa7 = 'SEGUNDO TRAMO  : '                                                                                                    */
/*             ftr-Glosa8 = 'Destino  : ' + STRING(X-LUGAR,'X(50)')                                                                                */
/*             ftr-Glosa9 = 'Observ   : ' + STRING(CcbCDocu.Glosa,"X(60)")                                                                         */
/*             ftr-Glosa10 = 'Contacto : ' + STRING(X-CONTC,'X(25)') + 'Hora Aten :' + STRING(X-HORA,'X(10)').                                     */
/*     END.                                                                                                                                        */
/*     OTHERWISE DO:                                                                                                                               */
/*         ASSIGN                                                                                                                                  */
/*             ftr-Glosa5 = "LA MERCADERIA VIAJA POR CUENTA Y RIESGO DEL CLIENTE, EL DESPACHO DE MERCADERIA ABARCA HASTA LA AGENCIA DE TRANSPORTE" */
/*             ftr-Glosa6 = x-Grupo-Topaz.                                                                                                         */
/*     END.                                                                                                                                        */
/* END CASE.                                                                                                                                       */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GRIMP_Formato-Continuo-13) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GRIMP_Formato-Continuo-13 Procedure 
PROCEDURE GRIMP_Formato-Continuo-13 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

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
/* Definimos Pie de Página */
/* ***************************************************************************** */
DEFINE FRAME F-FtrGui
    HEADER
    ftr-Glosa1 FORMAT 'x(130)' SKIP
    ftr-Glosa2 FORMAT 'x(100)' SKIP
    ftr-Glosa3 FORMAT 'x(100)' SKIP
    ftr-Glosa4 FORMAT 'x(100)' SKIP
    ftr-Glosa5 FORMAT 'x(130)' SKIP(1)
    ftr-Glosa6 FORMAT 'x(40)' ftr-Valor1 AT 50 FORMAT '>>,>>>' ftr-Valor2 AT 60 FORMAT '>>>,>>>.99' SKIP
    ftr-Glosa7 FORMAT 'x(100)' SKIP
    ftr-Glosa8 FORMAT 'x(100)' SKIP
    ftr-Glosa9 FORMAT 'x(100)' SKIP
    ftr-Glosa10 FORMAT 'x(100)' SKIP
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

/* ***************************************************************************** */
/* Imprimimos de acuerdo al formato seleccionado */
/* ***************************************************************************** */
OUTPUT TO PRINTER PAGE-SIZE 43.
PUT CONTROL {&PRN0} + {&PRN5A} + CHR(48) + {&PRN3}.     

/* RHC 28/04/2020 NO imprimir FLETE (fam. 100 catcont SV ) */
FOR EACH Detalle NO-LOCK BREAK BY Detalle.codcia BY Detalle.nroitm:
    VIEW FRAME F-HdrGui.
    VIEW FRAME F-FtrGui.
    DISPLAY 
        Detalle.codalm WHEN Detalle.codmat > ''
        Detalle.NroItm WHEN Detalle.codmat > ''
        Detalle.codmat WHEN Detalle.codmat > '' 
        Detalle.desmat 
        Detalle.desmar WHEN Detalle.codmat > ''
        Detalle.candes WHEN Detalle.codmat > ''
        Detalle.undvta WHEN Detalle.codmat > ''
        /*Detalle.peso   WHEN Detalle.peso > 0*/
        WITH FRAME F-DetaGui.
    IF LAST-OF(Detalle.codcia) THEN PAGE.
END.
OUTPUT CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GRIMP_Formato-Continuo-13-BCP) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GRIMP_Formato-Continuo-13-BCP Procedure 
PROCEDURE GRIMP_Formato-Continuo-13-BCP :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE FRAME F-HdrGui
    HEADER
    SKIP(4)
    x-FchDoc        AT 24 FORMAT "99/99/9999"
    SKIP (1)
    x-PuntoPartida  AT 12 FORMAT 'x(100)' SKIP
    x-PuntoLlegada  AT 12 FORMAT "X(100)" SKIP
    x-PuntoLlegada2  AT 12 FORMAT "X(100)" SKIP
    SKIP (2)
    x-Nombre        AT 20 FORMAT "X(70)"  SKIP
    x-Ruc           AT 8 FORMAT "X(11)" 
    SKIP(3)
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 200.
/* ***************************************************************************** */
/* Definición de Detalle */
/* ***************************************************************************** */
DEFINE FRAME F-DetaGui
    Detalle.codmat  AT 01   FORMAT "x(10)"
    Detalle.desmat  AT 12
    Detalle.candes  AT 90
    Detalle.UndVta  AT 112 
    Detalle.peso    AT 122 FORMAT '>>>,>>9.9999'
    WITH NO-LABELS NO-BOX NO-UNDERLINE STREAM-IO WIDTH 220.

DEFINE FRAME F-FtrGui
    HEADER
    SKIP(2)
    ftr-comprobante AT 30 FORMAT 'x(12)'
    SKIP(1)
    ftr-venta AT 10
    SKIP(5)
    WITH PAGE-BOTTOM NO-LABELS NO-UNDERLINE NO-BOX STREAM-IO WIDTH 200.

ftr-comprobante = "".
ftr-venta = "(X)".

/* Imprimimos de acuerdo al formato seleccionado */
OUTPUT TO PRINTER PAGE-SIZE 33.     /* Lineas x pagina 43 */
PUT CONTROL {&PRN0} + {&PRN5A} + CHR(48) + {&PRN3}.     

FOR EACH Detalle NO-LOCK BREAK BY Detalle.codcia BY Detalle.nroitm:
    VIEW FRAME F-HdrGui.
    VIEW FRAME F-FtrGui.
    DISPLAY 
        Detalle.codmat WHEN Detalle.codmat > '' 
        Detalle.desmat 
        Detalle.candes WHEN Detalle.codmat > ''
        Detalle.undvta WHEN Detalle.codmat > ''
        Detalle.peso 
        WITH FRAME F-DetaGui.

    IF LAST-OF(Detalle.codcia) THEN PAGE.
END.
OUTPUT CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GRIMP_Formato-Continuo-36) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GRIMP_Formato-Continuo-36 Procedure 
PROCEDURE GRIMP_Formato-Continuo-36 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ***************************************************************************** */
/* Definimos Encabezado */
/* ***************************************************************************** */
DEFINE FRAME F-HdrGui
    HEADER
    SKIP(6)
    x-PuntoPartida  AT 17 FORMAT 'x(100)' Ccbcdocu.NroDoc FORMAT 'x(15)' SKIP(1)
    x-Nombre        AT 12 FORMAT "X(70)"  SKIP
    x-PuntoLlegada  AT 12 FORMAT "X(100)" SKIP
    x-Ruc           AT 12 FORMAT "X(11)" SKIP(3)
    /*x-CodRef        FORMAT 'x(3)'*/
    x-NroRef        FORMAT "XXX-XXXXXXXX" 
    x-OD            AT 18
    x-OC
    x-FmaPgo
    x-FchDoc        AT 70 FORMAT '99/99/9999'
    x-CodVen        AT 90 FORMAT "X(5)"
    x-Bultos        
    x-Peso          AT 120
    SKIP(2)
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 200.
/* ***************************************************************************** */
/* Definimos Pie de Página */
/* ***************************************************************************** */
DEFINE FRAME F-FtrGui
    HEADER
    ftr-Glosa1 FORMAT 'x(100)' SKIP

    ftr-Glosa2 FORMAT 'x(100)' 
    ftr-Glosa8 FORMAT 'x(50)' AT 90 SKIP(0.1)

    ftr-Glosa3 FORMAT 'x(50)' AT 15 
    ftr-Glosa9 FORMAT 'x(50)' AT 70 SKIP(0.1)

    ftr-Glosa4 FORMAT 'x(50)' AT 12 
    ftr-Glosa10 FORMAT 'x(50)' AT 90 SKIP(0.1)

    ftr-Glosa5 FORMAT 'x(50)' AT 10 
    ftr-Glosa11 FORMAT 'x(50)' AT 90 SKIP(0.1)

    ftr-Glosa6 FORMAT 'x(50)' AT 15 
    ftr-Glosa12 FORMAT 'x(20)' AT 90 
    ftr-Glosa13 FORMAT 'x(20)' AT 115 SKIP(0.1)

    ftr-Glosa7 FORMAT 'x(50)' AT 15 
    ftr-Glosa14 FORMAT 'x(50)' AT 90 

    WITH PAGE-BOTTOM NO-LABELS NO-UNDERLINE NO-BOX STREAM-IO WIDTH 320.

/* ***************************************************************************** */
/* Definición de Detalle */
/* ***************************************************************************** */
DEFINE FRAME F-DetaGui
    Detalle.codmat AT 6
    Detalle.candes ' ' 
    Detalle.UndVta  
    Detalle.desmat FORMAT 'x(100)'
    WITH NO-LABELS NO-BOX NO-UNDERLINE STREAM-IO WIDTH 200.

/* ***************************************************************************** */
/* Imprimimos de acuerdo al formato seleccionado */
/* ***************************************************************************** */
OUTPUT TO PRINTER PAGE-SIZE 66.
PUT CONTROL {&PRN0} + {&PRN5A} + CHR(72) + {&PRN3}.     
FOR EACH Detalle NO-LOCK BREAK BY Detalle.codcia BY Detalle.nroitm:
    VIEW FRAME F-HdrGui.
    VIEW FRAME F-FtrGui.
    DISPLAY 
        Detalle.codmat WHEN Detalle.codmat > '' 
        Detalle.candes WHEN Detalle.codmat > ''
        Detalle.undvta WHEN Detalle.codmat > ''
        Detalle.desmat WHEN Detalle.codmat > ''
        WITH FRAME F-DetaGui.
    IF LAST-OF(Detalle.codcia) THEN PAGE.
END.
OUTPUT CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GRIMP_Formato-Continuo-36-BCP) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GRIMP_Formato-Continuo-36-BCP Procedure 
PROCEDURE GRIMP_Formato-Continuo-36-BCP :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* ***************************************************************************** */
/* Definimos Encabezado */
/* ***************************************************************************** */
DEFINE FRAME F-HdrGui
    HEADER
    SKIP(6)
    x-PuntoPartida  AT 17 FORMAT 'x(100)' Ccbcdocu.NroDoc FORMAT 'x(15)' SKIP(1)
    x-Nombre        AT 12 FORMAT "X(70)"  SKIP
    x-PuntoLlegada  AT 12 FORMAT "X(100)" SKIP
    x-Ruc           AT 12 FORMAT "X(11)" SKIP(3)
    /*x-CodRef        FORMAT 'x(3)'*/
    x-NroRef        FORMAT "XXX-XXXXXXXX" 
    x-OD            AT 18
    x-OC
    x-FmaPgo
    x-FchDoc        AT 70 FORMAT '99/99/9999'
    x-CodVen        AT 90 FORMAT "X(5)"
    x-Bultos        
    x-Peso          AT 120
    SKIP(2)
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 200.
/* ***************************************************************************** */
/* Definimos Pie de Página */
/* ***************************************************************************** */
DEFINE FRAME F-FtrGui
    HEADER
    SKIP(2)
    ftr-comprobante AT 30 FORMAT 'x(12)'
    SKIP(1)
    ftr-venta AT 10
    SKIP(5)
    WITH PAGE-BOTTOM NO-LABELS NO-UNDERLINE NO-BOX STREAM-IO WIDTH 200.

ftr-comprobante = "".
ftr-venta = "(X)".

/* ***************************************************************************** */
/* Definición de Detalle */
/* ***************************************************************************** */
DEFINE FRAME F-DetaGui
    Detalle.codmat AT 6
    Detalle.candes  ' '
    Detalle.UndVta  
    Detalle.desmat 
    Detalle.peso   FORMAT '>>>,>>9.9999'
    WITH NO-LABELS NO-BOX NO-UNDERLINE STREAM-IO WIDTH 200.

/* ***************************************************************************** */
/* Imprimimos de acuerdo al formato seleccionado */
/* ***************************************************************************** */
OUTPUT TO PRINTER PAGE-SIZE 66.
PUT CONTROL {&PRN0} + {&PRN5A} + CHR(72) + {&PRN3}.     
FOR EACH Detalle NO-LOCK BREAK BY Detalle.codcia BY Detalle.nroitm:
    VIEW FRAME F-HdrGui.
    VIEW FRAME F-FtrGui.
    DISPLAY 
        Detalle.codmat WHEN Detalle.codmat > '' 
        Detalle.candes WHEN Detalle.codmat > ''
        Detalle.undvta WHEN Detalle.codmat > ''
        Detalle.desmat WHEN Detalle.codmat > ''
        Detalle.peso WHEN Detalle.codmat > ''
        WITH FRAME F-DetaGui.
    IF LAST-OF(Detalle.codcia) THEN PAGE.
END.
OUTPUT CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GRIMP_Pie-de-Pagina) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GRIMP_Pie-de-Pagina Procedure 
PROCEDURE GRIMP_Pie-de-Pagina :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

CASE TRUE:
    WHEN X-TRANS > '' AND X-LUGAR > '' THEN DO:
        ASSIGN
            ftr-Glosa1 = "LA MERCADERIA VIAJA POR CUENTA Y RIESGO DEL CLIENTE, EL DESPACHO DE MERCADERIA ABARCA HASTA LA AGENCIA DE TRANSPORTE"
            ftr-Glosa2 = 'PRIMER TRAMO  : '
            ftr-Glosa3 = 'Transport: ' + STRING(X-NomTra,'X(50)')
            ftr-Glosa4 = 'RUC      : ' + STRING(X-RucTra,'X(11)') + 'Dirección: ' + STRING(X-DIREC,'X(50)')
            ftr-Glosa5 = 'Direccion: ' + STRING(x-Direc,'x(50)')
            ftr-Glosa6 = x-Grupo-Topaz
            ftr-Glosa7 = 'Contacto : ' + STRING(X-CONTC,'X(25)') + 'Hora Aten :' + STRING(X-HORA,'X(10)')
            ftr-Glosa8 = 'SEGUNDO TRAMO  : '
            ftr-Glosa9 = 'Destino  : ' + STRING(X-LUGAR,'X(50)')
            ftr-Glosa10 = 'Observ   : ' + STRING(CcbCDocu.Glosa,"X(60)").
    END.
    WHEN X-TRANS > '' AND TRUE <> (X-LUGAR > '') THEN DO:
        ASSIGN
            ftr-Glosa5 = "LA MERCADERIA VIAJA POR CUENTA Y RIESGO DEL CLIENTE, EL DESPACHO DE MERCADERIA ABARCA HASTA LA AGENCIA DE TRANSPORTE"
            ftr-Glosa6 = x-Grupo-Topaz
            ftr-Glosa7 = 'PRIMER TRAMO  : '
            ftr-Glosa8 = 'Transport: ' + STRING(X-NomTra,'X(50)')
            ftr-Glosa9 = 'RUC      : ' + STRING(X-RucTra,'X(11)')
            ftr-Glosa10 = 'Dirección: ' + STRING(X-DIREC,'X(50)').
    END.
    WHEN TRUE <> (X-TRANS > '') AND X-LUGAR > '' THEN DO:
        ASSIGN
            ftr-Glosa5 = "LA MERCADERIA VIAJA POR CUENTA Y RIESGO DEL CLIENTE, EL DESPACHO DE MERCADERIA ABARCA HASTA LA AGENCIA DE TRANSPORTE"
            ftr-Glosa6 = x-Grupo-Topaz
            ftr-Glosa7 = 'SEGUNDO TRAMO  : '
            ftr-Glosa8 = 'Destino  : ' + STRING(X-LUGAR,'X(50)')
            ftr-Glosa9 = 'Observ   : ' + STRING(CcbCDocu.Glosa,"X(60)")
            ftr-Glosa10 = 'Contacto : ' + STRING(X-CONTC,'X(25)') + 'Hora Aten :' + STRING(X-HORA,'X(10)').
    END.
    OTHERWISE DO:
        ASSIGN
            ftr-Glosa5 = "LA MERCADERIA VIAJA POR CUENTA Y RIESGO DEL CLIENTE, EL DESPACHO DE MERCADERIA ABARCA HASTA LA AGENCIA DE TRANSPORTE"
            ftr-Glosa6 = x-Grupo-Topaz.
    END.
END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GRIMP_Pie-de-Pagina-36) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GRIMP_Pie-de-Pagina-36 Procedure 
PROCEDURE GRIMP_Pie-de-Pagina-36 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


/* PIE DE PAGINA */
ASSIGN
    ftr-Glosa1 = STRING(X-NomTra,'X(100)')
    ftr-Glosa2 = STRING(x-Direc,'x(100)')
    ftr-Glosa3 = ""
    ftr-Glosa4 = ""
    ftr-Glosa5 = STRING(X-RucTra,'X(11)')
    ftr-Glosa6 = STRING(f-Placa,'x(15)')
    ftr-Glosa7 = TRIM(f-NroLicencia) + ' - ' + TRIM(f-Chofer)

    ftr-Glosa8 = SUBSTRING(x-Lugar,1,45)
    ftr-Glosa9 = SUBSTRING(x-Lugar,46,60)
    ftr-Glosa10 = ""
    ftr-Glosa11 = ""
    ftr-Glosa12 = ""
    ftr-Glosa13 = ""
    ftr-Glosa14 = ""
    .

IF (TRUE <> (X-TRANS > '')) AND (TRUE <> (X-LUGAR > '')) THEN DO:
    ASSIGN
        ftr-Glosa1 = ''
        ftr-Glosa2 = ''
        ftr-Glosa3 = ''
        ftr-Glosa4 = ''
        ftr-Glosa5 = ''
        ftr-Glosa6 = ''
        ftr-Glosa7 = ''
        ftr-Glosa8 = ''
        ftr-Glosa9 = ''
        .
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GRIMP_Rutina-Principal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GRIMP_Rutina-Principal Procedure 
PROCEDURE GRIMP_Rutina-Principal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pOrigenX AS CHAR.
DEF INPUT PARAMETER pRowid AS ROWID.       
DEF INPUT PARAMETER pFormato AS INTE.
/* Valores posibles:
    1: códigos Continental
    2: Códigos EAN
*/    

DEFINE VAR x-imprime-bcp AS CHAR.
DEFINE VAR pOrigen AS CHAR.

/* Para caso de impresion de formato BCP */
pOrigen = pOrigenX.
x-imprime-bcp = "".
IF NUM-ENTRIES(pOrigenX,"|") > 1 THEN DO:
    pOrigen = ENTRY(1,pOrigenX,"|").
    x-imprime-bcp = ENTRY(2,pOrigenX,"|").
END.
/* Valores posibles:
    G/R: Guía de Remisión por Ventas 
    ALM: Guía de Remisión del Almacén por otras transferencias */
IF LOOKUP(pOrigen, 'G/R,ALM,TRF') = 0 THEN RETURN.

DEF VAR x-Formato AS CHAR NO-UNDO.
x-Formato = "13".       /* Formato por defecto: 13 líneas por hoja */

/* Cargamos temporales de acuerdo al origen */
CASE pOrigen:
    WHEN "G/R" THEN DO:
        FIND FIRST ccbcdocu WHERE ROWID(ccbcdocu) = pRowid NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ccbcdocu THEN RETURN.
        FIND FacTabla WHERE FacTabla.CodCia = s-codcia AND
            FacTabla.Tabla = 'CFG_FMT_GR' AND
            FacTabla.Codigo = Ccbcdocu.CodDiv NO-LOCK NO-ERROR.
        IF AVAILABLE FacTabla THEN x-Formato = FacTabla.Campo-C[1].
        IF TRUE <> (x-Formato > '') THEN RETURN.
        CASE TRUE:
            WHEN x-Formato = "13" AND x-imprime-bcp = 'SI'  THEN DO:
                /* Formato 13 líneas por hoja */
                RUN GRIMP_Carga-Temporal (INPUT pFormato).
                RUN GRIMP_Pie-de-Pagina.
                RUN GRIMP_Formato-Continuo-13-BCP.
            END.
            WHEN x-Formato = "13" THEN DO:
                /* Formato 13 líneas por hoja */
                RUN GRIMP_Carga-Temporal (INPUT pFormato).
                RUN GRIMP_Pie-de-Pagina.
                RUN GRIMP_Formato-Continuo-13.
            END.
            WHEN x-Formato = "36" AND x-imprime-bcp = "SI" THEN DO:
                /* Formato 36 líneas por hoja */
                RUN GRIMP_Carga-Temporal (INPUT pFormato).
                RUN GRIMP_Pie-de-Pagina-36.
                RUN GRIMP_Formato-Continuo-36-BCP.
            END.
            WHEN x-Formato = "36" THEN DO:
                /* Formato 36 líneas por hoja */
                RUN GRIMP_Carga-Temporal (INPUT pFormato).
                RUN GRIMP_Pie-de-Pagina-36.
                RUN GRIMP_Formato-Continuo-36.
            END.
        END CASE.
    END.
END CASE.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

