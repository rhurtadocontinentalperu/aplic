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
DEFINE TEMP-TABLE tmp-tabla NO-UNDO
    FIELD t-CodAlm LIKE Almacen.codalm  FORMAT 'x(3)'
    FIELD t-CodDoc LIKE FacDPedi.CodDoc FORMAT "XXX"
    FIELD t-Nroped LIKE FacDPedi.NroPed FORMAT "XXX-XXXXXXXX"
    FIELD t-CodDiv LIKE FacCPedi.CodDiv FORMAT 'x(5)'
    FIELD t-FchPed LIKE FacDPedi.FchPed
    FIELD t-NomCli LIKE FacCPedi.NomCli COLUMN-LABEL "Cliente" FORMAT "x(35)"
    FIELD t-CodMat LIKE FacDPedi.codmat
    FIELD t-Canped LIKE FacDPedi.CanPed
    INDEX t-CodDoc t-NroPed.

DEFINE INPUT PARAMETER s-codcia AS INT.
DEFINE INPUT PARAMETER s-codalm AS CHAR.
DEFINE INPUT PARAMETER s-codmat AS CHAR.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tmp-tabla.
DEFINE OUTPUT PARAMETER x-Total AS DEC.

x-Total = 0.
EMPTY TEMP-TABLE tmp-tabla.
DEF VAR LocalTipMov AS CHAR INIT 'A,M' NO-UNDO.
/*
FOR EACH Almdrepo USE-INDEX Llave03 NO-LOCK WHERE Almdrepo.codcia = s-CodCia
    AND Almdrepo.codmat = s-CodMat
    AND Almdrepo.codalm = s-CodAlm,
*/
FOR EACH Almdrepo USE-INDEX Llave03 NO-LOCK WHERE Almdrepo.codcia = s-CodCia
    AND Almdrepo.codalm = s-CodAlm
    AND LOOKUP(Almdrepo.TipMov,LocalTipMov) = 0
    AND Almdrepo.codmat = s-CodMat,
    FIRST Almcrepo OF Almdrepo NO-LOCK WHERE Almcrepo.flgest = 'P',
    FIRST Almacen NO-LOCK WHERE Almacen.codcia = s-codcia AND Almacen.codalm = Almcrepo.almped:
    IF NOT (almdrepo.CanApro > almdrepo.CanAten) THEN NEXT.
    /*IF NOT LOOKUP(Almdrepo.TipMov,LocalTipMov) > 0 THEN NEXT.*/
    FIND FIRST tmp-tabla WHERE t-CodDoc = "REP"
        AND t-NroPed = STRING(Almcrepo.nroser, '999') + STRING(Almcrepo.nrodoc, '999999999')
        NO-LOCK NO-ERROR.
    IF NOT AVAIL tmp-tabla THEN DO:
        CREATE tmp-tabla.
        ASSIGN
            t-CodAlm = Almcrepo.AlmPed
            t-CodDoc = "REP"
            t-NroPed = STRING(Almcrepo.nroser, '999') + STRING(Almcrepo.nrodoc, '999999999')
            t-CodDiv = Almacen.CodDiv
            t-FchPed = Almcrepo.FchDoc
            t-codmat = s-CodMat
            t-CanPed = (Almdrepo.CanApro - Almdrepo.CanAten).
        x-Total = x-Total + t-CanPed.
    END.
END.

/* G/R por Transferencia en Tránsito */
DEF VAR LocalFecha AS DATE NO-UNDO.
LocalFecha = TODAY - 30.
/*IF CAN-FIND(FIRST Almdmov WHERE Almdmov.codcia = s-codcia
    AND Almdmov.codmat = s-CodMat
    AND Almdmov.fchdoc >= LocalFecha
    AND Almdmov.tipmov = "S"
    AND Almdmov.codmov = 03 NO-LOCK) THEN DO:
*/
    FOR EACH Almdmov NO-LOCK WHERE Almdmov.codcia = s-codcia
        AND Almdmov.codmat = s-CodMat
        AND Almdmov.fchdoc >= LocalFecha
        AND Almdmov.tipmov = "S"
        AND Almdmov.codmov = 03,
        FIRST Almcmov OF Almdmov NO-LOCK,
        FIRST Almacen OF Almcmov NO-LOCK:
        IF Almcmov.flgest = 'A' THEN NEXT.
        IF Almcmov.flgsit <> 'T' THEN NEXT.
        IF Almcmov.CrossDocking = NO  AND Almcmov.AlmDes    <> s-CodAlm THEN NEXT.
        IF Almcmov.CrossDocking = YES AND Almcmov.AlmacenXD <> s-CodAlm THEN NEXT.
        FIND FIRST tmp-tabla WHERE t-CodDoc = "TRF"
            AND  t-NroPed = STRING(Almcmov.nroser, '999') + STRING(Almcmov.nrodoc, '999999999')
            NO-LOCK NO-ERROR.
        IF NOT AVAIL tmp-tabla THEN DO:
            CREATE tmp-tabla.
            ASSIGN
                t-CodAlm = Almdmov.CodAlm
                t-CodDoc = "TRF"
                t-NroPed = STRING(Almcmov.nroser, '999') + STRING(Almcmov.nrodoc, '999999999')
                t-CodDiv = Almacen.CodDiv
                t-FchPed = Almdmov.FchDoc
                t-codmat = s-CodMat
                t-CanPed = Almdmov.CanDes.
            x-Total = x-Total + t-CanPed.
        END.
    END.

/*END.*/

FOR EACH Facdpedi NO-LOCK WHERE Facdpedi.codcia = s-codcia
    AND Facdpedi.codmat = s-CodMat
    AND Facdpedi.coddoc = 'OTR'     /* Orden de Transferencia */
    AND Facdpedi.flgest = 'P',
    FIRST Faccpedi OF Facdpedi NO-LOCK WHERE Faccpedi.flgest = 'P':
    CASE TRUE:
        WHEN Faccpedi.CrossDocking = NO  THEN DO:
            IF NOT (Faccpedi.flgest = 'P' AND Faccpedi.CodCli = s-CodAlm) THEN NEXT.
        END.
        WHEN Faccpedi.CrossDocking = YES THEN DO:
            IF NOT (Faccpedi.flgest = 'P' AND Faccpedi.AlmacenXD = s-CodAlm) THEN NEXT.
        END.
    END CASE.
    FIND FIRST tmp-tabla WHERE t-CodDoc = Faccpedi.coddoc AND 
        t-NroPed = Faccpedi.nroped NO-LOCK NO-ERROR.
    IF NOT AVAIL tmp-tabla THEN DO:
        CREATE tmp-tabla.
        ASSIGN 
            t-CodAlm = Faccpedi.CodAlm
            t-CodDoc = Faccpedi.CodDoc
            t-NroPed = Faccpedi.NroPed
            t-CodDiv = Faccpedi.CodDiv
            t-FchPed = Faccpedi.FchPed
            t-codmat = s-CodMat
            t-CanPed = FacDPedi.Factor * (FacDPedi.CanPed - FacDPedi.CanAte).
        x-Total = x-Total + t-CanPed.
    END.
END.

/* RHC 14/06/2019 SLOTING */
/* FOR EACH OOMoviAlmacen NO-LOCK WHERE OOMoviAlmacen.CodCia = s-CodCia AND                             */
/*     OOMoviAlmacen.FlagMigracion = "N" AND                                                            */
/*     OOMoviAlmacen.CodAlm = s-CodAlm AND                                                              */
/*     OOMoviAlmacen.TipMov = "I" AND                                                                   */
/*     OOMoviAlmacen.CodMov = 03 AND                                                                    */
/*     OOMoviAlmacen.codmat = s-CodMat,                                                                 */
/*     FIRST Almacen NO-LOCK WHERE Almacen.codcia = s-CodCia AND                                        */
/*     Almacen.codalm = OOMoviAlmacen.AlmOri:                                                           */
/*     FIND FIRST tmp-tabla WHERE t-CodDoc = "SLOTING"                                                  */
/*         AND t-NroPed = STRING(OOMoviAlmacen.nroser, '999') + STRING(OOMoviAlmacen.nrodoc, '9999999') */
/*         NO-LOCK NO-ERROR.                                                                            */
/*     IF NOT AVAIL tmp-tabla THEN DO:                                                                  */
/*         CREATE tmp-tabla.                                                                            */
/*         ASSIGN                                                                                       */
/*             t-CodAlm = OOMoviAlmacen.CodAlm                                                          */
/*             t-CodDoc = "SLOTING"                                                                     */
/*             t-NroPed = STRING(OOMoviAlmacen.nroser, '999') + STRING(OOMoviAlmacen.nrodoc, '9999999') */
/*             t-CodDiv = Almacen.CodDiv                                                                */
/*             t-FchPed = OOMoviAlmacen.FchDoc                                                          */
/*             t-codmat = s-CodMat                                                                      */
/*             t-CanPed = OOMoviAlmacen.CanDes.                                                         */
/*         x-Total = x-Total + t-CanPed.                                                                */
/*     END.                                                                                             */
/* END.                                                                                                 */

/* ********************************************************************************************************* */
/* RHC 16/06/2021 Sloting */
/* ********************************************************************************************************* */
/*
FOR EACH OOMoviAlmacen NO-LOCK WHERE OOMoviAlmacen.codcia = s-codcia
    AND OOMoviAlmacen.FlagMigracion = "N" 
    AND OOMoviAlmacen.CodAlm = s-CodAlm
    AND OOMoviAlmacen.TipMov = "I" 
    AND OOMoviAlmacen.CodMov = 03
    AND OOMoviAlmacen.CodMat = s-CodMat,
    FIRST Almacen NO-LOCK WHERE Almacen.codcia = s-CodCia AND
    Almacen.codalm = OOMoviAlmacen.AlmOri:
*/
FOR EACH OOMoviAlmacen NO-LOCK WHERE OOMoviAlmacen.codcia = s-codcia        
    AND OOMoviAlmacen.CodAlm = s-CodAlm
    AND OOMoviAlmacen.TipMov = "I" 
    AND OOMoviAlmacen.CodMov = 03
    AND OOMoviAlmacen.FlagMigracion = "N"
    AND OOMoviAlmacen.CodMat = s-CodMat,    
    FIRST Almacen NO-LOCK WHERE Almacen.codcia = s-CodCia AND
    Almacen.codalm = OOMoviAlmacen.AlmOri:
    CREATE tmp-tabla.
    ASSIGN
        t-CodAlm = OOMoviAlmacen.CodAlm
        t-CodDoc = "SLOTING"
        t-NroPed = STRING(OOMoviAlmacen.nroser, '999') + STRING(OOMoviAlmacen.nrodoc, '999999999')
        t-CodDiv = Almacen.CodDiv
        t-FchPed = OOMoviAlmacen.FchDoc
        t-codmat = s-CodMat
        t-CanPed = OOMoviAlmacen.CanDes.
    x-Total = x-Total + t-CanPed.
END.
/*
FOR EACH OOMoviAlmacen NO-LOCK WHERE OOMoviAlmacen.codcia = s-codcia
    AND OOMoviAlmacen.FlagMigracion = "N" 
    AND OOMoviAlmacen.CodAlm = s-CodAlm
    AND OOMoviAlmacen.FchDoc >= DATE(06,01,2019) 
    AND OOMoviAlmacen.TipMov = "I" 
    AND OOMoviAlmacen.CodMov = 90
    AND OOMoviAlmacen.CodMat = s-CodMat
    AND OOMoviAlmacen.UseInDropShipment = "NO",
    FIRST Almacen NO-LOCK WHERE Almacen.codcia = s-CodCia AND
    Almacen.codalm = OOMoviAlmacen.CodAlm:
*/
FOR EACH OOMoviAlmacen NO-LOCK WHERE OOMoviAlmacen.codcia = s-codcia        
    AND OOMoviAlmacen.CodAlm = s-CodAlm    
    AND OOMoviAlmacen.TipMov = "I" 
    AND OOMoviAlmacen.CodMov = 90    
    AND OOMoviAlmacen.FlagMigracion = "N" 
    AND OOMoviAlmacen.CodMat = s-CodMat    
    AND OOMoviAlmacen.FchDoc >= DATE(06,01,2019) 
    AND OOMoviAlmacen.UseInDropShipment = "NO",
    FIRST Almacen NO-LOCK WHERE Almacen.codcia = s-CodCia AND
    Almacen.codalm = OOMoviAlmacen.CodAlm:

    CREATE tmp-tabla.
    ASSIGN
        t-CodAlm = OOMoviAlmacen.CodAlm
        t-CodDoc = "SLOTING"
        t-NroPed = STRING(OOMoviAlmacen.nroser, '999') + STRING(OOMoviAlmacen.nrodoc, '999999999')
        t-CodDiv = Almacen.CodDiv
        t-FchPed = OOMoviAlmacen.FchDoc
        t-codmat = s-CodMat
        t-CanPed = OOMoviAlmacen.CanDes.
    x-Total = x-Total + t-CanPed.
END.
/*
FOR EACH OOMoviAlmacen NO-LOCK WHERE OOMoviAlmacen.codcia = s-codcia
    AND OOMoviAlmacen.FlagMigracion = "N" 
    AND OOMoviAlmacen.CodAlm = s-CodAlm
    AND OOMoviAlmacen.TipMov = "I" 
    AND (OOMoviAlmacen.CodMov = 09 OR OOMoviAlmacen.CodMov = 30)
    AND OOMoviAlmacen.CodMat = s-CodMat
    AND OOMoviAlmacen.UseInDropShipment = "NO",
    FIRST Almacen NO-LOCK WHERE Almacen.codcia = s-CodCia AND
    Almacen.codalm = OOMoviAlmacen.CodAlm:
*/    
FOR EACH OOMoviAlmacen NO-LOCK WHERE OOMoviAlmacen.codcia = s-codcia        
    AND OOMoviAlmacen.CodAlm = s-CodAlm
    AND OOMoviAlmacen.TipMov = "I" 
    /*AND (OOMoviAlmacen.CodMov = 09 OR OOMoviAlmacen.CodMov = 30)*/
    AND OOMoviAlmacen.CodMov = 09    
    AND OOMoviAlmacen.FlagMigracion = "N" 
    AND OOMoviAlmacen.CodMat = s-CodMat    
    AND OOMoviAlmacen.UseInDropShipment = "NO",
    FIRST Almacen NO-LOCK WHERE Almacen.codcia = s-CodCia AND
    Almacen.codalm = OOMoviAlmacen.CodAlm:

    CREATE tmp-tabla.
    ASSIGN
        t-CodAlm = OOMoviAlmacen.CodAlm
        t-CodDoc = "SLOTING"
        t-NroPed = STRING(OOMoviAlmacen.nroser, '999') + STRING(OOMoviAlmacen.nrodoc, '999999999')
        t-CodDiv = Almacen.CodDiv
        t-FchPed = OOMoviAlmacen.FchDoc
        t-codmat = s-CodMat
        t-CanPed = OOMoviAlmacen.CanDes.
    x-Total = x-Total + t-CanPed.
END.

FOR EACH OOMoviAlmacen NO-LOCK WHERE OOMoviAlmacen.codcia = s-codcia        
    AND OOMoviAlmacen.CodAlm = s-CodAlm
    AND OOMoviAlmacen.TipMov = "I" 
    AND OOMoviAlmacen.CodMov = 30    
    AND OOMoviAlmacen.FlagMigracion = "N" 
    AND OOMoviAlmacen.CodMat = s-CodMat    
    AND OOMoviAlmacen.UseInDropShipment = "NO",
    FIRST Almacen NO-LOCK WHERE Almacen.codcia = s-CodCia AND
    Almacen.codalm = OOMoviAlmacen.CodAlm:

    CREATE tmp-tabla.
    ASSIGN
        t-CodAlm = OOMoviAlmacen.CodAlm
        t-CodDoc = "SLOTING"
        t-NroPed = STRING(OOMoviAlmacen.nroser, '999') + STRING(OOMoviAlmacen.nrodoc, '999999999')
        t-CodDiv = Almacen.CodDiv
        t-FchPed = OOMoviAlmacen.FchDoc
        t-codmat = s-CodMat
        t-CanPed = OOMoviAlmacen.CanDes.
    x-Total = x-Total + t-CanPed.
END.

/* ********************************************************************************************************* */
/* ********************************************************************************************************* */

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
         HEIGHT             = 4.24
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


