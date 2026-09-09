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
         HEIGHT             = 3.96
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEF INPUT PARAMETER pRowid AS ROWID.
DEF INPUT PARAMETER pCodAlm AS CHAR.


/* RHC 23/10/2012 BLOQUEAMOS ESTA RUTINA */
RETURN "OK".
/* ************************************* */

DEF BUFFER CMOV FOR Almcmov.
DEF BUFFER ITEM FOR Almdmov.

DEF VAR R-ROWID AS ROWID NO-UNDO.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND CMOV WHERE ROWID(CMOV) = pRowid NO-LOCK NO-ERROR.
    IF NOT AVAILABLE CMOV THEN RETURN 'ADM-ERROR'.
    /* Cabecera */
    FIND Almtdocm WHERE
          Almtdocm.CodCia = CMOV.codcia AND
          Almtdocm.CodAlm = pCodAlm AND
          Almtdocm.TipMov = "I" AND
          Almtdocm.CodMov = CMOV.codmov
          EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'No se ha configurado el movimiento de transferencia para el almacén' pCodAlm SKIP
            'Grabación abortada' VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    CREATE Almcmov.
    ASSIGN
        Almcmov.NroDoc  = Almtdocm.NroDoc
        Almtdocm.NroDoc = Almtdocm.NroDoc + 1
        Almcmov.CodCia  = Almtdocm.CodCia 
        Almcmov.CodAlm  = Almtdocm.CodAlm 
        Almcmov.TipMov  = Almtdocm.TipMov 
        Almcmov.CodMov  = Almtdocm.CodMov 
        Almcmov.NroSer  = 000
        Almcmov.FlgSit  = ""
        Almcmov.FchDoc  = CMOV.FchDoc
        Almcmov.AlmDes  = CMOV.codalm
        Almcmov.HorRcp  = STRING(TIME,"HH:MM:SS")
        Almcmov.NomRef  = ''
        /*Almcmov.Nrorf1  = STRING(CMOV.NroSer,"999") + STRING(CMOV.NroDoc,"9999999")*/
        Almcmov.Nrorf1  = STRING(CMOV.NroSer,"999") + STRING(CMOV.NroDoc)
        Almcmov.Nrorf2  = CMOV.nrorf1
        Almcmov.Nrorf3  = STRING(CMOV.Nrorf3,"999") + STRING(CMOV.NroDoc,"9999999")
        Almcmov.FlgSit  = "*".      /* MARCA ESPECIAL */
    FOR EACH ITEM OF CMOV NO-LOCK:
        FIND Almmmate WHERE Almmmate.codcia = Almcmov.codcia
            AND Almmmate.codmat = ITEM.codmat
            AND Almmmate.codalm = Almcmov.CodAlm
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmate THEN DO:
            MESSAGE 'El producto' ITEM.codmat 'no está asignado al almacén' pCodAlm SKIP
                'Grabación abortada' VIEW-AS ALERT-BOX ERROR.
            UNDO, RETURN 'ADM-ERROR'.
        END.
        CREATE almdmov.
        ASSIGN 
            Almdmov.CodCia = Almcmov.CodCia 
            Almdmov.CodAlm = Almcmov.CodAlm 
            Almdmov.TipMov = Almcmov.TipMov 
            Almdmov.CodMov = Almcmov.CodMov 
            Almdmov.NroSer = Almcmov.NroSer 
            Almdmov.NroDoc = Almcmov.NroDoc 
            Almdmov.CodMon = Almcmov.CodMon 
            Almdmov.FchDoc = Almcmov.FchDoc 
            Almdmov.TpoCmb = Almcmov.TpoCmb 
            Almdmov.codmat = ITEM.codmat 
            Almdmov.CanDes = ITEM.CanDes 
            Almdmov.CodUnd = ITEM.CodUnd 
            Almdmov.Factor = ITEM.Factor 
            Almdmov.ImpCto = ITEM.ImpCto 
            Almdmov.PreUni = ITEM.PreUni 
            Almdmov.AlmOri = Almcmov.AlmDes 
            Almdmov.CodAjt = '' 
            Almdmov.HraDoc = Almcmov.HorRcp
            R-ROWID = ROWID(Almdmov).
        RUN ALM\ALMACSTK (R-ROWID).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        RUN alm/almacpr1 (R-ROWID, 'U').
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    END.
    RELEASE Almtdocm.
    RELEASE Almcmov.
    RELEASE Almdmov.
END.
RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


