&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
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

/* CALCULO DE FLETE (FACTOR HAROLD) */
DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pCodDiv AS CHAR.        /* La división o la lista de precios */
DEF INPUT PARAMETER pCodMon AS INT.         /* 1: S/  2: US$ */
DEF INPUT PARAMETER pFactor AS DEC.
/*DEF INPUT PARAMETER pTpoPed AS CHAR.  */  /* FALTA INCLUIR ESTE PARAMETRO */
DEF OUTPUT PARAMETER pFleteUnitario AS DEC.

DEF SHARED VAR s-CodCia AS INT.

pFleteUnitario = 0.     /* Valor por defecto */

/* CONSISTENCIAS */
/* Registrado en el catálogo de productos */
FIND Almmmatg WHERE Almmmatg.CodCia = s-CodCia AND Almmmatg.codmat = pCodMat NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN RETURN.

/* Lista de precios afecta a flete */
IF NOT CAN-FIND(GN-DIVI WHERE GN-DIVI.CodCia = s-CodCia AND
                GN-DIVI.CodDiv = pCodDiv AND 
                GN-DIVI.Campo-Log[1] = NO AND   
                GN-DIVI.Campo-Log[4] = TRUE NO-LOCK) THEN RETURN.

/* Linea (y sublinea) afecta a flete */
/* Por Línea y SUbLinea */
FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia AND
    VtaTabla.Tabla = "FLETEXLINEA" AND
    VtaTabla.Llave_c1 = pCodDiv AND 
    VtaTabla.Llave_c2 = Almmmatg.CodFam AND
    VtaTabla.LLave_c3 = Almmmatg.SubFam
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaTabla THEN DO:
    /* Solo por Línea */
    FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia AND
        VtaTabla.Tabla = "FLETEXLINEA" AND
        VtaTabla.Llave_c1 = pCodDiv AND 
        VtaTabla.Llave_c2 = Almmmatg.CodFam AND
        TRUE <> (VtaTabla.LLave_c3 > '')
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE VtaTabla THEN RETURN.
END.

FIND FacTabla WHERE FacTabla.CodCia = s-CodCia AND
    FacTabla.Tabla  = 'FLETE' AND
    FacTabla.Codigo = pCodDiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacTabla OR (FacTabla.Valor[1] + FacTabla.Valor[2] = 0) THEN RETURN.

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
         HEIGHT             = 4.35
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/* DETERMINAMOS SI ES POR PESO O VOLUMEN */
DEF VAR x-FactorFlete AS DEC NO-UNDO.
DEF VAR x-FleteVolumen AS DEC NO-UNDO.
DEF VAR x-FletePeso AS DEC NO-UNDO.
DEF VAR x-CostoUnitario AS DEC NO-UNDO.
DEF VAR x-PesoUnitario AS DEC NO-UNDO.
DEF VAR x-VolumenUnitario AS DEC NO-UNDO.
DEF VAR x-FleteUnitarioPeso AS DEC NO-UNDO.
DEF VAR x-FleteUnitarioVolumen AS DEC NO-UNDO.

DEF VAR x-CamionPeso AS DEC INIT 30000.       /* 30 TM */
DEF VAR x-CamionVolumen AS DEC INIT 85.       /* 85 m3 */

x-PesoUnitario = Almmmatg.Pesmat.
x-VolumenUnitario = Almmmatg.Libre_d02 / 1000000.

/* Ic - 06Oct2018, segun el flete ordenado por Karim Rodenberg/Gloria Salas */
FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND 
                            vtatabla.tabla = "FLETEXARTICULO" AND 
                            vtatabla.llave_c1 = pCodDiv AND 
                            vtatabla.llave_c2 = almmmatg.codmat NO-LOCK NO-ERROR.

IF NOT AVAILABLE vtatabla THEN DO:
    IF x-PesoUnitario = 0 OR x-VolumenUnitario = 0 THEN RETURN.

    DEF VAR x-UnidadesxPeso AS DEC NO-UNDO.
    DEF VAR x-UnidadesxVolumen AS DEC NO-UNDO.

    x-UnidadesxPeso = x-CamionPeso / x-PesoUnitario.        /* UNIDADES */
    x-UnidadesxVolumen = x-CamionVolumen / x-VolumenUnitario.   /* UNIDADES */

    FIND FacTabla WHERE FacTabla.CodCia = s-CodCia AND
        FacTabla.Tabla  = 'FLETE' AND
        FacTabla.Codigo = pCodDiv
        NO-LOCK NO-ERROR.
    IF AVAILABLE FacTabla THEN
        ASSIGN
            x-FleteUnitarioPeso = FacTabla.Valor[1] 
            x-FleteUnitarioVolumen = FacTabla.Valor[2].
    /*
    MESSAGE "x-FleteUnitarioPeso " x-FleteUnitarioPeso SKIP
                "x-FleteUnitarioVolumen " x-FleteUnitarioVolumen.
    */            
    IF pCodMon = 2 THEN
        ASSIGN
            x-FleteUnitarioPeso = x-FleteUnitarioPeso / Almmmatg.TpoCmb
            x-FleteUnitarioVolumen = x-FleteUnitarioVolumen / Almmmatg.TpoCmb.

    IF x-UnidadesxPeso < x-UnidadesxVolumen THEN DO:
        pFleteUnitario = (x-CamionPeso * x-FleteUnitarioPeso) / x-UnidadesxPeso.
    END.
    ELSE DO:
        pFleteUnitario = (x-CamionVolumen * x-FleteUnitarioVolumen) / x-UnidadesxVolumen.
    END.
END.
ELSE DO:
    pFleteUnitario = vtatabla.valor[1].
END.
pFleteUnitario = pFleteUnitario * pFactor.

/* RHC Factor Gerencia General 
Habilitar pasada la campaña 2019 

RUN gn/factor-porcentual-flete-v2 ( INPUT pCodDiv,      /* Lista de Precio */
                                    INPUT pCodMat,
                                    INPUT-OUTPUT pFleteUnitario,
                                    INPUT pTpoPed,
                                    INPUT pFactor,
                                    INPUT pCodMon).
*/

RETURN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


