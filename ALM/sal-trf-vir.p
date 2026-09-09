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
         HEIGHT             = 3.81
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEF INPUT PARAMETER pRowid AS ROWID.
DEF INPUT PARAMETER pCodAlm AS CHAR.

/* RHC 23/10/2012 RUTINA ELIMINADA */
RETURN "OK".
/* ******************************* */

DEF BUFFER CMOV FOR Almcmov.
DEF BUFFER ITEM FOR Almdmov.

DEF VAR R-ROWID AS ROWID NO-UNDO.
DEF VAR x-Item AS INT NO-UNDO.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-codcia AS INT.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND CMOV WHERE ROWID(CMOV) = pRowid NO-LOCK NO-ERROR.
    IF NOT AVAILABLE CMOV THEN RETURN 'ADM-ERROR'.

    /* Buscamos el correlativo de almacenes */
    FIND Almacen WHERE Almacen.CodCia = CMOV.codcia
        AND Almacen.CodAlm = pCodAlm 
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Almacen THEN DO: 
        MESSAGE 'NO se pudo bloquer el correlativo por almacén' pCodAlm VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    CREATE Almcmov.
    ASSIGN 
        Almcmov.CodCia = CMOV.CodCia 
        Almcmov.CodAlm = pCodAlm 
        Almcmov.AlmDes = CMOV.CodAlm
        Almcmov.TipMov = "S"
        Almcmov.CodMov = CMOV.CodMov
        Almcmov.FlgSit = "R"      /* Recepcionado */
        Almcmov.FchDoc = TODAY
        Almcmov.HorSal = STRING(TIME,"HH:MM")
        Almcmov.HraDoc = STRING(TIME,"HH:MM")
        Almcmov.NroSer = 000
        Almcmov.NroDoc = Almacen.CorrSal
        Almcmov.NroRf1 = STRING(CMOV.NroSer,"999") + STRING(CMOV.NroDoc)
        Almacen.CorrSal = Almacen.CorrSal + 1
        Almcmov.usuario = S-USER-ID.

    FOR EACH ITEM OF CMOV NO-LOCK BY ITEM.NroItm:
        CREATE almdmov.
        ASSIGN Almdmov.CodCia = Almcmov.CodCia 
               Almdmov.CodAlm = Almcmov.CodAlm 
               Almdmov.TipMov = Almcmov.TipMov 
               Almdmov.CodMov = Almcmov.CodMov 
               Almdmov.NroSer = Almcmov.NroSer
               Almdmov.NroDoc = Almcmov.NroDoc 
               Almdmov.CodMon = Almcmov.CodMon 
               Almdmov.FchDoc = Almcmov.FchDoc 
               Almdmov.HraDoc = Almcmov.HraDoc
               Almdmov.TpoCmb = Almcmov.TpoCmb
               Almdmov.codmat = ITEM.codmat
               Almdmov.CanDes = ITEM.CanDes
               Almdmov.CodUnd = ITEM.CodUnd
               Almdmov.Factor = ITEM.Factor
               Almdmov.ImpCto = ITEM.ImpCto
               Almdmov.PreUni = ITEM.PreUni
               Almdmov.AlmOri = Almcmov.AlmDes 
               Almdmov.CodAjt = ''
               Almdmov.HraDoc = Almcmov.HorSal
               Almdmov.NroItm = x-Item
               R-ROWID = ROWID(Almdmov).
        x-Item = x-Item + 1.
        RUN alm/almdcstk (R-ROWID).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        RUN alm/almacpr1 (R-ROWID, "U").
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    END.
END.
RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


