&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
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

/* *************************************************************************************** */
/* RUTINAS GENERALES DE CIERRE DE HOJA DE RUTA */
/* *************************************************************************************** */
/* RHC 19.06.2012 Cerramos Ccbcbult POR ORDENES DE DESPACHO */
FOR EACH Di-RutaD OF Di-RutaC NO-LOCK WHERE Di-RutaD.FlgEst = "C",    /* SOLO ENTREGADOS */
    FIRST Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = Di-RutaC.codcia
    AND Ccbcdocu.coddoc = Di-RutaD.codref
    AND Ccbcdocu.nrodoc = Di-RutaD.nroref,
    FIRST Ccbcbult EXCLUSIVE-LOCK WHERE CcbCBult.CodCia = Ccbcdocu.codcia
    AND CcbCBult.CodDoc = Ccbcdocu.Libre_C01      /*Ccbcdocu.codped*/
    AND CcbCBult.NroDoc = Ccbcdocu.Libre_C02      /*Ccbcdocu.nroped*/
    AND CcbCBult.Chr_01 = "P"
    ON ERROR UNDO, THROW:
    CcbCBult.Chr_01 = "C".
END.
/* *************************************************************************************** */
/* RHC 20.08.2012 Cerramos Ccbcbult POR TRANSFERENCIAS */
/* Ic 13Mar205 considerar OTR */
/* *************************************************************************************** */
FOR EACH Di-RutaG OF Di-RutaC NO-LOCK WHERE Di-RutaG.FlgEst = "C",    /* SOLO ENTREGADOS */
    EACH Ccbcbult EXCLUSIVE-LOCK USE-INDEX Llave03 WHERE CcbCBult.CodCia = Di-RutaC.codcia
    AND CcbCBult.CodDoc = "TRA"
    AND CcbCBult.NroDoc = STRING(Di-RutaG.serref, '999') + STRING(Di-RutaG.nroref, '999999')
    ON ERROR UNDO, THROW:
    IF CcbCBult.Chr_01 = "P" THEN CcbCBult.Chr_01 = "C".
END.
FOR EACH Di-RutaG OF Di-RutaC NO-LOCK WHERE Di-RutaG.FlgEst = "C",    /* SOLO ENTREGADOS */
    EACH Ccbcbult EXCLUSIVE-LOCK USE-INDEX Llave03 WHERE CcbCBult.CodCia = Di-RutaC.codcia
    AND CcbCBult.CodDoc = "OTR"
    AND CcbCBult.NroDoc = STRING(Di-RutaG.serref, '999') + STRING(Di-RutaG.nroref, '999999')
    ON ERROR UNDO, THROW:
    IF CcbCBult.Chr_01 = "P" THEN CcbCBult.Chr_01 = "C".
END.
/* *************************************************************************************** */
/* ------------- R A C K S --------------------------- */
/* Ic - 13Mar2015 */
/* *************************************************************************************** */
lOrdenes = "".
FOR EACH Di-RutaD OF Di-RutaC NO-LOCK ,
    FIRST Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = Di-RutaC.codcia
    AND Ccbcdocu.coddoc = Di-RutaD.codref
    AND Ccbcdocu.nrodoc = Di-RutaD.nroref,
    EACH Ccbcbult EXCLUSIVE-LOCK WHERE CcbCBult.CodCia = Ccbcdocu.codcia
    AND CcbCBult.CodDoc = Ccbcdocu.Libre_C01      /*O/D*/
    AND CcbCBult.NroDoc = Ccbcdocu.Libre_C02      /*Nro O/D*/
    ON ERROR UNDO, THROW:
    IF NOT (CcbCBult.Chr_01 = "P" AND LOOKUP(Ccbcdocu.Libre_C02,lOrdenes) = 0) THEN NEXT.
    /* Guias devueltas TOTALES */
    IF Ccbcdocu.Libre_C01 = 'O/D' AND (di-rutad.flgest = 'X' OR 
                                       di-rutad.flgest = 'N' OR 
                                       di-rutad.flgest = 'NR') THEN DO:
        lHRuta = "*" + TRIM(di-rutad.nrodoc) + "*".
        /* Busco la Orden en el RACK */
        FIND FIRST vtadtabla WHERE vtadtabla.codcia = s-codcia AND
            vtadtabla.tabla = 'MOV-RACK-DTL' AND
            vtadtabla.libre_c03 = 'O/D' AND
            vtadtabla.llavedetalle = ccbcdocu.libre_c02 AND
            vtadtabla.libre_c05 matches lHRuta NO-LOCK NO-ERROR.
        IF AVAILABLE vtadtabla THEN DO:
            ASSIGN CcbCBult.DEC_01 = CcbCBult.DEC_01 - vtadtabla.libre_d01.
            IF CcbCBult.DEC_01 < 0 THEN DO:
                ASSIGN ccbcbult.DEC_01 = 0.
            END.
            IF lOrdenes <> "" THEN DO:
                lOrdenes = lOrdenes + ",".
            END.
            lOrdenes = lOrdenes + trim(Ccbcdocu.Libre_C02).
        END.
    END.
END.
/* *************************************************************************************** */
/* Las Ordenes de Transferencias OTR y/o TRA */
/* *************************************************************************************** */
DEFINE BUFFER b-CcbCBult FOR CcbCBult.
lOrdenes = "".
/* Para NO ENTREGADOS/DEVUELTOS */
FOR EACH Di-RutaG OF Di-RutaC NO-LOCK WHERE LOOKUP(Di-RutaG.FlgEst,"X,N,NR") > 0:
    FIND FIRST almcmov WHERE almcmov.codcia = DI-RutaC.codcia AND 
        almcmov.codalm = di-rutaG.codalm AND
        almcmov.tipmov = di-rutaG.tipmov AND
        almcmov.codmov = di-rutaG.codmov AND 
        almcmov.nroser = di-rutaG.serref AND
        almcmov.nrodoc = di-rutaG.nroref NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almcmov THEN NEXT.
    IF almcmov.codref = 'OTR' THEN DO:
        /* Orden de Transferencia */
        lCodDoc = almcmov.codref.
        lNroDoc = almcmov.nroref.
    END.
    ELSE DO:
        /* Transferencia entre almacenes */
        lCodDoc = 'TRA'.
        lNroDoc = STRING(almcmov.nroser,"999") + STRING(almcmov.nrodoc,"999999").
    END.
    /* Buscar los bultos */
    FIND FIRST CcbCBult WHERE CcbCBult.codcia = s-codcia AND 
        CcbCBult.coddoc = lCodDoc AND 
        CcbCBult.nrodoc = lNroDoc NO-LOCK NO-ERROR.
    IF AVAILABLE CcbCBult AND LOOKUP(lNroDoc,lOrdenes) = 0 THEN DO:
        lHRuta = "*" + TRIM(di-rutaG.nrodoc) + "*".
        /* Chequeo si la O/D esta en el detalle del RACK */
        FIND FIRST vtadtabla WHERE vtadtabla.codcia = DI-RutaC.codcia AND
            vtadtabla.tabla = 'MOV-RACK-DTL' AND 
            vtadtabla.libre_c03 = lCodDoc AND 
            vtadtabla.llavedetalle = lNroDoc AND
            vtadtabla.libre_c05 matches lHRuta NO-LOCK NO-ERROR.
        IF AVAILABLE vtadtabla THEN DO:
            lRowid = ROWID(CcbCBult).
            FIND FIRST b-CcbCBult WHERE ROWID(b-CcbCBult) = lRowid EXCLUSIVE NO-ERROR.
            IF AVAILABLE b-CcbCBult THEN DO:
                ASSIGN b-CcbCBult.DEC_01 = b-CcbCBult.DEC_01 - vtadtabla.libre_d01.
                IF b-CcbCBult.DEC_01 < 0 THEN DO:
                    ASSIGN b-ccbcbult.DEC_01 = 0.
                END.
                IF lOrdenes <> "" THEN DO:
                    lOrdenes = lOrdenes + ",".
                END.
                lOrdenes = lOrdenes + trim(lNroDoc).
            END.
        END.
    END.
END.
IF AVAILABLE(Ccbcbult)   THEN RELEASE Ccbcbult.
IF AVAILABLE(b-Ccbcbult) THEN RELEASE b-Ccbcbult.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 4.35
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


