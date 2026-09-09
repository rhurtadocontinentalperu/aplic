&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
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

/* PARAMETROSSSSSSSSSSSSSSSS */
DEF INPUT PARAMETER pCodDoc AS CHAR.    /* COT */
DEF INPUT PARAMETER pNroDoc AS CHAR.
DEF OUTPUT PARAMETER pNewCodDoc AS CHAR.
DEF OUTPUT PARAMETER pNewNroDoc AS CHAR.
DEF OUTPUT PARAMETER pRetval AS CHAR NO-UNDO.

/*
s-TpoPed = "CR".    /* Valor por defecto */
IF pParametro > '' THEN s-TpoPed = ENTRY(1, pParametro).
s-TpoPed2 = ''.
IF NUM-ENTRIES(pParametro) > 2 THEN DO:
    s-TpoPed2 = ENTRY(2, pParametro).  /* ValesUtilex */
END.
*/

DEFINE NEW SHARED VARIABLE s-coddoc   AS CHAR INITIAL "PED".
DEFINE NEW SHARED VARIABLE s-codref   AS CHAR INITIAL "COT".
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE NEW SHARED VARIABLE S-CODCLI   AS CHAR.
DEFINE NEW SHARED VARIABLE S-CODMON   AS INTEGER INITIAL 1.
DEFINE NEW SHARED VARIABLE S-TPOCMB AS DECIMAL.  
DEFINE NEW SHARED VARIABLE S-NROTAR   AS CHAR. 
DEFINE NEW SHARED VARIABLE S-NROPED   AS CHAR.
DEFINE NEW SHARED VARIABLE s-NroSer AS INTEGER.
DEFINE NEW SHARED VARIABLE S-NROCOT   AS CHARACTER.
DEFINE NEW SHARED VARIABLE s-PorIgv LIKE Ccbcdocu.PorIgv.
DEFINE NEW SHARED VARIABLE s-FlgSit AS CHAR.
DEFINE NEW SHARED VARIABLE s-FlgIgv LIKE Faccpedi.FlgIgv.
DEFINE NEW SHARED VARIABLE s-FlgMinVenta LIKE GN-DIVI.FlgMinVenta.
DEFINE NEW SHARED VARIABLE s-TpoPed AS CHAR.
DEFINE NEW SHARED VARIABLE s-TpoPed2 AS CHAR.
DEFINE NEW SHARED VARIABLE s-FmaPgo AS CHAR.
DEFINE NEW SHARED VARIABLE s-NroDec AS INT INIT 4.
DEFINE NEW SHARED VARIABLE s-Tipo-Abastecimiento AS CHAR INIT "NORMAL".
DEFINE NEW SHARED VARIABLE pv-codcia AS INT.

DEFINE NEW SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE NEW SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE NEW SHARED VARIABLE S-CODVEN   AS CHAR.
DEFINE NEW SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE NEW SHARED VARIABLE CL-CODCIA  AS INTEGER.
DEF NEW SHARED VAR s-adm-new-record AS CHAR INIT "NO".

S-CODCIA = 1.
CL-CODCIA = 0.
pv-codcia = 0.

/* PARAMETROS DE PEDIDOS PARA LA DIVISION */
DEF NEW SHARED VAR s-FlgEmpaque LIKE GN-DIVI.FlgEmpaque.
DEF NEW SHARED VAR s-DiasVtoPed LIKE GN-DIVI.DiasVtoPed.
DEF NEW SHARED VAR s-VentaMayorista LIKE GN-DIVI.VentaMayorista.
DEF NEW SHARED VAR s-CodAlm AS CHAR. /* NOTA: Puede contener mas de un almacen */

DEFINE BUFFER COTIZACION FOR faccpedi.
DEFINE BUFFER COTIZACIONDTL FOR facdpedi.
DEFINE BUFFER PCO FOR faccpedi.
DEFINE BUFFER PEDIDO FOR faccpedi.
DEFINE BUFFER ORDEN FOR faccpedi.
DEFINE BUFFER B-CPEDI FOR Faccpedi.
DEFINE BUFFER x-facdpedi FOR Facdpedi.

/* 07.09.09 Variable para el Tracking */
DEFINE VAR s-FechaHora AS CHAR.
DEFINE VAR s-FechaI AS DATETIME NO-UNDO.
DEFINE VAR s-FechaT AS DATETIME NO-UNDO.

DEFINE VARIABLE T-SALDO     AS DECIMAL.
DEFINE VARIABLE F-totdias   AS INTEGER NO-UNDO.
DEFINE VARIABLE s-FlgEnv AS LOG NO-UNDO.

/* CONTROL DE NUMERO DE PCO SELECCIONADA */
DEF VAR xNroPCO AS CHAR NO-UNDO.
DEF VAR pFchEnt AS DATE.

/*  */
DEFINE TEMP-TABLE PEDI LIKE facdpedi.
DEFINE TEMP-TABLE PEDI-2 LIKE facdpedi.
DEFINE TEMP-TABLE PEDI-3 LIKE facdpedi.
DEFINE TEMP-TABLE REPORTE LIKE facdpedi.
DEFINE TEMP-TABLE t-facdpedi LIKE facdpedi.

/* OJO: Variable forzada ya que no funcion en el valida */
DEF VAR s-TpoLic LIKE Faccpedi.TpoLic NO-UNDO.

/* Articulo impuesto a la bolsas plasticas */
DEFINE VAR x-articulo-ICBPER AS CHAR.

x-articulo-ICBPER = "099268".

&SCOPED-DEFINE ARITMETICA-SUNAT YES
&SCOPED-DEFINE Promocion web/promocion-general-flash.r

DEFINE VAR grabarmsgLog AS LOG.
grabarmsgLog = YES.

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

pRetval = "".

s-TpoLic = NO. 

FIND FIRST COTIZACION WHERE COTIZACION.codcia = 1 AND COTIZACION.coddoc = pCodDoc AND
                        COTIZACION.nroped = pNroDoc NO-LOCK NO-ERROR.
IF NOT AVAILABLE COTIZACION THEN DO:
    pREtVal = 'Pedido comercial ' + pCodDoc + " " + pNroDoc + ' NO existe'.
    RETURN "ADM-ERROR".
END.
IF COTIZACION.flgest <> 'P' THEN DO:
    pREtVal = 'Pedido comercial ' + pCodDoc + " " + pNroDoc + " debe tener el estado 'P', estado actual es " + COTIZACION.flgest.
    RETURN "ADM-ERROR".
END.
/* Ic - 29Ene2016 ValesUtilex */
IF s-tpoped2 = 'VU' AND COTIZACION.tpoped <> 'VU'  THEN DO:
  pRetval =  'Cotización NO pertenece a VALES de UTILEX' + CHR(10) + 
      'Proceso abortado'.
  RETURN "ADM-ERROR".
END.

/**/
S-USER-ID = COTIZACION.usuario.
S-CODVEN = COTIZACION.codven.
S-CODDIV = COTIZACION.coddiv.
S-CODMON = COTIZACION.codmon.
s-codcli = COTIZACION.codcli.
s-CodRef = COTIZACION.coddoc.
s-NroCot = COTIZACION.NroPed.
s-FmaPgo = COTIZACION.fmapgo.

IF grabarmsgLog=YES THEN RUN lib/p-write-log-txt.r("Genera pedido logistico", 'Pedido comercial : ' + pCodDoc + ' ' + pNroDoc ).
IF grabarmsgLog=YES THEN RUN lib/p-write-log-txt.r("Genera pedido logistico", 'Pedido comercial : ' + pCodDoc + ' ' + pNroDoc + ' => validaciones').

RUN validaciones(OUTPUT pRetVal).
IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

/*
RUN verifica-cliente(OUTPUT pRetVal).
IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
.*/
/* ---------------------------------------------------------------------------------- */
FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

ASSIGN 
  s-FechaHora = '' 
  s-FechaI = DATETIME(TODAY, MTIME)
  s-FechaT = ?
  s-PorIgv = FacCfgGn.PorIgv
  s-FlgEnv = YES.
ASSIGN
  xNroPCO = ''
  s-NroCot = ''
  pFchEnt = TODAY.


FIND FIRST FacCorre WHERE FacCorre.CodCia = s-CodCia AND
                            FacCorre.CodDoc = s-CodDoc AND
                            FacCorre.CodDiv = s-CodDiv NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
    pREtVal = 'No esta configurado el correlativo para División ' + s-coddiv + ' tipo documento ' + s-coddoc.
    RETURN "ADM-ERROR".
END.

s-NroSer = FacCorre.NroSer.

/* RHC 31/01/2018 Valores por defecto pero dependen de la COTIZACION */
FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = s-coddiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN DO:
    pREtVal = 'División ' + s-coddiv + ' NO configurad'.
    RETURN "ADM-ERROR".
END.
ASSIGN
    s-DiasVtoPed = GN-DIVI.DiasVtoPed
    s-FlgEmpaque = GN-DIVI.FlgEmpaque
    s-VentaMayorista = GN-DIVI.VentaMayorista.

/* ********************************************* */
/* Determinamos hasta 5 almacenes para despachar */
/* RHC 31/01/2018 PARAMETROS DE ACUERDO A LA COTIZACION */
/* **************************************************** */
DEF BUFFER B-DIVI FOR gn-divi.
DEF VAR x-Lista_de_Precios AS CHAR NO-UNDO.     /* Por compatibilidad */

IF TRUE <> (COTIZACION.Lista_de_Precios > '') 
    THEN x-Lista_de_Precios = COTIZACION.Libre_c01.
    ELSE x-Lista_de_Precios = COTIZACION.Lista_de_Precios.
FIND FIRST B-DIVI WHERE B-DIVI.codcia = s-codcia AND B-DIVI.coddiv = x-Lista_de_Precios NO-LOCK NO-ERROR.
IF AVAILABLE B-DIVI THEN DO:
    ASSIGN
        s-DiasVtoPed = B-DIVI.DiasVtoPed
        s-FlgEmpaque = B-DIVI.FlgEmpaque
        s-VentaMayorista = B-DIVI.VentaMayorista.
END.

IF grabarmsgLog=YES THEN RUN lib/p-write-log-txt.r("Genera pedido logistico", 'Pedido comercial : ' + pCodDoc + ' ' + pNroDoc + ' => vtagn/ventas-library.r - PED_Add_Record_riqra').

/* Triggers */
DISABLE TRIGGERS FOR LOAD OF faccorre.
DISABLE TRIGGERS FOR LOAD OF vtactrkped.
DISABLE TRIGGERS FOR LOAD OF vtadtrkped.
DISABLE TRIGGERS FOR LOAD OF vtaddocu.
DISABLE TRIGGERS FOR LOAD OF vtacdocu.

DEFINE VAR hProc AS HANDLE NO-UNDO.
RUN vtagn/ventas-library.r PERSISTENT SET hProc.
RUN PED_Add_Record_riqra IN hProc (INPUT s-PorIgv,
                                   INPUT pCodDoc,   /* COT */
                                   INPUT pNroDoc,
                           OUTPUT pFchEnt,
                           OUTPUT xNroPCO,
                           OUTPUT s-NroCot,
                           OUTPUT s-CodAlm,
                           OUTPUT s-Tipo-Abastecimiento,
                           OUTPUT TABLE PEDI,
                           OUTPUT pRetVal) NO-ERROR.

IF ERROR-STATUS:ERROR = YES THEN DO:
    pRetVal = 'PED_Add_Record_riqra : ' + CHR(10) + ERROR-STATUS:GET-MESSAGE(1) + CHR(10) + pRetVal .
    RETURN 'ADM-ERROR'.
END.

DELETE PROCEDURE hProc.

IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
    pRetVal = "PED_Add_Record_riqra " + CHR(10) + pRetVal.
   /* pREtVal = 'Problemas al generar Pedido logistico desde el pedid comercial ' + pCodDoc + " " + pNroDoc .*/
    RETURN 'ADM-ERROR'.
END.
 
FIND FIRST PEDI NO-LOCK NO-ERROR.
IF NOT AVAILABLE PEDI THEN DO:
  IF TRUE <> (pRetVal > "") THEN pRetVal = "Por falta de Stock no se pudo crear el pedido logistico".
  pREtVal = pRetVal + CHR(10) + 'PROCESO ABORTADO'.
  RETURN "ADM-ERROR".
END.


    /* *************************************************************************************** */
    /* Verificamos PEDI y lo actualizamos con el stock disponible */
    /* *************************************************************************************** */
    EMPTY TEMP-TABLE PEDI-3.
    FOR EACH PEDI:
        CREATE PEDI-3.
        BUFFER-COPY PEDI TO PEDI-3.
    END.

    IF grabarmsgLog=YES THEN RUN lib/p-write-log-txt.r("Genera pedido logistico", 'Pedido comercial : ' + pCodDoc + ' ' + pNroDoc + ' => VALIDATE-DETAIL').

    SESSION:SET-WAIT-STATE('GENERAL').
    RUN VALIDATE-DETAIL ('YES', OUTPUT pRetVal).    /* YES : CREATE */
    SESSION:SET-WAIT-STATE('').
    
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        RETURN 'ADM-ERROR'.
    END.

/* **************************************************************************************** */
/* RHC 23/05/2019 CONTROL ADICIONAL: GUARDAMOS EL DETALLE Y SALDO DE LA COTIZACION
SI HAY DIFERENCIA AL MOMENTO DE GRABAR ENTONCES NO GRABAMOS NADA */
/* **************************************************************************************** */
EMPTY TEMP-TABLE t-Facdpedi.
FOR EACH Facdpedi OF COTIZACION NO-LOCK WHERE Facdpedi.Libre_c05 <> "OF":
  CREATE t-Facdpedi.
  BUFFER-COPY Facdpedi TO t-Facdpedi.
END.

/* Creo el pedido logistico PED */
RUN crear-pedido-logistico.

IF RETURN-VALUE = "ADM-ERROR" THEN DO:
    RETURN "ADM-ERROR".
END.

RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-crear-pedido-logistico) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE crear-pedido-logistico Procedure 
PROCEDURE crear-pedido-logistico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR cGlosa AS CHAR.
DEFINE VAR iSerie AS INT.
DEFINE VAR iCorrelativo AS INT.

IF grabarmsgLog=YES THEN RUN lib/p-write-log-txt.r("Genera pedido logistico", 'Pedido comercial : ' + pCodDoc + ' ' + pNroDoc + ' => Crear pedido logistico').

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

FIND LAST gn-tccja WHERE Gn-tccja.fecha <= TODAY NO-LOCK NO-ERROR.
IF AVAILABLE gn-tccja THEN DO:
  IF COTIZACION.CodMon = 2 THEN s-TpoCmb = Gn-tccja.venta.
  ELSE s-TpoCmb = Gn-tccja.compra.
END.
ELSE s-TpoCmb = FacCfgGn.TpoCmb[1].

FIND FIRST FacCorre WHERE FacCorre.CodCia = s-CodCia AND
                            FacCorre.CodDoc = s-CodDoc AND
                            FacCorre.CodDiv = s-CodDiv NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
    pREtVal = 'No esta configurado el correlativo para División ' + s-coddiv + ' tipo documento ' + s-coddoc.
    RETURN "ADM-ERROR".
END.

FIND CURRENT FacCorre EXCLUSIVE-LOCK NO-ERROR.
IF LOCKED FacCorre THEN DO:
    pRetVal = "La tabla FacCorre esta bloqueada".
    RETURN "ADM-ERROR".
END.
iSerie = FacCorre.NroSer.
iCorrelativo = FacCorre.Correlativo.
ASSIGN
    FacCorre.Correlativo = FacCorre.Correlativo + 1.
RELEASE FacCorre.       /* OJO */

/* ******************************************************* */
/* RHC 10/09/2020 Sede del Cliente (ej. caso B2B div 00519 */
/* ******************************************************* */
DEF VAR pSede AS CHAR NO-UNDO.
RUN Sede-Cliente (OUTPUT pSede, OUTPUT pREtVal).
IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
    RETURN "ADM-ERROR".
END.

/* Cargamos el temporal con todos los items de todos los almacenes */
FOR EACH PEDI WHERE PEDI.CanPed <= 0:
    DELETE PEDI.
END.
EMPTY TEMP-TABLE PEDI-2.
FOR EACH PEDI:
    CREATE PEDI-2.
    BUFFER-COPY PEDI TO PEDI-2.
END.

pREtVal = "Procesando el Grabado de pedido".

IF grabarmsgLog=YES THEN RUN lib/p-write-log-txt.r("Genera pedido logistico", 'Pedido comercial : ' + pCodDoc + ' ' + pNroDoc + ' => empieza la transaccion').

GRABAR_PEDIDO:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
     ASSIGN
          s-NroPed = ''
          s-CodCli = COTIZACION.CodCli
          s-CodMon = COTIZACION.CodMon                   /* >>> OJO <<< */
          s-FmaPgo = COTIZACION.FmaPgo
          S-FlgIgv = COTIZACION.FlgIgv.

    pRetVal = "Creando el pedido".

     CREATE faccpedi.
        ASSIGN faccpedi.codcia = s-codcia
                faccpedi.coddoc = s-coddoc
                faccpedi.nroped = STRING(iSerie, '999') + STRING(iCorrelativo, '999999')
                faccpedi.fchped = TODAY
                Faccpedi.TpoCmb = s-tpocmb
                Faccpedi.FchVen = TODAY + s-DiasVtoPed
                Faccpedi.FchEnt = IF (pFchEnt >= TODAY) THEN pFchEnt ELSE TODAY
                Faccpedi.libre_f02 = IF (pFchEnt >= TODAY) THEN pFchEnt ELSE TODAY
                Faccpedi.CodCli = COTIZACION.CodCli
                Faccpedi.NomCli = COTIZACION.NomCli
                Faccpedi.RucCli = COTIZACION.RucCli
                Faccpedi.Atencion = COTIZACION.Atencion
                Faccpedi.Dircli = COTIZACION.DirCli
                Faccpedi.FmaPgo = COTIZACION.FmaPgo
                Faccpedi.Glosa = COTIZACION.Glosa
                FacCPedi.codRef = COTIZACION.coddoc
                FacCPedi.NroRef = COTIZACION.NroPed
                FacCPedi.OrdCmp = COTIZACION.OrdCmp
                FacCPedi.FaxCli = COTIZACION.FaxCli
                FacCPedi.Sede = pSede
                FacCPedi.CodAlm = s-CodAlm
                FacCPedi.Cliente_Recoge = COTIZACION.Cliente_Recoge
                FacCPedi.TipVta = "No"
                Faccpedi.Cmpbnte = COTIZACION.Cmpbnte
                Faccpedi.CodMon = COTIZACION.CodMon
                Faccpedi.FlgIgv = COTIZACION.FlgIgv
                Faccpedi.Usuario = S-USER-ID
                Faccpedi.Hora   = STRING(TIME,"HH:MM:SS")
                Faccpedi.PorIgv = s-PorIgv 
                Faccpedi.CodDiv = S-CODDIV
                Faccpedi.FlgEst = "G"       /* FLAG TEMPORAL POR APROBAR */
                FacCPedi.TpoPed = s-TpoPed
                FacCPedi.FlgEnv = s-FlgEnv
                FacCPedi.Libre_c01 = s-User-id + '|' + STRING(DATETIME(TODAY, MTIME), '99/99/9999 HH:MM:SS')
                /* INFORMACION PARA LISTA EXPRESS */
                FacCPedi.PorDto     = COTIZACION.PorDto      /* Descuento LISTA EXPRESS */
                FacCPedi.ImpDto2    = COTIZACION.ImpDto2     /* Importe Decto Lista Express */
                FacCPedi.Importe[2] = COTIZACION.Importe[2] /* Importe Dcto Lista Express SIN IGV */
                FacCPedi.Libre_c02 = s-Tipo-Abastecimiento  /* PCO o NORMAL */
                FacCPedi.NroCard = COTIZACION.NroCard
                FacCPedi.CodVen  = COTIZACION.CodVen
                FacCPedi.CodTrans  = COTIZACION.CodTrans
                NO-ERROR.

            IF ERROR-STATUS:ERROR = YES THEN DO:
                RELEASE facCPedi NO-ERROR.
                RELEASE COTIZACION NO-ERROR.
                pRetVal = ERROR-STATUS:GET-MESSAGE(1).
                UNDO GRABAR_PEDIDO, RETURN 'ADM-ERROR'.
            END.
            
          /* *************************************************************************************** */
          /* RHC 09/04/2021 Datos del B2C y B2B */
          /* *************************************************************************************** */
          ASSIGN
              FacCPedi.ContactReceptorName = COTIZACION.ContactReceptorName 
              FacCPedi.TelephoneContactReceptor = COTIZACION.TelephoneContactReceptor 
              FacCPedi.ReferenceAddress = COTIZACION.ReferenceAddress 
              FacCPedi.DNICli = COTIZACION.DNICli
              Faccpedi.TpoLic = s-TpoLic.

        /* Ic 17Abr2024 */
          cGlosa = "".
          IF cotizacion.codcli = '20100047218' THEN DO:
              /* Verificamos si la Cotizacion tiene grupo de reparto */
              cGlosa = "PEDIDO EXTRAORDINARIO No. " + COTIZACION.OrdCmp.
              IF NOT (TRUE <> (cotizacion.DeliveryGroup > "")) THEN DO:
                  cGlosa = "GRUPO No. " + TRIM(cotizacion.DeliveryGroup) + " PEDIDO No. " + COTIZACION.OrdCmp.
              END.
              ASSIGN Faccpedi.Glosa = cGlosa.
          END. 
          /* *************************************************************************************** */
      /* 29/05/2023 Dependiendo de la CndVta la Fecha de Entrega tiene un tope SLM */
      /* *************************************************************************************** */
      FIND VtaTabla WHERE VtaTabla.CodCia = s-codcia AND
          VtaTabla.Tabla = "CFG-VCTO-CNDVTA-DIV" AND
          VtaTabla.Llave_c1 = s-FmaPgo AND 
          VtaTabla.Llave_c2 = COTIZACION.Libre_c01      /* OJO */
          NO-LOCK NO-ERROR.
      IF AVAILABLE VtaTabla AND VtaTabla.Valor[1] > 0 THEN ASSIGN Faccpedi.FchVen = TODAY + VtaTabla.Valor[1] .

      CASE s-Tipo-Abastecimiento:
          WHEN "PCO" THEN DO:
              FIND FIRST PCO WHERE PCO.codcia = s-CodCia AND
                  PCO.coddiv = s-CodDiv AND
                  PCO.coddoc = "PCO" AND
                  PCO.nroped = xNroPCO NO-LOCK NO-ERROR.
              IF AVAILABLE PCO THEN DO:
                  ASSIGN FacCPedi.CodOrigen = PCO.CodDoc
                        FacCPedi.NroOrigen = PCO.NroPed.
              END.
          END.
          OTHERWISE DO:
                ASSIGN FacCPedi.NroRef = COTIZACION.NroPed.
          END.
      END CASE.
      /* CASO CANAL MODERNO */
      IF CAN-FIND(gn-divi WHERE gn-divi.codcia = s-codcia AND 
                  gn-divi.coddiv = s-coddiv AND
                  gn-divi.canalventa = "MOD" NO-LOCK) THEN
            ASSIGN Faccpedi.Sede = COTIZACION.Ubigeo[1].
    /* ********************************************************************************************** */
    /* CONTROL DE SEDE Y UBIGEO: POR CLIENTE */
    /* ********************************************************************************************** */
    FIND FIRST gn-clied WHERE gn-clied.codcia = cl-codcia
        AND gn-clied.codcli = Faccpedi.codcli
        AND gn-clied.sede = Faccpedi.sede
        NO-LOCK NO-ERROR.
    ASSIGN
        FacCPedi.Ubigeo[1] = FacCPedi.Sede
        FacCPedi.Ubigeo[2] = "@CL"
        FacCPedi.Ubigeo[3] = FacCPedi.CodCli.
    /* ********************************************************************************************** */
    /* EN CASO DE VENIR DE UN PCO */
    /* ********************************************************************************************** */
    CASE TRUE:
        WHEN s-Tipo-Abastecimiento = "PCO" THEN DO:
            /* Bloqueamos PCO */
            FIND FIRST PCO WHERE PCO.codcia = s-codcia AND
                PCO.coddoc = "PCO" AND
                PCO.nroped = xNroPCO
                EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            IF ERROR-STATUS:ERROR = YES THEN DO:
                pRetVal = ERROR-STATUS:GET-MESSAGE(1).
                RELEASE faccorre NO-ERROR.
                RELEASE COTIZACION NO-ERROR.

                UNDO GRABAR_PEDIDO, RETURN 'ADM-ERROR'.
            END.
            ASSIGN
                PCO.FlgEst = "C".   /* SE CIERRA TOTALMENTE EL PCO */
            RELEASE PCO.
            ASSIGN
                FacCPedi.CodOrigen = "PCO"
                FacCPedi.NroOrigen = xNroPCO.
        END.
        OTHERWISE DO:
            /* 03/05/2024: C.Tenazoa: control de origen (Ej. RIQRA HORIZONTAL) */
            ASSIGN
                FacCPedi.CodOrigen = COTIZACION.CodOrigen
                FacCPedi.NroOrigen = COTIZACION.NroOrigen.
        END.
    END CASE.
    pRetVal = "Grabando el tracking".
    
    IF grabarmsgLog=YES THEN RUN lib/p-write-log-txt.r("Genera pedido logistico", 'Pedido comercial : ' + pCodDoc + ' ' + pNroDoc + ' => vtagn/pTracking-04.r').

    /* TRACKING */
    RUN vtagn/pTracking-04.r (s-CodCia,
                            s-CodDiv,
                            Faccpedi.CodDoc,
                            Faccpedi.NroPed,
                            s-User-Id,
                            'GNP',
                            'P',
                            DATETIME(TODAY, MTIME),
                            DATETIME(TODAY, MTIME),
                            Faccpedi.CodDoc,
                            Faccpedi.NroPed,
                            Faccpedi.CodRef,
                            Faccpedi.NroRef).
/*     /* ********************************************************************************************** */ */
/*     /* RHC 23/07/2018 CONTROL DE TOPE DE PEDIDOS */                                                      */
/*     /* ********************************************************************************************** */ */
/*     FOR EACH T-LogTabla NO-LOCK:                                                                         */
/*         CREATE LogTabla.                                                                                 */
/*         BUFFER-COPY T-LogTabla TO LogTabla                                                               */
/*             ASSIGN                                                                                       */
/*             logtabla.codcia = s-CodCia                                                                   */
/*             logtabla.Tabla = "TOPEDESPACHO"                                                              */
/*             LogTabla.ValorLlave = Faccpedi.CodDoc + '|' + Faccpedi.NroPed + '|' + T-LogTabla.ValorLlave. */
/*         DELETE T-LogTabla.                                                                               */
/*     END.                                                                                                 */
    /* ********************************************************************************************** */
    /* Control de Pedidos Generados */
    /* ********************************************************************************************** */
    CREATE Reporte.
    BUFFER-COPY Faccpedi TO Reporte.
    /* ********************************************************************************************** */
    /* Definimos cuantos almacenes hay de despacho */
    /* Cuando se modifica un pedido hay solo un almacén */
    /* ********************************************************************************************** */
    /* x-CodAlm = ENTRY(1, s-CodAlm).        /* El primer almacén por defecto */*/
    ASSIGN 
        FacCPedi.CodAlm = s-CodAlm.               /* <<<< OJO <<<< : Almacén del PEDIDO */
    /* ********************************************************************************************** */
    /* Division destino */
    /* ********************************************************************************************** */
    FIND Almacen OF Faccpedi NO-LOCK.

    IF AVAILABLE Almacen THEN FacCPedi.DivDes = Almacen.CodDiv.
    /* ********************************************************************************************** */
    /* CARGAMOS LA INFORMACION POR ALMACEN DESPACHO */
    /* ********************************************************************************************** */
    EMPTY TEMP-TABLE PEDI.
    FOR EACH PEDI-2 NO-LOCK WHERE PEDI-2.almdes = s-CodAlm:
        CREATE PEDI.
        BUFFER-COPY PEDI-2 TO PEDI.
    END.
    
    IF grabarmsgLog=YES THEN RUN lib/p-write-log-txt.r("Genera pedido logistico", 'Pedido comercial : ' + pCodDoc + ' ' + pNroDoc + ' => WRITE-DETAIL').

    RUN WRITE-DETAIL.       /* Detalle del pedido */
    /* ********************************************************************************************** */
    /* Reactualizamos la Fecha de Entrega                                             */
    /* ********************************************************************************************** */
    /* RHC 07/04/2021 */
    pRetVal = "Calculando fecha de entrega".
    pFchEnt = Faccpedi.Libre_f02.   /* Pactada con el cliente */
    
    IF grabarmsgLog=YES THEN RUN lib/p-write-log-txt.r("Genera pedido logistico", 'Pedido comercial : ' + pCodDoc + ' ' + pNroDoc + ' => Fecha-Entrega').

    RUN Fecha-Entrega (INPUT-OUTPUT pFchEnt, OUTPUT pRetVal) NO-ERROR.
    
    IF pRetVal > '' THEN UNDO GRABAR_PEDIDO, RETURN 'ADM-ERROR'.
    ASSIGN
        FacCPedi.FchEnt = pFchEnt.
 
    /* ****************************************************************************** */
    /* Grabamos Totales */
    /* ********************************************************************************************** */
    
    IF grabarmsgLog=YES THEN RUN lib/p-write-log-txt.r("Genera pedido logistico", 'Pedido comercial : ' + pCodDoc + ' ' + pNroDoc + ' => Graba Totales').

    RUN Graba-Totales.
    
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        pRetVal = "vta2/pactualizacotizacion.r" + CHR(10) + pRetVal.
        UNDO GRABAR_PEDIDO, RETURN 'ADM-ERROR'.
    END.
        
    /* ********************************************************************************************** */
    /* Actualizamos la cotizacion */
    /* ********************************************************************************************** */
    
    IF grabarmsgLog=YES THEN RUN lib/p-write-log-txt.r("Genera pedido logistico", 'Pedido comercial : ' + pCodDoc + ' ' + pNroDoc + ' => vta2/pactualizacotizacion.r').

    RUN vta2/pactualizacotizacion.r ( ROWID(faccpedi), "C", OUTPUT pRetVal).
    
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        pRetVal = "vta2/pactualizacotizacion.r" + CHR(10) + pRetVal.
        UNDO GRABAR_PEDIDO, RETURN 'ADM-ERROR'.
    END.
        

    /* ********************************************************************************************** */
    /* SE VA A DAR TANTAS VUELTAS COMO ALMACENES EXISTAN */
    /* ********************************************************************************************** */
    /* Ic - no va por que solo se va generar un pedido logistico
    RUN PedidosLogisticosxAlmacen.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    */
END.

IF grabarmsgLog=YES THEN RUN lib/p-write-log-txt.r("Genera pedido logistico", 'Pedido comercial : ' + pCodDoc + ' ' + pNroDoc + ' => Crear pedido logistico FIN').

pNewCoddoc = faccpedi.coddoc.
pNewNroDoc = faccpedi.nroped.

RELEASE faccpedi NO-ERROR.
RELEASE facdpedi NO-ERROR.

pRetVal = "".

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Fecha-Entrega) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Fecha-Entrega Procedure 
PROCEDURE Fecha-Entrega :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT-OUTPUT PARAMETER pFchEnt    AS DATE.
DEF OUTPUT PARAMETER pMensaje   AS CHAR.

/* LA RUTINA VA A DECIDIR SI EL CALCULO ES POR UBIGEO O POR GPS */
RUN logis/p-fecha-de-entrega.r (
    FacCPedi.CodDoc,              /* Documento actual */
    FacCPedi.NroPed,
    INPUT-OUTPUT pFchEnt,
    OUTPUT pMensaje).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Graba-Totales) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Totales Procedure 
PROCEDURE Graba-Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF {&ARITMETICA-SUNAT} &THEN
  /* ****************************************************************************************** */
  /* ****************************************************************************************** */
  {vtagn/totales-cotizacion-sunat.i &Cabecera="FacCPedi" &Detalle="FacDPedi"}
  /* ****************************************************************************************** */
  /* Importes SUNAT */
  /* ****************************************************************************************** */
  DEF VAR hProc AS HANDLE NO-UNDO.
  RUN sunat/sunat-calculo-importes.r PERSISTENT SET hProc.
  RUN tabla-faccpedi IN hProc (INPUT Faccpedi.CodDiv,
                               INPUT Faccpedi.CodDoc,
                               INPUT Faccpedi.NroPed,
                               OUTPUT pRetVal).
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN 'ADM-ERROR'.
  DELETE PROCEDURE hProc.
  /* ****************************************************************************************** */
  /* ****************************************************************************************** */
&ELSE
  {vta2/graba-totales-cotizacion-cred.i}
  /* ****************************************************************************************** */
  /* Importes SUNAT */
  /* NO graba importes Progress */
  /* ****************************************************************************************** */
  DEF VAR hProc AS HANDLE NO-UNDO.
  RUN sunat/sunat-calculo-importes PERSISTENT SET hProc.
  RUN tabla-faccpedi IN hProc (INPUT Faccpedi.CodDiv,
                               INPUT Faccpedi.CodDoc,
                               INPUT Faccpedi.NroPed,
                               OUTPUT pRetVal).
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN 'ADM-ERROR'.
  DELETE PROCEDURE hProc.
  /* ****************************************************************************************** */
  /* ****************************************************************************************** */
&ENDIF

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-sede-cliente) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sede-cliente Procedure 
PROCEDURE sede-cliente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF OUTPUT PARAMETER pSede AS CHAR NO-UNDO.
  DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.
                                                  
  ASSIGN
      pSede = ''
      pMensaje = ''.

  DEFINE VAR hProc AS HANDLE NO-UNDO.
  RUN gn/master-library.r PERSISTENT SET hProc.
  RUN B2B_Sede-Cliente IN hProc (INPUT COTIZACION.CodCli,
                                 INPUT COTIZACION.DeliveryAddress,
                                 INPUT COTIZACION.Region1Name,
                                 INPUT COTIZACION.Region2Name,
                                 INPUT COTIZACION.Region3Name, 
                                 INPUT COTIZACION.ReferenceAddress, 
                                 INPUT COTIZACION.TelephoneContactReceptor, 
                                 INPUT COTIZACION.ContactReceptorName,
                                 OUTPUT pSede,
                                 OUTPUT pMensaje).
                                 
  DELETE PROCEDURE hProc.
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validaciones) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaciones Procedure 
PROCEDURE validaciones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER pxRetVal AS CHAR NO-UNDO.

DEFINE VAR f-Tot AS DEC. 

FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
    AND gn-clie.codcli = COTIZACION.codcli NO-LOCK NO-ERROR.

IF NOT AVAILABLE gn-clie THEN DO:
    pxRetVal = 'Cia : ' + STRING(cl-codcia) + ',Cliente ' + COTIZACION.codcli + ' no registrado en el Maestro General de Clientes' + CHR(10) +
            'Comunicarse con el Administrador o ' + CHR(10) +
            'con el Gestor del Maestro de Clientes'.
    RETURN "ADM-ERROR".
END.

IF gn-clie.Libre_f01 <> ? AND gn-clie.Libre_f01 >= TODAY THEN DO:
    pxREtVal = 'NO podemos emitir comprobantes el día de hoy porque el RUC aún NO está activo en SUNAT' + CHR(10) + 
        'Fecha de inscrición SUNAT:' + string(gn-clie.Libre_f01,"99/99/9999").
    RETURN 'ADM-ERROR'.
END.

IF COTIZACION.Cmpbnte = "FAC" THEN DO:
    /* dígito verificador */
    DEF VAR pResultado AS CHAR NO-UNDO.
    RUN lib/_valruc.r (COTIZACION.RucCli, OUTPUT pResultado).
    IF pResultado = 'ERROR' THEN DO:
        pxRetVal = 'Código RUC MAL registrado' + CHR(10) +
            'Comunicarse con el Administrador o' + CHR(10) +
            'con el Gestor del Maestro de Clientes'.
        RETURN 'ADM-ERROR'.
    END.
END.
/* SEDE */
FIND FIRST gn-clied WHERE gn-clied.codcia = cl-codcia
    AND gn-clied.codcli = TRIM(COTIZACION.codcli)
    AND gn-clied.sede = TRIM(COTIZACION.sede)
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-clied THEN DO:
    pxRetVal = 'Sede NO registrada: ' + COTIZACION.sede + CHR(10) +
        'Comunicarse con el Administrador o' + CHR(10) +
        'con el Gestor del Maestro de Clientes'.
    RETURN 'ADM-ERROR'.
END.
/* CODIGO POSTAL */
IF TRUE <> (COTIZACION.CodPos > '') THEN DO:
    pxRetVal = 'Código Postal no debe estar en blanco' + CHR(10) +
        'Comunicarse con el Administrador o' + CHR(10) + 
        'con el Gestor del Maestro de Clientes'.
    RETURN 'ADM-ERROR'.
END.
FIND Almtabla WHERE almtabla.Tabla = "CP" AND almtabla.Codigo = COTIZACION.CodPos
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtabla THEN DO:
    pxRetVal =  'Código Postal no registrado' + CHR(10) + 
        'Comunicarse con el Administrador o' + CHR(10) +
        'con el Gestor del Maestro de Clientes'.
    RETURN 'ADM-ERROR'.
END.

/* CONSISTENCIA DE FECHA */
IF COTIZACION.fchven < COTIZACION.FchPed THEN DO:
    pxRetVal = 'Fecha de vencimiento no debe ser menor a la fecha del pedido' .
    RETURN "ADM-ERROR".
END.
IF COTIZACION.Libre_f02 > (COTIZACION.FchPed + 25) THEN DO: 
    pxRetVal =  'La fecha de entrega no puede superar los 25 días de la fecha de emisión del pedido'.
    RETURN "ADM-ERROR".
END.

/* CONSISTENCIA ALMACEN DESPACHO */
IF TRUE <> (COTIZACION.CodAlm > "") THEN DO:
    pxRetVal = "Almacén de Despacho no debe ser blanco" .
    RETURN "ADM-ERROR".
END.

/* CONSISTENCIA DE IMPORTES */
f-Tot = 0.
FOR EACH COTIZACIONDTL OF COTIZACION NO-LOCK:
   F-Tot = F-Tot + COTIZACIONDTL.ImpLin.
END.
IF F-Tot <= 0 THEN DO:
    pxRetVal =  "Importe total debe ser mayor a cero" .
    RETURN "ADM-ERROR".   
END.

/**** CONTROL DE 1/2 UIT PARA BOLETAS DE VENTA */
f-TOT = IF S-CODMON = 1 THEN F-TOT ELSE F-TOT * s-TpoCmb.
IF F-Tot > 700 THEN DO:
    IF COTIZACION.Cmpbnte = 'BOL' AND (TRUE <> (COTIZACION.Atencion > '')) THEN DO:
        pxRetVal = "Boleta de Venta Venta Mayor a S/.700.00 Ingresar Nro. DNI, Verifique... " .
        RETURN "ADM-ERROR".   
    END.
END.

/* RHC 15.12.09 CONTROL DE IMPORTE MINIMO POR PEDIDO */
DEF VAR pImpMin AS DEC NO-UNDO.
RUN vta2/p-MinCotPed.r (s-CodCia,
                   s-CodDiv,
                   s-CodDoc,
                   OUTPUT pImpMin).
IF pImpMin > 0 AND f-Tot < pImpMin THEN DO:
    pxRetVal = 'El importe mínimo para hacer un pedido es de S/.' + STRING( pImpMin) + CHR(10) +
        'Comunicarse con el Gestor Comercial'.
    RETURN "ADM-ERROR".
END.

/* ******************************************************************************** */
/* Ic 30Set2019 - CONTRA-ENTREGA no es aplicable a CLIENTES-NUEVOS */
/* ******************************************************************************** */
DEFINE VAR hProc AS HANDLE NO-UNDO.
DEFINE VAR x-moroso AS CHAR.

RUN ccb/libreria-ccb.r PERSISTENT SET hProc.
/* 
    Ic - 23Abr2020, ventas por whatsapp no validar cliente nuevo
    ya que esta venta viene como tpoped = 'E'
*/
IF COTIZACION.tpoped <> 'E' THEN DO:
    IF COTIZACION.fmapgo = '001'  THEN DO:
        DEFINE VAR x-retval AS LOG.

        x-retval = NO.
        RUN cliente-nuevo IN hProc (INPUT COTIZACION.codcli, OUTPUT x-retval).                
        IF x-retval = YES THEN DO:
            pxRetVal = 'CONTRA-ENTREGA no es aplicable para CLIENTES NUEVOS' .
            DELETE PROCEDURE hProc.
            RETURN "ADM-ERROR".
        END.
    END.
END.

/* ******************************************************************************** */
/* Ic 30Set2019 - Direccion de clientes es de CLIENTE moroso no pasa */
/* ******************************************************************************** */
x-moroso = "".

RUN direccion-de-moroso IN hProc (INPUT COTIZACION.codcli, 
                                  INPUT COTIZACION.sede,
                                  INPUT COTIZACION.fmapgo,
                                  OUTPUT x-moroso).        
DELETE PROCEDURE hProc.

IF x-moroso <> "" THEN DO:
    pxRetVal = 'ATENCION : La dirección de entrega pertenece ' + CHR(10) +
        'a un cliente con deuda calificada como morosidad' + CHR(10) +
        'El pedido va ir obligatoriamente a evaluación de créditos y cobranzas' + CHR(10) +
        'Comunicarse con el Gestor de Créditos y Cobranzas'.
        RETURN "ADM-ERROR".
END.

/* **************************************************************************** */
/* RHC 13/07/2020 NO artículo tipo SV ni Drop Shipping */
/* **************************************************************************** */
DEF VAR x-Cuenta-Items AS INTE INIT 0 NO-UNDO.

FOR EACH COTIZACIONDTL OF COTIZACION, FIRST Almmmatg OF COTIZACIONDTL NO-LOCK, FIRST Almtfami OF Almmmatg NO-LOCK:
    CASE TRUE:
        WHEN Almtfami.Libre_c01 = "SV" THEN NEXT.
        OTHERWISE DO:
            FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia AND
                VtaTabla.Tabla = "DROPSHIPPING" AND
                VtaTabla.Llave_c1 = COTIZACIONDTL.CodMat 
                NO-LOCK NO-ERROR.
            IF AVAILABLE VtaTabla THEN NEXT.
        END.
    END CASE.
    x-Cuenta-Items = x-Cuenta-Items + 1.
END.
IF x-Cuenta-Items = 0 AND COTIZACION.TipVta <> "Si" THEN DO:
    pxRetVal =  'Debido a las características de esta venta' + CHR(10) +
        'es necesario que seleccione TRAMITE DOCUMENTARIO'.
    RETURN 'ADM-ERROR'.
END.

/* **************************************************************************** */
/* RHC 03/10/19 Trámite Documentario por Configuración */
/* **************************************************************************** */
FIND FIRST Almacen WHERE Almacen.codcia = s-codcia AND
    Almacen.codalm = COTIZACION.CodAlm NO-LOCK NO-ERROR.
IF NOT AVAILABLE almacen THEN DO:
    pxRetVal =  'El almacen ' + COTIZACION.CodAlm + ' no existe'.
    RETURN 'ADM-ERROR'.
END.
IF almacen.campo-c[9] = 'I' THEN DO:
    pxRetVal =  'El almacen ' + COTIZACION.CodAlm + ' esta inactivo'.
    RETURN 'ADM-ERROR'.
END.

FIND FIRST GN-DIVI WHERE gn-divi.codcia = s-codcia AND
    gn-divi.coddiv = Almacen.coddiv NO-LOCK NO-ERROR.
FIND FIRST TabGener WHERE TabGener.CodCia = GN-DIVI.CodCia
    AND TabGener.Codigo = GN-DIVI.CodDiv
    AND TabGener.Clave = "CFGINC" NO-LOCK NO-ERROR.
IF COTIZACION.TipVta = "Si" THEN DO: 
    IF (NOT AVAILABLE TabGener OR TabGener.Libre_l05 = NO) THEN DO:
        pxRetVal = 'Trámite Documentario NO autorizado en la división de despacho' + CHR(10) +
            'Comunicarse con el Gestor de Abastecimientos'.
        RETURN "ADM-ERROR".
    END.
END.

/* *************************************************************************************** */
/* RHC 16/12/2021 Control de A/C por aplicar */
/* *************************************************************************************** */
DEF VAR pTpoLic AS LOG NO-UNDO.

RUN Verifica-AC (OUTPUT pTpoLic, OUTPUT pxRetval).
IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
    RETURN 'ADM-ERROR'.
END.
s-TpoLic = pTpoLic.     /* OJO */


/* *************************************************************************************** */
/* 19/01/2023 Nuevos Controles */
/* *************************************************************************************** */
/*
pFchEnt = COTIZACION.FchEnt.      /* OJO */
IF COTIZACION.Ubigeo[2] <> "@PV" THEN DO:
    pFchEnt = COTIZACION.Libre_f02.   /* Pactada con el cliente */
    RUN logis/p-fecha-de-entrega (
        FacCPedi.CodDoc,              /* Documento actual */
        FacCPedi.NroPed,
        INPUT-OUTPUT pFchEnt,
        OUTPUT pMensaje).
END.
  */
    /* ***************************************************************************
    RHC 25/01/2018 Verificamos la linea de crédito en 3 pasos
    1. Solicitar línea de crédito activa
    2. Solicitar deuda pendiente
    3. Tomar decisión
    ***************************************************************************** */
    DEF VAR f-Importe AS DEC NO-UNDO.

    f-Importe = 0.
    FOR EACH PEDI NO-LOCK:
       f-Importe = f-Importe + PEDI.ImpLin.
    END.
    FIND FIRST B-CPEDI WHERE B-CPEDI.codcia = s-codcia
        AND B-CPEDI.coddiv = s-CodDiv
        AND B-CPEDI.coddoc = COTIZACION.coddoc  /*s-CodRef*/
        AND B-CPEDI.nroped = COTIZACION.nroped  /*s-NroCot*/
        NO-LOCK NO-ERROR.
    IF B-CPEDI.TpoPed <> 'M' THEN DO:       /*** No valida LC para Contratos Marco ***/
        /* 28/11/2024 Gina Condor */
        /* Reemplazar vta2/linea-de-credito-v2 por vta2/linea-de-credito-disponible */
        RUN vta2/linea-de-credito-disponible (s-CodDiv,
                                      s-CodCli,
                                      s-FmaPgo,
                                      s-CodMon,
                                      f-Importe,
                                      NO). /* No muesta el mensaje */
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            pxRetVal = "NO PASA LA VALIDACION DE LINEA DE CREDITO".
            RETURN "ADM-ERROR".
        END.
    END.


pxRetVal = "".

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-VALIDATE-DETAIL) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE VALIDATE-DETAIL Procedure 
PROCEDURE VALIDATE-DETAIL :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF INPUT PARAMETER pEvento AS CHAR.                       
  DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

  DEF VAR LocalVerificaStock AS LOG NO-UNDO.
  DEF VAR x-StkAct AS DECI NO-UNDO.
  DEF VAR s-StkComprometido AS DECI NO-UNDO.
  DEF VAR s-StkDis AS DECI NO-UNDO.
  DEF VAR f-Factor AS DECI NO-UNDO.
  DEF VAR x-CanPed AS DECI NO-UNDO.
  DEF VAR f-CanPed AS DECI NO-UNDO.
  DEF VAR pSugerido AS DECI NO-UNDO.
  DEF VAR pEmpaque AS DECI NO-UNDO.
  DEF VAR pMaster AS DECI NO-UNDO.
  DEF VAR pInner AS DECI NO-UNDO.
/*
  FIND COTIZACION WHERE COTIZACION.CodCia = s-CodCia AND 
      COTIZACION.CodDiv = s-CodDiv AND 
      COTIZACION.CodDoc = s-CodRef AND 
      COTIZACION.NroPed = s-NroCot
      NO-LOCK.
  */
  /* RHC 24/04/2020 Validación VENTA DELIVERY */
  DEF VAR x-VentaDelivery AS LOG NO-UNDO.
  FIND FIRST FacTabla WHERE FacTabla.CodCia = s-CodCia AND
      FacTabla.Tabla = "GN-DIVI" AND
      FacTabla.Codigo = s-CodDiv AND
      FacTabla.Campo-L[3] = YES   /* Solo pedidos al 100% */
      NO-LOCK NO-ERROR.
  IF AVAILABLE FacTabla THEN x-VentaDelivery = YES.
  ELSE x-VentaDelivery = NO.
      
  /* OJO: Solo pasa lo que tiene stock disponible, salvo las ventas delivery */
  DETALLES:
  FOR EACH PEDI EXCLUSIVE-LOCK, FIRST Almmmatg OF PEDI NO-LOCK, FIRST Almtfami OF Almmmatg NO-LOCK:
      /* **************************************************************************************** */
      /* RHC 13/06/2020 NO se verifica el stock de productos con Cat. Contab. = "SV" */
      /* el x-articulo-ICBPER es un impuesto clasificado coomo SV (servicio) */
      /* RHC 10/07/2020 NO se verifica el stock de productos Drop Shipping */
      /* **************************************************************************************** */
      IF Almtfami.Libre_c01 = "SV" THEN NEXT.
      FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia AND
          VtaTabla.Tabla = "DROPSHIPPING" AND
          VtaTabla.Llave_c1 = PEDI.CodMat 
          NO-LOCK NO-ERROR.
      IF AVAILABLE VtaTabla THEN NEXT.
      /* **************************************************************************************** */
      /* VERIFICAMOS STOCK DISPONIBLE DE ALMACEN */
      /* **************************************************************************************** */
      FIND FIRST Almmmate WHERE Almmmate.codcia = s-codcia
          AND Almmmate.codalm = PEDI.AlmDes
          AND Almmmate.codmat = PEDI.CodMat
          NO-LOCK NO-ERROR.
      /* RHC 15/03/2021 Decidimos cuándo verificamos el stock */
      LocalVerificaStock = NO.
      IF pEvento = "YES" THEN LocalVerificaStock = YES.     /* CREATE */
      IF pEvento = "NO" THEN DO:                            /* UPDATE */
          /* Solo cuando hay una modificación de la cantidad: debe ser diferente a la solicitada anteriormente */
          FIND FIRST x-Facdpedi WHERE x-Facdpedi.codmat = PEDI.codmat NO-LOCK NO-ERROR.
          IF AVAILABLE x-Facdpedi AND PEDI.CanPed <> x-Facdpedi.CanPed THEN LocalVerificaStock = YES.
      END.
      /* ******************************************************** */
      /* RHC 13/07/2021: Siempre verificar stock para PROMOCIONES */
      /* ******************************************************** */
      IF PEDI.Libre_c05 = "OF" THEN LocalVerificaStock = YES.
      /* ******************************************************** */
      IF LocalVerificaStock = YES THEN DO:
          x-StkAct = 0.
          IF AVAILABLE Almmmate THEN x-StkAct = Almmmate.StkAct.
          /* **************************************************************** */
          /* OJO: Cuando se modifica hay que actualizar el STOCK COMPROMETIDO */
          /* **************************************************************** */
          IF x-StkAct > 0 THEN DO:
              RUN gn/stock-comprometido-v2.r (PEDI.CodMat, PEDI.AlmDes, YES, OUTPUT s-StkComprometido).
              IF pEvento = "NO" THEN DO:    /* MODIFICANDO EL PEDIDO */
                  FIND FIRST Facdpedi OF Faccpedi WHERE Facdpedi.codmat = PEDI.codmat NO-LOCK NO-ERROR.
                  IF AVAILABLE Facdpedi AND s-StkComprometido > 0 
                      THEN s-StkComprometido = s-StkComprometido - (Facdpedi.CanPed * Facdpedi.Factor).
              END.
              ELSE DO:  /* CREANDO EL PEDIDO */
                  /* **************************************************************** */
                  /* RHC 29/04/2020 Tener cuidado, la COT también comprometen mercadería */
                  /* **************************************************************** */
                  FIND FIRST FacTabla WHERE FacTabla.CodCia = COTIZACION.CodCia AND
                      FacTabla.Tabla = "GN-DIVI" AND
                      FacTabla.Codigo = COTIZACION.CodDiv AND
                      FacTabla.Campo-L[2] = YES AND   /* Reserva Stock? */
                      FacTabla.Valor[1] > 0           /* Horas de reserva */
                      NO-LOCK NO-ERROR.
                  IF AVAILABLE FacTabla THEN DO:
                      /* Si ha llegado hasta acá es que está dentro de las horas de reserva */
                      /* Afectamos lo comprometido: extornamos el comprometido */
                      FIND FIRST Facdpedi OF COTIZACION WHERE Facdpedi.codmat = PEDI.codmat NO-LOCK NO-ERROR.
                      IF AVAILABLE Facdpedi AND s-StkComprometido > 0 
                          THEN s-StkComprometido = s-StkComprometido - (Facdpedi.Factor * (Facdpedi.CanPed - Facdpedi.CanAte)).
                  END.
              END.
          END.
          s-StkDis = x-StkAct - s-StkComprometido.
          IF s-StkDis <= 0 THEN DO:
              /* ******************************** */
              /* Venta Delivery NO DESPACHAR NADA */
              /* ******************************** */
              IF x-VentaDelivery = YES THEN DO:
                  pMensaje = 'El STOCK DISPONIBLE está en CERO para el producto ' + PEDI.codmat + 
                      'en el almacén ' + PEDI.AlmDes + CHR(10).
                  RETURN "ADM-ERROR".
              END.
              /* ******************************** */
              DELETE PEDI.      /* << OJO << */
              NEXT DETALLES.    /* << OJO << */
          END.
          f-Factor = PEDI.Factor.
          x-CanPed = PEDI.CanPed * f-Factor.
          IF s-StkDis < x-CanPed THEN DO:
              /* ************************************ */
              /* 27/07/2022: CCamus nuevo promocional */
              /* ************************************ */
              IF PEDI.Libre_d03 > 0 THEN DO:
                  /* Quitamos la promoción */
                  ASSIGN
                      PEDI.CanPed = PEDI.CanPed - PEDI.Libre_d03
                      PEDI.Por_Dsctos[1] = 0
                      PEDI.Libre_d03 = 0.
                  x-CanPed = PEDI.CanPed * f-Factor.
                  IF x-CanPed < s-StkDis THEN s-StkDis = x-CanPed.  /* Ajuste */
              END.
              /* ******************************** */
              /* Venta Delivery NO DESPACHAR NADA */
              /* ******************************** */
              IF x-VentaDelivery = YES THEN DO:
                  pMensaje = 'Producto ' + PEDI.codmat + ' NO tiene Stock Disponible suficiente en el almacén ' + PEDI.AlmDes + CHR(10) +
                      'Se va a abortar la generación del Pedido'.
                  RETURN "ADM-ERROR".
              END.
              /* ******************************** */
              /* Ajustamos de acuerdo a los multiplos */
              PEDI.CanPed = ( s-StkDis - ( s-StkDis MODULO f-Factor ) ) / f-Factor.
              IF PEDI.CanPed <= 0 THEN DO:
                  DELETE PEDI.      /* OJO */
                  NEXT DETALLES.    /* OJO */
              END.
          END.
          /* EMPAQUE SUPERMERCADOS */
          FIND FIRST supmmatg WHERE supmmatg.codcia = s-CodCia
              AND supmmatg.codcli = s-CodCli
              AND supmmatg.codmat = PEDI.codmat 
              NO-LOCK NO-ERROR.
          f-CanPed = PEDI.CanPed * f-Factor.
          IF AVAILABLE supmmatg AND supmmatg.Libre_d01 <> 0 THEN DO:
              f-CanPed = (TRUNCATE((f-CanPed / supmmatg.Libre_d01),0) * supmmatg.Libre_d01).
              f-CanPed = ((f-CanPed - (f-CanPed MODULO f-Factor)) / f-Factor).  /* En unidades de venta */
          END.
          ELSE DO:    /* EMPAQUE OTROS */
              IF s-FlgEmpaque = YES THEN DO:
                  DEF VAR x-Lista_de_Precios AS CHAR NO-UNDO.     /* Por compatibilidad */

                  IF TRUE <> (COTIZACION.Lista_de_Precios > '') 
                      THEN x-Lista_de_Precios = COTIZACION.Libre_c01.
                      ELSE x-Lista_de_Precios = COTIZACION.Lista_de_Precios.
                  RUN vtagn/p-sugerido-ped-logistico.r (INPUT PEDI.CodMat,
                                                        INPUT (f-CanPed / f-Factor),    /* En unidades de Venta */
                                                        INPUT f-Factor,
                                                        INPUT x-Lista_de_Precios,
                                                        OUTPUT pSugerido,               /* En unidades de Venta */
                                                        OUTPUT pMaster,
                                                        OUTPUT pInner).
                  f-CanPed = pSugerido.     /* En unidades de Venta */
              END.
          END.
          IF f-CanPed <> PEDI.CanPed THEN DO:
              /* ******************************** */
              /* Venta Delivery NO DESPACHAR NADA */
              /* ******************************** */
              IF x-VentaDelivery = YES THEN DO:
                  pMensaje = 'Producto ' + PEDI.codmat + ' NO tiene Stock Disponible suficiente en el almacén ' + PEDI.AlmDes + CHR(10) +
                      'Se va a abortar la generación del Pedido'.
                  RETURN "ADM-ERROR".
              END.
              /* ******************************** */
          END.
          ASSIGN
              PEDI.CanPed = f-CanPed.
          IF PEDI.CanPed <= 0 THEN DO:
              DELETE PEDI.      /* OJO */
              NEXT DETALLES.    /* OJO */
          END.
      END.
      /* **************************************************************************************** */
  END.

  /* ********************************************************************************************** */
  /* RECALCULAMOS */
  /* ********************************************************************************************** */
  FOR EACH PEDI EXCLUSIVE-LOCK:
      {vta2/calcula-linea-detalle.i &Tabla="PEDI"}
      IF PEDI.CanPed <= 0 THEN DELETE PEDI.    
  END.
  
  /* ********************************************************************************************** */
  /* Las Promociones solo se calculan en el PRIMER PEDIDO */
  /* ********************************************************************************************** */
  /* 26/07/2023: Nueva libreria de promociones C.Camus
    Dos parámetros nuevos:
    pCodAlm: código de almacén de despacho
    pCantidad: cantidad (en unidades de stock) 
                si es un registro nuevo el valor va en 0 (cero)
  */                
  RUN {&Promocion} (COTIZACION.Libre_c01, 
                    s-CodCli, 
                    COTIZACION.CodAlm, 
                    (IF pEvento = "YES" THEN "CREATE" ELSE "UDPATE"),
                    INPUT-OUTPUT TABLE PEDI, 
                    OUTPUT pMensaje).
    
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  FOR EACH PEDI NO-LOCK WHERE PEDI.Libre_c05 = "OF", FIRST Almmmatg OF PEDI NO-LOCK, FIRST Almtfami OF Almmmatg NO-LOCK:
      /* **************************************************************************************** */
      /* VERIFICAMOS STOCK DISPONIBLE DE ALMACEN */
      /* **************************************************************************************** */
      FIND Almmmate WHERE Almmmate.codcia = s-codcia
          AND Almmmate.codalm = PEDI.AlmDes
          AND Almmmate.codmat = PEDI.CodMat
          NO-LOCK NO-ERROR.
      x-StkAct = 0.
      IF AVAILABLE Almmmate THEN x-StkAct = Almmmate.StkAct.
      IF x-StkAct > 0 THEN DO:
          RUN gn/stock-comprometido-v2.p (PEDI.CodMat, PEDI.AlmDes, YES, OUTPUT s-StkComprometido).
          /* **************************************************************** */
          /* OJO: Cuando se modifica hay que actualizar el STOCK COMPROMETIDO */
          /* **************************************************************** */
          IF pEvento = "NO" THEN DO:
              FIND Facdpedi OF Faccpedi WHERE Facdpedi.codmat = PEDI.codmat NO-LOCK NO-ERROR.
              IF AVAILABLE Facdpedi AND s-StkComprometido > 0 
                  THEN s-StkComprometido = s-StkComprometido - (Facdpedi.CanPed * Facdpedi.Factor).
          END.
      END.
      /* **************************************************************** */
      s-StkDis = x-StkAct - s-StkComprometido.
      IF s-StkDis <= 0 THEN DO:
          /* 24-8-2023: Solo avisa pero no bloquea J.Lopez RE: Acta de reunión del 10-8-2023: Regalos por Escalas del 23/08/2003 */
          pMensaje = 'Regalo/Promoción ' + PEDI.codmat + ' NO tiene Stock Disponible suficiente en el almacén ' + PEDI.AlmDes + CHR(10) +
              'Se continuará con la grabación'.
          DELETE PEDI.
          NEXT.
      END.
      f-Factor = PEDI.Factor.
      x-CanPed = PEDI.CanPed * f-Factor.
      IF s-StkDis < x-CanPed THEN DO:
          /* 24-8-2023: Solo avisa pero no bloquea J.Lopez RE: Acta de reunión del 10-8-2023: Regalos por Escalas del 23/08/2003 */
          pMensaje = 'Regalo/Promoción ' + PEDI.codmat + ' NO tiene Stock Disponible suficiente en el almacén ' + PEDI.AlmDes + CHR(10) +
              'Se continuará con la grabación'.
          DELETE PEDI.
          NEXT.
      END.
  END.
  /* ********************************************************************************************** */
  /* 16/11/2022: NINGUN producto (así sea promocional) debe estar con PRECIO CERO */
  /* ********************************************************************************************** */
  FOR EACH PEDI NO-LOCK:
      IF PEDI.PreUni <= 0 THEN DO:
          pMensaje = 'Producto ' + PEDI.codmat + ' NO tiene Precio Unitario ' + CHR(10) +
              'Se va a abortar la generación del Pedido'.
          RETURN "ADM-ERROR".
      END.
  END.
  IF NOT CAN-FIND(FIRST PEDI NO-LOCK) THEN DO:
      pMensaje = "NO hay items que facturar".
      RETURN 'ADM-ERROR'.
  END.
  /* ********************************************************************************************** */

  RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Verifica-AC) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Verifica-AC Procedure 
PROCEDURE Verifica-AC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF OUTPUT PARAMETER pTpoLic AS LOG NO-UNDO.
  DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

  /* RHC 09/02/17 Luis Urbano solo para condciones de pago 403 */
  
      pTpoLic = NO.       /* Valor por defecto */

      FIND FIRST gn-convt WHERE gn-ConVt.Codig = s-FmaPgo NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-convt OR gn-ConVt.Libre_l03 = NO THEN RETURN 'OK'.      

      /* Control de Facturas Adelantadas */
      DEFINE VARIABLE x-Saldo  AS DECI NO-UNDO.
      DEFINE VARIABLE x-ImpTot AS DECI NO-UNDO.
      DEFINE VARIABLE x-ImpPED AS DECI NO-UNDO.
      DEFINE VARIABLE x-ImpOD  AS DECI NO-UNDO.
      DEFINE VARIABLE x-ImpAC  AS DECI NO-UNDO.

      DEFIN BUFFER b-Faccpedi FOR Faccpedi.

      ASSIGN
          x-Saldo = 0
          x-ImpTot = 0.
      FOR EACH PEDI NO-LOCK:
          x-ImpTot = x-ImpTot + PEDI.ImpLin.
      END.
      /* ****************************************************************************** */
      /* 1ro Buscamos los A/C por aplicar pero que tengan la misma moneda que el pedido */
      /* ****************************************************************************** */
      ASSIGN
          x-ImpAC = 0.
      FOR EACH Ccbcdocu USE-INDEX Llave06 NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
          AND Ccbcdocu.codcli = s-CodCli
          AND Ccbcdocu.flgest = "P"
          AND Ccbcdocu.coddoc = "A/C"
          AND Ccbcdocu.CodMon = s-CodMon:
          IF Ccbcdocu.SdoAct > 0 
              THEN ASSIGN 
                        x-Saldo = x-Saldo + Ccbcdocu.SdoAct 
                        x-ImpAC = x-ImpAC + Ccbcdocu.SdoAct.
      END.

      /* Ajustamos el saldo del A/C */
      /*
      RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
      IF RETURN-VALUE = 'NO' THEN x-Saldo = x-Saldo + x-ImpTot.
      */
      IF x-Saldo <= 0 THEN DO:
          pMensaje = "NO hay A/C por aplicar".
          RETURN 'ADM-ERROR'.
      END.
      /* ****************************************************************************** */
      /* 2do Buscamos PED y O/D en trámite */
      /* ****************************************************************************** */
      DEF VAR x-EstadosValidos AS CHAR NO-UNDO.
      DEF VAR x-FlgEst AS CHAR NO-UNDO.
      DEF VAR k AS INTE NO-UNDO.

      ASSIGN
          x-EstadosValidos = "G,X,T,W,WX,WL,WC,P".
      ASSIGN
          x-ImpPED = 0.
      FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia:
          DO k = 1 TO NUM-ENTRIES(x-EstadosValidos):
              x-FlgEst = ENTRY(k, x-EstadosValidos).
              FOR EACH PEDIDO NO-LOCK WHERE PEDIDO.codcia = s-codcia 
                  AND PEDIDO.coddiv = gn-divi.coddiv
                  AND PEDIDO.coddoc = "PED"
                  AND PEDIDO.flgest = x-FlgEst
                  AND PEDIDO.codcli = s-codcli:
                  IF NOT (PEDIDO.fchven >= TODAY
                          AND PEDIDO.codmon = s-codmon
                          AND PEDIDO.TpoLic = YES) 
                      THEN NEXT.
                  x-Saldo = x-Saldo - PEDIDO.imptot.
                  x-ImpPED = x-ImpPED + PEDIDO.ImpTot.
              END.
          END.
      END.
      /* Ajustamos el saldo de los PEDIDOS */
      /*
      RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
      IF RETURN-VALUE = 'NO' THEN x-ImpPED = x-ImpPED - x-ImpTot.
      */
      ASSIGN
          x-ImpOD = 0.
      FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia,
          EACH ORDEN NO-LOCK WHERE ORDEN.codcia = s-codcia 
          AND ORDEN.coddiv = gn-divi.coddiv
          AND ORDEN.coddoc = "O/D"
          AND ORDEN.codcli = s-codcli
          AND ORDEN.flgest = "P"
          AND ORDEN.codmon = s-codmon,
          FIRST PEDIDO NO-LOCK WHERE PEDIDO.codcia = ORDEN.codcia
          AND PEDIDO.coddoc = ORDEN.codref
          AND PEDIDO.nroped = ORDEN.nroref:
          IF PEDIDO.TpoLic = NO THEN NEXT.
          x-Saldo = x-Saldo - ORDEN.imptot.
          x-ImpOD = x-ImpOD + ORDEN.ImpTot.
      END.
      /*MESSAGE 'cuatro ok' x-saldo x-impod x-imptot.*/
      IF x-Saldo < x-ImpTot THEN DO:
          pMensaje = "SALDO INSUFICIENTE DEL A/C" + CHR(10) + CHR(10) + 
              "Saldo del A/C:                                 " + STRING(x-ImpAC,'ZZZ,ZZZ,ZZ9.99') + CHR(10) +
              "Ped.Logísticos en trámite:             " + STRING(x-ImpPED,'ZZZ,ZZZ,ZZ9.99') + CHR(10) +
              "Ordenes de Despacho en trámite: " + STRING(x-ImpOD,'ZZZ,ZZZ,ZZ9.99') + CHR(10) +
              "---------------------------------------------------" + CHR(10) +
              "SALDO DISPONIBLE:                       " + STRING(x-Saldo,'ZZZ,ZZZ,ZZ9.99') .
          RETURN 'ADM-ERROR'.
      END.
      /* Actualizamos flag de  control */
      pTpoLic = YES.

  RETURN 'OK'.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-verifica-cliente) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verifica-cliente Procedure 
PROCEDURE verifica-cliente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER pxRetVal AS CHAR NO-UNDO.

/* Sacado de la rutina pri/p-verifica-cliente */

/* *********************************************************** */
/* RHC 22/07/2020 El cliente cesado se va a ver por cada canal */
/* *********************************************************** */
DEF VAR LocalValidaCliente AS LOG NO-UNDO.

LocalValidaCliente = YES.
FIND gn-divi WHERE gn-divi.codcia = s-CodCia
    AND gn-divi.coddiv = COTIZACION.coddiv NO-LOCK NO-ERROR.
IF AVAILABLE gn-divi THEN DO:
    FIND Vtamcanal WHERE Vtamcanal.Codcia = s-CodCia 
        AND Vtamcanal.CanalVenta = gn-divi.CanalVenta
        NO-LOCK NO-ERROR.
    IF AVAILABLE Vtamcanal THEN LocalValidaCliente = Vtamcanal.ValidaCliente.
END.
IF LocalValidaCliente = YES THEN DO:
    IF gn-clie.FlgSit = "B" THEN DO:
        pxRetVal = "Cliente esta Bloqueado" + CHR(10) +
            'Comunicarse con el Gestor del Maestro de Clientes'.
        RETURN "ADM-ERROR".
    END.
    IF gn-clie.FlgSit = "I" THEN DO:
        pxRetval =  "Cliente esta Inactivo" + CHR(10) + 
            'Comunicarse con el Administrador o' + CHR(10) +
            'con el Gestor del Maestro de Clientes'.
                    RETURN "ADM-ERROR".
    END.
    IF gn-clie.FlgSit = "C" THEN DO:
        pxRetVal = "Cliente esta Cesado" + CHR(10) +
            'Comunicarse con el Administrador o' + CHR(10) +
            'con el Gestor del Maestro de Clientes'.
        RETURN "ADM-ERROR".
    END.
END.
/* *********************************************************** */
/* *********************************************************** */
CASE pCodDoc:
    WHEN 'COT' OR WHEN 'C/M' OR WHEN 'PET' THEN DO:
        FIND Vtalnegra WHERE Vtalnegra.codcia = s-codcia
            AND Vtalnegra.codcli = COTIZACION.codcli
            NO-LOCK NO-ERROR.
        IF AVAILABLE Vtalnegra THEN DO:            
            /* 25Jul2016, correo de Julissa Calderon */
            pxRetval = "Cliente en la LISTA NEGRA del Area de Créditos" + CHR(10) +
                'Comunicarse con el Gestor Créditos y Cobranzas'.
            RETURN "ADM-ERROR".
        END.
    END.
END CASE.

/* 15/05/2023: Datos obligatorios
    Solo en caso de NO ser un cliente varios
 */
FIND FIRST FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.
IF AVAILABLE FacCfgGn AND FacCfgGn.CliVar <> gn-clie.codcli THEN DO:
    DEF VAR x-Campos AS CHAR NO-UNDO.

    IF TRUE <> (gn-clie.E-Mail > '') OR
        TRUE <> (gn-clie.Transporte[4] > '') OR
        TRUE <> (gn-clie.Telfnos[1] > '') OR
        TRUE <> (gn-clie.Canal > '') OR
        TRUE <> (gn-clie.GirCli > '') OR
        TRUE <> (gn-clie.ClfCom > '') THEN DO:
        x-Campos = "Los siguientes datos NO están registrados en el Maestro General de Clientes:" + CHR(10).
        IF TRUE <> (gn-clie.E-Mail > '') THEN x-Campos = x-Campos + "- E-mail de contacto" + CHR(10).
        IF TRUE <> (gn-clie.Transporte[4] > '') THEN x-Campos = x-Campos + "- E-mail de facturación electrónica" + CHR(10).
        IF TRUE <> (gn-clie.Telfnos[1] > '') THEN x-Campos = x-Campos + "- Teléfono #1" + CHR(10).
        IF TRUE <> (gn-clie.Canal > '') THEN x-Campos = x-Campos + "- Grupo de cliente" + CHR(10).
        IF TRUE <> (gn-clie.GirCli > '') THEN x-Campos = x-Campos + "- Giro" + CHR(10).
        IF TRUE <> (gn-clie.ClfCom > '') THEN x-Campos = x-Campos + "- Sector económico" + CHR(10).
        x-Campos = x-Campos + chr(10) + 
            'Comunicarse con el Administrador o' + CHR(10) +
            'Comunicarse con el Gestor del Maestro de Clientes'.
        pxRetVal = x-Campos.
        RETURN "ADM-ERROR".
    END.
END.

pxRetVal = "".

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-WRITE-DETAIL) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE WRITE-DETAIL Procedure 
PROCEDURE WRITE-DETAIL :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR I-NPEDI AS INTE NO-UNDO.

  /* AHORA SÍ GRABAMOS EL PEDIDO */
  FOR EACH PEDI NO-LOCK, FIRST Almmmatg OF PEDI NO-LOCK BY PEDI.NroItm: 
      I-NPEDI = I-NPEDI + 1.
      CREATE Facdpedi.
      BUFFER-COPY PEDI 
          EXCEPT PEDI.TipVta    /* Campo con valor A, B, C o D */
          TO Facdpedi
          ASSIGN
              Facdpedi.CodCia = Faccpedi.CodCia
              Facdpedi.CodDiv = Faccpedi.CodDiv
              Facdpedi.coddoc = Faccpedi.coddoc
              Facdpedi.NroPed = Faccpedi.NroPed
              Facdpedi.FchPed = Faccpedi.FchPed
              Facdpedi.Hora   = Faccpedi.Hora 
              /* Facdpedi.FlgEst = Faccpedi.FlgEst */ 
              Facdpedi.NroItm = I-NPEDI.
             /* 
                Ic - 23Jun2020, se coordino con Ruben para que no grabe el estado(flgest) 
                en el detalle ya que el storeprocedure lo hace    
             */
  END.
  IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

