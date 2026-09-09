&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE A-MATG NO-UNDO LIKE Almmmatg
       INDEX Idx00 AS PRIMARY CodMat.
DEFINE BUFFER B-FacTabla FOR FacTabla.
DEFINE BUFFER b-VtaDctoProm FOR VtaDctoProm.
DEFINE BUFFER b-VtaDctoPromMin FOR VtaDctoPromMin.
DEFINE TEMP-TABLE E-MATG NO-UNDO LIKE Almmmatg.
DEFINE TEMP-TABLE T-FacDPedi NO-UNDO LIKE FacDPedi.
DEFINE TEMP-TABLE t-VtaDctoProm NO-UNDO LIKE VtaDctoProm.
DEFINE TEMP-TABLE t-VtaDctoPromMin NO-UNDO LIKE VtaDctoPromMin.



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
/* Librerias para PRICING
DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN <libreria> PERSISTENT SET hProc.

RUN <libreria>.rutina_internaIN hProc (input  buffer tt-excel:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer tt-excel:handle,
                        input  c-csv-file,
                        output c-xls-file) .

DELETE PROCEDURE hProc.


*/
/* ***************************  Definitions  ************************** */
DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR cl-codcia AS INTE.
DEF SHARED VAR s-user-id AS CHAR.

/* Descuento x Volumen x Saldos */
DEF TEMP-TABLE ResumenxLinea
    FIELD codmat LIKE almmmatg.codmat
    FIELD codfam LIKE almmmatg.codfam
    FIELD subfam LIKE almmmatg.subfam 
    FIELD canped LIKE facdpedi.canped
    INDEX Llave01 AS PRIMARY /*UNIQUE*/ codmat codfam subfam.

DEF TEMP-TABLE ErroresxLinea LIKE ResumenxLinea.

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
      TABLE: A-MATG T "?" NO-UNDO INTEGRAL Almmmatg
      ADDITIONAL-FIELDS:
          INDEX Idx00 AS PRIMARY CodMat
      END-FIELDS.
      TABLE: B-FacTabla B "?" ? INTEGRAL FacTabla
      TABLE: b-VtaDctoProm B "?" ? INTEGRAL VtaDctoProm
      TABLE: b-VtaDctoPromMin B "?" ? INTEGRAL VtaDctoPromMin
      TABLE: E-MATG T "?" NO-UNDO INTEGRAL Almmmatg
      TABLE: T-FacDPedi T "?" NO-UNDO INTEGRAL FacDPedi
      TABLE: t-VtaDctoProm T "?" NO-UNDO INTEGRAL VtaDctoProm
      TABLE: t-VtaDctoPromMin T "?" NO-UNDO INTEGRAL VtaDctoPromMin
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 13.73
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-PRI_Alerta-de-Margen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PRI_Alerta-de-Margen Procedure 
PROCEDURE PRI_Alerta-de-Margen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Indica si se va a enviar solo una alerta
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodMat AS CHAR.                             
DEF OUTPUT PARAMETER pOk AS LOG NO-UNDO.

DEF BUFFER B-ARTICULO FOR Almmmatg.

pOk = NO.
/* ********************************************************************************************** */
/* 1ro. Por Ventas Mayores a n meses: NO pueden ser promociones o regalos */
/* ********************************************************************************************** */
DEF VAR pFchPed AS DATE NO-UNDO.

FIND FIRST FacTabla WHERE FacTabla.CodCia = s-CodCia AND FacTabla.Tabla = "MMX" NO-LOCK NO-ERROR.

IF AVAILABLE FacTabla AND FacTabla.Valor[1] > 0 THEN DO:
    RUN PRI_Ultima_Venta (INPUT pCodMat, OUTPUT pFchPed).
    IF pFchPed = ? THEN DO:
        /* Puede que sea un producto nuevo, veamos su fecha de registro */
        FIND B-ARTICULO WHERE B-ARTICULO.codcia = s-codcia
            AND B-ARTICULO.codmat = pCodMat NO-LOCK NO-ERROR.
        IF AVAILABLE B-ARTICULO THEN DO:
            IF B-ARTICULO.FchIng <= ADD-INTERVAL(TODAY, ( -1 * INTEGER(FacTabla.Valor[1]) ),'months') 
                THEN pOk = YES.     /* SOlo una Alerta */
        END.
    END.
    ELSE IF pFchPed < ADD-INTERVAL(TODAY, ( -1 * INTEGER(FacTabla.Valor[1]) ),'months') THEN DO:
        pOk = YES.     /* Solo una Alerta */
    END.
END.
/* ********************************************************************************************** */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRI_Cantidad-Fac-Neta) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PRI_Cantidad-Fac-Neta Procedure 
PROCEDURE PRI_Cantidad-Fac-Neta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
NOTA: 
De acuerdo a la configuración de la tabla pridtovolacucab y pridtovolacudet
determinamos la cantidad neta facturada */

DEF INPUT PARAMETER pCodDiv AS CHAR NO-UNDO.
DEF INPUT PARAMETER pCodCli AS CHAR NO-UNDO.
DEF INPUT PARAMETER pCodMat AS CHAR NO-UNDO.
DEF OUTPUT PARAMETER pCantidad AS DECI NO-UNDO.

/*RETURN.*/

DEF VAR pInicio AS DATE NO-UNDO.
DEF VAR pFin AS DATE NO-UNDO.

DEF VAR fFactor AS DECI NO-UNDO.

DEF BUFFER COTIZACION FOR Faccpedi.         
DEF BUFFER PEDIDO FOR Faccpedi.    
DEF BUFFER CREDITO FOR Ccbcdocu.

/* Buscamos todos los clientes agrupados */
DEF VAR x-Clientes AS CHAR NO-UNDO.
DEF VAR x-Agrupador AS CHAR NO-UNDO.
DEF VAR k AS INTE NO-UNDO.
DEF VAR x-CodCli AS CHAR NO-UNDO.

x-Clientes = pCodCli.       /* Valor por defecto */

/* Rastreamos el cliente agrupador */
FIND FIRST VtaCTabla WHERE VtaCTabla.CodCia = s-codcia AND
    VtaCTabla.Tabla = "CLGRP" AND
    VtaCTabla.Llave = pCodCli NO-LOCK NO-ERROR.
IF AVAILABLE VtaCTabla THEN x-Agrupador = VtaCTabla.Llave.
ELSE DO:
    FOR EACH Vtadtabla NO-LOCK WHERE VtaDTabla.CodCia = s-codcia AND
        VtaDTabla.Tabla = "CLGRP" AND
        VtaDTabla.Tipo = pCodCli,
        FIRST VtaCTabla OF VtaDTabla NO-LOCK:
        x-Agrupador = VtaCTabla.Llave.
        LEAVE.
    END.
END.
IF x-Agrupador > '' THEN DO:
    IF LOOKUP(x-Agrupador, x-Clientes) = 0 THEN x-Clientes = x-Clientes + ',' + x-Agrupador.
    FOR EACH VtaDTabla NO-LOCK WHERE VtaDTabla.CodCia = s-codcia AND
        VtaDTabla.Tabla = "CLGRP" AND
        VtaDTabla.Llave = x-Agrupador:
        IF LOOKUP(VtaDTabla.Tipo, x-Clientes) = 0 THEN x-Clientes = x-Clientes + ',' + VtaDTabla.Tipo.
    END.
END.
/*MESSAGE pcoddiv x-agrupador SKIP x-Clientes.*/

/* Buscamos las fechas configuradas */
pCantidad = 0.
FOR EACH PriDtoVolAcuCab NO-LOCK WHERE PriDtoVolAcuCab.CodCia = s-codcia
    AND PriDtoVolAcuCab.CodDiv = pCodDiv
    AND PriDtoVolAcuCab.Cerrado = NO,
    FIRST PriDtoVolAcuDet OF PriDtoVolAcuCab NO-LOCK WHERE PriDtoVolAcuDet.codmat = pCodMat:
    pInicio = PriDtoVolAcuCab.Inicio.
    pFin = PriDtoVolAcuCab.Fin.
    /* Barremos por cada cliente */
    DO k = 1 TO NUM-ENTRIES(x-Clientes):
        x-CodCli = ENTRY(k, x-Clientes).
        FOR EACH COTIZACION NO-LOCK WHERE COTIZACION.codcia = s-codcia
            AND COTIZACION.codcli = x-CodCli
            AND COTIZACION.coddoc = "COT"
            AND COTIZACION.FchPed >= pInicio
            AND COTIZACION.FchPed <= pFin
            AND COTIZACION.Lista_de_Precios = pCodDiv:
            IF NOT CAN-FIND(FIRST Facdpedi OF COTIZACION WHERE Facdpedi.codmat = pCodMat NO-LOCK) THEN NEXT.
            FOR EACH PEDIDO NO-LOCK WHERE PEDIDO.codcia = s-codcia
                AND PEDIDO.codref = COTIZACION.coddoc
                AND PEDIDO.nroref = COTIZACION.nroped
                AND PEDIDO.coddoc = "PED":
                IF NOT CAN-FIND(FIRST Facdpedi OF PEDIDO WHERE Facdpedi.codmat = pCodMat NO-LOCK) THEN NEXT.
                /* Lo facturado */
                FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
                    AND Ccbcdocu.codped = PEDIDO.coddoc
                    AND Ccbcdocu.nroped = PEDIDO.nroped 
                    AND LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL') > 0
                    AND Ccbcdocu.flgest <> "A"
                    AND Ccbcdocu.flgcie <> "C":
                    fFactor = 1.
                    FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK WHERE Ccbddocu.codmat = pCodMat:
                        pCantidad = pCantidad + (Ccbddocu.candes * Ccbddocu.factor) * fFactor.
                    END.
                    /* Buscamos si tiene N/C por devolución de mercadería */
                    FOR EACH CREDITO NO-LOCK WHERE CREDITO.codcia = s-codcia
                        AND CREDITO.coddoc = "N/C"
                        AND CREDITO.codref = Ccbcdocu.coddoc
                        AND CREDITO.nroref = Ccbcdocu.nrodoc
                        AND CREDITO.CndCre = "D"
                        AND CREDITO.flgest <> "A"
                        AND CREDITO.flgcie <> "C":
                        fFactor = -1.
                        FOR EACH Ccbddocu OF CREDITO NO-LOCK WHERE Ccbddocu.codmat = pCodMat:
                            pCantidad = pCantidad + (Ccbddocu.candes * Ccbddocu.factor) * fFactor.
                        END.
                    END.
                END.
            END.
        END.
    END.
END.
IF pCantidad < 0 THEN pCantidad = 0.
/*MESSAGE pcodmat pcantidad.*/

END PROCEDURE.

/*
FIND FIRST tc-gn-clie WHERE tc-gn-clie.CodCia = cl-codcia 
    AND tc-gn-clie.CodCli = pCodCli NO-LOCK NO-ERROR.
IF AVAILABLE tc-gn-clie THEN x-Agrupador = tc-gn-clie.CodCli.
ELSE DO:
    /* Buscamos agrupador válido */
    FOR EACH td-gn-clie WHERE td-gn-clie.CodCia = cl-codcia AND td-gn-clie.CodCliAgr = pCodCli,
        FIRST tc-gn-clie NO-LOCK WHERE tc-gn-clie.CodCia  = td-gn-clie.CodCia 
        AND tc-gn-clie.CodCli = td-gn-clie.CodCli,
        FIRST gn-clie NO-LOCK WHERE gn-clie.CodCia = tc-gn-clie.CodCia
        AND gn-clie.CodCli = tc-gn-clie.CodCli
        AND gn-clie.FlgSit = "A":
        x-Agrupador = tc-gn-clie.CodCli.
        LEAVE.
    END.
END.
IF x-Agrupador > '' THEN DO:
    FOR EACH td-gn-clie NO-LOCK WHERE td-gn-clie.CodCia = cl-codcia
        AND td-gn-clie.CodCli = x-Agrupador:
        IF LOOKUP(td-gn-clie.CodCliAgr, x-Clientes) = 0 
            THEN x-Clientes = x-Clientes + ',' + td-gn-clie.CodCliAgr.
    END.
END.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRI_DctoxVolxSaldo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PRI_DctoxVolxSaldo Procedure 
PROCEDURE PRI_DctoxVolxSaldo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
DEF INPUT PARAMETER pCodDiv AS CHAR.    /* Lista de Precio/División */
DEF INPUT PARAMETER pRowid AS ROWID.    /* Puntero de la COT */
DEF OUTPUT PARAMETER pMensaje AS CHAR.

DEF BUFFER B-Faccpedi FOR Faccpedi.
DEF BUFFER B-Facdpedi FOR Facdpedi.
DEF BUFFER B-FacTabla FOR FacTabla.

FIND B-Faccpedi WHERE ROWID(B-Faccpedi) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-Faccpedi THEN RETURN 'OK'.

DEF VAR j AS INT NO-UNDO.
DEF VAR x-Canti AS DEC NO-UNDO.
DEF VAR x-Rango AS DEC NO-UNDO.
DEF VAR x-DctoxVolumen AS DECIMAL DECIMALS 4 NO-UNDO.
DEF VAR X-TIPDTO AS CHAR INIT "DVXSALDOC" NO-UNDO.               /* Tipo de descuento aplicado (PROM, VOL) */ 
DEF VAR F-FACTOR AS DECI NO-UNDO.

DEF VAR x-PreVta LIKE Facdpedi.PreUni NO-UNDO.
DEF VAR x-TpoCmb LIKE Almmmatg.TpoCmb NO-UNDO.
DEF VAR x-MonVta LIKE Almmmatg.MonVta NO-UNDO.
DEF VAR x-UndVta LIKE Facdpedi.UndVta NO-UNDO.
DEF VAR s-PorIgv LIKE Faccpedi.PorIgv NO-UNDO.

ASSIGN s-PorIgv = B-Faccpedi.PorIgv.

/* 1ro. BARREMOS TODAS LAS PROMOCIONES POR SALDOS */
FOR EACH VtaDctoVolSaldo NO-LOCK WHERE VtaDctoVolSaldo.CodCia = B-Faccpedi.CodCia AND
        VtaDctoVolSaldo.CodDiv = pCodDiv AND
        VtaDctoVolSaldo.Tabla = "DVXSALDOC" AND
        (TODAY >= VtaDctoVolSaldo.FchIni AND TODAY <= VtaDctoVolSaldo.FchFin),
    FIRST FacTabla NO-LOCK WHERE FacTabla.CodCia = VtaDctoVolSaldo.CodCia AND
        FacTabla.Tabla = VtaDctoVolSaldo.Tabla AND
        FacTabla.Codigo = VtaDctoVolSaldo.Codigo:
    /* RESUMEN POR PRODUCTOS RELACIONADOS */
    /* POR CADA PROMOCION UN CALCULO NUEVO */
    EMPTY TEMP-TABLE ResumenxLinea.
    EMPTY TEMP-TABLE ErroresxLinea.
    FOR EACH B-FacTabla NO-LOCK WHERE B-FacTabla.codcia = FacTabla.CodCia AND 
        B-FacTabla.Tabla = "DVXSALDOD" AND 
        B-FacTabla.Codigo BEGINS FacTabla.Codigo,
        FIRST B-Facdpedi OF B-Faccpedi NO-LOCK WHERE B-Facdpedi.codmat = B-FacTabla.Campo-C[1],
        FIRST Almmmatg OF B-Facdpedi NO-LOCK:
        FIND FIRST ResumenxLinea WHERE ResumenxLinea.codmat = Almmmatg.codmat NO-ERROR.
        IF NOT AVAILABLE ResumenxLinea THEN CREATE ResumenxLinea.
        /* Todo en unidades de STOCK */
        ASSIGN
            ResumenxLinea.codmat = Almmmatg.codmat
            ResumenxLinea.canped = ResumenxLinea.canped + (B-Facdpedi.canped * B-Facdpedi.factor).
    END.
    /* ACUMULAMOS CANTIDADES */
    X-CANTI = 0.
    FOR EACH ResumenxLinea:
        X-CANTI = X-CANTI + ResumenxLinea.canped.
    END.
    /* BUSCAMOS SI CUMPLE EN DESCUENTO POR VOLUMEN */
    ASSIGN
        x-DctoxVolumen = 0
        x-Rango = 0.
    DO J = 1 TO 10:
        IF X-CANTI >= VtaDctoVolSaldo.DtoVolR[j] AND VtaDctoVolSaldo.DtoVolD[j] > 0  THEN DO:
            IF X-RANGO  = 0 THEN X-RANGO = VtaDctoVolSaldo.DtoVolR[j].
            IF X-RANGO <= VtaDctoVolSaldo.DtoVolR[j] THEN DO:
                ASSIGN
                    X-RANGO  = VtaDctoVolSaldo.DtoVolR[j]
                    x-DctoxVolumen = VtaDctoVolSaldo.DtoVolD[j].
            END.   
        END.   
    END.
    IF x-DctoxVolumen <= 0 THEN NEXT.   /* Siguiente Registro */
    /* ************************************************************ */
    /* RHC 28/10/2013 SE VA A RECALCULAR EL PRECIO DE LA COTIZACION */
    /* ************************************************************ */
    EMPTY TEMP-TABLE T-FacDPedi.
    FOR EACH ResumenxLinea:
        {lib/lock-genericov3.i ~
            &Alcance="FIRST" ~
            &Tabla="B-Facdpedi"
            &Condicion="B-Facdpedi.codcia = B-Faccpedi.codcia AND ~
            B-Facdpedi.coddiv = B-Faccpedi.coddiv AND ~
            B-Facdpedi.coddoc = B-Faccpedi.coddoc AND ~
            B-Facdpedi.nroped = B-Faccpedi.nroped AND ~
            B-Facdpedi.codmat = ResumenxLinea.codmat" ~
            &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
            &Accion="RETRY" ~
            &Mensaje="NO" ~
            &TipoError="UNDO, RETURN 'ADM-ERROR'" ~
            &txtMensaje="pMensaje"}
        /* Buscamos el PRECIO UNITARIO */
        RUN PRI_PrecioBase-DctoVolSaldo (INPUT "DVXSALDOD",
                                         INPUT VtaDctoVolSaldo.Codigo,
                                         INPUT VtaDctoVolSaldo.CodDiv,
                                         OUTPUT x-PreVta,
                                         OUTPUT x-TpoCmb,
                                         OUTPUT x-MonVta,
                                         OUTPUT x-UndVta).
        IF B-Faccpedi.CodMon <> x-MonVta THEN DO:
            IF B-Faccpedi.CodMon = 1 THEN x-PreVta = x-PreVta * x-TpoCmb.
            ELSE x-PreVta = x-PreVta / x-TpoCmb.
        END.
        /* Calculamos sobre el temporal: Precio Unitario + Flete */
        CREATE T-FacDPedi.
        BUFFER-COPY B-Facdpedi TO T-Facdpedi
            ASSIGN
            T-FacDPedi.Por_Dsctos[1] = 0
            T-FacDPedi.Por_Dsctos[2] = 0
            T-FacDPedi.Por_Dsctos[3] = x-DctoxVolumen.
        ASSIGN
            T-FacDPedi.PreUni = (x-PreVta *  T-FacDPedi.Factor) + T-FacDPedi.Libre_d02
            T-Facdpedi.Libre_c04 = x-TipDto.
        {vta2/calcula-linea-detalle.i &Tabla="T-FacDPedi"}
        /* Comparamos PRECIOS UNITARIOS */
        /*MESSAGE T-FacDPedi.implin  B-FacDPedi.implin.*/
        IF T-FacDPedi.implin < B-FacDPedi.implin THEN DO:
            BUFFER-COPY T-FacDPedi TO B-FacDPedi.
        END.
    END.
END.
RETURN 'OK'.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRI_Divisiones-Validas) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PRI_Divisiones-Validas Procedure 
PROCEDURE PRI_Divisiones-Validas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pTipoLista AS INT.
DEF OUTPUT PARAMETER pDivisiones AS CHAR.

pDivisiones = "".
CASE pTipoLista:
    WHEN 1 THEN DO:
        /* Ventas Mayoristas Contado y Crédito - Lista General */
        /* Cualquier cambio también afectar triggers/w-almmmatg.p */
        /* RHC 07/08/2020 Increnmentamos en grupo MIN */
        FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia AND
            gn-divi.campo-log[1] = NO AND
            LOOKUP(gn-divi.canalventa, 'ATL,HOR,INS,MOD,PRO,TDA,INT,B2C,MIN') > 0 AND
            gn-divi.ventamayorista = 1:
            pDivisiones = pDivisiones + (IF TRUE <> (pDivisiones > '') THEN '' ELSE ',') +
                gn-divi.coddiv.
        END.
    END.
    WHEN 2 THEN DO:
        /* Ventas Minoristas Contado (Utilex) - Lista General */
        FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia AND
            gn-divi.campo-log[1] = NO AND
            LOOKUP(gn-divi.canalventa, 'MIN') > 0 AND
            gn-divi.ventamayorista = 1:
            pDivisiones = pDivisiones + (IF TRUE <> (pDivisiones > '') THEN '' ELSE ',') +
                gn-divi.coddiv.
        END.
    END.
    WHEN 3 THEN DO:
        /* Ventas Mayoristas Contado y Crédito - Lista Específica */
        FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia AND
            gn-divi.campo-log[1] = NO AND
            LOOKUP(gn-divi.canalventa, 'ATL,HOR,INS,MOD,PRO,TDA,INT,B2C') > 0 AND
            gn-divi.ventamayorista = 2:
            pDivisiones = pDivisiones + (IF TRUE <> (pDivisiones > '') THEN '' ELSE ',') +
                gn-divi.coddiv.
        END.
    END.
    WHEN 4 THEN DO:
        /* Eventos - Lista Específica */
        FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia AND
            gn-divi.campo-log[1] = NO AND
            LOOKUP(gn-divi.canalventa, 'FER') > 0 AND
            gn-divi.ventamayorista = 2:
            pDivisiones = pDivisiones + (IF TRUE <> (pDivisiones > '') THEN '' ELSE ',') +
                gn-divi.coddiv.
        END.
    END.
END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRI_Excel-Errores) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PRI_Excel-Errores Procedure 
PROCEDURE PRI_Excel-Errores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER TABLE FOR E-MATG.
DEF INPUT PARAMETER TABLE FOR A-MATG.

FIND FIRST E-MATG NO-LOCK NO-ERROR.
FIND FIRST A-MATG NO-LOCK NO-ERROR.
IF NOT AVAILABLE E-MATG AND NOT AVAILABLE A-MATG THEN RETURN.
MESSAGE 'Los siguientes producto NO se han actualizado o hay una ALERTA' SKIP
    'Se mostrará una lista en Excel'
    VIEW-AS ALERT-BOX INFORMATION.

DEF VAR lNuevoFile AS LOG NO-UNDO.
DEF VAR lFileXls AS CHAR NO-UNDO.

lNuevoFile = YES.

{lib/excel-open-file.i}

DEF VAR x-CtoTot LIKE Almmmatg.ctotot NO-UNDO.
DEF VAR x-PreVta LIKE Almmmatg.prevta NO-UNDO.
DEF VAR x-PreOfi LIKE Almmmatg.preofi NO-UNDO.

ASSIGN
    chWorkSheet:Range("A1"):Value = "ERRORES - PRECIOS"
    chWorkSheet:Range("A2"):Value = "CODIGO"
    chWorkSheet:Columns("A"):NumberFormat = "@"
    chWorkSheet:Range("B2"):Value = "DESCRIPCION"
    chWorkSheet:Range("C2"):Value = "ERROR".
ASSIGN
    iRow = 2.
FOR EACH E-MATG:
    ASSIGN
        iColumn = 0
        iRow    = iRow + 1.
    ASSIGN
        iColumn = iColumn + 1
        chWorkSheet:Cells(iRow, iColumn):VALUE = E-MATG.codmat.
    ASSIGN
        iColumn = iColumn + 1
        chWorkSheet:Cells(iRow, iColumn):VALUE = E-MATG.desmat.
    ASSIGN
        iColumn = iColumn + 1
        chWorkSheet:Cells(iRow, iColumn):VALUE = E-MATG.Libre_c01.
END.
/* 2do ALERTAS */
/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(2).
ASSIGN
    chWorkSheet:Range("A1"):Value = "ALERTAS - PRECIOS"
    chWorkSheet:Range("A2"):Value = "CODIGO"
    chWorkSheet:Columns("A"):NumberFormat = "@"
    chWorkSheet:Range("B2"):Value = "DESCRIPCION"
    chWorkSheet:Range("C2"):Value = "ALERTA".
ASSIGN
    iRow = 2.
FOR EACH A-MATG:
    ASSIGN
        iColumn = 0
        iRow    = iRow + 1.
    ASSIGN
        iColumn = iColumn + 1
        chWorkSheet:Cells(iRow, iColumn):VALUE = A-MATG.codmat.
    ASSIGN
        iColumn = iColumn + 1
        chWorkSheet:Cells(iRow, iColumn):VALUE = A-MATG.desmat.
    ASSIGN
        iColumn = iColumn + 1
        chWorkSheet:Cells(iRow, iColumn):VALUE = A-MATG.Libre_c01.
END.
lCerrarAlTerminar = NO.     /* Hace visible y editable la hoja de cálculo */
lMensajeAlTerminar = NO.

{lib/excel-close-file.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRI_Graba-Dscto-Prom-Divi) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PRI_Graba-Dscto-Prom-Divi Procedure 
PROCEDURE PRI_Graba-Dscto-Prom-Divi :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{pri/PRI_Graba-Dscto-Prom-Divi.i &b-Tabla="b-VtaDctoProm" &Tabla="VtaDctoProm"}

/* DEFINE INPUT PARAMETER pReemplazar AS LOG.                                                                                        */
/* DEFINE INPUT PARAMETER pCodDiv AS CHAR.                                                                                           */
/* DEFINE INPUT PARAMETER pCodMat AS CHAR.                                                                                           */
/* DEFINE INPUT PARAMETER pPreOfi AS DECI.                                                                                           */
/* DEFINE INPUT PARAMETE pFchPrmD AS DATE.                                                                                           */
/* DEFINE INPUT PARAMETER pFchPrmH AS DATE.                                                                                          */
/* DEFINE INPUT PARAMETER pDescuentoVIP AS DECI.                                                                                     */
/* DEFINE INPUT PARAMETER pDescuentoMR  AS DECI.                                                                                     */
/* DEFINE INPUT PARAMETER pDescuento    AS DECI.                                                                                     */
/* DEFINE OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.                                                                                 */
/*                                                                                                                                   */
/* DEFINE VAR x-PreUni AS DECI NO-UNDO.                                                                                              */
/* DEFINE VAR pCuenta AS INTE NO-UNDO.                                                                                               */
/*                                                                                                                                   */
/* x-PreUni = pPreOfi.                                                                                                               */
/* CASE pReemplazar:                                                                                                                 */
/*     WHEN NO THEN DO:                                                                                                              */
/*         /* 1ro. Limpiamos información vigente */                                                                                  */
/*         FOR EACH VtaDctoProm EXCLUSIVE-LOCK WHERE VtaDctoProm.CodCia = s-CodCia AND                                               */
/*             VtaDctoProm.CodDiv = pCodDiv AND                                                                                      */
/*             VtaDctoProm.CodMat = pCodMat AND                                                                                      */
/*             VtaDctoProm.FchIni = pFchPrmD AND                                                                                     */
/*             VtaDctoProm.FchFin = pFchPrmH AND                                                                                     */
/*             VtaDctoProm.FlgEst = "A":                                                                                             */
/*             ASSIGN                                                                                                                */
/*                 VtaDctoProm.FlgEst  = "I"                                                                                         */
/*                 VtaDctoProm.FchAnulacion  = TODAY                                                                                 */
/*                 VtaDctoProm.HoraAnulacion = STRING(TIME, 'HH:MM:SS')                                                              */
/*                 VtaDctoProm.UsrAnulacion = s-user-id.                                                                             */
/*         END.                                                                                                                      */
/*         /* todas las promociones por producto */                                                                                  */
/*         CREATE VtaDctoProm.                                                                                                       */
/*         ASSIGN                                                                                                                    */
/*             VtaDctoProm.CodCia = s-CodCia                                                                                         */
/*             VtaDctoProm.CodDiv = pCodDiv                                                                                          */
/*             VtaDctoProm.CodMat = pCodMat                                                                                          */
/*             VtaDctoProm.FchIni = pFchPrmD                                                                                         */
/*             VtaDctoProm.FchFin = pFchPrmH                                                                                         */
/*             VtaDctoProm.DescuentoVIP = pDescuentoVIP                                                                              */
/*             VtaDctoProm.DescuentoMR = pDescuentoMR                                                                                */
/*             VtaDctoProm.Descuento = pDescuento                                                                                    */
/*             VtaDctoProm.UsrCreacion = s-User-Id                                                                                   */
/*             VtaDctoProm.FchCreacion = TODAY                                                                                       */
/*             VtaDctoProm.HoraCreacion = STRING(TIME, 'HH:MM:SS').                                                                  */
/*         IF VtaDctoProm.DescuentoVIP > 0 THEN VtaDctoProm.PrecioVIP = ROUND(x-PreUni * (1 - (VtaDctoProm.DescuentoVIP / 100)), 4). */
/*         IF VtaDctoProm.DescuentoMR  > 0 THEN VtaDctoProm.PrecioMR  = ROUND(x-PreUni * (1 - (VtaDctoProm.DescuentoMR / 100)), 4).  */
/*         IF VtaDctoProm.Descuento    > 0 THEN VtaDctoProm.Precio    = ROUND(x-PreUni * (1 - (VtaDctoProm.Descuento / 100)), 4).    */
/*     END.                                                                                                                          */
/*     WHEN YES THEN DO:                                                                                                             */
/*         /* ****************************************************************************************** */                          */
/*         /* 1ro. Buscamos promoción que cuya fecha de inicio se encuentre dentro de la nueva promoción */                          */
/*         /* ****************************************************************************************** */                          */
/*         FOR EACH b-VtaDctoProm EXCLUSIVE-LOCK WHERE b-VtaDctoProm.CodCia = s-CodCia                                               */
/*             AND b-VtaDctoProm.CodDiv = pCodDiv                                                                                    */
/*             AND b-VtaDctoProm.CodMat = pCodMat                                                                                    */
/*             AND b-VtaDctoProm.FlgEst = "A"                                                                                        */
/*             AND b-VtaDctoProm.FchIni >= pFchPrmD                                                                                  */
/*             AND b-VtaDctoProm.FchIni <= pFchPrmH:                                                                                 */
/*             IF b-VtaDctoProm.FchFin <= pFchPrmH THEN DO:                                                                          */
/*                 /* La promoción se encuentra dentro de la nueva promoción => es absorvida por la nueva promoción */               */
/*                 ASSIGN                                                                                                            */
/*                     b-VtaDctoProm.FlgEst = "I"                                                                                    */
/*                     b-VtaDctoProm.FchAnulacion = TODAY                                                                            */
/*                     b-VtaDctoProm.UsrAnulacion = s-user-id                                                                        */
/*                     b-VtaDctoProm.HoraAnulacion = STRING(TIME, 'HH:MM:SS').                                                       */
/*             END.                                                                                                                  */
/*             ELSE DO:                                                                                                              */
/*                 /* Se inactiva y se genera una nueva con nuevos vencimientos */                                                   */
/*                 CREATE VtaDctoProm.                                                                                               */
/*                 BUFFER-COPY b-VtaDctoProm TO VtaDctoProm                                                                          */
/*                     ASSIGN                                                                                                        */
/*                     VtaDctoProm.FlgEst = "A"                                                                                      */
/*                     VtaDctoProm.FchIni = pFchPrmH + 1       /* OJO */                                                             */
/*                     VtaDctoProm.HoraCreacion = STRING(TIME, 'HH:MM:SS')                                                           */
/*                     VtaDctoProm.FchCreacion = TODAY                                                                               */
/*                     VtaDctoProm.UsrCreacion = s-user-id.                                                                          */
/*                 ASSIGN                                                                                                            */
/*                     b-VtaDctoProm.FlgEst = "I"                                                                                    */
/*                     b-VtaDctoProm.FchAnulacion = TODAY                                                                            */
/*                     b-VtaDctoProm.UsrAnulacion = s-user-id                                                                        */
/*                     b-VtaDctoProm.HoraAnulacion = STRING(TIME, 'HH:MM:SS').                                                       */
/*             END.                                                                                                                  */
/*         END.                                                                                                                      */
/*         /* ****************************************************************************************** */                          */
/*         /* 2do. Buscamos promoción que cuya fecha de fin sea >= de la de fin de la nueva promoción    */                          */
/*         /* ****************************************************************************************** */                          */
/*         FOR EACH b-VtaDctoProm EXCLUSIVE-LOCK WHERE b-VtaDctoProm.CodCia = s-CodCia                                               */
/*             AND b-VtaDctoProm.CodDiv = pCodDiv                                                                                    */
/*             AND b-VtaDctoProm.CodMat = pCodMat                                                                                    */
/*             AND b-VtaDctoProm.FlgEst = "A"                                                                                        */
/*             AND b-VtaDctoProm.FchIni < pFchPrmD                                                                                   */
/*             AND b-VtaDctoProm.FchFin >= pFchPrmD:                                                                                 */
/*             /* Se inactiva y se generan hasta 2 una con nuevos vencimientos */                                                    */
/*             CREATE VtaDctoProm.                                                                                                   */
/*             BUFFER-COPY b-VtaDctoProm TO VtaDctoProm                                                                              */
/*                 ASSIGN                                                                                                            */
/*                 VtaDctoProm.FlgEst = "A"                                                                                          */
/*                 VtaDctoProm.FchFin = pFchPrmD - 1       /* OJO */                                                                 */
/*                 VtaDctoProm.HoraCreacion = STRING(TIME, 'HH:MM:SS')                                                               */
/*                 VtaDctoProm.FchCreacion = TODAY                                                                                   */
/*                 VtaDctoProm.UsrCreacion = s-user-id.                                                                              */
/*             IF b-VtaDctoProm.FchFin > pFchPrmH THEN DO:                                                                           */
/*                 CREATE VtaDctoProm.                                                                                               */
/*                 BUFFER-COPY b-VtaDctoProm TO VtaDctoProm                                                                          */
/*                     ASSIGN                                                                                                        */
/*                     VtaDctoProm.FlgEst = "A"                                                                                      */
/*                     VtaDctoProm.FchIni = pFchPrmH + 1       /* OJO */                                                             */
/*                     VtaDctoProm.HoraCreacion = STRING(TIME, 'HH:MM:SS')                                                           */
/*                     VtaDctoProm.FchCreacion = TODAY                                                                               */
/*                     VtaDctoProm.UsrCreacion = s-user-id.                                                                          */
/*             END.                                                                                                                  */
/*             ASSIGN                                                                                                                */
/*                 b-VtaDctoProm.FlgEst = "I"                                                                                        */
/*                 b-VtaDctoProm.FchAnulacion = TODAY                                                                                */
/*                 b-VtaDctoProm.UsrAnulacion = s-user-id                                                                            */
/*                 b-VtaDctoProm.HoraAnulacion = STRING(TIME, 'HH:MM:SS').                                                           */
/*         END.                                                                                                                      */
/*         /* ****************************************************************************************** */                          */
/*         /* 3ro. Grabamos la nueva promoción */                                                                                    */
/*         /* ****************************************************************************************** */                          */
/*         CREATE VtaDctoProm.                                                                                                       */
/*         ASSIGN                                                                                                                    */
/*             VtaDctoProm.codcia = s-CodCia                                                                                         */
/*             VtaDctoProm.FlgEst = "A"                                                                                              */
/*             VtaDctoProm.CodDiv = pCodDiv                                                                                          */
/*             VtaDctoProm.CodMat = pCodMat                                                                                          */
/*             VtaDctoProm.FchIni = pFchPrmD                                                                                         */
/*             VtaDctoProm.FchFin = pFchPrmH                                                                                         */
/*             VtaDctoProm.FchCreacion = TODAY                                                                                       */
/*             VtaDctoProm.HoraCreacion = STRING(TIME, 'HH:MM:SS')                                                                   */
/*             VtaDctoProm.UsrCreacion = s-user-id                                                                                   */
/*             VtaDctoProm.Descuento    = pDescuento                                                                                 */
/*             VtaDctoProm.DescuentoMR  = pDescuentoMR                                                                               */
/*             VtaDctoProm.DescuentoVIP = pDescuentoVIP.                                                                             */
/*         IF VtaDctoProm.DescuentoVIP > 0 THEN VtaDctoProm.PrecioVIP = ROUND(x-PreUni * (1 - (VtaDctoProm.DescuentoVIP / 100)), 4). */
/*         IF VtaDctoProm.DescuentoMR  > 0 THEN VtaDctoProm.PrecioMR  = ROUND(x-PreUni * (1 - (VtaDctoProm.DescuentoMR / 100)), 4).  */
/*         IF VtaDctoProm.Descuento    > 0 THEN VtaDctoProm.Precio    = ROUND(x-PreUni * (1 - (VtaDctoProm.Descuento / 100)), 4).    */
/*     END.                                                                                                                          */
/* END CASE.                                                                                                                         */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRI_Graba-Dscto-Prom-May) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PRI_Graba-Dscto-Prom-May Procedure 
PROCEDURE PRI_Graba-Dscto-Prom-May :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Por cada Artículo
------------------------------------------------------------------------------*/

{pri/PRI_Graba-Dscto-Prom.i &t-Tabla="t-VtaDctoProm" &b-Tabla="b-VtaDctoProm" &Tabla="VtaDctoProm"}

/* DEFINE INPUT PARAMETER pReemplazar AS LOG.                                                                              */
/* DEFINE INPUT PARAMETER pCodMat AS CHAR.                                                                                 */
/* DEFINE INPUT-OUTPUT PARAMETER TABLE FOR t-VtaDctoProm.                                                                  */
/* DEFINE INPUT PARAMETER x-MetodoActualizacion AS INTE.                                                                   */
/* DEFINE INPUT PARAMETER f-Division AS CHAR.                                                                              */
/* DEFINE OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.                                                                       */
/*                                                                                                                         */
/* DEFINE VAR pCuenta AS INTE NO-UNDO.                                                                                     */
/*                                                                                                                         */
/* CASE pReemplazar:                                                                                                       */
/*     WHEN NO THEN DO:                                                                                                    */
/*         FOR EACH t-VtaDctoProm EXCLUSIVE-LOCK WHERE t-VtaDctoProm.CodCia = s-CodCia                                     */
/*             AND t-VtaDctoProm.CodMat = pCodMat,                                                                         */
/*             FIRST Almmmatg OF t-VtaDctoProm NO-LOCK:                                                                    */
/*             IF x-MetodoActualizacion = 2 AND t-VtaDctoProm.CodDiv <> f-Division THEN NEXT.                              */
/*             FIND VtaDctoProm WHERE VtaDctoProm.CodCia = t-VtaDctoProm.CodCia AND                                        */
/*                 VtaDctoProm.CodDiv = t-VtaDctoProm.CodDiv AND                                                           */
/*                 VtaDctoProm.CodMat = t-VtaDctoProm.CodMat AND                                                           */
/*                 VtaDctoProm.FchIni = t-VtaDctoProm.FchIni AND                                                           */
/*                 VtaDctoProm.FchFin = t-VtaDctoProm.FchFin AND                                                           */
/*                 VtaDCtoProm.FlgEst = "A"                                                                                */
/*                 NO-LOCK NO-ERROR.                                                                                       */
/*             IF AVAILABLE VtaDctoProm THEN DO:                                                                           */
/*                 FIND CURRENT VtaDctoProm EXCLUSIVE-LOCK NO-ERROR NO-WAIT.                                               */
/*                 IF ERROR-STATUS:ERROR = YES THEN DO:                                                                    */
/*                     {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}                            */
/*                     UNDO, NEXT.                                                                                         */
/*                 END.                                                                                                    */
/*                 ASSIGN                                                                                                  */
/*                     VtaDctoProm.FchModificacion = TODAY                                                                 */
/*                     VtaDctoProm.HoraModificacion = STRING(TIME, 'HH:MM:SS')                                             */
/*                     VtaDctoProm.UsrModificacion = s-user-id.                                                            */
/*             END.                                                                                                        */
/*             ELSE DO:                                                                                                    */
/*                 CREATE VtaDctoProm.                                                                                     */
/*                 ASSIGN                                                                                                  */
/*                     VtaDctoProm.codcia = t-VtaDctoProm.CodCia                                                           */
/*                     VtaDCtoProm.FlgEst = "A"                                                                            */
/*                     VtaDctoProm.CodDiv = t-VtaDctoProm.CodDiv                                                           */
/*                     VtaDctoProm.CodMat = t-VtaDctoProm.CodMat                                                           */
/*                     VtaDctoProm.FchIni = t-VtaDctoProm.FchIni                                                           */
/*                     VtaDctoProm.FchFin = t-VtaDctoProm.FchFin                                                           */
/*                     VtaDctoProm.FchCreacion = TODAY                                                                     */
/*                     VtaDctoProm.HoraCreacion = STRING(TIME, 'HH:MM:SS')                                                 */
/*                     VtaDctoProm.UsrCreacion = s-user-id.                                                                */
/*             END.                                                                                                        */
/*             ASSIGN                                                                                                      */
/*                 VtaDctoProm.Descuento    = t-VtaDctoProm.Descuento                                                      */
/*                 VtaDctoProm.DescuentoMR  = t-VtaDctoProm.DescuentoMR                                                    */
/*                 VtaDctoProm.DescuentoVIP = t-VtaDctoProm.DescuentoVIP                                                   */
/*                 VtaDctoProm.Precio    = ROUND(Almmmatg.PreVta[1] * (1 - (t-VtaDctoProm.Descuento / 100)), 4)            */
/*                 VtaDctoProm.PrecioMR  = ROUND(Almmmatg.PreVta[1] * (1 - (t-VtaDctoProm.DescuentoMR / 100)), 4)          */
/*                 VtaDctoProm.PrecioVIP = ROUND(Almmmatg.PreVta[1] * (1 - (t-VtaDctoProm.DescuentoVIP / 100)), 4).        */
/*             DELETE t-VtaDctoProm.                                                                                       */
/*         END.                                                                                                            */
/*     END.                                                                                                                */
/*     WHEN YES THEN DO:                                                                                                   */
/*         FOR EACH t-VtaDctoProm EXCLUSIVE-LOCK WHERE t-VtaDctoProm.CodCia = s-CodCia                                     */
/*             AND t-VtaDctoProm.CodMat = pCodMat,                                                                         */
/*             FIRST Almmmatg OF t-VtaDctoProm NO-LOCK:                                                                    */
/*             IF x-MetodoActualizacion = 2 AND t-VtaDctoProm.CodDiv <> f-Division THEN NEXT.                              */
/*             /* ****************************************************************************************** */            */
/*             /* 1ro. Buscamos promoción que cuya fecha de inicio se encuentre dentro de la nueva promoción */            */
/*             /* ****************************************************************************************** */            */
/*             FOR EACH b-VtaDctoProm EXCLUSIVE-LOCK WHERE b-VtaDctoProm.CodCia = t-VtaDctoProm.CodCia                     */
/*                 AND b-VtaDctoProm.CodDiv = t-VtaDctoProm.CodDiv                                                         */
/*                 AND b-VtaDctoProm.CodMat = t-VtaDctoProm.CodMat                                                         */
/*                 AND b-VtaDctoProm.FlgEst = "A"                                                                          */
/*                 AND b-VtaDctoProm.FchIni >= t-VtaDctoProm.FchIni                                                        */
/*                 AND b-VtaDctoProm.FchIni <= t-VtaDctoProm.FchFin:                                                       */
/*                 IF b-VtaDctoProm.FchFin <= t-VtaDctoProm.FchFin THEN DO:                                                */
/*                     /* La promoción se encuentra dentro de la nueva promoción => es absorvida por la nueva promoción */ */
/*                     ASSIGN                                                                                              */
/*                         b-VtaDctoProm.FlgEst = "I"                                                                      */
/*                         b-VtaDctoProm.FchAnulacion = TODAY                                                              */
/*                         b-VtaDctoProm.UsrAnulacion = s-user-id                                                          */
/*                         b-VtaDctoProm.HoraAnulacion = STRING(TIME, 'HH:MM:SS').                                         */
/*                 END.                                                                                                    */
/*                 ELSE DO:                                                                                                */
/*                     /* Se inactiva y se genera una nueva con nuevos vencimientos */                                     */
/*                     CREATE VtaDctoProm.                                                                                 */
/*                     BUFFER-COPY b-VtaDctoProm TO VtaDctoProm                                                            */
/*                         ASSIGN                                                                                          */
/*                         VtaDctoProm.FlgEst = "A"                                                                        */
/*                         VtaDctoProm.FchIni = t-VtaDctoProm.FchFin + 1       /* OJO */                                   */
/*                         VtaDctoProm.HoraCreacion = STRING(TIME, 'HH:MM:SS')                                             */
/*                         VtaDctoProm.FchCreacion = TODAY                                                                 */
/*                         VtaDctoProm.UsrCreacion = s-user-id.                                                            */
/*                     ASSIGN                                                                                              */
/*                         b-VtaDctoProm.FlgEst = "I"                                                                      */
/*                         b-VtaDctoProm.FchAnulacion = TODAY                                                              */
/*                         b-VtaDctoProm.UsrAnulacion = s-user-id                                                          */
/*                         b-VtaDctoProm.HoraAnulacion = STRING(TIME, 'HH:MM:SS').                                         */
/*                 END.                                                                                                    */
/*             END.                                                                                                        */
/*             /* ****************************************************************************************** */            */
/*             /* 2do. Buscamos promoción que cuya fecha de fin sea >= de la de fin de la nueva promoción    */            */
/*             /* ****************************************************************************************** */            */
/*             FOR EACH b-VtaDctoProm EXCLUSIVE-LOCK WHERE b-VtaDctoProm.CodCia = t-VtaDctoProm.CodCia                     */
/*                 AND b-VtaDctoProm.CodDiv = t-VtaDctoProm.CodDiv                                                         */
/*                 AND b-VtaDctoProm.CodMat = t-VtaDctoProm.CodMat                                                         */
/*                 AND b-VtaDctoProm.FlgEst = "A"                                                                          */
/*                 AND b-VtaDctoProm.FchIni < t-VtaDctoProm.FchIni                                                         */
/*                 AND b-VtaDctoProm.FchFin >= t-VtaDctoProm.FchIni:                                                       */
/*                 /* Se inactiva y se generan hasta 2 una con nuevos vencimientos */                                      */
/*                 CREATE VtaDctoProm.                                                                                     */
/*                 BUFFER-COPY b-VtaDctoProm TO VtaDctoProm                                                                */
/*                     ASSIGN                                                                                              */
/*                     VtaDctoProm.FlgEst = "A"                                                                            */
/*                     VtaDctoProm.FchFin = t-VtaDctoProm.FchIni - 1       /* OJO */                                       */
/*                     VtaDctoProm.HoraCreacion = STRING(TIME, 'HH:MM:SS')                                                 */
/*                     VtaDctoProm.FchCreacion = TODAY                                                                     */
/*                     VtaDctoProm.UsrCreacion = s-user-id.                                                                */
/*                 IF b-VtaDctoProm.FchFin > t-VtaDctoProm.FchFin THEN DO:                                                 */
/*                     CREATE VtaDctoProm.                                                                                 */
/*                     BUFFER-COPY b-VtaDctoProm TO VtaDctoProm                                                            */
/*                         ASSIGN                                                                                          */
/*                         VtaDctoProm.FlgEst = "A"                                                                        */
/*                         VtaDctoProm.FchIni = t-VtaDctoProm.FchFin + 1       /* OJO */                                   */
/*                         VtaDctoProm.HoraCreacion = STRING(TIME, 'HH:MM:SS')                                             */
/*                         VtaDctoProm.FchCreacion = TODAY                                                                 */
/*                         VtaDctoProm.UsrCreacion = s-user-id.                                                            */
/*                 END.                                                                                                    */
/*                 ASSIGN                                                                                                  */
/*                     b-VtaDctoProm.FlgEst = "I"                                                                          */
/*                     b-VtaDctoProm.FchAnulacion = TODAY                                                                  */
/*                     b-VtaDctoProm.UsrAnulacion = s-user-id                                                              */
/*                     b-VtaDctoProm.HoraAnulacion = STRING(TIME, 'HH:MM:SS').                                             */
/*             END.                                                                                                        */
/*             /* ****************************************************************************************** */            */
/*             /* 3ro. Grabamos la nueva promoción */                                                                      */
/*             /* ****************************************************************************************** */            */
/*             CREATE VtaDctoProm.                                                                                         */
/*             ASSIGN                                                                                                      */
/*                 VtaDctoProm.codcia = t-VtaDctoProm.CodCia                                                               */
/*                 VtaDCtoProm.FlgEst = "A"                                                                                */
/*                 VtaDctoProm.CodDiv = t-VtaDctoProm.CodDiv                                                               */
/*                 VtaDctoProm.CodMat = t-VtaDctoProm.CodMat                                                               */
/*                 VtaDctoProm.FchIni = t-VtaDctoProm.FchIni                                                               */
/*                 VtaDctoProm.FchFin = t-VtaDctoProm.FchFin                                                               */
/*                 VtaDctoProm.FchCreacion = TODAY                                                                         */
/*                 VtaDctoProm.HoraCreacion = STRING(TIME, 'HH:MM:SS')                                                     */
/*                 VtaDctoProm.UsrCreacion = s-user-id                                                                     */
/*                 VtaDctoProm.Descuento    = t-VtaDctoProm.Descuento                                                      */
/*                 VtaDctoProm.DescuentoMR  = t-VtaDctoProm.DescuentoMR                                                    */
/*                 VtaDctoProm.DescuentoVIP = t-VtaDctoProm.DescuentoVIP                                                   */
/*                 VtaDctoProm.Precio    = ROUND(Almmmatg.PreVta[1] * (1 - (t-VtaDctoProm.Descuento / 100)), 4)            */
/*                 VtaDctoProm.PrecioMR  = ROUND(Almmmatg.PreVta[1] * (1 - (t-VtaDctoProm.DescuentoMR / 100)), 4)          */
/*                 VtaDctoProm.PrecioVIP = ROUND(Almmmatg.PreVta[1] * (1 - (t-VtaDctoProm.DescuentoVIP / 100)), 4).        */
/*             DELETE t-VtaDctoProm.                                                                                       */
/*         END.                                                                                                            */
/*     END.                                                                                                                */
/* END CASE.                                                                                                               */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRI_Graba-Dscto-Prom-Min) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PRI_Graba-Dscto-Prom-Min Procedure 
PROCEDURE PRI_Graba-Dscto-Prom-Min :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{pri/PRI_Graba-Dscto-Prom-Utilex.i &t-Tabla="t-VtaDctoProm" &b-Tabla="b-VtaDctoPromMin" &Tabla="VtaDctoPromMin"}

/* DEFINE INPUT PARAMETER pReemplazar AS LOG.                                                                              */
/* DEFINE INPUT PARAMETER pCodMat AS CHAR.                                                                                 */
/* DEFINE INPUT-OUTPUT PARAMETER TABLE FOR t-VtaDctoPromMin.                                                               */
/* DEFINE INPUT PARAMETER x-MetodoActualizacion AS INTE.                                                                   */
/* DEFINE INPUT PARAMETER f-Division AS CHAR.                                                                              */
/* DEFINE OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.                                                                       */
/*                                                                                                                         */
/* DEFINE VAR pCuenta AS INTE NO-UNDO.                                                                                     */
/*                                                                                                                         */
/* CASE pReemplazar:                                                                                                       */
/*     WHEN NO THEN DO:                                                                                                    */
/*         FOR EACH t-VtaDctoPromMin EXCLUSIVE-LOCK WHERE t-VtaDctoPromMin.CodCia = s-CodCia                               */
/*             AND t-VtaDctoPromMin.CodMat = pCodMat,                                                                      */
/*             FIRST Almmmatg OF t-VtaDctoPromMin NO-LOCK:                                                                 */
/*             IF x-MetodoActualizacion = 2 AND t-VtaDctoPromMin.CodDiv <> f-Division THEN NEXT.                           */
/*             FIND VtaDctoPromMin WHERE VtaDctoPromMin.CodCia = t-VtaDctoPromMin.CodCia AND                               */
/*                 VtaDctoPromMin.CodDiv = t-VtaDctoPromMin.CodDiv AND                                                     */
/*                 VtaDctoPromMin.CodMat = t-VtaDctoPromMin.CodMat AND                                                     */
/*                 VtaDctoPromMin.FchIni = t-VtaDctoPromMin.FchIni AND                                                     */
/*                 VtaDctoPromMin.FchFin = t-VtaDctoPromMin.FchFin AND                                                     */
/*                 VtaDctoPromMin.FlgEst = "A"                                                                             */
/*                 NO-LOCK NO-ERROR.                                                                                       */
/*             IF AVAILABLE VtaDctoPromMin THEN DO:                                                                        */
/*                 FIND CURRENT VtaDctoPromMin EXCLUSIVE-LOCK NO-ERROR NO-WAIT.                                            */
/*                 IF ERROR-STATUS:ERROR = YES THEN DO:                                                                    */
/*                     {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}                            */
/*                     UNDO, NEXT.                                                                                         */
/*                 END.                                                                                                    */
/*                 ASSIGN                                                                                                  */
/*                     VtaDctoPromMin.FchModificacion = TODAY                                                              */
/*                     VtaDctoPromMin.HoraModificacion = STRING(TIME, 'HH:MM:SS')                                          */
/*                     VtaDctoPromMin.UsrModificacion = s-user-id.                                                         */
/*             END.                                                                                                        */
/*             ELSE DO:                                                                                                    */
/*                 CREATE VtaDctoPromMin.                                                                                  */
/*                 ASSIGN                                                                                                  */
/*                     VtaDctoPromMin.codcia = t-VtaDctoPromMin.CodCia                                                     */
/*                     VtaDctoPromMin.FlgEst = "A"                                                                         */
/*                     VtaDctoPromMin.CodDiv = t-VtaDctoPromMin.CodDiv                                                     */
/*                     VtaDctoPromMin.CodMat = t-VtaDctoPromMin.CodMat                                                     */
/*                     VtaDctoPromMin.FchIni = t-VtaDctoPromMin.FchIni                                                     */
/*                     VtaDctoPromMin.FchFin = t-VtaDctoPromMin.FchFin                                                     */
/*                     VtaDctoPromMin.FchCreacion = TODAY                                                                  */
/*                     VtaDctoPromMin.HoraCreacion = STRING(TIME, 'HH:MM:SS')                                              */
/*                     VtaDctoPromMin.UsrCreacion = s-user-id.                                                             */
/*             END.                                                                                                        */
/*             ASSIGN                                                                                                      */
/*                 VtaDctoPromMin.Descuento    = t-VtaDctoPromMin.Descuento                                                */
/*                 VtaDctoPromMin.DescuentoMR  = t-VtaDctoPromMin.DescuentoMR                                              */
/*                 VtaDctoPromMin.DescuentoVIP = t-VtaDctoPromMin.DescuentoVIP                                             */
/*                 VtaDctoPromMin.Precio    = ROUND(Almmmatg.PreVta[1] * (1 - (t-VtaDctoPromMin.Descuento / 100)), 4)      */
/*                 VtaDctoPromMin.PrecioMR  = ROUND(Almmmatg.PreVta[1] * (1 - (t-VtaDctoPromMin.DescuentoMR / 100)), 4)    */
/*                 VtaDctoPromMin.PrecioVIP = ROUND(Almmmatg.PreVta[1] * (1 - (t-VtaDctoPromMin.DescuentoVIP / 100)), 4).  */
/*             DELETE t-VtaDctoPromMin.                                                                                    */
/*         END.                                                                                                            */
/*     END.                                                                                                                */
/*     WHEN YES THEN DO:                                                                                                   */
/*         FOR EACH t-VtaDctoPromMin EXCLUSIVE-LOCK WHERE t-VtaDctoPromMin.CodCia = s-CodCia                               */
/*             AND t-VtaDctoPromMin.CodMat = pCodMat,                                                                      */
/*             FIRST Almmmatg OF t-VtaDctoPromMin NO-LOCK:                                                                 */
/*             IF x-MetodoActualizacion = 2 AND t-VtaDctoPromMin.CodDiv <> f-Division THEN NEXT.                           */
/*             /* ****************************************************************************************** */            */
/*             /* 1ro. Buscamos promoción que cuya fecha de inicio se encuentre dentro de la nueva promoción */            */
/*             /* ****************************************************************************************** */            */
/*             FOR EACH b-VtaDctoPromMin EXCLUSIVE-LOCK WHERE b-VtaDctoPromMin.CodCia = t-VtaDctoPromMin.CodCia            */
/*                 AND b-VtaDctoPromMin.CodDiv = t-VtaDctoPromMin.CodDiv                                                   */
/*                 AND b-VtaDctoPromMin.CodMat = t-VtaDctoPromMin.CodMat                                                   */
/*                 AND b-VtaDctoPromMin.FlgEst = "A"                                                                       */
/*                 AND b-VtaDctoPromMin.FchIni >= t-VtaDctoPromMin.FchIni                                                  */
/*                 AND b-VtaDctoPromMin.FchIni <= t-VtaDctoPromMin.FchFin:                                                 */
/*                 IF b-VtaDctoPromMin.FchFin <= t-VtaDctoPromMin.FchFin THEN DO:                                          */
/*                     /* La promoción se encuentra dentro de la nueva promoción => es absorvida por la nueva promoción */ */
/*                     ASSIGN                                                                                              */
/*                         b-VtaDctoPromMin.FlgEst = "I"                                                                   */
/*                         b-VtaDctoPromMin.FchAnulacion = TODAY                                                           */
/*                         b-VtaDctoPromMin.UsrAnulacion = s-user-id                                                       */
/*                         b-VtaDctoPromMin.HoraAnulacion = STRING(TIME, 'HH:MM:SS').                                      */
/*                 END.                                                                                                    */
/*                 ELSE DO:                                                                                                */
/*                     /* Se inactiva y se genera una nueva con nuevos vencimientos */                                     */
/*                     CREATE VtaDctoPromMin.                                                                              */
/*                     BUFFER-COPY b-VtaDctoPromMin TO VtaDctoPromMin                                                      */
/*                         ASSIGN                                                                                          */
/*                         VtaDctoPromMin.FlgEst = "A"                                                                     */
/*                         VtaDctoPromMin.FchIni = t-VtaDctoPromMin.FchFin + 1       /* OJO */                             */
/*                         VtaDctoPromMin.HoraCreacion = STRING(TIME, 'HH:MM:SS')                                          */
/*                         VtaDctoPromMin.FchCreacion = TODAY                                                              */
/*                         VtaDctoPromMin.UsrCreacion = s-user-id.                                                         */
/*                     ASSIGN                                                                                              */
/*                         b-VtaDctoPromMin.FlgEst = "I"                                                                   */
/*                         b-VtaDctoPromMin.FchAnulacion = TODAY                                                           */
/*                         b-VtaDctoPromMin.UsrAnulacion = s-user-id                                                       */
/*                         b-VtaDctoPromMin.HoraAnulacion = STRING(TIME, 'HH:MM:SS').                                      */
/*                 END.                                                                                                    */
/*             END.                                                                                                        */
/*             /* ****************************************************************************************** */            */
/*             /* 2do. Buscamos promoción que cuya fecha de fin sea >= de la de fin de la nueva promoción    */            */
/*             /* ****************************************************************************************** */            */
/*             FOR EACH b-VtaDctoPromMin EXCLUSIVE-LOCK WHERE b-VtaDctoPromMin.CodCia = t-VtaDctoPromMin.CodCia            */
/*                 AND b-VtaDctoPromMin.CodDiv = t-VtaDctoPromMin.CodDiv                                                   */
/*                 AND b-VtaDctoPromMin.CodMat = t-VtaDctoPromMin.CodMat                                                   */
/*                 AND b-VtaDctoPromMin.FlgEst = "A"                                                                       */
/*                 AND b-VtaDctoPromMin.FchIni < t-VtaDctoPromMin.FchIni                                                   */
/*                 AND b-VtaDctoPromMin.FchFin >= t-VtaDctoPromMin.FchIni:                                                 */
/*                 /* Se inactiva y se generan hasta 2 una con nuevos vencimientos */                                      */
/*                 CREATE VtaDctoPromMin.                                                                                  */
/*                 BUFFER-COPY b-VtaDctoPromMin TO VtaDctoPromMin                                                          */
/*                     ASSIGN                                                                                              */
/*                     VtaDctoPromMin.FlgEst = "A"                                                                         */
/*                     VtaDctoPromMin.FchFin = t-VtaDctoPromMin.FchIni - 1       /* OJO */                                 */
/*                     VtaDctoPromMin.HoraCreacion = STRING(TIME, 'HH:MM:SS')                                              */
/*                     VtaDctoPromMin.FchCreacion = TODAY                                                                  */
/*                     VtaDctoPromMin.UsrCreacion = s-user-id.                                                             */
/*                 IF b-VtaDctoPromMin.FchFin > t-VtaDctoPromMin.FchFin THEN DO:                                           */
/*                     CREATE VtaDctoPromMin.                                                                              */
/*                     BUFFER-COPY b-VtaDctoPromMin TO VtaDctoPromMin                                                      */
/*                         ASSIGN                                                                                          */
/*                         VtaDctoPromMin.FlgEst = "A"                                                                     */
/*                         VtaDctoPromMin.FchIni = t-VtaDctoPromMin.FchFin + 1       /* OJO */                             */
/*                         VtaDctoPromMin.HoraCreacion = STRING(TIME, 'HH:MM:SS')                                          */
/*                         VtaDctoPromMin.FchCreacion = TODAY                                                              */
/*                         VtaDctoPromMin.UsrCreacion = s-user-id.                                                         */
/*                 END.                                                                                                    */
/*                 ASSIGN                                                                                                  */
/*                     b-VtaDctoPromMin.FlgEst = "I"                                                                       */
/*                     b-VtaDctoPromMin.FchAnulacion = TODAY                                                               */
/*                     b-VtaDctoPromMin.UsrAnulacion = s-user-id                                                           */
/*                     b-VtaDctoPromMin.HoraAnulacion = STRING(TIME, 'HH:MM:SS').                                          */
/*             END.                                                                                                        */
/*             /* ****************************************************************************************** */            */
/*             /* 3ro. Grabamos la nueva promoción */                                                                      */
/*             /* ****************************************************************************************** */            */
/*             CREATE VtaDctoPromMin.                                                                                      */
/*             ASSIGN                                                                                                      */
/*                 VtaDctoPromMin.codcia = t-VtaDctoPromMin.CodCia                                                         */
/*                 VtaDctoPromMin.FlgEst = "A"                                                                             */
/*                 VtaDctoPromMin.CodDiv = t-VtaDctoPromMin.CodDiv                                                         */
/*                 VtaDctoPromMin.CodMat = t-VtaDctoPromMin.CodMat                                                         */
/*                 VtaDctoPromMin.FchIni = t-VtaDctoPromMin.FchIni                                                         */
/*                 VtaDctoPromMin.FchFin = t-VtaDctoPromMin.FchFin                                                         */
/*                 VtaDctoPromMin.FchCreacion = TODAY                                                                      */
/*                 VtaDctoPromMin.HoraCreacion = STRING(TIME, 'HH:MM:SS')                                                  */
/*                 VtaDctoPromMin.UsrCreacion = s-user-id                                                                  */
/*                 VtaDctoPromMin.Descuento    = t-VtaDctoPromMin.Descuento                                                */
/*                 VtaDctoPromMin.DescuentoMR  = t-VtaDctoPromMin.DescuentoMR                                              */
/*                 VtaDctoPromMin.DescuentoVIP = t-VtaDctoPromMin.DescuentoVIP                                             */
/*                 VtaDctoPromMin.Precio    = ROUND(Almmmatg.PreVta[1] * (1 - (t-VtaDctoPromMin.Descuento / 100)), 4)      */
/*                 VtaDctoPromMin.PrecioMR  = ROUND(Almmmatg.PreVta[1] * (1 - (t-VtaDctoPromMin.DescuentoMR / 100)), 4)    */
/*                 VtaDctoPromMin.PrecioVIP = ROUND(Almmmatg.PreVta[1] * (1 - (t-VtaDctoPromMin.DescuentoVIP / 100)), 4).  */
/*             DELETE t-VtaDctoPromMin.                                                                                    */
/*         END.                                                                                                            */
/*     END.                                                                                                                */
/* END CASE.                                                                                                               */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRI_Lineas-Validas) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PRI_Lineas-Validas Procedure 
PROCEDURE PRI_Lineas-Validas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Líneas válidas por usuario
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pUser-Id AS CHAR.
DEF OUTPUT PARAMETER pLineas-Validas AS CHAR.

FOR EACH Vtatabla NO-LOCK WHERE Vtatabla.codcia = s-codcia
    AND Vtatabla.tabla = "LP"
    AND Vtatabla.llave_c1 = pUser-Id,
    FIRST Almtfami NO-LOCK WHERE Almtfami.codcia = s-codcia
    AND Almtfami.codfam = Vtatabla.llave_c2:
    pLineas-Validas = pLineas-Validas + (IF TRUE <> (pLineas-Validas > '') THEN '' ELSE ',') + Almtfami.codfam.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRI_Margen-Utilidad) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PRI_Margen-Utilidad Procedure 
PROCEDURE PRI_Margen-Utilidad :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Rutina que solo calcula el margen de utilidad en base al costo de reposición
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodDiv AS CHAR.    /* División o Lista de Precios */
DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pUndVta AS CHAR.
DEF INPUT PARAMETER pPreUni AS DECI.    /* Precio Unitario a la moneda de venta */
DEF INPUT PARAMETER pMonVta AS INTE.    /* Moneda de Venta */
DEF OUTPUT PARAMETER pMargen AS DECI NO-UNDO.
DEF OUTPUT PARAMETER pLimite AS DECI NO-UNDO.
DEF OUTPUT PARAMETER pError AS CHAR NO-UNDO.

/* ****************************************************************************************************** */
/* 1ro. Verificamos que la división controle margen de utilidad */
/* ****************************************************************************************************** */
IF pCodDiv > '' THEN DO:    /* Siempre y cuando se envíe un valor */
    FIND FacTabla WHERE FacTabla.CodCia = s-CodCia
        AND FacTabla.Tabla = "GN-DIVI"
        AND FacTabla.Codigo = pCodDiv
        NO-LOCK NO-ERROR.
    IF AVAILABLE FacTabla AND FacTabla.Campo-L[4] = NO THEN RETURN "OK".
END.
/* ****************************************************************************************************** */
/* 2do. Verificamos */
/* ****************************************************************************************************** */
DEF VAR pCuenta AS INTE NO-UNDO.
FIND Almmmatg WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = pCodMat NO-LOCK NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN DO:
    {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pError"}
    RETURN 'ADM-ERROR'.
END.
FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas AND Almtconv.Codalter = pUndVta NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv OR Almtconv.Equival <= 0 THEN DO:
    pError = 'Error en la tabla de equivalencias' + CHR(10) +
        'Revisar lo siguiente:' + CHR(10) + 
        'Artículo = ' + Almmmatg.CodMat + CHR(10) +
        'Unidad Base = ' + Almmmatg.UndBas + CHR(10) +
        'Unidad de Venta = ' + pUndVta.
    RETURN 'ADM-ERROR'.
END.
/* ****************************************************************************************************** */
/* RHC: 14/10/2022 El COSTO DE REPOSICION debe salir del PRICING */
/* ****************************************************************************************************** */
DEF VAR x-Costo AS DECI NO-UNDO.

/* *************************************************************************************** */
/* Capturamos si la división pertenece a un peldaño que es parte de la escalera de precios */
/* *************************************************************************************** */
DEFINE VAR LogParteEscalera AS LOG INIT NO NO-UNDO.
DEFINE VAR hEscalera AS HANDLE NO-UNDO.

IF pCodDiv > '' THEN DO:
    RUN web/web-library.p PERSISTENT SET hEscalera.
    RUN web_api-captura-peldano-valido IN hEscalera (INPUT pCodDiv,
                                                     OUTPUT LogParteEscalera,
                                                     OUTPUT pError).
    DELETE PROCEDURE hEscalera.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        RETURN 'ADM-ERROR'.
    END.
END.
/* *************************************************************************************** */
DEFINE VAR priMonVta AS INTE NO-UNDO.
DEFINE VAR priTpoCmb AS DECI NO-UNDO.

DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN web/web-library.p PERSISTENT SET hProc.

CASE LogParteEscalera:
    WHEN YES THEN DO:
        RUN web_api-pricing-ctoreposicion IN hProc (pCodDiv,
                                                    pCodMat,
                                                    "C",                /* Clasificación C por defecto */
                                                    "000",              /* Condición de venta Contado por defecto */
                                                    OUTPUT priMonVta,
                                                    OUTPUT priTpoCmb,
                                                    OUTPUT x-Costo,
                                                    OUTPUT pError).
        IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
        IF pMonVta = 1 AND priMonVta = 2 THEN x-Costo = x-Costo * priTpoCmb.
        IF pMonVta = 2 AND priMonVta = 1 THEN x-Costo = x-Costo / priTpoCmb.
    END.
    WHEN NO THEN DO:
        RUN web_api-pricing-ctoreposicion IN hProc ("",                 /* Toma por defecto el peldaño 6 */
                                                    pCodMat,
                                                    "C",                /* Clasificación C por defecto */
                                                    "000",              /* Condición de venta Contado por defecto */
                                                    OUTPUT priMonVta,
                                                    OUTPUT priTpoCmb,
                                                    OUTPUT x-Costo,
                                                    OUTPUT pError).
        IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
        IF pMonVta = 1 AND priMonVta = 2 THEN x-Costo = x-Costo * priTpoCmb.
        IF pMonVta = 2 AND priMonVta = 1 THEN x-Costo = x-Costo / priTpoCmb.
/*         CASE pMonVta:                                                       */
/*             WHEN 1 THEN DO:                                                 */
/*                 IF Almmmatg.MonVta = 1 THEN                                 */
/*                    ASSIGN X-COSTO = (Almmmatg.Ctotot).                      */
/*                 ELSE                                                        */
/*                    ASSIGN X-COSTO = (Almmmatg.Ctotot) * Almmmatg.TpoCmb.    */
/*             END.                                                            */
/*             WHEN 2 THEN DO:                                                 */
/*                 IF Almmmatg.MonVta = 2 THEN                                 */
/*                    ASSIGN X-COSTO = (Almmmatg.Ctotot).                      */
/*                 ELSE                                                        */
/*                    ASSIGN X-COSTO = (Almmmatg.Ctotot) / Almmmatg.TpoCmb.    */
/*             END.                                                            */
/*             OTHERWISE DO:                                                   */
/*                 pError = "Error en la moneda de venta: " + STRING(pMonVta). */
/*                 RETURN 'ADM-ERROR'.                                         */
/*             END.                                                            */
/*         END CASE.                                                           */
    END.
END CASE.
DELETE PROCEDURE hProc.

DEF VAR f-Factor AS DECI NO-UNDO.
ASSIGN
    f-Factor = Almtconv.Equival
    pPreUni = pPreUni / f-Factor.   /* En unidades de stock */

/* ****************************************************************************************************** */
/* 3ro. Cálculo del Margen */
/* ****************************************************************************************************** */
IF x-Costo = 0 OR x-Costo = ? THEN DO:
    pError = 'Error en el costo unitario' + CHR(10) +
                'Revisar lo siguiente:' + CHR(10) + 
                'Artículo = ' + Almmmatg.CodMat + CHR(10) +
                'Costo Unitario = ' + STRING(x-Costo).
    RETURN 'ADM-ERROR'.
END.
DEF VAR x-Margen AS DECI NO-UNDO.
/*MESSAGE pPreUni X-COSTO.*/
/* Margen calculado en base al COSTO */
ASSIGN
    X-MARGEN = ROUND( ((( pPreUni / X-COSTO ) - 1 ) * 100 ), 2 )
    pMargen = x-Margen
    pLimite = x-Margen.
/* ****************************************************************************************************** */
/* 4to. Margen mínimo por Linea */
/* ****************************************************************************************************** */
FIND TabGener WHERE Tabgener.codcia = s-codcia 
    AND Tabgener.clave = 'MML'
    AND Tabgener.codigo = Almmmatg.codfam NO-LOCK NO-ERROR.
IF NOT AVAILABLE TabGener THEN DO:
    /* NO hay CONTROL de margen de utilidad por este producto */
    RETURN 'OK'.
END.
/* Producto Propio o de Terceros */
DEF VAR x-Limite AS DECI NO-UNDO.
IF Almmmatg.chr__02 = 'P' THEN X-LIMITE = TabGener.Parametro[2].
ELSE X-LIMITE = TabGener.Parametro[1].
/* ****************************************************************************************************** */
/* 5to. Margen mínimo por Sublinea */
/* ****************************************************************************************************** */
FIND VtaTabla WHERE VtaTabla.codcia = s-codcia
    AND VtaTabla.tabla = 'MMLL'
    AND VtaTabla.llave_c1 = Almmmatg.codfam
    AND VtaTabla.llave_c2 = Almmmatg.subfam
    NO-LOCK NO-ERROR.
IF AVAILABLE VtaTabla THEN DO:
    /* Producto Propio o de Terceros */
    IF Almmmatg.chr__02 = 'P' THEN X-LIMITE = VtaTabla.Valor[2].
    ELSE X-LIMITE = VtaTabla.Valor[1].
    /* Margen mínimo por marca */
    FIND VtaTabla WHERE VtaTabla.CodCia = TabGener.CodCia
        AND VtaTabla.Tabla = 'MMLLM'
        AND VtaTabla.Llave_c1 = Almmmatg.codfam
        AND VtaTabla.Llave_c2 = Almmmatg.subfam
        AND VtaTabla.Llave_c3 = Almmmatg.codmar
        NO-LOCK NO-ERROR.
    IF AVAILABLE VtaTabla THEN DO:
        /* Producto Propio o de Terceros */
        IF Almmmatg.chr__02 = 'P' THEN X-LIMITE = VtaTabla.Valor[2].
        ELSE X-LIMITE = VtaTabla.Valor[1].
    END.
END.
ASSIGN
    pLimite = x-Limite.
/* ****************************************************************************************************** */
/* 6to. RHC 04.04.2011 Productos exonerados */
/* ****************************************************************************************************** */
FIND FIRST VtaTabla WHERE VtaTabla.codcia = s-codcia
    AND VtaTabla.tabla = 'MMLX'
    AND VTaTabla.llave_c1 = pCodMat
    NO-LOCK NO-ERROR.
IF AVAILABLE VtaTabla THEN x-Limite = x-Margen.     /* OJO */
/* ****************************************************************************************************** */
IF X-MARGEN < X-LIMITE THEN DO:
    pError = "PRODUCTO: " + pCodMat + " >>> " + "Margen de " + STRING(x-Margen) 
            + "%, por debajo del margen mínimo de " + STRING(x-Limite) + "%".
/*     pError = 'PRODUCTO: ' + pCodMat + CHR(10) +                                                              */
/*                 'MARGEN DE UTILIDAD MUY BAJO' + CHR(10) +                                                    */
/*                 'El margen es de ' + STRING(x-Margen) +  '%, no debe ser menor a ' + STRING(x-Limite) + '%'. */
    /* RETURN 'ADM-ERROR'. */
    /* OJO: NO se devuelve ADM-ERROR
            El programa que llama esta función controla el error a través de la variable pError 
    */            
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRI_Margen-Utilidad-Listas) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PRI_Margen-Utilidad-Listas Procedure 
PROCEDURE PRI_Margen-Utilidad-Listas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Rutina que solo calcula el margen de utilidad en base al costo de reposición
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodDiv AS CHAR.    /* División o Lista de Precios */
DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pUndVta AS CHAR.
DEF INPUT PARAMETER pPorDto AS DECI.    /* % de Descuento */
DEF INPUT PARAMETER pMonVta AS INTE.    /* Moneda de Venta */
DEF OUTPUT PARAMETER pMargen AS DECI NO-UNDO.
DEF OUTPUT PARAMETER pLimite AS DECI NO-UNDO.
DEF OUTPUT PARAMETER pError AS CHAR NO-UNDO.

DEF VAR pPreUni AS DECI NO-UNDO.

/* ****************************************************************************************************** */
/* 1ro. Verificamos que la división controle margen de utilidad */
/* ****************************************************************************************************** */
IF pCodDiv > '' THEN DO:    /* Siempre y cuando se envíe un valor */
    FIND B-FacTabla WHERE B-FacTabla.CodCia = s-CodCia
        AND B-FacTabla.Tabla = "GN-DIVI"
        AND B-FacTabla.Codigo = pCodDiv
        NO-LOCK NO-ERROR.
    IF AVAILABLE B-FacTabla AND B-FacTabla.Campo-L[4] = NO THEN RETURN "OK".
END.
/* ****************************************************************************************************** */
/* 2do. Verificamos */
/* ****************************************************************************************************** */
DEF VAR pCuenta AS INTE NO-UNDO.
FIND Almmmatg WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = pCodMat NO-LOCK NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN DO:
    {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pError"}
    RETURN 'ADM-ERROR'.
END.

FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas AND Almtconv.Codalter = pUndVta NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv OR Almtconv.Equival <= 0 THEN DO:
    pError = 'Error en la tabla de equivalencias' + CHR(10) +
        'Revisar lo siguiente:' + CHR(10) + 
        'Artículo = ' + Almmmatg.CodMat + CHR(10) +
        'Unidad Base = ' + Almmmatg.UndBas + CHR(10) +
        'Unidad de Venta = ' + pUndVta.
    RETURN 'ADM-ERROR'.
END.
/* ****************************************************************************************************** */
/* RHC: 14/10/2022 El COSTO DE REPOSICION debe salir del PRICING */
/* ****************************************************************************************************** */
DEF VAR x-Costo AS DECI NO-UNDO.

DEFINE VAR priMonVta AS INTE NO-UNDO.
DEFINE VAR priTpoCmb AS DECI NO-UNDO.

DEFINE VAR hLocalProc AS HANDLE NO-UNDO.


RUN web/web-library.p PERSISTENT SET hLocalProc.
RUN web_api-pricing-ctoreposicion IN hLocalProc (pCodDiv,
                                            pCodMat,
                                            "C",                /* Clasificación C por defecto */
                                            "000",              /* Condición de venta Contado por defecto */
                                            OUTPUT priMonVta,
                                            OUTPUT priTpoCmb,
                                            OUTPUT x-Costo,
                                            OUTPUT pError).
IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
/*MESSAGE 'uno'.*/

DEF VAR pPeldano AS CHAR INIT '6' NO-UNDO.      /* Por defecto peldaño TIENDAS */
IF pCodDiv > '' THEN DO:
    FIND gn-divi WHERE gn-divi.codcia = s-codcia AND
        gn-divi.coddiv = pCodDiv NO-LOCK NO-ERROR.
    IF AVAILABLE gn-divi AND GN-DIVI.Grupo_Divi_GG > '' THEN 
        ASSIGN pPeldano = TRIM(STRING(INTEGER(GN-DIVI.Grupo_Divi_GG))) NO-ERROR.
END.
RUN web_api-pricing-preuni IN hLocalProc (pCodMat,
                                     pPeldano,
                                     "C",                /* Clasificación C por defecto */
                                     "000",              /* Condición de venta Contado por defecto */
                                     OUTPUT priMonVta,
                                     OUTPUT priTpoCmb,
                                     OUTPUT pPreUni,
                                     OUTPUT pError).

IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
DELETE PROCEDURE hLocalProc.
/*MESSAGE 'dos'.*/

pPreUni = ROUND(pPreUni * ( 1 - ( pPorDto / 100 ) ),4).

/*
IF pMonVta = 1 AND priMonVta = 2 THEN x-Costo = x-Costo * priTpoCmb.
IF pMonVta = 2 AND priMonVta = 1 THEN x-Costo = x-Costo / priTpoCmb.
*/

DEF VAR f-Factor AS DECI NO-UNDO.
ASSIGN
    f-Factor = Almtconv.Equival
    pPreUni = pPreUni / f-Factor.   /* En unidades de stock */

/* CASE pMonVta:                                                       */
/*     WHEN 1 THEN DO:                                                 */
/*         IF Almmmatg.MonVta = 1 THEN                                 */
/*            ASSIGN X-COSTO = (Almmmatg.Ctotot).                      */
/*         ELSE                                                        */
/*            ASSIGN X-COSTO = (Almmmatg.Ctotot) * Almmmatg.TpoCmb.    */
/*     END.                                                            */
/*     WHEN 2 THEN DO:                                                 */
/*         IF Almmmatg.MonVta = 2 THEN                                 */
/*            ASSIGN X-COSTO = (Almmmatg.Ctotot).                      */
/*         ELSE                                                        */
/*            ASSIGN X-COSTO = (Almmmatg.Ctotot) / Almmmatg.TpoCmb.    */
/*     END.                                                            */
/*     OTHERWISE DO:                                                   */
/*         pError = "Error en la moneda de venta: " + STRING(pMonVta). */
/*         RETURN 'ADM-ERROR'.                                         */
/*     END.                                                            */
/* END CASE.                                                           */


/* ****************************************************************************************************** */
/* 3ro. Cálculo del Margen */
/* ****************************************************************************************************** */
IF x-Costo = 0 OR x-Costo = ? THEN DO:
    pError = 'Error en el costo unitario' + CHR(10) +
                'Revisar lo siguiente:' + CHR(10) + 
                'Artículo = ' + Almmmatg.CodMat + CHR(10) +
                'Costo Unitario = ' + STRING(x-Costo).
    RETURN 'ADM-ERROR'.
END.
DEF VAR x-Margen AS DECI NO-UNDO.
/* Margen calculado en base al COSTO */
ASSIGN
    X-MARGEN = ROUND( ((( pPreUni / X-COSTO ) - 1 ) * 100 ), 2 )
    pMargen = x-Margen
    pLimite = x-Margen.
/* ****************************************************************************************************** */
/* 4to. Margen mínimo por Linea */
/* ****************************************************************************************************** */
FIND TabGener WHERE Tabgener.codcia = s-codcia 
    AND Tabgener.clave = 'MML'
    AND Tabgener.codigo = Almmmatg.codfam NO-LOCK NO-ERROR.
IF NOT AVAILABLE TabGener THEN DO:
    /* NO hay CONTROL de margen de utilidad por este producto */
    RETURN 'OK'.
END.
/* Producto Propio o de Terceros */
DEF VAR x-Limite AS DECI NO-UNDO.
IF Almmmatg.chr__02 = 'P' THEN X-LIMITE = TabGener.Parametro[2].
ELSE X-LIMITE = TabGener.Parametro[1].
/* ****************************************************************************************************** */
/* 5to. Margen mínimo por Sublinea */
/* ****************************************************************************************************** */
FIND VtaTabla WHERE VtaTabla.codcia = s-codcia
    AND VtaTabla.tabla = 'MMLL'
    AND VtaTabla.llave_c1 = Almmmatg.codfam
    AND VtaTabla.llave_c2 = Almmmatg.subfam
    NO-LOCK NO-ERROR.
IF AVAILABLE VtaTabla THEN DO:
    /* Producto Propio o de Terceros */
    IF Almmmatg.chr__02 = 'P' THEN X-LIMITE = VtaTabla.Valor[2].
    ELSE X-LIMITE = VtaTabla.Valor[1].
    /* Margen mínimo por marca */
    FIND VtaTabla WHERE VtaTabla.CodCia = TabGener.CodCia
        AND VtaTabla.Tabla = 'MMLLM'
        AND VtaTabla.Llave_c1 = Almmmatg.codfam
        AND VtaTabla.Llave_c2 = Almmmatg.subfam
        AND VtaTabla.Llave_c3 = Almmmatg.codmar
        NO-LOCK NO-ERROR.
    IF AVAILABLE VtaTabla THEN DO:
        /* Producto Propio o de Terceros */
        IF Almmmatg.chr__02 = 'P' THEN X-LIMITE = VtaTabla.Valor[2].
        ELSE X-LIMITE = VtaTabla.Valor[1].
    END.
END.
ASSIGN
    pLimite = x-Limite.
/* ****************************************************************************************************** */
/* 6to. RHC 04.04.2011 Productos exonerados */
/* ****************************************************************************************************** */
FIND FIRST VtaTabla WHERE VtaTabla.codcia = s-codcia
    AND VtaTabla.tabla = 'MMLX'
    AND VTaTabla.llave_c1 = pCodMat
    NO-LOCK NO-ERROR.
IF AVAILABLE VtaTabla THEN x-Limite = x-Margen.     /* OJO */
/* ****************************************************************************************************** */
IF X-MARGEN < X-LIMITE THEN DO:
    pError = "PRODUCTO: " + pCodMat + " >>> " + "Margen de " + STRING(x-Margen) 
            + "%, por debajo del margen mínimo de " + STRING(x-Limite) + "%".
/*     pError = 'PRODUCTO: ' + pCodMat + CHR(10) +                                                              */
/*                 'MARGEN DE UTILIDAD MUY BAJO' + CHR(10) +                                                    */
/*                 'El margen es de ' + STRING(x-Margen) +  '%, no debe ser menor a ' + STRING(x-Limite) + '%'. */
    /* RETURN 'ADM-ERROR'. */
    /* OJO: NO se devuelve ADM-ERROR
            El programa que llama esta función controla el error a través de la variable pError 
    */            
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRI_Margen-Utilidad-Ventas) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PRI_Margen-Utilidad-Ventas Procedure 
PROCEDURE PRI_Margen-Utilidad-Ventas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Rutina que solo calcula el margen de utilidad en base al costo de reposición
  07/11/2022: Nuevo parámetro LogParteEscalera
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER LogParteEscalera AS LOG NO-UNDO.
DEF INPUT PARAMETER pCodDiv AS CHAR.    /* División o Lista de Precios */
DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pUndVta AS CHAR.
DEF INPUT PARAMETER pPreUni AS DECI.    /* Precio Unitario a la moneda de venta */
DEF INPUT PARAMETER pMonVta AS INTE.    /* Moneda de Venta */
DEF OUTPUT PARAMETER pMargen AS DECI NO-UNDO.
DEF OUTPUT PARAMETER pLimite AS DECI NO-UNDO.
DEF OUTPUT PARAMETER pError AS CHAR NO-UNDO.

/* ****************************************************************************************************** */
/* 1ro. Verificamos que la división controle margen de utilidad */
/* 07/11/2022: Bloqueado */
/* ****************************************************************************************************** */
/* IF pCodDiv > '' THEN DO:    /* Siempre y cuando se envíe un valor */     */
/*     FIND FacTabla WHERE FacTabla.CodCia = s-CodCia                       */
/*         AND FacTabla.Tabla = "GN-DIVI"                                   */
/*         AND FacTabla.Codigo = pCodDiv                                    */
/*         NO-LOCK NO-ERROR.                                                */
/*     IF AVAILABLE FacTabla AND FacTabla.Campo-L[4] = NO THEN RETURN "OK". */
/* END.                                                                     */
/* ****************************************************************************************************** */
/* 2do. Verificamos */
/* ****************************************************************************************************** */
DEF VAR pCuenta AS INTE NO-UNDO.
FIND Almmmatg WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = pCodMat NO-LOCK NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN DO:
    {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pError"}
    RETURN 'ADM-ERROR'.
END.
FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas AND Almtconv.Codalter = pUndVta NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv OR Almtconv.Equival <= 0 THEN DO:
    pError = 'Error en la tabla de equivalencias' + CHR(10) +
        'Revisar lo siguiente:' + CHR(10) + 
        'Artículo = ' + Almmmatg.CodMat + CHR(10) +
        'Unidad Base = ' + Almmmatg.UndBas + CHR(10) +
        'Unidad de Venta = ' + pUndVta.
    RETURN 'ADM-ERROR'.
END.
/* ****************************************************************************************************** */
/* RHC: 14/10/2022 El COSTO DE REPOSICION debe salir del PRICING */
/* ****************************************************************************************************** */
DEF VAR x-Costo AS DECI NO-UNDO.
/* *************************************************************************************** */
/* Capturamos si la división pertenece a un peldaño que es parte de la escalera de precios */
/* *************************************************************************************** */
/* DEFINE VAR LogParteEscalera AS LOG INIT NO NO-UNDO.                           */
/* DEFINE VAR hEscalera AS HANDLE NO-UNDO.                                       */
/*                                                                               */
/* IF pCodDiv > '' THEN DO:                                                      */
/*     RUN web/web-library.p PERSISTENT SET hEscalera.                           */
/*     RUN web_api-captura-peldano-valido IN hEscalera (INPUT pCodDiv,           */
/*                                                      OUTPUT LogParteEscalera, */
/*                                                      OUTPUT pError).          */
/*     DELETE PROCEDURE hEscalera.                                               */
/*     IF RETURN-VALUE = 'ADM-ERROR' THEN DO:                                    */
/*         RETURN 'ADM-ERROR'.                                                   */
/*     END.                                                                      */
/* END.                                                                          */
/* *************************************************************************************** */
DEFINE VAR priMonVta AS INTE NO-UNDO.
DEFINE VAR priTpoCmb AS DECI NO-UNDO.

DEFINE VAR hWebLibrary AS HANDLE NO-UNDO.

RUN web/web-library.p PERSISTENT SET hWebLibrary.

CASE LogParteEscalera:
    WHEN YES THEN DO:
        RUN web_api-pricing-ctoreposicion IN hWebLibrary (pCodDiv,
                                                          pCodMat,
                                                          "C",                /* Clasificación C por defecto */
                                                          "000",              /* Condición de venta Contado por defecto */
                                                          OUTPUT priMonVta,
                                                          OUTPUT priTpoCmb,
                                                          OUTPUT x-Costo,
                                                          OUTPUT pError).
        IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
        IF pMonVta = 1 AND priMonVta = 2 THEN x-Costo = x-Costo * priTpoCmb.
        IF pMonVta = 2 AND priMonVta = 1 THEN x-Costo = x-Costo / priTpoCmb.
    END.
    WHEN NO THEN DO:
        RUN web_api-pricing-ctoreposicion IN hWebLibrary ("",                 /* Toma por defecto el peldaño 6 */
                                                    pCodMat,
                                                    "C",                /* Clasificación C por defecto */
                                                    "000",              /* Condición de venta Contado por defecto */
                                                    OUTPUT priMonVta,
                                                    OUTPUT priTpoCmb,
                                                    OUTPUT x-Costo,
                                                    OUTPUT pError).
        IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
        IF pMonVta = 1 AND priMonVta = 2 THEN x-Costo = x-Costo * priTpoCmb.
        IF pMonVta = 2 AND priMonVta = 1 THEN x-Costo = x-Costo / priTpoCmb.
/*         CASE pMonVta:                                                       */
/*             WHEN 1 THEN DO:                                                 */
/*                 IF Almmmatg.MonVta = 1 THEN                                 */
/*                    ASSIGN X-COSTO = (Almmmatg.Ctotot).                      */
/*                 ELSE                                                        */
/*                    ASSIGN X-COSTO = (Almmmatg.Ctotot) * Almmmatg.TpoCmb.    */
/*             END.                                                            */
/*             WHEN 2 THEN DO:                                                 */
/*                 IF Almmmatg.MonVta = 2 THEN                                 */
/*                    ASSIGN X-COSTO = (Almmmatg.Ctotot).                      */
/*                 ELSE                                                        */
/*                    ASSIGN X-COSTO = (Almmmatg.Ctotot) / Almmmatg.TpoCmb.    */
/*             END.                                                            */
/*             OTHERWISE DO:                                                   */
/*                 pError = "Error en la moneda de venta: " + STRING(pMonVta). */
/*                 RETURN 'ADM-ERROR'.                                         */
/*             END.                                                            */
/*         END CASE.                                                           */
    END.
END CASE.
DELETE PROCEDURE hWebLibrary.

DEF VAR f-Factor AS DECI NO-UNDO.
ASSIGN
    f-Factor = Almtconv.Equival
    pPreUni = pPreUni / f-Factor.   /* En unidades de stock */

/* ****************************************************************************************************** */
/* 3ro. Cálculo del Margen */
/* ****************************************************************************************************** */
IF x-Costo = 0 OR x-Costo = ? THEN DO:
    pError = 'Error en el costo unitario' + CHR(10) +
                'Revisar lo siguiente:' + CHR(10) + 
                'Artículo = ' + Almmmatg.CodMat + CHR(10) +
                'Costo Unitario = ' + STRING(x-Costo).
    RETURN 'ADM-ERROR'.
END.
DEF VAR x-Margen AS DECI NO-UNDO.
/* Margen calculado en base al COSTO */
ASSIGN
    X-MARGEN = ROUND( ((( pPreUni / X-COSTO ) - 1 ) * 100 ), 2 )
    pMargen = x-Margen
    pLimite = x-Margen.
/* ****************************************************************************************************** */
/* 4to. Margen mínimo por Linea */
/* ****************************************************************************************************** */
FIND TabGener WHERE Tabgener.codcia = s-codcia 
    AND Tabgener.clave = 'MML'
    AND Tabgener.codigo = Almmmatg.codfam NO-LOCK NO-ERROR.
IF NOT AVAILABLE TabGener THEN DO:
    /* NO hay CONTROL de margen de utilidad por este producto */
    RETURN 'OK'.
END.
/* Producto Propio o de Terceros */
DEF VAR x-Limite AS DECI NO-UNDO.
IF Almmmatg.chr__02 = 'P' THEN X-LIMITE = TabGener.Parametro[2].
ELSE X-LIMITE = TabGener.Parametro[1].
/* ****************************************************************************************************** */
/* 5to. Margen mínimo por Sublinea */
/* ****************************************************************************************************** */
FIND VtaTabla WHERE VtaTabla.codcia = s-codcia
    AND VtaTabla.tabla = 'MMLL'
    AND VtaTabla.llave_c1 = Almmmatg.codfam
    AND VtaTabla.llave_c2 = Almmmatg.subfam
    NO-LOCK NO-ERROR.
IF AVAILABLE VtaTabla THEN DO:
    /* Producto Propio o de Terceros */
    IF Almmmatg.chr__02 = 'P' THEN X-LIMITE = VtaTabla.Valor[2].
    ELSE X-LIMITE = VtaTabla.Valor[1].
    /* Margen mínimo por marca */
    FIND VtaTabla WHERE VtaTabla.CodCia = TabGener.CodCia
        AND VtaTabla.Tabla = 'MMLLM'
        AND VtaTabla.Llave_c1 = Almmmatg.codfam
        AND VtaTabla.Llave_c2 = Almmmatg.subfam
        AND VtaTabla.Llave_c3 = Almmmatg.codmar
        NO-LOCK NO-ERROR.
    IF AVAILABLE VtaTabla THEN DO:
        /* Producto Propio o de Terceros */
        IF Almmmatg.chr__02 = 'P' THEN X-LIMITE = VtaTabla.Valor[2].
        ELSE X-LIMITE = VtaTabla.Valor[1].
    END.
END.
ASSIGN
    pLimite = x-Limite.
/* ****************************************************************************************************** */
/* 6to. RHC 04.04.2011 Productos exonerados */
/* ****************************************************************************************************** */
FIND FIRST VtaTabla WHERE VtaTabla.codcia = s-codcia
    AND VtaTabla.tabla = 'MMLX'
    AND VTaTabla.llave_c1 = pCodMat
    NO-LOCK NO-ERROR.
IF AVAILABLE VtaTabla THEN x-Limite = x-Margen.     /* OJO */
/* ****************************************************************************************************** */
IF X-MARGEN < X-LIMITE THEN DO:
    pError = "PRODUCTO: " + pCodMat + " >>> " + "Margen de " + STRING(x-Margen) 
            + "%, por debajo del margen mínimo de " + STRING(x-Limite) + "%".
/*     pError = 'PRODUCTO: ' + pCodMat + CHR(10) +                                                              */
/*                 'MARGEN DE UTILIDAD MUY BAJO' + CHR(10) +                                                    */
/*                 'El margen es de ' + STRING(x-Margen) +  '%, no debe ser menor a ' + STRING(x-Limite) + '%'. */
    /* RETURN 'ADM-ERROR'. */
    /* OJO: NO se devuelve ADM-ERROR
            El programa que llama esta función controla el error a través de la variable pError 
    */            
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRI_PrecioBase-DctoVolSaldo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PRI_PrecioBase-DctoVolSaldo Procedure 
PROCEDURE PRI_PrecioBase-DctoVolSaldo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF INPUT PARAMETER s-Tabla AS CHAR.          /* Para buscar los productos relacionados */
  DEF INPUT PARAMETER s-Codigo AS CHAR.
  DEF INPUT PARAMETER pCodDiv AS CHAR.
  DEF OUTPUT PARAMETER pPrecioBase AS DEC.
  DEF OUTPUT PARAMETER x-TpoCmb AS DEC.
  DEF OUTPUT PARAMETER x-MonVta AS INT.
  DEF OUTPUT PARAMETER pUndVta AS CHAR.

  pPrecioBase = 0.
  x-TpoCmb = 0.
  x-MonVta = 1.
  pUndVta = ''.
  FIND gn-divi WHERE gn-divi.codcia = s-codcia AND
      gn-divi.coddiv = pCodDiv NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-divi THEN RETURN.
  
  CASE TRUE:
      WHEN gn-divi.CanalVenta = "FER" AND GN-DIVI.VentaMayorista = 2 THEN DO:
          /* EVENTOS */
          FIND FIRST B-FacTabla WHERE B-FacTabla.CodCia = s-codcia AND
              B-FacTabla.Tabla = s-Tabla AND
              B-FacTabla.Codigo BEGINS s-Codigo AND
              CAN-FIND(FIRST VtaListaMay WHERE VtaListaMay.CodCia = s-codcia AND
                       VtaListaMay.CodDiv = pCodDiv AND
                       VtaListaMay.codmat = ENTRY(2,B-FacTabla.Codigo,'|')
                       NO-LOCK)
              NO-LOCK NO-ERROR.
          IF AVAILABLE B-FacTabla THEN DO:
              FIND FIRST VtaListaMay WHERE VtaListaMay.CodCia = s-codcia AND
                  VtaListaMay.CodDiv = pCodDiv AND
                  VtaListaMay.codmat = ENTRY(2,B-FacTabla.Codigo,'|')
                  NO-LOCK.
              pPrecioBase = VtaListaMay.PreOfi.
              FIND FIRST Almmmatg OF VtaListaMay NO-LOCK.
              x-TpoCmb = Almmmatg.TpoCmb.
              x-MonVta = Almmmatg.MonVta.
              pUndVta = Almmmatg.UndStk.
          END.
      END.
      WHEN gn-divi.CanalVenta = "MIN" AND GN-DIVI.VentaMayorista = 1 THEN DO:
          /* UTILEX */
          FIND FIRST B-FacTabla WHERE B-FacTabla.CodCia = s-codcia AND
              B-FacTabla.Tabla = s-Tabla AND
              B-FacTabla.Codigo BEGINS s-Codigo AND
              CAN-FIND(FIRST VtaListaMinGn WHERE VtaListaMinGn.CodCia = s-codcia AND
                       VtaListaMinGn.codmat = ENTRY(2,B-FacTabla.Codigo,'|')
                       NO-LOCK)
              NO-LOCK NO-ERROR.
          IF AVAILABLE B-FacTabla THEN DO:
              FIND FIRST VtaListaMinGn WHERE VtaListaMinGn.CodCia = s-codcia AND
                  VtaListaMinGn.codmat = ENTRY(2,B-FacTabla.Codigo,'|')
                  NO-LOCK.
              pPrecioBase = VtaListaMinGn.PreOfi.
              FIND FIRST Almmmatg OF VtaListaMinGn NO-LOCK.
              x-TpoCmb = Almmmatg.TpoCmb.
              x-MonVta = Almmmatg.MonVta.
              pUndVta = Almmmatg.UndStk.
          END.
      END.
      WHEN GN-DIVI.VentaMayorista = 1 THEN DO:
          /* LISTA GENERAL LIMA */
          FIND FIRST B-FacTabla WHERE B-FacTabla.CodCia = s-codcia AND
              B-FacTabla.Tabla = s-Tabla AND
              B-FacTabla.Codigo BEGINS s-Codigo AND
              CAN-FIND(FIRST Almmmatg WHERE Almmmatg.CodCia = s-codcia AND
                       Almmmatg.codmat = B-FacTabla.Campo-c[1] AND
                       Almmmatg.preofi > 0 NO-LOCK)
              NO-LOCK NO-ERROR.
          IF AVAILABLE B-FacTabla THEN DO:
              FIND FIRST Almmmatg WHERE Almmmatg.CodCia = s-codcia AND
                  Almmmatg.codmat = B-FacTabla.Campo-c[1]
                  NO-LOCK.
              pPrecioBase = Almmmatg.PreOfi.
              x-TpoCmb = Almmmatg.TpoCmb.
              x-MonVta = Almmmatg.MonVta.
              pUndVta = Almmmatg.UndStk.
          END.
          /*MESSAGE ppreciobase x-tpocmb x-monvta pundvta.*/
      END.
      WHEN GN-DIVI.VentaMayorista = 2 THEN DO:
          /* LISTA POR DIVISION */
          FIND FIRST B-FacTabla WHERE B-FacTabla.CodCia = s-codcia AND
              B-FacTabla.Tabla = s-Tabla AND
              B-FacTabla.Codigo BEGINS s-Codigo AND
              CAN-FIND(FIRST VtaListaMay WHERE VtaListaMay.CodCia = s-codcia AND
                       VtaListaMay.CodDiv = pCodDiv AND
                       VtaListaMay.codmat = ENTRY(2,B-FacTabla.Codigo,'|')
                       NO-LOCK)
              NO-LOCK NO-ERROR.
          IF AVAILABLE B-FacTabla THEN DO:
              FIND FIRST VtaListaMay WHERE VtaListaMay.CodCia = s-codcia AND
                  VtaListaMay.CodDiv = pCodDiv AND
                  VtaListaMay.codmat = ENTRY(2,B-FacTabla.Codigo,'|')
                  NO-LOCK.
              pPrecioBase = VtaListaMay.PreOfi.
              FIND FIRST Almmmatg OF VtaListaMay NO-LOCK.
              x-TpoCmb = Almmmatg.TpoCmb.
              x-MonVta = Almmmatg.MonVta.
              pUndVta = Almmmatg.UndStk.
          END.
      END.
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRI_Ultima_Venta) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PRI_Ultima_Venta Procedure 
PROCEDURE PRI_Ultima_Venta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Lo rastreamos a travéz del pedido logístico
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pCodMat AS CHAR.
DEF OUTPUT PARAMETER pFchPed AS DATE.

FOR EACH Facdpedi NO-LOCK WHERE FacDPedi.CodCia = s-CodCia
    AND FacDPedi.codmat = pCodMat
    AND LOOKUP(FacDPedi.CodDoc, "PED,P/M") > 0
    AND Facdpedi.Libre_c05 <> 'OF',
    FIRST Faccpedi OF Facdpedi NO-LOCK WHERE Faccpedi.FlgEst <> "A"
    BY Facdpedi.fchped DESC:
    pFchPed = Facdpedi.FchPed.
    LEAVE.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRI_Valida-Margen-Utilidad) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PRI_Valida-Margen-Utilidad Procedure 
PROCEDURE PRI_Valida-Margen-Utilidad :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF INPUT PARAMETER pCodDiv AS CHAR.
  DEF INPUT PARAMETER pCodMat AS CHAR.
  DEF INPUT PARAMETER pUndVta AS CHAR.
  DEF INPUT PARAMETER pPreUni AS DECI.
  DEF INPUT PARAMETER pCodMon AS INTE.
  DEF OUTPUT PARAMETER pMargen AS DECI.
  DEF OUTPUT PARAMETER pLimite AS DECI.
  DEF OUTPUT PARAMETER pError AS CHAR NO-UNDO.

  /* ****************************************************************************************************** */
  /* 1ro. Verificamos que la división controle margen de utilidad */
  /* ****************************************************************************************************** */
  IF pCodDiv > '' THEN DO:    /* Siempre y cuando se envíe un valor */
      FIND FacTabla WHERE FacTabla.CodCia = s-CodCia
          AND FacTabla.Tabla = "GN-DIVI"
          AND FacTabla.Codigo = pCodDiv
          NO-LOCK NO-ERROR.
      IF AVAILABLE FacTabla AND FacTabla.Campo-L[4] = NO THEN RETURN "OK".
  END.
  /* ****************************************************************************************************** */
  /* ****************************************************************************************************** */
  /* *************************************************************************************** */
  /* Capturamos si la división pertenece a un peldaño que es parte de la escalera de precios */
  /* *************************************************************************************** */
  DEFINE VAR LogParteEscalera AS LOG INIT NO NO-UNDO.
  DEFINE VAR hEscalera AS HANDLE NO-UNDO.

  IF pCodDiv > '' THEN DO:
      RUN web/web-library.p PERSISTENT SET hEscalera.
      RUN web_api-captura-peldano-valido IN hEscalera (INPUT pCodDiv,
                                                       OUTPUT LogParteEscalera,
                                                       OUTPUT pError).
      DELETE PROCEDURE hEscalera.
      IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
          RETURN 'ADM-ERROR'.
      END.
  END.
  /* *************************************************************************************** */

  RUN PRI_Margen-Utilidad-Ventas (INPUT LogParteEscalera,
                                  INPUT pCodDiv,
                                  INPUT pCodMat,
                                  INPUT pUndVta,
                                  INPUT pPreUni,
                                  INPUT pCodMon,
                                  OUTPUT pMargen,
                                  OUTPUT pLimite,
                                  OUTPUT pError).
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      /* Error crítico */
      RETURN 'ADM-ERROR'.
  END.
  /* Controlamos si el margen de utilidad está bajo a través de la variable pError */
  IF pError > '' THEN DO:
      /* Error por margen de utilidad */
      /* 2do. Verificamos si solo es una ALERTA, definido por GG */
/*       DEF VAR pAlerta AS LOG NO-UNDO.                           */
/*       RUN PRI_Alerta-de-Margen (INPUT pCodMat, OUTPUT pAlerta). */
/*       IF pAlerta = NO THEN DO:                                  */
/*           pError = pError + CHR(10) + 'No admitido'.            */
/*           RETURN 'ADM-ERROR'.                                   */
/*       END.                                                      */
      pError = ''.
  END.
  RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRI_Valida-Margen-Utilidad-Total) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PRI_Valida-Margen-Utilidad-Total Procedure 
PROCEDURE PRI_Valida-Margen-Utilidad-Total :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF BUFFER B-CPEDI FOR Faccpedi.
DEF BUFFER B-DPEDI FOR Facdpedi.

DEF INPUT PARAMETER pRowid AS ROWID.
DEF OUTPUT PARAMETER pError AS CHAR NO-UNDO.

pError = "".

FIND B-CPEDI WHERE ROWID(B-CPEDI) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-CPEDI THEN RETURN 'OK'.

/* ********************************* MARGEN DE UTILIDAD ******************************* */
/* CONTRATO MARCO, REMATES, EXPOLIBRERIA, LISTA EXPRESS: NO TIENE MINIMO NI MARGEN DE UTILIDAD */
IF LOOKUP(B-CPEDI.TpoPed, "M,R") > 0 THEN RETURN "OK".   
IF B-CPEDI.Libre_C04 = "SI" THEN RETURN "OK".       /* (s-TpoMarco) */
IF LOOKUP(B-CPEDI.FMAPGO, "899,900") > 0 THEN RETURN "OK".
/* ******************************************************************************* */
/* ****************************************************************************************************** */
/* 1ro. Verificamos que la división controle margen de utilidad */
/* ****************************************************************************************************** */
IF B-CPEDI.Lista_de_Precios > '' THEN DO:    /* Siempre y cuando se envíe un valor */
    FIND FacTabla WHERE FacTabla.CodCia = s-CodCia
        AND FacTabla.Tabla = "GN-DIVI"
        AND FacTabla.Codigo = B-CPEDI.Lista_de_Precios
        NO-LOCK NO-ERROR.
    IF AVAILABLE FacTabla AND FacTabla.Campo-L[4] = NO THEN RETURN "OK".
END.
/* ****************************************************************************************************** */
/* ****************************************************************************************************** */
DEF VAR x-Margen AS DEC NO-UNDO.
DEF VAR x-Limite AS DEC NO-UNDO.
DEF VAR pAlerta AS LOG NO-UNDO.

/* *************************************************************************************** */
/* Capturamos si la división pertenece a un peldaño que es parte de la escalera de precios */
/* *************************************************************************************** */
DEFINE VAR LogParteEscalera AS LOG INIT NO NO-UNDO.
DEFINE VAR hEscalera AS HANDLE NO-UNDO.

IF B-CPEDI.Lista_de_Precios > '' THEN DO:
    RUN web/web-library.p PERSISTENT SET hEscalera.
    RUN web_api-captura-peldano-valido IN hEscalera (INPUT B-CPEDI.Lista_de_Precios,
                                                     OUTPUT LogParteEscalera,
                                                     OUTPUT pError).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        RETURN 'ADM-ERROR'.
    END.
    DELETE PROCEDURE hEscalera.
END.
/* *************************************************************************************** */

FOR EACH B-DPEDI OF B-CPEDI NO-LOCK WHERE B-DPEDI.Libre_c05 <> "OF",
    FIRST Almmmatg OF B-DPEDI NO-LOCK WHERE Almmmatg.CatConta[1] <> "SV": 
    /* 09/11/2022: Solo se valida margen de los que tengas descuentos acumulados
                    El margen es controlado desde la carga de precios
    */                    
    IF TRUE <> (B-DPEDI.Libre_c04 > '') THEN NEXT.

    /* 1ro. Calculamos el margen de utilidad */
    RUN PRI_Margen-Utilidad-Ventas (INPUT LogParteEscalera,
                                    INPUT B-CPEDI.Lista_de_Precios,
                                    INPUT B-DPEDI.CodMat,
                                    INPUT B-DPEDI.UndVta,
                                    INPUT ((B-DPEDI.ImpLin - B-DPEDI.ImpDto2)/ B-DPEDI.CanPed),
                                    INPUT B-CPEDI.CodMon,
                                    OUTPUT x-Margen,
                                    OUTPUT x-Limite,
                                    OUTPUT pError).
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.  /* Error CRÍTICO */
    /* 2do. Verificamos si está configurado como una alerta por GG */
    IF pError > '' THEN DO:
        /* Error por margen de utilidad */
/*         RUN PRI_Alerta-de-Margen (INPUT B-DPEDI.CodMat, OUTPUT pAlerta). */
/*         IF pAlerta = NO THEN DO:                                         */
/*             pError = pError + CHR(10) + 'No admitido'.                   */
/*             RETURN 'ADM-ERROR'.                                          */
/*         END.                                                             */
        pError = ''.
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

