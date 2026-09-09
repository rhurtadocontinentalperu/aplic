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


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fClasificacion Include 
FUNCTION fClasificacion RETURNS CHARACTER
  ( INPUT pCodMat AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fClfGral Include 
FUNCTION fClfGral RETURNS CHARACTER
  ( INPUT pCodMat AS CHAR, INPUT pReposicion AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fClfMayo Include 
FUNCTION fClfMayo RETURNS CHARACTER
  ( INPUT pCodMat AS CHAR, INPUT pReposicion AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fClfUtil Include 
FUNCTION fClfUtil RETURNS CHARACTER
  ( INPUT pCodMat AS CHAR, INPUT pReposicion AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fCompraTransito Include 
FUNCTION fCompraTransito RETURNS DECIMAL
  ( INPUT pCodAlm AS CHAR, INPUT pCodMat AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fFSDespacho Include 
FUNCTION fFSDespacho RETURNS DECIMAL
  ( INPUT pAlmPed AS CHAR, INPUT pCodMat AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fStkDisponible Include 
FUNCTION fStkDisponible RETURNS DECIMAL
  ( INPUT pCodAlm AS CHAR,
    INPUT pCodMat AS CHAR ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fStockComprometido Include 
FUNCTION fStockComprometido RETURNS DECIMAL
  ( INPUT pCodMat AS CHAR, INPUT pCodAlm AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fStockTransito Include 
FUNCTION fStockTransito RETURNS DECIMAL
  ( INPUT pCodAlm AS CHAR, INPUT pCodMat AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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
         HEIGHT             = 11
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ARTICULOS-A-SOLICITAR Include 
PROCEDURE ARTICULOS-A-SOLICITAR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pTipoCalculo AS CHAR.

FIND FIRST B-MATE WHERE B-MATE.codcia = s-codcia
    AND B-MATE.codalm = s-codalm
    AND B-MATE.codmat = pCodMat
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-MATE THEN RETURN 'OK'.
/* RHC 12/03/2019 Depuramos */
IF pTipoCalculo = "AUT" THEN DO:
    IF (B-MATE.StkMin + B-MATE.VCtMn1 + B-MATE.VCtMn2) = 0
        THEN DO:
        RETURN 'OK'.
    END.
END.
/* ************************ */

DEF VAR pStkComprometido AS DEC NO-UNDO.
DEF VAR pStockTransito   AS DEC NO-UNDO.
DEF VAR pCompraTransito  AS DEC NO-UNDO.

/* *********************************************************************** */
/* 2do DEFINIMOS LA CANTIDAD A REPONER *********************************** */
/* *********************************************************************** */
DEF VAR pOk AS LOG NO-UNDO.
DEF VAR pCodigo AS CHAR NO-UNDO.    /* UBIGEO */

RUN gn/fAlmPrincipal (INPUT s-CodAlm, OUTPUT pOk).
/* Cuando el pTipoCalculo = "MAN" => Simula una TIENDA */
IF pTipoCalculo = "MAN" THEN pOk = NO.
CASE pOk:
    WHEN YES THEN DO:   /* ES UN CD */
        FIND FIRST TabGener WHERE TabGener.CodCia = s-codcia
            AND TabGener.Clave = "ZG"
            AND TabGener.Libre_c01 = s-CodAlm
            AND TabGener.Libre_l01 = YES
            NO-LOCK.
        pCodigo = TabGener.Codigo.  /* Zona Geografica que nos interesa Ej. ATE */
        /* Barremos todos los almacenes de la sede por cada producto */
        FOR EACH TabGener NO-LOCK WHERE TabGener.CodCia = s-CodCia
            AND TabGener.Clave = "ZG"
            AND TabGener.Codigo = pCodigo,
            FIRST Almtabla NO-LOCK WHERE Almtabla.tabla = Tabgener.clave
            AND Almtabla.codigo = Tabgener.codigo:
            FIND FIRST B-MATE WHERE B-MATE.CodCia = s-CodCia
                AND B-MATE.CodAlm = TabGener.Libre_c01
                AND B-MATE.codmat = pCodMat
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE B-MATE THEN NEXT.
            FIND FIRST T-MATE WHERE T-MATE.CodMat = pCodMat EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE T-MATE THEN DO:
                CREATE T-MATE.
                BUFFER-COPY B-MATE
                    EXCEPT B-MATE.StkAct 
                    B-MATE.StkMin 
                    B-MATE.StkRep 
                    B-MATE.StkComprometido
                    B-MATE.StkActCbd
                    TO T-MATE
                    ASSIGN T-MATE.CodAlm = s-CodAlm.    /* OJO */
            END.
            pStkComprometido = fStockComprometido(B-MATE.codmat, B-MATE.codalm).
            pStockTransito = fStockTransito(B-MATE.CodAlm, B-MATE.CodMat).
            pCompraTransito = fCompraTransito(B-MATE.CodAlm, B-MATE.CodMat).
            ASSIGN
                /* Stock Disponible Solicitante */
                T-MATE.StkAct = T-MATE.StkAct + (B-MATE.StkAct - pStkComprometido)
                T-MATE.StkComprometido = T-MATE.StkComprometido + pStkComprometido
                T-MATE.StkMin = T-MATE.StkMin + B-MATE.StkMin
                /* Stock en Tránsito Solicitante */
                T-MATE.StkRep = T-MATE.StkRep + pStockTransito
                /* Compras en Tránsito */
                T-MATE.StkActCbd = T-MATE.StkActCbd + pCompraTransito
                .
        END.    /* EACH TabGener */   
    END.
    WHEN NO THEN DO:   /* ES UNA TIENDA */
        CREATE T-MATE.
        BUFFER-COPY B-MATE 
            EXCEPT B-MATE.StkAct 
            B-MATE.StkMin  
            B-MATE.StkRep 
            B-MATE.StkComprometido
            B-MATE.StkActCbd
            TO T-MATE.
        pStkComprometido = fStockComprometido(B-MATE.codmat, B-MATE.codalm).
        /*pStkComprometido = B-MATE.StkComprometido */
        pStockTransito = fStockTransito(B-MATE.CodAlm, B-MATE.CodMat).
        pCompraTransito = fCompraTransito(B-MATE.CodAlm, B-MATE.CodMat).
        ASSIGN
            /* Stock Disponible Solicitante */
            T-MATE.StkAct = (B-MATE.StkAct - pStkComprometido)
            T-MATE.StkComprometido = pStkComprometido
            T-MATE.StkMin = B-MATE.StkMin
            /* Stock en Tránsito Solicitante */
            T-MATE.StkRep = pStockTransito
            /* Compras en Tránsito */
            T-MATE.StkActCbd = pCompraTransito
            .
    END.
END CASE.


RETURN 'OK'.
              
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DATOS-FINALES Include 
PROCEDURE DATOS-FINALES :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN
        T-DREPO.DesMat = B-MATG.DesMat
        T-DREPO.DesMar = B-MATG.DesMar
        T-DREPO.UndBas = B-MATG.UndBas
        T-DREPO.CodFam = B-MATG.CodFam
        T-DREPO.SubFam = B-MATG.SubFam.
    FIND FIRST B-MATE WHERE B-MATE.CodCia = s-codcia
        AND B-MATE.CodAlm = T-DREPO.AlmPed
        AND B-MATE.codmat = T-DREPO.CodMat
        NO-LOCK NO-ERROR.
    IF AVAILABLE B-MATE THEN DO:
        FIND FIRST Almtubic OF B-MATE NO-LOCK NO-ERROR.
        IF AVAILABLE Almtubic THEN
            ASSIGN
            T-DREPO.CodUbi = Almtubic.CodUbi
            T-DREPO.CodZona = Almtubic.CodZona.
    END.
    /* Clasificacion */
    T-DREPO.ClfGral = fClfGral(T-DREPO.CodMat,s-Reposicion).
    T-DREPO.ClfMayo = fClfMayo(T-DREPO.CodMat,s-Reposicion).
    T-DREPO.ClfUtil = fClfUtil(T-DREPO.CodMat,s-Reposicion).
    T-DREPO.DesStkDis = fStkDisponible(T-DREPO.AlmPed,T-DREPO.CodMat).
/*     T-DREPO.DesSaldo = fFSDespacho(T-DREPO.AlmPed,T-DREPO.CodMat). */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RESUMEN-POR-DESPACHO Include 
PROCEDURE RESUMEN-POR-DESPACHO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pAlmPed AS CHAR.
DEF INPUT PARAMETER pCodMat AS CHAR.

DEF VAR pOk AS LOG NO-UNDO.
DEF VAR pOkSolicitante AS LOG NO-UNDO.
DEF VAR pCodigo AS CHAR NO-UNDO.
DEF VAR lReservaMaximo AS LOG NO-UNDO.

DEF VAR pStkComprometido AS DEC NO-UNDO.
DEF VAR pStockTransito AS DEC NO-UNDO.
DEF VAR pCompraTransito AS DEC NO-UNDO.

EMPTY TEMP-TABLE T-GENER.
EMPTY TEMP-TABLE T-MATE-2.

/* Posicionamos en el almacén de reposición */
FIND FIRST B-MATE WHERE B-MATE.codcia = s-codcia
    AND B-MATE.codalm = pAlmPed     /* Almacén de Reposición */
    AND B-MATE.codmat = pCodMat
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-MATE THEN RETURN.

RUN gn/fAlmPrincipal (INPUT pAlmPed, OUTPUT pOk).
RUN gn/fAlmPrincipal (INPUT s-CodAlm, OUTPUT pOkSolicitante).

CASE TRUE:
    WHEN pOkSolicitante = YES AND pOk = YES THEN DO:   /* ES UN CD */
        FIND FIRST TabGener WHERE TabGener.CodCia = s-codcia
            AND TabGener.Clave = "ZG"
            AND TabGener.Libre_c01 = pAlmPed
            AND TabGener.Libre_l01 = YES
            NO-LOCK.
        pCodigo = TabGener.Codigo.  /* Zona Geografica que nos interesa */
        lReservaMaximo = YES.
        FOR EACH TabGener NO-LOCK WHERE TabGener.CodCia = s-CodCia
            AND TabGener.Clave = "ZG"
            AND TabGener.Codigo = pCodigo,
            FIRST Almtabla NO-LOCK WHERE Almtabla.tabla = Tabgener.clave
            AND Almtabla.codigo = Tabgener.codigo:
            /* RHC 08/09/2017 Max Ramos Si sede NO reserva stock => todo se va a cero */
            IF TabGener.Libre_l01 = YES AND TabGener.Libre_l02 = NO THEN lReservaMaximo = NO.
            /* ********************************************************************** */
            FIND FIRST B-MATE2 WHERE B-MATE2.codcia = s-codcia
                AND B-MATE2.codalm = TabGener.Libre_c01
                AND B-MATE2.codmat = B-MATE.codmat
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE B-MATE2 THEN NEXT.
            FIND FIRST T-MATE-2 OF B-MATE EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE T-MATE-2 THEN DO:
                CREATE T-MATE-2.
                BUFFER-COPY B-MATE
                    EXCEPT B-MATE.StkAct B-MATE.StkMin B-MATE.StkRep B-MATE.StkComprometido B-MATE.StkActCbd
                    TO T-MATE-2.
            END.
            pStkComprometido = fStockComprometido(B-MATE2.CodMat, B-MATE2.CodAlm).
            pStockTransito = fStockTransito(B-MATE2.CodAlm, B-MATE2.CodMat).
            pCompraTransito = fCompraTransito(B-MATE2.CodAlm, B-MATE2.CodMat).
            ASSIGN  
                /* Stock Disponible Despachante */
                T-MATE-2.StkAct = T-MATE-2.StkAct + (B-MATE2.StkAct - pStkComprometido)
                T-MATE-2.StkComprometido = T-MATE-2.StkComprometido + pStkComprometido
                /* Stock Maximo Despachante CD: (Stock Maximo + Seguridad) Tienda: Stock Maximo */
                T-MATE-2.StkMin = T-MATE-2.StkMin + B-MATE2.StkMin
                /* Stock en Tránsito Despachante */
                T-MATE-2.StkRep = T-MATE-2.StkRep + pStockTransito
                /* Compras en Tránsito */
                T-MATE-2.StkActCbd = T-MATE-2.StkActCbd + pCompraTransito
                .
            /* Datos adicionales */
/*             ASSIGN                                                                            */
/*                 T-MATE-2.DesStkMax = T-MATE-2.DesStkMax + B-MATE2.StkMin                      */
/*                 T-MATE-2.DesStkDis = T-MATE-2.DesStkDis + (B-MATE2.StkAct - pStkComprometido) */
/*                 T-MATE-2.DesStkTra = T-MATE-2.DesStkTra + pStockTransito                      */
/*                 .                                                                             */
        END.
        /* Definimos si el GRUPO cubre el despacho */
        FIND FIRST T-MATE-2 OF B-MATE EXCLUSIVE-LOCK NO-ERROR.
        /* **************************************************************** */
        IF lReservaMaximo = NO THEN T-MATE-2.StkMin = 0.    /* OJO CON ESTO */
        /* **************************************************************** */
        IF AVAILABLE T-MATE-2 THEN DO:
            IF ((T-MATE-2.StkAct + T-MATE-2.StkRep + T-MATE-2.StkActCbd) - T-MATE-2.StkMin) <= 0 THEN DO:
                DELETE T-MATE-2.
            END.
            ELSE DO:
                /* ************************************************************************************ */
                /* RHC 03/07/17 Verificamos si considera el Stock Maximo */
                /* ************************************************************************************ */
                FIND FIRST TabGener WHERE TabGener.CodCia = s-codcia
                    AND TabGener.Clave = "ZG"
                    AND TabGener.Libre_c01 = B-MATE.CodAlm
                    NO-LOCK NO-ERROR.
                /* ************************************************************************************ */
                /* Cargamos los datos del ALMACEN de Despacho */
                FIND B-MATE2 OF B-MATE NO-LOCK NO-ERROR.
                pStkComprometido = fStockComprometido(B-MATE2.CodMat, B-MATE2.CodAlm).
                /*pStockTransito   = fStockTransito(B-MATE2.CodAlm, B-MATE2.CodMat).*/
                /*pCompraTransito  = fCompraTransito(B-MATE2.CodAlm, B-MATE2.CodMat).*/
                /* RHC 16/06/2017 La CD o el Almacén? */
                IF ((T-MATE-2.StkAct + T-MATE-2.StkRep + T-MATE-2.StkActCbd) - T-MATE-2.StkMin) > 
                    ( B-MATE2.StkAct - pStkComprometido ) THEN DO:
                    ASSIGN
                        /* Stock Disponible Despachante */
                        T-MATE-2.StkAct = (B-MATE2.StkAct - pStkComprometido)
                        T-MATE-2.StkComprometido = pStkComprometido
                        /* Stock Maximo Despachante CD: (Stock Maximo + Seguridad) Tienda: Stock Maximo */
                        T-MATE-2.StkMin = 0     /*B-MATE2.StkMin */
                        /*T-MATE-2.StkRep = pStockTransito*/
                        /* Compras en Tránsito */
                        /*T-MATE-2.StkActCbd = pCompraTransito*/
                        .
                    ASSIGN
                        T-MATE-2.StkRep = 0
                        T-MATE-2.StkActCbd = 0
                        .
                END.
                ELSE DO:
                END.
            END.
        END.
    END.
    OTHERWISE DO:    /* ES UNA TIENDA */
        FIND FIRST TabGener WHERE TabGener.CodCia = s-codcia
            AND TabGener.Clave = "ZG"
            AND TabGener.Libre_c01 = pAlmPed
            NO-LOCK.
        lReservaMaximo = YES.
        IF AVAILABLE TabGener AND TabGener.Libre_l02 = NO THEN lReservaMaximo = NO.
        /* Almacén de Despacho NO PRINCIPAL */
        FIND B-MATE2 OF B-MATE NO-LOCK NO-ERROR.
        CREATE T-MATE-2.
        BUFFER-COPY B-MATE2
            EXCEPT B-MATE2.StkAct 
            B-MATE2.StkMin 
            B-MATE2.StkRep 
            B-MATE2.StkComprometido
            B-MATE2.StkActCbd
            TO T-MATE-2.
        pStkComprometido = fStockComprometido(B-MATE2.CodMat, B-MATE2.CodAlm).
        pStockTransito = fStockTransito(B-MATE2.CodAlm, B-MATE2.CodMat).
        ASSIGN
            T-MATE-2.StkAct = B-MATE2.StkAct - pStkComprometido
            T-MATE-2.StkComprometido = pStkComprometido
            T-MATE-2.StkMin = B-MATE2.StockMax         /* Solo el Stock Maximo */
            .
        /* Datos adicionales */
/*         ASSIGN                                                       */
/*             T-MATE-2.DesStkMax = B-MATE2.StockMax                    */
/*             T-MATE-2.DesStkDis = (B-MATE2.StkAct - pStkComprometido) */
/*             T-MATE-2.DesStkTra = pStockTransito                      */
/*             .                                                        */
        /* **************************************************************** */
        IF lReservaMaximo = NO THEN T-MATE-2.StkMin = 0.    /* OJO CON ESTO */
        /* **************************************************************** */
    END.
END CASE.
/* FOR EACH T-MATE-2 EXCLUSIVE-LOCK:                                                                                         */
/*     ASSIGN                                                                                                                */
/*         T-MATE-2.DesStkMax = 0                                                                                            */
/*         T-MATE-2.DesStkDis = 0.                                                                                           */
/*     FIND FIRST TabGener WHERE TabGener.CodCia = s-codcia                                                                  */
/*         AND TabGener.Clave = "ZG"                                                                                         */
/*         AND TabGener.Libre_c01 = T-MATE-2.CodAlm                                                                          */
/*         NO-LOCK NO-ERROR.                                                                                                 */
/*     IF NOT AVAILABLE TabGener THEN NEXT.                                                                                  */
/*     pCodigo = TabGener.Codigo.  /* Zona Geografica que nos interesa */                                                    */
/*     FOR EACH TabGener NO-LOCK WHERE TabGener.CodCia = s-CodCia                                                            */
/*         AND TabGener.Clave = "ZG"                                                                                         */
/*         AND TabGener.Codigo = pCodigo,                                                                                    */
/*         FIRST Almtabla NO-LOCK WHERE Almtabla.tabla = Tabgener.clave                                                      */
/*         AND Almtabla.codigo = Tabgener.codigo:                                                                            */
/*         FIND B-MATE2 WHERE B-MATE2.codcia = s-codcia                                                                      */
/*             AND B-MATE2.codalm = TabGener.Libre_c01                                                                       */
/*             AND B-MATE2.codmat = T-MATE-2.CodMat                                                                          */
/*             NO-LOCK NO-ERROR.                                                                                             */
/*         IF NOT AVAILABLE B-MATE2 THEN NEXT.                                                                               */
/*         pStkComprometido = fStockComprometido(B-MATE2.CodMat, B-MATE2.CodAlm).                                            */
/*         ASSIGN                                                                                                            */
/*             T-MATE-2.DesStkMax = T-MATE-2.DesStkMax + (IF pOkSolicitante = YES THEN B-MATE2.StkMin ELSE B-MATE2.StockMax) */
/*             T-MATE-2.DesStkDis = T-MATE-2.DesStkDis + (B-MATE2.StkAct - pStkComprometido).                                */
/*     END.                                                                                                                  */
/* END.                                                                                                                      */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fClasificacion Include 
FUNCTION fClasificacion RETURNS CHARACTER
  ( INPUT pCodMat AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF BUFFER B-MATG FOR Almmmatg.

  FIND B-MATG WHERE B-MATG.codcia = s-codcia
      AND B-MATG.codmat = pCodMat
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE B-MATG THEN RETURN '?'.
  FIND Almcfggn WHERE Almcfggn.codcia = s-codcia NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almcfggn THEN RETURN B-MATG.TipRot[1].
  FIND FacTabla WHERE FacTabla.CodCia = s-codcia 
      AND FacTabla.Tabla = 'RANKVTA'
      AND FacTabla.Codigo = B-MATG.codmat
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE FacTabla THEN RETURN B-MATG.TipRot[1].
  FIND gn-divi WHERE gn-divi.codcia = s-codcia
      AND gn-divi.coddiv = s-coddiv
      NO-LOCK NO-ERROR.
  CASE TRUE:
      WHEN Almcfggn.Temporada = "C" THEN DO:
          IF GN-DIVI.CanalVenta = "MIN" THEN RETURN FacTabla.Campo-C[2].
          ELSE RETURN FacTabla.Campo-C[3].
      END.
      WHEN Almcfggn.Temporada = "NC" THEN DO:
          IF GN-DIVI.CanalVenta = "MIN" THEN RETURN FacTabla.Campo-C[5].
          ELSE RETURN FacTabla.Campo-C[6].
      END.
  END CASE.

  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fClfGral Include 
FUNCTION fClfGral RETURNS CHARACTER
  ( INPUT pCodMat AS CHAR, INPUT pReposicion AS LOG ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF BUFFER B-MATG FOR Almmmatg.

  FIND B-MATG WHERE B-MATG.codcia = s-codcia
      AND B-MATG.codmat = pCodMat
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE B-MATG THEN RETURN ''.
  FIND FIRST factabla WHERE factabla.codcia = s-codcia 
      AND factabla.tabla = 'RANKVTA' 
      AND factabla.codigo = B-MATG.codmat
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE FacTabla THEN RETURN ''.
  CASE Preposicion:
      WHEN YES /* Campaña */    THEN RETURN FacTabla.campo-c[1].
      WHEN NO /* No Campaña */  THEN RETURN FacTabla.campo-c[4].
  END CASE.
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fClfMayo Include 
FUNCTION fClfMayo RETURNS CHARACTER
  ( INPUT pCodMat AS CHAR, INPUT pReposicion AS LOG ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF BUFFER B-MATG FOR Almmmatg.

  FIND B-MATG WHERE B-MATG.codcia = s-codcia
      AND B-MATG.codmat = pCodMat
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE B-MATG THEN RETURN ''.
  FIND FIRST factabla WHERE factabla.codcia = s-codcia 
      AND factabla.tabla = 'RANKVTA' 
      AND factabla.codigo = B-MATG.codmat
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE FacTabla THEN RETURN ''.
  CASE Preposicion:
      WHEN YES /* Campaña */    THEN RETURN FacTabla.campo-c[3].
      WHEN NO /* No Campaña */  THEN RETURN FacTabla.campo-c[6].
  END CASE.
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fClfUtil Include 
FUNCTION fClfUtil RETURNS CHARACTER
  ( INPUT pCodMat AS CHAR, INPUT pReposicion AS LOG ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF BUFFER B-MATG FOR Almmmatg.

  FIND B-MATG WHERE B-MATG.codcia = s-codcia
      AND B-MATG.codmat = pCodMat
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE B-MATG THEN RETURN ''.
  FIND FIRST factabla WHERE factabla.codcia = s-codcia 
      AND factabla.tabla = 'RANKVTA' 
      AND factabla.codigo = B-MATG.codmat
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE FacTabla THEN RETURN ''.
  CASE Preposicion:
      WHEN YES /* Campaña */    THEN RETURN FacTabla.campo-c[2].
      WHEN NO /* No Campaña */  THEN RETURN FacTabla.campo-c[5].
  END CASE.
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fCompraTransito Include 
FUNCTION fCompraTransito RETURNS DECIMAL
  ( INPUT pCodAlm AS CHAR, INPUT pCodMat AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEF VAR x-Acumulado AS DECI NO-UNDO.

    FOR EACH OOComPend NO-LOCK WHERE OOComPend.CodAlm = pCodAlm AND OOComPend.CodMat = pCodMat:
        x-Acumulado = x-Acumulado + (OOComPend.CanPed - OOComPend.CanAte).
    END.
    RETURN x-Acumulado.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fFSDespacho Include 
FUNCTION fFSDespacho RETURNS DECIMAL
  ( INPUT pAlmPed AS CHAR, INPUT pCodMat AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF BUFFER B-MATE FOR Almmmate.
  FIND B-MATE WHERE B-MATE.codcia = s-codcia
      AND B-MATE.codalm = pAlmPed
      AND B-MATE.codmat = pCodMat
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE B-MATE THEN RETURN 0.00.

  DEF VAR pStkComprometido AS DEC NO-UNDO.
  DEF VAR pStockTransito AS DEC NO-UNDO.

  pStkComprometido = fStockComprometido(B-MATE.CodMat, B-MATE.CodAlm).
  pStockTransito =  fStockTransito(B-MATE.codalm,B-MATE.codmat).
  CASE s-TipoCalculo:
      WHEN "GRUPO" THEN DO:
          RETURN (B-MATE.StkAct + pStockTransito - pStkComprometido - B-MATE.StkMin).
      END.
      WHEN "TIENDA" THEN DO:
          RETURN (B-MATE.StkAct - pStkComprometido - B-MATE.StockMax).
      END.
      OTHERWISE RETURN 0.00.
  END CASE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fStkDisponible Include 
FUNCTION fStkDisponible RETURNS DECIMAL
  ( INPUT pCodAlm AS CHAR,
    INPUT pCodMat AS CHAR ):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF BUFFER B-MATE FOR Almmmate.
  DEF VAR pStkComprometido AS DEC NO-UNDO.

  FIND FIRST B-MATE WHERE B-MATE.codcia = s-codcia
      AND B-MATE.codalm = pCodAlm
      AND B-MATE.codmat = pCodMat
      NO-LOCK NO-ERROR.
  IF AVAILABLE B-MATE THEN DO:
      pStkComprometido = fStockComprometido(B-MATE.CodMat, B-MATE.CodAlm).
      RETURN (B-MATE.StkAct - pStkComprometido).
  END.
  ELSE RETURN 0.00.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fStockComprometido Include 
FUNCTION fStockComprometido RETURNS DECIMAL
  ( INPUT pCodMat AS CHAR, INPUT pCodAlm AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR pStkComprometido AS DEC INIT 0 NO-UNDO.

  RUN gn/stock-comprometido-v2.p (pCodMat, pCodAlm, YES, OUTPUT pStkComprometido).
  RETURN pStkComprometido.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fStockTransito Include 
FUNCTION fStockTransito RETURNS DECIMAL
  ( INPUT pCodAlm AS CHAR, INPUT pCodMat AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    /* En Tránsito */
    DEF VAR x-Total AS DEC NO-UNDO.
    RUN alm/p-articulo-en-transito (
        s-CodCia,
        pCodAlm,
        pCodMat,
        INPUT-OUTPUT TABLE tmp-tabla,
        OUTPUT x-Total).

    RETURN x-Total.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

