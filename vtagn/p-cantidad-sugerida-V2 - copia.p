&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-MATG FOR Almmmatg.



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
      TABLE: B-MATG B "?" ? INTEGRAL Almmmatg
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 4.85
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/* ESTA VERSION DECIDE CUAL UNIDAD DE MEDIDA TOMAR */
/* EL PROGRAMA DEVUELVE LA CANTIDAD SUGERIDA DE ACUERDO AL EMPAQUE      */
/* ******************************************************************** */

DEF INPUT PARAMETER pCodDiv AS CHAR.        /* División COTIZADORA */
DEF INPUT PARAMETER pListaPrecios AS CHAR.  /* Lista de Precios o División */
DEF INPUT PARAMETER pCodMat AS CHAR.        /* Artículo */
DEF INPUT PARAMETER pCanPed AS DEC.         /* Cantidad en UNIDADES DE VENTA */
DEF INPUT PARAMETER pUndVta AS CHAR.        /* UNIDAD DE VENTA */
DEF INPUT PARAMETER pCodCli AS CHAR.        /* CLIENTE */

DEF OUTPUT PARAMETER pSugerido AS DEC.
DEF OUTPUT PARAMETER pEmpaque  AS DEC.      /* Empaque sugerido */

DEF OUTPUT PARAMETER pMsgError AS CHAR NO-UNDO.

DEF SHARED VAR s-codcia AS INT.

DEF VAR s-ControlEmpaque    AS LOG NO-UNDO.
DEF VAR s-ControlMinVta     AS LOG NO-UNDO.
DEF VAR f-CanFinal          AS DEC NO-UNDO.
DEF VAR f-MinimoVentas      AS DEC NO-UNDO.
DEF VAR f-CanPed            AS DEC NO-UNDO.


IF TRUE <> (pListaPrecios > '')  THEN pListaPrecios = pCodDiv.
FIND GN-DIVI WHERE GN-DIVI.CodCia = s-CodCia AND
    GN-DIVI.CodDiv = pListaPrecios NO-LOCK.
ASSIGN
    s-ControlEmpaque = GN-DIVI.FlgEmpaque
    s-ControlMinVta  = GN-DIVI.FlgMinVenta.

/* Articulo */
FIND Almmmatg WHERE Almmmatg.codcia = s-CodCia AND Almmmatg.codmat = pCodMat NO-LOCK.
/* Equivalencia */
DEF VAR x-Factor AS DEC NO-UNDO.
x-Factor = 1.
FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndStk AND Almtconv.Codalter = pUndVta NO-LOCK NO-ERROR.
IF AVAILABLE Almtconv THEN x-Factor = Almtconv.Equival.

pCanPed = pCanPed * x-Factor.   /* EN UNIDADES DE STOCK */
f-CanPed = pCanPed.             /* Valor Inicial */
pSugerido = pCanPed.            /* OJO >>> Valor Inicial */

CASE TRUE:
    WHEN GN-DIVI.CanalVenta = "FER" AND GN-DIVI.VentaMayorista = 2 AND s-ControlEmpaque = YES THEN DO:
        /* EVENTOS */
        /* VENTAS EVENTOS (PRE-VENTA EXPOLIBRERIA):
        CanalVenta = "FER"  EVENTOS
        VentaMayorista = 2  LISTA DE PRECIOS POR DIVISION 
        */
        RUN Sugerido-Eventos.
        IF f-CanPed <> pSugerido THEN DO:
            pMsgError = 'Solo puede despachar en empaques de ' + STRING(pEmpaque) + ' ' + Almmmatg.UndBas.
        END.
    END.
    WHEN GN-DIVI.CanalVenta = "MOD" THEN DO:
        /* EMPAQUE SUPERMERCADOS */
        FIND FIRST supmmatg WHERE supmmatg.codcia = s-CodCia
            AND supmmatg.codcli = pCodCli
            AND supmmatg.codmat = pCodMat
            NO-LOCK NO-ERROR.
        IF AVAILABLE supmmatg AND supmmatg.Libre_d01 > 0 THEN DO:
            pEmpaque = supmmatg.Libre_d01.
            f-CanPed = ( TRUNCATE((f-CanPed / pEmpaque),0) * pEmpaque ).
        END.
        pSugerido = ( f-CanPed - ( f-CanPed MODULO x-Factor ) ).
        IF pCanPed <> pSugerido THEN DO:
            pMsgError = 'Solo puede despachar en empaques de ' + STRING(pEmpaque) + ' ' + Almmmatg.UndBas.
        END.
    END.
    WHEN s-ControlMinVta = YES THEN DO:
        RUN Minimo-de-Venta.
        /* Redondeamos al Mínimo Venta Mayorista */
        /*pEmpaque = Almmmatg.DEC__03.  /* Mínimo Ventas Mayorista */*/
        pEmpaque = f-MinimoVentas.
        IF pEmpaque > 0 THEN DO:
            f-CanFinal = (TRUNCATE((pCanPed / pEmpaque),0) * pEmpaque).
            pSugerido = f-CanFinal.
        END.
        ELSE pSugerido = pCanPed.
    END.
END CASE.
/* Devolvemos la cantidad a la unidad de venta */
IF pSugerido <= 0 THEN pSugerido = 0.
pSugerido = pSugerido / x-Factor.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Minimo-de-Venta) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Minimo-de-Venta Procedure 
PROCEDURE Minimo-de-Venta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    f-CanPed = pCanPed.     /* En Unidades de Stock */
    CASE pCodDiv:
        WHEN "00065" THEN DO:       /* CHICLAYO */
            IF Almmmatg.PesoBruto > 0 THEN DO:
                f-MinimoVentas = Almmmatg.PesoBruto.
                IF f-MinimoVentas > 0 THEN DO:
                    IF f-CanPed < f-MinimoVentas THEN DO:
                        pMsgError = "ERROR el el artículo " + Almmmatg.codmat + CHR(10) +
                            "No se puede despachar menos de " + STRING(f-MinimoVentas) + ' ' + Almmmatg.UndStk.
                    END.
                    IF f-CanPed > f-MinimoVentas AND Almmmatg.Paquete > 0 THEN DO:
                        IF (f-CanPed - f-MinimoVentas) MODULO Almmmatg.Paquete > 0 THEN DO:
                            pMsgError = "ERROR el el artículo " + Almmmatg.codmat + CHR(10) +
                                  "No se puede despachar menos de " + STRING(f-MinimoVentas) + ' ' + Almmmatg.UndStk + CHR(10) +
                                   "el incrementos de " + STRING(Almmmatg.Paquete) + ' ' + Almmmatg.UndStk.
                        END.
                    END.
                END.
                ELSE IF Almmmatg.Paquete > 0 AND f-CanPed <> 1 THEN DO:
                    IF f-CanPed MODULO Almmmatg.Paquete > 0 THEN DO:
                        pMsgError = "ERROR el el artículo " + Almmmatg.codmat + CHR(10) +
                            "Solo se puede despachar en múltiplos de " + STRING(Almmmatg.Paquete) + ' ' + Almmmatg.UndStk.
                        RETURN 'ADM-ERROR'.
                    END.
                END.
            END.
        END.
        OTHERWISE DO:
            f-MinimoVentas = Almmmatg.DEC__03.
            CASE TRUE:
                WHEN GN-DIVI.CanalVenta = "FER" AND GN-DIVI.VentaMayorista = 2 THEN DO:
                    f-MinimoVentas = Almmmatg.StkMax.
                    IF f-MinimoVentas > 0 THEN DO:
                        f-CanPed = TRUNCATE((f-CanPed / f-MinimoVentas),0) * f-MinimoVentas.
                        IF f-CanPed <> pCanPed THEN DO:
                            pMsgError = 'Solo puede vender en múltiplos de ' + STRING(f-MinimoVentas) + ' ' + Almmmatg.UndBas.
                        END.
                    END.
                END.
                WHEN f-MinimoVentas > 0 AND f-CanPed < f-MinimoVentas THEN DO:
                    pMsgError = 'Solo puede vender como mínimo ' + STRING(f-MinimoVentas) + ' ' + Almmmatg.UndBas.
                END.
            END.
        END.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Sugerido-Eventos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Sugerido-Eventos Procedure 
PROCEDURE Sugerido-Eventos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPAQUE:
DO:
    /* LA CANTIDAD PUEDE SER POR EMPAQUE INNER O MASTER */
    /* ********************************** */
    /* 1ro. Redondeamos al Empaque Master: DE LA EXPOLIBRERIA o DE LA EMPRESA */
    /* ********************************** */
    pSugerido = 0.
    IF Almmmatg.CanEmp > 0 OR Almmmatg.Libre_d03 > 0 THEN DO:
        pEmpaque = Almmmatg.Libre_d03.    /* Empaque Master Expolibreria */
        IF pEmpaque <= 0 THEN pEmpaque = Almmmatg.CanEmp.     /* Empaque Master Empresa */
        IF pCanPed > pEmpaque THEN DO:
            f-CanFinal = TRUNCATE(pCanPed / pEmpaque, 0) * pEmpaque.
            pSugerido = pSugerido + f-CanFinal.
            pCanPed = pCanPed - f-CanFinal.
        END.
        ELSE DO:
            /* Tope mínimo 85% y se redondea al Empaque Master*/
            IF (pCanPed / pEmpaque * 100) >= 85 THEN DO:
                f-CanFinal = pEmpaque.
                pSugerido = pSugerido + f-CanFinal.
                LEAVE EMPAQUE.  /* Tomamos el empaque y termina la rutina */
            END.
        END.
    END.
    IF pCanPed <= 0 THEN LEAVE EMPAQUE.
    /* ********************************* */
    /* 2do. Redondeamos al Empaque Inner: DE LA EMPRESA */
    /* ********************************* */
    IF Almmmatg.StkRep > 0 THEN DO:
        pEmpaque = Almmmatg.StkRep.
        IF pCanPed > pEmpaque THEN DO:
            f-CanFinal = TRUNCATE(pCanPed / pEmpaque, 0) * pEmpaque.
            pSugerido = pSugerido + f-CanFinal.
            pCanPed = pCanPed - f-CanFinal.
        END.
        ELSE DO:
            /* Tope mínimo 85% y se redondea al Empaque Inner */
            IF (pCanPed / pEmpaque * 100) >= 85 THEN DO:
                f-CanFinal = pEmpaque.
                pSugerido = pSugerido + f-CanFinal.
                LEAVE EMPAQUE.  /* Tomamos el empaque y termina la rutina */
            END.
        END.
    END.
    IF pCanPed <= 0 THEN LEAVE EMPAQUE.     /* Cantidad muy baja */
    /* ********************************************* */
    /* 3ro. Redondeamos al Mínimo Venta Expolibreria */
     /* ********************************************* */
    f-MinimoVentas = Almmmatg.StkMax.
    /* ******************************************* */
    /* RHC 27/12/0019 De los Pedidos del Proveedor */
    /* ******************************************* */
    FIND AlmCatVtaD WHERE AlmCatVtaD.CodCia = s-CodCia AND
        AlmCatVtaD.CodDiv = pListaPrecios AND 
        AlmCatVtaD.codmat = pCodMat AND
        CAN-FIND(AlmCatVtaC WHERE AlmCatVtaC.CodCia = AlmCatVtaD.CodCia AND
                 AlmCatVtaC.CodDiv = AlmCatVtaD.CodDiv AND
                 AlmCatVtaC.CodPro = AlmCatVtaD.CodPro AND 
                 AlmCatVtaC.NroPag = AlmCatVtaD.NroPag NO-LOCK)
        NO-LOCK NO-ERROR.
    IF AVAILABLE AlmCatVtaD THEN DO:
        f-MinimoVentas = AlmCatVtaD.Libre_d02.
    END.
        

    /* ******************************************* */
    /* ******************************************* */
    IF f-MinimoVentas <= 0 THEN f-MinimoVentas = pCanPed.   /* <<< OJO <<< */
    pEmpaque = f-MinimoVentas.
    IF pCanPed > pEmpaque THEN DO:
        f-CanFinal = TRUNCATE(pCanPed / pEmpaque, 0) * pEmpaque.
        pSugerido = pSugerido + f-CanFinal.
        pCanPed = pCanPed - f-CanFinal.
    END.
    ELSE DO:
        /* Tope mínimo 85% y se redondea al Mínimo Ventas Expolibreria */
        IF (pCanPed / pEmpaque * 100) >= 85 THEN DO:
            f-CanFinal = pEmpaque.
            pSugerido = pSugerido + f-CanFinal.
            LEAVE EMPAQUE.
        END.
    END.
    IF pCanPed <= 0 THEN LEAVE EMPAQUE.     /* Cantidad muy baja */
    /* ************************************************** */
    /* 4to. Si queda un saldo lo acumulamos a lo sugerido: Almmmatg.StkMax es MINIMO DE VENTA EXPOLIBRERIA */
    /* ************************************************** */
    IF Almmmatg.StkMax > 0 THEN f-CanFinal = TRUNCATE(pCanPed / Almmmatg.StkMax, 0) * Almmmatg.StkMax.
    ELSE f-CanFinal = pCanPed / pEmpaque * pEmpaque.
    pSugerido = pSugerido + f-CanFinal.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

