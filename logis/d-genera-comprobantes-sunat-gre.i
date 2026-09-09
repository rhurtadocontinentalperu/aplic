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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Aplicacion-de-Adelantos Include 
PROCEDURE Aplicacion-de-Adelantos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF FacCPedi.TpoLic = NO THEN RETURN "OK".
IF LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL') = 0 THEN RETURN "OK".
RUN vtagn/p-aplica-factura-adelantada.r(ROWID(Ccbcdocu)).

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal Include 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  EMPTY TEMP-TABLE PEDI.
  DEF VAR iCountItem AS INT INIT 0 NO-UNDO.
  FOR EACH ITEM BY ITEM.NroItm:
      CREATE PEDI.
      BUFFER-COPY ITEM TO PEDI.
      iCountItem = iCountItem + 1.
      IF iCountItem >= FILL-IN-items THEN LEAVE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Comprobantes Include 
PROCEDURE Crea-Comprobantes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE iCountItem AS INTEGER INITIAL 1 NO-UNDO.

    ASSIGN
        iCountGuide = 1
        pMensaje = "".
    EMPTY TEMP-TABLE T-CDOCU.
    EMPTY TEMP-TABLE T-DDOCU.
    RLOOP:
    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
        /* Correlativo */
        {lib\lock-genericov3.i ~
            &Tabla="FacCorre" ~
            &Condicion="FacCorre.CodCia = s-CodCia ~
            AND FacCorre.CodDiv = s-CodDiv ~
            AND FacCorre.CodDoc = cCodDoc ~
            AND FacCorre.NroSer = INTEGER(COMBO-NroSer)" ~
            &Bloqueo= "EXCLUSIVE-LOCK" ~
            &Accion="RETRY" ~
            &Mensaje="NO" ~
            &tMensaje="pMensaje" ~
            &TipoError="UNDO RLOOP, RETURN 'ADM-ERROR'" ~
            }
        /* Cabecera de Guía */
        RUN proc_CreaCabecera.
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO RLOOP, RETURN 'ADM-ERROR'.

        /* Detalle */
        FOR EACH PEDI, FIRST ITEM WHERE ITEM.CodMat = PEDI.CodMat,
            FIRST Almmmatg OF PEDI NO-LOCK
            BREAK BY PEDI.CodCia BY PEDI.Libre_c05 BY PEDI.Libre_c04 BY PEDI.CodMat:
            CREATE T-DDOCU.
            BUFFER-COPY PEDI TO T-DDOCU.
            ASSIGN
                T-DDOCU.NroItm = iCountItem
                T-DDOCU.CodCia = T-CDOCU.CodCia
                T-DDOCU.CodDiv = T-CDOCU.CodDiv
                T-DDOCU.Coddoc = T-CDOCU.Coddoc
                T-DDOCU.NroDoc = T-CDOCU.NroDoc 
                T-DDOCU.FchDoc = T-CDOCU.FchDoc
                T-DDOCU.CanDes = PEDI.CanAte
                T-DDOCU.impdcto_adelanto[4] = PEDI.Libre_d02.  /* Flete Unitario */
            ASSIGN
                T-DDOCU.Pesmat = Almmmatg.Pesmat * (T-DDOCU.Candes * T-DDOCU.Factor).

            {sunat/sunat-calculo-importes-sku.i &Cabecera="T-CDOCU" &Detalle="T-DDOCU"}

            /* Actualiza Detalle de la Orden de Despacho */
            FIND FIRST Facdpedi WHERE Facdpedi.codcia = ITEM.codcia
                AND Facdpedi.coddiv = ITEM.coddiv
                AND Facdpedi.coddoc = ITEM.coddoc
                AND Facdpedi.nroped = ITEM.nroped
                AND Facdpedi.codmat = ITEM.codmat
                AND Facdpedi.libre_c05 = ITEM.libre_c05    /* Campo de control adicional */
                EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            /* En caso de Lista Express puede que no este registrado el producto */
            IF NOT AVAILABLE Facdpedi THEN DO:
                pMensaje = 'NO se pudo bloquear el código ' + PEDI.codmat + ' de la O/D'.
                UNDO RLOOP, RETURN 'ADM-ERROR'.
            END.
            ASSIGN
                Facdpedi.canate = Facdpedi.canate + PEDI.canate.
            iCountItem = iCountItem + 1.
            /* LLEVAMOS EL SALDO EN EL ARCHIVO DE CONTROL */
            DELETE ITEM.
        END. /* FOR EACH FacDPedi... */
        RUN proc_GrabaTotales.
        /* EN CASO DE CERRAR LAS FACTURAS APLICAMOS EL REDONDEO */
        IF Faccpedi.Importe[2] <> 0 THEN DO:
            /* NOS ASEGURAMOS QUE SEA EL ULTIMO REGISTRO */
            IF NOT CAN-FIND(FIRST Facdpedi OF Faccpedi WHERE (Facdpedi.CanPed - Facdpedi.CanAte) > 0
                            NO-LOCK) THEN DO:
                ASSIGN 
                    T-CDOCU.ImpTot = T-CDOCU.ImpTot + Faccpedi.Importe[2]
                    T-CDOCU.Libre_d02 = Faccpedi.Importe[2]
                    T-CDOCU.ImpVta = ROUND ( (T-CDOCU.ImpTot - T-CDOCU.AcuBon[5])/ ( 1 + T-CDOCU.PorIgv / 100 ) , 2)
                    T-CDOCU.ImpIgv = (T-CDOCU.ImpTot - T-CDOCU.AcuBon[5]) - T-CDOCU.ImpVta
                    T-CDOCU.ImpBrt = T-CDOCU.ImpVta + T-CDOCU.ImpDto + T-CDOCU.ImpExo
                    T-CDOCU.SdoAct = T-CDOCU.ImpTot.
            END.
        END.
        /* FIN DE REDONDEO */
        /* 04/02/2026: Tabla de configuración */
        FIND FIRST Vtatabla WHERE Vtatabla.codcia = s-codcia
            AND Vtatabla.tabla = "CONFIG-VTAS"
            AND Vtatabla.llave_c1 = "MARKETPLACE"
            AND Vtatabla.llave_c2 = "DIVISION"
            AND Vtatabla.llave_c3 = T-CDOCU.DivOri
            NO-LOCK NO-ERROR NO-WAIT.
        IF AVAILABLE Vtatabla THEN DO:
            ASSIGN
                T-CDOCU.FlgEst = "C"
                T-CDOCU.SdoAct = 0
                T-CDOCU.FchCan = TODAY.
        END.
    END.
    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Generacion-de-GR Include 
PROCEDURE Generacion-de-GR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE iCountItem AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VARIABLE lCreaHeader AS LOGICAL NO-UNDO.

    DEF VAR pCodDpto AS CHAR NO-UNDO.
    DEF VAR pCodProv AS CHAR NO-UNDO.
    DEF VAR pCodDist AS CHAR NO-UNDO.
    DEF VAR pZona    AS CHAR NO-UNDO.
    DEF VAR pSubZona AS CHAR NO-UNDO.
    DEF VAR pCodPos  AS CHAR NO-UNDO.

    IF NOT (pEsValesUtilex = NO AND COMBO-BOX-Guias = "SI") THEN RETURN "OK".

    FIND FacCfgGn WHERE FacCfgGn.CodCia = s-CodCia NO-LOCK NO-ERROR.

    /* **************************************************************************** */
    /* 04/07/2022 Registros por cada GR */
    /* **************************************************************************** */
    DEF VAR x-Items_Guias AS INTE NO-UNDO.
    DEF VAR pFormatoImpresion AS CHAR NO-UNDO.

    DEFINE VAR hLibAlmacen AS HANDLE NO-UNDO.
    RUN alm/almacen-library.p PERSISTENT SET hLibAlmacen.

    RUN GR_Formato_Items IN hLibAlmacen (INPUT COMBO-NroSer-Guia,
                                         OUTPUT pFormatoImpresion,
                                         OUTPUT x-Items_Guias).
    DELETE PROCEDURE hLibAlmacen.

/*     x-Items_Guias = FacCfgGn.Items_Guias.       /* Valor por defecto */        */
/*     FIND FIRST FacTabla WHERE FacTabla.codcia = s-codcia AND                   */
/*         FacTabla.tabla = 'CFG_FMT_GR' AND                                      */
/*         FacTabla.codigo = s-coddiv                                             */
/*         NO-LOCK NO-ERROR.                                                      */
/*     IF AVAILABLE FacTabla AND FacTabla.Campo-C[1] > '' THEN DO:                */
/*         ASSIGN x-Items_Guias = INTEGER(FacTabla.Campo-C[1]) NO-ERROR.          */
/*         IF ERROR-STATUS:ERROR = YES THEN x-Items_Guias = FacCfgGn.Items_Guias. */
/*     END.                                                                       */
    /* **************************************************************************** */
    /* **************************************************************************** */

    ASSIGN
        lCreaHeader = TRUE.
    pMensaje = "".
    trloop:
    DO TRANSACTION ON ERROR UNDO trloop, RETURN 'ADM-ERROR' ON STOP UNDO trloop, RETURN 'ADM-ERROR':
        /* Correlativo */
        {lib\lock-genericov3.i &Tabla="FacCorre" ~
            &Condicion="FacCorre.CodCia = s-CodCia ~
            AND FacCorre.CodDoc = 'G/R' ~
            AND FacCorre.CodDiv = s-CodDiv ~
            AND FacCorre.NroSer = INTEGER(COMBO-NroSer-Guia)" ~
            &Bloqueo= "EXCLUSIVE-LOCK NO-ERROR" ~
            &Accion="RETRY" ~
            &Mensaje="NO" ~
            &txtMensaje="pMensaje" ~
            &TipoError="UNDO TRLOOP, RETURN 'ADM-ERROR'" ~
            }

        /* *************************************** */
        /* RHC 11/05/2020 NO va el flete en la G/R */
        /* RHC 13/07/2020 NO va productos DROP SHIPPING */
        /* *************************************** */
        EMPTY TEMP-TABLE T-DDOCU.
        FOR EACH Reporte NO-LOCK WHERE LOOKUP(Reporte.CodDoc, 'FAC,BOL,FAI') > 0, 
            FIRST B-CDOCU OF Reporte NO-LOCK, 
            EACH B-DDOCU OF B-CDOCU NO-LOCK,
            FIRST Almmmatg OF B-DDOCU NO-LOCK,
            FIRST Almtfami OF Almmmatg NO-LOCK:
            CASE TRUE:
                WHEN Almtfami.Libre_c01 = "SV" THEN NEXT.
                OTHERWISE DO:
                    FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia AND
                        VtaTabla.Tabla = "DROPSHIPPING" AND
                        VtaTabla.Llave_c1 = B-DDOCU.CodMat 
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE VtaTabla THEN NEXT.
                END.
            END CASE.
            CREATE T-DDOCU.
            BUFFER-COPY B-DDOCU TO T-DDOCU.
        END.

        FOR EACH Reporte NO-LOCK WHERE LOOKUP(Reporte.CodDoc, 'FAC,BOL,FAI') > 0, 
            FIRST B-CDOCU OF Reporte NO-LOCK, 
            EACH T-DDOCU OF B-CDOCU NO-LOCK,
            FIRST Almmmatg OF T-DDOCU NO-LOCK
            BREAK BY Reporte.CodCia BY Reporte.NroDoc BY T-DDOCU.NroItm:
            /* Cabecera */
            IF lCreaHeader THEN DO:
                CREATE CcbCDocu.
                BUFFER-COPY B-CDOCU
                    TO CcbCDocu
                    ASSIGN
                    CcbCDocu.CodDiv = s-CodDiv
                    CcbCDocu.CodDoc = "G/R"
                    CcbCDocu.NroDoc =  STRING(FacCorre.NroSer,ENTRY(1,x-FormatoGUIA,'-')) + 
                                        STRING(FacCorre.Correlativo,ENTRY(2,x-FormatoGUIA,'-')) 
                    CcbCDocu.FchDoc = TODAY
                    CcbCDocu.CodRef = B-CDOCU.CodDoc
                    CcbCDocu.NroRef = B-CDOCU.NroDoc
                    CcbCDocu.FlgEst = "F"   /* FACTURADO */
                    CcbCDocu.usuario = S-USER-ID
                    CcbCDocu.TpoFac = "A"     /* AUTOMATICA (No descarga stock) */
                    NO-ERROR.
                IF ERROR-STATUS:ERROR THEN DO:
                    pMensaje = "Mal configurado el correlativo de la G/R o duplicado".
                    UNDO trloop, RETURN 'ADM-ERROR'.
                END.
                ASSIGN
                    FacCorre.Correlativo = FacCorre.Correlativo + 1.
                /* ************************************************************* */
                /* RHC De acuerdo a la sede le cambiamos la dirección de entrega */
                /* ************************************************************* */
                RUN logis/p-lugar-de-entrega (INPUT Faccpedi.CodDoc,
                                              INPUT Faccpedi.NroPed,
                                              OUTPUT FILL-IN-LugEnt).
                ASSIGN
                    CcbCDocu.LugEnt  = FILL-IN-LugEnt.
                RUN gn/fUbigeo (INPUT Faccpedi.CodDiv,
                                INPUT Faccpedi.CodDoc,
                                INPUT Faccpedi.NroPed,
                                OUTPUT pCodDpto,
                                OUTPUT pCodProv,
                                OUTPUT pCodDist,
                                OUTPUT pCodPos,
                                OUTPUT pZona,
                                OUTPUT pSubZona).

                ASSIGN
                    CcbCDocu.CodDpto = pCodDpto
                    CcbCDocu.CodProv = pCodProv
                    CcbCDocu.CodDist = pCodDist.
                /* ************************************************************* */
                /* ************************************************************* */
                /* RHC 22/07/2015 COPIAMOS DATOS DEL TRANSPORTISTA */
                FIND FIRST T-CcbADocu NO-LOCK NO-ERROR.
                IF AVAILABLE T-CcbADocu THEN DO:
                    FIND FIRST B-ADOCU WHERE B-ADOCU.codcia = Ccbcdocu.codcia
                        AND B-ADOCU.coddiv = Ccbcdocu.coddiv
                        AND B-ADOCU.coddoc = Ccbcdocu.coddoc
                        AND B-ADOCU.nrodoc = Ccbcdocu.nrodoc
                        NO-ERROR.
                    IF NOT AVAILABLE B-ADOCU THEN CREATE B-ADOCU.
                    BUFFER-COPY T-CcbADocu 
                        TO B-ADOCU
                        ASSIGN
                            B-ADOCU.CodCia = Ccbcdocu.CodCia
                            B-ADOCU.CodDiv = Ccbcdocu.CodDiv
                            B-ADOCU.CodDoc = Ccbcdocu.CodDoc
                            B-ADOCU.NroDoc = Ccbcdocu.NroDoc.
                    FIND gn-provd WHERE gn-provd.CodCia = pv-codcia AND
                        gn-provd.CodPro = B-ADOCU.Libre_C[9] AND
                        gn-provd.Sede   = B-ADOCU.Libre_C[20] AND
                        CAN-FIND(FIRST gn-prov OF gn-provd NO-LOCK)
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE gn-provd THEN
                        ASSIGN
                        CcbCDocu.CodAge  = gn-provd.CodPro
                        CcbCDocu.CodDpto = gn-provd.CodDept 
                        CcbCDocu.CodProv = gn-provd.CodProv 
                        CcbCDocu.CodDist = gn-provd.CodDist 
                        CcbCDocu.LugEnt2 = gn-provd.DirPro.
                END.
                ASSIGN
                    lCreaHeader = FALSE.
            END.
            /* Detalle */
            CREATE Ccbddocu.
            BUFFER-COPY T-DDOCU 
                TO Ccbddocu
                ASSIGN
                    CcbDDocu.NroItm = iCountItem
                    Ccbddocu.coddiv = Ccbcdocu.coddiv
                    Ccbddocu.coddoc = Ccbcdocu.coddoc
                    Ccbddocu.nrodoc = Ccbcdocu.nrodoc.                        
            iCountItem = iCountItem + 1.
            IF iCountItem > x-Items_Guias OR LAST-OF(Reporte.CodCia) OR LAST-OF(Reporte.NroDoc)
                THEN DO:
                RUN proc_GrabaTotalesGR.
                iCountItem = 1.
                lCreaHeader = TRUE.
            END.
        END.
    END.
    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Comprobantes Include 
PROCEDURE Graba-Comprobantes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

pMensaje = "".
PRIMERO:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH T-CDOCU NO-LOCK:
        CREATE Ccbcdocu.
        BUFFER-COPY T-CDOCU TO Ccbcdocu NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pMensaje = "Correlativo errado o duplicado: " + T-CDOCU.coddoc + " " +  T-CDOCU.nrodoc.
            UNDO PRIMERO, RETURN 'ADM-ERROR'.
        END.
        FOR EACH T-DDOCU OF T-CDOCU NO-LOCK:
            CREATE Ccbddocu.
            BUFFER-COPY T-DDOCU TO Ccbddocu NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                pMensaje = "Correlativo errado o duplicado: " + T-CDOCU.coddoc + " " +  T-CDOCU.nrodoc.
                UNDO PRIMERO, RETURN 'ADM-ERROR'.
            END.
        END.
        /* ****************************************************************************************** */
        CREATE Reporte.
        BUFFER-COPY Ccbcdocu TO Reporte.    /* OJO: Control de Comprobantes Generados */
        /* *********************************************************************** */
        /* RHC 12/10/2020 CONTROL MR: Control KPI de despacho por O/D */
        /* *********************************************************************** */
        DEFINE VAR hMaster AS HANDLE NO-UNDO.
        RUN gn/master-library.r PERSISTENT SET hMaster.
        RUN ML_Actualiza-FAC-Control IN hMaster (INPUT ROWID(Ccbcdocu),     /* FAC */
                                                 OUTPUT pMensaje).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO PRIMERO, RETURN 'ADM-ERROR'.
        DELETE PROCEDURE hMaster.
        /* *********************************************************************** */
        /* CALCULO DE PERCEPCIONES */
        /* *********************************************************************** */
        RUN vta2/calcula-percepcion.r( ROWID(Ccbcdocu) ).
        FIND CURRENT Ccbcdocu EXCLUSIVE-LOCK.

        /* ******************************* */
        /* RHC 22/11/2019 OTROS DESCUENTOS */
        /* ******************************* */
        DEFINE VAR z-hProc AS HANDLE NO-UNDO.           /* Handle Libreria */
        RUN sunat\p-otros-descuentos-sunat.p PERSISTENT SET z-hProc.
        /* *********************************************************************** */
        /* Otros descuentos */
        /* *********************************************************************** */
        RUN descuento-logistico IN z-hProc (INPUT Ccbcdocu.coddiv,
                                            INPUT Ccbcdocu.coddoc,
                                            INPUT Ccbcdocu.nrodoc,
                                            OUTPUT pMensaje).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            DELETE PROCEDURE z-hProc.                   /* Release Libreria */
            UNDO PRIMERO, RETURN 'ADM-ERROR'.
        END.
        /* *********************************************************************** */
        /* Descuentos por PRONTO PAGO/DESPACHO (A/C) */
        /* *********************************************************************** */
        IF FacCPedi.TpoLic = YES THEN DO:
            /* Otros descuentos */
            SESSION:SET-WAIT-STATE("GENERAL").
            RUN descuento-por-pronto-pago IN z-hProc (INPUT Ccbcdocu.coddiv,
                                          INPUT Ccbcdocu.coddoc,
                                          INPUT Ccbcdocu.nrodoc,
                                          OUTPUT pMensaje).
            SESSION:SET-WAIT-STATE("").

            IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                DELETE PROCEDURE z-hProc.                   /* Release Libreria */
                UNDO PRIMERO, RETURN 'ADM-ERROR'.
            END.
        END.
        DELETE PROCEDURE z-hProc.                       /* Release Libreria */
        /* *********************************************************************** */
        /* RHC 30-11-2006 Transferencia Gratuita */
        /* *********************************************************************** */
        IF LOOKUP(Ccbcdocu.FmaPgo, '900,899') > 0 THEN Ccbcdocu.sdoact = 0.
        IF Ccbcdocu.sdoact <= 0 
        THEN ASSIGN
                Ccbcdocu.fchcan = TODAY
                Ccbcdocu.flgest = 'C'.
        /* ****************************************************************************************** */
        /* Importes SUNAT */
        /* 05/08/2022: Pre-calculo para ser usado en APLICACION DE ANTICIPOS */
        /* ****************************************************************************************** */
        DEF VAR hProc AS HANDLE NO-UNDO.
        RUN sunat/sunat-calculo-importes PERSISTENT SET hProc.
        RUN tabla-ccbcdocu IN hProc (INPUT Ccbcdocu.CodDiv,
                                     INPUT Ccbcdocu.CodDoc,
                                     INPUT Ccbcdocu.NroDoc,
                                     OUTPUT pMensaje).
        IF pMensaje = "OK" THEN pMensaje = "".
        IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
        /* ****************************************************************************************** */
        /* *********************************************************************** */
        /* APLICACION DE ADELANTOS */
        /* *********************************************************************** */
        RUN Aplicacion-de-Adelantos.
        IF RETURN-VALUE = "ADM-ERROR" THEN DO:
            IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo generar las N/C por aplicación de A/C".
            UNDO PRIMERO, RETURN 'ADM-ERROR'.
        END.
        /* ****************************************************************************************** */
        /* Importes SUNAT */
        /* ****************************************************************************************** */
        RUN tabla-ccbcdocu IN hProc (INPUT Ccbcdocu.CodDiv,
                                     INPUT Ccbcdocu.CodDoc,
                                     INPUT Ccbcdocu.NroDoc,
                                     OUTPUT pMensaje).
        IF pMensaje = "OK" THEN pMensaje = "".
        IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
        DELETE PROCEDURE hProc.
        /* ****************************************************************************************** */
        /* *********************************************************************** */
        /* RHC 12.07.2012 limpiamos campos para G/R */
        /* *********************************************************************** */
        ASSIGN
            Ccbcdocu.codref = ""
            Ccbcdocu.nroref = "".
        /* solo va a sevir para el mismo día */
        IF pOrigen = "MOSTRADOR" THEN DO:
            FIND FIRST w-report WHERE w-report.Llave-I = Ccbcdocu.codcia
                AND w-report.Campo-C[1] = Ccbcdocu.coddoc
                AND w-report.Campo-C[2] = Ccbcdocu.nrodoc      
                AND w-report.Llave-C = "IMPCAJA"
                AND w-report.Llave-D = Ccbcdocu.fchdoc
                AND w-report.Task-No = INTEGER(Ccbcdocu.coddiv)
                NO-ERROR.
            IF NOT AVAILABLE w-report THEN CREATE w-report.
            ASSIGN
            w-report.Llave-I = Ccbcdocu.codcia
            w-report.Campo-C[1] = Ccbcdocu.coddoc
            w-report.Campo-C[2] = Ccbcdocu.nrodoc      
            w-report.Llave-C = "IMPCAJA"
            w-report.Llave-D = Ccbcdocu.fchdoc
            w-report.Task-No = INTEGER(Ccbcdocu.coddiv).
        END.
        /* *********************************************************************** */
        /* ACTUALIZAMOS ALMACENES */
        /* *********************************************************************** */
        RUN vta2/act_almv2.r ( INPUT ROWID(CcbCDocu), OUTPUT pMensaje ).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            IF TRUE <> (pMensaje > "") THEN pMensaje = "ERROR: NO se pudo actualizar el Kardex".
            UNDO PRIMERO, RETURN 'ADM-ERROR'.
        END.
        /* *********************************************************************** */
        /* RHC 14/10/2020 Control FIFO productos por # de Serie */
        /* *********************************************************************** */
        RUN gn/master-library PERSISTENT SET hMaster.
        RUN ML_Actualiza-FIFO-Control IN hMaster (INPUT ROWID(Ccbcdocu),     /* FAC */
                                                  OUTPUT pMensaje).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO PRIMERO, RETURN 'ADM-ERROR'.
        DELETE PROCEDURE hMaster.
    END.
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_CreaCabecera Include 
PROCEDURE proc_CreaCabecera :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Ic - 01Feb2017, es serie de Comprobante diferido */                                  

DEFINE VAR x-fechaemision AS DATE.
DEFINE VAR cDivOri AS CHAR NO-UNDO.
DEFINE VAR x-fecha-vcto AS DATE.

cDivOri = FacCPedi.CodDiv.  /* Por defecto */
IF AVAILABLE COTIZACION THEN cDivOri = COTIZACION.CodDiv.

x-fechaemision = TODAY.
IF pEsSerieDiferido = YES THEN DO:
    /* Ic - 01Feb2017, la fecha de emision el ultimo dia del mes anterior */
    x-fechaemision = DATE(MONTH(TODAY),1,YEAR(TODAY)) - 1.
END.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* ******************************************* */
    /* RHC 24/11/2015 Control de LISTA DE TERCEROS */
    /* ******************************************* */
    IF AVAILABLE COTIZACION AND COTIZACION.TipBon[10] > 0 THEN DO:
        FIND Gn-clie WHERE Gn-clie.codcia = cl-codcia
            AND Gn-clie.codcli = Faccpedi.codcli
            EXCLUSIVE-LOCK NO-ERROR.
        IF ERROR-STATUS:ERROR AND LOCKED(Gn-clie) THEN DO:
            MESSAGE 'NO se pudo actualizar el control de LISTA DE TERCEROS en el cliente'
                VIEW-AS ALERT-BOX ERROR.
            UNDO, RETURN 'ADM-ERROR'.
        END.
        ASSIGN
            Gn-clie.Libre_d01 = MAXIMUM(Gn-clie.Libre_d01, COTIZACION.TipBon[10]).
    END.
    FIND Gn-clie WHERE Gn-clie.codcia = cl-codcia
        AND Gn-clie.codcli = Faccpedi.codcli
        NO-LOCK NO-ERROR.
    /* ******************************************* */
    CREATE T-CDOCU.
    BUFFER-COPY FacCPedi 
        EXCEPT Faccpedi.ImpDto2 Faccpedi.PorDto Faccpedi.Importe
        TO T-CDOCU
        ASSIGN
        T-CDOCU.CodDiv = s-CodDiv
        T-CDOCU.DivOri = cDivOri    /* OJO: division de estadisticas */
        T-CDOCU.CodAlm = FacCPedi.CodAlm   /* OJO: Almacén despacho */
        T-CDOCU.CodDoc = cCodDoc
        T-CDOCU.NroDoc =  STRING(FacCorre.NroSer,ENTRY(1,x-FormatoFAC,'-')) + 
                            STRING(FacCorre.Correlativo,ENTRY(2,x-FormatoFAC,'-')) 
        T-CDOCU.FchDoc = x-fechaemision /* TODAY , Ic - 01Feb2017 */
        T-CDOCU.CodMov = cCodMov
        T-CDOCU.CodRef = FacCPedi.CodDoc           /* CONTROL POR DEFECTO */
        T-CDOCU.NroRef = FacCPedi.NroPed
        T-CDOCU.Libre_c01 = FacCPedi.CodDoc        /* CONTROL ADICIONAL */
        T-CDOCU.Libre_c02 = FacCPedi.NroPed
        T-CDOCU.Libre_c04 = (IF cCodDoc = "TCK" AND AVAILABLE gn-clie AND gn-clie.libre_c01 = "J" THEN "FAC" ELSE "")     /* Para TCK */
        T-CDOCU.CodPed = FacCPedi.CodRef
        T-CDOCU.NroPed = FacCPedi.NroRef
        T-CDOCU.FchVto = x-fechaemision /* TODAY , Ic - 01Feb2017 */
        T-CDOCU.CodAnt = FacCPedi.Atencion     /* DNI */
        T-CDOCU.TpoCmb = FacCfgGn.TpoCmb[1]
        T-CDOCU.NroOrd = FacCPedi.ordcmp
        T-CDOCU.FlgEst = IF (pEsValesUtilex = YES ) THEN "E" ELSE "P"
        T-CDOCU.TpoFac = "CR"                  /* CREDITO */
        T-CDOCU.Tipo   = "CREDITO"  /*pOrigen*/
        T-CDOCU.CodCaja= pCodTer
        T-CDOCU.usuario = S-USER-ID
        T-CDOCU.HorCie = STRING(TIME,'hh:mm')
        T-CDOCU.LugEnt = FILL-IN-LugEnt     /* OJO */
        T-CDOCU.LugEnt2 = FacCPedi.LugEnt2
        T-CDOCU.Glosa = FILL-IN-Glosa
        T-CDOCU.FlgCbd = FacCPedi.FlgIgv
        T-CDOCU.Sede   = FacCPedi.Sede.     /* <<< SEDE DEL CLIENTE <<< */

    /* Datos de los descuentos globales Ic - Enero2025*/
    ASSIGN T-CDOCU.mrguti = FacCPedi.porcent[2]     /* %Dscto */
            T-CDOCU.impint = FacCPedi.porcent[1].   /* Importe */

    /* RHC 18/02/2016 LISTA EXPRESS WEB */          
    IF COTIZACION.TpoPed = "LF" 
        THEN ASSIGN
                T-CDOCU.ImpDto2   = COTIZACION.ImpDto2       /* Descuento TOTAL CON IGV */
                T-CDOCU.Libre_d01 = COTIZACION.Importe[3].   /* Descuento TOTAL SIN IGV */
    /* **************************** */
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    FIND FIRST gn-convt WHERE gn-convt.Codig = T-CDOCU.FmaPgo NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt THEN DO:
        T-CDOCU.TipVta = IF gn-ConVt.TotDias = 0 THEN "1" ELSE "2".
        /*T-CDOCU.FchVto = T-CDOCU.FchDoc + INTEGER(ENTRY(NUM-ENTRIES(gn-ConVt.Vencmtos),gn-ConVt.Vencmtos)).*/
    END.
    /* Ic - 29Set2018, a pedido de jukiisa calderon */
    RUN gn/fecha-vencimiento-cond-vta.r(INPUT T-CDOCU.FmaPgo, INPUT T-CDOCU.FchDoc, OUTPUT x-fecha-vcto).
    ASSIGN T-CDOCU.FchVto = x-fecha-vcto.

    FIND gn-clie WHERE gn-clie.CodCia = cl-codcia 
        AND gn-clie.CodCli = T-CDOCU.CodCli 
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie  THEN DO:
        ASSIGN
            T-CDOCU.CodDpto = gn-clie.CodDept 
            T-CDOCU.CodProv = gn-clie.CodProv 
            T-CDOCU.CodDist = gn-clie.CodDist.
    END.
    /* Guarda Centro de Costo */
    FIND gn-ven WHERE
        gn-ven.codcia = s-codcia AND
        gn-ven.codven = T-CDOCU.codven
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-ven THEN T-CDOCU.cco = gn-ven.cco.
    /* RHC 22/07/2015 COPIAMOS DATOS DEL TRANSPORTISTA */
    FIND FIRST T-CcbADocu NO-LOCK NO-ERROR.
    IF AVAILABLE T-CcbADocu THEN DO:
        FIND FIRST B-ADOCU WHERE B-ADOCU.codcia = T-CDOCU.codcia
            AND B-ADOCU.coddiv = T-CDOCU.coddiv
            AND B-ADOCU.coddoc = T-CDOCU.coddoc
            AND B-ADOCU.nrodoc = T-CDOCU.nrodoc
            NO-ERROR.
        IF NOT AVAILABLE B-ADOCU THEN CREATE B-ADOCU.
        BUFFER-COPY T-CcbADocu 
            TO B-ADOCU
            ASSIGN
                B-ADOCU.CodCia = T-CDOCU.CodCia
                B-ADOCU.CodDiv = T-CDOCU.CodDiv
                B-ADOCU.CodDoc = T-CDOCU.CodDoc
                B-ADOCU.NroDoc = T-CDOCU.NroDoc.
        /* ACTUALIZAMOS ORDEN DE DESPACHO */
        /* RHC 18/09/2019 Solo si NO va es un DEJADO EN TIENDA */
        IF FacCPedi.DT = NO AND B-ADOCU.Libre_C[9] > '' THEN DO:  /* AGENCIA DE TRANSPORTE */
            FIND gn-provd WHERE gn-provd.CodCia = pv-codcia AND 
                gn-provd.CodPro = B-ADOCU.Libre_C[9] AND 
                gn-provd.Sede   = B-ADOCU.Libre_C[20]
                NO-LOCK NO-ERROR.
            IF AVAILABLE gn-provd THEN DO:
                FIND TabDistr WHERE TabDistr.CodDepto = gn-provd.CodDept 
                    AND TabDistr.CodProvi = gn-provd.CodProv 
                    AND TabDistr.CodDistr = gn-provd.CodDist
                    NO-LOCK NO-ERROR.
                IF AVAILABLE TabDistr THEN DO:
                    ASSIGN
                        FacCPedi.Ubigeo[1] = gn-provd.Sede
                        FacCPedi.Ubigeo[2] = "@PV"
                        FacCPedi.Ubigeo[3] = gn-provd.CodPro.
            END.
          END.
      END.
    END.
    /* ******************************** */
    /* TRACKING GUIAS */
    RUN vtagn/pTracking-04 (s-CodCia,
                            s-CodDiv,
                            T-CDOCU.CodPed,
                            T-CDOCU.NroPed,
                            s-User-Id,
                            'EFAC',
                            'P',
                            DATETIME(TODAY, MTIME),
                            DATETIME(TODAY, MTIME),
                            T-CDOCU.coddoc,
                            T-CDOCU.nrodoc,
                            T-CDOCU.Libre_c01,
                            T-CDOCU.Libre_c02).
    s-FechaT = DATETIME(TODAY, MTIME).
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_GrabaTotales Include 
PROCEDURE proc_GrabaTotales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Rutina General */
    {vtagn/i-total-factura-sunat.i &Cabecera="T-CDOCU" &Detalle="T-DDOCU"}


    /*
    /* Caso Lista Express */
    IF COTIZACION.TpoPed = "LF"  THEN ASSIGN T-CDOCU.SdoAct = 0 T-CDOCU.FlgEst = "C".
    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_GrabaTotalesGR Include 
PROCEDURE proc_GrabaTotalesGR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{vta2/graba-totales-factura-cred.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Resumen-Temporal Include 
PROCEDURE Resumen-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Cargamos informacion de Zonas y Ubicaciones */
    FOR EACH PEDI:
        ASSIGN
            PEDI.Libre_c04 = "G-0"
            PEDI.Libre_c05 = "G-0".
        FIND FIRST Almmmate WHERE Almmmate.CodCia = s-CodCia
            AND Almmmate.CodAlm = PEDI.AlmDes
            AND Almmmate.CodMat = PEDI.CodMat
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmate THEN DO:
            ASSIGN 
                PEDI.Libre_c04 = Almmmate.CodUbi.
            FIND Almtubic WHERE Almtubic.codcia = s-codcia
                AND Almtubic.codubi = Almmmate.codubi
                AND Almtubic.codalm = Almmmate.codalm
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almtubic THEN PEDI.Libre_c05 = Almtubic.CodZona.
        END.
    END.
    /* RHC 15/03/17 DESCUENTO POR LISTA EXPRESS */
    IF COTIZACION.TpoPed = "LF" THEN DO:      /* LISTA EXPRESS */
        FOR EACH PEDI:
            FIND Facdpedi OF Faccpedi WHERE Facdpedi.codmat = PEDI.codmat NO-LOCK NO-ERROR.
            IF AVAILABLE Facdpedi THEN PEDI.ImpDto2 = Facdpedi.ImpDto2.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

