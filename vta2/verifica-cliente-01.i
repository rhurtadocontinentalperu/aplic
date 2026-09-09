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


DEFINE BUFFER x-factabla FOR factabla.

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
         HEIGHT             = 7.46
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

DEFINE VAR OK AS LOGICAL NO-UNDO.
DEFINE VAR X-CREUSA AS DECIMAL NO-UNDO.
DEFINE VARIABLE I-ListPr     AS INTEGER NO-UNDO.
DEFINE VARIABLE F-MRGUTI     AS INTEGER NO-UNDO.
DEFINE VARIABLE dImpTot      AS DECIMAL NO-UNDO.
DEFINE VARIABLE T-SALDO      AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-totdias    AS INTEGER NO-UNDO.
DEFINE VARIABLE t-Resultado  AS CHAR    NO-UNDO.

DEFINE VAR x-cliente-ubicacion AS CHAR.
DEFINE VAR x-tolerancia-dias AS INT.
DEFINE VAR x-stk-letras AS INT.
DEFINE VAR x-stk-letras-del-cliente AS INT.

IF FacCPedi.Flgest = 'G' THEN DO:
    /* ****************************** */
    /* POR DEFECTO TODO ESTA APROBADO */
    /* ****************************** */
    ASSIGN 
        OK = TRUE.
        /*Faccpedi.FlgEst = "P".*/
    /* ****************************** */
    LOOPCONTROL:
    DO:     /* BLOQUE DE CONTROL */
        /* RHC 29/03/17 CLIENTES ESPECIALES SE APRUEBAN AUTOMATICAMENTE */
        FIND FIRST gn-cliex WHERE gn-cliex.CodCia = cl-codcia
            AND gn-cliex.CodUnico = Faccpedi.codcli
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-cliex THEN LEAVE LOOPCONTROL.
        /* ************************************************************ */
        /* VENTA CONTADO TAMBIEN */
        IF FacCPedi.fmapgo = "000" THEN DO:
            LEAVE LOOPCONTROL.
        END.

        IF LOOKUP(FacCPedi.fmapgo,"001,002") = 0 THEN DO:
            /* Ic - 05Feb2021 19:41pm,  conversamos con Susana y luego verifcar */
            FIND FIRST gn-convt WHERE gn-ConVt.Codig = Faccpedi.FmaPgo NO-LOCK NO-ERROR.
            IF AVAILABLE gn-convt  THEN DO:
                IF gn-convt.tipvta = "1" THEN DO: /* LOS CONTADO SE SALEN */
                    LEAVE LOOPCONTROL.
                END.
            END.
        END.

        /* TAMPOCO EXPOLIBRERIA CONTADO CONTRA-ENTREGA */
        IF FacCPedi.TpoPed = "E" AND FacCPedi.FmaPgo = '001' THEN DO:
            LEAVE LOOPCONTROL.
        END.

        /* ********************************************************************************* */
        /* CONTADO CONTRAENTREGA Y TRANSFERENCIAS GRATUITAS NECESITAN APROBACION OBLIGATORIA */
        /* ********************************************************************************* */
        /* RHC 25/08/17 Acuerdo de reunión, correo del 24/08/17 */
        IF LOOKUP(FacCPedi.fmaPgo,"001,900,899") > 0 THEN DO:
            ASSIGN 
                FacCPedi.Flgest = 'X'   /* x CC */
                FacCPedi.Glosa  = TRIM (FacCPedi.Glosa) + '//Cond.Cred.'
                FacCPedi.Libre_c05 = 'CONDICION DE VENTA'.
            &IF DEFINED(VarMensaje) > 0 &THEN
            {&VarMensaje} = 'Por la condición de venta debe ser aprobado por Créditos ó administrador'.
            &ENDIF
            LEAVE LOOPCONTROL.
        END.
        /* Ic 27Set2019 - Direccion de clientes es de CLIENTE moroso no pasa */
        FIND FIRST gn-clied WHERE gn-clied.codcia = cl-codcia
           AND gn-clied.codcli = Faccpedi.codcli
           AND gn-clied.sede = Faccpedi.sede NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clieD THEN DO:
            DEFINE VAR hProc AS HANDLE NO-UNDO.
            DEFINE VAR x-moroso AS CHAR.

            RUN ccb\libreria-ccb PERSISTENT SET hProc.   
            x-moroso = "".

            RUN direccion-de-moroso IN hProc (INPUT faccpedi.codcli, 
                                              INPUT gn-clied.dircli,
                                              INPUT faccpedi.fmapgo,
                                              OUTPUT x-moroso).        
            IF x-moroso > "" THEN DO:
                ASSIGN
                    FacCPedi.Flgest = 'X'
                    FacCPedi.Glosa  = TRIM (FacCPedi.Glosa) 
                    FacCPedi.Libre_c05 = 'DIRECCION DE ENTREGA, PERTENECE A CLIENTE MOROSO(' + x-moroso + ')'
                    FacCPedi.Libre_c04 = '- PASA POR EVALUACION DE CREDITO'.

                &IF DEFINED(VarMensaje) > 0 &THEN
                    {&VarMensaje} = 'Direccion de entrega de cliente moroso!!'.
                &ENDIF
                LEAVE LOOPCONTROL.
            END.
            DELETE PROCEDURE hProc.
        END.
        /* **************************************************** */
        /* POR LA LINEA DE CREDITO: Contado NO verifica la línea de crédito */
        /* RHC 12/06/18 La línea de crédito de todo el grupo si fuera el caso */
        /* 28/11/2024 Gina Condor */
        /* Reemplazar vta2/linea-de-credito-v2 por vta2/linea-de-credito-disponible */
        RUN vta2/linea-de-credito-v2 (Faccpedi.CodDiv,
        /*RUN vta2/linea-de-credito-disponible (Faccpedi.CodDiv,*/
                                      Faccpedi.CodCli,
                                      Faccpedi.FmaPgo,
                                      Faccpedi.CodMon,
                                      0,
                                      NO).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            ASSIGN 
                FacCPedi.Flgest = 'X'
                FacCPedi.Glosa  = TRIM (FacCPedi.Glosa) + '//Linea Credito'
                FacCPedi.Libre_c05 = 'SUPERA LA LINEA DE CREDITO'
                FacCPedi.Libre_c04 = ' - SUPERA LA LINEA DE CREDITO'.
            &IF DEFINED(VarMensaje) &THEN
            {&VarMensaje} = FacCPedi.Libre_c05.
            &ENDIF
            LEAVE LOOPCONTROL.
        END.
        ASSIGN 
            FacCPedi.Libre_c04 = ' - IMPORTE DENTRO DE LA LINEA DE CREDITO'.
        /* DEUDA VENCIDA */
        /* RHC 12/06/18 De cualquier cliente del grupo */
        DEF VAR LocalMaster AS CHAR.
        DEF VAR LocalRelacionados AS CHAR.
        DEF VAR LocalAgrupados AS LOG.
        DEF VAR LocalCliente AS CHAR NO-UNDO.

        RUN ccb/p-cliente-master (Faccpedi.CodCli,
                                  OUTPUT LocalMaster,
                                  OUTPUT LocalRelacionados,
                                  OUTPUT LocalAgrupados).

        IF LocalAgrupados = YES AND LocalRelacionados > '' THEN DO:
        END.
        ELSE DO:
            LocalRelacionados = Faccpedi.CodCli.
        END.

        /* Ic - 11Ago2020 - FIN, correo Sr. Rodolfo Salas del 11Ago2020 : Notificación: Notas de Crédito */
        DEFINE VAR x-dias-tolerables AS INT.
        DEFINE VAR x-tabla-cyc AS CHAR.        

        x-tabla-cyc = "APR.PED|DOCMNTOS".
        /* Cliente de LIMA o PROVINCIA */
        RUN VTA_ubicacion-cliente (INPUT faccpedi.codcli, OUTPUT x-cliente-ubicacion).

        IF x-cliente-ubicacion = "" THEN x-cliente-ubicacion = "CUALQUIERCOSA".

        /* DOCUMENTOS CON DEUDA VENCIDA */
        DEF VAR iCliente AS INTE NO-UNDO.
        /* Barremos tolerancia por defecto (8 horas en promedio) */
        FOR EACH factabla WHERE factabla.codcia = s-codcia AND factabla.tabla = x-tabla-cyc NO-LOCK:
            x-dias-tolerables = 0.
            IF faccpedi.fmapgo = '002' THEN DO:
                /* CONTADO ANTICIPADO */
                RUN VTA_tolerancia-dias-vctos(INPUT factabla.codigo, 
                                              INPUT faccpedi.coddiv,
                                              INPUT faccpedi.codcli, 
                                              INPUT x-cliente-ubicacion, /* x-ubicli = "" : que la rutina calcule la ubicacion del cliente*/
                                              OUTPUT x-dias-tolerables).
            END.
            ELSE DO:
                x-dias-tolerables = factabla.valor[1].
            END.                
            IF x-dias-tolerables < 0 THEN x-dias-tolerables = 0.

            DO iCliente = 1 TO NUM-ENTRIES(LocalRelacionados):
                FIND FIRST CcbCDocu WHERE CcbCDocu.CodCia = FacCPedi.CodCia
                    AND CcbCDocu.CodCli = ENTRY(iCLiente, LocalRelacionados)
                    /*AND  CAN-DO(LocalRelacionados, CcbCDocu.CodCli)*/
                    AND CcbCDocu.FlgEst = "P" 
                    AND CcbCDocu.CodDoc = factabla.codigo                  /* FAC,BOL,CHQ,LET,N/D */
                    AND (CcbCDocu.FchVto + x-dias-tolerables ) < TODAY    /* 8 dias + de plazo */
                    NO-LOCK NO-ERROR. 
                IF AVAIL CcbCDocu THEN DO:
                    ASSIGN
                        FacCPedi.Flgest = 'X'
                        FacCPedi.Glosa  = TRIM (FacCPedi.Glosa) + '//Doc. Venc.'
                        FacCPedi.Libre_c05 = 'DEUDA VENCIDA: ' + Ccbcdocu.coddoc + ' ' + Ccbcdocu.nrodoc.
                    &IF DEFINED(VarMensaje) &THEN
                        /*{&VarMensaje} = FacCPedi.Libre_c05.*/
                        {&VarMensaje} = "El cliente/grupo tiene una deuda atrazada:" + CHR(13) + CHR(10) +
                                    "Cliente : " + TRIM(Ccbcdocu.nomcli) + CHR(13) + CHR(10) +
                                    "Documento : " + TRIM(Ccbcdocu.coddoc) + " " + TRIM(Ccbcdocu.nrodoc) + CHR(13) + CHR(10) +
                                    "Vencimiento : " + STRING(Ccbcdocu.fchvto,"99/99/9999").
                    &ENDIF
                    LEAVE LOOPCONTROL.
                END.
            END.
        END.        
        /* Ic - 11Ago2020 - FIN */

        /* RHC 15/11/18 Solicitado por Luis Figueroa               
            Si tiene línea de crédito
            Si no tiene deudas mayores a 8 días
            Si tiene al menos una letra frimada en blanco
            */
        /* **************************************************** */
        /*
            Ic - 29Oct2019, correo de Julissa se valida contra la cantidad de letras
                que se ingreso en la condicion de venta
                
                Si el Stock de Letras es < que las letras requeridas segun Cond.Venta pasa por aprobacion
                de CyC, de lo contrario se aprueba en automatico
        */
        x-stk-letras = 0.
        x-stk-letras-del-cliente = 0.
        FIND FIRST gn-convt WHERE gn-ConVt.Codig = Faccpedi.FmaPgo NO-LOCK NO-ERROR.
        IF AVAILABLE gn-convt  THEN DO:                                                                 /* /*AND gn-convt.tipvta <> "1"*/ SOLO CREDITO */
            x-stk-letras = gn-convt.libre_d01.  /* Cantidad de letras que requiere la condicion de venta */
        END.
        IF x-stk-letras < 0 THEN x-stk-letras = 0.
                
        IF x-stk-letras > 0 THEN DO:
            /* Si la condicion de venta tiene cargada cantida de letras */
            FIND FIRST ccbstklet WHERE ccbstklet.codcia = s-CodCia AND
                        ccbstklet.codclie = Faccpedi.CodCli NO-LOCK NO-ERROR.
            IF AVAILABLE ccbstklet THEN DO:
                x-stk-letras-del-cliente = ccbstklet.qstklet.
            END.

            /* 21Oct2022 - Ana Huaman si la condicion de venta indica stock de letras, se debe validar a todas las ventas */
            IF /*ccbstklet.qstklet*/ x-stk-letras-del-cliente < x-stk-letras THEN DO:
                ASSIGN
                    FacCPedi.Flgest = 'X'
                    FacCPedi.Glosa  = TRIM (FacCPedi.Glosa) 
                    FacCPedi.Libre_c05 = 'NO TIENE STOCK DE LETRAS (' + STRING(x-stk-letras-del-cliente) + ')'
                    FacCPedi.Libre_c04 = '- PASA POR EVALUACION DE CREDITO'.

                &IF DEFINED(VarMensaje) > 0 &THEN
                    {&VarMensaje} = 'El cliente NO tiene Stock de Letras!!'.
                &ENDIF
                LEAVE LOOPCONTROL.
            END.            
        END.

        /* **************************************************** */
        /* CANJE CON LETRAS POR ACEPTAR/APROBAR */

        /* Dias de Tolerancia */
        x-tolerancia-dias = 15.

        IF x-cliente-ubicacion = "CUALQUIERCOSA" THEN x-cliente-ubicacion = "LIMA". /* x compatibilidad, si no tiene ubicacion asume LIMA segun Julissa */

        FIND FIRST x-factabla WHERE x-factabla.codcia = s-codcia AND
                                    x-factabla.tabla = "APR.PED|LT.X.ACEPTAR" AND   /* APROBACION PEDIDOS, LETRAS X ACEPTAR */
                                    x-factabla.codigo = x-cliente-ubicacion NO-LOCK NO-ERROR.
        IF AVAILABLE x-factabla THEN x-tolerancia-dias = x-factabla.valor[1].

        FIND FIRST Ccbcdocu WHERE Ccbcdocu.codcia = Faccpedi.codcia
            AND CcbCDocu.CodCli = FacCPedi.Codcli
            AND Ccbcdocu.flgest = "X" 
            AND Ccbcdocu.coddoc = 'LET'
            AND (TODAY - Ccbcdocu.FchDoc) >= x-tolerancia-dias  /* 15 */
            NO-LOCK NO-ERROR.
        IF AVAILABLE Ccbcdocu THEN DO:
            ASSIGN
                FacCPedi.Flgest = 'X'
                FacCPedi.Glosa  = TRIM (FacCPedi.Glosa) + '//CANJE POR LETRA POR APROBAR'
                /*FacCPedi.Libre_c05 = 'CANJE POR APROBAR: ' + Ccbcdocu.CodRef + ' ' + Ccbcdocu.NroRef.*/
                FacCPedi.Libre_c05 = 'Cliente tiene letra pendiente por ACEPTAR ' + Ccbcdocu.CodRef + ' ' + Ccbcdocu.NroRef + ' ' + STRING(Ccbcdocu.FchDoc,"99/99/9999").
            &IF DEFINED(VarMensaje) &THEN
            {&VarMensaje} = FacCPedi.Libre_c05.
            {&VarMensaje} = FacCPedi.Libre_c05.
            &ENDIF
            LEAVE LOOPCONTROL.
        END.

        /* RHC 08.05.2012 PEDIDOS DE SUPERMERCADOS PASAN OBLIGADO POR SEC GG GG*/
        IF Faccpedi.coddiv = '00017' THEN DO:
            ASSIGN
                FacCPedi.Flgest = 'W'
                FacCPedi.Glosa  = TRIM (FacCPedi.Glosa) + '//Supermercados'
                FacCPedi.Libre_c05 = 'SUPERMERCADOS' + FacCPedi.Libre_c04.
            LEAVE LOOPCONTROL.
        END.
    END.    /* LOOPCONTROL */
    IF Faccpedi.FlgEst = "G" THEN Faccpedi.FlgEst = "P".
    /* ****************************************************************** */
/*     FOR EACH FacDPedi OF FacCPedi EXCLUSIVE-LOCK:                      */
/*         ASSIGN  FacDPedi.Flgest = FacCPedi.Flgest.   /* <<< OJO <<< */ */
/*         RELEASE FacDPedi.                                              */
/*     END.                                                               */
    IF FacCPedi.FlgEst = 'P' THEN DO:    /* APROBACION AUTOMATICA DEL PEDIDO */
       /* TRACKING */
        FIND Almacen OF Faccpedi NO-LOCK.
        RUN vtagn/pTracking-04 (s-CodCia,
                          Almacen.CodDiv,
                          Faccpedi.CodDoc,
                          Faccpedi.NroPed,
                          s-User-Id,
                          'ANP',
                          'P',
                          DATETIME(TODAY, MTIME),
                          DATETIME(TODAY, MTIME),
                          Faccpedi.coddoc,
                          Faccpedi.nroped,
                          Faccpedi.coddoc,
                          Faccpedi.nroped).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


