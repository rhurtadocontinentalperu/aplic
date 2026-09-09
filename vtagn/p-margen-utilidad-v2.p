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
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* PARAMETROS */
DEF INPUT PARAMETER  pCodDiv AS CHAR.
DEF INPUT PARAMETER  pCodMat LIKE Almmmatg.CodMat.
DEF INPUT PARAMETER  pPreUni AS DEC.
DEF INPUT PARAMETER  pUndVta AS CHAR.
DEF INPUT PARAMETER  pMonVta AS INT.
DEF INPUT PARAMETER  pTpoCmb AS DEC.        /* NO SE VA A USAR, solo por compatibilidad */
DEF INPUT PARAMETER  pVerError AS LOG.      /* Mostrar el error */
DEF INPUT PARAMETER  pCodAlm AS CHAR.

DEF OUTPUT PARAMETER pMargen AS DEC NO-UNDO.
DEF OUTPUT PARAMETER pLimite AS DEC NO-UNDO.
DEF OUTPUT PARAMETER pError AS CHAR NO-UNDO.        /* Se relaciona con el parámetro pVerError */

pError = "".

/*DEF SHARED VAR s-coddiv AS CHAR.*/
DEF SHARED VAR s-codcia AS INT.

FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = pCodDiv NO-LOCK.

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
         HEIGHT             = 4.85
         WIDTH              = 48.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEF VAR pPreMin AS DEC NO-UNDO.

/* RHC 26.09.05 MARGEN DE UTILIDAD */
DEF VAR X-COSTO AS DEC NO-UNDO.
DEF VAR X-MARGEN AS DEC NO-UNDO.
DEF VAR X-LIMITE AS DEC NO-UNDO.
DEF VAR f-Factor AS DEC NO-UNDO.

FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.codmat = pCodMat
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN DO:
    pError = 'Código de Artículo: ' + pCodMat + ' NO registrado'.
    IF pVerError = YES THEN MESSAGE pError VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
FIND Almacen WHERE Almacen.codcia = s-codcia
    AND Almacen.codalm = pCodAlm
    NO-LOCK NO-ERROR.
FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
    AND Almtconv.Codalter = pUndVta
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv OR Almtconv.Equival <= 0 THEN DO:
    pError = 'Código de Artículo: ' + pCodMat + CHR(10) +
        'Error en la tabla de equivalencias' + CHR(10) +
        'Revisar lo siguiente:' + CHR(10) + 
        'Unidad Base = ' + Almmmatg.UndBas + CHR(10) +
        'Unidad de Venta = ' + pUndVta.
    IF pVerError = YES THEN MESSAGE pError VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
f-Factor = Almtconv.Equival.
pPreUni = pPreUni / f-Factor.   /* A Unidad Base: Incluido el IGV */
ASSIGN
    X-COSTO = 0     /* Incluido el IGV */
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
    pError = 'Código de Artículo: ' + pCodMat + CHR(10) +
        'Error el costos' + CHR(10) +
        'Revisar lo siguiente:' + CHR(10) + 
        'Costo = ' + STRING(x-Costo).
    IF pVerError = YES THEN MESSAGE pError VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
ASSIGN
    X-MARGEN = ROUND( ((( pPreUni / X-COSTO ) - 1 ) * 100 ), 2 )
    pMargen = x-Margen
    pLimite = x-Margen.     /* Por Defecto */

/* SELECCIONAMOS EL MARGEN MINIMO DE UTILIDAD */
DEF VAR x-Margen-Propios AS DEC NO-UNDO.
DEF VAR x-Margen-Terceros AS DEC NO-UNDO.

ASSIGN
    x-Margen-Propios = 0
    x-Margen-Terceros = 0.
RLOOP:
DO:
    /* 1ro. Por Artículo */
    FIND VtaTabla WHERE VtaTabla.codcia = s-codcia AND
        VtaTabla.tabla = 'MMA' AND
        VtaTabla.Llave_c1 = GN-DIVI.Grupo_Divi_GG AND
        VtaTabla.Llave_c2 = Almmmatg.CodMat
        NO-LOCK NO-ERROR.
    IF AVAILABLE VtaTabla THEN DO:
        ASSIGN
            x-Margen-Propios = VtaTabla.Valor[1]
            x-Margen-Terceros = VtaTabla.Valor[1].  /* El mismo */
        LEAVE RLOOP.
    END.
    /* 2do por Marca y Línea */
    FIND VtaDTabla WHERE VtaDTabla.CodCia = s-codcia AND 
        VtaDTabla.Tabla = "MMLM" AND
        VtaDTabla.Llave = GN-DIVI.Grupo_Divi_GG AND
        VtaDTabla.Tipo = Almmmatg.codfam AND 
        VtaDTabla.LlaveDetalle = Almmmatg.codmar
        NO-LOCK NO-ERROR.
    IF AVAILABLE VtaDTabla THEN DO:
        ASSIGN
            x-Margen-Propios = VtaDTabla.Libre_d01
            x-Margen-Terceros = VtaDTabla.Libre_d02.
        LEAVE RLOOP.
    END.
    /* 3ro por Linea y Sub-Linea */
    FIND VtaDTabla WHERE VtaDTabla.CodCia = s-CodCia  AND
        VtaDTabla.Tabla = "MMLS" AND
        VtaDTabla.Llave = GN-DIVI.Grupo_Divi_GG AND 
        VtaDTabla.Tipo  = Almmmatg.codfam AND 
        VtaDTabla.LlaveDetalle = Almmmatg.subfam
        NO-LOCK NO-ERROR.
    IF AVAILABLE VtaDTabla THEN DO:
        ASSIGN
            x-Margen-Propios = VtaDTabla.Libre_d01
            x-Margen-Terceros = VtaDTabla.Libre_d02.
        LEAVE RLOOP.
    END.
    /* 4to. por Línea */
    FIND VtaTabla WHERE VtaTabla.CodCia = s-Codcia AND
        VtaTabla.Llave_c1 = GN-DIVI.Grupo_Divi_GG AND 
        VtaTabla.Tabla = "MML" AND
        VtaTabla.Llave_c2 = Almmmatg.codfam 
        NO-LOCK NO-ERROR.
    IF AVAILABLE VtaTabla THEN DO:
        ASSIGN
            x-Margen-Propios = VtaTabla.Valor[1]
            x-Margen-Terceros = VtaTabla.Valor[2].
    END.
END.
/* MARGEN MINIMO POR LINEA */
IF Almmmatg.chr__02 = 'P' 
    THEN X-LIMITE = x-Margen-Propios.
    ELSE X-LIMITE = x-Margen-Terceros.
ASSIGN
    pLimite = x-Limite.
/* RHC 04.04.2011 Productos exonerados */
FIND VtaTabla WHERE VtaTabla.codcia = s-codcia
    AND VtaTabla.tabla = 'MMLX'
    AND VTaTabla.llave_c1 = pCodMat
    NO-LOCK NO-ERROR.
IF AVAILABLE VtaTabla THEN x-Limite = x-Margen.
/* *********************************** */
/* Almacenes de REMATES */
IF AVAILABLE Almacen AND Almacen.Campo-c[3] = "SI" THEN x-Limite = x-Margen.
/* ******************** */
IF X-MARGEN < X-LIMITE THEN DO:
    pError = 'ERROR EN EL ARTICULO: ' + pCodMat + CHR(10) +
            'MARGEN DE UTILIDAD MUY BAJO' + CHR(10) +
            'El margen es de ' + STRING(x-Margen) + '%, no debe ser menor a ' +
            STRING(x-Limite) + '%'.
    IF pVerError = YES THEN MESSAGE pError VIEW-AS ALERT-BOX WARNING.
    /* CALCULAMOS EL PRECIO MINIMO */
    x-Limite = (( pPreUni / X-COSTO ) - 1 ) * 100.
    pPreMin = ( 1 + x-Limite / 100 ) * x-Costo * f-Factor.
    RETURN 'ADM-ERROR'.
END.
RETURN 'OK'.


/*
DEF VAR pPreMin AS DEC NO-UNDO.

/* RHC 26.09.05 MARGEN DE UTILIDAD */
DEF VAR X-COSTO AS DEC NO-UNDO.
DEF VAR X-MARGEN AS DEC NO-UNDO.
DEF VAR X-LIMITE AS DEC NO-UNDO.
DEF VAR f-Factor AS DEC NO-UNDO.

FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.codmat = pCodMat
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN DO:
    pError = 'Código de Artículo: ' + pCodMat + ' NO registrado'.
    IF pVerError = YES THEN MESSAGE pError VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
FIND Almacen WHERE Almacen.codcia = s-codcia
    AND Almacen.codalm = pCodAlm
    NO-LOCK NO-ERROR.
FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
    AND Almtconv.Codalter = pUndVta
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv OR Almtconv.Equival <= 0 THEN DO:
    pError = 'Código de Artículo: ' + pCodMat + CHR(10) +
        'Error en la tabla de equivalencias' + CHR(10) +
        'Revisar lo siguiente:' + CHR(10) + 
        'Unidad Base = ' + Almmmatg.UndBas + CHR(10) +
        'Unidad de Venta = ' + pUndVta.
    IF pVerError = YES THEN MESSAGE pError VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
f-Factor = Almtconv.Equival.
pPreUni = pPreUni / f-Factor.   /* A Unidad Base: Incluido el IGV */
ASSIGN
    X-COSTO = 0     /* Incluido el IGV */
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
    pError = 'Código de Artículo: ' + pCodMat + CHR(10) +
        'Error el costos' + CHR(10) +
        'Revisar lo siguiente:' + CHR(10) + 
        'Costo = ' + STRING(x-Costo).
    IF pVerError = YES THEN MESSAGE pError VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
ASSIGN
    X-MARGEN = ROUND( ((( pPreUni / X-COSTO ) - 1 ) * 100 ), 2 )
    pMargen = x-Margen
    pLimite = x-Margen.     /* Por Defecto */
/* SELECCIONAMOS EL MARGEN MINIMO DE UTILIDAD */
DEF VAR x-Margen-Propios AS DEC NO-UNDO.
DEF VAR x-Margen-Terceros AS DEC NO-UNDO.

ASSIGN
    x-Margen-Propios = 0
    x-Margen-Terceros = 0.
RLOOP:
DO:
    /* 1ro. Por Artículo */
    FIND VtaTabla WHERE VtaTabla.codcia = s-codcia AND
        VtaTabla.tabla = 'MMA' AND
        VtaTabla.Llave_c1 = gn-divi.canalventa AND
        VtaTabla.Llave_c2 = Almmmatg.CodMat
        NO-LOCK NO-ERROR.
    IF AVAILABLE VtaTabla THEN DO:
        ASSIGN
            x-Margen-Propios = VtaTabla.Valor[1]
            x-Margen-Terceros = VtaTabla.Valor[1].  /* El mismo */
        LEAVE RLOOP.
    END.
    /* 2do por Marca y Línea */
    FIND VtaDTabla WHERE VtaDTabla.CodCia = s-codcia AND 
        VtaDTabla.Tabla = "MMLM" AND
        VtaDTabla.Llave = gn-divi.canalventa AND
        VtaDTabla.Tipo = Almmmatg.codfam AND 
        VtaDTabla.LlaveDetalle = Almmmatg.codmar
        NO-LOCK NO-ERROR.
    IF AVAILABLE VtaDTabla THEN DO:
        ASSIGN
            x-Margen-Propios = VtaDTabla.Libre_d01
            x-Margen-Terceros = VtaDTabla.Libre_d02.
        LEAVE RLOOP.
    END.
    /* 3ro por Linea y Sub-Linea */
    FIND VtaDTabla WHERE VtaDTabla.CodCia = s-CodCia  AND
        VtaDTabla.Tabla = "MMLS" AND
        VtaDTabla.Llave = gn-divi.canalventa AND 
        VtaDTabla.Tipo  = Almmmatg.codfam AND 
        VtaDTabla.LlaveDetalle = Almmmatg.subfam
        NO-LOCK NO-ERROR.
    IF AVAILABLE VtaDTabla THEN DO:
        ASSIGN
            x-Margen-Propios = VtaDTabla.Libre_d01
            x-Margen-Terceros = VtaDTabla.Libre_d02.
        LEAVE RLOOP.
    END.
    /* 4to. por Línea */
    FIND VtaTabla WHERE VtaTabla.CodCia = s-Codcia AND
        VtaTabla.Llave_c1 = gn-divi.canalventa AND 
        VtaTabla.Tabla = "MML" AND
        VtaTabla.Llave_c2 = Almmmatg.codfam 
        NO-LOCK NO-ERROR.
    IF AVAILABLE VtaTabla THEN DO:
        ASSIGN
            x-Margen-Propios = VtaTabla.Valor[1]
            x-Margen-Terceros = VtaTabla.Valor[2].
    END.
END.
/* MARGEN MINIMO POR LINEA */
IF Almmmatg.chr__02 = 'P' 
    THEN X-LIMITE = x-Margen-Propios.
    ELSE X-LIMITE = x-Margen-Terceros.
ASSIGN
    pLimite = x-Limite.
/* *********************************** */
/* Almacenes de REMATES */
IF AVAILABLE Almacen AND Almacen.Campo-c[3] = "SI" THEN x-Limite = x-Margen.
/* ******************** */
IF X-MARGEN < X-LIMITE THEN DO:
    pError = 'ERROR EN EL ARTICULO: ' + pCodMat + CHR(10) +
            'MARGEN DE UTILIDAD MUY BAJO' + CHR(10) +
            'El margen es de ' + STRING(x-Margen) + '%, no debe ser menor a ' +
            STRING(x-Limite) + '%'.
    IF pVerError = YES THEN MESSAGE pError VIEW-AS ALERT-BOX WARNING.
    /* CALCULAMOS EL PRECIO MINIMO */
    x-Limite = (( pPreUni / X-COSTO ) - 1 ) * 100.
    pPreMin = ( 1 + x-Limite / 100 ) * x-Costo * f-Factor.
    RETURN 'ADM-ERROR'.
END.
RETURN 'OK'.

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


