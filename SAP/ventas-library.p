&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW SHARED BUFFER B-CPEDI FOR FacCPedi.
DEFINE BUFFER B-DPEDI FOR FacDPedi.
DEFINE BUFFER COTIZACION FOR FacCPedi.
DEFINE TEMP-TABLE ITEM LIKE FacDPedi.
DEFINE BUFFER PCO FOR FacCPedi.
DEFINE TEMP-TABLE PEDI NO-UNDO LIKE FacDPedi.
DEFINE TEMP-TABLE T-LogTabla NO-UNDO LIKE logtabla.



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

DEFINE VAR cMsgProcesoBatch AS CHAR.
DEFINE VAR lProcesoBatch AS LOG.
DEFINE VAR pCodCot AS CHAR.
DEFINE VAR pNroCot AS CHAR.

DEF SHARED VAR s-codcia AS INT.   
DEF SHARED VAR cl-codcia AS INT.   
DEF SHARED VAR s-user-id AS CHAR. 
DEF SHARED VAR s-coddiv AS CHAR.    
DEFINE SHARED VAR s-DiasVtoPed LIKE GN-DIVI.DiasVtoPed.
DEFINE SHARED VAR s-FlgEmpaque  LIKE GN-DIVI.FlgEmpaque.
DEFINE SHARED VAR s-VentaMayorista LIKE GN-DIVI.VentaMayorista.
/* ICBPER */ 
DEFINE VAR x-articulo-ICBPER AS CHAR.

x-articulo-ICBPER = '099268'.

DEF VAR s-PorIgv LIKE Ccbcdocu.PorIgv.

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
      TABLE: B-CPEDI B "NEW SHARED" ? INTEGRAL FacCPedi
      TABLE: B-DPEDI B "?" ? INTEGRAL FacDPedi
      TABLE: COTIZACION B "?" ? INTEGRAL FacCPedi
      TABLE: ITEM T "?" ? INTEGRAL FacDPedi
      TABLE: PCO B "?" ? INTEGRAL FacCPedi
      TABLE: PEDI T "?" NO-UNDO INTEGRAL FacDPedi
      TABLE: T-LogTabla T "?" NO-UNDO INTEGRAL logtabla
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 8.23
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

DEF INPUT PARAMETER s-PorIgv AS DEC.
DEF OUTPUT PARAMETER pFchEnt AS DATE.
DEF OUTPUT PARAMETER xNroPCO AS CHAR.
DEF OUTPUT PARAMETER s-NroCot AS CHAR.
DEF OUTPUT PARAMETER s-CodAlm AS CHAR.
DEF OUTPUT PARAMETER s-Tipo-Abastecimiento AS CHAR.
DEF OUTPUT PARAMETER TABLE FOR PEDI. 

EMPTY TEMP-TABLE PEDI.

DEF VAR s-CodRef AS CHAR INIT "COT" NO-UNDO.

cMsgProcesoBatch = "".

ASSIGN
    xNroPCO = ''
    s-NroCot = ''
    pFchEnt = TODAY.
/* ************************************************************************************** */
/* 1ro. Solicitamos la COTIZACION o PCO */
/* ************************************************************************************** */

IF lProcesoBatch = NO THEN DO:
    RUN logis/d-cot-pco-pendientes.r(OUTPUT s-CodRef, OUTPUT s-NroCot).
    IF TRUE <> (s-NroCot > "") THEN RETURN "ADM-ERROR".

    pCodCot = s-codref.
    pNroCot = s-NroCot.
END.
ELSE DO:
    s-CodRef = pCodCot. /* COT */
    s-NroCot = pNroCot.
END.
/* ************************************************************************************** */
/* 2do. Solicitamos los ITEMS de la COTIZACION */
/* ************************************************************************************** */
CASE TRUE:
  WHEN s-CodRef = "PCO" THEN DO:
      /* POR PRE-COTIZACIONES */
      s-CodAlm = ''.
      xNroPCO = s-NroCot.
      FOR EACH Vtaddocu NO-LOCK  WHERE VtaDDocu.CodCia = s-CodCia AND
          VtaDDocu.CodPed = s-CodRef AND
          VtaDDocu.NroPed = xNroPCO
          BREAK BY VtaDDocu.AlmDes:
          IF FIRST-OF(VtaDDocu.AlmDes) THEN DO:
              s-CodAlm = s-CodAlm + (IF TRUE <> (s-CodAlm > '') THEN '' ELSE ',') +
                  VtaDDocu.AlmDes.
          END.
      END.
      FIND FIRST PCO WHERE PCO.CodCia = s-CodCia AND 
          PCO.CodDoc = "PCO" AND 
          PCO.NroPed = xNroPCO
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE PCO THEN DO:
          cMsgProcesoBatch = 'No se pudo ubicar la PRE-COTIZACION ' + string(xNroPco).
          IF lProcesoBatch = NO THEN MESSAGE cMsgProcesoBatch  VIEW-AS ALERT-BOX ERROR.
          RETURN 'ADM-ERROR'.
      END.
      ASSIGN 
          s-NroCot = ENTRY(1, xNroPCO, '-')   /* <<< OJO <<< */
          pFchEnt = PCO.FchEnt
          s-Tipo-Abastecimiento = "PCO".
  END.
  OTHERWISE DO:
      /* PEDIDOS NORMALES */
      IF lProcesoBatch = NO THEN DO:
          RUN SAP/d-pedido-tablet.r (INPUT s-CodRef, INPUT s-NroCot, OUTPUT s-CodAlm, OUTPUT TABLE PEDI).
          IF TRUE <> (s-CodAlm > "") THEN RETURN "ADM-ERROR".
      END.
      ELSE DO:
          /* Cargar los items  */
          RUN PED_carga_producto(OUTPUT s-codalm).
          
      END.
      /* *********************************** */
      FIND FIRST COTIZACION WHERE COTIZACION.codcia = s-codcia
              AND COTIZACION.coddiv = s-CodDiv
              AND COTIZACION.coddoc = s-CodRef
              AND COTIZACION.nroped = s-NroCot
              NO-LOCK NO-ERROR.
      IF NOT AVAILABLE COTIZACION THEN DO:
          cMsgProcesoBatch = 'Cotización ' + string(s-NroCot) +  ' NO se pudo ubicar'.
          IF lProcesoBatch = NO THEN MESSAGE cMsgProcesoBatch  VIEW-AS ALERT-BOX ERROR.
          RETURN 'ADM-ERROR'.
      END.
      ASSIGN
          pFchEnt = COTIZACION.FchEnt
          s-Tipo-Abastecimiento = "NORMAL".
  END.
END CASE.
FIND FIRST COTIZACION WHERE COTIZACION.codcia = s-CodCia AND
    COTIZACION.coddiv = s-CodDiv AND
    COTIZACION.coddoc = "COT" AND
    COTIZACION.nroped = s-NroCot NO-LOCK NO-ERROR.
IF NOT AVAILABLE COTIZACION THEN DO:
    cMsgProcesoBatch = 'Cotización ' + string(s-NroCot) +  ' NO se pudo ubicar'.
    IF lProcesoBatch = NO THEN MESSAGE cMsgProcesoBatch  VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.

/* DISTRIBUYE LOS PRODUCTOS POR ORDEN DE ALMACENES */
CASE s-Tipo-Abastecimiento:
    WHEN "PCO" THEN DO:
        /* Ic - 20Set2024, este procedimiento no se adecuo para riqra */
        RUN PED_Asigna-PCO (xNroPCO, s-PorIgv).
        IF RETURN-VALUE = "ADM-ERROR" THEN RETURN 'ADM-ERROR'.
    END.
    OTHERWISE DO:

        RUN PED_Asigna-Cotizacion (s-CodAlm, s-PorIgv).
        
        IF RETURN-VALUE = "ADM-ERROR" THEN RETURN 'ADM-ERROR'.
    END.
END CASE.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PED_Asigna-Cotizacion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PED_Asigna-Cotizacion Procedure 
PROCEDURE PED_Asigna-Cotizacion PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Se supone que ya viene con el saldo disponible
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pCodAlm AS CHAR.
  DEFINE INPUT PARAMETER s-PorIgv AS DEC.

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
  DEF VAR x-Lista_de_Precios AS CHAR NO-UNDO.     /* Por compatibilidad */

  IF TRUE <> (COTIZACION.Lista_de_Precios > '') 
      THEN x-Lista_de_Precios = COTIZACION.Libre_c01.
  ELSE x-Lista_de_Precios = COTIZACION.Lista_de_Precios.

  DEF BUFFER B-DIVI FOR gn-divi.
  FIND B-DIVI WHERE B-DIVI.codcia = s-codcia AND B-DIVI.coddiv = x-Lista_de_Precios NO-LOCK NO-ERROR.
  IF AVAILABLE B-DIVI THEN DO:
      ASSIGN
          s-DiasVtoPed = B-DIVI.DiasVtoPed
          s-FlgEmpaque = B-DIVI.FlgEmpaque
          s-VentaMayorista = B-DIVI.VentaMayorista.
  END.
  /* **************************************************** */
  /* RHC 30/03/2022 Validación VENTA DELIVERY             */
  /* **************************************************** */
  DEF VAR x-VentaDelivery AS LOG NO-UNDO.
  FIND FIRST FacTabla WHERE FacTabla.CodCia = s-CodCia AND
      FacTabla.Tabla = "GN-DIVI" AND
      FacTabla.Codigo = COTIZACION.CodDiv AND
      FacTabla.Campo-L[3] = YES   /* Solo pedidos al 100% */
      NO-LOCK NO-ERROR.
  IF AVAILABLE FacTabla THEN x-VentaDelivery = YES.
  ELSE x-VentaDelivery = NO.
  /* **************************************************** */
  IF lProcesoBatch = NO THEN DO:
      DEFINE FRAME F-Mensaje
        'Procesando: ' Facdpedi.codmat SKIP(1)
        'Espere un momento por favor ...' SKIP
        WITH CENTERED NO-LABELS OVERLAY VIEW-AS DIALOG-BOX TITLE 'TRASLADANDO COTIZACION'.
  END.

  i-NPedi = 0.

  /* VERIFICACION DE LOS SALDOS DE LA COTIZACION */
  DEF VAR pMensaje AS CHAR NO-UNDO.

  RUN VTA_Verifica-Saldo-COT (OUTPUT pMensaje).
  
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      cMsgProcesoBatch = pMensaje.
      IF lProcesoBatch = NO THEN MESSAGE pMensaje VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
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
  EMPTY TEMP-TABLE ITEM.
  EMPTY TEMP-TABLE T-LogTabla.
  FOR EACH PEDI:
      CREATE ITEM.
      BUFFER-COPY PEDI TO ITEM.
  END.
  EMPTY TEMP-TABLE PEDI.
  /* ********************************************* */
  ALMACENES:
  FOR EACH ITEM NO-LOCK,     
      FIRST Facdpedi OF COTIZACION NO-LOCK WHERE Facdpedi.CodMat = ITEM.CodMat,
      FIRST Almmmatg OF Facdpedi NO-LOCK,
      FIRST Almtfami OF Almmmatg NO-LOCK
      BY ITEM.CodMat:

      IF lProcesoBatch = NO THEN DISPLAY Facdpedi.codmat WITH FRAME F-Mensaje.
      ASSIGN
          f-Factor = Facdpedi.Factor
          t-AlmDes = ''
          t-CanPed = 0.
      x-CodAlm = ENTRY(1, pCodAlm).   /* Por si acaso, aunque solo debería tener un almacén */
      F-CANPED = ITEM.CanPed.       /* OJO */
      /* FILTROS */
      /* 07/05/2026: NO controlar si está asignado o no */
/*       FIND FIRST Almmmate WHERE Almmmate.codcia = s-codcia                                                  */
/*           AND Almmmate.codalm = x-CodAlm  /* *** OJO *** */                                                 */
/*           AND Almmmate.codmat = Facdpedi.CodMat                                                             */
/*           NO-LOCK NO-ERROR.                                                                                 */
/*                                                                                                             */
/*       IF NOT AVAILABLE Almmmate THEN DO:                                                                    */
/*           cMsgProcesoBatch = 'Producto ' + Facdpedi.codmat + ' NO asignado al almacén (' + x-CodAlm + ")" . */
/*                                                                                                             */
/*           IF lProcesoBatch = NO THEN DO:                                                                    */
/*               MESSAGE 'Producto' Facdpedi.codmat 'NO asignado al almacén:' x-CodAlm  SKIP(1)                */
/*                   'Comunicarse con el Gestor de Almacenes'                                                  */
/*                   VIEW-AS ALERT-BOX INFORMATION                                                             */
/*                   TITLE 'VERIFICACION DE ARTICULOS'.                                                        */
/*           END.                                                                                              */
/*           IF x-VentaDelivery = YES THEN RETURN 'ADM-ERROR'. /* Corta el Proceso */                          */
/*           NEXT ALMACENES.                                                                                   */
/*       END.                                                                                                  */

      /* ******************************************************************** */
      /* RHC 23/07/2018 SOLAMENTE CARGAMOS T-LOGTABLA CON EL TOPE DE DESPACHO */
      /* ******************************************************************** */
      DEF VAR pAlmSug AS CHAR NO-UNDO.
      DEF VAR pRetirar AS LOG NO-UNDO.
      RUN SAP/p-tope-pedido (Facdpedi.CodMat,
                             x-CodAlm,
                             f-CanPed * f-Factor,
                             YES,
                             INPUT-OUTPUT TABLE T-LogTabla,
                             OUTPUT pAlmSug,
                             OUTPUT pRetirar).
      /* ******************************************************************** */
      /* RHC 09/07/2020 NO verifica stock disponible en los siguientes casos:
      - Impuesto a la bolsa plástica
      - Servicios 
      - Drop Shipping
      */
      /* ******************************************************************** */
      /* DEFINIMOS LA CANTIDAD */
      x-CanPed = f-CanPed * f-Factor.   /* En unidades de stock */
      f-CanPed = f-CanPed * f-Factor.   /* En unidades de Stock */
/*       /* EMPAQUE SUPERMERCADOS */                                                                  */
/*       FIND FIRST supmmatg WHERE supmmatg.codcia = COTIZACION.CodCia                                */
/*         AND supmmatg.codcli = COTIZACION.CodCli                                                    */
/*         AND supmmatg.codmat = FacDPedi.codmat                                                      */
/*         NO-LOCK NO-ERROR.                                                                          */
/*       IF AVAILABLE supmmatg AND supmmatg.Libre_d01 <> 0 THEN DO:                                   */
/*           f-CanPed = (TRUNCATE((f-CanPed / supmmatg.Libre_d01),0) * supmmatg.Libre_d01).           */
/*       END.                                                                                         */
/*       ELSE DO:    /* EMPAQUE OTROS */                                                              */
          IF s-FlgEmpaque = YES THEN DO:
              RUN vtagn/p-cantidad-sugerida.p (COTIZACION.TpoPed,   /*s-TpoPed,*/
                                               Facdpedi.CodMat,
                                               f-CanPed,
                                               OUTPUT pSugerido,
                                               OUTPUT pEmpaque).
              f-CanPed = pSugerido.
          END.
/*       END.                                                                                         */
      f-CanPed = ((f-CanPed - (f-CanPed MODULO f-Factor)) / f-Factor).  /* En unidades de venta */

      IF f-CanPed <= 0 THEN NEXT ALMACENES.
      /* Ya vienen los artículos redondeamos al empaque */
      ASSIGN
          x-CanPed = f-CanPed.
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
                  PEDI.CodCli = COTIZACION.CodCli
                  PEDI.ALMDES = t-AlmDes  /* *** OJO *** */
                  PEDI.NroItm = I-NPEDI
                  PEDI.CanPed = t-CanPed    /* << OJO << */
                  PEDI.CanAte = 0.
          ASSIGN
              PEDI.Libre_d01 = (FacDPedi.CanPed - FacDPedi.CanAte)
              PEDI.Libre_c01 = '*'.
          /* RHC 28/04/2016 Caso extraño */
          IF PEDI.CanPed > PEDI.Libre_d01 
              THEN ASSIGN PEDI.CanPed = PEDI.Libre_d01 PEDI.Libre_d02 = PEDI.Libre_d01.
          /* *************************** */
          IF PEDI.CanPed <> facdPedi.CanPed THEN DO:
              {vta2/calcula-linea-detalle.i &Tabla="PEDI"}.
          END.
          /* FIN DE CARGA */
      END.
  END.
  IF lProcesoBatch = NO THEN HIDE FRAME F-Mensaje.
  /* ******************************************************************** */
  /* ******************************************************************** */
  /* SI HUBIERA UN PRODUCTO CON UNA OBSERVACION => SE PRESENTA UNA VENTANA*/
  IF lProcesoBatch = NO THEN RUN vta2/d-ped-tope-despacho.
  /* ******************************************************************** */
  /* ******************************************************************** */
  RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PED_Asigna-PCO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PED_Asigna-PCO Procedure 
PROCEDURE PED_Asigna-PCO PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pNroPCO AS CHAR.
  DEFINE INPUT PARAMETER s-PorIgv AS DEC.
                        
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
  DEF VAR x-Lista_de_Precios AS CHAR NO-UNDO.     /* Por compatibilidad */

  IF TRUE <> (COTIZACION.Lista_de_Precios > '') 
      THEN x-Lista_de_Precios = COTIZACION.Libre_c01.
      ELSE x-Lista_de_Precios = COTIZACION.Lista_de_Precios.

  DEF BUFFER B-DIVI FOR gn-divi.

  FIND FIRST B-DIVI WHERE B-DIVI.codcia = s-codcia AND B-DIVI.coddiv = x-Lista_de_Precios NO-LOCK NO-ERROR.
  IF AVAILABLE B-DIVI THEN DO:
      ASSIGN
          s-DiasVtoPed = B-DIVI.DiasVtoPed
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
  DEF VAR pMensaje AS CHAR NO-UNDO.
  
  RUN VTA_Verifica-Saldo-COT (OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      MESSAGE pMensaje VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
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
  FOR EACH Facdpedi OF COTIZACION NO-LOCK,
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
      /* NOTA: La COT YA está afecta la CanAte por el PCO  */
      x-CodAlm = VtaDDocu.AlmDes.   /* <<< OJO <<< */
      F-CANPED = VtaDDocu.CanPed.   /* <<< OJO <<< */
      /* ************************************************* */
      /* FILTROS */
      /* 07/05/2026: NO validar si está asignado al almacén */
/*       FIND FIRST Almmmate WHERE Almmmate.codcia = s-codcia                     */
/*           AND Almmmate.codalm = x-CodAlm  /* *** OJO *** */                    */
/*           AND Almmmate.codmat = Facdpedi.CodMat                                */
/*           NO-LOCK NO-ERROR.                                                    */
/*       IF NOT AVAILABLE Almmmate THEN DO:                                       */
/*           MESSAGE 'Producto' Facdpedi.codmat 'NO asignado al almacén' x-CodAlm */
/*               VIEW-AS ALERT-BOX INFORMATION.                                   */
/*           NEXT ALMACENES.                                                      */
/*       END.                                                                     */
      /* ******************************************************************** */
      /* RHC 23/07/2018 SOLAMENTE CARGAMOS T-LOGTABLA CON EL TOPE DE DESPACHO */
      /* ******************************************************************** */
      DEF VAR pAlmSug AS CHAR NO-UNDO.
      DEF VAR pRetirar AS LOG NO-UNDO.

      RUN SAP/p-tope-pedido (Facdpedi.CodMat,
                             x-CodAlm,
                             f-CanPed * f-Factor,
                             YES,
                             INPUT-OUTPUT TABLE T-LogTabla,
                             OUTPUT pAlmSug,
                             OUTPUT pRetirar).
      /* ******************************************************************** */
      /* Stock Disponible */
      /* ******************************************************************** */
      ASSIGN
          x-StkAct = Almmmate.StkAct
          s-StkComprometido = 0.
      IF x-StkAct > 0 THEN RUN SAP/Stock-Comprometido (INPUT Facdpedi.CodMat, 
                                                       INPUT x-CodAlm, 
                                                       INPUT YES, 
                                                       OUTPUT s-StkComprometido).
      /* ******************************************************************** */
      /* RHC 29/04/2020 Tener cuidado, las COT también comprometen mercadería */
      /* ******************************************************************** */
      FIND FIRST FacTabla WHERE FacTabla.CodCia = COTIZACION.CodCia AND
          FacTabla.Tabla = "GN-DIVI" AND
          FacTabla.Codigo = COTIZACION.CodDiv AND
          FacTabla.Campo-L[2] = YES AND   /* Reserva Stock? */
          FacTabla.Valor[1] > 0           /* Horas de reserva */
          NO-LOCK NO-ERROR.
      IF AVAILABLE FacTabla THEN DO:
          /* Si ha llegado hasta acá es que está dentro de las horas de reserva */
          /* Afectamos lo comprometido: extornamos el comprometido */
          s-StkComprometido = s-StkComprometido - (Facdpedi.Factor * (Facdpedi.CanPed - Facdpedi.CanAte)).
      END.
      /* ******************************************************************** */
      /* ******************************************************************** */
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
            DEF VAR pMaster AS DECI NO-UNDO.
            DEF VAR pInner  AS DECI NO-UNDO.

            RUN vtagn/p-sugerido-ped-logistico.p (INPUT Facdpedi.codmat,
                                                  INPUT f-CanPed / f-Factor,    /* En unidades de venta */
                                                  INPUT f-Factor,
                                                  INPUT x-Lista_de_Precios,
                                                  OUTPUT pSugerido,             /* En unidades de venta */
                                                  OUTPUT pMaster,
                                                  OUTPUT pInner).
            f-CanPed = pSugerido.
      END.
      ELSE DO:
          f-CanPed = ((f-CanPed - (f-CanPed MODULO f-Factor)) / f-Factor).  /* En unidades de venta */
      END.
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
                  PEDI.CodCli = COTIZACION.CodCli
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
          {vta2/calcula-linea-detalle.i &Tabla="PEDI"}.
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

&IF DEFINED(EXCLUDE-PED_carga_producto) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PED_carga_producto Procedure 
PROCEDURE PED_carga_producto PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT        PARAMETER x-CodAlm AS CHAR.
/*
DEF INPUT-OUTPUT PARAMETER I-NPEDI  AS INTE NO-UNDO.
*/
DEF VAR f-Factor AS DEC NO-UNDO.
DEF VAR t-AlmDes AS CHAR NO-UNDO.
DEF VAR t-CanPed AS DEC NO-UNDO.
DEF VAR F-CANPED AS DECIMAL NO-UNDO.
DEF VAR x-StkAct AS DEC NO-UNDO.
DEF VAR s-StkComprometido AS DEC.
DEF VAR s-StkDis AS DEC NO-UNDO.
DEF VAR x-CanPed AS DEC NO-UNDO.
DEF VAR pSugerido AS DEC NO-UNDO.
DEF VAR pEmpaque AS DEC NO-UNDO.
DEF VAR pAlmSug AS CHAR NO-UNDO.
DEF VAR pRetirar AS LOG NO-UNDO.
DEF VAR s-CodDoc AS CHAR INIT "PED" NO-UNDO.

DEFINE VAR I-NPEDI AS INT.

DEF VAR x-CuentaItems AS INT NO-UNDO.

DEF BUFFER B-DIVI FOR gn-divi.
DEF VAR x-Lista_de_Precios AS CHAR NO-UNDO.     /* Por compatibilidad */

IF TRUE <> (B-CPEDI.Lista_de_Precios > '') 
    THEN x-Lista_de_Precios = B-CPEDI.Libre_c01.
    ELSE x-Lista_de_Precios = B-CPEDI.Lista_de_Precios.
FIND B-DIVI WHERE B-DIVI.codcia = s-codcia AND B-DIVI.coddiv = x-Lista_de_Precios NO-LOCK NO-ERROR.
IF AVAILABLE B-DIVI THEN DO:
    ASSIGN
        s-DiasVtoPed = B-DIVI.DiasVtoPed
        s-FlgEmpaque = B-DIVI.FlgEmpaque
        s-VentaMayorista = B-DIVI.VentaMayorista.
END.
x-CodAlm = B-CPEDI.codalm.

/* RHC 12/06/2020 las líneas con Categoria Contable SV NO verifican stock */
/* 1ro. Cargamos Productos que NO sean SV */
/* RHC 09/07/2020 Productos Drop Shipping NO verifican stock */
ALMACENES:
FOR EACH Facdpedi OF B-CPEDI NO-LOCK WHERE (Facdpedi.CanPed - Facdpedi.CanAte) > 0,   
    FIRST Almmmatg OF Facdpedi NO-LOCK, 
    FIRST Almtfami OF Almmmatg NO-LOCK:
    /* ************************************************************************* */
    CASE TRUE:
        WHEN Almtfami.Libre_c01 = "SV" THEN NEXT.
        OTHERWISE DO:
            /* ************************************************************************* */
            /* Buscamos si es Drop Shipping */
            /* ************************************************************************* */
            FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia AND
                VtaTabla.Tabla = "DROPSHIPPING" AND
                VtaTabla.Llave_c1 = Facdpedi.CodMat 
                NO-LOCK NO-ERROR.
            IF AVAILABLE VtaTabla THEN NEXT.
        END.
    END CASE.
    /* ************************************************************************* */
    x-CuentaItems = x-CuentaItems + 1.
    
    ASSIGN
        f-Factor = Facdpedi.Factor
        t-AlmDes = ''
        t-CanPed = 0.
    ASSIGN
        F-CANPED = (FacDPedi.CanPed - FacDPedi.CanAte).
    /* FILTROS */
    FIND Inventory_SAP WHERE Inventory_SAP.WarehouseCode = x-CodAlm AND
        Inventory_SAP.ItemCode = Facdpedi.codmat
        NO-LOCK NO-ERROR NO-WAIT.
    /* ******************************************************************** */
    /* Stock Disponible */
    /* ******************************************************************** */
    x-StkAct = 0.
    s-StkComprometido = 0.
    IF AVAILABLE Inventory_SAP THEN x-StkAct = Inventory_SAP.Quantity.
    IF x-StkAct > 0 AND x-articulo-ICBPER <> Facdpedi.CodMat THEN DO:
        /* Si es un "SV" el stock comprometido es cero */
        RUN SAP/Stock-Comprometido.r (INPUT Facdpedi.CodMat, 
                                      INPUT x-CodAlm, 
                                      INPUT YES, 
                                      OUTPUT s-StkComprometido).
        /* RHC 29/04/2020 Tener cuidado, las COT también comprometen mercadería */
        FIND FacTabla WHERE FacTabla.CodCia = B-CPEDI.CodCia AND
            FacTabla.Tabla = "GN-DIVI" AND
            FacTabla.Codigo = B-CPEDI.CodDiv AND
            FacTabla.Campo-L[2] = YES AND   /* Reserva Stock? */
            FacTabla.Valor[1] > 0           /* Horas de reserva */
            NO-LOCK NO-ERROR.
        IF AVAILABLE FacTabla AND s-StkComprometido > 0 THEN DO:
            /* Si ha llegado hasta acá es que está dentro de las horas de reserva */
            /* Afectamos lo comprometido: extornamos el comprometido */
            s-StkComprometido = s-StkComprometido - (Facdpedi.Factor * (Facdpedi.CanPed - Facdpedi.CanAte)).
        END.
    END.
    ASSIGN
        s-StkDis = x-StkAct - s-StkComprometido.
    IF s-StkDis <= 0 THEN NEXT.     /* NO HAY STOCK: Pasamos al siquiente Producto */
    /* ******************************************************************** */
    /* DEFINIMOS LA CANTIDAD */
    /* ******************************************************************** */
    x-CanPed = f-CanPed * f-Factor.   /* En unidades de stock */
    IF s-StkDis < x-CanPed THEN DO:
        /* Se ajusta la Cantidad Pedida al Saldo Disponible del Almacén */
        f-CanPed = ((S-STKDIS - (S-STKDIS MODULO f-Factor)) / f-Factor).
    END.
    f-CanPed = f-CanPed * f-Factor.   /* En unidades de Stock */
    /* ******************************************************************** */
    /* EMPAQUE SUPERMERCADOS */
    /* ******************************************************************** */
    FIND FIRST supmmatg WHERE supmmatg.codcia = B-CPedi.CodCia
        AND supmmatg.codcli = B-CPedi.CodCli
        AND supmmatg.codmat = FacDPedi.codmat 
        NO-LOCK NO-ERROR.
    IF AVAILABLE supmmatg AND supmmatg.Libre_d01 <> 0 THEN DO:
        f-CanPed = (TRUNCATE((f-CanPed / supmmatg.Libre_d01),0) * supmmatg.Libre_d01).
        f-CanPed = ((f-CanPed - (f-CanPed MODULO f-Factor)) / f-Factor).  /* En unidades de venta */
    END.
    ELSE DO:    /* EMPAQUE OTROS */
        IF s-FlgEmpaque = YES THEN DO:
            DEF VAR pMaster AS DECI NO-UNDO.
            DEF VAR pInner  AS DECI NO-UNDO.

            RUN vtagn/p-sugerido-ped-logistico.p (INPUT Facdpedi.codmat,
                                                  INPUT f-CanPed / f-Factor,    /* En unidades de venta */
                                                  INPUT f-Factor,
                                                  INPUT x-Lista_de_Precios,
                                                  OUTPUT pSugerido,             /* En unidades de venta */
                                                  OUTPUT pMaster,
                                                  OUTPUT pInner).
            f-CanPed = pSugerido.
        END.
        ELSE DO:
            f-CanPed = ((f-CanPed - (f-CanPed MODULO f-Factor)) / f-Factor).  /* En unidades de venta */
        END.
    END.
    
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
                PEDI.CodDoc = s-coddoc
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
            THEN ASSIGN 
                    PEDI.CanPed = PEDI.Libre_d01 
                    PEDI.Libre_d02 = PEDI.Libre_d01.
        /* *************************** */
        IF PEDI.CanPed <> facdPedi.CanPed THEN DO:
            {vta2/calcula-linea-detalle.i &Tabla="PEDI"}.
        END.
        /* FIN DE CARGA */
    END.
END.
/* ******************************************************************** */
/* 2do. Cargamos Productos que SI sean SV */
/* ******************************************************************** */
SERVICIOS:
FOR EACH Facdpedi OF B-CPEDI NO-LOCK WHERE (Facdpedi.CanPed - Facdpedi.CanAte) > 0,   
    FIRST Almmmatg OF Facdpedi NO-LOCK, 
    FIRST Almtfami OF Almmmatg NO-LOCK WHERE Almtfami.Libre_c01 = "SV":
    /* ************************************************************************* */
    /* Buscamos si es Drop Shipping */
    /* ************************************************************************* */
    FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia AND
        VtaTabla.Tabla = "DROPSHIPPING" AND
        VtaTabla.Llave_c1 = Facdpedi.CodMat 
        NO-LOCK NO-ERROR.
    IF AVAILABLE VtaTabla THEN NEXT.
    /* ************************************************************************* */    
    x-CuentaItems = x-CuentaItems + 1.
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
            PEDI.CodDoc = s-coddoc
            PEDI.NroPed = ''
            PEDI.CodCli = B-CPEDI.CodCli
            PEDI.ALMDES = x-CodAlm  /* *** OJO *** */
            PEDI.NroItm = I-NPEDI
            PEDI.CanPed = (Facdpedi.CanPed - Facdpedi.CanAte)
            PEDI.CanAte = 0.
    ASSIGN
        PEDI.Libre_d01 = (FacDPedi.CanPed - FacDPedi.CanAte)
        PEDI.Libre_d02 = (FacDPedi.CanPed - FacDPedi.CanAte)
        PEDI.Libre_c01 = '*'.
    /* *************************** */
    IF PEDI.CanPed <> facdPedi.CanPed THEN DO:
        {vta2/calcula-linea-detalle.i &Tabla="PEDI"}.
    END.
    /* FIN DE CARGA */
END.
/* ******************************************************************** */
/* 3ro. Cargamos Productos que SI sean Drop Shipping */
/* ******************************************************************** */
DROPSHIPPING:
FOR EACH Facdpedi OF B-CPEDI NO-LOCK WHERE (Facdpedi.CanPed - Facdpedi.CanAte) > 0,
    FIRST Almmmatg OF Facdpedi NO-LOCK, 
    FIRST Almtfami OF Almmmatg NO-LOCK WHERE Almtfami.Libre_c01 <> "SV":
    /* ************************************************************************* */
    /* Buscamos si es Drop Shipping */
    /* ************************************************************************* */
    FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia AND
        VtaTabla.Tabla = "DROPSHIPPING" AND
        VtaTabla.Llave_c1 = Facdpedi.CodMat 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE VtaTabla THEN NEXT.
    /* ************************************************************************* */
    /* ************************************************************************* */    
    x-CuentaItems = x-CuentaItems + 1.
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
            PEDI.CodDoc = s-coddoc
            PEDI.NroPed = ''
            PEDI.CodCli = B-CPEDI.CodCli
            PEDI.ALMDES = x-CodAlm  /* *** OJO *** */
            PEDI.NroItm = I-NPEDI
            PEDI.CanPed = (Facdpedi.CanPed - Facdpedi.CanAte)
            PEDI.CanAte = 0.
    ASSIGN
        PEDI.Libre_d01 = (FacDPedi.CanPed - FacDPedi.CanAte)
        PEDI.Libre_d02 = (FacDPedi.CanPed - FacDPedi.CanAte)
        PEDI.Libre_c01 = '*'.
    /* *************************** */
    IF PEDI.CanPed <> facdPedi.CanPed THEN DO:
        {vta2/calcula-linea-detalle.i &Tabla="PEDI"}.
    END.
    /* FIN DE CARGA */
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-VTA_Verifica-Saldo-COT) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE VTA_Verifica-Saldo-COT Procedure 
PROCEDURE VTA_Verifica-Saldo-COT PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

  /* VERIFICACION DE LOS SALDOS DE LA COTIZACION */
  DEF VAR x-CanAte AS DECI NO-UNDO.
  DEF BUFFER B-DCOT FOR Facdpedi.

  FOR EACH Facdpedi OF COTIZACION NO-LOCK WHERE (Facdpedi.CanPed - Facdpedi.CanAte) > 0:
      IF Facdpedi.CanAte < 0 THEN DO:
          FIND B-DCOT WHERE ROWID(B-DCOT) = ROWID(Facdpedi) EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
          IF AVAILABLE B-DCOT THEN DO:
              x-canate = 0.
              FOR EACH b-cpedi NO-LOCK WHERE b-cpedi.codcia = COTIZACION.codcia
                  AND b-cpedi.coddoc = 'PED'
                  AND b-cpedi.coddiv = COTIZACION.coddiv
                  AND b-cpedi.codref = COTIZACION.coddoc
                  AND b-cpedi.nroref = COTIZACION.nroped
                  AND LOOKUP(b-cpedi.flgest, 'C,G,X') > 0,
                  EACH b-dpedi OF b-cpedi NO-LOCK WHERE b-dpedi.codmat = B-DCOT.codmat:
                  x-canate = x-canate + b-dpedi.canped.
              END.
              IF B-DCOT.canate <> x-canate  THEN B-DCOT.canate = x-canate.
          END.
          ELSE DO:
              pMensaje = 'Hay una inconsistencia en el producto: ' + Facdpedi.codmat + CHR(10) +
                  'No se pudo actualizar el saldo correctamente' + CHR(10) +
                  'Registro en uso por otro usuario' + CHR(10) +
                  'Proceso abortado, vuelva a intentarlo en un momento'.
              RETURN 'ADM-ERROR'.
          END.
      END.
  END.
  RELEASE B-DCOT.
  RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

