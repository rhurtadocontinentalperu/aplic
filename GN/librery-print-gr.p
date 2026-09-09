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

DEF INPUT PARAMETER pRowid AS ROWID NO-UNDO.

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
         HEIGHT             = 6.65
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEF VAR pFormato AS INTE NO-UNDO.


FIND FIRST ccbcdocu WHERE ROWID(ccbcdocu) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbcdocu THEN RETURN.

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

DEFINE BUFFER B-DOCU FOR CcbCDocu.

/* ***************************************************************************** */
/* Valores de cabecera */
/* ***************************************************************************** */
ASSIGN
    x-PuntoLlegada = TRIM(Ccbcdocu.lugent)    /* Sede del cliente o del transportista */
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
/* Bultos */
FOR EACH CcbCBult WHERE CcbCBult.CodCia = Ccbcdocu.codcia AND
    CcbCBult.CodDiv = Ccbcdocu.coddiv AND 
    CcbCBult.CodDoc = ccbcdocu.libre_c01 AND
    CcbCBult.NroDoc = ccbcdocu.libre_c02
    NO-LOCK:
    x-Bultos = x-Bultos + CcbCBult.Bultos.
END.
/* Peso */
FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK, FIRST Almmmatg OF Ccbddocu NO-LOCK:
    x-Peso = x-Peso + (Ccbddocu.candes * Ccbddocu.factor * Almmmatg.pesmat).
END.
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
            /* Ic - 02Oct2020 : Se cambio a pedido de Mayra Padilla
            IF COTIZACION.CodCli = '20382036655' THEN x-Grupo-Topaz = 'Grupo/Topaz: ' + COTIZACION.OfficeCustomer.
            IF COTIZACION.CodCli = '20100047218' THEN x-Grupo-Topaz = 'Grupo/Topaz: ' + COTIZACION.InvoiceCustomerGroup.
            */
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
    /* ***************************************************************** */
    /* Para caso del BCP - 23Dic2021 - el articulo de ellos              */
    /* ***************************************************************** */
    /*IF LOOKUP(Ccbcdocu.CodCli,'20100047218') > 0 /*AND Ccbcdocu.CodAlm = '11D'*/ THEN DO:       /* BCP   ??????????????????  */*/
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
        /*
        FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                                        x-faccpedi.coddoc = Ccbcdocu.codped AND     /* Deberia ser PED */
                                        x-faccpedi.nroped = Ccbcdocu.nroped NO-LOCK NO-ERROR.
        IF AVAILABLE x-faccpedi THEN DO:
            FIND FIRST x-facdpedi WHERE x-facdpedi.codcia = s-codcia AND
                                        x-facdpedi.coddoc = x-faccpedi.codref AND   /* Deberia ser COT */
                                        x-facdpedi.nroped = x-faccpedi.nroref AND
                                        x-facdpedi.codmat = Ccbddocu.codmat NO-LOCK NO-ERROR.
            IF AVAILABLE x-facdpedi THEN DO:
                ASSIGN Detalle.DesMat_cli = x-facdpedi.customerArtDescription
                        Detalle.codMat_cli = x-facdpedi.customerArtCode.
                    
            END.
        END.
        */
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
/*IF LOOKUP(Ccbcdocu.CodCli,'20100047218') > 0 /*AND Ccbcdocu.CodAlm = '11D'*/ THEN DO:   /* BCP   ??????????????????  */*/
IF x-imprime-bcp = "SI" THEN DO:
    FOR EACH Detalle:
        ASSIGN Detalle.codmat = TRIM(Detalle.codmat_cli)
                Detalle.desmat = Detalle.desmat_cli.
    END.
END.

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

&IF DEFINED(EXCLUDE-GRIMP_Formato-Continuo-13) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GRIMP_Formato-Continuo-13 Procedure 
PROCEDURE GRIMP_Formato-Continuo-13 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

