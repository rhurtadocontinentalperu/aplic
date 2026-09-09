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
         HEIGHT             = 3.92
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pCodAlm AS CHAR.
DEF OUTPUT PARAMETER pComprometido AS DEC.

/* Pedidos por Reposicion Aprobados en Tránsito */
FOR EACH Almdrepo NO-LOCK WHERE Almdrepo.codcia = s-codcia
    AND Almdrepo.codmat = pCodMat
    AND Almdrepo.codalm = pCodAlm
    AND LOOKUP(Almdrepo.almped, '997,998') = 0
    AND Almdrepo.CanApro > almdrepo.CanAten:
    FIND FIRST Almcrepo WHERE Almcrepo.codcia = almdrepo.codcia
        AND Almcrepo.codalm = Almdrepo.codalm
        AND Almcrepo.tipmov = Almdrepo.tipmov
        AND Almcrepo.nroser = Almdrepo.nroser
        AND Almcrepo.nrodoc = Almdrepo.nrodoc
        AND Almcrepo.FlgEst = 'P'
        /*AND LOOKUP(Almcrepo.FlgSit, 'A,P') > 0*/
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almcrepo THEN pComprometido = pComprometido + (Almdrepo.CanApro - Almdrepo.CanAten).
END.
/* FOR EACH Almcrepo NO-LOCK WHERE Almcrepo.codcia = s-codcia                 */
/*     AND Almcrepo.CodAlm = pCodAlm                                          */
/*     AND LOOKUP(Almcrepo.AlmPed, '997,998') = 0                             */
/*     AND Almcrepo.FlgEst = 'P'                                              */
/*     AND LOOKUP(Almcrepo.FlgSit, 'A,P') > 0,     /* Aprobado y x Aprobar */ */
/*     EACH Almdrepo OF Almcrepo NO-LOCK WHERE Almdrepo.codmat = pCodMat      */
/*     AND almdrepo.CanApro > almdrepo.CanAten:                               */
/*     pComprometido = pComprometido + (Almdrepo.CanApro - Almdrepo.CanAten). */
/* END.                                                                       */

/* G/R por Transferencia en Tránsito */
FOR EACH Almdmov USE-INDEX Almd02 NO-LOCK WHERE Almdmov.codcia = s-codcia
    AND Almdmov.fchdoc >= TODAY - 7
    AND Almdmov.codmat = pCodMat
    AND Almdmov.tipmov = "S"
    AND Almdmov.codmov = 03,
    FIRST Almcmov OF Almdmov NO-LOCK:
    IF Almcmov.flgest <> "A" AND Almcmov.flgsit = "T" AND Almcmov.almdes = pCodAlm 
        THEN DO:
        pComprometido = pComprometido + Almdmov.candes.
    END.
END.

/* POR ORDENES DE TRANSFERENCIA */
FOR EACH Facdpedi USE-INDEX Llave02 NO-LOCK WHERE Facdpedi.codcia = s-codcia
    AND Facdpedi.codmat = pCodMat
    AND Facdpedi.coddoc = 'STR'     /* Solicitud de Transferencia */
    AND Facdpedi.flgest = 'P':
    FIND FIRST Faccpedi OF Facdpedi NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Faccpedi OR NOT (Faccpedi.flgest = 'P' AND Faccpedi.codcli = pCodAlm)
        THEN NEXT.
    /* CHequeamos que la R/A NO esté pendientes */
    FIND FIRST Almcrepo WHERE Almcrepo.codcia = s-codcia
        AND Almcrepo.codalm = Faccpedi.codcli
        AND Almcrepo.nroser = INTEGER(SUBSTRING(Faccpedi.nroref,1,3))
        AND Almcrepo.nrodoc = INTEGER(SUBSTRING(Faccpedi.nroref,4))
        AND Almcrepo.flgest = "M"   /* Lo han cerrado manualmente */
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almcrepo THEN NEXT.

    pComprometido = pComprometido + FacDPedi.Factor * (FacDPedi.CanPed - FacDPedi.CanAte).
END.
FOR EACH Facdpedi USE-INDEX Llave02 NO-LOCK WHERE Facdpedi.codcia = s-codcia
    AND Facdpedi.codmat = pCodMat
    AND Facdpedi.coddoc = 'OTR'     /* Orden de Transferencia */
    AND Facdpedi.flgest = 'P':
    FIND FIRST Faccpedi OF Facdpedi NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Faccpedi OR NOT (Faccpedi.flgest = 'P' AND Faccpedi.codcli = pCodAlm)
        THEN NEXT.
    pComprometido = pComprometido + FacDPedi.Factor * (FacDPedi.CanPed - FacDPedi.CanAte).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


