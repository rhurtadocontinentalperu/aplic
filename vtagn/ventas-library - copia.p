&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-ADocu FOR CcbADocu.
DEFINE BUFFER B-ALM FOR Almacen.
DEFINE NEW SHARED BUFFER B-CPEDI FOR FacCPedi.
DEFINE BUFFER B-DPEDI FOR FacDPedi.
DEFINE BUFFER COTIZACION FOR FacCPedi.
DEFINE BUFFER PCO FOR FacCPedi.
DEFINE TEMP-TABLE PEDI NO-UNDO LIKE FacDPedi.
DEFINE NEW SHARED TEMP-TABLE T-LogTabla NO-UNDO LIKE logtabla.



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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.

/* PRODUCTOS POR ROTACION */
DEFINE SHARED VAR s-FlgRotacion LIKE gn-divi.flgrotacion.
DEFINE SHARED VAR s-FlgEmpaque  LIKE GN-DIVI.FlgEmpaque.
DEFINE SHARED VAR s-FlgMinVenta LIKE GN-DIVI.FlgMinVenta.
DEFINE SHARED VAR s-VentaMayorista LIKE GN-DIVI.VentaMayorista.
DEFINE SHARED VAR s-FlgTipoVenta LIKE GN-DIVI.FlgPreVta.

DEFINE SHARED VAR s-TpoPed AS CHAR.

/* Sintaxis:

DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN <libreria> PERSISTENT SET hProc.

RUN <libreria>.rutina_interna IN hProc (input  buffer tt-excel:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

DELETE PROCEDURE hProc.

*/

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
      TABLE: B-ADocu B "?" ? INTEGRAL CcbADocu
      TABLE: B-ALM B "?" ? INTEGRAL Almacen
      TABLE: B-CPEDI B "NEW SHARED" ? INTEGRAL FacCPedi
      TABLE: B-DPEDI B "?" ? INTEGRAL FacDPedi
      TABLE: COTIZACION B "?" ? INTEGRAL FacCPedi
      TABLE: PCO B "?" ? INTEGRAL FacCPedi
      TABLE: PEDI T "?" NO-UNDO INTEGRAL FacDPedi
      TABLE: T-LogTabla T "NEW SHARED" NO-UNDO INTEGRAL logtabla
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 9.96
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-PED_Add-Record) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PED_Add-Record Procedure 
PROCEDURE PED_Add-Record :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pPorIgv AS DEC.
DEF OUTPUT PARAMETER pCodOrigen AS CHAR.
DEF OUTPUT PARAMETER pNroOrigen AS CHAR.
DEF OUTPUT PARAMETER pNroCot AS CHAR.
DEF OUTPUT PARAMETER pCodAlm AS CHAR.
DEF OUTPUT PARAMETER pFchEnt AS DATE.
DEF OUTPUT PARAMETER TABLE FOR PEDI.

DEF BUFFER PCO     FOR Faccpedi.

/* De acuerdo a la division se va a solicitar la COT o PCO */
DEF VAR x-Tipo AS CHAR NO-UNDO.
ASSIGN
    pCodAlm = ''
    pNroCot = ''
    pCodOrigen = ''
    pNroOrigen = ''.
CASE x-Tipo:
    WHEN "PCO" THEN DO:
        RUN vta2/d-pco-cred-pendiente (OUTPUT pCodAlm, OUTPUT pNroOrigen).
        IF TRUE <> (pCodAlm > "") THEN RETURN "ADM-ERROR".
        /* FORMATO x-NroPCO
        123123456-nn
        Donde 123123456: Es el Número de la Cotización 
        nn: es un correlativo del PCO 
        */
        pCodOrigen = "PCO".
        pNroCot = ENTRY(1,pNroOrigen,'-').  /* <<< OJO <<< */
        FIND PCO WHERE PCO.CodCia = s-CodCia AND 
            PCO.CodDoc = pCodOrigen AND 
            PCO.NroPed = pNroOrigen
            NO-LOCK NO-ERROR.
        IF AVAILABLE PCO THEN pFchEnt = PCO.FchEnt.
        RUN PED_Asigna-PCO (pNroOrigen, pPorIgv).
        IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
    END.
    WHEN "EVENTOS" THEN DO:
    END.
    OTHERWISE DO:   /* NORMAL */
        RUN vta2/d-cot-cred-pendiente (OUTPUT pCodAlm, OUTPUT pNroCot).
        IF TRUE <> (pCodAlm > "") THEN RETURN "ADM-ERROR".
        pCodOrigen = "COT".
        FIND B-CPEDI WHERE B-CPEDI.codcia = s-codcia
            AND B-CPEDI.coddiv = s-CodDiv
            AND B-CPEDI.coddoc = pCodOrigen
            AND B-CPEDI.nroped = pNroCot
            NO-LOCK NO-ERROR.
        IF AVAILABLE B-CPEDI THEN pFchEnt = B-CPEDI.FchEnt.
        RUN PED_Asigna-Cotizacion (pCodAlm, pPorIgv).
        IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
    END.
END CASE.
/* Validamos la B-CPEDI */
FIND B-CPEDI WHERE B-CPEDI.codcia = s-CodCia AND
    B-CPEDI.coddiv = s-coddiv AND
    B-CPEDI.coddoc = "COT" AND
    B-CPEDI.nroped = pNroCot NO-LOCK.
/* chequeamos cotización */
IF B-CPEDI.FchVen < TODAY THEN DO:
    FIND FIRST B-DPEDI OF B-CPEDI WHERE B-DPEDI.CanAte > 0 NO-LOCK NO-ERROR.
    IF NOT AVAILABLE B-DPEDI THEN DO:
        MESSAGE 'Cotización VENCIDA el' B-CPEDI.FchVen SKIP
            'Proceso abortado'
            VIEW-AS ALERT-BOX INFORMATION.
        RETURN "ADM-ERROR".
    END.
END.

RETURN 'OK'.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PED_Asigna-Cotizacion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PED_Asigna-Cotizacion Procedure 
PROCEDURE PED_Asigna-Cotizacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pCodAlm AS CHAR.
  DEFINE INPUT PARAMETER pPorIgv AS DEC.

  DEFINE VARIABLE I-NPEDI AS INTEGER NO-UNDO.
  DEFINE VARIABLE f-Factor AS DEC NO-UNDO.
  DEFINE VARIABLE x-CanPed AS DEC NO-UNDO.
  DEFINE VARIABLE s-StkComprometido AS DEC.
  DEFINE VARIABLE s-StkDis AS DEC NO-UNDO.
  DEFINE VARIABLE F-CANPED AS DECIMAL NO-UNDO.
  DEFINE VARIABLE x-StkAct AS DEC NO-UNDO.
  DEFINE VARIABLE x-CodAlm AS CHAR NO-UNDO.
  DEFINE VARIABLE i AS INT NO-UNDO.

  /* **************************************************** */
  /* RHC 31/01/2018 PARAMETROS DE ACUERDO A LA COTIZACION */
  /* **************************************************** */
  DEF BUFFER B-DIVI FOR gn-divi.
  FIND B-DIVI WHERE B-DIVI.codcia = s-codcia AND B-DIVI.coddiv = B-CPEDI.Libre_c01 NO-LOCK NO-ERROR.
  IF AVAILABLE B-DIVI THEN DO:
      ASSIGN
          s-FlgEmpaque = B-DIVI.FlgEmpaque
          s-VentaMayorista = B-DIVI.VentaMayorista.
  END.
  /* **************************************************** */
  /* **************************************************** */
  DEFINE FRAME F-Mensaje
    'Procesando: ' Facdpedi.codmat SKIP(1)
    'Espere un momento por favor ...' SKIP
    WITH CENTERED NO-LABELS OVERLAY VIEW-AS DIALOG-BOX TITLE 'TRASLADANDO COTIZACION'.

  EMPTY TEMP-TABLE PEDI.

  i-NPedi = 0.
  /* VERIFICACION DE LOS SALDOS DE LA COTIZACION */
  FOR EACH Facdpedi OF B-CPEDI NO-LOCK WHERE (Facdpedi.CanPed - Facdpedi.CanAte) > 0:
      IF Facdpedi.CanAte < 0 THEN DO:   /* HAY UN NEGATIVO */
          MESSAGE 'Hay una incosistencia el el producto:' Facdpedi.codmat SKIP
              'Proceso abortado'
              VIEW-AS ALERT-BOX WARNING.
          RETURN 'ADM-ERROR'.
      END.
  END.
  /* CARGAMOS STOCK DISPONIBLE */
  /* s-CodAlm: Tiene uno solo almacenes configurados */
  DEF VAR t-AlmDes AS CHAR NO-UNDO.
  DEF VAR t-CanPed AS DEC NO-UNDO.
  DEF VAR pSugerido AS DEC NO-UNDO.
  DEF VAR pEmpaque AS DEC NO-UNDO.

  /* ********************************************* */
  /* LIMPIAMOS LA TABLA DE LOG DE TOPE DE DESPACHO */
  /* ********************************************* */
  EMPTY TEMP-TABLE T-LogTabla.
  /* ********************************************* */
  ALMACENES:
  FOR EACH Facdpedi OF B-CPEDI NO-LOCK WHERE (Facdpedi.CanPed - Facdpedi.CanAte) > 0,
      FIRST Almmmatg OF Facdpedi NO-LOCK
      BY Facdpedi.NroItm:
      DISPLAY Facdpedi.codmat WITH FRAME F-Mensaje.
      ASSIGN
          f-Factor = Facdpedi.Factor
          t-AlmDes = ''
          t-CanPed = 0.
      x-CodAlm = ENTRY(1, pCodAlm).   /* Por si acaso, aunque solo debería tener un almacén */
      F-CANPED = (FacDPedi.CanPed - FacDPedi.CanAte).
      /* FILTROS */
      FIND Almmmate WHERE Almmmate.codcia = s-codcia
          AND Almmmate.codalm = x-CodAlm  /* *** OJO *** */
          AND Almmmate.codmat = Facdpedi.CodMat
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almmmate THEN DO:
          MESSAGE 'Producto' Facdpedi.codmat 'NO asignado al almacén' x-CodAlm
              VIEW-AS ALERT-BOX WARNING.
          IF B-CPEDI.TpoPed = "LF" THEN RETURN 'ADM-ERROR'.
          NEXT ALMACENES.
      END.
      /* ******************************************************************** */
      /* RHC 23/07/2018 SOLAMENTE CARGAMOS T-LOGTABLA CON EL TOPE DE DESPACHO */
      /* ******************************************************************** */
      DEF VAR pAlmSug AS CHAR NO-UNDO.
      DEF VAR pRetirar AS LOG NO-UNDO.
      RUN alm/p-tope-pedido (Facdpedi.CodMat,
                             x-CodAlm,
                             f-CanPed * f-Factor,
                             YES,
                             INPUT-OUTPUT TABLE T-LogTabla,
                             OUTPUT pAlmSug,
                             OUTPUT pRetirar).
      /*IF pRetirar = YES THEN NEXT ALMACENES.*/
      /* ******************************************************************** */
      /* ******************************************************************** */
      /* Stock Disponible */
      x-StkAct = Almmmate.StkAct.
      RUN gn/Stock-Comprometido-v2 (Facdpedi.CodMat, x-CodAlm, YES, OUTPUT s-StkComprometido).
      s-StkDis = x-StkAct - s-StkComprometido.
      IF s-StkDis <= 0 THEN DO:
          /* RHC 04/02/2016 Solo en caso de LISTA EXPRESS */
          IF B-CPEDI.TpoPed = "LF" THEN DO:
              MESSAGE 'Producto ' Facdpedi.codmat 'NO tiene Stock en el almacén ' x-CodAlm SKIP
                  'Abortamos la generación del Pedido?'
                  VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE rpta AS LOG.
              IF rpta = YES THEN RETURN "ADM-ERROR".
          END.
          NEXT ALMACENES.
      END.
      /* DEFINIMOS LA CANTIDAD */
      x-CanPed = f-CanPed * f-Factor.   /* En unidades de stock */
      IF s-StkDis < x-CanPed THEN DO:
          /* Se ajusta la Cantidad Pedida al Saldo Disponible del Almacén */
          f-CanPed = ((S-STKDIS - (S-STKDIS MODULO f-Factor)) / f-Factor).
      END.
      f-CanPed = f-CanPed * f-Factor.   /* En unidades de Stock */
      /* EMPAQUE SUPERMERCADOS */
      FIND FIRST supmmatg WHERE supmmatg.codcia = B-CPedi.CodCia
          AND supmmatg.codcli = B-CPedi.CodCli
          AND supmmatg.codmat = FacDPedi.codmat 
          NO-LOCK NO-ERROR.
      IF AVAILABLE supmmatg AND supmmatg.Libre_d01 <> 0 THEN DO:
          f-CanPed = (TRUNCATE((f-CanPed / supmmatg.Libre_d01),0) * supmmatg.Libre_d01).
      END.
      ELSE DO:    /* EMPAQUE OTROS */
          IF s-FlgEmpaque = YES THEN DO:
              RUN vtagn/p-cantidad-sugerida.p (s-TpoPed,
                                               Facdpedi.CodMat, 
                                               f-CanPed, 
                                               OUTPUT pSugerido, 
                                               OUTPUT pEmpaque).
              f-CanPed = pSugerido.
          END.
      END.
      f-CanPed = ((f-CanPed - (f-CanPed MODULO f-Factor)) / f-Factor).  /* En unidades de venta */
      IF f-CanPed <= 0 THEN NEXT ALMACENES.
      IF f-CanPed > t-CanPed THEN DO:
          t-CanPed = f-CanPed.
          t-AlmDes = x-CodAlm.
      END.
      IF t-CanPed > 0 THEN DO:
          /* ******************************* */
          /* GRABACION */
          I-NPEDI = I-NPEDI + 1.
          CREATE PEDI.
          BUFFER-COPY FacDPedi 
              EXCEPT Facdpedi.CanSol Facdpedi.CanApr
              TO PEDI
              ASSIGN 
                  PEDI.CodCia = s-codcia
                  PEDI.CodDiv = s-coddiv
                  PEDI.CodDoc = "PED"
                  PEDI.NroPed = ''
                  PEDI.CodCli = B-CPEDI.CodCli
                  PEDI.ALMDES = t-AlmDes  /* *** OJO *** */
                  PEDI.NroItm = I-NPEDI
                  PEDI.CanPed = t-CanPed    /* << OJO << */
                  PEDI.CanAte = 0.
          ASSIGN
              PEDI.Libre_d01 = (FacDPedi.CanPed - FacDPedi.CanAte)
              PEDI.Libre_d02 = t-CanPed
              PEDI.Libre_c01 = '*'.
          /* RHC 28/04/2016 Caso extraño */
          IF PEDI.CanPed > PEDI.Libre_d01 
              THEN ASSIGN PEDI.CanPed = PEDI.Libre_d01 PEDI.Libre_d02 = PEDI.Libre_d01.
          /* *************************** */
          IF PEDI.CanPed <> facdPedi.CanPed THEN DO:
              ASSIGN
                  PEDI.ImpLin = PEDI.CanPed * PEDI.PreUni * 
                                ( 1 - PEDI.Por_Dsctos[1] / 100 ) *
                                ( 1 - PEDI.Por_Dsctos[2] / 100 ) *
                                ( 1 - PEDI.Por_Dsctos[3] / 100 ).
              IF PEDI.Por_Dsctos[1] = 0 AND PEDI.Por_Dsctos[2] = 0 AND PEDI.Por_Dsctos[3] = 0 
              THEN PEDI.ImpDto = 0.
              ELSE PEDI.ImpDto = PEDI.CanPed * PEDI.PreUni - PEDI.ImpLin.
              ASSIGN
                  PEDI.ImpLin = ROUND(PEDI.ImpLin, 2)
                  PEDI.ImpDto = ROUND(PEDI.ImpDto, 2).
              IF PEDI.AftIsc 
                  THEN PEDI.ImpIsc = ROUND(PEDI.PreBas * PEDI.CanPed * (Almmmatg.PorIsc / 100),4).
              IF PEDI.AftIgv 
                  THEN PEDI.ImpIgv = PEDI.ImpLin - ROUND( PEDI.ImpLin  / ( 1 + (pPorIgv / 100) ), 4 ).
          END.
          /* FIN DE CARGA */
      END.
  END.
  HIDE FRAME F-Mensaje.
  /* ******************************************************************** */
  /* ******************************************************************** */
  /* SI HUBIERA UN PRODUCTO CON UNA OBSERVACION => SE PRESENTA UNA VENTANA*/
  RUN vta2/d-ped-tope-despacho.
  /* ******************************************************************** */
  /* ******************************************************************** */
  RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PED_Asigna-PCO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PED_Asigna-PCO Procedure 
PROCEDURE PED_Asigna-PCO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pNroPCO AS CHAR.
  DEFINE INPUT PARAMETER pPorIgv AS DEC.
                        
  DEFINE VARIABLE I-NPEDI AS INTEGER NO-UNDO.
  DEFINE VARIABLE f-Factor AS DEC NO-UNDO.
  DEFINE VARIABLE x-CanPed AS DEC NO-UNDO.
  DEFINE VARIABLE s-StkComprometido AS DEC.
  DEFINE VARIABLE s-StkDis AS DEC NO-UNDO.
  DEFINE VARIABLE F-CANPED AS DECIMAL NO-UNDO.
  DEFINE VARIABLE x-StkAct AS DEC NO-UNDO.
  DEFINE VARIABLE x-CodAlm AS CHAR NO-UNDO.
  DEFINE VARIABLE i AS INT NO-UNDO.

  /* ************************************************************************** */
  /* RHC 31/01/2018 PARAMETROS DE ACUERDO A LA LISTA DE PRECIO DE LA COTIZACION */
  /* ************************************************************************** */
  DEF BUFFER B-DIVI FOR gn-divi.
  FIND B-DIVI WHERE B-DIVI.codcia = s-codcia AND B-DIVI.coddiv = B-CPEDI.Libre_c01 NO-LOCK NO-ERROR.
  IF AVAILABLE B-DIVI THEN DO:
      ASSIGN
          s-FlgEmpaque = B-DIVI.FlgEmpaque
          s-VentaMayorista = B-DIVI.VentaMayorista.
  END.
  /* **************************************************** */
  /* **************************************************** */
  DEFINE FRAME F-Mensaje
    'Procesando: ' Facdpedi.codmat SKIP(1)
    'Espere un momento por favor ...' SKIP
    WITH CENTERED NO-LABELS OVERLAY VIEW-AS DIALOG-BOX TITLE 'TRASLADANDO COTIZACION'.


  i-NPedi = 0.
  /* VERIFICACION DE LOS SALDOS DE LA COTIZACION */
  FOR EACH Facdpedi OF B-CPEDI NO-LOCK WHERE (Facdpedi.CanPed - Facdpedi.CanAte) > 0:
      IF Facdpedi.CanAte < 0 THEN DO:   /* HAY UN NEGATIVO */
          MESSAGE 'Hay una incosistencia el el producto:' Facdpedi.codmat SKIP
              'Avisar a sistemas' SKIP(2)
              'Proceso abortado'
              VIEW-AS ALERT-BOX WARNING.
          RETURN 'ADM-ERROR'.
      END.
  END.
  /* CARGAMOS STOCK DISPONIBLE */
  /* s-CodAlm: Tiene uno mas almacenes configurados */
  DEF VAR t-AlmDes AS CHAR NO-UNDO.
  DEF VAR t-CanPed AS DEC NO-UNDO.
  DEF VAR pSugerido AS DEC NO-UNDO.
  DEF VAR pEmpaque AS DEC NO-UNDO.

  /* ********************************************* */
  /* LIMPIAMOS LA TABLA DE LOG DE TOPE DE DESPACHO */
  /* ********************************************* */
  EMPTY TEMP-TABLE T-LogTabla.
  EMPTY TEMP-TABLE PEDI.
  /* ********************************************* */
  ALMACENES:
  FOR EACH Facdpedi OF B-CPEDI NO-LOCK,
      EACH Vtaddocu NO-LOCK WHERE Vtaddocu.codcia = s-CodCia AND
      Vtaddocu.codped = "PCO" AND
      Vtaddocu.nroped = pNroPCO AND
      Vtaddocu.codmat = Facdpedi.codmat AND
      Vtaddocu.canped > 0,
      FIRST Almmmatg OF Facdpedi NO-LOCK
      BY Facdpedi.NroItm:
      DISPLAY Facdpedi.codmat WITH FRAME F-Mensaje.
      ASSIGN
          f-Factor = Facdpedi.Factor
          t-AlmDes = ''
          t-CanPed = 0.
      /* ************************************************* */
      /* INFORMACION DE LA PROGRAMACION DE ABASTECIMIENTOS */
      x-CodAlm = VtaDDocu.AlmDes.   /* <<< OJO <<< */
      F-CANPED = VtaDDocu.CanPed.   /* <<< OJO <<< */
      /* ************************************************* */
      /* FILTROS */
      FIND Almmmate WHERE Almmmate.codcia = s-codcia
          AND Almmmate.codalm = x-CodAlm  /* *** OJO *** */
          AND Almmmate.codmat = Facdpedi.CodMat
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almmmate THEN DO:
          MESSAGE 'Producto' Facdpedi.codmat 'NO asignado al almacén' x-CodAlm
              VIEW-AS ALERT-BOX INFORMATION.
          NEXT ALMACENES.
      END.
      /* ******************************************************************** */
      /* RHC 23/07/2018 SOLAMENTE CARGAMOS T-LOGTABLA CON EL TOPE DE DESPACHO */
      /* ******************************************************************** */
      DEF VAR pAlmSug AS CHAR NO-UNDO.
      DEF VAR pRetirar AS LOG NO-UNDO.
      RUN alm/p-tope-pedido (Facdpedi.CodMat,
                             x-CodAlm,
                             f-CanPed * f-Factor,
                             YES,
                             INPUT-OUTPUT TABLE T-LogTabla,
                             OUTPUT pAlmSug,
                             OUTPUT pRetirar).
      /* ******************************************************************** */
      /* ******************************************************************** */
      /* Stock Disponible */
      x-StkAct = Almmmate.StkAct.
      RUN gn/Stock-Comprometido-v2 (Facdpedi.CodMat, x-CodAlm, YES, OUTPUT s-StkComprometido).
      s-StkDis = x-StkAct - s-StkComprometido.
      IF s-StkDis <= 0 THEN DO:
          NEXT ALMACENES.
      END.
      /* DEFINIMOS LA CANTIDAD */
      x-CanPed = f-CanPed * f-Factor.   /* En unidades de stock */
      IF s-StkDis < x-CanPed THEN DO:
          /* Se ajusta la Cantidad Pedida al Saldo Disponible del Almacén */
          f-CanPed = ((S-STKDIS - (S-STKDIS MODULO f-Factor)) / f-Factor).
      END.
      /* ********************************************************************************************** */
      /* EMPAQUE OTROS */
      /* ********************************************************************************************** */
      f-CanPed = f-CanPed * f-Factor.   /* En unidades de Stock */
      IF s-FlgEmpaque = YES THEN DO:
          RUN vtagn/p-cantidad-sugerida-pco.p (Facdpedi.CodMat, 
                                               f-CanPed, 
                                               OUTPUT pSugerido, 
                                               OUTPUT pEmpaque).
          f-CanPed = pSugerido.
      END.
      f-CanPed = ((f-CanPed - (f-CanPed MODULO f-Factor)) / f-Factor).  /* En unidades de venta */
      IF f-CanPed <= 0 THEN NEXT ALMACENES.
      /* ********************************************************************************************** */
      /* ********************************************************************************************** */
      IF f-CanPed > t-CanPed THEN DO:
          t-CanPed = f-CanPed.
          t-AlmDes = x-CodAlm.
      END.
      IF t-CanPed > 0 THEN DO:
          /* CONSISTENCIA ANTES DE GRABAR */
          IF CAN-FIND(FIRST PEDI WHERE PEDI.codmat = Facdpedi.codmat AND PEDI.almdes = t-AlmDes NO-LOCK)
              THEN NEXT ALMACENES.
          /* ******************************* */
          /* GRABACION */
          I-NPEDI = I-NPEDI + 1.
          CREATE PEDI.
          BUFFER-COPY FacDPedi 
              EXCEPT Facdpedi.CanSol Facdpedi.CanApr
              TO PEDI
              ASSIGN 
                  PEDI.CodCia = s-codcia
                  PEDI.CodDiv = s-coddiv
                  PEDI.CodDoc = "PED"
                  PEDI.NroPed = ''
                  PEDI.CodCli = B-CPEDI.CodCli
                  PEDI.ALMDES = t-AlmDes  /* *** OJO *** */
                  PEDI.NroItm = I-NPEDI
                  PEDI.CanPed = t-CanPed    /* << OJO << */
                  PEDI.CanAte = 0.
          ASSIGN
              PEDI.Libre_d01 = VtaDDocu.CanPed
              PEDI.Libre_d02 = t-CanPed
              PEDI.Libre_c01 = '*'.
          /* RHC 28/04/2016 Caso extraño */
          IF PEDI.CanPed > PEDI.Libre_d01 
              THEN ASSIGN PEDI.CanPed = PEDI.Libre_d01 PEDI.Libre_d02 = PEDI.Libre_d01.
          /* *************************** */
          ASSIGN
              PEDI.ImpLin = PEDI.CanPed * PEDI.PreUni * 
                            ( 1 - PEDI.Por_Dsctos[1] / 100 ) *
                            ( 1 - PEDI.Por_Dsctos[2] / 100 ) *
                            ( 1 - PEDI.Por_Dsctos[3] / 100 ).
          IF PEDI.Por_Dsctos[1] = 0 AND PEDI.Por_Dsctos[2] = 0 AND PEDI.Por_Dsctos[3] = 0 
          THEN PEDI.ImpDto = 0.
          ELSE PEDI.ImpDto = PEDI.CanPed * PEDI.PreUni - PEDI.ImpLin.
          ASSIGN
              PEDI.ImpLin = ROUND(PEDI.ImpLin, 2)
              PEDI.ImpDto = ROUND(PEDI.ImpDto, 2).
          IF PEDI.AftIsc 
              THEN PEDI.ImpIsc = ROUND(PEDI.PreBas * PEDI.CanPed * (Almmmatg.PorIsc / 100),4).
          IF PEDI.AftIgv 
              THEN PEDI.ImpIgv = PEDI.ImpLin - ROUND( PEDI.ImpLin  / ( 1 + (pPorIgv / 100) ), 4 ).
          /* FIN DE CARGA */
      END.
  END.
  HIDE FRAME F-Mensaje.
  /* ******************************************************************** */
  /* ******************************************************************** */
  /* SI HUBIERA UN PRODUCTO CON UNA OBSERVACION => SE PRESENTA UNA VENTANA*/
  RUN vta2/d-ped-tope-despacho.
  /* ******************************************************************** */
  /* ******************************************************************** */
  RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PED_Despachar-Pedido) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PED_Despachar-Pedido Procedure 
PROCEDURE PED_Despachar-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* ROWID del PEDIDO */
DEF INPUT PARAMETER pRowid AS ROWID.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

pMensaje = ''.
FIND Faccpedi WHERE ROWID(Faccpedi) = pRowid NO-LOCK.
/* Solo PEDidos GENERADOS */
IF Faccpedi.flgest <> "G" THEN DO:
    pMensaje = "El pedido ya NO está por aprobar".
    RETURN "ADM-ERROR".
END.
/* LISTA EXPRESS */
FIND COTIZACION WHERE COTIZACION.codcia = Faccpedi.codcia
    AND COTIZACION.coddiv = Faccpedi.coddiv
    AND COTIZACION.coddoc = Faccpedi.codref
    AND COTIZACION.nroped = Faccpedi.nroref
    NO-LOCK NO-ERROR.
IF AVAILABLE COTIZACION AND COTIZACION.TpoPed = "LF" AND COTIZACION.FlgEst <> "C" 
    THEN DO:
    pMensaje = 'PEDIDO LISTA EXPRESS' + chr(10) + 'NO se puede despachar parciales'.
    RETURN 'ADM-ERROR'.
END.
/* ****************************************************************************** */
/* RHC 04/02/2018 Ciclo de Cross Docking Clientes */
/* ****************************************************************************** */
DEF VAR pCrossDocking AS LOG NO-UNDO.
DEF VAR pAlmacenXD AS CHAR NO-UNDO.
DEF VAR k AS INT NO-UNDO.
DEF BUFFER B-DESTINO FOR Almacen.
DEF BUFFER B-ORIGEN  FOR Almacen.
RUN alm/d-crossdocking-v2 (OUTPUT pCrossDocking, OUTPUT pAlmacenXD).
IF pAlmacenXD = "ERROR" THEN RETURN 'ADM-ERROR'.
IF pCrossDocking = YES THEN DO k = 1 TO NUM-ENTRIES(Faccpedi.CodAlm):
    FIND B-DESTINO WHERE B-DESTINO.codcia = s-codcia
        AND B-DESTINO.codalm = ENTRY(k, Faccpedi.CodAlm)
        NO-LOCK.
    FIND B-ORIGEN WHERE B-ORIGEN.codcia = s-codcia
        AND B-ORIGEN.codalm = pAlmacenXD
        NO-LOCK.
    IF B-DESTINO.CodDiv = B-ORIGEN.CodDiv THEN DO:
        pMensaje = 'NO se puede generar para el mismo CD'.
        RETURN 'ADM-ERROR'.
    END.
END.
/* ****************************************************************************** */
/* ****************************************************************************** */
MESSAGE 'El Pedido está listo para ser despachado' SKIP 'Continuamos?'
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN 'ADM-ERROR'.
/* Cliente */
FIND Gn-clie WHERE Gn-clie.codcia = cl-codcia AND Gn-clie.codcli = Faccpedi.codcli
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Gn-clie THEN DO:
    pMensaje = 'Cliente NO registrado'.
    RETURN 'ADM-ERROR'.
END.
/* Revisar datos del Transportista */
FIND Ccbadocu WHERE Ccbadocu.codcia = Faccpedi.codcia
    AND Ccbadocu.coddiv = Faccpedi.coddiv
    AND Ccbadocu.coddoc = Faccpedi.coddoc
    AND Ccbadocu.nrodoc = Faccpedi.nroped
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Ccbadocu THEN DO:
    MESSAGE 'Aún NO ha ingresado los datos del transportista' SKIP 'Continuamos?'
        VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE rpta-1 AS LOG.
    IF rpta-1 = NO THEN RETURN 'ADM-ERROR'.
END.
/* ********************************* */
RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i ~
        &Tabla="Faccpedi" ~
        &Condicion="ROWID(Faccpedi) = pRowid" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="LEAVE" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" }
    IF Faccpedi.flgest <> "G" THEN DO:
        pMensaje = 'El Pedido ya fue aprobado por:' + CHR(10) +
            'Usuario: ' + FacCPedi.UsrAprobacion + CHR(10) +
            'Fecha: ' + STRING(FacCPedi.FchAprobacion) + CHR(10) + CHR(10) +
            'Proceso abortado'.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* VERIFICAMOS DEUDA DEL CLIENTE */
    {vta2/verifica-cliente-01.i &VarMensaje = pMensaje}
    
    /* RHC 19/02/2018 Maldito cross docking */
    ASSIGN                  
        Faccpedi.CrossDocking = pCrossDocking
        Faccpedi.AlmacenXD = pAlmacenXD.    /* Almacén que despacha al cliente */
    IF Faccpedi.FlgEst = "X" THEN DO:
        /* ******************************* */
        /* RHC 17/08/2018 TRACKING DE CONTROL */
        /* ******************************* */
        RUN vtagn/pTracking-04 (s-CodCia,
                          s-CodDiv,
                          Faccpedi.CodDoc,
                          Faccpedi.NroPed,
                          s-User-Id,
                          'PANPX',
                          'P',
                          DATETIME(TODAY, MTIME),
                          DATETIME(TODAY, MTIME),
                          Faccpedi.CodDoc,
                          Faccpedi.NroPed,
                          Faccpedi.CodRef,
                          Faccpedi.NroRef).
        /* ******************************* */
        /* ******************************* */
        IF TRUE <> (pMensaje > '') THEN pMensaje = "NO pasó la línea de crédito".
        LEAVE RLOOP.
    END.
    /* VERIFICAMOS MARGEN DE UTILIDAD */
    IF LOOKUP(s-CodDiv, '00000,00017,00018') > 0 THEN DO:
        {vta2/i-verifica-margen-utilidad-1.i}
        IF Faccpedi.FlgEst = "W" THEN DO:
            pMensaje = FacCPedi.Libre_c05.
            LEAVE RLOOP.
        END.
    END.
    /* CREAMOS LA ORDEN */
    pMensaje = "".
    CASE TRUE:
        WHEN Faccpedi.CrossDocking = NO THEN DO:
            RUN VTA_Genera-OD ( ROWID(Faccpedi), OUTPUT pMensaje ).
/*             RUN vta2/pcreaordendesp-v2 ( ROWID(Faccpedi), OUTPUT pMensaje ). */
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO RLOOP, LEAVE RLOOP.
        END.
        WHEN Faccpedi.CrossDocking = YES THEN DO:
            RUN alm/genera-otr-ventas ( ROWID(Faccpedi), OUTPUT pMensaje ).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO RLOOP, LEAVE RLOOP.
        END.
    END CASE.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-VTA_Genera-OD) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE VTA_Genera-OD Procedure 
PROCEDURE VTA_Genera-OD :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowid AS ROWID.
DEF OUTPUT PARAMETER pComprobante AS CHAR.     /* O/D generada */
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

pMensaje = "".
FIND B-CPEDI WHERE ROWID(B-CPEDI) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-CPEDI THEN DO:
    pMensaje = "NO se ubicó el Pedido".
    RETURN 'ADM-ERROR'.
END.
/* ***************************************************************************** */
/* SOLO PARA PEDIDOS APROBADOS */
/* ***************************************************************************** */
IF B-CPEDI.FlgEst <> "P" THEN RETURN 'OK'.
/* ***************************************************************************** */
/* NO DEBE SER PARA CROSS DOCKING */
/* ***************************************************************************** */
IF B-CPEDI.CrossDocking = YES THEN DO:
    pMensaje = "Si es para Cross Docking NO debe generar una ORDEN DE DESPACHO".
    RETURN 'ADM-ERROR'.
END.
/* ***************************************************************************** */
/* NOTA: La división debe ser la de FACCPEDI */
/* ***************************************************************************** */
DEF VAR s-CodDiv AS CHAR NO-UNDO.
s-CodDiv = B-CPEDI.CodDiv.
/* ***************************************************************************** */
DEFINE VARIABLE s-FlgPicking LIKE GN-DIVI.FlgPicking.
DEFINE VARIABLE s-FlgBarras LIKE GN-DIVI.FlgBarras.
DEFINE VARIABLE s-DiasVtoO_D LIKE GN-DIVI.DiasVtoO_D.
DEFINE VARIABLE s-NroSer AS INTEGER.
/* ***************************************************************************** */
/* PARAMETROS DE COTIZACION PARA LA DIVISION */
/* ***************************************************************************** */
FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = s-coddiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN DO:
    pMensaje = 'División ' + s-coddiv + ' NO configurada'.
    RETURN 'ADM-ERROR'.
END.
DEF VAR s-coddoc AS CHAR INIT "O/D" NO-UNDO.
CASE B-CPEDI.CodDoc:
    WHEN "PED" THEN s-CodDoc = "O/D".
    WHEN "P/M" THEN s-CodDoc = "O/M".
END CASE.
FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
    FacCorre.CodDoc = S-CODDOC AND
    FacCorre.CodDiv = S-CODDIV AND
    FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
   pMensaje = "Correlativo del Documento no configurado: " + s-coddoc.
   RETURN 'ADM-ERROR'.
END.
ASSIGN
    s-nroser = FacCorre.NroSer.
ASSIGN
    s-FlgPicking = GN-DIVI.FlgPicking
    s-FlgBarras  = GN-DIVI.FlgBarras
    s-DiasVtoO_D = GN-DIVI.DiasVtoO_D.
FIND FIRST FacCfgGn WHERE FacCfgGn.codcia = s-codcia NO-LOCK.
/* ***************************************************************************** */
DEFINE VAR cEsValeUtilex AS LOG INIT NO.
DEFINE VAR cNroVales AS CHAR.

DEFINE VAR hMaster AS HANDLE NO-UNDO.
RUN gn/master-library PERSISTENT SET hMaster.

pMensaje = "".
SESSION:SET-WAIT-STATE('GENERAL').
LoopGrabarData:
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE :
    FIND CURRENT B-CPEDI EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF NOT AVAILABLE B-CPEDI THEN DO:
        pMensaje = "No se pudo Bloquear B-CPEDI".
        UNDO LoopGrabarData, LEAVE.
    END.
    {lib/lock-genericov3.i
        &Tabla="FacCorre"
        &Condicion=" FacCorre.CodCia = s-codcia
        AND FacCorre.CodDoc = s-coddoc
        AND FacCorre.NroSer = s-nroser"
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
        &Accion="RETRY"
        &Intentos=10
        &Mensaje="NO"
        &txtMensaje="pMensaje"
        &TipoError="UNDO LoopGrabarData, LEAVE LoopGrabarData"
        }
    /* **************************** */
    /* NOTA: el campo Importe[1] e Importe[2] sirven para determinar el redondeo
        Importe[1]: Importe original del pedido
        Importe[2]: Importe del redondeo
        NOTA. El campo TpoLic sirve para controlar cuando se aplica o no un adelanto de campaña
    */
    /* Ic - 29Ene2016, para vales utilex (B-CPEDI : PEDIDO)*/
    /* Busco la cotizacion */
    FIND FIRST COTIZACION WHERE COTIZACION.codcia = s-codcia 
        AND COTIZACION.coddoc = 'COT' 
        AND COTIZACION.nroped = b-cpedi.nroref NO-LOCK NO-ERROR.
    IF AVAILABLE COTIZACION THEN DO:
        IF COTIZACION.tpoped = 'VU' THEN cEsValeUtilex = YES.
    END.

    CREATE FacCPedi.
    BUFFER-COPY B-CPEDI 
        EXCEPT 
        B-CPEDI.TpoPed
        B-CPEDI.FlgEst
        B-CPEDI.FlgSit
        B-CPEDI.TipVta
        TO FacCPedi
        ASSIGN 
            FacCPedi.CodCia = S-CODCIA
            FacCPedi.CodDiv = S-CODDIV
            FacCPedi.CodDoc = s-coddoc 
            FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
            FacCPedi.CodRef = B-CPEDI.CodDoc
            FacCPedi.NroRef = B-CPEDI.NroPed
            FacCPedi.TpoCmb = FacCfgGn.TpoCmb[1] 
            FacCPedi.FchPed = TODAY
            FacCPedi.FchVen = TODAY + s-DiasVtoO_D
            FacCPedi.Hora = STRING(TIME,"HH:MM")
            FacCPedi.FlgEst = 'X'   /* PROCESANDO: revisar rutina Genera-Pedido */
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "Correlativo de la Orden mal registrado o duplicado".
        UNDO LoopGrabarData, LEAVE.
    END.
    /* ************************************************************************** */
    /* RHC 22/11/17 se va a volver a calcular la fecha de entrega                 */
    /* ************************************************************************** */
    DEF VAR pFchEnt AS DATE NO-UNDO.
    RUN logis/p-fecha-de-entrega (INPUT Faccpedi.CodDoc,
                                  INPUT Faccpedi.NroPed,
                                  INPUT-OUTPUT pFchEnt,
                                  OUTPUT pMensaje).
    IF pMensaje > '' THEN DO:
        UNDO LoopGrabarData, LEAVE.
    END.
    ASSIGN
        FacCPedi.FchEnt = pFchEnt.  /* OJO */
    /* ************************************************************************** */
    /* TRACKING */
    /* ******************************************************************** */
    RUN vtagn/pTracking-04 (Faccpedi.CodCia,
                            Faccpedi.CodDiv,
                            Faccpedi.CodRef,
                            Faccpedi.NroRef,
                            s-User-Id,
                            'GOD',
                            'P',
                            DATETIME(TODAY, MTIME),
                            DATETIME(TODAY, MTIME),
                            Faccpedi.CodDoc,
                            Faccpedi.NroPed,
                            Faccpedi.CodRef,
                            Faccpedi.NroRef)
        NO-ERROR.
    /* ******************************************************************** */
    /* COPIAMOS DATOS DEL TRANSPORTISTA */
    /* ******************************************************************** */
    FIND FIRST Ccbadocu WHERE Ccbadocu.codcia = B-CPEDI.codcia
        AND Ccbadocu.coddiv = B-CPEDI.coddiv
        AND Ccbadocu.coddoc = B-CPEDI.coddoc
        AND Ccbadocu.nrodoc = B-CPEDI.nroped
        NO-LOCK NO-ERROR.
    IF AVAILABLE Ccbadocu THEN DO:
        FIND FIRST B-ADOCU WHERE B-ADOCU.codcia = Faccpedi.codcia
            AND B-ADOCU.coddiv = Faccpedi.coddiv
            AND B-ADOCU.coddoc = Faccpedi.coddoc
            AND B-ADOCU.nrodoc = Faccpedi.nroped
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE B-ADOCU THEN CREATE B-ADOCU.
        BUFFER-COPY Ccbadocu TO B-ADOCU
            ASSIGN
                B-ADOCU.CodDiv = FacCPedi.CodDiv
                B-ADOCU.CodDoc = FacCPedi.CodDoc
                B-ADOCU.NroDoc = FacCPedi.NroPed
            NO-ERROR.
    END.
    /* ******************************************************************** */
    ASSIGN 
        FacCPedi.UsrAprobacion = S-USER-ID
        FacCPedi.FchAprobacion = TODAY.
    /* ******************************************************************** */
    /* Detalle de la OD */
    /* ******************************************************************** */
    
    DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.
    pMensaje = "NO se pudo generar el detalle de la Orden".
    FOR EACH B-DPEDI OF B-CPEDI NO-LOCK BY B-DPEDI.NroItm ON ERROR UNDO, THROW:
        /* GRABAMOS LA DIVISION Y EL ALMACEN DESTINO EN LA CABECERA */
        I-NITEM = I-NITEM + 1.
        CREATE FacDPedi. 
        BUFFER-COPY B-DPEDI 
            TO FacDPedi
            ASSIGN  
            FacDPedi.CodCia  = FacCPedi.CodCia 
            FacDPedi.coddiv  = FacCPedi.coddiv 
            FacDPedi.coddoc  = FacCPedi.coddoc 
            FacDPedi.NroPed  = FacCPedi.NroPed 
            FacDPedi.FchPed  = FacCPedi.FchPed
            FacDPedi.Hora    = FacCPedi.Hora 
            FacDPedi.FlgEst  = 'P'       /*FacCPedi.FlgEst*/
            FacDPedi.NroItm  = I-NITEM
            FacDPedi.CanAte  = 0                     /* <<< OJO <<< */
            FacDPedi.CanSol  = FacDPedi.CanPed       /* <<< OJO <<< */
            FacDPedi.CanPick = FacDPedi.CanPed      /* <<< OJO <<< */
            NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pMensaje = "Error al grabar el producto " + B-DPEDI.codmat.
            UNDO LoopGrabarData, LEAVE LoopGrabarData.
        END.
    END.
    pMensaje = "".
    /* ******************************************************************** */
    /* RHC 26/12/2016 Consistencia final: La O/D y el PED deben ser iguales */
    /* ******************************************************************** */
    DEF VAR x-ItmPed AS INT NO-UNDO.
    DEF VAR x-ItmOD  AS INT NO-UNDO.
    DEF VAR x-ImpPed AS DEC NO-UNDO.
    DEF VAR x-ImpOD  AS DEC NO-UNDO.
    ASSIGN
        x-ItmPed = 0
        x-ItmOD  = 0
        x-ImpPed = 0
        x-ImpOD  = 0.
    FOR EACH Facdpedi OF Faccpedi NO-LOCK:
        x-ItmPed = x-ItmPed + 1.
        x-ImpPed = x-ImpPed + Facdpedi.ImpLin.
    END.
    FOR EACH B-DPEDI OF B-CPEDI NO-LOCK:
        x-ItmOD = x-ItmOD + 1.
        x-ImpOD = x-ImpOD + B-DPEDI.ImpLin.
    END.
    IF x-ItmPed <> x-ItmOD OR x-ImpPed <> x-ImpOD THEN DO:
        pMensaje = "Se encontró una inconsistencia entre el Pedido y la Orden de Despacho" +  CHR(10) +
            "Proceso Abortado".        
        UNDO LoopGrabarData, LEAVE.
    END.
    /* ******************************************************************** */
    /* CONTROL DE OTROS PROCESOS POR DIVISION */
    /* ******************************************************************** */
    FIND gn-divi WHERE gn-divi.codcia = Faccpedi.codcia
        AND gn-divi.coddiv = Faccpedi.divdes
        NO-LOCK.
    ASSIGN
        s-FlgPicking = GN-DIVI.FlgPicking
        s-FlgBarras  = GN-DIVI.FlgBarras.
    IF s-FlgPicking = YES THEN FacCPedi.FlgSit = "T".    /* Por Pickear en Almacén */
    IF s-FlgPicking = NO AND s-FlgBarras = NO THEN FacCPedi.FlgSit = "C".    /* Picking OK */
    IF s-FlgPicking = NO AND s-FlgBarras = YES THEN FacCPedi.FlgSit = "P".   /* Pre-Picking OK */
    /* Ic - 29Ene2016, para vales utilex (B-CPEDI : PEDIDO)*/
    IF (cEsValeUtilex = YES) THEN DO:
        ASSIGN 
            FacCPedi.FlgEst = 'P'
            FacCPedi.FlgSit = 'C' .
    END.
    
    /* ******************************************************************** */
    /* Genera Sub-Pedidos si fuera el caso */
    /* ******************************************************************** */
    
    IF FacCPedi.FlgSit = "T" THEN DO:
        RUN Genera-SubOrden IN hMaster (INPUT ROWID(Faccpedi),
                                        INPUT Faccpedi.DivDes,     /* División de Despacho */
                                        OUTPUT pMensaje).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo generar la sub-orden'.
            UNDO LoopGrabarData, LEAVE.        
        END.
/*         RUN Genera-SubPedidos.                                                          */
/*         IF RETURN-VALUE = 'ADM-ERROR' THEN DO:                                          */
/*             IF TRUE <> (pMensaje > '') THEN                                             */
/*                 pMensaje = "No se pudo generar el detalle de la Sub-Orden de Despacho". */
/*             UNDO LoopGrabarData, LEAVE.                                                 */
/*         END.                                                                            */
    END.
    /* *************************************************************************** */
    /* Actualiza Cantidad Atendida del Pedido */
    /* *************************************************************************** */
/*     RUN Actualiza-Pedido (+1). */
    
    RUN Actualiza-Saldo-Referencia IN hMaster (ROWID(Faccpedi), "C", OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        pMensaje = "ERROR: No se pudo actualizar el saldo del Pedido".
        UNDO LoopGrabarData, LEAVE.        
    END.
    /* *************************************************************************** */
    /* RHC 08/04/2016 Ahora sí actualizamos el estado */
    /* *************************************************************************** */
    
    ASSIGN
        FacCPedi.FlgEst = 'P'.  /* APROBADO */
    ASSIGN 
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    RELEASE FacCorre.
    pComprobante = Faccpedi.coddoc + ' ' + Faccpedi.nroped.
END.
DELETE PROCEDURE hMaster.
SESSION:SET-WAIT-STATE('').
IF TRUE <> (pMensaje > "") THEN RETURN 'OK'.
ELSE RETURN 'ADM-ERROR'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-VTA_Genera-OTR) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE VTA_Genera-OTR Procedure 
PROCEDURE VTA_Genera-OTR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowid AS ROWID.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

pMensaje = ''.

FIND B-CPEDI WHERE ROWID(B-CPEDI) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-CPEDI THEN DO:
    pMensaje = "NO se pudo ubicar el pedido de ventas".
    RETURN 'ADM-ERROR'.
END.
IF B-CPEDI.FlgEst <> "P" THEN RETURN "OK".
/* DEBE SER PARA CROSS DOCKING */
IF B-CPEDI.CrossDocking = NO THEN DO:
    pMensaje = "Si NO es para Cross Docking NO debe generar una ORDEN DE TRANSFERENCIA".
    RETURN 'ADM-ERROR'.
END.

DEF VAR lDivDespacho AS CHAR NO-UNDO.
DEF VAR lAlmDespacho AS CHAR NO-UNDO.

DEF VAR s-coddoc     AS CHAR INITIAL "OTR" NO-UNDO.    /* Orden de Transferencia */
DEF VAR s-NroSer     AS INT  NO-UNDO.
DEF VAR s-TpoPed     AS CHAR INITIAL "" NO-UNDO.

/* PARAMETROS DE PEDIDOS PARA LA DIVISION */
DEF VAR s-FlgEmpaque LIKE GN-DIVI.FlgEmpaque.
DEF VAR s-DiasVtoPed LIKE GN-DIVI.DiasVtoPed.
DEF VAR s-VentaMayorista LIKE GN-DIVI.VentaMayorista.
DEF VAR s-FlgPicking LIKE GN-DIVI.FlgPicking.
DEF VAR s-FlgBarras LIKE GN-DIVI.FlgBarras.

DEF VAR iNroSKU     AS INT NO-UNDO.
DEF VAR iPeso       AS DEC NO-UNDO.
DEF VAR cUbigeo     AS CHAR NO-UNDO.
DEF VAR lHora       AS CHAR NO-UNDO.
DEF VAR lDias       AS INT NO-UNDO.
DEF VAR lHoraTope   AS CHAR NO-UNDO.
DEF VAR lFechaPedido AS DATE NO-UNDO.

/* El Almacén Destino (El que va a hacer el despacho final al cliente) */
FIND FIRST Almacen WHERE Almacen.codcia = s-codcia
      AND Almacen.codalm = B-CPEDI.AlmacenXD NO-LOCK NO-ERROR.
IF NOT AVAILABLE almacen THEN DO:
    pMensaje = 'Almacén ' + B-CPEDI.AlmacenXD + ' NO existe'.
    RETURN "ADM-ERROR".
END.
FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = Almacen.CodDiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN DO:
    pMensaje = 'División ' + Almacen.CodDiv + ' NO configurada'.
    RETURN "ADM-ERROR".
END.
cUbigeo = TRIM(gn-divi.Campo-Char[3]) + TRIM(gn-divi.Campo-Char[4]) + TRIM(gn-divi.Campo-Char[5]).
/* El almacén de Despacho (El que debería despachar al cliente) */
FIND FIRST Almacen WHERE Almacen.codcia = s-codcia
      AND Almacen.codalm = B-CPEDI.CodAlm NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almacen THEN DO:
    pMensaje = 'Almacen de despacho ' + B-CPEDI.CodAlm + ' No existe'.
    RETURN "ADM-ERROR".
END.
lDivDespacho = Almacen.CodDiv.
lAlmDespacho = Almacen.CodAlm.
/* Control del correlativo */
FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
    FacCorre.CodDiv = lDivDespacho AND
    FacCorre.CodDoc = S-CODDOC AND
    FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
   pMensaje = "Codigo de Documento " + s-coddoc + " No configurado para la division " + lDivDespacho.
   RETURN "ADM-ERROR".
END.
/* La serie segun el almacén de donde se desea despachar */
s-NroSer = FacCorre.NroSer.
/* Datos de la División de Despacho */
FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = lDivDespacho
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN DO:
    pMensaje = 'División ' + lDivDespacho + ' NO configurada'.
    RETURN "ADM-ERROR".
END.
ASSIGN
    s-DiasVtoPed = GN-DIVI.DiasVtoPed
    s-FlgEmpaque = GN-DIVI.FlgEmpaque
    s-VentaMayorista = GN-DIVI.VentaMayorista.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

DEFINE VAR hMaster AS HANDLE NO-UNDO.
RUN gn/master-library PERSISTENT SET hMaster.

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND CURRENT B-CPEDI EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE B-CPEDI THEN UNDO, RETURN 'ADM-ERROR'.
    /* ******************************************************************************** */
    /* Paso 01 : Llenar el Temporal con el detalle de los Articulos */
    /* ******************************************************************************** */
    EMPTY TEMP-TABLE PEDI.
    DEFINE VARIABLE I-NPEDI AS INTEGER NO-UNDO.
    DEFINE VARIABLE f-Factor AS DEC NO-UNDO.
    DEFINE VARIABLE F-CANPED AS DECIMAL NO-UNDO.
    DEFINE VARIABLE x-CodAlm AS CHAR NO-UNDO.
    DEFINE VARIABLE x-CanPed AS DEC NO-UNDO.
    i-NPedi = 0.
    DEF VAR t-AlmDes AS CHAR NO-UNDO.
    DEF VAR t-CanPed AS DEC NO-UNDO.
    FOR EACH B-DPEDI OF B-CPEDI NO-LOCK, FIRST Almmmatg OF B-DPEDI NO-LOCK:
        f-Factor = 1.
        t-AlmDes = ''.
        t-CanPed = 0.
        F-CANPED = (B-DPEDI.CanPed - B-DPEDI.CanAte).     /* OJO */
        x-CodAlm = lAlmDespacho.
        /* DEFINIMOS LA CANTIDAD */
        x-CanPed = f-CanPed * f-Factor.
        IF f-CanPed <= 0 THEN NEXT.
        IF f-CanPed > t-CanPed THEN DO:
            t-CanPed = f-CanPed.
            t-AlmDes = x-CodAlm.
        END.
        I-NPEDI = I-NPEDI + 1.
        CREATE PEDI.
        BUFFER-COPY B-DPEDI 
            TO PEDI
            ASSIGN 
            PEDI.CodCia = s-codcia
            PEDI.CodDiv = lDivDespacho
            PEDI.CodDoc = s-coddoc
            PEDI.NroPed = ''
            PEDI.ALMDES = t-AlmDes  /* *** OJO *** */
            PEDI.NroItm = I-NPEDI
            PEDI.CanPed = t-CanPed            /* << OJO << */
            PEDI.CanAte = 0.
        ASSIGN
            PEDI.Libre_d01 = (B-DPEDI.CanPed - B-DPEDI.CanAte)
            PEDI.Libre_d02 = t-CanPed
            PEDI.Libre_c01 = '*'.
        ASSIGN
            PEDI.UndVta = Almmmatg.UndBas.
    END.
    /* ******************************************************************************** */
    /* Paso 02 : Adiciono el Registro en la Cabecera */
    /* ******************************************************************************** */
    {lib/lock-genericov3.i
        &Tabla="FacCorre"
        &Condicion="Faccorre.codcia = s-codcia
        AND Faccorre.coddoc = s-coddoc
        AND Faccorre.nroser = s-nroser"
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
        &Accion="RETRY"
        &Mensaje="NO"
        &txtMensaje="pMensaje"
        &TipoError="UNDO, RETURN 'ADM-ERROR'"
        }
    /* ***************************************************************** */
    /* Determino la fecha de entrega del pedido */
    /* ***************************************************************** */
    ASSIGN
        iNroSKU = 0
        iPeso = 0.
    FOR EACH PEDI NO-LOCK, FIRST Almmmatg OF PEDI NO-LOCK:
        iNroSKU = iNroSKU + 1.
        iPeso = iPeso + (PEDI.CanPed * PEDI.Factor) * Almmmatg.PesMat.
    END.
    lFechaPedido = MAXIMUM(TODAY, B-CPEDI.FchEnt).
    FIND Almacen WHERE Almacen.codcia = s-codcia AND Almacen.codalm = B-CPEDI.codalm NO-LOCK NO-ERROR.
    CREATE Faccpedi.
    BUFFER-COPY B-CPEDI TO Faccpedi
        ASSIGN 
        Faccpedi.CodCia = S-CODCIA
        Faccpedi.CodDiv = lDivDespacho
        Faccpedi.CodDoc = s-coddoc      /* OTR */
        Faccpedi.TpoPed = s-tpoped      /* "" */
        Faccpedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
        FacCPedi.CodAlm = lAlmDespacho
        Faccpedi.FchPed = TODAY
        Faccpedi.FlgEst = "X"       /* EN PROCESO */
        FacCPedi.FlgEnv = YES
        FacCPedi.Libre_c01 = s-User-id + '|' + STRING(DATETIME(TODAY, MTIME), '99/99/9999 HH:MM')
        FacCPedi.FchEnt = lFechaPedido
        Faccpedi.FchVen = lFechaPedido + 7
        Faccpedi.CodRef = B-CPEDI.CodDoc    /* PED */
        FacCPedi.NroRef = B-CPEDI.NroPed
        FacCPedi.Glosa = B-CPEDI.Glosa
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        pMensaje = 'NO se pudo grabar la ' + s-coddoc.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* RHC 20/12/17 Cross Docking */
    ASSIGN
        Faccpedi.CrossDocking = YES
        Faccpedi.AlmacenXD    = Faccpedi.CodCli.            /* Destino Final (Cliente) */
    ASSIGN
        Faccpedi.CodCli       = B-CPEDI.AlmacenXD.          /* Almacén de Tránsito */
    FIND Almacen WHERE Almacen.codcia = s-codcia AND Almacen.codalm = B-CPEDI.AlmacenXD NO-LOCK NO-ERROR.
    ASSIGN
        Faccpedi.NomCli = Almacen.Descripcion
        Faccpedi.Dircli = Almacen.DirAlm.
    /* ************************** */
    ASSIGN 
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    /* Actualizamos la hora cuando lo vuelve a modificar */
    ASSIGN
        Faccpedi.Usuario = S-USER-ID
        Faccpedi.Hora   = STRING(TIME,"HH:MM").
    /* Division destino */
    FIND Almacen OF Faccpedi NO-LOCK NO-ERROR.
    IF AVAILABLE Almacen THEN FacCPedi.DivDes = Almacen.CodDiv.
    /* CONTROL DE OTROS PROCESOS POR DIVISION */
    FIND gn-divi WHERE gn-divi.codcia = Faccpedi.codcia
        AND gn-divi.coddiv = Faccpedi.divdes
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-divi THEN
        ASSIGN
            s-FlgPicking = GN-DIVI.FlgPicking
            s-FlgBarras  = GN-DIVI.FlgBarras.
    IF s-FlgPicking = YES THEN FacCPedi.FlgSit = "T".    /* Por Pre-Pickear */
    IF s-FlgPicking = NO AND s-FlgBarras = NO THEN FacCPedi.FlgSit = "C".    /* Barras OK */
    IF s-FlgPicking = NO AND s-FlgBarras = YES THEN FacCPedi.FlgSit = "P".   /* Pre-Picking OK */
    /* ***************************************************************** */
    /* DETALLE DE LA OTR */
    /* ***************************************************************** */
    /* Borramos data sobrante */
    FOR EACH PEDI WHERE PEDI.CanPed <= 0:
        DELETE PEDI.
    END.
    /* AHORA SÍ GRABAMOS EL PEDIDO */
    I-NPEDI = 0.
    FOR EACH PEDI, FIRST Almmmatg OF PEDI NO-LOCK BY PEDI.NroItm: 
        I-NPEDI = I-NPEDI + 1.
        CREATE Facdpedi.
        BUFFER-COPY PEDI 
            TO Facdpedi
            ASSIGN
            Facdpedi.CodCia = Faccpedi.CodCia
            Facdpedi.CodDiv = Faccpedi.CodDiv
            Facdpedi.coddoc = Faccpedi.coddoc
            Facdpedi.NroPed = Faccpedi.NroPed
            Facdpedi.AlmDes = Faccpedi.CodAlm
            Facdpedi.FchPed = Faccpedi.FchPed
            Facdpedi.Hora   = Faccpedi.Hora 
            Facdpedi.FlgEst = Faccpedi.FlgEst
            FacDPedi.CanPick = FacDPedi.CanPed
            Facdpedi.NroItm = I-NPEDI.
        DELETE PEDI.
    END.
    /* verificamos que al menos exista 1 item grabado */
    FIND FIRST Facdpedi OF Faccpedi NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Facdpedi 
        THEN RETURN 'ADM-ERROR'.
    ELSE RETURN 'OK'.
    /* ***************************************************************** */
    /* FECHA DE ENTREGA */
    /* ***************************************************************** */
    RUN logis/p-fecha-de-entrega (FacCPedi.CodDoc,              /* Documento actual */
                                  FacCPedi.NroPed,
                                  INPUT-OUTPUT lFechaPedido,
                                  OUTPUT pMensaje).
    IF pMensaje > '' THEN DO:
        UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        FacCPedi.FchEnt = lFechaPedido
        Faccpedi.FchVen = lFechaPedido + 7
        Faccpedi.FlgEst = "P".                  /* OJO >>> APROBADO */
    /* *********************************************************** */
    /* *********************************************************** */
    /* Actualizamos la cotizacion */
/*     RUN Actualiza-Pedido (+1). */
    RUN Actualiza-Saldo-Referencia IN hMaster ("C", OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        pMensaje = "ERROR: No se pudo actualizar el saldo del Pedido".
        UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
    END.
    /* *********************************************************** */
    /* TRACKING */
    RUN vtagn/pTracking-04 (Faccpedi.CodCia,
                            Faccpedi.CodDiv,
                            Faccpedi.CodRef,
                            Faccpedi.NroRef,
                            s-User-Id,
                            'GOT',    /* Generación OTR */
                            'P',
                            DATETIME(TODAY, MTIME),
                            DATETIME(TODAY, MTIME),
                            Faccpedi.CodDoc,
                            Faccpedi.NroPed,
                            Faccpedi.CodRef,
                            Faccpedi.NroRef)
        NO-ERROR.
    /* ******************************************************************** */
    /* Genera Sub-Pedidos si fuera el caso */
    /* ******************************************************************** */
    IF FacCPedi.FlgSit = "T" THEN DO:
        RUN Genera-SubOrden (INPUT Faccpedi.CodDiv,     /* División de Despacho */
                             OUTPUT pMensaje).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            pMensaje = 'NO se pudo generar la sub-orden'.
            UNDO, RETURN 'ADM-ERROR'.
        END.
    END.
    /* *************************************************************************** */
    /* ************ CREAMOS VARIAS OTRs SI FUERA NECESARIO ************* */
    /* *************************************************************************** */
    REPEAT ON ERROR UNDO PRINCIPAL, RETURN 'ADM-ERROR' ON STOP UNDO PRINCIPAL, RETURN 'ADM-ERROR':
        FIND FIRST PEDI NO-ERROR.
        IF NOT AVAILABLE PEDI THEN LEAVE.
        CREATE B-CPEDI.
        BUFFER-COPY FacCPedi TO B-CPEDI ASSIGN B-CPEDI.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999").
        ASSIGN FacCorre.Correlativo = FacCorre.Correlativo + 1.
        FIND FacCPedi WHERE ROWID(Faccpedi) = ROWID(B-CPEDI).
        RUN Genera-Pedido.    /* Detalle del pedido */
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            pMensaje = 'NO se pudo generar el pedido' + CHR(10) + 'NO hay stock suficiente en los almacenes'.
            UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
        END.
        /* Actualizamos la cotizacion */
        /*     RUN Actualiza-Pedido (+1). */
        RUN Actualiza-Saldo-Referencia IN hMaster ("C", OUTPUT pMensaje).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            pMensaje = "ERROR: No se pudo actualizar el saldo del Pedido".
            UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
        END.
        /* *********************************************************** */
        /* ******************************************************************** */
        /* Genera Sub-Pedidos si fuera el caso */
        /* ******************************************************************** */
        IF FacCPedi.FlgSit = "T" THEN DO:
            RUN Genera-SubOrden (INPUT Faccpedi.CodDiv,     /* División de Despacho */
                                 OUTPUT pMensaje).
            IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                pMensaje = 'NO se pudo generar la sub-orden'.
                UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
            END.
        END.
    END.
END.
DELETE PROCEDURE hMaster.
IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.
IF AVAILABLE(Faccpedi) THEN RELEASE Faccpedi.
IF AVAILABLE(B-CPEDI)  THEN RELEASE B-CPEDI.
IF AVAILABLE(B-CPEDI)  THEN RELEASE B-CPEDI.
IF pMensaje > '' THEN RETURN 'ADM-ERROR'.
ELSE RETURN 'OK'.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-VTA_Valida-Cantidad) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE VTA_Valida-Cantidad Procedure 
PROCEDURE VTA_Valida-Cantidad :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF INPUT PARAMETER pCodMat AS CHAR.
  DEF INPUT PARAMETER pUndVta AS CHAR.
  DEF INPUT-OUTPUT PARAMETER pCanPed AS DEC.
  DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

  
  /* ************************************************************************** */
  /* Verificación de la Unidad de Venta */
  /* ************************************************************************** */
  IF TRUE <> (pUndVta > "") THEN DO:
       pMensaje = "La unidad está en blanco".
       RETURN "ADM-ERROR".
  END.
  FIND Unidades WHERE Unidades.Codunid = pUndVta NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Unidades THEN DO:
      pMensaje = 'Unidad NO válida o inactiva'.
      RETURN "ADM-ERROR".
  END.
/*   IF NOT AVAILABLE Unidades OR Unidades.Libre_l01 = YES THEN DO: */
/*       pMensaje = 'Unidad NO válida o inactiva'.                  */
/*       RETURN "ADM-ERROR".                                        */
/*   END.                                                           */
  FIND FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia AND
      Almmmatg.codmat = pCodMat NO-LOCK.
  FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
      AND Almtconv.Codalter = pUndVta
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almtconv THEN DO:
      pMensaje = 'NO está configurado el factor de equivalencia para el producto ' + 
          Almmmatg.codmat + CHR(10) +
          '    Unidad base: ' + Almmmatg.UndBas + CHR(10) +
          'Unidad de venta: ' + pUndVta.
      RETURN "ADM-ERROR".
  END.
  /* ************************************************************************** */
  /* Verificación de la cantidad vendida en base a la configuración de unidades */
  /* ************************************************************************** */
  DEF VAR x-CanPed AS DEC NO-UNDO.
  DEF VAR i-CanPed AS INT NO-UNDO.

  x-CanPed = DECIMAL(pCanPed).
  i-CanPed = INTEGER(pCanPed).
  IF Unidades.Libre_L02 = YES THEN DO:
      /* Unidad indivisible */
      IF x-CanPed <> i-CanPed THEN DO:
          pMensaje = 'Solo se puede vender en valores enteros'.
          pCanPed = i-CanPed.
          RETURN 'ADM-ERROR'.
      END.
  END.
  ELSE DO:
      /* Por múltiplos entonces */
      IF Almtconv.Multiplos <> 0 THEN DO:
          IF (TRUNCATE(x-CanPed / Almtconv.Multiplos, 0) * Almtconv.Multiplos) <> x-CanPed THEN DO:
              pMensaje = 'Solo se puede vender en múltiplos de ' + STRING(Almtconv.Multiplos).
              pCanPed = TRUNCATE(x-CanPed / Almtconv.Multiplos, 0) * Almtconv.Multiplos.
              RETURN 'ADM-ERROR'.
          END.
      END.
  END.
  RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-VTA_Valida-Empaque) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE VTA_Valida-Empaque Procedure 
PROCEDURE VTA_Valida-Empaque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodCli AS CHAR.
DEF INPUT PARAMETER pCodMat AS CHAR.                                      
DEF INPUT-OUTPUT PARAMETER pCanPed AS DEC.
DEF INPUT PARAMETER pFactor AS DEC.
DEF INPUT PARAMETER pTpoPed AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

/* ************************************************************************** */
/* Control de Empaque */
/* ************************************************************************** */
DEF VAR pSugerido AS DEC NO-UNDO.
DEF VAR pEmpaque  AS DEC NO-UNDO.
DEF VAR f-CanPed  AS DEC NO-UNDO.
DEF VAR x-CanPed  AS DEC NO-UNDO.

x-CanPed = pCanPed.     /* Calor original */

FIND FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = pCodMat NO-LOCK.
f-CanPed = pCanPed * pFactor.   /* En unidades de stock */
RUN vtagn/p-cantidad-sugerida.p (INPUT pTpoPed, 
                                 INPUT pCodMat, 
                                 INPUT f-CanPed, 
                                 OUTPUT pSugerido,  /* Redondeado al EMPAQUE o a f-CanPed */
                                 OUTPUT pEmpaque).
pMensaje = ''.
CASE TRUE:
    WHEN pTpoPed = "S" THEN DO:     /* CANAL MODERNO (SUPERMERCADOS) */
        /* EMPAQUE SUPERMERCADOS */
        FIND FIRST supmmatg WHERE supmmatg.codcia = s-CodCia
            AND supmmatg.codcli = pCodCli
            AND supmmatg.codmat = pCodMat
            NO-LOCK NO-ERROR.
        IF AVAILABLE supmmatg AND supmmatg.Libre_d01 <> 0 THEN DO:
            f-CanPed = (TRUNCATE((f-CanPed / supmmatg.Libre_d01),0) * supmmatg.Libre_d01).
        END.
        /* Redondeamos al empaque */
        pCanPed = ( f-CanPed - ( f-CanPed MODULO pFactor ) ) / pFactor.
    END.
    WHEN s-FlgEmpaque = YES THEN DO:
        /* En caso se determine el EMPAQUE */
        IF pEmpaque > 0 THEN DO:
            /* Devolvemos el sugerido */
            pCanPed = pSugerido / pFactor.
            /* Solo para un control de errores (si se desea) */
            f-CanPed = TRUNCATE((f-CanPed / pEmpaque),0) * pEmpaque.
            IF f-CanPed <> (x-CanPed * pFactor) THEN DO:
                pMensaje = 'Solo puede despachar en empaques de ' + STRING(pEmpaque) + ' ' + Almmmatg.UndBas.
                RETURN 'ADM-ERROR'.
            END.
        END.
    END.
END CASE.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-VTA_Valida-Minimo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE VTA_Valida-Minimo Procedure 
PROCEDURE VTA_Valida-Minimo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodMat AS CHAR.                                      
DEF INPUT-OUTPUT PARAMETER pCanPed AS DEC.
DEF INPUT PARAMETER pFactor AS DEC.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

/* ************************************************************************** */
/* Control de Mínimo de Ventas */
/* ************************************************************************** */
DEF VAR f-CanPed AS DEC NO-UNDO.
DEF VAR f-Minimo AS DEC NO-UNDO.

FIND FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = pCodMat NO-LOCK.
IF s-FlgMinVenta = YES THEN DO:
    CASE s-CodDiv:
        WHEN "00065" THEN DO:       /* CHICLAYO */
            IF Almmmatg.PesoBruto > 0 THEN DO:
                f-CanPed = pCanPed * pFactor.
                f-Minimo = Almmmatg.PesoBruto.
                IF f-Minimo > 0 THEN DO:
                    IF f-CanPed < f-Minimo THEN DO:
                        pMensaje = "ERROR el el artículo " + Almmmatg.codmat + CHR(10) +
                            "No se puede despachar menos de " + STRING(f-Minimo) + ' ' + Almmmatg.UndStk.
                        RETURN 'ADM-ERROR'.
                    END.
                    IF f-CanPed > f-Minimo AND Almmmatg.Paquete > 0 THEN DO:
                        IF (f-CanPed - f-Minimo) MODULO Almmmatg.Paquete > 0 THEN DO:
                            pMensaje = "ERROR el el artículo " + Almmmatg.codmat + CHR(10) +
                                  "No se puede despachar menos de " + STRING(f-Minimo) + ' ' + Almmmatg.UndStk + CHR(10) +
                                   "el incrementos de " + STRING(Almmmatg.Paquete) + ' ' + Almmmatg.UndStk.
                            RETURN 'ADM-ERROR'.
                        END.
                    END.
                END.
                ELSE IF Almmmatg.Paquete > 0 AND f-CanPed <> 1 THEN DO:
                    IF f-CanPed MODULO Almmmatg.Paquete > 0 THEN DO:
                        pMensaje = "ERROR el el artículo " + Almmmatg.codmat + CHR(10) +
                            "Solo se puede despachar en múltiplos de " + STRING(Almmmatg.Paquete) + ' ' + Almmmatg.UndStk.
                        RETURN 'ADM-ERROR'.
                    END.
                END.
            END.
        END.
        OTHERWISE DO:
            f-CanPed = pCanPed * pFactor.
            f-Minimo = Almmmatg.DEC__03.
            IF s-VentaMayorista = 2 THEN DO:  /* LISTA POR DIVISION */
                FIND FIRST VtaListaMay OF Almmmatg WHERE Vtalistamay.coddiv = s-coddiv NO-LOCK NO-ERROR.
                IF AVAILABLE VtaListaMay AND Vtalistamay.CanEmp > 0 THEN DO:
                    IF f-CanPed < Vtalistamay.CanEmp THEN DO:
                        pMensaje = 'Solo puede vender como mínimo ' + STRING(Vtalistamay.CanEmp) + ' ' + Almmmatg.UndBas.
                        RETURN "ADM-ERROR".
                    END.
                END.
            END.
            ELSE DO:      /* LISTA GENERAL */
                IF f-Minimo > 0 THEN DO:
                    IF f-CanPed < f-Minimo THEN DO:
                        pMensaje = 'Solo puede vender como mínimo ' + STRING(f-Minimo) + ' ' + Almmmatg.UndBas.
                        RETURN "ADM-ERROR".
                    END.
                END.
            END.
            IF s-TpoPed = "E" THEN DO:    /* Expolibreria */
                IF f-Minimo > 0 THEN DO:
                    f-CanPed = TRUNCATE((f-CanPed / f-Minimo),0) * f-Minimo.
                    IF f-CanPed <> pCanPed * pFactor THEN DO:
                        pMensaje = 'Solo puede vender en múltiplos de ' + STRING(f-Minimo) + ' ' + Almmmatg.UndBas.
                        RETURN "ADM-ERROR".
                    END.
                END.
            END.
        END.
    END CASE.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-VTA_Valida-Unidad) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE VTA_Valida-Unidad Procedure 
PROCEDURE VTA_Valida-Unidad :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF INPUT PARAMETER pCodMat AS CHAR.
  DEF INPUT PARAMETER pUndVta AS CHAR.
  DEF INPUT-OUTPUT PARAMETER pCanPed AS DEC.
  DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

  /* ************************************************************************** */
  /* Verificación de la Unidad de Venta */
  /* ************************************************************************** */
  IF TRUE <> (pUndVta > "") THEN DO:
       pMensaje = "La unidad está en blanco".
       RETURN "ADM-ERROR".
  END.
  FIND Unidades WHERE Unidades.Codunid = pUndVta NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Unidades OR Unidades.Libre_l01 = YES THEN DO:
      pMensaje = 'Unidad NO válida o inactiva'.
      RETURN "ADM-ERROR".
  END.
  FIND FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia NO-LOCK.
  FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
      AND Almtconv.Codalter = pUndVta
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almtconv THEN DO:
      pMensaje = 'NO está configurado el factor de equivalencia para el producto ' + 
          Almmmatg.codmat + CHR(10) +
          '    Unidad base: ' + Almmmatg.UndBas + CHR(10) +
          'Unidad de venta: ' + pUndVta.
      RETURN "ADM-ERROR".
  END.
  /* ************************************************************************** */
  /* Verificación de la cantidad vendida en base a la configuración de unidades */
  /* ************************************************************************** */
/*   DEF VAR x-CanPed AS DEC NO-UNDO.                                                                  */
/*   DEF VAR i-CanPed AS INT NO-UNDO.                                                                  */
/*                                                                                                     */
/*   x-CanPed = DECIMAL(pCanPed).                                                                      */
/*   i-CanPed = INTEGER(pCanPed).                                                                      */
/*   IF Unidades.Libre_L02 = YES THEN DO:                                                              */
/*       /* Unidad indivisible */                                                                      */
/*       IF x-CanPed <> i-CanPed THEN DO:                                                              */
/*           pMensaje = 'Solo se puede vender en valores enteros'.                                     */
/*           pCanPed = i-CanPed.                                                                       */
/*           RETURN 'ADM-ERROR'.                                                                       */
/*       END.                                                                                          */
/*   END.                                                                                              */
/*   ELSE DO:                                                                                          */
/*       /* Por múltiplos entonces */                                                                  */
/*       IF Almtconv.Multiplos <> 0 THEN DO:                                                           */
/*           IF (TRUNCATE(x-CanPed / Almtconv.Multiplos, 0) * Almtconv.Multiplos) <> x-CanPed THEN DO: */
/*               pMensaje = 'Solo se puede vender en múltiplos de ' + STRING(Almtconv.Multiplos).      */
/*               pCanPed = TRUNCATE(x-CanPed / Almtconv.Multiplos, 0) * Almtconv.Multiplos.            */
/*               RETURN 'ADM-ERROR'.                                                                   */
/*           END.                                                                                      */
/*       END.                                                                                          */
/*   END.                                                                                              */
  RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

