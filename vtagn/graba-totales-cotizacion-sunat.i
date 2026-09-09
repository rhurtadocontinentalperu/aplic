&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Importe total para FacCPedi (COT PED O/D P/M)

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
         HEIGHT             = 4.96
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

DEFINE VARIABLE F-IGV AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-ISC AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-Dto2xExonerados AS DEC NO-UNDO.
DEFINE VARIABLE x-Dto2xAfectosIgv AS DEC NO-UNDO.
DEFINE VAR x-Precio-ICBPER AS DECI NO-UNDO.

ASSIGN
    FacCPedi.ImpDto = 0
    FacCPedi.ImpDto2 = 0
    FacCPedi.ImpIgv = 0
    FacCPedi.ImpIsc = 0
    FacCPedi.ImpTot = 0
    FacCPedi.ImpExo = 0
    FacCPedi.Importe[3] = 0
    F-IGV = 0
    F-ISC = 0
    x-Dto2xExonerados = 0
    x-Dto2xAfectosIgv = 0.
/* RHC 15/08/19 pedido por G.P.: Impuesto a la bolsa plástica */
ASSIGN
    Faccpedi.AcuBon[10] = 0.

/* ********************************************************************************** */
/* Sacar el importe de bolsas plasticas */
/* ********************************************************************************** */
x-precio-ICBPER = 0.0.   

DEFINE VAR z-hProc AS HANDLE NO-UNDO.               /* Handle Libreria */

RUN ccb\libreria-ccb.p PERSISTENT SET z-hProc.

RUN precio-impsto-bolsas-plastica IN z-hProc (INPUT TODAY, OUTPUT x-precio-ICBPER).

DELETE PROCEDURE z-hProc.                   /* Release Libreria */
/* ********************************************************************************** */
/* ********************************************************************************** */
/* VENTAS INAFECTAS A IGV */
IF FacCPedi.FlgIgv = NO THEN DO:
    FacCPedi.PorIgv = 0.00.
    FOR EACH FacDPedi OF FacCPedi:
        ASSIGN
            FacDPedi.AftIgv = NO
            FacDPedi.ImpIgv = 0.00.
    END.
END.

FOR EACH FacDPedi OF FacCPedi NO-LOCK, FIRST Almmmatg OF FacDPedi NO-LOCK:
    F-Igv = F-Igv + FacDPedi.ImpIgv.
    F-Isc = F-Isc + FacDPedi.ImpIsc.

    FacCPedi.ImpTot = FacCPedi.ImpTot + FacDPedi.ImpLin.
    FacCPedi.ImpDto2 = FacCPedi.ImpDto2 + FacDPedi.ImpDto2.

    IF FacDPedi.AftIgv = YES
    THEN FacCPedi.ImpDto = FacCPedi.ImpDto + ROUND(FacDPedi.ImpDto / (1 + FacCPedi.PorIgv / 100), 2).
    ELSE FacCPedi.ImpDto = FacCPedi.ImpDto + FacDPedi.ImpDto.

    IF NOT FacDPedi.AftIgv THEN FacCPedi.ImpExo = FacCPedi.ImpExo + FacDPedi.ImpLin.

    IF NOT FacDPedi.AftIgv THEN x-Dto2xExonerados = x-Dto2xExonerados + FacDPedi.ImpDto2.
    ELSE x-Dto2xAfectosIgv = x-Dto2xAfectosIgv + FacDPedi.ImpDto2.

    IF Almmmatg.CodFam = '086' 
        THEN FacCPedi.AcuBon[10] = FacCPedi.AcuBon[10] + (Facdpedi.CanPed  * x-precio-ICBPER).
END.

ASSIGN
    FacCPedi.ImpIgv = ROUND(F-IGV,2)
    FacCPedi.ImpIsc = ROUND(F-ISC,2).
ASSIGN
    FacCPedi.ImpVta = FacCPedi.ImpTot - FacCPedi.ImpExo - FacCPedi.ImpIgv - Faccpedi.AcuBon[10].
ASSIGN
    FacCPedi.ImpBrt = FacCPedi.ImpVta + FacCPedi.ImpDto
    FacCPedi.Importe[1] = FacCPedi.ImpTot.    /* Guardamos el importe original */
/* RHC 06/05/2014 En caso tenga descuento por Encarte */
IF Faccpedi.ImpDto2 > 0 THEN DO:
    ASSIGN
        Faccpedi.ImpTot = Faccpedi.ImpTot - Faccpedi.ImpDto2
        Faccpedi.ImpIgv = Faccpedi.ImpIgv -  ~
            ROUND(x-Dto2xAfectosIgv / ( 1 + Faccpedi.PorIgv / 100) * Faccpedi.PorIgv / 100, 2)
        Faccpedi.ImpExo = Faccpedi.ImpExo - x-Dto2xExonerados
        FacCPedi.ImpVta = FacCPedi.ImpTot - FacCPedi.ImpExo - FacCPedi.ImpIgv - Faccpedi.AcuBon[10]
        FacCPedi.ImpBrt = FacCPedi.ImpVta + FacCPedi.ImpDto.
END.
/* ******************************************** */
/* RHC 15/08/19 IMPUESTO A LA BOLSA DE PLASTICO */
/* ******************************************** */
ASSIGN
    Faccpedi.ImpTot = Faccpedi.ImpTot /*+ Faccpedi.AcuBon[10]*/.

/* PERCEPCION */
RUN vta2/percepcion-por-pedido ( ROWID(Faccpedi) ).

/* *************************************** */
FIND CURRENT Faccpedi EXCLUSIVE-LOCK.
/* *************************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


