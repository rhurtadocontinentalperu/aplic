DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-CodDiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-codalm AS CHAR.
DEF VAR s-coddoc AS CHAR INIT 'COT' NO-UNDO.
DEF VAR s-nroser AS INTE NO-UNDO.
DEF VAR s-tpoped AS CHAR NO-UNDO.

/* Datos del Pedido Logistico */
DEF INPUT PARAMETER pCodPed AS CHAR.
DEF INPUT PARAMETER pNroPed AS CHAR.

/* Acumulamos todas las facturas relacionadas a la misma cotización */
DEF TEMP-TABLE ITEM LIKE Facdpedi.

DEF BUFFER COTIZACION FOR Faccpedi.
DEF BUFFER DETALLE FOR Facdpedi.

FIND Faccpedi WHERE Faccpedi.codcia = s-CodCia
    AND Faccpedi.coddoc = pCodPed
    AND Faccpedi.nroped = pNroPed
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccpedi THEN RETURN.

FIND COTIZACION WHERE COTIZACION.codcia = Faccpedi.CodCia
    AND COTIZACION.coddoc = Faccpedi.codref
    AND COTIZACION.nroped = Faccpedi.nroref
    NO-LOCK NO-ERROR.
ASSIGN
    s-TpoPed = COTIZACION.TpoPed.

/* Buscamos que su división genere cotizaciones por bonificaciones */

/* *************************************************************** */
FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = COTIZACION.codcia
    AND Faccpedi.coddoc = 'PED'
    AND Faccpedi.codref = COTIZACION.coddoc
    AND Faccpedi.nroref = COTIZACION.nroped
    AND Faccpedi.flgest <> 'A',
    EACH Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
    AND LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL') > 0
    AND Ccbcdocu.flgest <> 'A'
    AND Ccbcdocu.codped = Faccpedi.coddoc
    AND Ccbcdocu.nroped = Faccpedi.nroped,
    EACH Ccbddocu OF Ccbcdocu NO-LOCK,
    FIRST Facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.codmat = Ccbddocu.codmat
    AND Facdpedi.Libre_c05 <> 'OF',
    FIRST DETALLE OF COTIZACION NO-LOCK WHERE DETALLE.codmat = Ccbddocu.codmat:
    FIND FIRST PEDI WHERE PEDI.codmat = Ccbddocu.codmat EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE PEDI THEN CREATE PEDI.
    ASSIGN
        PEDI.codcia = Ccbddocu.codcia
        PEDI.codmat = Ccbddocu.codmat
        PEDI.canped = PEDI.canped + CcbDDocu.CanDes
        PEDI.factor = Ccbddocu.factor.
    ASSIGN
        PEDI.preuni = (DETALLE.ImpLin - DETALLE.ImpDto2) / DETALLE.CanPed.
END.

&SCOPED-DEFINE Promocion vta2/promocion-generalv2.p

/* ********************************************************************************************** */
/* Las Promociones solo se calculan en el PRIMER PEDIDO */
/* ********************************************************************************************** */
/* RHC 05/05/2014 nueva rutina de promociones */
DEF VAR pMensaje AS CHAR NO-UNDO.
RUN {&Promocion} (COTIZACION.Libre_c01, 
                  COTIZACION.CodCli, 
                  INPUT-OUTPUT TABLE PEDI, 
                  OUTPUT pMensaje).
IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
/* ********************************************************************************************** */

DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    CREATE Faccpedi.
    BUFFER-COPY COTIZACION TO Faccpedi
        ASSIGN
        FacCPedi.FlgEst = "P"
        FacCPedi.CodAlm = ''
        FacCPedi.Cliente_Recoge = NO.
    /* NUEVA COTIZACION */
    ASSIGN
        Faccpedi.Usuario = S-USER-ID
        Faccpedi.Hora   = STRING(TIME,"HH:MM:SS").
    /* RUTINA PRINCIPAL */
    RUN CREATE-TRANSACION.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo generar la cotización'.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* ************************************************************************ */
    /* RHC 13/10/2020 Llican PreVenta: Primer estado de la cotización EVENTOS   */
    /* ************************************************************************ */
    IF s-TpoPed = "E" THEN Faccpedi.FlgEst = 'PV'.     /* Por Aprobar */
    /* ************************************************************************ */
END.
/* Control si el Cliente Recoge */
IF FacCPedi.Cliente_Recoge = NO THEN FacCPedi.CodAlm = ''.
/* ******************************************** */
/* RHC 19/050/2021 Datos para HOMOLOGAR las COT */
/* ******************************************** */
ASSIGN
    FacCPedi.CustomerPurchaseOrder = Faccpedi.OrdCmp.
/* ******************************************** */
/* ******************************************** */
  FOR EACH ITEM WHERE ITEM.ImpLin > 0,
      FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = ITEM.codmat
      BY ITEM.NroItm:
      /* ****************************************************************************** */
      /* VER SI LA DIVISION VERIFICA STOCK */
      /* ****************************************************************************** */
      FIND FacTabla WHERE FacTabla.codcia = s-CodCia AND
          FacTabla.tabla = "GN-DIVI" AND
          FacTabla.codigo = s-CodDiv AND
          FacTabla.campo-L[1] = YES
          NO-LOCK NO-ERROR.
      IF AVAILABLE FacTabla THEN DO:
          DEFINE VARIABLE s-StkComprometido AS DECIMAL NO-UNDO.
          DEFINE VARIABLE x-StkActual AS DECIMAL NO-UNDO.
          DEFINE VARIABLE x-CanPedida AS DECIMAL NO-UNDO.
          DEFINE VARIABLE x-StkDisponible AS DECIMAL NO-UNDO.
          /* Verificamos el stock del primer almacén válido */
          FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA 
              AND  Almmmate.CodAlm = ENTRY(1, s-CodAlm)
              AND  Almmmate.codmat = ITEM.CodMat
              NO-LOCK NO-ERROR.
          IF AVAILABLE Almmmate THEN x-StkActual = Almmmate.StkAct.
          ELSE x-StkActual = 0.
          RUN gn/Stock-Comprometido-v2 (ITEM.CodMat,
                                        ENTRY(1, s-CodAlm),
                                        YES,
                                        OUTPUT s-StkComprometido).
          x-StkDisponible = x-StkActual - s-StkComprometido.
          x-CanPedida = ITEM.CanPed * ITEM.Factor.
          IF x-CanPedida > x-StkDisponible THEN DO:
              pMensaje = "No hay STOCK disponible en el almacén " + ENTRY(1, s-CodAlm) + CHR(10) +
                         "para el producto " + ITEM.CodMat + CHR(10) +
                         "     STOCK ACTUAL : " + STRING(x-StkActual) + CHR(10) +
                         "     COMPROMETIDO : " + STRING(s-StkComprometido).
              UNDO, RETURN 'ADM-ERROR'.
          END.
      END.
      /* ****************************************************************************** */
      /* ****************************************************************************** */
      I-NITEM = I-NITEM + 1.
      CREATE FacDPedi.
      BUFFER-COPY ITEM 
          TO FacDPedi
          ASSIGN
              FacDPedi.CodCia = FacCPedi.CodCia
              FacDPedi.CodDiv = FacCPedi.CodDiv
              FacDPedi.coddoc = FacCPedi.coddoc
              FacDPedi.NroPed = FacCPedi.NroPed
              FacDPedi.FchPed = FacCPedi.FchPed
              FacDPedi.Hora   = FacCPedi.Hora 
              FacDPedi.FlgEst = FacCPedi.FlgEst
              FacDPedi.NroItm = I-NITEM.
  END.
  /* ************************************************************************************** */
  /* DESCUENTOS APLICADOS A TODA LA COTIZACION */
  /* ************************************************************************************** */
  RUN DESCUENTOS-FINALES (OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      IF TRUE <> (pMensaje > '') THEN pMensaje = 'ERROR al aplicar los descuentos totales a la cotización'.
      UNDO, RETURN 'ADM-ERROR'.
  END.
  /* ****************************************************************************************** */
  /* RHC 09/06/2021 Verificamos si todos los productos cumplen con el margen mínimo de utilidad */
  /* ****************************************************************************************** */
  DEF VAR hProc AS HANDLE NO-UNDO.
  RUN pri/pri-librerias PERSISTENT SET hProc.
  RUN PRI_Valida-Margen-Utilidad-Total IN hProc (INPUT ROWID(Faccpedi), OUTPUT pMensaje).
  IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
  DELETE PROCEDURE hProc.
  /* ****************************************************************************************** */
  /* RHC 02/01/2020 Promociones proyectadas */
  /* ****************************************************************************************** */
  EMPTY TEMP-TABLE ITEM.
  FOR EACH Facdpedi OF Faccpedi NO-LOCK:
      CREATE ITEM.
      BUFFER-COPY Facdpedi TO ITEM.
  END.
  RUN vtagn/p-promocion-general.r (INPUT Faccpedi.CodDiv,
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
  /* ****************************************************************************************** */
  {vtagn/totales-cotizacion-unificada.i &Cabecera="FacCPedi" &Detalle="FacDPedi"}
  /* ****************************************************************************************** */
  /* ****************************************************************************************** */
  /* RHC 20/07/2017 Comisiones */
  /* ****************************************************************************************** */
  FOR EACH Facdpedi OF Faccpedi NO-LOCK:
      {lib/lock-genericov3.i ~
          &Tabla="B-DPEDI" ~
          &Condicion="ROWID(B-DPEDI) = ROWID(Facdpedi)" ~
          &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
          &Accion="RETRY" ~
          &Mensaje="NO" ~
          &txtMensaje="pMensaje" ~
          &TippoError="UNDO, RETURN 'ADM-ERROR'"}
      /* Grabamos la Comisión del Vendedor */
      B-DPEDI.Libre_d04 = fComision().
  END.

  IF AVAILABLE(Faccorre) THEN RELEASE FacCorre.
  IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.
  IF AVAILABLE(B-DPEDI)  THEN RELEASE B-DPEDI.
  IF AVAILABLE(gn-clie)  THEN RELEASE Gn-Clie.

RETURN 'OK'.


PROCEDURE CREATE-TRANSACTION:
/* ************************* */

PRINCIPAL:                                                                                  
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {vta2/icorrelativosecuencial.i &Codigo = s-coddoc &Serie = s-nroser}
    ASSIGN 
        FacCPedi.CodCia = S-CODCIA
        FacCPedi.CodDiv = S-CODDIV
        FacCPedi.CodDoc = s-coddoc 
        FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
        FacCPedi.FchPed = TODAY 
        FacCPedi.Hora   = STRING(TIME,"HH:MM:SS")
        FacCPedi.TpoPed = s-TpoPed
        FacCPedi.FlgEst = (IF FacCPedi.CodCli BEGINS "SYS" THEN "I" ELSE "P")     /* APROBADO */
        FacCPedi.Lista_de_Precios = FacCPedi.Libre_c01      /* OJO */
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        {lib/mensaje-de-error.i &MensajeError="pMensaje"}
        UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
/*     /* DATOS SUPERMERCADOS */                                              */
/*     CASE s-TpoPed:                                                         */
/*         WHEN "S" THEN DO:                                                  */
/*             IF s-Import-Ibc = YES THEN FacCPedi.Libre_C05 = "1".           */
/*             IF s-Import-B2B = YES THEN FacCPedi.Libre_C05 = "3".  /* OJO*/ */
/*         END.                                                               */
/*     END CASE.                                                              */
    /*  */
/*     IF lOrdenGrabada > '' THEN DO:                                       */
/*         DISABLE TRIGGERS FOR LOAD OF factabla.                           */
/*         FIND FIRST factabla WHERE factabla.codcia = s-codcia AND         */
/*             factabla.tabla = 'OC PLAZA VEA' AND                          */
/*             factabla.codigo = lOrdenGrabada EXCLUSIVE NO-ERROR.          */
/*         IF NOT AVAILABLE factabla THEN DO:                               */
/*             CREATE factabla.                                             */
/*             ASSIGN                                                       */
/*                 factabla.codcia = s-codcia                               */
/*                 factabla.tabla = 'OC PLAZA VEA'                          */
/*                 factabla.codigo = lOrdenGrabada                          */
/*                 factabla.campo-c[2] = STRING(NOW,"99/99/9999 HH:MM:SS"). */
/*         END.                                                             */
/*     END.                                                                 */
    /* RHC 05/10/17 En caso de COPIAR una cotizacion hay que "limpiar" estos campos */
    ASSIGN
        Faccpedi.Libre_c02 = ""       /* "PROCESADO" por Abastecimientos */
        Faccpedi.LugEnt2   = ""
        .
/*     IF Faccpedi.CodRef = "PPV" THEN DO:                              */
/*         RUN actualiza-prepedido ( +1, OUTPUT pMensaje ).             */
/*         IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'. */
/*     END.                                                             */
END.
RETURN 'OK'.


END PROCEDURE.



