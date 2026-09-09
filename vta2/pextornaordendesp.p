&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CMOV FOR Almcmov.
DEFINE BUFFER CMOV FOR Almcmov.



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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF INPUT PARAMETER pRowid AS ROWID.

/* Verificamos */
FIND Almcmov WHERE ROWID(Almcmov) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almcmov THEN RETURN.
IF Almcmov.CrossDocking = NO THEN RETURN.

DEF VAR I-MOVORI AS INT INIT 03 NO-UNDO.

/* Verificamos que sea la última guia con la misma referencia */
DEF VAR x-CodRef AS CHAR NO-UNDO.
DEF VAR x-NroRef AS CHAR NO-UNDO.

FIND CMOV WHERE CMOV.CodCia = Almcmov.CodCia 
    AND  CMOV.CodAlm = Almcmov.AlmDes 
    AND  CMOV.TipMov = "S" 
    AND  CMOV.CodMov = I-MOVORI 
    AND  CMOV.NroSer = INTEGER(SUBSTRING(Almcmov.NroRf1,1,3)) 
    AND  CMOV.NroDoc = INTEGER(SUBSTRING(Almcmov.NroRf1,4)) 
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE CMOV THEN RETURN.
ASSIGN
    x-CodRef = CMOV.CodRef      /* OTR del origen */
    x-NroRef = CMOV.NroRef.
/* Buscamos la OTR base y capturamos su R/A de referencia */
FIND Faccpedi WHERE Faccpedi.codcia = s-codcia
    AND Faccpedi.coddoc = CMOV.codref
    AND Faccpedi.nroped = CMOV.nroref
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccpedi THEN RETURN.

FOR EACH CMOV NO-LOCK WHERE CMOV.codcia = s-codcia
    AND CMOV.CodAlm = Almcmov.AlmDes    /* El almacén de origen */
    AND CMOV.TipMov = "S" 
    AND CMOV.CodMov = I-MOVORI 
    AND CMOV.CodRef = x-CodRef          /* Referencia OTR */
    AND CMOV.NroRef = x-NroRef
    AND CMOV.FlgEst <> "A"
    AND CMOV.FlgSit = "R":               /* Aún está recepcionado */
    IF CMOV.NroSer = INTEGER(SUBSTRING(Almcmov.NroRf1,1,3)) 
        AND CMOV.NroDoc = INTEGER(SUBSTRING(Almcmov.NroRf1,4)) 
        THEN NEXT.      /* NO se toma en cuenta el mismo movimiento */
    /* Si hay un movimiento que aún no ha sido anulado entonces no extorno nada */
    RETURN.     
END.
/* Capturamos R/A origen */
ASSIGN
    x-CodRef = Faccpedi.codref      /* R/A o PED origen */
    x-NroRef = Faccpedi.nroref.

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
   Temp-Tables and Buffers:
      TABLE: B-CMOV B "?" ? INTEGRAL Almcmov
      TABLE: CMOV B "?" ? INTEGRAL Almcmov
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 4.08
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* La OTR migrada */
    FOR EACH Faccpedi EXCLUSIVE-LOCK WHERE Faccpedi.codcia = s-codcia
        AND Faccpedi.coddiv = s-coddiv
        AND LOOKUP(Faccpedi.coddoc, "OTR,O/D") > 0
        AND Faccpedi.codref = x-CodRef
        AND Faccpedi.nroref = x-NroRef:
        FOR EACH Vtaddocu EXCLUSIVE-LOCK WHERE VtaDDocu.CodCia = Faccpedi.codcia
            AND VtaDDocu.CodDiv = Faccpedi.coddiv
            AND VtaDDocu.CodPed = Faccpedi.coddoc
            AND VtaDDocu.NroPed = Faccpedi.nroped:
            DELETE VtaDDocu.
        END.
        FOR EACH Ccbcbult EXCLUSIVE-LOCK WHERE CcbCBult.CodCia = Faccpedi.codcia
            AND CcbCBult.CodDiv = Faccpedi.coddiv
            AND CcbCBult.CodDoc = Faccpedi.coddoc
            AND CcbCBult.NroDoc = Faccpedi.nroped:
            DELETE CcbCBult.
        END.
        FOR EACH ControlOD EXCLUSIVE-LOCK WHERE ControlOD.CodCia = Faccpedi.codcia
            AND ControlOD.CodDiv = Faccpedi.coddiv
            AND ControlOD.CodDoc = Faccpedi.coddoc
            AND ControlOD.NroDoc = Faccpedi.nroped:
            DELETE ControlOD.
        END.
        Faccpedi.FlgEst = "A".
        FacCPedi.FecAct = TODAY.
        FacCPedi.HorAct = STRING(TIME, 'HH:MM:SS').
        FacCPedi.UsrAct = s-user-id.
    END.
    IF AVAILABLE(Faccpedi) THEN RELEASE Faccpedi.
    IF AVAILABLE(Vtaddocu) THEN RELEASE Vtaddocu.
    IF AVAILABLE(Ccbcbult) THEN RELEASE Ccbcbult.
    IF AVAILABLE(ControlOD) THEN RELEASE ControlOD.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


