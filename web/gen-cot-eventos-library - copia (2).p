&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER b-VtaCDocu FOR VtaCDocu.
DEFINE BUFFER b-VtaDDocu FOR VtaDDocu.
DEFINE TEMP-TABLE BONIFICACION LIKE FacDPedi.
DEFINE TEMP-TABLE ITEM NO-UNDO LIKE FacDPedi.
DEFINE TEMP-TABLE ITEM-1 NO-UNDO LIKE FacDPedi.
DEFINE TEMP-TABLE PEDI LIKE FacDPedi.
DEFINE TEMP-TABLE T-CONTROL NO-UNDO LIKE FacDPedi.



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
/*&SCOPED-DEFINE precio-venta-general pri/PrecioVentaMayorCreditoFlash.p*/
&SCOPED-DEFINE precio-venta-general web/PrecioFinalCreditoMayorista.p


/* ***************************  Definitions  ************************** */

DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-coddiv AS CHAR.
DEFINE SHARED VAR cl-codcia AS INT.
DEFINE SHARED VAR s-user-id AS CHAR.

DEFINE VAR x-Articulo-ICBPer AS CHAR INIT '099268'.

DEF VAR s-coddoc AS CHAR INIT "COT" NO-UNDO.
DEF VAR s-nroser AS INT NO-UNDO.
DEF VAR s-tpoped AS CHAR INIT "E" NO-UNDO .
DEF VAR s-codmon LIKE faccpedi.codmon NO-UNDO.
DEF VAR s-nrodec AS INTE INIT 4 NO-UNDO.
DEF VAR s-tpocmb AS DEC NO-UNDO.
DEF VAR s-porigv AS DEC NO-UNDO.
DEF VAR s-FmaPgo AS CHAR NO-UNDO.
DEF VAR s-cndvta-validos AS CHAR NO-UNDO.

DEF TEMP-TABLE ResumenxLinea
    FIELD codmat LIKE almmmatg.codmat
    FIELD codfam LIKE almmmatg.codfam
    FIELD subfam LIKE almmmatg.subfam
    FIELD canped LIKE facdpedi.canped
    INDEX Llave01 AS PRIMARY /*UNIQUE*/ codmat codfam subfam.

DEF TEMP-TABLE ErroresxLinea LIKE ResumenxLinea.

FIND FIRST FacCorre WHERE Faccorre.codcia = s-codcia
    AND Faccorre.coddiv = s-coddiv
    AND Faccorre.coddoc = s-coddoc
    AND  FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
    MESSAGE 'NO está configurado el correlativo para el doc.' s-coddoc
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
ASSIGN
    s-NroSer = FacCorre.NroSer.

DEF VAR s-Import-IBC AS LOG INIT NO NO-UNDO.
DEF VAR s-Import-B2B AS LOG INIT NO NO-UNDO.
DEF VAR s-Import-Cissac AS LOG INIT NO NO-UNDO.
DEF VAR s-CodCli AS CHAR NO-UNDO.
DEF VAR s-CodVen AS CHAR NO-UNDO.
DEF VAR s-CndVta AS CHAR NO-UNDO.
DEF VAR s-Cmpbnte AS CHAR NO-UNDO.

DEFINE VAR x-serie AS CHAR.
DEFINE VAR x-numero AS CHAR.
DEFINE VAR x-serie-numero AS CHAR.

/* ***************************************************************** */
/* Pantalla de Mensajes */
/* ***************************************************************** */
DEFINE IMAGE IMAGE-1 FILENAME "IMG\Coti.ico" SIZE 12 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.
/* ***************************************************************** */
/* ***************************************************************** */

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
      TABLE: b-VtaCDocu B "?" ? INTEGRAL VtaCDocu
      TABLE: b-VtaDDocu B "?" ? INTEGRAL VtaDDocu
      TABLE: BONIFICACION T "?" ? INTEGRAL FacDPedi
      TABLE: ITEM T "?" NO-UNDO INTEGRAL FacDPedi
      TABLE: ITEM-1 T "?" NO-UNDO INTEGRAL FacDPedi
      TABLE: PEDI T "?" ? INTEGRAL FacDPedi
      TABLE: T-CONTROL T "?" NO-UNDO INTEGRAL FacDPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 8.35
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Change-TpoPed) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Change-TpoPed Procedure 
PROCEDURE Change-TpoPed :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pTpoPed AS CHAR. 
 
s-TpoPed = pTpoPed.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-COT_Genera-COT) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE COT_Genera-COT Procedure 
PROCEDURE COT_Genera-COT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER pCodCli AS CHAR.
DEF INPUT PARAMETER pCodVen AS CHAR.
DEF OUTPUT PARAMETER pNroPed AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

FIND gn-clie WHERE gn-clie.codcia = cl-codcia
    AND gn-clie.codcli = pCodCli NO-LOCK NO-ERROR.
FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = pCodDiv NO-LOCK NO-ERROR.

DEF VAR s-DiasVtoCot AS INTE NO-UNDO.
DEF VAR s-MinimoDiasDespacho AS INTE NO-UNDO.

ASSIGN
    s-DiasVtoCot = GN-DIVI.DiasVtoCot
    s-MinimoDiasDespacho = GN-DIVI.Campo-Dec[3]
    .
ASSIGN
    s-CodCli = pCodCli
    s-CodVen = pCodVen.

DEF VAR I-nroItm AS INTE NO-UNDO.

/* RHC 05/10/2022: Días Vencimiento Pre-Pedido Eventos */
DEF VAR s-Dias-Vcto AS INTE INIT 15 NO-UNDO.
FIND FIRST FacTabla WHERE FacTabla.CodCia = s-CodCia AND 
    FacTabla.Tabla = 'GN-DIVI' AND
    FacTabla.Codigo = pCodDiv NO-LOCK NO-ERROR.
IF AVAILABLE FacTabla AND FacTabla.Valor[2] > 0 THEN s-Dias-Vcto = FacTabla.Valor[2].

/* Hay que cargar lo digitado por terceros en el pre-pedido original */
PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    /* Cargamos Digitados Propios (PET) */
    EMPTY TEMP-TABLE ITEM.
    I-NroItm = 1.
    FIND FIRST Vtacdocu WHERE VtaCDocu.CodCia = s-CodCia
        AND VtaCDocu.CodDiv = s-CodDiv
        AND VtaCDocu.CodPed = "PET"
        AND VtaCDocu.CodCli = pCodCli
        AND VtaCDocu.Libre_c05 = "*"
        AND VtaCDocu.FlgEst <> "A"
        AND VtaCDocu.FlgSit <> 'T'
        AND VtaCDocu.FchPed >= (TODAY - s-Dias-Vcto)
        NO-LOCK NO-ERROR.
    IF AVAILABLE VtaCDocu THEN DO:
        FIND CURRENT VtaCDocu EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &MensajeError="pMensaje"}
             RETURN 'ADM-ERROR'.
        END.
        FOR EACH Vtaddocu OF Vtacdocu NO-LOCK BY Vtaddocu.NroItm:
            FIND FIRST ITEM WHERE ITEM.codmat = Vtaddocu.codmat NO-LOCK NO-ERROR.
                        IF AVAILABLE ITEM THEN NEXT.
            CREATE ITEM.
            BUFFER-COPY Vtaddocu 
                TO ITEM 
                ASSIGN ITEM.NroItm = I-NroItm.
            I-NroItm = I-NroItm + 1.
        END.
        ASSIGN
            VtaCDocu.FlgSit = "T".
    END.
    /* Cargamos digitados Tercero (PPT): Solo los que tienen una cantidad digitada */
    FOR EACH b-Vtacdocu EXCLUSIVE-LOCK WHERE b-Vtacdocu.codcia = s-CodCia
            AND b-Vtacdocu.codped = "PPT"
            AND b-Vtacdocu.coddiv = s-CodDiv
            AND b-Vtacdocu.flgest = "P"
            AND b-Vtacdocu.codcli = pCodCli
            /*AND b-Vtacdocu.libre_c05 = "*"*/
            AND b-Vtacdocu.fchven >= TODAY:
        FOR EACH b-Vtaddocu OF b-Vtacdocu NO-LOCK WHERE b-Vtaddocu.CanPed > 0
            BY b-Vtaddocu.NroItm:
            FIND FIRST ITEM WHERE ITEM.codmat = b-Vtaddocu.codmat NO-LOCK NO-ERROR.
            IF AVAILABLE ITEM THEN NEXT.
            CREATE ITEM.
            BUFFER-COPY b-Vtaddocu EXCEPT b-Vtaddocu.libre_c01 b-Vtaddocu.libre_c02 b-Vtaddocu.libre_c03
                b-Vtaddocu.libre_c04 b-Vtaddocu.libre_d01 b-Vtaddocu.libre_d02
                TO ITEM 
                ASSIGN ITEM.NroItm = I-NroItm.
            /* Cargamos también al pre-pedido original */
            IF AVAILABLE VtaCDocu THEN DO:
                CREATE Vtaddocu.
                BUFFER-COPY b-Vtaddocu TO Vtaddocu
                    ASSIGN
                    VtaDDocu.CodDiv = Vtacdocu.coddiv
                    VtaDDocu.CodPed = Vtacdocu.codped
                    VtaDDocu.NroPed = Vtacdocu.nroped
                    VtaDDocu.FchPed = VTacdocu.fchped
                    VtaDDocu.NroItm = I-nroItm.
            END.
            I-NroItm = I-NroItm + 1.
        END.
        ASSIGN
            b-VtaCDocu.FchAprobacion = TODAY
            b-VtaCDocu.FlgEst = "C"     /* Marcamos */
            b-Vtacdocu.libre_c05 = "*"
            b-VtaCDocu.UsrAprobacion = s-user-id.
        /* Como solo hay 1 se sale del loop */
        LEAVE.
    END.
    IF NOT CAN-FIND(FIRST ITEM NO-LOCK) THEN DO:
        pMensaje = "NO hay items registrados".
        RETURN 'ADM-ERROR'.
    END.
    FOR EACH ITEM:
        CREATE T-CONTROL.
        BUFFER-COPY ITEM TO T-CONTROL.
    END.

    /* ************************************************************************************* */
    {vta2/icorrelativosecuencial.i &Codigo = s-coddoc &Serie = s-nroser}
    /* ************************************************************************************* */

    CREATE Faccpedi.
    IF AVAILABLE VtaCDocu THEN DO:
        BUFFER-COPY Vtacdocu 
            EXCEPT VtaCDocu.Libre_C02 VtaCDocu.Libre_C03 Vtacdocu.Libre_c05
            TO Faccpedi
            ASSIGN 
            FacCPedi.CodDoc = s-coddoc 
            FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
            FacCPedi.Atencion = VtaCDocu.DniCli
            FacCPedi.Libre_C02 = VtaCDocu.Libre_C03    /* Última atención */
            .
        s-FmaPgo = FacCPedi.FmaPgo.
    END.
    ELSE DO:
        ASSIGN 
            FacCPedi.CodCia = s-CodCia
            FacCPedi.CodDiv = s-CodDiv
            FacCPedi.CodDoc = s-coddoc 
            FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
            .
        RUN vtagn/p-fmapgo-valido.r (s-codcli, s-tpoped, pCodDiv, OUTPUT s-cndvta-validos).
        s-FmaPgo = ENTRY(1, s-cndvta-validos).
        ASSIGN
            FacCPedi.FchVen = (TODAY + s-DiasVtoCot)
            FacCPedi.FchEnt = (TODAY + s-MinimoDiasDespacho)
            FacCPedi.CodCli = s-CodCli
            Faccpedi.NomCli = gn-clie.NomCli
            Faccpedi.RucCli = gn-clie.Ruc 
            Faccpedi.DirCli = gn-clie.DirCli
            FacCPedi.FmaPgo = s-FmaPgo
            .
        FIND gn-clied WHERE gn-clied.codcia = cl-codcia
            AND gn-clied.codcli = s-codcli
            AND gn-clied.sede = Faccpedi.sede
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clied THEN DO:
            FacCPedi.Glosa = Gn-ClieD.DirCli.
            FacCPedi.CodPos = Gn-ClieD.Codpos.
        END.
          IF TRUE <> (FacCPedi.RucCli > '') THEN Faccpedi.Cmpbnte = 'BOL'.
          ELSE Faccpedi.Cmpbnte = 'FAC'.
        ASSIGN
            FacCPedi.CodMon = 1
            FacCPedi.FlgIgv = YES
            FacCPedi.Libre_d01 = s-NroDec.
    END.
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    ASSIGN
        FacCPedi.TpoPed = s-TpoPed
        FacCPedi.FchPed = TODAY 
        FacCPedi.FlgEst = "PV"     /* APROBADO */
        FacCPedi.Hora = STRING(TIME,"HH:MM:SS")
        FacCPedi.Usuario = S-USER-ID
        FacCPedi.Libre_c01 = pCodDiv    /* Lista de Precios */
        FacCPedi.Sede = "@@@"
        FacCPedi.CodVen = s-CodVen
        .
    ASSIGN
        pNroPed = FacCPedi.NroPed.

    /* ************************************************************************************* */
    /* Recalculamos Precios de Venta */
    /* OJO: es la versión de precios antes de terminar el módulo de Pricing 2021 */
    /* RHC 05/10/2022: Si hay un error en un precio NO continúa el proceso */
    /* ************************************************************************************* */
    {web/recalcular-cotizacion-unificada-web.i &pTpoPed=s-TpoPed &pMuestraError=NO}

    /* NOTA: Si un producto NO tiene precio entonces se aborta la grabación */
    FOR EACH T-CONTROL:
        IF NOT CAN-FIND(FIRST ITEM WHERE ITEM.codmat = T-CONTROL.codmat NO-LOCK) THEN DO:
            pMensaje = "Se han detectado productos sin precios" + CHR(10) +
                "Proceso abortado" + CHR(10) + CHR(10) +
                pMensaje.
            UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
        END.
    END.
    /* ************************************************************************************* */
    /* Generamos Detalle */
    /* ************************************************************************************* */
    FOR EACH ITEM NO-LOCK, FIRST Almmmatg OF ITEM NO-LOCK:
        CREATE Facdpedi.
        BUFFER-COPY ITEM TO Facdpedi
            ASSIGN
                FacDPedi.CodCia = FacCPedi.CodCia
                FacDPedi.CodDiv = FacCPedi.CodDiv
                FacDPedi.coddoc = FacCPedi.coddoc
                FacDPedi.NroPed = FacCPedi.NroPed
                FacDPedi.FchPed = FacCPedi.FchPed
                FacDPedi.Hora   = FacCPedi.Hora 
                FacDPedi.FlgEst = FacCPedi.FlgEst.
    END.
    /* ************************************************************************************** */
    /* DESCUENTOS APLICADOS A TODA LA COTIZACION */
    /* ************************************************************************************** */
    RUN EVEN_DESCUENTOS-FINALES (INPUT pCodDiv, OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = 'ERROR al aplicar los descuentos totales a la cotización'.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* ************************************************************************************** */
    /* RHC 02/01/2020 Promociones proyectadas */
    /* ************************************************************************************** */
    RUN EVEN_BONIFICACION (OUTPUT pMensaje).
    /* ************************************************************************************** */
    /* ************************************************************************************** */
    {vtagn/totales-cotizacion-unificada.i &Cabecera="FacCPedi" &Detalle="FacDPedi"}
    /* ****************************************************************************************** */
    /* Importes SUNAT */
    /* NO actualiza campos Progress */
    /* ****************************************************************************************** */
    DEF VAR hProcSunat AS HANDLE NO-UNDO.
    RUN sunat/sunat-calculo-importes PERSISTENT SET hProcSunat.
    RUN tabla-faccpedi IN hProcSunat (INPUT Faccpedi.CodDiv,
                                      INPUT Faccpedi.CodDoc,
                                      INPUT Faccpedi.NroPed,
                                      OUTPUT pMensaje).
    IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
    DELETE PROCEDURE hProcSunat.
    /* ****************************************************************************************** */
    /* ************************************************************************************** */
    /* ************************************************************************************** */
    /* Renumeramos items */
    I-NroItm = 1.
    FOR EACH Facdpedi OF Faccpedi BY Facdpedi.nroitm:
        ASSIGN
            Facdpedi.NroItm = I-NroItm.
        I-NroItm = I-NroItm + 1.
    END.
    /* Referencias cruzadas */
    IF AVAILABLE VtaCDocu THEN
        ASSIGN
            FacCPedi.CodRef = VtaCDocu.CodPed
            FacCPedi.NroRef = VtaCDocu.NroPed
            VtaCDocu.CodRef = FacCPedi.CodDoc
            VtaCDocu.NroRef = FacCPedi.NroPed
            Vtacdocu.FlgSit = "T".
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-COT_Genera-COT-por-PET) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE COT_Genera-COT-por-PET Procedure 
PROCEDURE COT_Genera-COT-por-PET :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER pCodVen AS CHAR.
DEF INPUT PARAMETER pCodRef AS CHAR.
DEF INPUT PARAMETER pNroRef AS CHAR.

DEF OUTPUT PARAMETER pNroPed  AS CHAR NO-UNDO.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR cRowid AS ROWID NO-UNDO.    /* Control del registro del pedido comercial */


FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = pCodDiv NO-LOCK NO-ERROR.

DEF VAR s-MinimoDiasDespacho AS INTE NO-UNDO.
DEF VAR s-DiasVtoCot AS INTE NO-UNDO.

ASSIGN
    s-DiasVtoCot = GN-DIVI.DiasVtoCot
    s-MinimoDiasDespacho = GN-DIVI.Campo-Dec[3]
    .
ASSIGN
    s-CodVen = pCodVen.

DEF VAR I-nroItm AS INTE NO-UNDO.

/* Hay que cargar lo digitado por terceros en el pre-pedido original */
DISPLAY 'Importando Pre-Pedido.....Un momento por favor' @ Fi-Mensaje WITH FRAME F-Proceso.
/* 1ro. Número de cotización y soltamos la tabla */
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    /* ************************************************************************************* */
    {vta2/icorrelativosecuencial.i &Codigo = s-coddoc &Serie = s-nroser}
    /* ************************************************************************************* */

    x-serie-numero = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999").

    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.

    FIND CURRENT faccorre NO-LOCK NO-ERROR.
END.
HIDE FRAME F-Proceso.


/* 2do. grabamos cotización */
PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    /* Cargamos Digitados Propios (PET) */
    EMPTY TEMP-TABLE ITEM.
    I-NroItm = 1.
    FIND FIRST Vtacdocu WHERE VtaCDocu.CodCia = s-CodCia
        AND VtaCDocu.CodPed = pCodRef
        AND VtaCDocu.NroPed = pNroRef
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Vtacdocu THEN DO:
        pMensaje = "Documento " + pCodRef + " " + pNroRef + " NO registrado".
        RETURN 'ADM-ERROR'.
    END.
    FIND CURRENT VtaCDocu EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        {lib/mensaje-de-error.i &MensajeError="pMensaje"}
        RETURN 'ADM-ERROR'.
    END.
    FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND
        gn-clie.codcli = Vtacdocu.codcli NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-clie THEN DO:
        pMensaje = "Cliente " + Vtacdocu.codcli + " NO registrado".
        UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        s-codcli = gn-clie.codcli.
    FOR EACH Vtaddocu OF Vtacdocu NO-LOCK BY Vtaddocu.NroItm:
        FIND FIRST ITEM WHERE ITEM.codmat = Vtaddocu.codmat NO-LOCK NO-ERROR.
        IF AVAILABLE ITEM THEN NEXT.
        CREATE ITEM.
        BUFFER-COPY Vtaddocu 
            TO ITEM 
            ASSIGN ITEM.NroItm = I-NroItm.
        I-NroItm = I-NroItm + 1.
    END.
    ASSIGN
        VtaCDocu.FlgSit = "T".
    /* Cargamos digitados Tercero (PPT): Solo los que tienen una cantidad digitada */
    /* 04/01/2014: Ahora viene or Riqra en el Pre-Pedido (PET) */
/*     FOR EACH b-Vtacdocu EXCLUSIVE-LOCK WHERE b-Vtacdocu.codcia = s-CodCia                                */
/*             AND b-Vtacdocu.codped = "PPT"                                                                */
/*             AND b-Vtacdocu.coddiv = s-CodDiv                                                             */
/*             AND b-Vtacdocu.flgest = "P"                                                                  */
/*             AND b-Vtacdocu.codcli = VtaCDocu.CodCli                                                      */
/*             AND b-Vtacdocu.fchven >= TODAY ON ERROR UNDO, THROW:                                         */
/*         FOR EACH b-Vtaddocu OF b-Vtacdocu NO-LOCK WHERE b-Vtaddocu.CanPed > 0                            */
/*             BY b-Vtaddocu.NroItm:                                                                        */
/*             FIND FIRST ITEM WHERE ITEM.codmat = b-Vtaddocu.codmat NO-LOCK NO-ERROR.                      */
/*             IF AVAILABLE ITEM THEN NEXT.                                                                 */
/*             DISPLAY 'Importando artículo ' + b-Vtaddocu.codmat @ Fi-Mensaje WITH FRAME F-Proceso.        */
/*             CREATE ITEM.                                                                                 */
/*             BUFFER-COPY b-Vtaddocu EXCEPT b-Vtaddocu.libre_c01 b-Vtaddocu.libre_c02 b-Vtaddocu.libre_c03 */
/*                 b-Vtaddocu.libre_c04 b-Vtaddocu.libre_d01 b-Vtaddocu.libre_d02                           */
/*                 TO ITEM                                                                                  */
/*                 ASSIGN ITEM.NroItm = I-NroItm.                                                           */
/*             /* Cargamos también al pre-pedido original */                                                */
/*             IF AVAILABLE VtaCDocu THEN DO:                                                               */
/*                 CREATE Vtaddocu.                                                                         */
/*                 BUFFER-COPY b-Vtaddocu TO Vtaddocu                                                       */
/*                     ASSIGN                                                                               */
/*                     VtaDDocu.CodDiv = Vtacdocu.coddiv                                                    */
/*                     VtaDDocu.CodPed = Vtacdocu.codped                                                    */
/*                     VtaDDocu.NroPed = Vtacdocu.nroped                                                    */
/*                     VtaDDocu.FchPed = VTacdocu.fchped                                                    */
/*                     VtaDDocu.NroItm = I-nroItm.                                                          */
/*             END.                                                                                         */
/*             I-NroItm = I-NroItm + 1.                                                                     */
/*         END.                                                                                             */
/*         ASSIGN                                                                                           */
/*             b-VtaCDocu.FchAprobacion = TODAY                                                             */
/*             b-VtaCDocu.FlgEst = "C"     /* Marcamos */                                                   */
/*             b-Vtacdocu.libre_c05 = "*"                                                                   */
/*             b-VtaCDocu.UsrAprobacion = s-user-id.                                                        */
/*         /* Como solo hay 1 se sale del loop */                                                           */
/*         LEAVE.                                                                                           */
/*     END.                                                                                                 */
/*     IF AVAILABLE(b-Vtacdocu) THEN RELEASE b-Vtacdocu.                                                    */
/*     IF AVAILABLE(Vtaddocu)   THEN RELEASE Vtaddocu.                                                      */
/*     HIDE FRAME Fi-Mensaje.                                                                               */

    IF NOT CAN-FIND(FIRST ITEM NO-LOCK) THEN DO:
        pMensaje = "NO hay items registrados".
        UNDO, RETURN 'ADM-ERROR'.
    END.

    CREATE Faccpedi.
    IF AVAILABLE VtaCDocu THEN DO:
        BUFFER-COPY Vtacdocu 
            EXCEPT VtaCDocu.Libre_C02 VtaCDocu.Libre_C03 Vtacdocu.Libre_c05
            TO Faccpedi
            ASSIGN 
            FacCPedi.CodDoc = s-coddoc 
            FacCPedi.CodDiv = s-CodDiv  /* Ic */
            FacCPedi.NroPed = x-serie-numero
            FacCPedi.Atencion = VtaCDocu.DniCli
            FacCPedi.Libre_C02 = VtaCDocu.Libre_C03    /* Última atención */
            .
        s-FmaPgo = FacCPedi.FmaPgo.
        /* 02/03/2024: C.Iman */
        ASSIGN
            FacCPedi.CodOrigen = VtaCDocu.CodOri.
        /* 04/05/2024: C. Tenazoa */
        ASSIGN
            FacCPedi.NroOrigen = VtaCDocu.NroOri        /* EXPO, B2C, etc */
            FacCPedi.Cliente_Recoge = VtaCDocu.TpoLic.  /* Ic - 21May2024 */

    END.
    ELSE DO:
        ASSIGN 
            FacCPedi.CodCia = s-CodCia
            FacCPedi.CodDiv = s-CodDiv
            FacCPedi.CodDoc = s-coddoc 
            FacCPedi.NroPed = x-serie-numero
            .
        RUN vtagn/p-fmapgo-valido.r (s-codcli, s-tpoped, pCodDiv, OUTPUT s-cndvta-validos).
        s-FmaPgo = ENTRY(1, s-cndvta-validos).
        ASSIGN
            FacCPedi.FchVen = (TODAY + s-DiasVtoCot)
            FacCPedi.FchEnt = (TODAY + s-MinimoDiasDespacho)
            FacCPedi.CodCli = s-CodCli
            Faccpedi.NomCli = gn-clie.NomCli
            Faccpedi.RucCli = gn-clie.Ruc 
            Faccpedi.DirCli = gn-clie.DirCli
            FacCPedi.FmaPgo = s-FmaPgo
            .
        FIND gn-clied WHERE gn-clied.codcia = cl-codcia
            AND gn-clied.codcli = s-codcli
            AND gn-clied.sede = Faccpedi.sede
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clied THEN DO:
            FacCPedi.Glosa = Gn-ClieD.DirCli.
            FacCPedi.CodPos = Gn-ClieD.Codpos.
        END.
          IF TRUE <> (FacCPedi.RucCli > '') THEN Faccpedi.Cmpbnte = 'BOL'.
          ELSE Faccpedi.Cmpbnte = 'FAC'.
        ASSIGN
            FacCPedi.CodMon = 1
            FacCPedi.FlgIgv = YES
            FacCPedi.Libre_d01 = s-NroDec.
    END.
    ASSIGN
        FacCPedi.TpoPed = s-TpoPed
        FacCPedi.FchPed = TODAY 
        FacCPedi.FlgEst = "PV"     /* APROBADO */
        FacCPedi.Hora = STRING(TIME,"HH:MM:SS")
        FacCPedi.Usuario = S-USER-ID
        FacCPedi.Libre_c01 = pCodDiv    /* Lista de Precios */
        /*FacCPedi.Sede = "@@@"*/   /* Ic 21May2024 - se desabilito para Riqra debe respetar lo que viene */
        FacCPedi.CodVen = s-CodVen
        .
        IF TRUE <> (FacCPedi.Sede > "") THEN ASSIGN FacCPedi.Sede = "@@@".  /* Ic 21May2024 */
    ASSIGN
        pNroPed = FacCPedi.NroPed
        cRowid = ROWID(Faccpedi).

    /* ************************************************************************************* */
    /* Recalculamos Precios de Venta */
    /* OJO: es la versión de precios antes de terminar el módulo de Pricing 2021 */
    /* RHC 05/10/2022: Si hay un error en un precio NO continúa el proceso */
    /* ************************************************************************************* */
    DISPLAY 'Recalculando.....Un momento por favor' @ Fi-Mensaje WITH FRAME F-Proceso.

    {web/recalcular-cotizacion-unificada-web.i &pTpoPed=s-TpoPed &pMuestraError=YES}

    /* NOTA: Si un producto NO tiene precio entonces se aborta la grabación */
    IF NOT CAN-FIND(FIRST ITEM) THEN DO:
        pMensaje = "NO hay items que grabar" + CHR(10) + "Proceso Abortado".
        HIDE FRAME F-Proceso.
        UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
    END.
    /* ************************************************************************************* */
    /* Generamos Detalle */
    /* ************************************************************************************* */
    FOR EACH ITEM NO-LOCK, FIRST Almmmatg OF ITEM NO-LOCK:
        CREATE Facdpedi.
        BUFFER-COPY ITEM TO Facdpedi
            ASSIGN
                FacDPedi.CodCia = FacCPedi.CodCia
                FacDPedi.CodDiv = FacCPedi.CodDiv
                FacDPedi.coddoc = FacCPedi.coddoc
                FacDPedi.NroPed = FacCPedi.NroPed
                FacDPedi.FchPed = FacCPedi.FchPed
                FacDPedi.Hora   = FacCPedi.Hora 
                FacDPedi.FlgEst = FacCPedi.FlgEst.
    END.
    /* ************************************************************************************** */
    {vtagn/totales-cotizacion-unificada.i &Cabecera="FacCPedi" &Detalle="FacDPedi"}
    /* ****************************************************************************************** */
    /* Importes SUNAT */
    /* NO actualiza campos Progress */
    /* ****************************************************************************************** */
    DEF VAR hProcSunat AS HANDLE NO-UNDO.

    RUN sunat/sunat-calculo-importes PERSISTENT SET hProcSunat.
    RUN tabla-faccpedi IN hProcSunat (INPUT Faccpedi.CodDiv,
                                      INPUT Faccpedi.CodDoc,
                                      INPUT Faccpedi.NroPed,
                                      OUTPUT pMensaje).
    IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
    DELETE PROCEDURE hProcSunat.
    /* ****************************************************************************************** */
    /* ************************************************************************************** */
    /* ************************************************************************************** */
    /* Renumeramos items */
    I-NroItm = 1.
    FOR EACH Facdpedi OF Faccpedi BY Facdpedi.nroitm:
        ASSIGN
            Facdpedi.NroItm = I-NroItm.
        I-NroItm = I-NroItm + 1.
    END.
    /* Referencias cruzadas */
    IF AVAILABLE VtaCDocu THEN
        ASSIGN
            FacCPedi.CodRef = VtaCDocu.CodPed
            FacCPedi.NroRef = VtaCDocu.NroPed
            VtaCDocu.CodRef = FacCPedi.CodDoc
            VtaCDocu.NroRef = FacCPedi.NroPed
            Vtacdocu.FlgSit = "T".

    IF AVAILABLE(Faccpedi) THEN RELEASE Faccpedi.
    IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.
    IF AVAILABLE(VtaCDocu) THEN RELEASE VtaCDocu.
END.
HIDE FRAME F-Proceso.
/* ****************************************************************************************** */
/* ****************************************************************************************** */
DISPLAY 'Descuentos acumulados.....Un momento por favor' @ Fi-Mensaje WITH FRAME F-Proceso.
RUN COT_Genera-COT-por-PET-DCTOS (INPUT cRowid,
                                  INPUT pCodDiv,
                                  OUTPUT pMensaje).
/*IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.*/
IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
    /* Solo mostramos el mensaje de error pero continuamos con el proceso */
    MESSAGE pMensaje VIEW-AS ALERT-BOX WARNING.
    pMensaje = "".
END.
HIDE FRAME F-Proceso.
/* ****************************************************************************************** */
/* ****************************************************************************************** */
RETURN 'OK'.

END PROCEDURE.

PROCEDURE COT_Genera-COT-por-PET-DCTOS:
/* *********************************** */

DEF INPUT PARAMETER pRowid AS ROWID.
DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR  I-NroItm AS INTE NO-UNDO.

DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    FIND Faccpedi WHERE ROWID(Faccpedi) = pRowid EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    /* Un error que no debería pasar */
    IF ERROR-STATUS:ERROR = YES THEN DO:
        pMensaje = "NO se ha podido calcular los descuentos acumulados" + CHR(10) +
            "Regrabar el Pedido".
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* ************************************************************************************** */
    /* DESCUENTOS APLICADOS A TODA LA COTIZACION */
    /* ************************************************************************************** */
    RUN EVEN_DESCUENTOS-FINALES (INPUT pCodDiv, OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = 'ERROR al aplicar los descuentos totales a la cotización'.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* ************************************************************************************** */
    /* RHC 02/01/2020 Promociones proyectadas */
    /* ************************************************************************************** */
    RUN EVEN_BONIFICACION (OUTPUT pMensaje).
    /* ************************************************************************************** */
    /* ************************************************************************************** */
    {vtagn/totales-cotizacion-unificada.i &Cabecera="FacCPedi" &Detalle="FacDPedi"}
    /* ****************************************************************************************** */
    /* Importes SUNAT */
    /* NO actualiza campos Progress */
    /* ****************************************************************************************** */
    DEF VAR hProcSunat AS HANDLE NO-UNDO.

    RUN sunat/sunat-calculo-importes PERSISTENT SET hProcSunat.
    RUN tabla-faccpedi IN hProcSunat (INPUT Faccpedi.CodDiv,
                                      INPUT Faccpedi.CodDoc,
                                      INPUT Faccpedi.NroPed,
                                      OUTPUT pMensaje).
    IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
    DELETE PROCEDURE hProcSunat.
    /* ****************************************************************************************** */
    /* ************************************************************************************** */
    /* ************************************************************************************** */
    /* Renumeramos items */
    I-NroItm = 1.
    FOR EACH Facdpedi OF Faccpedi EXCLUSIVE-LOCK BY Facdpedi.nroitm:
        ASSIGN
            Facdpedi.NroItm = I-NroItm.
        I-NroItm = I-NroItm + 1.
    END.
    IF AVAILABLE(FacCPedi) THEN RELEASE FacCPedi.
END.
RETURN 'OK'.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-COT_Genera-COT-SUNAT) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE COT_Genera-COT-SUNAT Procedure 
PROCEDURE COT_Genera-COT-SUNAT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER pCodCli AS CHAR.
DEF INPUT PARAMETER pCodVen AS CHAR.
DEF OUTPUT PARAMETER pNroPed AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

FIND gn-clie WHERE gn-clie.codcia = cl-codcia
    AND gn-clie.codcli = pCodCli NO-LOCK NO-ERROR.
FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = pCodDiv NO-LOCK NO-ERROR.

DEF VAR s-DiasVtoCot AS INTE NO-UNDO.
DEF VAR s-MinimoDiasDespacho AS INTE NO-UNDO.

ASSIGN
    s-DiasVtoCot = GN-DIVI.DiasVtoCot
    s-MinimoDiasDespacho = GN-DIVI.Campo-Dec[3]
    .
ASSIGN
    s-CodCli = pCodCli
    s-CodVen = pCodVen.

DEF VAR I-nroItm AS INTE NO-UNDO.

/* Hay que cargar lo digitado por terceros en el pre-pedido original */
MESSAGE 'voy por aquí'.
PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    /* Cargamos Digitados Propios (PET) */
    EMPTY TEMP-TABLE ITEM.
    I-NroItm = 1.
    FIND FIRST Vtacdocu WHERE VtaCDocu.CodCia = s-CodCia
        AND VtaCDocu.CodDiv = s-CodDiv
        AND VtaCDocu.CodPed = "PET"
        AND VtaCDocu.CodCli = pCodCli
        AND VtaCDocu.Libre_c05 = "*"
        AND VtaCDocu.FlgEst <> "A"
        AND VtaCDocu.FlgSit <> 'T'
        AND VtaCDocu.FchPed >= (TODAY - 7)
        NO-LOCK NO-ERROR.
    IF AVAILABLE VtaCDocu THEN DO:
        FIND CURRENT VtaCDocu EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &MensajeError="pMensaje"}
             RETURN 'ADM-ERROR'.
        END.
        FOR EACH Vtaddocu OF Vtacdocu NO-LOCK BY Vtaddocu.NroItm:
            FIND FIRST ITEM WHERE ITEM.codmat = Vtaddocu.codmat NO-LOCK NO-ERROR.
                        IF AVAILABLE ITEM THEN NEXT.
            CREATE ITEM.
            BUFFER-COPY Vtaddocu 
                TO ITEM 
                ASSIGN ITEM.NroItm = I-NroItm.
            I-NroItm = I-NroItm + 1.
        END.
        ASSIGN
            VtaCDocu.FlgSit = "T".
    END.
    /* Cargamos digitados Tercero (PPT): Solo los que tienen una cantidad digitada */
    FOR EACH b-Vtacdocu EXCLUSIVE-LOCK WHERE b-Vtacdocu.codcia = s-CodCia
            AND b-Vtacdocu.codped = "PPT"
            AND b-Vtacdocu.coddiv = s-CodDiv
            AND b-Vtacdocu.flgest = "P"
            AND b-Vtacdocu.codcli = pCodCli
            /*AND b-Vtacdocu.libre_c05 = "*"*/
            AND b-Vtacdocu.fchven >= TODAY:
        FOR EACH b-Vtaddocu OF b-Vtacdocu NO-LOCK WHERE b-Vtaddocu.CanPed > 0
            BY b-Vtaddocu.NroItm:
            FIND FIRST ITEM WHERE ITEM.codmat = b-Vtaddocu.codmat NO-LOCK NO-ERROR.
            IF AVAILABLE ITEM THEN NEXT.
            CREATE ITEM.
            BUFFER-COPY b-Vtaddocu EXCEPT b-Vtaddocu.libre_c01 b-Vtaddocu.libre_c02 b-Vtaddocu.libre_c03
                b-Vtaddocu.libre_c04 b-Vtaddocu.libre_d01 b-Vtaddocu.libre_d02
                TO ITEM 
                ASSIGN ITEM.NroItm = I-NroItm.
            /* Cargamos también al pre-pedido original */
            IF AVAILABLE VtaCDocu THEN DO:
                CREATE Vtaddocu.
                BUFFER-COPY b-Vtaddocu TO Vtaddocu
                    ASSIGN
                    VtaDDocu.CodDiv = Vtacdocu.coddiv
                    VtaDDocu.CodPed = Vtacdocu.codped
                    VtaDDocu.NroPed = Vtacdocu.nroped
                    VtaDDocu.FchPed = VTacdocu.fchped
                    VtaDDocu.NroItm = I-nroItm.
            END.
            I-NroItm = I-NroItm + 1.
        END.
        ASSIGN
            b-VtaCDocu.FchAprobacion = TODAY
            b-VtaCDocu.FlgEst = "C"     /* Marcamos */
            b-Vtacdocu.libre_c05 = "*"
            b-VtaCDocu.UsrAprobacion = s-user-id.
        /* Como solo hay 1 se sale del loop */
        LEAVE.
    END.
    IF NOT CAN-FIND(FIRST ITEM NO-LOCK) THEN DO:
        pMensaje = "NO hay items registrados".
        RETURN 'ADM-ERROR'.
    END.
    FOR EACH ITEM:
        CREATE T-CONTROL.
        BUFFER-COPY ITEM TO T-CONTROL.
    END.

    /* ************************************************************************************* */
    {vta2/icorrelativosecuencial.i &Codigo = s-coddoc &Serie = s-nroser}
    /* ************************************************************************************* */
    CREATE Faccpedi.
    IF AVAILABLE VtaCDocu THEN DO:
        BUFFER-COPY Vtacdocu 
            EXCEPT VtaCDocu.Libre_C02 VtaCDocu.Libre_C03 Vtacdocu.Libre_c05
            TO Faccpedi
            ASSIGN 
            FacCPedi.CodDoc = s-coddoc 
            FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
            FacCPedi.Atencion = VtaCDocu.DniCli
            FacCPedi.Libre_C02 = VtaCDocu.Libre_C03    /* Última atención */
            .
        s-FmaPgo = FacCpedi.FmaPgo.
    END.
    ELSE DO:
        ASSIGN 
            FacCPedi.CodCia = s-CodCia
            FacCPedi.CodDiv = s-CodDiv
            FacCPedi.CodDoc = s-coddoc 
            FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
            .
        RUN vtagn/p-fmapgo-valido.r (s-codcli, s-tpoped, pCodDiv, OUTPUT s-cndvta-validos).
        s-FmaPgo = ENTRY(1, s-cndvta-validos).
        ASSIGN
            FacCPedi.FchVen = (TODAY + s-DiasVtoCot)
            FacCPedi.FchEnt = (TODAY + s-MinimoDiasDespacho)
            FacCPedi.CodCli = s-CodCli
            Faccpedi.NomCli = gn-clie.NomCli
            Faccpedi.RucCli = gn-clie.Ruc 
            Faccpedi.DirCli = gn-clie.DirCli
            FacCPedi.FmaPgo = s-FmaPgo
            .
        FIND gn-clied WHERE gn-clied.codcia = cl-codcia
            AND gn-clied.codcli = s-codcli
            AND gn-clied.sede = Faccpedi.sede
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clied THEN DO:
            FacCPedi.Glosa = Gn-ClieD.DirCli.
            FacCPedi.CodPos = Gn-ClieD.Codpos.
        END.
          IF TRUE <> (FacCPedi.RucCli > '') THEN Faccpedi.Cmpbnte = 'BOL'.
          ELSE Faccpedi.Cmpbnte = 'FAC'.
        ASSIGN
            FacCPedi.CodMon = 1
            FacCPedi.FlgIgv = YES
            FacCPedi.Libre_d01 = s-NroDec.
    END.
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    ASSIGN
        FacCPedi.TpoPed = s-TpoPed
        FacCPedi.FchPed = TODAY 
        FacCPedi.FlgEst = "PV"     /* APROBADO */
        FacCPedi.Hora = STRING(TIME,"HH:MM:SS")
        FacCPedi.Usuario = S-USER-ID
        FacCPedi.Libre_c01 = pCodDiv    /* Lista de Precios */
        FacCPedi.Sede = "@@@"
        FacCPedi.CodVen = s-CodVen
        .
    ASSIGN
        pNroPed = FacCPedi.NroPed.
    /* ************************************************************************************* */
    /* Recalculamos Precios de Venta */
    /* OJO: es la versión de precios antes de terminar el módulo de Pricing 2021 */
    /* ************************************************************************************* */
    {web/recalcular-cotizacion-unificada.i &pTpoPed=s-TpoPed}
    /* NOTA: Si un producto NO tiene precio entonces se aborta la grabación */
    FOR EACH T-CONTROL:
        IF NOT CAN-FIND(FIRST ITEM WHERE ITEM.codmat = T-CONTROL.codmat NO-LOCK) THEN DO:
            pMensaje = "Se han detectado productos sin precio peldaño bruot" + CHR(10) +
                "Proceso abortado" + CHR(10) + CHR(10) +
                pMensaje.
            UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
        END.
    END.
    /* ************************************************************************************* */
    /* Generamos Detalle */
    /* ************************************************************************************* */
    FOR EACH ITEM NO-LOCK, FIRST Almmmatg OF ITEM NO-LOCK:
        CREATE Facdpedi.
        BUFFER-COPY ITEM TO Facdpedi
            ASSIGN
                FacDPedi.CodCia = FacCPedi.CodCia
                FacDPedi.CodDiv = FacCPedi.CodDiv
                FacDPedi.coddoc = FacCPedi.coddoc
                FacDPedi.NroPed = FacCPedi.NroPed
                FacDPedi.FchPed = FacCPedi.FchPed
                FacDPedi.Hora   = FacCPedi.Hora 
                FacDPedi.FlgEst = FacCPedi.FlgEst.
    END.
    /* ************************************************************************************** */
    /* DESCUENTOS APLICADOS A TODA LA COTIZACION */
    /* ************************************************************************************** */
    RUN EVEN_DESCUENTOS-FINALES (INPUT pCodDiv, OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = 'ERROR al aplicar los descuentos totales a la cotización'.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* ************************************************************************************** */
    /* RHC 02/01/2020 Promociones proyectadas */
    /* ************************************************************************************** */
    RUN EVEN_BONIFICACION (OUTPUT pMensaje).
    /* ****************************************************************************************** */
    /* ****************************************************************************************** */
    {vtagn/totales-cotizacion-sunat.i &Cabecera="FacCPedi" &Detalle="FacDPedi"}
    /* ****************************************************************************************** */
    /* Importes SUNAT */
    /* ****************************************************************************************** */
    DEF VAR hProcSunat AS HANDLE NO-UNDO.
    RUN sunat/sunat-calculo-importes PERSISTENT SET hProcSunat.
    RUN tabla-faccpedi IN hProcSunat (INPUT Faccpedi.CodDiv,
                                      INPUT Faccpedi.CodDoc,
                                      INPUT Faccpedi.NroPed,
                                      OUTPUT pMensaje).
    IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
    DELETE PROCEDURE hProcSunat.
    /* ****************************************************************************************** */
    /* ****************************************************************************************** */
    /* Renumeramos items */
    I-NroItm = 1.
    FOR EACH Facdpedi OF Faccpedi BY Facdpedi.nroitm:
        ASSIGN
            Facdpedi.NroItm = I-NroItm.
        I-NroItm = I-NroItm + 1.
    END.
    /* Referencias cruzadas */
    IF AVAILABLE VtaCDocu THEN
        ASSIGN
            FacCPedi.CodRef = VtaCDocu.CodPed
            FacCPedi.NroRef = VtaCDocu.NroPed
            VtaCDocu.CodRef = FacCPedi.CodDoc
            VtaCDocu.NroRef = FacCPedi.NroPed
            Vtacdocu.FlgSit = "T".
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-EVEN_BONIFICACION) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE EVEN_BONIFICACION Procedure 
PROCEDURE EVEN_BONIFICACION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

    /* ************************************************************************************** */
    /* RHC 02/01/2020 Promociones proyectadas */
    /* ************************************************************************************** */
    DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.
    EMPTY TEMP-TABLE ITEM.
    FOR EACH Facdpedi OF Faccpedi NO-LOCK:
        CREATE ITEM.
        BUFFER-COPY Facdpedi TO ITEM.
    END.
    RUN vtagn/p-promocion-general (INPUT Faccpedi.CodDiv,
                                   INPUT Faccpedi.CodDoc,
                                   INPUT Faccpedi.NroPed,
                                   INPUT TABLE ITEM,
                                   OUTPUT TABLE BONIFICACION,
                                   OUTPUT pMensaje).
    IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".
    I-NITEM = 0.
    FOR EACH BONIFICACION,
        FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia AND 
        Almmmatg.codmat = BONIFICACION.codmat
        BY BONIFICACION.NroItm:
        I-NITEM = I-NITEM + 1.
        CREATE FacDPedi.
        BUFFER-COPY BONIFICACION
            TO FacDPedi
            ASSIGN
                FacDPedi.CodCia = FacCPedi.CodCia
                FacDPedi.CodDiv = FacCPedi.CodDiv
                FacDPedi.coddoc = "CBO"   /* Bonificacion en COT */
                FacDPedi.NroPed = FacCPedi.NroPed
                FacDPedi.FchPed = FacCPedi.FchPed
                FacDPedi.Hora   = FacCPedi.Hora 
                FacDPedi.FlgEst = FacCPedi.FlgEst
                FacDPedi.NroItm = I-NITEM.
    END.
    /* ****************************************************************************************** */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-EVEN_DESCUENTOS-FINALES) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE EVEN_DESCUENTOS-FINALES Procedure 
PROCEDURE EVEN_DESCUENTOS-FINALES :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF INPUT PARAMETER pCodDiv AS CHAR NO-UNDO.
  DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

  /* ************************************************************************************** */
  /* DESCUENTOS APLICADOS A TODA LA COTIZACION */
  /* ************************************************************************************** */
  DEF VAR hProc AS HANDLE NO-UNDO.
  RUN vtagn/ventas-library PERSISTENT SET hProc.
  RUN DCTO_VOL_LINEA IN hProc (INPUT ROWID(Faccpedi),
                               INPUT s-TpoPed,
                               INPUT pCodDiv,
                               OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  RUN DCTO_VOL_SALDO IN hProc (INPUT ROWID(Faccpedi),
                               INPUT s-TpoPed,
                               INPUT pCodDiv,
                               OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  RUN DCTO_VOL_SALDO_EVENTO IN hProc (INPUT ROWID(Faccpedi),
                                      INPUT s-TpoPed,
                                      INPUT pCodDiv,
                                      OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  /* 06/01/2024: Actualizando con los nuevos descuentos */
/*   RUN DCTO_PRONTO_DESPACHO IN hProc (INPUT ROWID(Faccpedi),    */
/*                                      INPUT pCodDiv,            */
/*                                      OUTPUT pMensaje).         */
/*   IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'. */

  RUN DCTO_IMP_ACUM IN hProc (INPUT ROWID(Faccpedi),
                              INPUT pCodDiv,
                              OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  /* 16-9-23: Este descuento va por encima de todos los anteriores C.Camus */
  RUN DCTO_VOL_ACUM_TIME IN hProc (INPUT ROWID(Faccpedi),
                                   INPUT pCodDiv,
                                   INPUT Faccpedi.CodCli,
                                   OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  
  DELETE PROCEDURE hProc.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PET_Genera-COT) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PET_Genera-COT Procedure 
PROCEDURE PET_Genera-COT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowid AS ROWID.
DEF INPUT PARAMETER pCodDiv AS CHAR.        /* Lista de Precios */
DEF OUTPUT PARAMETER pNroPed AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

FIND Vtacdocu WHERE ROWID(Vtacdocu) = pRowid NO-LOCK NO-ERROR  NO-WAIT.
IF NOT AVAILABLE Vtacdocu THEN DO:
    pMensaje = 'No se encontró la pre-cotización'.
    RETURN "ADM-ERROR".
END.

DEFINE VAR s-user-id AS CHAR INIT 'VTA-15'.

/* Por Lista de Precios */
CASE pCodDiv:
    WHEN '10072' THEN s-user-id = 'VTA-172'.
    WHEN '20067' OR WHEN '10067' THEN s-user-id = 'VTA-167'.
    WHEN '10060' OR WHEN '20060' THEN s-user-id = 'VTA-160'.
END CASE.
/* Por Lista de Precios y División */
CASE TRUE:
    WHEN pCodDiv = "10000" THEN DO:
        CASE s-CodDiv.
            WHEN "10011" THEN s-user-id = "VTA-111".
            WHEN "10031" THEN s-user-id = "VTA-131".
            WHEN "10032" THEN s-user-id = "VTA-132".
            WHEN "10038" THEN s-user-id = "VTA-138".
            WHEN "10039" THEN s-user-id = "VTA-139".
            WHEN "10041" THEN s-user-id = "VTA-141".
        END CASE.
    END.
END CASE.

ASSIGN
    s-CodCli = Vtacdocu.codcli
    s-CndVta = Vtacdocu.fmapgo
    s-Cmpbnte = Vtacdocu.cmpbnte.

EMPTY TEMP-TABLE ITEM.
EMPTY TEMP-TABLE T-CONTROL.

EMPTY TEMP-TABLE ITEM-1.
EMPTY TEMP-TABLE PEDI.

DEFINE VARIABLE I-NroItm AS INTEGER INIT 1 NO-UNDO.

/* Hay que cargar lo digitado por terceros en el pre-pedido original */
PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    /* Bloqueamos el pre-pedido */
    FIND CURRENT Vtacdocu EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Vtacdocu THEN DO:
        pMensaje = "No se pudo bloquear la pre-cotización".
        RETURN "ADM-ERROR".
    END.
    /* Cargamos Digitados Propios (PET) */
    I-NroItm = 1.
    FOR EACH Vtaddocu OF Vtacdocu NO-LOCK BY Vtaddocu.NroItm:
        FIND FIRST ITEM WHERE ITEM.codmat = Vtaddocu.codmat NO-LOCK NO-ERROR.
        IF AVAILABLE ITEM THEN NEXT.
        CREATE ITEM.
        BUFFER-COPY Vtaddocu 
            TO ITEM 
            ASSIGN ITEM.NroItm = I-NroItm.
        I-NroItm = I-NroItm + 1.
    END.
    /* Cargamos digitados Tercero (PPT): Solo los que tienen una cantidad digitada */
    FOR EACH b-Vtacdocu EXCLUSIVE-LOCK WHERE b-Vtacdocu.codcia = Vtacdocu.codcia
            AND b-Vtacdocu.codped = "PPT"
            AND b-Vtacdocu.coddiv = Vtacdocu.coddiv
            AND b-Vtacdocu.flgest = "P"
            AND b-Vtacdocu.codcli = Vtacdocu.codcli
            /*AND b-Vtacdocu.libre_c05 = "*"*/
            AND b-Vtacdocu.fchven >= TODAY:
        FOR EACH b-Vtaddocu OF b-Vtacdocu NO-LOCK WHERE b-Vtaddocu.CanPed > 0
            BY b-Vtaddocu.NroItm:
            FIND FIRST ITEM WHERE ITEM.codmat = b-Vtaddocu.codmat NO-LOCK NO-ERROR.
            IF AVAILABLE ITEM THEN NEXT.
            CREATE ITEM.
            BUFFER-COPY b-Vtaddocu EXCEPT b-Vtaddocu.libre_c01 b-Vtaddocu.libre_c02 b-Vtaddocu.libre_c03
                b-Vtaddocu.libre_c04 b-Vtaddocu.libre_d01 b-Vtaddocu.libre_d02
                TO ITEM 
                ASSIGN ITEM.NroItm = I-NroItm.
            /* Cargamos también al pre-pedido original */
            CREATE Vtaddocu.
            BUFFER-COPY b-Vtaddocu TO Vtaddocu
                ASSIGN
                VtaDDocu.CodDiv = Vtacdocu.coddiv
                VtaDDocu.CodPed = Vtacdocu.codped
                VtaDDocu.NroPed = Vtacdocu.nroped
                VtaDDocu.FchPed = VTacdocu.fchped
                VtaDDocu.NroItm = I-nroItm.
            I-NroItm = I-NroItm + 1.
        END.
        ASSIGN
            b-VtaCDocu.FchAprobacion = TODAY
            b-VtaCDocu.FlgEst = "C"     /* Marcamos */
            b-Vtacdocu.libre_c05 = "*"
            b-VtaCDocu.UsrAprobacion = s-user-id.
        /* Como solo hay 1 se sale del loop */
        LEAVE.
    END.
    FOR EACH ITEM:
        CREATE T-CONTROL.
        BUFFER-COPY ITEM TO T-CONTROL.
    END.

    {vta2/icorrelativosecuencial.i &Codigo = s-coddoc &Serie = s-nroser}

    CREATE Faccpedi.
    BUFFER-COPY Vtacdocu 
        EXCEPT VtaCDocu.Libre_C02 VtaCDocu.Libre_C03 Vtacdocu.Libre_c05
        TO Faccpedi
        ASSIGN 
        FacCPedi.CodDoc = s-coddoc 
        FacCPedi.FchPed = TODAY 
        FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
        FacCPedi.TpoPed = VtaCDocu.Libre_c02
        FacCPedi.Atencion = VtaCDocu.DniCli
        FacCPedi.FlgEst = "PV"     /* APROBADO */
        FacCPedi.Libre_C02 = VtaCDocu.Libre_C03.    /* Última atención */
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    ASSIGN
        pNroPed  = FacCPedi.NroPed
        s-TpoPed = FacCPedi.TpoPed
        s-CodMon = FacCPedi.CodMon
        s-NroDec = FacCPedi.Libre_d01
        s-TpoCmb = FacCPedi.TpoCmb
        s-PorIgv = FacCPedi.PorIgv
        s-FmaPgo = FacCPedi.FmaPgo.
    ASSIGN 
        FacCPedi.Hora = STRING(TIME,"HH:MM:SS")
        FacCPedi.Usuario = S-USER-ID
        FacCPedi.Libre_c01 = VtaCDocu.Libre_c01.    /* Lista de Precios */
    /* Recalculamos Precios de Venta */
    /* OJO: es la versión de precios antes de terminar el módulo de Pricing 2021 */
    {vtagn/recalcular-cotizacion-unificada.i &pTpoPed=s-TpoPed}
    /* NOTA: Si un producto NO tiene precio entonces se aborta la grabación */
    FOR EACH T-CONTROL:
        IF NOT CAN-FIND(FIRST ITEM WHERE ITEM.codmat = T-CONTROL.codmat NO-LOCK) THEN DO:
            pMensaje = "Se han detectado productos sin precio peldaño bruto" + CHR(10) +
                "Proceso abortado" + CHR(10) + CHR(10) +
                pMensaje.
            UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
        END.
    END.
    /* Generamos Detalle */
    FOR EACH ITEM NO-LOCK, FIRST Almmmatg OF ITEM NO-LOCK:
        CREATE Facdpedi.
        BUFFER-COPY ITEM TO Facdpedi
            ASSIGN
                FacDPedi.CodCia = FacCPedi.CodCia
                FacDPedi.CodDiv = FacCPedi.CodDiv
                FacDPedi.coddoc = FacCPedi.coddoc
                FacDPedi.NroPed = FacCPedi.NroPed
                FacDPedi.FchPed = FacCPedi.FchPed
                FacDPedi.Hora   = FacCPedi.Hora 
                FacDPedi.FlgEst = FacCPedi.FlgEst.
    END.
    /* ************************************************************************************** */
    /* DESCUENTOS APLICADOS A TODA LA COTIZACION */
    /* ************************************************************************************** */
    RUN EVEN_DESCUENTOS-FINALES (INPUT pCodDiv, OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = 'ERROR al aplicar los descuentos totales a la cotización'.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* ************************************************************************************** */
    /* RHC 02/01/2020 Promociones proyectadas */
    /* ************************************************************************************** */
    RUN EVEN_BONIFICACION (OUTPUT pMensaje).
    /* ************************************************************************************** */
    /* ************************************************************************************** */
    {vtagn/totales-cotizacion-unificada.i &Cabecera="FacCPedi" &Detalle="FacDPedi"}
    /* ****************************************************************************************** */
    /* Renumeramos items */
    I-NroItm = 1.
    FOR EACH Facdpedi OF Faccpedi BY Facdpedi.nroitm:
        ASSIGN
            Facdpedi.NroItm = I-NroItm.
        I-NroItm = I-NroItm + 1.
    END.
    /* Referencias cruzadas */
    ASSIGN
        VtaCDocu.CodRef = FacCPedi.CodDoc
        VtaCDocu.NroRef = FacCPedi.NroPed
        FacCPedi.CodRef = VtaCDocu.CodPed
        FacCPedi.NroRef = VtaCDocu.NroPed
        Vtacdocu.FlgSit = "T".
END.
RELEASE Vtacdocu.
RELEASE FacCorre.
RELEASE Faccpedi.
RELEASE Facdpedi.

RETURN "OK".



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

