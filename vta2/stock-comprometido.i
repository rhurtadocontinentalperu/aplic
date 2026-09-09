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

DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pCodAlm AS CHAR.
DEF OUTPUT PARAMETER pComprometido AS DEC.

/* CALCULO DEL STOCK COMPROMETIDO */
FIND FacCfgGn WHERE faccfggn.codcia = s-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccfggn THEN RETURN.

/* Stock comprometido por PEDIDOS ACTIVOS MOSTRADOR */
DEF VAR TimeOut AS INTEGER NO-UNDO.
DEF VAR TimeNow AS INTEGER NO-UNDO.

/* Tiempo por defecto fuera de campaña */
TimeOut = (FacCfgGn.Dias-Res * 24 * 3600) +
          (FacCfgGn.Hora-Res * 3600) + 
          (FacCfgGn.Minu-Res * 60).

pComprometido = 0.
DEF VAR i AS INT NO-UNDO.
DEF VAR x-CodAlm AS CHAR NO-UNDO.

DO i = 1 TO NUM-ENTRIES(pCodAlm):
    x-CodAlm = ENTRY(i, pCodAlm).
    /**********   Barremos para los PEDIDOS MOSTRADOR ***********************/ 
    FOR EACH Facdpedi USE-INDEX Llave04 NO-LOCK WHERE Facdpedi.CodCia = s-codcia
        AND Facdpedi.AlmDes = x-CodAlm
        AND Facdpedi.codmat = pcodmat
        AND Facdpedi.coddoc = 'P/M'
        AND Facdpedi.FlgEst = "P":
        FIND FIRST Faccpedi OF Facdpedi WHERE Faccpedi.FlgEst = "P" NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Faccpedi THEN NEXT.

        TimeNow = (TODAY - FacCPedi.FchPed) * 24 * 3600.
        TimeNow = TimeNow + TIME - ( (INTEGER(SUBSTRING(FacCPedi.Hora, 1, 2)) * 3600) +
                  (INTEGER(SUBSTRING(FacCPedi.Hora, 4, 2)) * 60) ).
        IF TimeOut > 0 THEN DO:
            IF TimeNow <= TimeOut   /* Dentro de la valides */
            THEN DO:
                /* cantidad en reservacion */
                pComprometido = pComprometido + FacDPedi.Factor * FacDPedi.CanPed.
            END.
        END.
    END.
    
    /**********   Barremos para los PEDIDOS AL CREDITO   ***********************/ 
    FOR EACH Facdpedi USE-INDEX Llave04 NO-LOCK WHERE Facdpedi.codcia = s-codcia
        AND Facdpedi.almdes = x-CodAlm
        AND Facdpedi.codmat = pCodMat
        AND Facdpedi.coddoc = 'PED'
        AND Facdpedi.flgest = 'P':
        /* RHC 12.12.2011 agregamos los nuevos estados */
        FIND FIRST Faccpedi OF Facdpedi WHERE LOOKUP(Faccpedi.FlgEst, "G,X,P,W,WX,WL") > 0 NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Faccpedi THEN NEXT.
        pComprometido = pComprometido + FacDPedi.Factor * (FacDPedi.CanPed - FacDPedi.canate).
    END.
    /* ORDENES DE DESPACHO CREDITO */
    FOR EACH Facdpedi USE-INDEX Llave04 NO-LOCK WHERE Facdpedi.codcia = s-codcia
        AND Facdpedi.almdes = x-CodAlm
        AND Facdpedi.codmat = pCodMat
        AND Facdpedi.coddoc = 'O/D'
        AND LOOKUP(Facdpedi.flgest, 'WL,P') > 0:
        FIND FIRST Faccpedi OF Facdpedi WHERE Faccpedi.flgest = 'P' NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Faccpedi THEN NEXT.
        pComprometido = pComprometido + FacDPedi.Factor * (FacDPedi.CanPed - FacDPedi.canate).
    END.
    
    /* Stock Comprometido por Pedidos por Reposicion Automatica */
    /* OJO ver tambien el programa vtamay/c-conped.w */
    FOR EACH Almcrepo USE-INDEX Llave02 NO-LOCK WHERE Almcrepo.codcia = s-codcia
        AND Almcrepo.AlmPed = x-CodAlm
        AND Almcrepo.FlgEst = 'P',
        /*AND LOOKUP(Almcrepo.FlgSit, 'A,P,G') > 0,     /* Aprobados y x Aprobar */*/
        EACH Almdrepo OF Almcrepo NO-LOCK WHERE Almdrepo.codmat = pCodMat
        AND almdrepo.CanApro > almdrepo.CanAten:
        pComprometido = pComprometido + (Almdrepo.CanApro - Almdrepo.CanAten).
    END.
    
    /* POR ORDENES DE TRANSFERENCIA */
    FOR EACH Facdpedi USE-INDEX Llave04 NO-LOCK WHERE Facdpedi.codcia = s-codcia
        AND Facdpedi.almdes = x-CodAlm
        AND Facdpedi.codmat = pCodMat
        AND Facdpedi.coddoc = 'OTR'
        AND Facdpedi.flgest = 'P':
        FIND FIRST Faccpedi OF Facdpedi WHERE Faccpedi.flgest = 'P' NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Faccpedi THEN NEXT.
        pComprometido = pComprometido + FacDPedi.Factor * (FacDPedi.CanPed - FacDPedi.CanAte).
    END.
    /* RHC 27/12/2013 STOCK COMPROMETIDO POR COTIZACIONES Y PRE-PEDIDOS EXPOLIBRERIA */
/*     FOR EACH Facdpedi USE-INDEX Llave04 NO-LOCK WHERE Facdpedi.codcia = s-codcia                   */
/*             AND Facdpedi.almdes = x-CodAlm                                                         */
/*             AND Facdpedi.codmat = pCodMat                                                          */
/*             AND Facdpedi.coddoc = 'COT'                                                            */
/*             AND Facdpedi.flgest = 'P',                                                             */
/*         FIRST Faccpedi OF Facdpedi NO-LOCK WHERE Faccpedi.FlgEst = "P" AND Faccpedi.TpoPed = "E".  */
/*         pComprometido = pComprometido + FacDPedi.Factor * (FacDPedi.CanPed - FacDPedi.canate).     */
/*     END.                                                                                           */
/*     FOR EACH Vtaddocu USE-INDEX Llave04 NO-LOCK WHERE Vtaddocu.codcia = s-codcia                   */
/*             AND Vtaddocu.almdes = x-CodAlm                                                         */
/*             AND Vtaddocu.codmat = pCodMat                                                          */
/*             AND Vtaddocu.codped = 'PET'                                                            */
/*             AND Vtaddocu.flgest = 'P',                                                             */
/*         FIRST Vtacdocu OF Vtaddocu NO-LOCK WHERE Vtacdocu.FlgEst = "P" AND Vtacdocu.FlgSit <> "T": */
/*         pComprometido = pComprometido + Vtaddocu.Factor * Vtaddocu.CanPed.                         */
/*     END.                                                                                           */
    /* ***************************************************************************** */
    /* Stock Comprometido por Pedidos por Uso Interno */
/*     FOR EACH Almcdocu NO-LOCK WHERE Almcdocu.codcia = s-codcia                     */
/*         AND Almcdocu.CodDoc= 'SUI'                                                 */
/*         AND Almcdocu.Libre_c02 = x-CodAlm                                          */
/*         AND LOOKUP(Almcdocu.FlgEst, 'T,WL,P') > 0,                                 */
/*         EACH Almddocu OF Almcdocu NO-LOCK WHERE Almddocu.codigo = pCodMat          */
/*         AND Almddocu.Libre_d02 > Almddocu.Libre_d03:                               */
/*         pComprometido = pComprometido + (Almddocu.Libre_d02 - Almddocu.Libre_d03). */
/*     END.                                                                           */
END.

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
         HEIGHT             = 3.96
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


