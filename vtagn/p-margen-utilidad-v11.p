&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Determinar el margen de utilidad de la venta

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       : Controla o no el margen de utilidad dependiendo del canal de venta
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* PARAMETROS */
DEF INPUT PARAMETER  pCodDiv AS CHAR.       /* Canal de Venta o Lista de Precios */
DEF INPUT PARAMETER  pCodMat LIKE Almmmatg.CodMat.
DEF INPUT PARAMETER  pPreUni AS DEC.
DEF INPUT PARAMETER  pUndVta AS CHAR.
DEF INPUT PARAMETER  pMonVta AS INT.
DEF INPUT PARAMETER  pTpoCmb AS DEC.
DEF INPUT PARAMETER  pVerError AS LOG.      /* Mostrar el error */
DEF INPUT PARAMETER  pCodAlm AS CHAR.
DEF OUTPUT PARAMETER pMargen AS DEC NO-UNDO.
DEF OUTPUT PARAMETER pLimite AS DEC NO-UNDO.
DEF OUTPUT PARAMETER pError AS CHAR NO-UNDO.        /* Se relaciona con el parámetro pVerError */


DEF SHARED VAR s-codcia AS INT.

/* ************************************ */
/* Control de margen mínimo de utilidad */
/* ************************************ */
IF pCodDiv > '' THEN DO:    /* Siempre y cuando se envíe un valor */
    FIND FacTabla WHERE FacTabla.CodCia = s-CodCia
        AND FacTabla.Tabla = "GN-DIVI"
        AND FacTabla.Codigo = pCodDiv
        NO-LOCK NO-ERROR.
    IF AVAILABLE FacTabla AND FacTabla.Campo-L[4] = NO THEN RETURN "OK".
END.
/* ************************************ */

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
         HEIGHT             = 4.19
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF VAR pPreMin AS DEC NO-UNDO.

pError = "".

/* RHC 26.09.05 MARGEN DE UTILIDAD */
DEF VAR X-COSTO AS DEC NO-UNDO.
DEF VAR X-MARGEN AS DEC NO-UNDO.
DEF VAR X-LIMITE AS DEC NO-UNDO.
DEF VAR f-Factor AS DEC NO-UNDO.

FIND Almmmatg WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = pCodMat NO-LOCK NO-ERROR.
FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas AND Almtconv.Codalter = pUndVta NO-LOCK NO-ERROR.
FIND Almacen WHERE Almacen.codcia = s-codcia AND Almacen.codalm = pCodAlm NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv OR Almtconv.Equival <= 0 THEN DO:
    pError = 'Error en la tabla de equivalencias' + CHR(10) +
        'Revisar lo siguiente:' + CHR(10) + 
        'Artículo = ' + Almmmatg.CodMat + CHR(10) +
        'Unidad Base = ' + Almmmatg.UndBas + CHR(10) +
        'Unidad de Venta = ' + pUndVta.
    IF pVerError = YES THEN MESSAGE pError VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
f-Factor = Almtconv.Equival.
pPreUni = pPreUni / f-Factor.   /* En unidades de stock */

ASSIGN
    X-COSTO = 0
    X-MARGEN = 0.
IF pMonVta = 1 THEN DO:
   IF Almmmatg.MonVta = 1 THEN 
      ASSIGN X-COSTO = (Almmmatg.Ctotot).
   ELSE
      ASSIGN X-COSTO = (Almmmatg.Ctotot) * Almmmatg.TpoCmb.     /*pTpoCmb.*/
END.        
IF pMonVta = 2 THEN DO:
   IF Almmmatg.MonVta = 2 THEN
      ASSIGN X-COSTO = (Almmmatg.Ctotot).
   ELSE
      ASSIGN X-COSTO = (Almmmatg.Ctotot) / Almmmatg.TpoCmb.     /*pTpoCmb .*/
END.      
IF x-Costo = 0 OR x-Costo = ? THEN DO:
    pError = 'Error en el costo unitario' + CHR(10) +
        'Revisar lo siguiente:' + CHR(10) + 
        'Artículo = ' + Almmmatg.CodMat + CHR(10) +
        'Costo Unitario = ' + STRING(x-Costo).
    IF pVerError = YES THEN MESSAGE pError VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
ASSIGN
    X-MARGEN = ROUND( ((( pPreUni / X-COSTO ) - 1 ) * 100 ), 2 )
    pMargen = x-Margen
    pLimite = x-Margen.

/* *********************** */
/* Margen mínimo por Linea */
/* *********************** */
FIND TabGener WHERE Tabgener.codcia = s-codcia 
    AND Tabgener.clave = 'MML'
    AND Tabgener.codigo = Almmmatg.codfam NO-LOCK NO-ERROR.
IF NOT AVAILABLE TabGener THEN DO:
    /* NO hay margen de utilidad por este producto */
    RETURN 'OK'.
END.
/* Producto Propio o de Terceros */
IF Almmmatg.chr__02 = 'P' THEN X-LIMITE = TabGener.Parametro[2].
ELSE X-LIMITE = TabGener.Parametro[1].
/* ************************** */
/* Margen mínimo por Sublinea */
/* ************************** */
FIND VtaTabla WHERE VtaTabla.codcia = s-codcia
    AND VtaTabla.tabla = 'MMLL'
    AND VtaTabla.llave_c1 = Almmmatg.codfam
    AND VtaTabla.llave_c2 = Almmmatg.subfam
    NO-LOCK NO-ERROR.
IF AVAILABLE VtaTabla THEN DO:
    /* Producto Propio o de Terceros */
    IF Almmmatg.chr__02 = 'P' THEN X-LIMITE = VtaTabla.Valor[2].
    ELSE X-LIMITE = VtaTabla.Valor[1].
    /* Margen mínimo por marca */
    FIND VtaTabla WHERE VtaTabla.CodCia = TabGener.CodCia
        AND VtaTabla.Tabla = 'MMLLM'
        AND VtaTabla.Llave_c1 = Almmmatg.codfam
        AND VtaTabla.Llave_c2 = Almmmatg.subfam
        AND VtaTabla.Llave_c3 = Almmmatg.codmar
        NO-LOCK NO-ERROR.
    IF AVAILABLE VtaTabla THEN DO:
        /* Producto Propio o de Terceros */
        IF Almmmatg.chr__02 = 'P' THEN X-LIMITE = VtaTabla.Valor[2].
        ELSE X-LIMITE = VtaTabla.Valor[1].
    END.
END.
ASSIGN
    pLimite = x-Limite.
/* *********************************** */
/* RHC 04.04.2011 Productos exonerados */
/* *********************************** */
FIND VtaTabla WHERE VtaTabla.codcia = s-codcia
    AND VtaTabla.tabla = 'MMLX'
    AND VTaTabla.llave_c1 = pCodMat
    NO-LOCK NO-ERROR.
IF AVAILABLE VtaTabla THEN x-Limite = x-Margen.
/* ******************** */
/* Almacenes de REMATES */
/* ******************** */
IF AVAILABLE Almacen AND Almacen.Campo-c[3] = "SI" THEN x-Limite = x-Margen.
/* ******************** */
DEF VAR x-Error AS LOG NO-UNDO.
IF X-MARGEN < X-LIMITE THEN DO:
    x-Error = YES.  /* Por Defecto */
    pError = 'ERROR EN EL PRODUCTO: ' + pCodMat + CHR(10) + 
        'MARGEN DE UTILIDAD MUY BAJO' + CHR(10) +
        'El margen es de ' + STRING(x-Margen) +  '%, no debe ser menor a ' + STRING(x-Limite) + '%'.
    /* ******************************************************************************** */
    /* RHC 02/06/2021 Verificamos si solo se muestra el error o bloqueamos la grabación */
    /* ******************************************************************************** */
/*     FIND FIRST FacTabla WHERE FacTabla.CodCia = s-CodCia AND FacTabla.Tabla = "MMX" NO-LOCK NO-ERROR.     */
/*     IF AVAILABLE FacTabla THEN DO:                                                                        */
/*         /* 1ro. Productos sin ventas */                                                                   */
/*         FIND LAST Almdmov WHERE Almdmov.CodCia = s-CodCia                                                 */
/*             AND Almdmov.codmat = pCodMat                                                                  */
/*             AND Almdmov.TipMov = "S"                                                                      */
/*             AND Almdmov.CodMov = 02     /* Ventas */                                                      */
/*             USE-INDEX Almd02 NO-LOCK NO-ERROR.                                                            */
/*         IF AVAILABLE Almdmov AND Almdmov.FchDoc < ADD-INTERVAL(TODAY,INTEGER(FacTabla.Valor[1]),'months') */
/*             THEN DO:                                                                                      */
/*             x-Error = NO.        /* Solo una Alerta */                                                    */
/*         END.                                                                                              */
/*     END.                                                                                                  */
    /* ******************************************************************************** */
    /* CALCULAMOS EL PRECIO MINIMO */
    x-Limite = (( pPreUni / X-COSTO ) - 1 ) * 100.
    pPreMin = ( 1 + x-Limite / 100 ) * x-Costo * f-Factor.
    IF pVerError = YES THEN DO:
        IF x-Error = YES THEN DO:
            MESSAGE pError SKIP 'El proceso puede truncarse' VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.
        ELSE DO:
            MESSAGE pError SKIP 'El proceso puede continuar' VIEW-AS ALERT-BOX WARNING.
            RETURN 'OK'.
        END.
    END.
END.
RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


