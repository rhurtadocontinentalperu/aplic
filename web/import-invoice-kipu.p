&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER bCcbCDocu FOR CcbCDocu.
DEFINE BUFFER bCcbDDocu FOR CcbDDocu.
DEFINE BUFFER bFacDPedi FOR FacDPedi.
DEFINE TEMP-TABLE COMPROBANTES NO-UNDO LIKE CcbCDocu.
DEFINE TEMP-TABLE PEDI2 NO-UNDO LIKE FacDPedi.



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
DISABLE TRIGGERS FOR LOAD OF Almmmate.
DISABLE TRIGGERS FOR LOAD OF Almmmatg.

DEF NEW SHARED VAR s-codcia AS INTE INIT 001.
DEF NEW SHARED VAR cl-codcia AS INTE INIT 000.
DEF NEW SHARED VAR s-user-id AS CHAR INIT 'SYSTEM'.
DEF NEW SHARED VAR s-coddiv AS CHAR.
DEF NEW SHARED VAR s-coddoc AS CHAR INIT 'P/M'.
DEF NEW SHARED VAR s-codcli AS CHAR.
DEF NEW SHARED VAR s-tpoped AS CHAR.
DEF NEW SHARED VAR s-codter AS CHAR.

DEF VAR s-NroSer AS INTE NO-UNDO.
DEF VAR s-CodAlm AS CHAR NO-UNDO.
DEF VAR s-NroDec AS INTE INIT 4 NO-UNDO.
s-NroDec = 4.
DEF VAR s-CodMov LIKE FacDocum.CodMov NO-UNDO.
DEF VAR s-Tipo AS CHAR INIT 'MOSTRADOR' NO-UNDO.
DEF VAR s-PorIgv AS DECI NO-UNDO.
DEF VAR s-TpoCmb AS DECI NO-UNDO.

DEFINE VAR s-CodCja AS CHAR INIT 'I/C' NO-UNDO.
DEFINE VAR s-sercja AS INT NO-UNDO.

DEFINE VAR x-Articulo-ICBPer AS CHAR INIT '099268'.

DEF VAR hProcSunat AS HANDLE NO-UNDO.
RUN sunat/sunat-calculo-importes PERSISTENT SET hProcSunat NO-ERROR.
IF ERROR-STATUS:ERROR THEN DO:
    PUT UNFORMATTED "ERROR: No se pudo ejecutar el programa sunat-calculo-importes" SKIP "Proceso abortado" SKIP.
    RETURN.
END.

FIND FIRST FacCfgGn WHERE FacCfgGn.codcia = s-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCfgGn THEN DO:
    PUT UNFORMATTED TRIM(ERROR-STATUS:GET-MESSAGE(1)) SKIP "Proceso abortado" SKIP.
    RETURN.
END.

DEFINE VAR x-ClientesVarios AS CHAR.
x-ClientesVarios = FacCfgGn.CliVar.     /* 11 digitos */

DEFINE VAR x-precio-ICBPER AS DECI.
DEFINE VAR x-TotalImpuestoBolsaPlastica AS DECI.

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
      TABLE: bCcbCDocu B "?" ? INTEGRAL CcbCDocu
      TABLE: bCcbDDocu B "?" ? INTEGRAL CcbDDocu
      TABLE: bFacDPedi B "?" ? INTEGRAL FacDPedi
      TABLE: COMPROBANTES T "?" NO-UNDO INTEGRAL CcbCDocu
      TABLE: PEDI2 T "?" NO-UNDO INTEGRAL FacDPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 12.35
         WIDTH              = 60.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF VAR pMensaje AS CHAR NO-UNDO.
DEF VAR pRowidP_M AS ROWID NO-UNDO.
DEF VAR pRowidFAC AS ROWID NO-UNDO.

DEF VAR iItems AS INTE NO-UNDO.

PUT UNFORMATTED "INICIO: " NOW SKIP.
FOR EACH FacCVtaOnLine EXCLUSIVE-LOCK WHERE FacCVtaOnLine.codcia = s-codcia
        AND FacCVtaOnLine.CodOrigen = "KIPU"
        AND FacCVtaOnLine.CodDoc = "PPM"
        AND FacCVtaOnLine.FlgEst = "P":

    /* FILTRO INICIAL POR # DE ITEMS */
    iItems = 0.
    FOR EACH FacDVtaOnLine NO-LOCK WHERE  FacDVtaOnLine.CodCia = FacCVtaOnLine.codcia
        AND FacDVtaOnLine.CodDoc = FacCVtaOnLine.CodDoc
        AND FacDVtaOnLine.NroPed = FacCVtaOnLine.NroPed:
        iItems = iItems + 1.
    END.
    IF iItems <> FacCVtaOnLine.Items THEN DO:
        PUT UNFORMATTED
            FacCVtaOnLine.CodDoc + " " + FacCVtaOnLine.NroPed SKIP
            'ERROR: Items incompletos'
            SKIP.
        UNDO, NEXT.
    END.

    s-CodDiv = FacCVtaOnLine.CodDiv.
    s-CodCli = FacCVtaOnLine.CodCli.
    s-CodAlm = FacCVtaOnLine.CodAlm.
    s-PorIgv = FacCVtaOnLine.PorIgv.
    s-TpoCmb = FacCVtaOnLine.TpoCmb.

    IF s-TpoCmb = 0 OR s-TpoCmb = 1 THEN DO:
        s-TpoCmb = FacCfgGn.TpoCmb[1] .
        /* RHC 11.08.2014 TC Caja Compra */
        FIND LAST gn-tccja WHERE gn-tccja.fecha <= TODAY AND gn-tccja.fecha <> ? NO-LOCK NO-ERROR.
        IF AVAILABLE gn-tccja THEN s-TpoCmb = Gn-TCCja.Compra.
    END.
    IF s-PorIgv = 0 THEN s-PorIgv = FacCfgGn.PorIgv.

    /* ****************************************************************************************** */
    /* Control de Caja Kipu */
    /* ****************************************************************************************** */
    s-CodTer = "KIPU".      /* OJO: Valor fijo */
    /* Control del documento Ingreso Caja por terminal */
    FIND FIRST ccbdterm WHERE CcbDTerm.CodCia = s-codcia AND
        CcbDTerm.CodDiv = s-coddiv AND      /* 00043 */
        CcbDTerm.CodDoc = s-codcja AND      /* I/C */
        CcbDTerm.CodTer = s-codter          /* KIPU */
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ccbdterm THEN DO:
        PUT UNFORMATTED
            "ERROR: No está configurado el terminal " + s-codter + " en la división " + s-coddiv
            SKIP.
        UNDO, NEXT.
    END.
    s-sercja = ccbdterm.nroser.

    /* ****************************************************************************************** */
    /* Generamos el P/M */
    /* ****************************************************************************************** */
    FIND FIRST FacCorre WHERE FacCorre.CodCia = s-CodCia AND
        FacCorre.CodDoc = s-CodDoc AND      /* P/M */
        FacCorre.CodDiv = s-CodDiv AND
        FacCorre.FlgEst = YES NO-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        PUT UNFORMATTED
            "NO está configurado el correlativo para el documento " + s-CodDoc + " división " + s-coddiv
            SKIP.
        UNDO, NEXT.
    END.
    s-NroSer = FacCorre.NroSer.

    /* El movimiento de almacén corresponde al comprobante a emitir (FAC/BOL). */
    FIND FacDocum WHERE FacDocum.CodCia = s-CodCia
        AND FacDocum.CodDoc = FacCVtaOnLine.Cmpbnte
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE FacDocum THEN DO:
        PUT UNFORMATTED
            'NO está configurado el documento ' + FacCVtaOnLine.Cmpbnte + " división " + s-coddiv
            SKIP.
        UNDO, NEXT.
    END.
    s-CodMov = FacDocum.CodMov.
    IF s-CodMov = ? OR s-CodMov = 0 THEN DO:
        PUT UNFORMATTED
            'NO está configurado el código de movimiento para el documento ' + FacCVtaOnLine.Cmpbnte + " división " + s-coddiv
            SKIP.
        UNDO, NEXT.
    END.

    /* Cargamos detalle del PPM */
    RUN Import_Detail.

    /* Grabamos el PPM */
    RUN Save_Pedido (OUTPUT pRowidP_M, OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' OR pRowidP_M = ? THEN DO:
        IF pMensaje = "" THEN pMensaje = "No se pudo generar el pedido P/M".
        PUT UNFORMATTED FacCVtaOnLine.CodDoc + " " + FacCVtaOnLine.NroPed SKIP
            "ERROR: " + TRIM(pMensaje) SKIP.
        UNDO, NEXT.
    END.

    FIND Faccpedi WHERE ROWID(Faccpedi) = pRowidP_M NO-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR = YES OR NOT AVAILABLE Faccpedi THEN DO:
        pMensaje = TRIM(ERROR-STATUS:GET-MESSAGE(1)).
        IF pMensaje = "" THEN pMensaje = "No se encontró el pedido P/M generado".
        PUT UNFORMATTED FacCVtaOnLine.CodDoc + " " + FacCVtaOnLine.NroPed SKIP
            "ERROR: " + pMensaje SKIP.
        UNDO, NEXT.
    END.

    /* ****************************************************************************************** */
    /* Grabamos Comprobante */
    /* ****************************************************************************************** */
    RUN Save_Invoice (BUFFER FacCPedi, OUTPUT pRowidFAC, OUTPUT pMensaje).
    IF pMensaje > '' OR pRowidFAC = ? THEN DO:
        IF pMensaje = "" THEN pMensaje = "No se pudo generar el comprobante".
        PUT UNFORMATTED FacCVtaOnLine.CodDoc + " " + FacCVtaOnLine.NroPed SKIP
            "ERROR: " + TRIM(pMensaje) SKIP.
        UNDO, NEXT.
    END.

    FIND Ccbcdocu WHERE ROWID(Ccbcdocu) = pRowidFAC NO-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR = YES OR NOT AVAILABLE Ccbcdocu THEN DO:
        pMensaje = TRIM(ERROR-STATUS:GET-MESSAGE(1)).
        IF pMensaje = "" THEN pMensaje = "No se encontró el comprobante generado".
        PUT UNFORMATTED "Documento " + FacCVtaOnLine.CodDoc + " " + FacCVtaOnLine.NroPed SKIP
            "ERROR: " + pMensaje SKIP.
        UNDO, NEXT.
    END.
    /* ****************************************************************************************** */

    /* ****************************************************************************************** */
    /* Grabamos Cancelación */
    /* ****************************************************************************************** */
    FIND Faccpedi WHERE ROWID(Faccpedi) = pRowidP_M NO-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR OR NOT AVAILABLE Faccpedi THEN DO:
        pMensaje = TRIM(ERROR-STATUS:GET-MESSAGE(1)).
        IF pMensaje = "" THEN pMensaje = "No se encontró el pedido P/M para cancelar".
        PUT UNFORMATTED FacCVtaOnLine.CodDoc + " " + FacCVtaOnLine.NroPed SKIP
            "ERROR: " + pMensaje SKIP.
        UNDO, NEXT.
    END.

    FIND Ccbcdocu WHERE ROWID(Ccbcdocu) = pRowidFAC NO-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR OR NOT AVAILABLE Ccbcdocu THEN DO:
        pMensaje = TRIM(ERROR-STATUS:GET-MESSAGE(1)).
        IF pMensaje = "" THEN pMensaje = "No se encontró el comprobante para cancelar".
        PUT UNFORMATTED FacCVtaOnLine.CodDoc + " " + FacCVtaOnLine.NroPed SKIP
            "ERROR: " + pMensaje SKIP.
        UNDO, NEXT.
    END.

    RUN Save_Cash_Deposit (BUFFER FacCPedi, BUFFER Ccbcdocu, OUTPUT pMensaje).
    IF pMensaje > '' THEN DO:
        PUT UNFORMATTED FacCVtaOnLine.CodDoc + " " + FacCVtaOnLine.NroPed SKIP "ERROR: " + TRIM(pMensaje) SKIP.
        UNDO, NEXT.
    END.
    /* ****************************************************************************************** */

    /* ****************************************************************************************** */
    /* Marcamos como procesado */
    /* ****************************************************************************************** */
    ASSIGN
        FacCVtaOnLine.FlgEst = "C"
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = TRIM(ERROR-STATUS:GET-MESSAGE(1)).
        IF pMensaje = "" THEN pMensaje = "No se pudo marcar la venta como procesada".
        PUT UNFORMATTED FacCVtaOnLine.CodDoc + " " + FacCVtaOnLine.NroPed SKIP
            "ERROR: " + pMensaje SKIP.
        UNDO, NEXT.
    END.
END.
PUT UNFORMATTED "FIN: " NOW SKIP.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Create_Customer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Create_Customer Procedure 
PROCEDURE Create_Customer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pcError AS CHAR NO-UNDO.

pcError = "".

DEF VAR x-Cuenta AS INT NO-UNDO.

DEFINE VAR cTabla AS CHAR.
DEFINE VAR cLlave_c1 AS CHAR.
DEFINE VAR cLlave_c2 AS CHAR.
DEFINE VAR cLlave_c3 AS CHAR.
DEFINE VAR cValueGiro AS CHAR.
DEFINE VAR cValueGrupoCliente AS CHAR.
DEFINE VAR cValueSectorEconomico AS CHAR.
DEFINE VAR pAddress AS CHAR NO-UNDO.

IF FacCPedi.CodCli = x-ClientesVarios THEN RETURN.

DEFINE VAR cDirFiscal AS CHAR.
DEFINE VAR cDirEntrega AS CHAR.

cTabla = "CONFIG-DEFAULTS".
cLlave_c1 = "B2C".
cLlave_c2 = "CLIENTE-NATURAL".
cLlave_c3 = "".

cDirFiscal = CAPS(TRIM(FacCPedi.DirCli)).
cDirEntrega = CAPS(trim(FacCPedi.LugEnt)).

FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = FacCPedi.CodCli NO-LOCK NO-ERROR.
IF AVAILABLE Gn-Clie THEN RETURN.

/* Nuevo Cliente */
/* Genera automáticamente un registro Sede = "@@@" */
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    CREATE gn-clie NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pcError = TRIM(ERROR-STATUS:GET-MESSAGE(1)).
        IF pcError = "" THEN pcError = "No se pudo crear el cliente " + FacCPedi.CodCli.
        UNDO, LEAVE.
    END.
    ASSIGN
        gn-clie.CodCia      = cl-codcia
        gn-clie.CodCli      = FacCPedi.CodCli
        gn-clie.Libre_C01   = "N"
        gn-clie.NomCli      = CAPS(FacCPedi.NomCli)
        gn-clie.DirCli      = CAPS(FacCPedi.DirCli)   
        gn-clie.Ruc         = ""
        gn-clie.DNI         = FacCPedi.DNICli
        gn-clie.clfCli      = "C" 
        gn-clie.clfCli2     = "C" 
        gn-clie.cm_clfCli_p = "C" 
        gn-clie.cm_clfCli_t = "C" 
        gn-clie.CodPais     = "01" 
        gn-clie.CodVen      = FacCPedi.CodVen
        gn-clie.CndVta      = FacCPedi.FmaPgo
        gn-clie.Fching      = Faccpedi.FchPed 
        gn-clie.usuario     = S-USER-ID 
        gn-clie.TpoCli      = "1"
        gn-clie.CodDiv      = FacCPedi.CodDiv
        gn-clie.Rucold      = "NO"
        gn-clie.Libre_L01   = NO
        gn-clie.FlgSit      = 'A'    /* Activo */
        gn-clie.FlagAut     = 'A'   /* Autorizado */
        gn-clie.CodDept     = FacCPedi.CodDept 
        gn-clie.CodProv     = FacCPedi.CodProv 
        gn-clie.CodDist     = FacCPedi.CodDist
        gn-clie.E-Mail      = FacCPedi.E-Mail       /* eMail contacto */
        gn-clie.Transporte[4]  = FacCPedi.E-Mail       /* eMail facturacion electronica */
        gn-clie.Telfnos[1]  = FacCPedi.TelephoneContactReceptor
        gn-clie.SwCargaSunat = "N" 
        NO-ERROR .
    IF ERROR-STATUS:ERROR THEN UNDO, LEAVE.
    /* ****************************************************************************** */
    /* Datos Adicionales */
    /* ****************************************************************************** */
    CASE TRUE:
        WHEN gn-clie.codcli BEGINS '20' THEN DO:
            ASSIGN 
                gn-clie.Ruc       = FacCPedi.RucCli
                gn-clie.Libre_C01 = "J".
            cLlave_c2 = "CLIENTE-JURIDICO".
        END.            
        WHEN gn-clie.codcli BEGINS '10' THEN DO:
            ASSIGN 
                gn-clie.Ruc      = FacCPedi.RucCli
                gn-clie.Libre_C01 = "N".
        END.            
        WHEN gn-clie.codcli BEGINS '15' THEN DO:
            ASSIGN 
                gn-clie.Ruc       = FacCPedi.RucCli
                gn-clie.Libre_C01 = "N".
        END.           
        WHEN gn-clie.codcli BEGINS '17' THEN DO:  
            ASSIGN 
                gn-clie.Ruc         = FacCPedi.RucCli
                gn-clie.Libre_C01   = "E".
        END.
        /* 03/11/2023: Actualmente el carnet de extranjeria tiene 9 dígitos Giuliana Chirinos S.Leon */
        WHEN LENGTH(gn-clie.DNI) <> 8 THEN DO:
            ASSIGN 
                gn-clie.Ruc       = ""
                gn-clie.Libre_C01 = "E".
        END.
    END CASE.
    /* Datos adicionales */
    cLlave_c3 = "GIRO".
    FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia
        AND vtatabla.tabla = cTabla
        AND vtatabla.llave_C1 = cLlave_c1 
        AND vtatabla.llave_c2 = cLlave_c2 
        AND vtatabla.llave_c3 = cLlave_c3 NO-LOCK NO-ERROR.
    IF AVAILABLE vtatabla THEN cValueGiro = TRIM(vtatabla.llave_c4).
    cLlave_c3 = "GRUPOCLIENTE".
    FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia
        AND vtatabla.tabla = cTabla
        AND vtatabla.llave_C1 = cLlave_c1 
        AND vtatabla.llave_c2 = cLlave_c2 
        AND vtatabla.llave_c3 = cLlave_c3 NO-LOCK NO-ERROR.
    IF AVAILABLE vtatabla THEN cValueGrupoCliente = TRIM(vtatabla.llave_c4).
    cLlave_c3 = "SECTORECONOMICO".
    FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia
        AND vtatabla.tabla = cTabla
        AND vtatabla.llave_C1 = cLlave_c1 
        AND vtatabla.llave_c2 = cLlave_c2 
        AND vtatabla.llave_c3 = cLlave_c3 NO-LOCK NO-ERROR.
    IF AVAILABLE vtatabla THEN cValueSectorEconomico = TRIM(vtatabla.llave_c4).
    ASSIGN 
        gn-clie.canal = cValueGrupoCliente
        gn-clie.gircli = cValueGiro
        gn-clie.clfcom = cValueSectorEconomico.
    /* ****************************************************************************** */
    /* RHC 24/06/2020 Agregar información a la dirección */
    /* ****************************************************************************** */
    /* Armado de la dirección */
    pAddress = CAPS(FacCPedi.DirCli).
    FIND TabDepto WHERE TabDepto.CodDepto = FacCPedi.CodDept NO-LOCK NO-ERROR.
    FIND TabProvi WHERE TabProvi.CodDepto = FacCPedi.CodDept AND
        TabProvi.CodProvi = FacCPedi.CodProv NO-LOCK NO-ERROR.
    FIND TabDistr WHERE TabDistr.CodDepto = FacCPedi.CodDept AND
        TabDistr.CodProvi = FacCPedi.CodProv AND
        TabDistr.CodDistr = FacCPedi.CodDist NO-LOCK NO-ERROR.
    IF AVAILABLE TabDepto AND AVAILABLE TabProvi AND AVAILABLE TabDistr THEN DO:
        pAddress = TRIM(pAddress) + ' ' + 
                    CAPS(TRIM(TabDepto.NomDepto)) + ' - ' +
                    CAPS(TRIM(TabProvi.NomProvi)) + ' - ' +
                    CAPS(TabDistr.NomDistr).
    END.
    ASSIGN
        Gn-Clie.DirCli = pAddress.
END.
IF ERROR-STATUS:ERROR THEN pcError = TRIM(ERROR-STATUS:GET-MESSAGE(1)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Import_Detail) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Import_Detail Procedure 
PROCEDURE Import_Detail :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR I-NITEM AS INTE NO-UNDO.
DEF VAR pSugerido AS DEC NO-UNDO.
DEF VAR pEmpaque AS DEC NO-UNDO.

EMPTY TEMP-TABLE PEDI2.

DETALLES:
FOR EACH FacDVtaOnLine NO-LOCK WHERE FacDVtaOnLine.CodCia = FacCVtaOnLine.CodCia AND
        FacDVtaOnLine.CodDiv = FacCVtaOnLine.CodDiv AND
        FacDVtaOnLine.CodDoc = FacCVtaOnLine.CodDoc AND
        FacDVtaOnLine.NroPed = FacCVtaOnLine.NroPed,
    FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = FacDVtaOnLine.CodCia AND
        Almmmatg.codmat = FacDVtaOnLine.CodMat
    BY FacDVtaOnLine.CodMat:
    /* Se acumulan por cada SKU y en unidades de stock. */
    FIND FIRST PEDI2 WHERE PEDI2.codmat = FacDVtaOnLine.CodMat EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE PEDI2 THEN DO:
        I-NITEM = I-NITEM + 1.
        CREATE PEDI2.
        BUFFER-COPY FacDVtaOnLine 
            EXCEPT FacDVtaOnLine.Libre_d05
            TO PEDI2
            ASSIGN 
            PEDI2.CodCia = s-codcia
            PEDI2.CodDiv = s-CodDiv
            PEDI2.CodDoc = s-CodDoc      /* Normalmente PPM */
            PEDI2.NroPed = ''
            PEDI2.NroItm = I-NITEM
            PEDI2.CanAte = 0.
    END.
    ELSE
        PEDI2.CanPed = PEDI2.CanPed + FacDVtaOnLine.CanPed.

    PEDI2.Libre_d01 = PEDI2.CanPed.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-impuesto-bolsa-plastica) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE impuesto-bolsa-plastica Procedure 
PROCEDURE impuesto-bolsa-plastica PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCantidad AS DEC.

DEFINE VAR x-implin AS DEC.

x-precio-ICBPER = 0.0.   

DEFINE VAR pFecha AS DATE.
DEFINE VAR pPrecioImpsto AS DEC.

DEFINE VAR x-tabla AS CHAR INIT "IMPSTO_BOL_PLASTICA".
DEFINE VAR x-fecha AS DATE.

x-fecha = TODAY.

/* Indica que la configuracion para el precio del impsto a la bolsa NO esta configurado*/
pPrecioImpsto = -9.99.

FIND FIRST factabla WHERE factabla.codcia = s-codcia AND
    factabla.tabla = x-tabla AND
    (x-fecha >= factabla.campo-d[1] AND x-fecha <= factabla.campo-d[2])
    NO-LOCK NO-ERROR.
IF AVAILABLE factabla THEN DO:
    pPrecioImpsto = factabla.valor[1].
END.

x-precio-ICBPER = pPrecioImpsto.
x-implin = pCantidad * x-precio-ICBPER.
x-TotalImpuestoBolsaPlastica = x-TotalImpuestoBolsaPlastica + x-ImpLin.

ASSIGN 
    Ccbddocu.impuestoBolsaPlastico = x-precio-ICBPER   /*x-implin*/
    Ccbddocu.montoTributoBolsaPlastico = x-implin
    Ccbddocu.cantidadBolsaPlastico = pCantidad
    Ccbddocu.montoUnitarioBolsaPlastico = x-precio-ICBPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-proc_Genera-Deposito) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_Genera-Deposito Procedure 
PROCEDURE proc_Genera-Deposito PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* OJO: Ya va con los valores del depósito */
DEF VAR F-Banco AS CHAR INIT 'CO'       NO-UNDO.
DEF VAR F-Cta   AS CHAR INIT '10413100' NO-UNDO.
DEF VAR FILL-IN-NroOpe AS CHAR          NO-UNDO.
DEF VAR F-Fecha AS DATE                 NO-UNDO.

ASSIGN F-Fecha = TODAY.

/* RHC 13/10/2018 RHC: a pedido de Susana Leon */
ASSIGN 
    F-Banco = 'IB' 
    F-Cta = '10416100'.

{ccb/i-pendep-02-v2.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Save_Cash_Deposit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Save_Cash_Deposit Procedure 
PROCEDURE Save_Cash_Deposit :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF PARAMETER BUFFER bFaccpedi FOR Faccpedi.
DEF PARAMETER BUFFER bCcbcdocu FOR Ccbcdocu.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR FILL-IN_Voucher4 AS CHAR NO-UNDO.
DEF VAR FILL-IN_CodBco4 AS CHAR NO-UNDO.
DEF VAR COMBO_TarjCred AS CHAR NO-UNDO.

DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    /* Bloqueamos el comprobante */
    FIND CURRENT bCcbcdocu EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = ERROR-STATUS:GET-MESSAGE(1).
        UNDO, LEAVE.
    END.

    /* Buscamos el registro de cancelación */
    FIND CjaCVtaOnLine WHERE CjaCVtaOnLine.CodCia = s-codcia
        AND CjaCVtaOnLine.CodDiv = FacCVtaOnLine.CodDiv
        AND CjaCVtaOnLine.CodDoc = FacCVtaOnLine.CodDoc
        AND CjaCVtaOnLine.NroDoc = FacCVtaOnLine.NroPed
        AND CjaCVtaOnLine.CodRef = FacCVtaOnLIne.Cmpbnte
        AND CjaCVtaOnLine.NroRef = FacCVtaOnLIne.NCmpbnte
        EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF NOT AVAILABLE CjaCVtaOnLine THEN DO:
        pMensaje = TRIM(ERROR-STATUS:GET-MESSAGE(1)).
        IF pMensaje = "" THEN
            pMensaje = "No se encontró la cancelación de caja para el comprobante " +
                       bCcbcdocu.CodDoc + " " + bCcbcdocu.NroDoc.
        UNDO, LEAVE.
    END.

    /* Tipo de Cambio Caja */
    FIND LAST Gn-tccja WHERE Gn-tccja.Fecha <= bFaccpedi.FchPed NO-LOCK NO-ERROR.
    IF AVAILABLE Gn-TcCja THEN s-TpoCmb = Gn-Tccja.Compra.

    /* Ingreso a Caja */
    {lib\lock-genericov3.i &Tabla="FacCorre" ~
        &Alcance="FIRST"
        &Condicion="FacCorre.CodCia = s-codcia ~
        AND FacCorre.CodDiv = s-coddiv ~
        AND FacCorre.CodDoc = s-codcja ~
        AND FacCorre.NroSer = s-sercja" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, LEAVE" }

    /* Crea Cabecera de Caja */
    CREATE CcbCCaja.
    ASSIGN
        CcbCCaja.CodCia     = s-CodCia
        CcbCCaja.CodDiv     = s-CodDiv 
        CcbCCaja.CodDoc     = s-CodCja
        CcbCCaja.NroDoc     = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
        CcbCCaja.CodCaja    = CjaCVtaOnLine.CodCaja     /*s-CodTer*/
        CcbCCaja.usuario    = s-user-id
        CcbCCaja.CodCli     = bFaccpedi.codcli
        CcbCCaja.NomCli     = bFaccpedi.NomCli
        CcbCCaja.CodMon     = bFaccpedi.CodMon
        CcbCCaja.TpoCmb     = s-TpoCmb
        CcbCCaja.FchDoc     = bFaccpedi.FchPed
        CcbCCaja.Tipo       = s-Tipo
        CcbCCaja.FLGEST     = "C"
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = TRIM(ERROR-STATUS:GET-MESSAGE(1)).
        UNDO, LEAVE.
    END.
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    RELEASE FacCorre.
    /* Datos de cancelación */
    ASSIGN
        CcbCCaja.ImpNac[1] = CjaCVtaOnLine.EfeNac 
        CcbCCaja.ImpUsa[1] = CjaCVtaOnLine.EfeExt 
        CcbCCaja.ImpNac[4] = CjaCVtaOnLine.TarNac
        CcbCCaja.ImpUsa[4] = CjaCVtaOnLine.TarExt
        .

    /* **************************************************************************** */
    /* DATOS DE LA TARJETA DE PAGO */
    /* **************************************************************************** */
    IF CcbCCaja.ImpNac[4] + CcbCCaja.ImpUsa[4] > 0 THEN DO:
        IF CjaCVtaOnLine.Voucher > '' THEN DO:
            /* Armamos # de tarjeta */
            FILL-IN_Voucher4 = FILL("*",12) + TRIM(CjaCVtaOnLine.Voucher).
            FILL-IN_Voucher4 = SUBSTRING(FILL-IN_Voucher4, LENGTH(FILL-IN_Voucher4) - 12 + 1).
            ASSIGN
                CcbCCaja.Voucher[4]= FILL-IN_Voucher4
                .
            /* Armamos Banco */
            IF NUM-ENTRIES(CjaCVtaOnLine.Tarjeta_Banco,"-") >= 2 
                THEN FILL-IN_CodBco4 = TRIM(ENTRY(2,CjaCVtaOnLine.Tarjeta_Banco,"-")).
            FIND cb-tabl WHERE cb-tabl.tabla = "04" AND cb-tabl.codigo = FILL-IN_CodBco4 NO-LOCK NO-ERROR.
            IF NOT AVAILABLE cb-tabl THEN DO:
                FIND FIRST cb-tabl WHERE cb-tabl.tabla = "04" 
                    AND INDEX(cb-tabl.nombre, FILL-IN_CodBco4) > 0
                    NO-LOCK NO-ERROR.
                IF AVAILABLE cb-tabl THEN FILL-IN_CodBco4 = cb-tabl.codigo.
            END.
            ASSIGN 
                CcbCCaja.CodBco[4] = FILL-IN_CodBco4.
            /* Armamos Tipo de Tarjeta */
            COMBO_TarjCred = CjaCVtaOnLine.Tipo_Tarjeta.
            FIND FacTabla WHERE FacTabla.codcia = s-codcia 
                AND FacTabla.Tabla = "TC"
                AND FacTabla.Nombre = COMBO_TarjCred
                NO-LOCK NO-ERROR.
            IF AVAILABLE FacTabla THEN COMBO_TarjCred = TRIM(FacTabla.Codigo) + " " + TRIM(FacTabla.Nombre).
            ASSIGN 
                CcbCCaja.Voucher[9] = COMBO_TarjCred.
            /* Pendientes por Depositar (TCR) */
            CREATE CcbPenDep.
            ASSIGN
                CcbPenDep.CodCia = CcbCCaja.CodCia
                CcbPenDep.CodDoc = "TCR"
                CcbPenDep.CodDiv = CcbCCaja.CodDiv
                CcbPenDep.CodRef = CcbCCaja.CodDoc
                CcbPenDep.NroRef = CcbCCaja.NroDoc
                CcbPenDep.FchCie = CcbCCaja.FchCie
                CcbPenDep.NroDoc = CcbCCaja.Voucher[9] + "|" + CcbCCaja.Voucher[4]
                CcbPenDep.FlgEst = "P"
                CcbPenDep.HorCie = bFacCPedi.Hora
                CcbPenDep.usuario = s-user-id.
            ASSIGN
                CcbPenDep.ImpNac = CcbCCaja.ImpNac[4]
                CcbPenDep.SdoNac = CcbCCaja.ImpNac[4]
                CcbPenDep.ImpUsa = CcbCCaja.ImpUsa[4]
                CcbPenDep.SdoUsa = CcbCCaja.ImpUsa[4].
            /* RHC 12/01/2015 Solicitado por Susana Leon */
            RUN proc_Genera-Deposito.
            /* ***************************************** */
        END.
    END.
    /* **************************************************************************** */

    /* Cancelamos el comprobante */
    CREATE CcbDCaja.
    ASSIGN
        CcbDCaja.CodCia = CcbCCaja.CodCia
        CcbdCaja.CodDiv = CcbCCaja.CodDiv
        CcbDCaja.CodDoc = CcbCCaja.CodDoc
        CcbDCaja.NroDoc = CcbCCaja.NroDoc
        CcbDCaja.CodRef = bCcbcdocu.CodDoc
        CcbDCaja.NroRef = bCcbcdocu.NroDoc
        CcbDCaja.CodCli = bCcbcdocu.CodCli
        CcbDCaja.CodMon = bCcbcdocu.CodMon
        CcbDCaja.FchDoc = CcbCCaja.FchDoc
        CcbDCaja.ImpTot = Ccbcdocu.ImpTot
        CcbDCaja.TpoCmb = CcbCCaja.TpoCmb.
    ASSIGN
        bCcbcdocu.FlgEst = "C"
        bCcbcdocu.FchCan = bFaccpedi.FchPed
        bCcbcdocu.SdoAct = 0
        .

    /* Cerramos I/C */
    ASSIGN
        CcbCCaja.FlgCie = "C"
        CcbCCaja.FchCie = CcbCCaja.FchDoc
        CcbCCaja.HorCie = bFacCPedi.Hora
        .

    /* Cerramos */
    ASSIGN
        CjaCVtaOnLine.FlgEst = "C"
        CjaCVtaOnLine.MigEstado = "E"
        CjaCVtaOnLine.MigFechaCarga = TODAY
        CjaCVtaOnLine.MigHoraCarga = STRING(TIME,'HH:MM:SS')
        .


    IF AVAILABLE(bCcbcdocu) THEN RELEASE bCcbcdocu NO-ERROR.
    IF AVAILABLE(CcbCCaja) THEN RELEASE CcbCCaja NO-ERROR.
    IF AVAILABLE(CcbDCaja) THEN RELEASE CcbDCaja NO-ERROR.
END.
IF ERROR-STATUS:ERROR AND pMensaje = "" THEN pMensaje = TRIM(ERROR-STATUS:GET-MESSAGE(1)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Save_Detail) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Save_Detail Procedure 
PROCEDURE Save_Detail :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

  DEF VAR I-NITEM AS INTEGER NO-UNDO INIT 0.
  DEF VAR LocalPreUniFin LIKE Facdpedi.PreUni NO-UNDO.
  DEF VAR LocalPreUniTeo LIKE Facdpedi.PreUni NO-UNDO.

  pMensaje = "".
  RLOOP:
  DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
      FOR EACH PEDI2 NO-LOCK BY PEDI2.NroItm ON ERROR UNDO, THROW:
          I-NITEM = I-NITEM + 1.
          CREATE FacDPedi.
          BUFFER-COPY PEDI2 TO FacDPedi
              ASSIGN
                  FacDPedi.CodCia = FacCPedi.CodCia
                  FacDPedi.CodDiv = FacCPedi.CodDiv
                  FacDPedi.CodDoc = FacCPedi.CodDoc
                  FacDPedi.NroPed = FacCPedi.NroPed
                  FacDPedi.FchPed = FacCPedi.FchPed
                  FacDPedi.FlgEst = FacCPedi.FlgEst
                  FacDPedi.CodCli = FacCPedi.CodCli
                  FacDPedi.AlmDes = FacCPedi.CodAlm
                  FacDPedi.NroItm = I-NITEM
              NO-ERROR.
          IF ERROR-STATUS:ERROR = YES THEN DO:
              pMensaje = ERROR-STATUS:GET-MESSAGE(1).
              UNDO RLOOP, LEAVE RLOOP.
          END.
          /* ***************************************************************** */
          /*{vtagn/CalculoDetalleMayorCredito.i &Tabla="FacDPedi" }*/
          ASSIGN
              FacDPedi.ImpLin = FacDPedi.CanPed * FacDPedi.PreUni * 
                ( 1 - FacDPedi.Por_Dsctos[1] / 100 ) *
                ( 1 - FacDPedi.Por_Dsctos[2] / 100 ) *
                ( 1 - FacDPedi.Por_Dsctos[3] / 100 ).
          IF FacDPedi.Por_Dsctos[1] = 0 AND FacDPedi.Por_Dsctos[2] = 0 AND FacDPedi.Por_Dsctos[3] = 0 
            THEN FacDPedi.ImpDto = 0.
            ELSE FacDPedi.ImpDto = FacDPedi.CanPed * FacDPedi.PreUni - FacDPedi.ImpLin.
          /* CON FLETE */
          IF FacDPedi.Libre_d02 > 0 THEN DO:
              /* El flete afecta el monto final */
              IF FacDPedi.ImpDto = 0 THEN DO:       /* NO tiene ningun descuento */
                  ASSIGN
                      FacDPedi.PreUni = ROUND(FacDPedi.PreUni + FacDPedi.Libre_d02, s-NroDec)  /* Incrementamos el PreUni */
                      FacDPedi.ImpLin = FacDPedi.CanPed * FacDPedi.PreUni.
              END.
              ELSE DO:      /* CON descuento promocional o volumen */
                  /* El flete afecta al precio unitario resultante */
                  LocalPreUniFin = FacDPedi.ImpLin / FacDPedi.CanPed.     /* Valor resultante */
                  LocalPreUniFin = LocalPreUniFin + FacDPedi.Libre_d02.    /* Unitario Afectado al Flete */
                  LocalPreUniTeo = LocalPreUniFin / ( ( 1 - FacDPedi.Por_Dsctos[1] / 100 ) * ( 1 - FacDPedi.Por_Dsctos[2] / 100 ) * ( 1 - FacDPedi.Por_Dsctos[3] / 100 ) ). 
                  IF LocalPreUniTeo = ? THEN LocalPreUniTeo = 0.
                  /* Comtemplar 100 dsctos que viene desde el pedido comercial - Susana Leon/Carla Tenazoa*/
                  IF LocalPreUniTeo <= 0 AND (FacDPedi.Por_Dsctos[1] + FacDPedi.Por_Dsctos[2] + FacDPedi.Por_Dsctos[3] ) >= 100 THEN LocalPreUniTeo = FacDPedi.PreUni.
                  ASSIGN
                      FacDPedi.PreUni = ROUND(LocalPreUniTeo, s-NroDec).
              END.
              ASSIGN
                  FacDPedi.ImpLin = ROUND ( FacDPedi.CanPed * FacDPedi.PreUni * 
                                            ( 1 - FacDPedi.Por_Dsctos[1] / 100 ) *
                                            ( 1 - FacDPedi.Por_Dsctos[2] / 100 ) *
                                            ( 1 - FacDPedi.Por_Dsctos[3] / 100 ), 2 ).
              IF FacDPedi.Por_Dsctos[1] = 0 AND FacDPedi.Por_Dsctos[2] = 0 AND FacDPedi.Por_Dsctos[3] = 0 
                  THEN FacDPedi.ImpDto = 0.
              ELSE FacDPedi.ImpDto = (FacDPedi.CanPed * FacDPedi.PreUni) - FacDPedi.ImpLin.
          END.
          /*/* ***************************************************************** */*/
          ASSIGN
              FacDPedi.ImpLin = ROUND(FacDPedi.ImpLin, 2)
              FacDPedi.ImpDto = ROUND(FacDPedi.ImpDto, 2).
          IF FacDPedi.AftIsc 
              THEN FacDPedi.ImpIsc = ROUND(FacDPedi.PreBas * FacDPedi.CanPed * (Almmmatg.PorIsc / 100), s-NroDec).
          IF FacDPedi.AftIgv 
              THEN FacDPedi.ImpIgv =  FacDPedi.ImpLin - ( FacDPedi.ImpLin  / ( 1 + (s-PorIgv / 100)) ).
          /* ***************************************************************** */
          ASSIGN
              FacDPedi.ImpIgv = ROUND(FacDPedi.ImpIgv, s-NroDec).
      END.
  END.
  IF ERROR-STATUS:ERROR THEN pMensaje = ERROR-STATUS:GET-MESSAGE(1).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Save_Detail_Invoice) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Save_Detail_Invoice Procedure 
PROCEDURE Save_Detail_Invoice :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF PARAMETER BUFFER bFaccpedi FOR Faccpedi.     
DEF OUTPUT PARAMETER pcError AS CHAR NO-UNDO.

DEF VAR iCountItem AS INTE INIT 1 NO-UNDO.

RLOOP:
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    FOR EACH bFacdpedi OF bFaccpedi NO-LOCK:
        CREATE bCcbddocu.
        BUFFER-COPY bFacdpedi TO bCcbddocu
            ASSIGN
                bCcbddocu.CodCia = bCcbcdocu.CodCia
                bCcbddocu.Coddoc = bCcbcdocu.Coddoc
                bCcbddocu.NroDoc = bCcbcdocu.NroDoc 
                bCcbddocu.FchDoc = bCcbcdocu.FchDoc
                bCcbddocu.CodDiv = bCcbcdocu.CodDiv
                bCcbddocu.NroItm = iCountItem
                bCcbddocu.CanDes = bFacdpedi.CanPed
                bCcbddocu.Factor = bFacdpedi.Factor
                bCcbddocu.UndVta = bFacdpedi.UndVta
                bCcbddocu.ImpIgv = bFacdpedi.ImpIgv
                bCcbddocu.ImpIsc = bFacdpedi.ImpIsc
                bCcbddocu.ImpDto = bFacdpedi.ImpDto
                bCcbddocu.ImpLin = bFacdpedi.ImpLin
                bCcbddocu.impdcto_adelanto[4] = bFacdpedi.Libre_d02   /* Flete Unitario */
            NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pcError = TRIM(ERROR-STATUS:GET-MESSAGE(1)).
            UNDO RLOOP, LEAVE RLOOP.
        END.
        iCountItem = iCountItem + 1.
    END.
END.
IF AVAILABLE(bCcbddocu) THEN RELEASE bCcbddocu.
IF ERROR-STATUS:ERROR AND pcError = "" THEN pcError = TRIM(ERROR-STATUS:GET-MESSAGE(1)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Save_Invoice) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Save_Invoice Procedure 
PROCEDURE Save_Invoice :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF PARAMETER BUFFER bFaccpedi FOR Faccpedi.
DEF OUTPUT PARAMETER pRowid AS ROWID NO-UNDO.
DEF OUTPUT PARAMETER pcError AS CHAR NO-UNDO.

DEFINE VARIABLE iCountItem AS INTEGER INITIAL 1 NO-UNDO.

pcError = "".
RLOOP:
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    FIND CURRENT bFaccpedi EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR OR NOT AVAILABLE bFaccpedi THEN DO:
        pcError = TRIM(ERROR-STATUS:GET-MESSAGE(1)).
        IF pcError = "" THEN pcError = "No se pudo bloquear el pedido P/M para generar el comprobante".
        UNDO, LEAVE.
    END.

    FIND FIRST bCcbcdocu WHERE bCcbcdocu.codcia = s-codcia 
        AND bCcbcdocu.coddoc = bFacCPedi.Cmpbnte 
        AND bCcbcdocu.nrodoc = bFacCPedi.NCmpbnte
        NO-LOCK NO-ERROR.
    IF AVAILABLE bCcbcdocu THEN DO:
        pcError = "Comprobante " + bFacCPedi.Cmpbnte + " " + bFacCPedi.NCmpbnte + " ya registrado".
        UNDO, RETURN.
    END.

    CREATE bCcbcdocu NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pcError = TRIM(ERROR-STATUS:GET-MESSAGE(1)).
        IF pcError = "" THEN pcError = "No se pudo crear la cabecera del comprobante".
        UNDO, LEAVE.
    END.
    ASSIGN
        bCcbcdocu.CodCia = s-CodCia
        bCcbcdocu.CodDiv = s-CodDiv   

        bCcbcdocu.CodDoc = bFacCPedi.Cmpbnte 
        bCcbcdocu.NroDoc = bFacCPedi.NCmpbnte

        bCcbcdocu.DivOri = bFaccpedi.CodDiv       /* OJO: division de estadisticas */
        bCcbcdocu.CodAlm = bFaccpedi.CodAlm       /* Almacén de descarga */
        bCcbcdocu.FchDoc = bFaccpedi.FchPed
        bCcbcdocu.CodMov = s-CodMov
        bCcbcdocu.CodRef = bFaccpedi.CodDoc           /* CONTROL POR DEFECTO */
        bCcbcdocu.NroRef = bFaccpedi.NroPed
        bCcbcdocu.CodPed = bFaccpedi.CodDoc           /* NUMERO DE PEDIDO */
        bCcbcdocu.NroPed = bFaccpedi.NroPed
        bCcbcdocu.Tipo   = s-Tipo
        bCcbcdocu.CodCaja= s-CodTer
        bCcbcdocu.FchVto = bFaccpedi.FchPed
        bCcbcdocu.CodCli = bFaccpedi.CodCli
        bCcbcdocu.NomCli = bFaccpedi.NomCli
        bCcbcdocu.RucCli = bFaccpedi.RucCli
        bCcbcdocu.CodAnt = bFaccpedi.Atencion     /* DNI */
        bCcbcdocu.DirCli = bFaccpedi.DirCli
        bCcbcdocu.CodVen = bFaccpedi.CodVen
        bCcbcdocu.TipVta = "1"
        bCcbcdocu.TpoFac = "CO"                  /* CONTADO, (OJO Utilex dice solo "C" ) */
        bCcbcdocu.FmaPgo = bFaccpedi.FmaPgo
        bCcbcdocu.CodMon = bFaccpedi.CodMon
        bCcbcdocu.TpoCmb = FacCfgGn.TpoCmb[1]
        bCcbcdocu.PorIgv = bFaccpedi.PorIgv
        bCcbcdocu.NroOrd = bFaccpedi.ordcmp
        bCcbcdocu.FlgEst = "P"                   /* PENDIENTE */
        bCcbcdocu.FlgSit = "P"
        bCcbcdocu.usuario = S-USER-ID
        bCcbcdocu.HorCie = STRING(TIME,'hh:mm')
        /* INFORMACION DEL P/M */
        bCcbcdocu.Glosa     = bFaccpedi.Glosa
        bCcbcdocu.TipBon[1] = bFaccpedi.TipBon[1]
        bCcbcdocu.NroCard   = bFaccpedi.NroCard 
        bCcbcdocu.FlgEnv    = bFaccpedi.FlgEnv /* OJO Control de envio de documento */
        bCcbcdocu.FlgCbd    = bFaccpedi.FlgIgv
        /* RHC 18/01/2016 TCK Factura */
        bCcbcdocu.Libre_c04 = bFaccpedi.Cmpbnte
        /* Información Ventas Utilex */
        bCcbcdocu.ImpDto2    = bFaccpedi.ImpDto2
        /* INFORMACION DEL ENCARTE */
        bCcbcdocu.Libre_c05 = bFaccpedi.FlgSit + '|' + bFaccpedi.Libre_c05
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, LEAVE.

    /* Guarda Centro de Costo */
    FIND gn-ven WHERE gn-ven.codcia = s-codcia AND gn-ven.codven = bCcbcdocu.codven NO-LOCK NO-ERROR.
    IF AVAILABLE gn-ven THEN bCcbcdocu.cco = gn-ven.cco.

    RUN Save_Detail_Invoice (BUFFER bFaccpedi, OUTPUT pcError).
    IF pcError > '' THEN UNDO, LEAVE.

    RUN Save_Total_Invoice ( OUTPUT pcError).
    IF pcError > '' THEN UNDO, LEAVE.

    CREATE COMPROBANTES.
    BUFFER-COPY bCcbcdocu TO COMPROBANTES.

    ASSIGN
        bFaccpedi.FlgEst = "C"      /* OJO: Se cierra el pedido mostrador */
        pRowid = ROWID(bCcbCDocu).

    IF AVAILABLE(bCcbcdocu) THEN RELEASE bCcbcdocu.
    IF AVAILABLE(bFaccpedi) THEN RELEASE bFaccpedi.
END.
IF ERROR-STATUS:ERROR AND pcError = "" THEN DO:
    pcError = TRIM(ERROR-STATUS:GET-MESSAGE(1)).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Save_Pedido) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Save_Pedido Procedure 
PROCEDURE Save_Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pRowid AS ROWID NO-UNDO.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR x-Cuenta AS INTE NO-UNDO.
DEF VAR x-data AS CHAR NO-UNDO.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':    
    {lib/lock-genericov3.i ~
        &Tabla="FacCorre" ~
        &Condicion="FacCorre.CodCia = S-CODCIA ~ 
        AND FacCorre.CodDoc = S-CODDOC ~ 
        AND FacCorre.CodDiv = S-CODDIV ~ 
        AND Faccorre.NroSer = S-NroSer" ~ 
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~ 
        &Accion="RETRY" ~ 
        &Mensaje="NO" ~ 
        &txtMensaje="pMensaje" ~ 
        &TipoError="UNDO, RETURN 'ADM-ERROR'"}

    CREATE FacCPedi.
    BUFFER-COPY FacCVtaOnLine EXCEPT FacCVtaOnLine.Libre_c01 TO FacCPedi 
        ASSIGN 
        FacCPedi.CodCia = S-CODCIA
        FacCPedi.CodDiv = S-CODDIV
        FacCPedi.CodDoc = s-coddoc      /* P/M */
        FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
        FacCPedi.FchPed = FacCVtaOnLine.FchPed 
        FacCPedi.CodAlm = S-CODALM
        FacCPedi.PorIgv = FacCfgGn.PorIgv 
        FacCPedi.Libre_c02 = s-TpoPed
        /*FacCPedi.Libre_c03 = FILL-IN-1:SCREEN-VALUE IN FRAME {&FRAME-NAME}*/
        /*FacCPedi.CodTer = S-CODTER*/
        FacCPedi.Libre_d01 = s-NroDec
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        pMensaje = TRIM(ERROR-STATUS:GET-MESSAGE(1)).
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* Campos Relacionados */
    ASSIGN
        FacCPedi.CodRef = FacCVtaOnLine.CodDoc
        FacCPedi.NroRef = FacCVtaOnLine.NroPed.
    IF TRUE <> (TRIM(Faccpedi.FmaPgo) > '') THEN FacCPedi.FmaPgo = "000".
    /* Campos faltantes */
    IF TRUE <> (FacCPedi.CodDept > '') THEN DO:
        FIND gn-divi WHERE gn-divi.codcia = s-codcia 
            AND gn-divi.coddiv = s-coddiv
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-divi THEN
            ASSIGN
            FacCPedi.CodDept = GN-DIVI.Campo-Char[3] 
            FacCPedi.CodProv = GN-DIVI.Campo-Char[4] 
            FacCPedi.CodDist = GN-DIVI.Campo-Char[5] 
            .
    END.

    /* Correlativo */
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    RELEASE FacCorre.

    /* Cliente */
    /* Verificar la Longitud */
    x-data = TRIM(Faccpedi.CodCli).
    IF LENGTH(x-data) < 11 THEN x-data = FILL("0", 11 - LENGTH(x-data)) + x-data.
    Faccpedi.CodCli = x-data.
    s-CodCli = Faccpedi.CodCli.
    IF TRUE <> (FacCPedi.Sede > '') THEN FacCPedi.Sede = "@@@".

    RUN Create_Customer (OUTPUT pMensaje).
    IF pMensaje > '' THEN UNDO, RETURN 'ADM-ERROR'.

    /* Datos Adicionales */
    FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = FacCPedi.codcli NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie THEN DO:
        IF TRUE <> (FacCPedi.NomCli > '')   THEN FacCPedi.NomCli = gn-clie.NomCli.
        IF TRUE <> (FacCPedi.RucCli > '')   THEN FacCPedi.RucCli = gn-clie.Ruc.
        IF TRUE <> (FacCPedi.DirCli > '')   THEN FacCPedi.DirCli = gn-clie.DirCli.
        IF TRUE <> (FacCPedi.NroCard > '')  THEN FacCPedi.NroCard = gn-clie.NroCard.
        IF TRUE <> (FacCPedi.DniCli > '')   THEN FacCPedi.DniCli  = gn-clie.DNI.
    END.
    FIND gn-clied WHERE gn-clied.codcia = cl-codcia
        AND gn-clied.codcli = FacCPedi.codcli
        AND gn-clied.sede = FacCPedi.sede
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clied THEN DO:
        IF TRUE <> (FacCPedi.CodPos > '') THEN FacCPedi.CodPos = Gn-ClieD.Codpos.
        FacCPedi.Glosa = (IF TRUE <> (FacCPedi.Glosa > '') 
                          THEN Gn-ClieD.DirCli ELSE FacCPedi.Glosa).
        ASSIGN
            FacCPedi.CodDept = Gn-ClieD.CodDept 
            FacCPedi.CodProv = Gn-ClieD.CodProv 
            FacCPedi.CodDist = Gn-ClieD.CodDist
            .
    END.
    ASSIGN 
        FacCPedi.TpoCmb = s-TpoCmb
        FacCPedi.Atencion = FacCPedi.DNICli
        FacCPedi.Hora = STRING(TIME,"HH:MM:SS")
        FacCPedi.Usuario = S-USER-ID
        FacCPedi.Libre_c01 = s-CodDiv
        .
    /* VENDEDOR */
    ASSIGN
        FacCPedi.CodVen = '020'.        /* Valor por defecto */
    IF FacCVtaOnLine.Libre_c01 > '' THEN DO:
        FIND CcbTabla WHERE CcbTabla.CodCia = s-codcia
            AND CcbTabla.Tabla = "KIPU"
            AND CcbTabla.Codigo = "VENDEDOR"
            AND CcbTabla.Libre_c01 = FacCVtaOnLine.Libre_c01    /* Usuario Kipu */
            NO-LOCK NO-ERROR.
        IF AVAILABLE CcbTabla AND CcbTabla.Libre_c02 > '' THEN FacCPedi.CodVen = CcbTabla.Libre_c02.
    END.

    RUN Save_Detail (OUTPUT pMensaje).
    IF pMensaje > "" THEN UNDO, RETURN 'ADM-ERROR'.

    /* ************************************************************************************** */
    {vtagn/totales-cotizacion-sunat.i &Cabecera="FacCPedi" &Detalle="FacDPedi"}
    /* ************************************************************************************** */

    RUN tabla-faccpedi.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = TRIM(ERROR-STATUS:GET-MESSAGE(1)).
        IF pMensaje = "" THEN pMensaje = "Error al calcular los totales del P/M".
        UNDO, RETURN 'ADM-ERROR'.
    END.

    
    /* ****************************************************************************************** */
    /* Importes SUNAT */
    /* NO actualiza campos Progress */
    /* ****************************************************************************************** */
/*     RUN tabla-faccpedi IN hProcSunat (INPUT Faccpedi.CodDiv, */
/*                                       INPUT Faccpedi.CodDoc, */
/*                                       INPUT Faccpedi.NroPed, */
/*                                       OUTPUT pMensaje).      */
/*     IF pMensaje = "OK" THEN pMensaje = "".                   */
/*     IF pMensaje > "" THEN UNDO, RETURN 'ADM-ERROR'.          */

    ASSIGN
        pRowid = ROWID(FacCPedi).

    IF AVAILABLE(FacCPedi) THEN RELEASE FacCPedi.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Save_Total_Invoice) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Save_Total_Invoice Procedure 
PROCEDURE Save_Total_Invoice :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pcError AS CHAR NO-UNDO.

DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    /* Totales por Comprobante */
    ASSIGN
        bCcbcdocu.ImpBrt  = Faccpedi.ImpBrt 
        bCcbcdocu.ImpDto  = Faccpedi.ImpDto 
        bCcbcdocu.ImpDto2 = Faccpedi.ImpDto2
        bCcbcdocu.ImpIgv  = Faccpedi.ImpIgv 
        bCcbcdocu.ImpIsc  = Faccpedi.ImpIsc 
        bCcbcdocu.ImpTot  = Faccpedi.ImpTot 
        bCcbcdocu.ImpExo  = Faccpedi.ImpExo 
        bCcbcdocu.ImpVta  = Faccpedi.ImpVta 
        bCcbcdocu.AcuBon[10] = 0
        .

    RUN tabla-ccbcdocu.
    IF ERROR-STATUS:ERROR THEN DO:
        pcError = TRIM(ERROR-STATUS:GET-MESSAGE(1)).
        IF pcError = "" THEN pcError = "Error al calcular los totales del comprobante".
        UNDO, LEAVE.
    END.

    /* ACTUALIZAMOS ALMACENES */
    RUN vta2/act_almv2 ( INPUT ROWID(bCcbCDocu), OUTPUT pcError ).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pcError > '') THEN pcError = "ERROR: NO se pudo actualizar el Kardex".
        UNDO, LEAVE.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tabla-ccbcdocu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE tabla-ccbcdocu Procedure 
PROCEDURE tabla-ccbcdocu PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{aplic/web/import-invoice-kipu.i &Cabecera="bCcbcdocu" &Detalle="Ccbddocu"}

/*


/* Transferencia gratuita */
DEF VAR x-es-transferencia-gratuita AS LOG NO-UNDO.
DEF VAR x-tasaigv AS DECI NO-UNDO.
DEF VAR x-factor-descuento AS DECI NO-UNDO.
DEF VAR x-dcto_otros_factor AS DECI NO-UNDO.
DEF VAR x-dcto_encarte AS DECI NO-UNDO.

DEFINE VAR x-items AS INT INIT 0.
DEFINE VAR x-filer1 AS DEC INIT 0.0000.
DEFINE VAR x-filer2 AS DEC INIT 0.0000.

DEFINE VAR x-linea-bolsas-plastica AS CHAR NO-UNDO.
DEFINE VAR x-articulo-ICBPER AS CHAR NO-UNDO.
DEFINE VAR x-existe-icbper AS LOG NO-UNDO.
DEFINE VAR x-exonerado AS DECI NO-UNDO.
DEFINE VAR x-gratuito AS DEC NO-UNDO.
DEFINE VAR x-sumaImporteTotalSinImpuesto AS DEC.
DEFINE VAR x-montoBaseIgv AS DEC.
DEFINE VAR x-sumaIGV AS DEC.
DEFINE VAR x-OtrosTributosOpGratuitas AS DEC. 
DEFINE VAR x-TotalImpuestos AS DEC.

x-precio-ICBPER = 0.
x-TotalImpuestoBolsaPlastica = 0.

x-articulo-ICBPER = "099268".
x-linea-bolsas-plastica = "086".
x-tasaigv = bCcbcdocu.PorIgv / 100.

x-items = 0.
FOR EACH Ccbddocu OF bCcbcdocu NO-LOCK:
    FIND FIRST almmmatg OF Ccbddocu NO-LOCK NO-ERROR.    
    x-items = x-items + 1.
    IF x-items > 1 THEN LEAVE.
END.
x-es-transferencia-gratuita = NO.
IF LOOKUP(bCcbcdocu.fmapgo,"899,900") > 0  THEN DO:
    x-es-transferencia-gratuita  = YES.
END.

x-exonerado = 0.
x-gratuito = 0.
x-gratuito = 0.
x-sumaImporteTotalSinImpuesto = 0.
x-montoBaseIgv = 0.
x-sumaIGV = 0.
x-OtrosTributosOpGratuitas = 0.

FOR EACH Ccbddocu OF bCcbcdocu EXCLUSIVE-LOCK:
    FIND FIRST almmmatg OF Ccbddocu NO-LOCK NO-ERROR.
    IF Ccbddocu.codmat = x-articulo-ICBPER THEN DO:
        /* Ya no considerar el item ICBPER como articulo */
        NEXT.
    END.
    /* Tipo de Afectación */
    ASSIGN Ccbddocu.cTipoAfectacion = "GRAVADA".
    IF x-es-transferencia-gratuita  = YES THEN DO:
        ASSIGN Ccbddocu.cTipoAfectacion = "GRATUITA".
    END.
    ELSE DO:
        IF Ccbddocu.aftigv = NO THEN ASSIGN Ccbddocu.cTipoAfectacion = "EXONERADA".        
        IF LOOKUP(Ccbddocu.coddoc,"N/C,N/D") = 0 THEN DO:
            IF Ccbddocu.preuni <= 0.06 THEN ASSIGN Ccbddocu.cTipoAfectacion = "GRATUITA".
        END.
    END.
    x-filer1 = Ccbddocu.ImpLin.
    /* Precio Unitario SIN impuestos */
    IF Ccbddocu.cTipoAfectacion = "EXONERADA" THEN DO:
        ASSIGN Ccbddocu.cPreUniSinImpuesto = Ccbddocu.preuni.
    END.
    ELSE DO:
        ASSIGN Ccbddocu.cPreUniSinImpuesto = ROUND(Ccbddocu.preuni / (1 + x-TasaIGV), 4). 
    END.
    /* Factor del Descuento: en decimales */
    x-factor-descuento = 0.
    IF LOOKUP(Ccbddocu.coddoc,"N/C,N/D") = 0 THEN DO:
        x-dcto_otros_factor  = 0.
        x-dcto_encarte = 0.     /* NO se está dando junto con por:dsctos[x] */
                                /* En caso contrario revisar la rutuina */
        x-dcto_otros_factor = Ccbddocu.dcto_otros_factor.
        IF Ccbddocu.ImpDto2 > 0 AND Ccbddocu.ImpLin <> 0 
            THEN x-dcto_encarte = Ccbddocu.ImpDto2 / Ccbddocu.ImpLin * 100.
        IF Ccbddocu.Por_Dsctos[1]     > 0 
            OR Ccbddocu.Por_Dsctos[2] > 0 
            OR Ccbddocu.Por_Dsctos[3] > 0 /*OR t-Ccbddocu.dcto_otros_factor > 0*/ 
            OR x-dcto_otros_factor  > 0 
            OR x-dcto_encarte > 0 THEN DO:
            x-factor-descuento = ( 1 -  ( 1 - Ccbddocu.Por_Dsctos[1] / 100 ) *
                                   ( 1 - Ccbddocu.Por_Dsctos[2] / 100 ) *
                                   ( 1 - Ccbddocu.Por_Dsctos[3] / 100 ) *  
                                   ( 1 - x-dcto_encarte / 100 ) *
                                   ( 1 - x-dcto_otros_factor / 100 ) ) *  100.                        
            x-factor-descuento = ROUND(x-factor-descuento / 100 , 5).   /* Puede ser hasta 5 decimales */
        END.
    END.
    IF x-factor-descuento >= 1 THEN DO:
        ASSIGN Ccbddocu.cTipoAfectacion = "GRATUITA".
    END.
    ASSIGN Ccbddocu.FactorDescuento = x-factor-descuento.
    /* Tasa de IGV */
    IF LOOKUP(Ccbddocu.cTipoAfectacion,"EXONERADA,INAFECTA") = 0 THEN DO:
        ASSIGN Ccbddocu.TasaIGV = x-tasaIGV.
    END.
    /* Importes Unitarios */
    IF Ccbddocu.cTipoAfectacion <> "GRATUITA" THEN DO:
        ASSIGN Ccbddocu.ImporteUnitarioSinImpuesto = Ccbddocu.cPreUniSinImpuesto.
    END.
    IF LOOKUP(Ccbddocu.cTipoAfectacion,"GRATUITA") > 0 THEN DO:
        ASSIGN Ccbddocu.ImporteReferencial = Ccbddocu.cPreUniSinImpuesto.
    END.
    /* Importe Base del Descuento */
    IF Ccbddocu.FactorDescuento > 0 THEN DO:
        ASSIGN 
            Ccbddocu.ImporteBaseDescuento = ROUND(Ccbddocu.ImporteUnitarioSinImpuesto * Ccbddocu.candes, 2) 
            Ccbddocu.ImporteDescuento = ROUND(Ccbddocu.FactorDescuento * Ccbddocu.ImporteBaseDescuento, 2).
    END.
    /* Importe total SIN impuestos */
    IF Ccbddocu.cTipoAfectacion = "GRATUITA" THEN DO:
/*         ASSIGN                                                                                         */
/*             Ccbddocu.ImporteTotalSinImpuesto = ROUND(Ccbddocu.ImporteReferencial * Ccbddocu.candes, 2) */
/*             Ccbddocu.MontoBaseIGV = ROUND(Ccbddocu.ImporteReferencial * Ccbddocu.candes, 2).           */
        ASSIGN
            Ccbddocu.ImporteTotalSinImpuesto = Ccbddocu.ImpLin - Ccbddocu.ImpIgv
            Ccbddocu.MontoBaseIGV = Ccbddocu.ImpLin - Ccbddocu.ImpIgv.
    END.
    ELSE DO:
/*         ASSIGN                                                                                                                               */
/*             Ccbddocu.ImporteTotalSinImpuesto = ROUND((Ccbddocu.ImporteUnitarioSinImpuesto * Ccbddocu.candes) - Ccbddocu.ImporteDescuento, 2) */
/*             Ccbddocu.MontoBaseIGV = ROUND((Ccbddocu.ImporteUnitarioSinImpuesto * Ccbddocu.candes) - Ccbddocu.ImporteDescuento, 2).           */
        ASSIGN
            Ccbddocu.ImporteTotalSinImpuesto = ROUND((Ccbddocu.ImpLin - Ccbddocu.ImpIgv) - Ccbddocu.ImpDto, 2)
            Ccbddocu.MontoBaseIGV = ROUND((Ccbddocu.ImpLin - Ccbddocu.ImpIgv) - Ccbddocu.ImpDto, 2).
    END.
    /* Importes IMPUESTOS con y sin impuestos */
/*     ASSIGN                                                                                                           */
/*         Ccbddocu.ImporteIGV = ROUND(Ccbddocu.MontoBaseIGV * Ccbddocu.TasaIGV, 2)                                     */
/*         Ccbddocu.ImporteTotalImpuestos = IF (Ccbddocu.cTipoAfectacion = "GRATUITA") THEN 0 ELSE Ccbddocu.ImporteIGV. */
    ASSIGN 
        Ccbddocu.ImporteIGV = ROUND(Ccbddocu.ImpIgv, 2)
        Ccbddocu.ImporteTotalImpuestos = IF (Ccbddocu.cTipoAfectacion = "GRATUITA") THEN 0 ELSE Ccbddocu.ImporteIGV.

    IF Ccbddocu.cTipoAfectacion <> "GRATUITA" THEN DO:
        /*Ccbddocu.ImporteUnitarioConImpuesto = ROUND((Ccbddocu.ImporteTotalSinImpuesto + Ccbddocu.ImporteTotalImpuesto) / Ccbddocu.candes, 4).*/
        Ccbddocu.ImporteUnitarioConImpuesto = ROUND(Ccbddocu.PreUni, 4). /*4*/
    END.
    IF Ccbddocu.cTipoAfectacion = "EXONERADA" THEN DO:
        /*ASSIGN Ccbddocu.cImporteVentaExonerado = ROUND((Ccbddocu.ImporteUnitarioSinImpuesto * Ccbddocu.candes) - Ccbddocu.ImporteDescuento, 4).*/
        ASSIGN Ccbddocu.cImporteVentaExonerado = ROUND((Ccbddocu.ImpLin - Ccbddocu.ImpIgv) - Ccbddocu.ImpDto, 4).
    END.
    IF Ccbddocu.cTipoAfectacion = "GRATUITA" THEN DO:
        ASSIGN Ccbddocu.cImporteVentaGratuito = ROUND(Ccbddocu.ImporteReferencial * Ccbddocu.candes, 4).
    END.
    IF LOOKUP(Ccbddocu.cTipoAfectacion,"EXONERADA,GRATUITA") = 0 THEN DO:
/*         ASSIGN                                                                     */
/*             Ccbddocu.cSumaImpteTotalSinImpuesto = Ccbddocu.ImporteTotalSinImpuesto */
/*             Ccbddocu.cMontoBaseIGV = Ccbddocu.MontoBaseIGV.                        */
        ASSIGN  
            Ccbddocu.cSumaImpteTotalSinImpuesto = ROUND(Ccbddocu.ImpLin - Ccbddocu.ImpIgv, 2)
            Ccbddocu.cMontoBaseIGV = Ccbddocu.MontoBaseIGV.
    END.
    IF Ccbddocu.cTipoAfectacion <> "GRATUITA" THEN DO:
        ASSIGN Ccbddocu.cSumaIGV = Ccbddocu.ImporteIGV.
    END.
    IF Ccbddocu.cTipoAfectacion = "GRATUITA" THEN DO:
        Ccbddocu.cOtrosTributosOpGratuito = Ccbddocu.ImporteIGV.
    END.
    /* Importe Total Con Impuestos */
    IF Ccbddocu.cTipoAfectacion <> "GRATUITA" THEN DO:
        /*ASSIGN Ccbddocu.cImporteTotalConImpuesto = Ccbddocu.MontoBaseIGV + Ccbddocu.ImporteIGV.*/
        ASSIGN Ccbddocu.cImporteTotalConImpuesto = Ccbddocu.ImpLin.
    END.
    x-filer2 = Ccbddocu.candes.
    /* Bolsa Plastica */
    IF AVAILABLE almmmatg AND almmmatg.codfam = x-linea-bolsas-plastica THEN DO:
        RUN impuesto-bolsa-plastica (INPUT Ccbddocu.candes).
        ASSIGN 
            Ccbddocu.ImporteTotalImpuesto = Ccbddocu.ImporteTotalImpuesto + Ccbddocu.montoTributoBolsaPlastico.
        x-existe-icbper = YES.        
    END.        


    /* ************************************************************************************************************ */
    /* SUB-TOTALES */
    /* ************************************************************************************************************ */
    IF Ccbddocu.cTipoAfectacion = "EXONERADA" THEN DO:        
        /*x-exonerado = x-exonerado + Ccbddocu.cImporteVentaExonerado.*/
        x-exonerado = x-exonerado + (Ccbddocu.ImpLin - Ccbddocu.ImpIgv).
    END.
    IF Ccbddocu.cTipoAfectacion = "GRATUITA" THEN DO:
        /*x-gratuito = x-gratuito + Ccbddocu.cImporteVentaGratuito.*/
        x-gratuito = x-gratuito + Ccbddocu.ImpLin.
    END.
    IF LOOKUP(Ccbddocu.cTipoAfectacion,"EXONERADA,GRATUITA") = 0 THEN DO:
        /*x-sumaImporteTotalSinImpuesto = x-sumaImporteTotalSinImpuesto + Ccbddocu.cSumaImpteTotalSinImpuesto.*/
        x-sumaImporteTotalSinImpuesto = x-sumaImporteTotalSinImpuesto + (Ccbddocu.ImpLin - Ccbddocu.ImpIgv).
        x-montoBaseIgv = x-montoBaseIgv + Ccbddocu.cMontoBaseIGV.     /* U */
    END.
    IF Ccbddocu.cTipoAfectacion <> "GRATUITA" THEN DO:
        /*x-sumaIGV = x-sumaIGV + Ccbddocu.cSumaIGV.*/
        x-sumaIGV = x-sumaIGV + Ccbddocu.ImpIgv.
    END.
    IF Ccbddocu.cTipoAfectacion = "GRATUITA" THEN DO:
        /*x-OtrosTributosOpGratuitas = x-OtrosTributosOpGratuitas + Ccbddocu.cOtrosTributosOpGratuito.*/
        x-OtrosTributosOpGratuitas = x-OtrosTributosOpGratuitas + Ccbddocu.ImpIgv.
    END.
END.

/* ************************************************************************************************************ */
/* TOTALES */
/* ************************************************************************************************************ */
ASSIGN 
    bCcbcdocu.totalValorVentaNetoOpGravadas     = x-sumaImporteTotalSinImpuesto
    bCcbcdocu.totalValorVentaNetoOpGratuitas    = x-gratuito
    bCcbcdocu.totalTributosOpeGratuitas         = x-OtrosTributosOpGratuitas
    bCcbcdocu.totalValorVentaNetoOpExoneradas   = x-exonerado
    bCcbcdocu.totalIgv                          = x-sumaIGV
    bCcbcdocu.totalImpuestos                    = bCcbcdocu.totalIgv
    bCcbcdocu.totalValorVenta                   = x-sumaImporteTotalSinImpuesto
    bCcbcdocu.totalPrecioVenta                  = bCcbcdocu.totalValorVentaNetoOpGravadas + x-sumaIGV.
/* ICBPER */
ASSIGN 
    bCcbcdocu.totalPrecioVenta = bCcbcdocu.totalPrecioVenta + x-TotalImpuestoBolsaPlastica
    bCcbcdocu.montoBaseICBPER = x-precio-ICBPER 
    bCcbcdocu.totalMontoICBPER = x-TotalImpuestoBolsaPlastica. 
/* EXONERADAS */
IF bCcbcdocu.totalValorVentaNetoOpExoneradas > 0 THEN DO:
    ASSIGN 
        bCcbcdocu.totalPrecioVenta = bCcbcdocu.totalPrecioVenta + bCcbcdocu.totalValorVentaNetoOpExoneradas
        bCcbcdocu.totalValorVenta = bCcbcdocu.totalValorVenta + bCcbcdocu.totalValorVentaNetoOpExoneradas.
END.
x-TotalImpuestos = bCcbcdocu.totalIGV.   /* Jul2024 : x-OtrosTributosOpGratuitas. */
ASSIGN 
    bCcbcdocu.totalVenta = bCcbcdocu.totalPrecioVenta.
ASSIGN 
    bCcbcdocu.totalImpuestos = x-TotalImpuestos.   
/* + ICBPER */
ASSIGN 
    bCcbcdocu.totalImpuestos = bCcbcdocu.totalImpuestos + x-TotalImpuestoBolsaPlastica.   

/* ************************************************************************************************************ */
/* TOTALES AJUSTADOS */
/* ************************************************************************************************************ */
/* ASSIGN                                                             */
/*     bCcbcdocu.totalValorVentaNetoOpGravadas     = bCcbcdocu.ImpVta */
/*     bCcbcdocu.totalIgv                          = bCcbcdocu.ImpIgv */
/*     bCcbcdocu.totalImpuestos                    = bCcbcdocu.ImpIgv */
/*     bCcbcdocu.totalValorVenta                   = bCcbcdocu.ImpVta */
/*     bCcbcdocu.totalPrecioVenta                  = bCcbcdocu.ImpTot */
/*     .                                                              */

/* ************************************************************************* */
/* AJUSTE DE IMPORTES FINALES EN CASO DE B2C / RIQRA */
/* ************************************************************************* */
/* DEF VAR Local_Delta AS DECI NO-UNDO.                                                             */
/* DEF VAR Local_TipoAfectacion AS CHAR NO-UNDO.                                                    */
/* DEF VAR importeDescuentoGlobal AS DEC.                                                           */
/*                                                                                                  */
/* importeDescuentoGlobal = bCcbcdocu.impint.                                                       */
/* Local_Delta = bCcbcdocu.ImpTot - importeDescuentoGlobal - bCcbcdocu.TotalVenta.                  */
/* {sunat/sunat-calculo-importes-ajustados.i &CabeceraAjuste="bCcbcdocu" &DetalleAjuste="Ccbddocu"} */


*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tabla-faccpedi) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE tabla-faccpedi Procedure 
PROCEDURE tabla-faccpedi :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{aplic/web/import-invoice-kipu.i &Cabecera="Faccpedi" &Detalle="Facdpedi"}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

