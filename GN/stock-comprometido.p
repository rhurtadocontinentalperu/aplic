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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pCodAlm AS CHAR.
DEF OUTPUT PARAMETER pComprometido AS DEC.

/* CALCULO DEL STOCK COMPROMETIDO */
DEF SHARED VAR s-codcia AS INT.

FIND FacCfgGn WHERE faccfggn.codcia = s-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccfggn THEN RETURN.

/* Stock comprometido por PEDIDOS ACTIVOS MOSTRADOR */
DEF VAR TimeOut AS INTEGER NO-UNDO.
DEF VAR TimeNow AS INTEGER NO-UNDO.

/* Tiempo por defecto fuera de campaña */
TimeOut = (FacCfgGn.Dias-Res * 24 * 3600) +
          (FacCfgGn.Hora-Res * 3600) + 
          (FacCfgGn.Minu-Res * 60).

FOR EACH Facdpedm NO-LOCK USE-INDEX Llave03 WHERE Facdpedm.CodCia = s-codcia 
    AND Facdpedm.coddoc = 'P/M'
    AND Facdpedm.AlmDes = pCODALM
    AND Facdpedm.codmat = pcodmat 
    AND Facdpedm.FlgEst = "P" :
    FIND FIRST Faccpedm OF Facdpedm WHERE 
        /*Faccpedm.CodAlm = pcodalm AND */
        Faccpedm.FlgEst = "P"  
        NO-LOCK NO-ERROR. 
    IF NOT AVAIL Faccpedm THEN NEXT.
    
    TimeNow = (TODAY - FacCPedm.FchPed) * 24 * 3600.
    TimeNow = TimeNow + TIME - ( (INTEGER(SUBSTRING(FacCPedm.Hora, 1, 2)) * 3600) +
              (INTEGER(SUBSTRING(FacCPedm.Hora, 4, 2)) * 60) ).
    IF TimeOut > 0 THEN DO:
        IF TimeNow <= TimeOut   /* Dentro de la valides */
        THEN DO:
            /* cantidad en reservacion */
            pComprometido = pComprometido + FacDPedm.Factor * FacDPedm.CanPed.
        END.
    END.
END.



/***
/* Tiempo dentro de campaña */
FIND FIRST FacCfgVta WHERE Faccfgvta.codcia = s-codcia
    AND Faccfgvta.coddoc = 'P/M'
    AND TODAY >= Faccfgvta.fechad
    AND TODAY <= Faccfgvta.fechah
    NO-LOCK NO-ERROR.
IF AVAILABLE FacCfgVta 
THEN TimeOut = (FacCfgVta.Dias-Res * 24 * 3600) +
                (FacCfgVta.Hora-Res * 3600) + 
                (FacCfgVta.Minu-Res * 60).
IF TimeOut > 0 THEN DO:
    /*
    FOR EACH Faccpedm NO-LOCK WHERE Faccpedm.codcia = s-codcia
        AND Faccpedm.coddoc = "P/M"
        AND Faccpedm.flgest = "P":
        TimeNow = (TODAY - FacCPedm.FchPed) * 24 * 3600.
        TimeNow = TimeNow + TIME - ( (INTEGER(SUBSTRING(FacCPedm.Hora, 1, 2)) * 3600) +
                  (INTEGER(SUBSTRING(FacCPedm.Hora, 4, 2)) * 60) ).
        IF TimeNow > TimeOut THEN NEXT.
        FOR EACH Facdpedm OF Faccpedm NO-LOCK WHERE Facdpedm.almdes = pCodAlm
            AND Facdpedm.codmat = pCodMat:
            pComprometido = pComprometido + FacDPedm.Factor * FacDPedm.CanPed.
        END.
    END.
    */
END.
*****/

/**********   Barremos para los PEDIDOS AL CREDITO   ***********************/ 
FOR EACH Facdpedi USE-INDEX Llave04 NO-LOCK WHERE Facdpedi.codcia = s-codcia
        AND Facdpedi.almdes = pCodAlm
        AND Facdpedi.codmat = pCodMat
        AND Facdpedi.coddoc = 'PED'
        AND (Facdpedi.canped - Facdpedi.canate) > 0
        AND LOOKUP (Facdpedi.flgest, 'X,P') > 0,
        FIRST Faccpedi OF Facdpedi NO-LOCK WHERE LOOKUP(Faccpedi.FlgEst, "X,P") > 0:
    pComprometido = pComprometido + FacDPedi.Factor * (FacDPedi.CanPed - FacDPedi.canate).
END.

FOR EACH Facdpedi USE-INDEX Llave04 NO-LOCK WHERE Facdpedi.codcia = s-codcia
        AND Facdpedi.almdes = pCodAlm
        AND Facdpedi.codmat = pCodMat
        AND Facdpedi.coddoc = 'O/D'
        AND (Facdpedi.canped - Facdpedi.canate) > 0
        AND  FacDPedi.FlgEst = 'P',
        FIRST Faccpedi OF Facdpedi NO-LOCK WHERE Faccpedi.flgest = 'P':
    pComprometido = pComprometido + FacDPedi.Factor * (FacDPedi.CanPed - FacDPedi.canate).
END.

/* Stock Comprometido por Pedidos por Reposicion Automatica */
FOR EACH Almcrepo NO-LOCK WHERE Almcrepo.codcia = s-codcia
    AND Almcrepo.TipMov = 'A'
    AND Almcrepo.AlmPed = pCodAlm
    AND Almcrepo.FlgEst = 'P',
    /*AND Almcrepo.FlgSit = 'A',*/
    EACH Almdrepo OF Almcrepo NO-LOCK WHERE Almdrepo.codmat = pCodMat
    AND almdrepo.CanApro > almdrepo.CanAten:
    pComprometido = pComprometido + (Almdrepo.CanApro - Almdrepo.CanAten).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


