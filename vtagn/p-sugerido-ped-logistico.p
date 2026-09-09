&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description : Redondeamos al empaque inferior

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEF SHARED VAR s-codcia AS INTE.
    
DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pCanPed AS DECI.        /* Cantidad Pedida */
DEF INPUT PARAMETER pFactor AS DECI.        /* Factor de conversión */
DEF INPUT PARAMETER pListaPrecios AS CHAR.  /* División o Lista de Precios */
DEF OUTPUT PARAMETER pSugerido AS DECI.     /* Cantidad Sugerida */
DEF OUTPUT PARAMETER pMaster AS DECI.
DEF OUTPUT PARAMETER pInner  AS DECI.

FIND Almmmatg WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = pCodMat NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN RETURN.

FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = pListaPrecios NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN RETURN.

/* Dividimos la cantidad en fracciones de empaque master e inner */

/* 1ro Determinamos el empaque master e inner */
FIND AlmCatVtaD WHERE AlmCatVtaD.CodCia = s-CodCia AND
    AlmCatVtaD.CodDiv = pListaPrecios AND 
    AlmCatVtaD.CodPro = Almmmatg.CodPr1 AND
    AlmCatVtaD.codmat = pCodMat AND
    CAN-FIND(AlmCatVtaC WHERE AlmCatVtaC.CodCia = AlmCatVtaD.CodCia AND
             AlmCatVtaC.CodDiv = AlmCatVtaD.CodDiv AND
             AlmCatVtaC.CodPro = AlmCatVtaD.CodPro AND 
             AlmCatVtaC.NroPag = AlmCatVtaD.NroPag NO-LOCK)
    NO-LOCK NO-ERROR.
IF GN-DIVI.CanalVenta = "FER" AND Almmmatg.Libre_d03 > 0 THEN DO:
    pMaster = Almmmatg.Libre_d03.      /* Empaque Master Expolibreria */
END.
IF pMaster <= 0 AND Almmmatg.CanEmp > 0 THEN DO:
    pMaster = Almmmatg.CanEmp.         /* Empaque Master Empresa */
END.
IF GN-DIVI.CanalVenta = "FER" AND AVAILABLE AlmCatVtaD AND AlmCatVtaD.Libre_d03 > 0 THEN DO:
    pMaster = AlmCatVtaD.Libre_d03.    /* Empaque Master Expolibreria */
END.
IF pInner <= 0 AND Almmmatg.StkRep > 0 THEN DO:
    pInner = Almmmatg.StkRep.         /* Empaque Inner Empresa */
END.

DEF VAR f-CanFinal AS DECI NO-UNDO.
DEF VAR f-CanPed AS DECI NO-UNDO.

f-CanPed = pCanPed * pFactor.   /* En unidades de stock */

/* Si no hay definido empaques */
IF pMaster <= 0 AND pInner <= 0 THEN DO:
    ASSIGN pSugerido = pCanPed.        /* Valor por defecto */
    RETURN.
END.

EMPAQUE:
DO:
    /* 2do Redondeemos al Empaque Master */
    IF pMaster > 0 THEN DO:
        IF f-CanPed >= pMaster THEN DO:     /* Sí se puede redondear en Empaque Master */
            f-CanFinal = TRUNCATE(f-CanPed / pMaster, 0) * pMaster.
            pSugerido = pSugerido + f-CanFinal.
            f-CanPed = f-CanPed - f-CanFinal.
        END.
    END.
    IF f-CanPed <= 0 THEN LEAVE EMPAQUE.
    /* 3ro Redondeamos al Empaque Inner */
    IF pInner > 0 THEN DO:
        IF f-CanPed >= pInner THEN DO:
            f-CanFinal = TRUNCATE(f-CanPed / pInner, 0) * pInner.
            pSugerido = pSugerido + f-CanFinal.
            f-CanPed = f-CanPed - f-CanFinal.
        END.
    END.
END.
/* Devolvemos el Sugerido en unidades de venta */
pSugerido = ((pSugerido - (pSugerido MODULO pFactor)) / pFactor).  /* En unidades de venta */
/*pSugerido = pSugerido / pFactor.*/

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
         HEIGHT             = 4.69
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


