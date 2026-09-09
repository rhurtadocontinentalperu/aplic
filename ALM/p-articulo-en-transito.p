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
    Notes       : 16/12/2024 Optimización de queries
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


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-addToTmpTabla) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addToTmpTabla Procedure 
FUNCTION addToTmpTabla RETURNS LOGICAL
  ( INPUT pCodAlm AS CHAR,
    INPUT pCodDoc AS CHAR,
    INPUT pNroPed AS CHAR,
    INPUT pCodDiv AS CHAR,
    INPUT pFchPed AS DATE,
    INPUT pCodMat AS CHAR,
    INPUT pCanPed AS DEC
    )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


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
         HEIGHT             = 7.73
         WIDTH              = 53.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
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
DEF VAR k AS INT NO-UNDO.
DEF VAR LocalFecha AS DATE NO-UNDO.
DEF VAR x-Fecha AS DATE NO-UNDO.
DEF VAR pDesde AS DATE NO-UNDO.

LocalFecha = ADD-INTERVAL(TODAY, -1, 'month').
x-Fecha = ADD-INTERVAL(TODAY, -60, 'days').
pDesde = ADD-INTERVAL(TODAY, -1, 'month').


/* Procesar Almdrepo */
DO k = 1 TO NUM-ENTRIES(LocalTipMov):
    FOR EACH Almdrepo NO-LOCK WHERE Almdrepo.codcia = s-codcia AND
            Almdrepo.codmat = s-codmat AND
            Almdrepo.flgest = "P" AND
            Almdrepo.codalm = s-codalm AND
            Almdrepo.tipmov = ENTRY(k, LocalTipMov),
        FIRST Almcrepo OF Almdrepo NO-LOCK WHERE Almcrepo.flgest = 'P',
        FIRST Almacen NO-LOCK WHERE Almacen.codcia = s-codcia AND Almacen.codalm = Almcrepo.almped:
        addToTmpTabla(Almcrepo.AlmPed, 
                      "REP", 
                      STRING(Almcrepo.nroser, '999') + STRING(Almcrepo.nrodoc, '999999999'), 
                      Almacen.CodDiv, 
                      Almcrepo.FchDoc, 
                      s-CodMat, 
                      (Almdrepo.CanApro - Almdrepo.CanAten)).
    END.
END.

/* Procesar Almdmov */
FOR EACH Almdmov NO-LOCK WHERE Almdmov.codcia = s-codcia
    AND Almdmov.codmat = s-CodMat
    AND Almdmov.fchdoc >= LocalFecha
    AND Almdmov.tipmov = "S"
    AND Almdmov.codmov = 03,
    FIRST Almcmov OF Almdmov NO-LOCK,
    FIRST Almacen OF Almdmov NO-LOCK:

    IF Almcmov.flgest = 'A' OR Almcmov.flgsit <> 'T' THEN NEXT.
    IF Almcmov.CrossDocking = NO AND Almcmov.AlmDes <> s-CodAlm THEN NEXT.
    IF Almcmov.CrossDocking = YES AND Almcmov.AlmacenXD <> s-CodAlm THEN NEXT.

    addToTmpTabla(Almdmov.CodAlm, 
                  "TRF", 
                  STRING(Almcmov.nroser, '999') + STRING(Almcmov.nrodoc, '999999999'), 
                  Almacen.CodDiv, 
                  Almdmov.FchDoc, 
                  s-CodMat, 
                  Almdmov.CanDes).
END.

/* Procesar Facdpedi */
FOR EACH Facdpedi NO-LOCK WHERE Facdpedi.codcia = s-codcia
    AND Facdpedi.codmat = s-CodMat
    AND Facdpedi.coddoc = 'OTR'
    AND Facdpedi.flgest = 'P'
    AND Facdpedi.fchped >= x-Fecha,
    FIRST Faccpedi OF Facdpedi NO-LOCK WHERE Faccpedi.flgest = 'P':

    IF (Faccpedi.CrossDocking = NO AND NOT (Faccpedi.flgest = 'P' AND Faccpedi.CodCli = s-CodAlm)) OR
       (Faccpedi.CrossDocking = YES AND NOT (Faccpedi.flgest = 'P' AND Faccpedi.AlmacenXD = s-CodAlm)) THEN NEXT.

    addToTmpTabla(Faccpedi.CodAlm, 
                  Faccpedi.coddoc, 
                  Faccpedi.nroped, 
                  Faccpedi.CodDiv, 
                  Faccpedi.FchPed, 
                  s-CodMat, 
                  FacDPedi.Factor * (FacDPedi.CanPed - FacDPedi.CanAte)).
END.

/* Procesar OOMoviAlmacen */
FOR EACH OOMoviAlmacen NO-LOCK WHERE OOMoviAlmacen.codcia = s-codcia        
    AND OOMoviAlmacen.FlagMigracion = "N"
    AND OOMoviAlmacen.FchDoc >= pDesde
    AND OOMoviAlmacen.CodAlm = s-CodAlm
    AND OOMoviAlmacen.TipMov = "I" 
    AND OOMoviAlmacen.CodMov = 03 
    AND OOMoviAlmacen.CodMat = s-CodMat,
    FIRST Almacen NO-LOCK WHERE Almacen.codcia = s-CodCia AND Almacen.codalm = OOMoviAlmacen.AlmOri:

    addToTmpTabla(OOMoviAlmacen.CodAlm, 
                  "SLOTING", 
                  STRING(OOMoviAlmacen.nroser, '999') + STRING(OOMoviAlmacen.nrodoc, '999999999'), 
                  Almacen.CodDiv, 
                  OOMoviAlmacen.FchDoc, 
                  s-CodMat, 
                  OOMoviAlmacen.CanDes).
END.

RUN addForCodMov (90).
RUN addForCodMov (09).
RUN addForCodMov (30).


/* FOR EACH OOMoviAlmacen NO-LOCK WHERE OOMoviAlmacen.codcia = s-codcia                                 */
/*     AND OOMoviAlmacen.FlagMigracion = "N"                                                            */
/*     AND OOMoviAlmacen.FchDoc >= pDesde                                                               */
/*     AND OOMoviAlmacen.CodAlm = s-CodAlm                                                              */
/*     AND OOMoviAlmacen.TipMov = "I"                                                                   */
/*     AND (OOMoviAlmacen.CodMov = 90                                                                   */
/*         OR OOMoviAlmacen.CodMov = 09                                                                 */
/*         OR OOMoviAlmacen.CodMov = 30)                                                                */
/*     AND OOMoviAlmacen.CodMat = s-CodMat,                                                             */
/*     FIRST Almacen NO-LOCK WHERE Almacen.codcia = s-CodCia AND Almacen.codalm = OOMoviAlmacen.CodAlm: */
/*                                                                                                      */
/*     IF OOMoviAlmacen.UseInDropShipment <> "NO" THEN NEXT.                                            */
/*                                                                                                      */
/*     addToTmpTabla(OOMoviAlmacen.CodAlm,                                                              */
/*                   "SLOTING",                                                                         */
/*                   STRING(OOMoviAlmacen.nroser, '999') + STRING(OOMoviAlmacen.nrodoc, '999999999'),   */
/*                   Almacen.CodDiv,                                                                    */
/*                   OOMoviAlmacen.FchDoc,                                                              */
/*                   s-CodMat,                                                                          */
/*                   OOMoviAlmacen.CanDes).                                                             */
/* END.                                                                                                 */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-addForCodMov) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addForCodMov Procedure 
PROCEDURE addForCodMov :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pCodMov LIKE OOMoviAlmacen.CodMov NO-UNDO.

FOR EACH OOMoviAlmacen NO-LOCK WHERE OOMoviAlmacen.codcia = s-codcia        
    AND OOMoviAlmacen.FlagMigracion = "N"
    AND OOMoviAlmacen.FchDoc >= pDesde
    AND OOMoviAlmacen.CodAlm = s-CodAlm
    AND OOMoviAlmacen.TipMov = "I" 
    AND OOMoviAlmacen.CodMov = pCodMov
    AND OOMoviAlmacen.CodMat = s-CodMat,
    FIRST Almacen NO-LOCK WHERE Almacen.codcia = s-CodCia AND Almacen.codalm = OOMoviAlmacen.CodAlm:

    IF OOMoviAlmacen.UseInDropShipment <> "NO" THEN NEXT.

    addToTmpTabla(OOMoviAlmacen.CodAlm, 
                  "SLOTING", 
                  STRING(OOMoviAlmacen.nroser, '999') + STRING(OOMoviAlmacen.nrodoc, '999999999'), 
                  Almacen.CodDiv, 
                  OOMoviAlmacen.FchDoc, 
                  s-CodMat, 
                  OOMoviAlmacen.CanDes).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-addToTmpTabla) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addToTmpTabla Procedure 
FUNCTION addToTmpTabla RETURNS LOGICAL
  ( INPUT pCodAlm AS CHAR,
    INPUT pCodDoc AS CHAR,
    INPUT pNroPed AS CHAR,
    INPUT pCodDiv AS CHAR,
    INPUT pFchPed AS DATE,
    INPUT pCodMat AS CHAR,
    INPUT pCanPed AS DEC
    ) :

/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FIND FIRST tmp-tabla WHERE t-CodDoc = pCodDoc AND t-NroPed = pNroPed NO-LOCK NO-ERROR NO-WAIT.
    IF NOT AVAIL tmp-tabla THEN DO:
        CREATE tmp-tabla.
        ASSIGN
            t-CodAlm = pCodAlm
            t-CodDoc = pCodDoc
            t-NroPed = pNroPed
            t-CodDiv = pCodDiv
            t-FchPed = pFchPed
            t-codmat = pCodMat
            t-CanPed = pCanPed.
        x-Total = x-Total + pCanPed.
        RETURN TRUE.
    END.
    RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

