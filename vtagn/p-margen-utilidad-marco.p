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
/* PARAMETROS */
DEF INPUT PARAMETER  pCodMat LIKE Almmmatg.CodMat.
DEF INPUT PARAMETER  pPreUni AS DEC.
DEF INPUT PARAMETER  pUndVta AS CHAR.
DEF INPUT PARAMETER  pMonVta AS INT.
DEF INPUT PARAMETER  pTpoCmb AS DEC.
DEF INPUT PARAMETER  pVerError AS LOG.      /* Mostrar el error */
DEF INPUT PARAMETER  pCodAlm AS CHAR.
DEF OUTPUT PARAMETER pMargen AS DEC.
DEF OUTPUT PARAMETER pLimite AS DEC.
DEF OUTPUT PARAMETER pError AS CHAR.        /* Se relaciona con el parámetro pVerError */

DEF VAR pPreMin AS DEC.

DEF SHARED VAR s-codcia AS INT.

/* RHC 26.09.05 MARGEN DE UTILIDAD */
DEF VAR X-COSTO AS DEC NO-UNDO.
DEF VAR x-MonCto AS INT NO-UNDO.
DEF VAR X-MARGEN AS DEC NO-UNDO.
DEF VAR X-LIMITE AS DEC NO-UNDO.
DEF VAR f-Factor AS DEC NO-UNDO.

FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.codmat = pCodMat
    NO-LOCK NO-ERROR.
FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
    AND Almtconv.Codalter = pUndVta
    NO-LOCK NO-ERROR.
FIND Almacen WHERE Almacen.codcia = s-codcia
    AND Almacen.codalm = pCodAlm
    NO-LOCK NO-ERROR.
f-Factor = Almtconv.Equival / Almmmatg.FacEqu.
pPreUni = pPreUni / f-Factor.

ASSIGN
    X-COSTO = (IF Almmmatg.CtoTotMarco > 0 THEN Almmmatg.CtoTotMarco ELSE Almmmatg.CtoTot)
    x-MonCto = (IF Almmmatg.CtoTotMarco > 0 THEN Almmmatg.DEC__02 ELSE Almmmatg.MonVta)
    X-MARGEN = 0.
IF pMonVta = 1 THEN DO:
   IF x-MonCto = 1 THEN 
      ASSIGN X-COSTO = x-Costo.
   ELSE
      ASSIGN X-COSTO = x-Costo * Almmmatg.TpoCmb.     /*pTpoCmb.*/
END.        
IF pMonVta = 2 THEN DO:
   IF x-MonCto = 2 THEN
      ASSIGN X-COSTO = x-Costo.
   ELSE
      ASSIGN X-COSTO = x-Costo / Almmmatg.TpoCmb.     /*pTpoCmb .*/
END.      
ASSIGN
    X-MARGEN = ROUND( ((( pPreUni / X-COSTO ) - 1 ) * 100 ), 2 )
    pMargen = x-Margen
    pLimite = x-Margen
    pError  = "OK".
/* Margen mínimo por Linea */
FIND TabGener WHERE Tabgener.codcia = s-codcia 
    AND Tabgener.clave = 'MML'
    AND Tabgener.codigo = Almmmatg.codfam NO-LOCK NO-ERROR.
IF AVAILABLE TabGener THEN DO:
    IF Almmmatg.chr__02 = 'P' 
    THEN X-LIMITE = TabGener.Parametro[2].
    ELSE X-LIMITE = TabGener.Parametro[1].
    /* Margen mínimo por Sublinea */
    FIND VtaTabla WHERE VtaTabla.codcia = s-codcia
        AND VtaTabla.tabla = 'MMLL'
        AND VtaTabla.llave_c1 = Almmmatg.codfam
        AND VtaTabla.llave_c2 = Almmmatg.subfam
        NO-LOCK NO-ERROR.
    IF AVAILABLE VtaTabla THEN DO:
        IF Almmmatg.chr__02 = 'P' 
        THEN X-LIMITE = VtaTabla.Valor[2].
        ELSE X-LIMITE = VtaTabla.Valor[1].
        /* Margen mínimo por marca */
        FIND VtaTabla WHERE VtaTabla.CodCia = TabGener.CodCia
            AND VtaTabla.Tabla = 'MMLLM'
            AND VtaTabla.Llave_c1 = Almmmatg.codfam
            AND VtaTabla.Llave_c2 = Almmmatg.subfam
            AND VtaTabla.Llave_c3 = Almmmatg.codmar
            NO-LOCK NO-ERROR.
        IF AVAILABLE VtaTabla THEN DO:
            IF Almmmatg.chr__02 = 'P' 
            THEN X-LIMITE = VtaTabla.Valor[2].
            ELSE X-LIMITE = VtaTabla.Valor[1].
        END.
    END.
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
        IF pVerError = YES 
            THEN MESSAGE 'ERROR EN EL PRODUCTO:' pCodMat SKIP
                'MARGEN DE UTILIDAD MUY BAJO' SKIP
                'El margen es de' x-Margen '%, no debe ser menor a' x-Limite '%'
                VIEW-AS ALERT-BOX WARNING.
        pError = "ADM-ERROR".
        /* CALCULAMOS EL PRECIO MINIMO */
        x-Limite = (( pPreUni / X-COSTO ) - 1 ) * 100.
        pPreMin = ( 1 + x-Limite / 100 ) * x-Costo * f-Factor.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


