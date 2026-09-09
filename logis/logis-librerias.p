&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-RutaC FOR DI-RutaC.
DEFINE TEMP-TABLE t-ccbcdocu NO-UNDO LIKE CcbCDocu.



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

/* Sintaxis 
DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN <libreria> PERSISTENT SET hProc.
RUN <libreria>.rutina_internaIN hProc (input  buffer tt-excel:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .
DELETE PROCEDURE hProc.
*/


DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.

DEFINE BUFFER x-faccpedi FOR faccpedi.   
DEFINE BUFFER x-ccbcdocu FOR ccbcdocu.

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
      TABLE: B-RutaC B "?" ? INTEGRAL DI-RutaC
      TABLE: t-ccbcdocu T "?" NO-UNDO INTEGRAL CcbCDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 9.73
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-FLETE_Resumen-HR) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FLETE_Resumen-HR Procedure 
PROCEDURE FLETE_Resumen-HR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       De una H/R cerrada
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pNroDoc AS CHAR.
/*DEF OUTPUT PARAMETER pPeso AS DECI.
DEF OUTPUT PARAMETER pVolumen AS DECI.*/
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF BUFFER B-RutaC FOR Di-RutaC.
DEF BUFFER B-RutaD FOR Di-RutaD.
DEF BUFFER B-RutaG FOR Di-RutaG.
DEF BUFFER B-RutaDG FOR Di-RutaDG.

/* Buscamos Hoja de Ruta */
FIND B-RutaC WHERE B-RutaC.codcia = s-codcia
    AND B-RutaC.coddiv = pCodDiv
    AND B-RutaC.coddoc = pCodDoc
    AND B-RutaC.nrodoc = pNroDoc
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-RutaC THEN DO:
    pMensaje = "NO se pudo encontrar la H/R con los siguientes datos:" + CHR(10) +
        pcoddiv + " " + pcoddoc + " " + pnrodoc.
    RETURN 'ADM-ERROR'.
END.
IF B-RutaC.FlgEst <> "C" THEN RETURN "OK".
IF B-RutaC.CodDoc <> "H/R" THEN RETURN "OK".
IF NOT CAN-FIND(FIRST B-RutaG OF B-RutaC NO-LOCK) THEN RETURN "OK".     /* NO hay guias por transferencias */

DEF VAR x-Peso AS DECI NO-UNDO.
DEF VAR x-Volumen AS DECI NO-UNDO.

/* ************************************************************************************************************** */
/* 1ro. Calculamos el Peso y Volumen por TODA la H/R */
/* ************************************************************************************************************** */
x-Peso = 0.
x-Volumen = 0.

FOR EACH B-RutaD OF B-RutaC NO-LOCK,
    FIRST CcbCDocu WHERE CcbCDocu.CodCia = B-RutaD.CodCia
    AND CcbCDocu.CodDoc = B-RutaD.CodRef
    AND CcbCDocu.NroDoc = B-RutaD.NroRef NO-LOCK:
    /* Acumulamos Peso y Volumen */
    FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK, FIRST Almmmatg OF Ccbddocu NO-LOCK:
        x-Peso = x-Peso + (Ccbddocu.CanDes * Ccbddocu.Factor) * Almmmatg.PesMat.                          /* En kg */
        x-Volumen = x-Volumen + (Ccbddocu.CanDes * Ccbddocu.Factor * Almmmatg.Libre_d02 / 1000000).       /* En m3 */
    END.
END.
FOR EACH B-RutaG OF B-RutaC NO-LOCK,
    FIRST Almcmov WHERE Almcmov.CodCia = B-RutaG.CodCia
    AND Almcmov.CodAlm = B-RutaG.CodAlm
    AND Almcmov.TipMov = B-RutaG.Tipmov
    AND Almcmov.CodMov = B-RutaG.Codmov
    AND Almcmov.NroSer = B-RutaG.serref
    AND Almcmov.NroDoc = B-RutaG.nroref NO-LOCK:
    /* Acumulamos Peso y Volumen */
    FOR EACH Almdmov OF Almcmov NO-LOCK, FIRST Almmmatg OF Almdmov NO-LOCK:
        x-Peso = x-Peso + (Almdmov.CanDes * Almdmov.Factor) * Almmmatg.PesMat.                          /* En kg */
        x-Volumen = x-Volumen + (Almdmov.CanDes * Almdmov.Factor * Almmmatg.Libre_d02 / 1000000).       /* En m3 */
    END.
END.
FOR EACH B-RutaDG OF B-RutaC NO-LOCK,
    FIRST CcbCDocu WHERE CcbCDocu.CodCia = B-RutaDG.CodCia
    AND CcbCDocu.CodDoc = "G/R"
    AND CcbCDocu.NroDoc = B-RutaDG.NroRef 
    AND Ccbcdocu.tpofac = 'I' NO-LOCK:
    /* Acumulamos Peso y Volumen */
    FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK, FIRST Almmmatg OF Ccbddocu NO-LOCK:
        x-Peso = x-Peso + (Ccbddocu.CanDes * Ccbddocu.Factor) * Almmmatg.PesMat.                          /* En kg */
        x-Volumen = x-Volumen + (Ccbddocu.CanDes * Ccbddocu.Factor * Almmmatg.Libre_d02 / 1000000).       /* En m3 */
    END.
END.
/* ASSIGN                    */
/*     pPeso = x-Peso        */
/*     pVolumen = x-Volumen. */
/* ************************************************************************************************************** */
/* 2do. Calculamos la Tarifa por Flete */
/* Supuesto: que el total del camión va a una Zona Geográfica única */
/* ************************************************************************************************************** */
DEF VAR x-Origen  AS CHAR NO-UNDO.
DEF VAR x-Destino AS CHAR NO-UNDO.

FIND FIRST TabGener WHERE TabGener.CodCia = s-codcia
    AND TabGener.Clave = 'ZG_DIVI'
    AND TabGener.Libre_c01 = pCodDiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE TabGener THEN DO:
    pMensaje = "NO existe la Zona Geográfica para la división " + pCodDiv.
    RETURN 'ADM-ERROR'.
END.
x-Origen = TabGener.Codigo.

FOR FIRST B-RutaG OF B-RutaC NO-LOCK,
    FIRST Almcmov WHERE Almcmov.CodCia = B-RutaG.CodCia
    AND Almcmov.CodAlm = B-RutaG.CodAlm
    AND Almcmov.TipMov = B-RutaG.Tipmov
    AND Almcmov.CodMov = B-RutaG.Codmov
    AND Almcmov.NroSer = B-RutaG.serref
    AND Almcmov.NroDoc = B-RutaG.nroref NO-LOCK,
    /* Buscamos el almacén destino */
    FIRST Almacen NO-LOCK WHERE Almacen.codcia = s-codcia
    AND Almacen.codalm = Almcmov.AlmDes,
    FIRST TabGener NO-LOCK WHERE TabGener.CodCia = s-codcia
    AND TabGener.Clave = 'ZG_DIVI'
    AND TabGener.Libre_c01 = Almacen.CodDiv:
    ASSIGN
        x-Destino = TabGener.Codigo.
    /* Buscamos tarifario por peso */
    FIND FIRST flete_tarifario WHERE flete_tarifario.CodCia = s-codcia
        AND flete_tarifario.Tipo = "Peso"
        AND flete_tarifario.Origen = x-Origen
        AND flete_tarifario.Destino = x-Destino
        AND x-Peso >= flete_tarifario.Minimo 
        AND x-Peso < flete_tarifario.Maximo 
        NO-LOCK NO-ERROR.
    IF AVAILABLE flete_tarifario THEN DO:
        RUN FLETE_Resumen-HR-Graba (INPUT B-RutaC.NroDoc,
                                    INPUT B-RutaC.FchSal,
                                    INPUT x-Origen,
                                    INPUT x-Destino,
                                    INPUT x-Peso,
                                    OUTPUT pMensaje).
    END.
    /* Buscamos tarifario por volumen */
    FIND FIRST flete_tarifario WHERE flete_tarifario.CodCia = s-codcia
        AND flete_tarifario.Tipo = "Volumen"
        AND flete_tarifario.Origen = x-Origen
        AND flete_tarifario.Destino = x-Destino
        AND x-Volumen >= flete_tarifario.Minimo 
        AND x-Volumen < flete_tarifario.Maximo 
        NO-LOCK NO-ERROR.
    IF AVAILABLE flete_tarifario THEN DO:
        RUN FLETE_Resumen-HR-Graba (INPUT B-RutaC.NroDoc,
                                    INPUT B-RutaC.FchSal,
                                    INPUT x-Origen,
                                    INPUT x-Destino,
                                    INPUT x-Volumen,
                                    OUTPUT pMensaje).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    END.
END.
RETURN 'OK'.

END PROCEDURE.


PROCEDURE FLETE_Resumen-HR-Graba:
/* ***************************** */

    DEF INPUT PARAMETER pNroDoc   AS CHAR.
    DEF INPUT PARAMETER pFchSal   AS DATE.
    DEF INPUT PARAMETER pOrigen   AS CHAR.
    DEF INPUT PARAMETER pDestino  AS CHAR.
    DEF INPUT PARAMETER pValor    AS DECI.
    DEF OUTPUT PARAMETER pMensaje AS CHAR.

    IF pValor = 0 THEN RETURN 'OK'.

    DEF VAR pCuenta AS INTE NO-UNDO.

    FIND FIRST flete_resumen_hr WHERE flete_resumen_hr.CodCia = s-codcia
        AND flete_resumen_hr.FchSal = pFchSal
        AND flete_resumen_hr.Origen = pOrigen
        AND flete_resumen_hr.Destino = pDestino
        AND flete_resumen_hr.Tipo = flete_tarifario.Tipo
        NO-LOCK NO-ERROR.
    IF AVAILABLE flete_resumen_hr THEN DO:
        FIND CURRENT flete_resumen_hr EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}
            UNDO, RETURN 'ADM-ERROR'.
        END.
    END.
    ELSE DO:
        CREATE flete_resumen_hr.
    END.
    ASSIGN
        flete_resumen_hr.CodCia = s-codcia
        flete_resumen_hr.FchSal = pFchSal
        flete_resumen_hr.Origen = pOrigen
        flete_resumen_hr.Destino = pDestino
        flete_resumen_hr.Tipo = flete_tarifario.Tipo.
    ASSIGN
        flete_resumen_hr.Cantidad = flete_resumen_hr.Cantidad + pValor
        flete_resumen_hr.Importe = flete_resumen_hr.Importe + (pValor * flete_tarifario.Flete_Unitario)
        .

    FIND FIRST flete_detallado_hr WHERE flete_detallado_hr.CodCia = s-codcia 
        AND flete_detallado_hr.Origen = pOrigen
        AND flete_detallado_hr.CodDoc = "H/R"
        AND flete_detallado_hr.NroDoc = pNroDoc
        AND flete_detallado_hr.Tipo = flete_tarifario.Tipo
        NO-LOCK NO-ERROR.
    IF AVAILABLE flete_detallado_hr THEN DO:
        FIND CURRENT flete_detallado_hr EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}
            UNDO, RETURN 'ADM-ERROR'.
        END.
    END.
    ELSE DO:
        CREATE flete_detallado_hr.
    END.
    ASSIGN
        flete_detallado_hr.CodCia = s-codcia 
        flete_detallado_hr.Origen = pOrigen
        flete_detallado_hr.CodDoc = "H/R"
        flete_detallado_hr.NroDoc = pNroDoc
        flete_detallado_hr.Destino = pDestino
        flete_detallado_hr.FchSal = pFchSal
        flete_detallado_hr.Cantidad = flete_detallado_hr.Cantidad + pValor
        flete_detallado_hr.Flete_Unitario = flete_tarifario.Flete_Unitario
        flete_detallado_hr.Importe = flete_detallado_hr.Importe + (pValor * flete_tarifario.Flete_Unitario)
        flete_detallado_hr.Tipo = flete_tarifario.Tipo.
    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Grupo-reparto) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Grupo-reparto Procedure 
PROCEDURE Grupo-reparto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodDoc AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pNroDoc AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pDeliveryGroup AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pInvoiceCustomerGroup AS CHAR NO-UNDO.

DEFINE VAR x-nro-cot AS CHAR INIT "".
DEFINE VAR x-cod-cot AS CHAR INIT "".
DEFINE VAR x-nro-doc AS CHAR INIT "".
DEFINE VAR x-cod-doc AS CHAR INIT "".

pDeliveryGroup = "".
pInvoiceCustomerGroup = "".

CASE pCodDoc :
    WHEN "COT" THEN DO:
        x-nro-cot = pNroDoc.
        x-cod-cot = pCodDoc.
    END.
    WHEN "PED" THEN DO:
        FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                                    x-faccpedi.coddoc = pCodDoc AND
                                    x-faccpedi.nroped = pNroDoc NO-LOCK NO-ERROR.
        IF AVAILABLE x-faccpedi THEN DO:
            x-cod-cot = x-faccpedi.codref.  /* Deberia ser COT */
            x-nro-cot = x-faccpedi.nroref.
        END.
    END.
    WHEN "O/D" THEN DO:
        FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                                    x-faccpedi.coddoc = pCodDoc AND
                                    x-faccpedi.nroped = pNroDoc NO-LOCK NO-ERROR.
        IF AVAILABLE x-faccpedi THEN DO:
            x-cod-doc = x-faccpedi.codref.  /* Deberia ser PED */
            x-nro-doc = x-faccpedi.nroref.

            FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                                        x-faccpedi.coddoc = x-cod-doc AND
                                        x-faccpedi.nroped = x-nro-doc NO-LOCK NO-ERROR.
            IF AVAILABLE x-faccpedi THEN DO:
                x-cod-cot = x-faccpedi.codref.  /* Deberia ser COT */
                x-nro-cot = x-faccpedi.nroref.
            END.
        END.
    END.
END CASE.

FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                            x-faccpedi.coddoc = x-cod-cot AND
                            x-faccpedi.nroped = x-nro-cot NO-LOCK NO-ERROR.
IF AVAILABLE x-faccpedi THEN DO:
    pDeliveryGroup = x-faccpedi.DeliveryGroup.
    pInvoiceCustomerGroup = x-faccpedi.InvoiceCustomerGroup.
END.

RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GR_peso-volumen-bultos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GR_peso-volumen-bultos Procedure 
PROCEDURE GR_peso-volumen-bultos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodDiv AS CHAR NO-UNDO.     /* Acepta vacios */
DEFINE INPUT PARAMETER pCodDoc AS CHAR NO-UNDO.      /* G/R */
DEFINE INPUT PARAMETER pNroDoc AS CHAR NO-UNDO.      
DEFINE OUTPUT PARAMETER pPeso AS DEC NO-UNDO.
DEFINE OUTPUT PARAMETER pVolumen AS DEC NO-UNDO.
DEFINE OUTPUT PARAMETER pBultos AS INT NO-UNDO.

DEFINE VAR z-peso AS DEC.
DEFINE VAR z-volumen AS DEC.
DEFINE VAR z-bultos AS INT.
DEFINE VAR x-codguia AS CHAR.
DEFINE VAR x-nroguia AS CHAR.

z-bultos = 0.
pPeso = 0.
pVolumen = 0.
pBultos = 0.

IF TRUE <> (pCoddiv > "") THEN DO:
    /* No vino division */
    FIND FIRST x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND
                                x-ccbcdocu.coddoc = pCodDoc AND
                                x-ccbcdocu.nrodoc = pNroDoc NO-LOCK NO-ERROR.
END.
ELSE DO:
    FIND FIRST x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND
                                x-ccbcdocu.coddiv = pCodDiv AND
                                x-ccbcdocu.coddoc = pCodDoc AND
                                x-ccbcdocu.nrodoc = pNroDoc NO-LOCK NO-ERROR.
END.

IF NOT AVAILABLE x-ccbcdocu THEN RETURN.

IF TRUE <> (pCoddiv > "") THEN pCoddiv = x-ccbcdocu.coddiv.

/* Peso y volumen */
FOR EACH Ccbddocu OF x-Ccbcdocu NO-LOCK, FIRST Almmmatg OF Ccbddocu NO-LOCK:
    pPeso = pPeso + (Ccbddocu.candes * Ccbddocu.factor * Almmmatg.pesmat).
    IF Almmmatg.libre_d02 = ? THEN DO:
        /* ES NULO */
    END.
    ELSE DO:
        pvolumen = pvolumen + (Ccbddocu.candes * Ccbddocu.factor * (Almmmatg.libre_d02 / 1000000) ).
    END.
    
END.

/* Grupo de reparto */
DEFINE VAR x-DeliveryGroup AS CHAR.
DEFINE VAR x-InvoiCustomerGroup AS CHAR.

RUN Grupo-reparto(INPUT x-ccbcdocu.libre_c01, INPUT x-ccbcdocu.libre_c02,   /* O/D */
                            OUTPUT x-DeliveryGroup, OUTPUT x-InvoiCustomerGroup).       

IF x-DeliveryGroup = "" OR x-InvoiCustomerGroup = "" THEN DO:
    FOR EACH CcbCBult WHERE CcbCBult.CodCia = x-Ccbcdocu.codcia AND
        CcbCBult.CodDiv = x-Ccbcdocu.coddiv AND 
        CcbCBult.CodDoc = x-ccbcdocu.libre_c01 AND      /* O/D */
        CcbCBult.NroDoc = x-ccbcdocu.libre_c02
        NO-LOCK:
        pBultos = pBultos + CcbCBult.Bultos.
    END.
END.
ELSE DO:
    /* Todas las FAI involucradas en la misma G/R */
    DEF BUFFER bf-ccbcdocu FOR ccbcdocu.
    FOR EACH bf-ccbcdocu WHERE bf-ccbcdocu.codcia = s-codcia AND
                                bf-ccbcdocu.codref = pCodDoc AND   /* G/R */
                                bf-ccbcdocu.nroref = pNroDoc AND
                                bf-ccbcdocu.coddoc = 'FAI' AND 
                                bf-ccbcdocu.flgest <> 'A' NO-LOCK:

        FOR EACH CcbCBult WHERE CcbCBult.CodCia = bf-Ccbcdocu.codcia AND
            CcbCBult.CodDiv = bf-Ccbcdocu.coddiv AND 
            CcbCBult.CodDoc = bf-ccbcdocu.libre_c01 AND      /* O/D */
            CcbCBult.NroDoc = bf-ccbcdocu.libre_c02 NO-LOCK:
            pBultos = pBultos + CcbCBult.Bultos.
        END.
    END.
END.

/* 21/07/2022 En caso falle todo */
IF pBultos = 0 THEN DO:
    FOR EACH CcbCBult WHERE CcbCBult.CodCia = x-Ccbcdocu.codcia AND
        CcbCBult.CodDoc = x-ccbcdocu.libre_c01 AND      /* O/D */
        CcbCBult.NroDoc = x-ccbcdocu.libre_c02
        NO-LOCK:
        pBultos = pBultos + CcbCBult.Bultos.
    END.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-HR_Peso-y-Volumen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HR_Peso-y-Volumen Procedure 
PROCEDURE HR_Peso-y-Volumen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF INPUT PARAMETER pCodDiv AS CHAR.
  DEF INPUT PARAMETER pCodDoc AS CHAR.
  DEF INPUT PARAMETER pNroDoc AS CHAR.

  DEF OUTPUT PARAMETER pPeso AS DECI.
  DEF OUTPUT PARAMETER pVolumen AS DECI.

  FIND FIRST Di-RutaC WHERE DI-RutaC.CodCia = s-codcia AND
      DI-RutaC.CodDiv = pCodDiv AND
      DI-RutaC.CodDoc = pCodDoc AND
      DI-RutaC.NroDoc = pNroDoc NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Di-RutaC THEN RETURN.

  DEF BUFFER FACTURA FOR Ccbcdocu.
  DEF BUFFER x-ccbcdocu FOR Ccbcdocu.

  DEFINE VAR x-DeliveryGroup AS CHAR.
  DEFINE VAR x-InvoiCustomerGroup AS CHAR.
  DEFINE VAR x-codfac AS CHAR.
  DEFINE VAR x-nrofac AS CHAR.
  DEFINE VAR x-Cancelado AS CHAR NO-UNDO.

  FOR EACH Di-RutaD OF Di-RutaC NO-LOCK,
      FIRST Ccbcdocu NO-LOCK WHERE CcbCDocu.CodCia = s-codcia
      AND CcbCDocu.CodDoc = DI-RutaD.CodRef       /* G/R */
      AND CcbCDocu.NroDoc = DI-RutaD.NroRef:
      /* ********************************************************************************* */
      /* Definimos la G/R válidas */
      /* ********************************************************************************* */
      x-codfac = "".
      x-nrofac = "".
      x-Cancelado = ''.
      EMPTY TEMP-TABLE t-ccbcdocu.
      RUN Grupo-reparto (INPUT ccbcdocu.libre_c01, 
                         INPUT ccbcdocu.libre_c02,     /* O/D */
                         OUTPUT x-DeliveryGroup, 
                         OUTPUT x-InvoiCustomerGroup).             
      IF x-DeliveryGroup = "" OR x-InvoiCustomerGroup = "" THEN DO:        
          FIND FIRST FACTURA WHERE FACTURA.codcia = Ccbcdocu.codcia
              AND FACTURA.coddoc = Ccbcdocu.codref
              AND FACTURA.nrodoc = Ccbcdocu.nroref NO-LOCK NO-ERROR.
          IF NOT AVAILABLE FACTURA THEN NEXT.
          FIND FIRST gn-convt WHERE gn-ConVt.Codig = FACTURA.fmapgo NO-LOCK NO-ERROR.
          IF NOT AVAILABLE gn-convt THEN NEXT.
          ASSIGN
              x-codfac = FACTURA.coddoc
              x-nrofac = FACTURA.nrodoc
              x-cancelado = (IF FACTURA.FlgEst = "C" THEN "CANCELADO" ELSE "").
          CREATE t-ccbcdocu.
          BUFFER-COPY ccbcdocu TO t-ccbcdocu.
      END.
      ELSE DO:
          /* Ic - 02Oct2020 : G/R x grupo de reparto caso BCP */
          /* No esta facturado las G/R */
          /* Todas las FAIS del grupos de reparto */
          FOR EACH x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND
              x-ccbcdocu.coddoc = 'FAI' AND 
              x-ccbcdocu.codref = ccbcdocu.coddoc AND /* G/R */
              x-ccbcdocu.nroref = ccbcdocu.nrodoc AND
              x-ccbcdocu.flgest <> 'A' NO-LOCK:
              FIND FIRST gn-convt WHERE gn-ConVt.Codig = x-ccbcdocu.fmapgo NO-LOCK NO-ERROR.
              IF NOT AVAILABLE gn-convt THEN NEXT.
              CREATE t-ccbcdocu.
              BUFFER-COPY x-ccbcdocu TO t-ccbcdocu.
          END.
      END.
      /* ********************************************************************************* */
      /* ********************************************************************************* */
      FOR EACH t-ccbcdocu NO-LOCK:
          /* PESO y VOLUMEN */
          /* 27/02/2023 Datos acumulados por el trigger */
          ASSIGN
              pPeso = pPeso + t-Ccbcdocu.Libre_d01
              pVolumen = pVolumen + t-Ccbcdocu.Libre_d02.
      END.
  END.
  /* *************************************************************************************** */
  /* GIAS DE REMISION POR TRANSFERENCIA */
  /* *************************************************************************************** */
  FOR EACH Di-RutaG OF Di-RutaC NO-LOCK,
      FIRST Almcmov NO-LOCK WHERE Almcmov.CodCia = Di-RutaG.CodCia
        AND Almcmov.CodAlm = Di-RutaG.CodAlm
        AND Almcmov.TipMov = Di-RutaG.Tipmov
        AND Almcmov.CodMov = Di-RutaG.Codmov
        AND Almcmov.NroSer = Di-RutaG.serref
        AND Almcmov.NroDoc = Di-RutaG.nroref:
      /* 27/02/2023 Datos acumulados por el trigger */
      ASSIGN
          pPeso = pPeso + Almcmov.Libre_d01
          pVolumen = pVolumen + Almcmov.Libre_d02.
  END.
  /* *************************************************************************************** */
  /* ITINIRANTES */
  /* *************************************************************************************** */
  FOR EACH Di-RutaDG OF Di-RutaC NO-LOCK,
      FIRST Ccbcdocu NO-LOCK WHERE CcbCDocu.CodCia = s-codcia
        AND CcbCDocu.CodDoc = Di-RutaDG.CodRef       /* G/R */
        AND CcbCDocu.NroDoc = Di-RutaDG.NroRef:
      /* 27/02/2023 Datos acumulados por el trigger */
      ASSIGN
          pPeso = pPeso + Ccbcdocu.Libre_d01
          pVolumen = pVolumen + Ccbcdocu.Libre_d02.
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-HR_Peso-y-Volumen-Calculo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HR_Peso-y-Volumen-Calculo Procedure 
PROCEDURE HR_Peso-y-Volumen-Calculo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pNroDoc AS CHAR.

FIND FIRST Di-RutaC WHERE DI-RutaC.CodCia = s-codcia AND
    DI-RutaC.CodDiv = pCodDiv AND
    DI-RutaC.CodDoc = pCodDoc AND
    DI-RutaC.NroDoc = pNroDoc NO-LOCK NO-ERROR.
IF NOT AVAILABLE Di-RutaC THEN RETURN.

DEF BUFFER FACTURA FOR Ccbcdocu.
DEF BUFFER x-ccbcdocu FOR Ccbcdocu.

DEFINE VAR x-DeliveryGroup AS CHAR.
DEFINE VAR x-InvoiCustomerGroup AS CHAR.
DEFINE VAR x-codfac AS CHAR.
DEFINE VAR x-nrofac AS CHAR.
DEFINE VAR x-Cancelado AS CHAR NO-UNDO.

DEF BUFFER B-CDOCU FOR ccbcdocu.
DEF BUFFER B-DDOCU FOR ccbddocu.
DEF BUFFER B-MATG  FOR Almmmatg.
DEF BUFFER B-CMOV FOR almcmov.
DEF BUFFER B-DMOV FOR almdmov.

DEF VAR x-Peso AS DECI NO-UNDO.
DEF VAR x-Volumen AS DECI NO-UNDO.

FOR EACH Di-RutaD OF Di-RutaC NO-LOCK,
    FIRST Ccbcdocu NO-LOCK WHERE CcbCDocu.CodCia = s-codcia
    AND CcbCDocu.CodDoc = DI-RutaD.CodRef       /* G/R */
    AND CcbCDocu.NroDoc = DI-RutaD.NroRef:
    /* ********************************************************************************* */
    /* Definimos la G/R válidas */
    /* ********************************************************************************* */
    x-codfac = "".
    x-nrofac = "".
    x-Cancelado = ''.
    EMPTY TEMP-TABLE t-ccbcdocu.
    RUN Grupo-reparto (INPUT ccbcdocu.libre_c01, 
                       INPUT ccbcdocu.libre_c02,     /* O/D */
                       OUTPUT x-DeliveryGroup, 
                       OUTPUT x-InvoiCustomerGroup).             
    IF x-DeliveryGroup = "" OR x-InvoiCustomerGroup = "" THEN DO:        
        FIND FIRST FACTURA NO-LOCK WHERE FACTURA.codcia = Ccbcdocu.codcia
            AND FACTURA.coddoc = Ccbcdocu.codref
            AND FACTURA.nrodoc = Ccbcdocu.nroref NO-ERROR.
        IF NOT AVAILABLE FACTURA THEN NEXT.
        FIND FIRST gn-convt NO-LOCK WHERE gn-ConVt.Codig = FACTURA.fmapgo NO-ERROR.
        IF NOT AVAILABLE gn-convt THEN NEXT.
        ASSIGN
            x-codfac = FACTURA.coddoc
            x-nrofac = FACTURA.nrodoc
            x-cancelado = (IF FACTURA.FlgEst = "C" THEN "CANCELADO" ELSE "").
        CREATE t-ccbcdocu.
        BUFFER-COPY ccbcdocu TO t-ccbcdocu.
    END.
    ELSE DO:
        /* Ic - 02Oct2020 : G/R x grupo de reparto caso BCP */
        /* No esta facturado las G/R */
        /* Todas las FAIS del grupos de reparto */
        FOR EACH x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND
            x-ccbcdocu.coddoc = 'FAI' AND 
            x-ccbcdocu.codref = ccbcdocu.coddoc AND /* G/R */
            x-ccbcdocu.nroref = ccbcdocu.nrodoc AND
            x-ccbcdocu.flgest <> 'A' NO-LOCK:
            FIND FIRST gn-convt NO-LOCK WHERE gn-ConVt.Codig = x-ccbcdocu.fmapgo NO-ERROR.
            IF NOT AVAILABLE gn-convt THEN NEXT.
            CREATE t-ccbcdocu.
            BUFFER-COPY x-ccbcdocu TO t-ccbcdocu.
        END.
    END.
    /* ********************************************************************************* */
    /* ********************************************************************************* */
    FOR EACH t-ccbcdocu NO-LOCK, FIRST B-CDOCU OF t-ccbcdocu EXCLUSIVE-LOCK:
        /* PESO y VOLUMEN */
        x-Peso = 0.      /* Peso en kg */
        x-Volumen = 0.      /* Volumen en m3 */
        FOR EACH B-DDOCU OF B-CDOCU NO-LOCK,FIRST B-MATG OF B-DDOCU NO-LOCK:
            x-Peso = x-Peso + (B-DDOCU.candes * B-DDOCU.factor * B-MATG.pesmat).
            x-Volumen = x-Volumen + (B-DDOCU.candes * B-DDOCU.factor * B-MATG.libre_d02 / 1000000).
        END.
        B-CDOCU.libre_d01 = x-Peso.
        B-CDOCU.libre_d02 = x-Volumen.
    END.
    RELEASE B-CDOCU.
END.
/* *************************************************************************************** */
/* GIAS DE REMISION POR TRANSFERENCIA */
/* *************************************************************************************** */
FOR EACH Di-RutaG OF Di-RutaC NO-LOCK,
    FIRST B-CMOV EXCLUSIVE-LOCK WHERE B-CMOV.CodCia = Di-RutaG.CodCia
      AND B-CMOV.CodAlm = Di-RutaG.CodAlm
      AND B-CMOV.TipMov = Di-RutaG.Tipmov
      AND B-CMOV.CodMov = Di-RutaG.Codmov
      AND B-CMOV.NroSer = Di-RutaG.serref
      AND B-CMOV.NroDoc = Di-RutaG.nroref:
    x-Peso = 0.      /* Peso en kg */
    x-Volumen = 0.      /* Volumen en m3 */
    FOR EACH B-DMOV OF B-CMOV NO-LOCK, FIRST B-MATG OF B-DMOV NO-LOCK:
        x-Peso = x-Peso + (B-DMOV.candes * B-DMOV.factor * B-MATG.pesmat).
        x-Volumen = x-Volumen + (B-DMOV.candes * B-DMOV.factor * B-MATG.libre_d02 / 1000000).
    END.
    B-CMOV.libre_d01 = x-Peso.
    B-CMOV.libre_d02 = x-Volumen.
END.
RELEASE B-CMOV.
/* *************************************************************************************** */
/* ITINIRANTES */
/* *************************************************************************************** */
FOR EACH Di-RutaDG OF Di-RutaC NO-LOCK,
    FIRST B-CDOCU EXCLUSIVE-LOCK WHERE B-CDOCU.CodCia = s-codcia
      AND B-CDOCU.CodDoc = Di-RutaDG.CodRef       /* G/R */
      AND B-CDOCU.NroDoc = Di-RutaDG.NroRef:
    /* PESO y VOLUMEN */
    x-Peso = 0.      /* Peso en kg */
    x-Volumen = 0.      /* Volumen en m3 */
    FOR EACH B-DDOCU OF B-CDOCU NO-LOCK,
        FIRST B-MATG OF B-DDOCU NO-LOCK:
        x-Peso = x-Peso + (B-DDOCU.candes * B-DDOCU.factor * B-MATG.pesmat).
        x-Volumen = x-Volumen + (B-DDOCU.candes * B-DDOCU.factor * B-MATG.libre_d02 / 1000000).
    END.
    B-CDOCU.libre_d01 = x-Peso.
    B-CDOCU.libre_d02 = x-Volumen.
END.
RELEASE B-CDOCU.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-LL_Actualiza-OD-Control) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LL_Actualiza-OD-Control Procedure 
PROCEDURE LL_Actualiza-OD-Control :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF BUFFER B-ORDENES FOR Faccpedi.        
DEF BUFFER B-ORDENESD FOR Facdpedi.
DEF BUFFER B-OD-CONTROLC FOR Faccpedi.
DEF BUFFER B-OD-CONTROLD FOR Facdpedi.

DEF INPUT PARAMETER pRowid AS ROWID.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

FIND B-ORDENES WHERE ROWID(B-ORDENES) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-ORDENES THEN RETURN 'OK'.
IF NOT (B-ORDENES.FlgEst = "P" AND B-ORDENES.FlgSit = "C") THEN RETURN "OK".
IF LOOKUP(B-ORDENES.coddoc, "O/D,OTR") = 0 THEN RETURN 'OK'.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i ~
        &Tabla="B-OD-CONTROLC" ~
        &Alcance="FIRST" ~
        &Condicion="B-OD-CONTROLC.codcia = B-ORDENES.codcia ~
                    AND B-OD-CONTROLC.coddiv = B-ORDENES.coddiv ~
                    AND B-OD-CONTROLC.coddoc = (IF B-ORDENES.coddoc = 'O/D' THEN 'ODP' ELSE 'OTP') ~
                    AND B-OD-CONTROLC.nroped = B-ORDENES.nroped" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" ~
        }
   ASSIGN
        B-OD-CONTROLC.FlgSit = "C".

   FOR EACH B-ORDENESD OF B-ORDENES NO-LOCK:
       FIND FIRST B-OD-CONTROLD OF B-OD-CONTROLC WHERE B-OD-CONTROLD.codmat = B-ORDENESD.codmat
           NO-LOCK NO-ERROR.
       IF NOT AVAILABLE B-OD-CONTROLD THEN NEXT.
       FIND CURRENT B-OD-CONTROLD EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
       IF ERROR-STATUS:ERROR THEN DO:
           {lib/mensaje-de-error.i &MensajeError="pMensaje"}
           UNDO RLOOP, RETURN 'ADM-ERROR'.
       END.
       ASSIGN
           B-OD-CONTROLD.CanAte = B-ORDENESD.CanPed.
   END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ODOTR_Listo-para-Facturar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ODOTR_Listo-para-Facturar Procedure 
PROCEDURE ODOTR_Listo-para-Facturar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAMETER pCodRef AS CHAR.    /* O/D OTR */
    DEF INPUT PARAMETER pNroRef AS CHAR.
    DEF OUTPUT PARAMETER pOk AS LOG.

    /* Verificamos si se marcar para fedatear una PHR */
    DEF VAR x-CuentaFallas AS INT NO-UNDO.

    pOk = NO.
    x-CuentaFallas = 0.
    FOR EACH VtaCDocu NO-LOCK WHERE VtaCDocu.CodCia = s-CodCia AND
        VtaCDocu.CodDiv = s-CodDiv AND
        VtaCDocu.CodPed = "HPK" AND      /* HPK */
        VtaCDocu.CodRef = pCodRef AND      
        VtaCDocu.NroRef = pNroRef:
        IF NOT (VtaCDocu.FlgEst = "P" AND VtaCDocu.FlgSit = "C") 
            THEN x-CuentaFallas = x-CuentaFallas + 1.
    END.
    IF x-CuentaFallas = 0 THEN pOk = YES.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PHR_Listo-para-Fedateo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PHR_Listo-para-Fedateo Procedure 
PROCEDURE PHR_Listo-para-Fedateo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAMETER pCodOri AS CHAR.
    DEF INPUT PARAMETER pNroOri AS CHAR.
    DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

    FIND B-RutaC WHERE B-RutaC.CodCia = s-CodCia AND
        B-RutaC.CodDiv = s-CodDiv AND
        B-RutaC.CodDoc = pCodOri AND
        B-RutaC.NroDoc = pNroOri
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE B-RutaC THEN RETURN 'OK'.
    IF LOOKUP(B-RutaC.FlgEst, 'PX,PK') = 0 THEN RETURN 'OK'.
    
    /* Verificamos si se marcar para fedatear una PHR */
    DEF VAR x-Ok AS LOG NO-UNDO.
    DEF VAR x-CuentaFallas AS INT NO-UNDO.

    x-Ok = NO.
    x-CuentaFallas = 0.
    FOR EACH VtaCDocu NO-LOCK WHERE VtaCDocu.CodCia = s-CodCia AND
        VtaCDocu.CodDiv = s-CodDiv AND
        VtaCDocu.CodPed = "HPK" AND      /* HPK */
        VtaCDocu.CodOri = pCodOri AND      /* PHR */
        VtaCDocu.NroOri = pNroOri:
        IF VtaCDocu.FlgSit <> "C" THEN x-CuentaFallas = x-CuentaFallas + 1.
    END.
    IF x-CuentaFallas = 0 THEN x-Ok = YES.
    IF x-Ok = YES THEN DO:
        {lib/lock-genericov3.i ~
            &Tabla="B-RutaC" ~
            &Alcance="FIRST" ~
            &Condicion="B-RutaC.CodCia = s-CodCia and ~
            B-RutaC.CodDiv = s-CodDiv and ~
            B-RutaC.CodDoc = pCodOri and ~
            B-RutaC.NroDoc = pNroOri" ~
            &Bloqueo="EXCLUSIVE-LOCK NO-ERROR NO-WAIT" ~
            &Accion="RETRY" ~
            &Mensaje="NO" ~
            &txtMensaje="pMensaje" ~
            &TipoError="UNDO, RETURN 'ADM-ERROR'"}
        ASSIGN
            B-RutaC.FlgEst = "PF".     /* TODO en Distribución */
        RELEASE B-RutaC.
    END.
    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

