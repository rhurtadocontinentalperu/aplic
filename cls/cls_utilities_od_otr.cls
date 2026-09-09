/* ******************************************************************* */
CLASS cls_utilities_od_otr:
    DEFINE PRIVATE STATIC VARIABLE iCodCia AS INTEGER NO-UNDO.
    DEFINE PRIVATE STATIC VARIABLE cCodDiv AS CHARACTER NO-UNDO.
    DEFINE PRIVATE STATIC VARIABLE iclCodCia AS INTEGER NO-UNDO.

    /* ******************************************************************* */
    CONSTRUCTOR PUBLIC cls_utilities_od_otr (INPUT piCodCia AS INTE, 
                                             INPUT pcCodDiv AS CHAR,
                                             INPUT pclCodCia AS INTE
                                             ):
        SUPER().
        cls_utilities_od_otr:iCodCia = piCodCia.
        cls_utilities_od_otr:cCodDiv = pcCodDiv.
        cls_utilities_od_otr:iclCodCia = pclCodCia.

    END CONSTRUCTOR.


    /* ******************************************************************* */
    /* RUTINA MASTER */
    /* ******************************************************************* */
    METHOD PUBLIC LOGICAL PED_Despachar_Rutina_Master(
        BUFFER bPedido FOR Faccpedi,
        INPUT plProcesoBatch AS LOG,
        INPUT pcUserId AS CHAR,
        OUTPUT pcMensaje AS CHAR,
        OUTPUT pcAviso AS CHAR
        ):
        IF NOT AVAILABLE bPedido THEN DO:
            pcMensaje = "Pedido no registrado".
            RETURN FALSE.
        END.

        /* OJO: Solo PEDidos GENERADOS */  
        IF bPedido.flgest <> "G" THEN DO:
            pcMensaje = "El pedido ya NO está por aprobar". 
            RETURN FALSE.
        END.
        /* ****************************************************************************** */
        /* 
            Ic - 23Jun2020, para casos de pedido de 002 - CONTADO ANTICIPADO
            que aun no haya actualizado la BD
        */
        /* ****************************************************************************** */
        DEFINE VAR x-fmapago AS CHAR NO-UNDO.
        DEFINE VAR x-boleta-deposito AS CHAR NO-UNDO.
        DEFINE VAR x-retval AS CHAR NO-UNDO.  
        DEFINE VAR pNroOD AS CHAR NO-UNDO.
        
        x-fmapago = bPedido.fmapgo.
        x-boleta-deposito = bPedido.libre_c03.
        IF x-fmapago = '002' THEN DO:
            IF TRUE <> (x-boleta-deposito > "") THEN DO:
                pcMensaje = "Imposible realizar despacho" + CHR(10) +
                    "para CONTADO ANTICIPADO, debe asignar la BD APROBADO".
                RETURN FALSE.
            END.
            /* Verificamos que la condicion de venta este asignado a esa division  */
            DEFINE VAR hVentasLibrary AS HANDLE NO-UNDO.
            RUN vtagn/ventas-library.p  PERSISTENT SET hVentasLibrary.
            RUN VTA_cond-vta_division IN hVentasLibrary (INPUT x-fmapago, 
                                                         INPUT bPedido.coddiv, 
                                                         OUTPUT x-retval).
            DELETE PROCEDURE hVentasLibrary.
            IF x-retval = 'NO' THEN DO:
                pcMensaje =  "La condicion de venta (" + x-fmapago + ")" + CHR(10) +
                        "No esta asignado a la división de venta (" + bPedido.coddiv + ")".
                RETURN FALSE.
            END.
        END.
        /* ****************************************************************************** */
        DEF VAR iCuenta AS INTE NO-UNDO.
        DEF VAR pDT AS LOG NO-UNDO.
        DEF VAR pAlmacenDT AS CHAR NO-UNDO.
        DEF VAR pCrossDocking AS LOG NO-UNDO.
        DEF VAR pAlmacenXD AS CHAR NO-UNDO.
        DEF VAR k AS INT NO-UNDO.
        
        DEF BUFFER B-DESTINO FOR Almacen.
        DEF BUFFER B-ORIGEN  FOR Almacen.
        
        /* ****************************************************************************** */
        /* RHC 23/07/20196 Ciclo de Dejado en Tienda */
        /* ****************************************************************************** */
        IF plProcesoBatch = NO THEN DO:
            /* OJO: NO permite una ventana tipo "dialog" */
            RUN logis/d-dejado-en-tienda (OUTPUT pDT, OUTPUT pAlmacenDT).
            IF pAlmacenDT = "ERROR" THEN RETURN TRUE.
        END.
        IF pDT = YES THEN DO k = 1 TO NUM-ENTRIES(bPedido.CodAlm):
            FIND FIRST B-DESTINO WHERE B-DESTINO.codcia = iCodCia
                AND B-DESTINO.codalm = ENTRY(k, bPedido.CodAlm)
                NO-LOCK.
            FIND FIRST B-ORIGEN WHERE B-ORIGEN.codcia = iCodCia
                AND B-ORIGEN.codalm = pAlmacenDT
                NO-LOCK.
            IF B-DESTINO.CodDiv = B-ORIGEN.CodDiv THEN DO:
                pcMensaje = 'NO se puede generar para el mismo CD'.
                RETURN FALSE.
            END.
        END.
        /* ****************************************************************************** */
        /* ****************************************************************************** */
        IF plProcesoBatch = NO THEN DO:
            MESSAGE 'El Pedido está listo para ser despachado' SKIP 'Continuamos?'
                  VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
            IF rpta = NO THEN RETURN FALSE.
            /* Ic - 30Set2024, reunion Carla Tenazoa, pedido desde Riqra no considerar transportista */
            /* Revisar datos del Transportista */
            FIND FIRST Ccbadocu WHERE Ccbadocu.codcia = bPedido.codcia
                AND Ccbadocu.coddiv = bPedido.coddiv
                AND Ccbadocu.coddoc = bPedido.coddoc
                AND Ccbadocu.nrodoc = bPedido.nroped
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Ccbadocu THEN DO:    
                MESSAGE 'Aún NO ha ingresado los datos del transportista' SKIP 'Continuamos?'
                    VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE rpta-1 AS LOG.
                IF rpta-1 = NO THEN RETURN FALSE.
            END.
        END.
        
        DEF VAR pFchEnt AS DATE NO-UNDO.
        
        RLOOP:
        DO TRANSACTION ON ERROR UNDO, RETURN FALSE ON STOP UNDO, RETURN FALSE:
            /* Bloqueamos PEDIDO */
            FIND CURRENT bPedido EXCLUSIVE-LOCK.
            IF bPedido.flgest <> "G" THEN DO:
                pcMensaje = 'El Pedido ya fue aprobado por:' + CHR(10) +
                    'Usuario: ' + bPedido.UsrAprobacion + CHR(10) +
                    'Fecha: ' + STRING(bPedido.FchAprobacion) + CHR(10) + CHR(10) +
                    'Proceso abortado'.
                UNDO RLOOP, RETURN FALSE.
            END.
            /* ****************************************************************************** */
            /* Reactualizamos la Fecha de Entrega                                             */
            /* ****************************************************************************** */
            pFchEnt = bPedido.FchEnt.      /* OJO */
            IF bPedido.Ubigeo[2] <> "@PV" THEN DO:
                pFchEnt = bPedido.Libre_f02.   /* Pactada con el cliente */
                /* LA RUTINA VA A DECIDIR SI EL CALCULO ES POR UBIGEO O POR GPS */
                RUN logis/p-fecha-de-entrega (bPedido.CodDoc,              /* Documento actual */
                                              bPedido.NroPed,
                                              INPUT-OUTPUT pFchEnt,
                                              OUTPUT pcMensaje).
                IF pcMensaje > '' THEN UNDO, RETURN FALSE.
            END.
            ASSIGN
                bPedido.FchEnt = pFchEnt.
        
            /* ****************************************************************************** */
            DEF VAR lExito AS LOG NO-UNDO.
            lExito = CCB_Verifica_Cliente (
                BUFFER bPedido,
                OUTPUT pcMensaje, 
                OUTPUT pcAviso).
            IF lExito = NO THEN UNDO, RETURN FALSE.
        
            /* RHC 19/02/2018 Cross Docking */
            ASSIGN                  
                bPedido.AlmacenDT      = pAlmacenDT
                bPedido.DT             = pDT
                bPedido.CrossDocking   = pCrossDocking
                bPedido.AlmacenXD      = pAlmacenXD.    /* Almacén que despacha al cliente */
            /* ********************************************************************************************** */
            /* CONTROL DE SEDE Y UBIGEO: POR CLIENTE */
            /* ********************************************************************************************** */
            IF bPedido.DT = YES THEN DO:
                ASSIGN
                    bPedido.Ubigeo[1] = bPedido.AlmacenDT
                    bPedido.Ubigeo[2] = "@ALM"
                    bPedido.Ubigeo[3] = bPedido.AlmacenDT.
            END.
            
            /* ********************************************************************************************** */
            /* *********************************************************************** */
            /* APROBACION DEL PEDIDO */
            /* *********************************************************************** */
            IF bPedido.FlgEst = "P" THEN DO:
               /* TRACKING */
                FIND Almacen OF bPedido NO-LOCK.
                RUN vtagn/pTracking-04 (iCodCia,
                                  Almacen.CodDiv,
                                  bPedido.CodDoc,
                                  bPedido.NroPed,
                                  pcUserId,
                                  'ANP',
                                  'P',
                                  DATETIME(TODAY, MTIME),
                                  DATETIME(TODAY, MTIME),
                                  bPedido.coddoc,
                                  bPedido.nroped,
                                  bPedido.coddoc,
                                  bPedido.nroped).
            END.
            IF bPedido.FlgEst = "X" THEN DO:
                /* ******************************* */
                /* RHC 17/08/2018 TRACKING DE CONTROL */
                /* ******************************* */
                RUN vtagn/pTracking-04 (iCodCia,
                                  cCodDiv,
                                  bPedido.CodDoc,
                                  bPedido.NroPed,
                                  pcUserId,
                                  'PANPX',
                                  'P',
                                  DATETIME(TODAY, MTIME),
                                  DATETIME(TODAY, MTIME),
                                  bPedido.CodDoc,
                                  bPedido.NroPed,
                                  bPedido.CodRef,
                                  bPedido.NroRef).
            END.
        
            /* ********************************************************************************************** */
            /* SI NO HA SIDO APROBADO ENTONCES NO GENERA ORDEN DE DESPACHO */
            /* ********************************************************************************************** */
            IF bPedido.FlgEst <> "P" THEN LEAVE.
        
            /* ********************************************************************************************** */
            /* DEPENDIENDO DE SI ES CROSSDOCKING O NO GENERA UNA O/D O UNA OTR */
            /* OJO: En esta rutina SIEMPRE PEDIDO.CrossDocking = NO */
            /* ********************************************************************************************** */
            CASE bPedido.CrossDocking:
                WHEN NO THEN DO:
                    RUN OD_Generacion_Rutina_Master (NO,
                                                     OUTPUT pNroOD,
                                                     OUTPUT pcMensaje).
                    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN FALSE.
                    pcAviso = "Orden de Despacho = " + pNroOD.
                END.
                WHEN YES THEN DO:
                    /* Por aquí NUNCA pasa (¿?) */
                    RUN OTR_Generacion_por_CrossDocking (NO,
                                                     OUTPUT pNroOD,
                                                     OUTPUT pcMensaje).
                    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN FALSE.
                    pcAviso = "Orden de Transferencia = " + pNroOD.
                END.
            END CASE.
        END.
    END METHOD.

    METHOD PRIVATE LOGICAL CCB_Verifica_Cliente(BUFFER bPedido FOR Faccpedi,
                                                OUTPUT pcMensaje AS CHAR,
                                                OUTPUT pcAviso AS CHAR).
        
        /* *********************************************************************** */
        /* RUTINA ESTANDAR */
        /* *********************************************************************** */
        DEF VAR lExito AS LOG NO-UNDO.

        lExito = CCB_Verifica_Cliente_FmaPgo (BUFFER bPedido,
                                              OUTPUT pcAviso).
        IF lExito = NO THEN RETURN FALSE.
        
        /* *********************************************************************** 
            PARA CONTADO ANTICIPADO
            01Oct2019, Susana Leon converso con Daniel Llican y en coordinacion
                        con Julisa calderon, cuando la boleta de deposito (BD) es inferior 
                        al monto del pedido se debe derivar a la bandeja de CyC
        *********************************************************************** */
        DEFINE VAR x-doc-deposito AS CHAR.
        
        x-doc-deposito = TRIM(bPedido.usrchq).
        IF TRUE <> (bPedido.usrchq > "") THEN x-doc-deposito = "BD".
        
        IF bPedido.fmapgo = '002' AND bPedido.FlgEst = "P" THEN DO:
            FIND FIRST Ccbcdocu WHERE Ccbcdocu.codcia = iCodCia
                AND Ccbcdocu.coddoc = x-doc-deposito        /* BD o A/R */
                AND Ccbcdocu.nrodoc = bPedido.Libre_c03
                AND Ccbcdocu.codcli = bPedido.CodCli
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Ccbcdocu OR Ccbcdocu.flgest <> 'P' OR Ccbcdocu.SdoAct <= 0
                THEN DO:
                pcMensaje = x-doc-deposito + " " + bPedido.Libre_c03 + " NO existe o no pertenece al cliente".
                RETURN FALSE.
            END.
            IF Ccbcdocu.FmaPgo <> bPedido.fmapgo THEN DO:
                pcMensaje =  'La condición de venta del " + bPedido.usrchq + " " + bPedido.Libre_c03 + " NO es CONTADO ANTICIPADO'.
                RETURN FALSE.
            END.
            /*
                01Oct2019, Susana Leon converso con Daniel Llican y en coordinacion
                            con Julisa calderon, cuando la boleta de deposito (BD) es inferior 
                            al monto del bPedido se debe derivar a la bandeja de CyC
            */            
            IF bPedido.CodMon = Ccbcdocu.CodMon THEN DO:
                IF Ccbcdocu.sdoact < bPedido.imptot THEN DO:
                    ASSIGN 
                        bPedido.flgest = 'X'
                        bPedido.Libre_c05 = 'EL MONTO DEL " + bPedido.usrchq + " " + bPedido.Libre_c03 +" ES INFERIOR AL MONTO DEL bPedido'
                        bPedido.Libre_c04 = '- PASA POR EVALUACION DE CREDITO'.
                END.
            END.
            ELSE DO:
                IF Ccbcdocu.codmon = 1 THEN DO:
                    IF Ccbcdocu.sdoact < (bPedido.imptot * bPedido.Tpocmb) THEN DO:
                        ASSIGN 
                            bPedido.flgest = 'X'
                            bPedido.Libre_c05 = 'EL MONTO DEL " + bPedido.usrchq + " " + bPedido.Libre_c03 + " ES INFERIOR AL MONTO DEL bPedido'
                            bPedido.Libre_c04 = '- PASA POR EVALUACION DE CREDITO'.
                    END.
                END.
                ELSE DO:
                    IF Ccbcdocu.sdoact < (bPedido.imptot / bPedido.Tpocmb) THEN DO:
                        ASSIGN 
                            bPedido.flgest = 'X'
                            bPedido.Libre_c05 = 'EL MONTO DEL " + bPedido.usrchq + " " + bPedido.Libre_c03 + " ES INFERIOR AL MONTO DEL bPedido'
                            bPedido.Libre_c04 = '- PASA POR EVALUACION DE CREDITO'.
                    END.
                END.
            END.
        END.   
        /* *********************************************************************** */
        /* VERIFICAMOS MARGEN DE UTILIDAD */
        /* *********************************************************************** */
        IF LOOKUP(bPedido.Lista_de_Precios, '00000,00017,00018') > 0 THEN DO:
            RUN VTA_Margen_de_Utilidad.
            IF bPedido.FlgEst = "W" THEN DO:
                pcAviso = "Margen Utilidad!" + bPedido.Libre_c05.
            END.
        END.
        
        /* 01Oct2019 - Fin */
        RETURN TRUE.

    END METHOD.

    METHOD PRIVATE LOGICAL CCB_Verifica_Cliente_FmaPgo (BUFFER bPedido FOR Faccpedi,
                                                        OUTPUT pcAviso AS CHAR):

        DEFINE VAR x-cliente-ubicacion AS CHAR.
        DEFINE VAR x-tolerancia-dias AS INT.
        DEFINE VAR x-stk-letras AS INT.
        DEFINE VAR x-stk-letras-del-cliente AS INT.
    
        DEFINE BUFFER bClied FOR gn-clied.
    
        /* ************************************************************ */
        /* 29/03/17 CLIENTES ESPECIALES SE APRUEBAN AUTOMATICAMENTE */
        /* ************************************************************ */
        FIND FIRST gn-cliex WHERE gn-cliex.CodCia = iclCodCia
            AND gn-cliex.CodUnico = bPedido.codcli
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-cliex THEN DO:
            ASSIGN
                bPedido.FlgEst = "P".
            RETURN TRUE.
        END.
    
        /* ************************************************************ */
        /* Ic - 05Feb2021 19:41pm,  conversamos con Susana y luego verificar */
        /* Condiciones de ventas especiales 001 y 002 */
        /* ************************************************************ */
        IF LOOKUP(bPedido.fmapgo,"001,002") = 0 THEN DO:
            FIND FIRST gn-convt WHERE gn-ConVt.Codig = bPedido.FmaPgo NO-LOCK NO-ERROR.
            /* Los CONTADO se aprueban automáticamente */
            IF AVAILABLE gn-convt AND gn-convt.tipvta = "1" THEN DO:
                ASSIGN
                    bPedido.FlgEst = "P".
                RETURN TRUE.
            END.
        END.
        /* TAMPOCO EXPOLIBRERIA CONTADO CONTRA-ENTREGA */
        IF bPedido.TpoPed = "E" AND bPedido.FmaPgo = '001' THEN DO:
            ASSIGN
                bPedido.FlgEst = "P".
            RETURN TRUE.
        END.
        /* ********************************************************************************* */
        /* CONTADO CONTRAENTREGA Y TRANSFERENCIAS GRATUITAS NECESITAN APROBACION OBLIGATORIA */
        /* ********************************************************************************* */
        /* 25/08/17 Acuerdo de reunión, correo del 24/08/17 */
        IF LOOKUP(bPedido.fmaPgo,"001,900,899") > 0 THEN DO:
            ASSIGN 
                bPedido.Flgest = 'X'   /* x CC */
                bPedido.Glosa  = TRIM (bPedido.Glosa) + '//Cond.Cred.'
                bPedido.Libre_c05 = 'CONDICION DE VENTA'.
            pcAviso = 'Por la condición de venta debe ser aprobado por Créditos ó administrador'.
            RETURN TRUE.
        END.
        /* ********************************************************************************* */
        /* Ic 27Set2019 - Direccion de clientes es de CLIENTE moroso no pasa */
        /* ********************************************************************************* */
        DEF VAR hLibreriaCcb AS HANDLE NO-UNDO.
        FIND FIRST bClied WHERE bClied.codcia = iclCodCia
           AND bClied.codcli = bPedido.codcli
           AND bClied.sede = bPedido.sede NO-LOCK NO-ERROR.
        IF AVAILABLE bClied THEN DO:
            DEFINE VAR x-moroso AS CHAR.
            RUN ccb\libreria-ccb PERSISTENT SET hLibreriaCcb.   
            x-moroso = "".
            RUN direccion-de-moroso IN hLibreriaCcb (INPUT bPedido.codcli, 
                                                     INPUT bClied.dircli,
                                                     INPUT bPedido.fmapgo,
                                                     OUTPUT x-moroso).        
            DELETE PROCEDURE hLibreriaCcb.
            IF x-moroso > "" THEN DO:
                ASSIGN
                    bPedido.Flgest = 'X'
                    bPedido.Glosa  = TRIM (bPedido.Glosa) 
                    bPedido.Libre_c05 = 'DIRECCION DE ENTREGA, PERTENECE A CLIENTE MOROSO(' + x-moroso + ')'
                    bPedido.Libre_c04 = '- PASA POR EVALUACION DE CREDITO'.
                pcAviso = 'Direccion de entrega de cliente moroso!!'.
                RETURN TRUE.
            END.
        END.
        /* ********************************************************************************* */
        /* POR LA LINEA DE CREDITO: Contado NO verifica la línea de crédito */
        /* RHC 12/06/18 La línea de crédito de todo el grupo si fuera el caso */
        /* 28/11/2024 Gina Condor */
        /* Reemplazar vta2/linea-de-credito-v2 por vta2/linea-de-credito-disponible */
        /* ********************************************************************************* */
        /*RUN vta2/linea-de-credito-disponible (bPedido.CodDiv,*/
        RUN vta2/linea-de-credito-v2 (bPedido.CodDiv,
                                      bPedido.CodCli,
                                      bPedido.FmaPgo,
                                      bPedido.CodMon,
                                      0,
                                      NO).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            ASSIGN 
                bPedido.Flgest = 'X'
                bPedido.Glosa  = TRIM (bPedido.Glosa) + '//Linea Credito'
                bPedido.Libre_c05 = 'SUPERA LA LINEA DE CREDITO'
                bPedido.Libre_c04 = ' - SUPERA LA LINEA DE CREDITO'.
            pcAviso = bPedido.Libre_c05.
            RETURN TRUE.
        END.
    
        ASSIGN 
            bPedido.Libre_c04 = ' - IMPORTE DENTRO DE LA LINEA DE CREDITO'.
    
        /* ********************************************************************************* */
        /* DEUDA VENCIDA */
        /* 12/06/18 De cualquier cliente del grupo */
        /* ********************************************************************************* */
        DEF VAR LocalMaster AS CHAR.
        DEF VAR LocalRelacionados AS CHAR.
        DEF VAR LocalAgrupados AS LOG.
        DEF VAR LocalCliente AS CHAR NO-UNDO.
    
        RUN ccb/p-cliente-master (bPedido.CodCli,
                                  OUTPUT LocalMaster,
                                  OUTPUT LocalRelacionados,
                                  OUTPUT LocalAgrupados).
        IF LocalAgrupados = YES AND LocalRelacionados > '' THEN DO:
        END.
        ELSE DO:
            LocalRelacionados = bPedido.CodCli.
        END.
        /* DOCUMENTOS CON DEUDA VENCIDA */
        /* Ic - 11Ago2020 - FIN, correo Sr. Rodolfo Salas del 11Ago2020 : Notificación: Notas de Crédito */
        DEFINE VAR x-dias-tolerables AS INT.
        DEFINE VAR x-tabla-cyc AS CHAR.        
        DEFINE VAR iCliente AS INTE NO-UNDO.
    
        x-tabla-cyc = "APR.PED|DOCMNTOS".
        /* Cliente de LIMA o PROVINCIA */
        DEF VAR hVentasLibrary AS HANDLE NO-UNDO.
        RUN vtagn/ventas-library PERSISTENT SET hVentasLibrary.
        RUN VTA_ubicacion-cliente IN hVentasLibrary (INPUT bPedido.codcli, OUTPUT x-cliente-ubicacion).
        IF TRUE <> (x-cliente-ubicacion > "") THEN x-cliente-ubicacion = "CUALQUIERCOSA".
        /* Barremos tolerancia por defecto (8 horas en promedio) */
        FOR EACH factabla WHERE factabla.codcia = iCodCia AND factabla.tabla = x-tabla-cyc NO-LOCK:
            x-dias-tolerables = 0.
            IF bPedido.fmapgo = '002' THEN DO:
                /* CONTADO ANTICIPADO */
                RUN VTA_tolerancia-dias-vctos IN hVentasLibrary (INPUT factabla.codigo, 
                                                                 INPUT bPedido.coddiv,
                                                                 INPUT bPedido.codcli, 
                                                                 INPUT x-cliente-ubicacion, /* x-ubicli = "" : que la rutina calcule la ubicacion del cliente*/
                                                                 OUTPUT x-dias-tolerables).
            END.
            ELSE DO:
                x-dias-tolerables = factabla.valor[1].
            END.                
            IF x-dias-tolerables < 0 THEN x-dias-tolerables = 0.
    
            DO iCliente = 1 TO NUM-ENTRIES(LocalRelacionados):
                FIND FIRST CcbCDocu WHERE CcbCDocu.CodCia = bPedido.CodCia
                    AND CcbCDocu.CodCli = ENTRY(iCLiente, LocalRelacionados)
                    AND CcbCDocu.FlgEst = "P" 
                    AND CcbCDocu.CodDoc = factabla.codigo                  /* FAC,BOL,CHQ,LET,N/D */
                    AND (CcbCDocu.FchVto + x-dias-tolerables ) < TODAY    /* 8 dias + de plazo */
                    NO-LOCK NO-ERROR. 
                IF AVAIL CcbCDocu THEN DO:
                    ASSIGN
                        bPedido.Flgest = 'X'
                        bPedido.Glosa  = TRIM (bPedido.Glosa) + '//Doc. Venc.'
                        bPedido.Libre_c05 = 'DEUDA VENCIDA: ' + Ccbcdocu.coddoc + ' ' + Ccbcdocu.nrodoc.
                    pcAviso = "El cliente/grupo tiene una deuda atrazada:" + CHR(13) + CHR(10) +
                        "Cliente : " + TRIM(Ccbcdocu.nomcli) + CHR(13) + CHR(10) +
                        "Documento : " + TRIM(Ccbcdocu.coddoc) + " " + TRIM(Ccbcdocu.nrodoc) + CHR(13) + CHR(10) +
                        "Vencimiento : " + STRING(Ccbcdocu.fchvto,"99/99/9999").
                    RETURN TRUE.
                END.
            END.
        END.        
        DELETE PROCEDURE hVentasLibrary.
        /* Ic - 11Ago2020 - FIN */
    
        /* ********************************************************************************* */
        /* RHC 15/11/18 Solicitado por Luis Figueroa               
            Si tiene línea de crédito
            Si no tiene deudas mayores a 8 días
            Si tiene al menos una letra frimada en blanco
           Ic - 29Oct2019, correo de Julissa se valida contra la cantidad de letras
                que se ingreso en la condicion de venta
                Si el Stock de Letras es < que las letras requeridas segun Cond.Venta pasa por aprobacion
                de CyC, de lo contrario se aprueba en automatico
        */
        /* ********************************************************************************* */
        x-stk-letras = 0.
        x-stk-letras-del-cliente = 0.
        FIND FIRST gn-convt WHERE gn-ConVt.Codig = bPedido.FmaPgo NO-LOCK NO-ERROR.
        IF AVAILABLE gn-convt  THEN x-stk-letras = gn-convt.libre_d01.  /* Cantidad de letras que requiere la condicion de venta */
        IF x-stk-letras < 0 THEN x-stk-letras = 0.
        IF x-stk-letras > 0 THEN DO:
            /* Si la condicion de venta tiene cargada cantida de letras */
            FIND FIRST ccbstklet WHERE ccbstklet.codcia = iCodCia AND
                ccbstklet.codclie = bPedido.CodCli NO-LOCK NO-ERROR.
            IF AVAILABLE ccbstklet THEN x-stk-letras-del-cliente = ccbstklet.qstklet.
            /* 21Oct2022 - Ana Huaman si la condicion de venta indica stock de letras, se debe validar a todas las ventas */
            IF x-stk-letras-del-cliente < x-stk-letras THEN DO:
                ASSIGN
                    bPedido.Flgest = 'X'
                    bPedido.Glosa  = TRIM (bPedido.Glosa) 
                    bPedido.Libre_c05 = 'NO TIENE STOCK DE LETRAS (' + STRING(x-stk-letras-del-cliente) + ')'
                    bPedido.Libre_c04 = '- PASA POR EVALUACION DE CREDITO'.
                pcAviso = 'El cliente NO tiene Stock de Letras!!'.
                RETURN TRUE.
            END.            
        END.
    
        /* **************************************************** */
        /* CANJE CON LETRAS POR ACEPTAR/APROBAR */
        /* **************************************************** */
        /* Dias de Tolerancia */
        x-tolerancia-dias = 15.
        IF x-cliente-ubicacion = "CUALQUIERCOSA" THEN x-cliente-ubicacion = "LIMA". /* x compatibilidad, si no tiene ubicacion asume LIMA segun Julissa */
        FIND FIRST FacTabla WHERE FacTabla.codcia = iCodCia AND
            FacTabla.tabla = "APR.PED|LT.X.ACEPTAR" AND   /* APROBACION bPedidoS, LETRAS X ACEPTAR */
            FacTabla.codigo = x-cliente-ubicacion NO-LOCK NO-ERROR.
        IF AVAILABLE FacTabla THEN x-tolerancia-dias = FacTabla.valor[1].
        FIND FIRST Ccbcdocu WHERE Ccbcdocu.codcia = bPedido.codcia
            AND CcbCDocu.CodCli = bPedido.Codcli
            AND Ccbcdocu.flgest = "X" 
            AND Ccbcdocu.coddoc = 'LET'
            AND (TODAY - Ccbcdocu.FchDoc) >= x-tolerancia-dias  /* 15 */
            NO-LOCK NO-ERROR.
        IF AVAILABLE Ccbcdocu THEN DO:
            ASSIGN
                bPedido.Flgest = 'X'
                bPedido.Glosa  = TRIM (bPedido.Glosa) + '//CANJE POR LETRA POR APROBAR'
                bPedido.Libre_c05 = 'Cliente tiene letra pendiente por ACEPTAR ' + Ccbcdocu.CodRef + ' ' + Ccbcdocu.NroRef + ' ' + STRING(Ccbcdocu.FchDoc,"99/99/9999").
            pcAviso = bPedido.Libre_c05.
            RETURN TRUE.
        END.
    
        /* ********************************************************************************* */
        /* RHC 08.05.2012 PEDIDOS DE SUPERMERCADOS PASAN OBLIGADO POR SEC GG GG*/
        /* ********************************************************************************* */
        IF bPedido.coddiv = '00017' THEN DO:
            ASSIGN
                bPedido.Flgest = 'W'
                bPedido.Glosa  = TRIM (bPedido.Glosa) + '//Supermercados'
                bPedido.Libre_c05 = 'SUPERMERCADOS' + bPedido.Libre_c04.
            RETURN TRUE.
        END.
        /* *********************************************************************** */
        /* APROBAMOS EL PEDIDO */
        /* *********************************************************************** */
        IF bPedido.FlgEst = "G" THEN bPedido.FlgEst = "P".
    
        /* *********************************************************************** */
        /* 27/09/2019 TRAMITE DOCUMENTARIO: Forzamos la aprobar por COMERCIAL  */
        /* 23/10/2019 TRAMITE DOCUMENTARIO: Forzamos la aprobar por CC y CC  */
        /* bPedido.TipVta = "Si" = Tramite documentario */
        /* *********************************************************************** */
        IF bPedido.TipVta = "Si" AND bPedido.FlgEst = "P" THEN DO:
            ASSIGN
                bPedido.Flgest = "X"
                bPedido.Glosa  = TRIM(bPedido.Glosa) 
                bPedido.Libre_c05 = 'TRAMITE DOCUMENTARIO'.
        END.
    
        RETURN TRUE.

    END METHOD.

END CLASS.
