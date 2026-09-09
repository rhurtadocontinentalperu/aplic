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

DEF INPUT PARAMETER pRowid AS ROWID.

DEF SHARED VAR s-user-id AS CHAR.

FIND Faccpedi WHERE ROWID(Faccpedi) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccpedi THEN RETURN.

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
         HEIGHT             = 3.88
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEF VAR r-Rowid AS ROWID NO-UNDO.

DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    /* Extornamos Salidas x Transferencias */
    FOR EACH Almcmov WHERE Almcmov.codcia = Faccpedi.codcia
        AND Almcmov.codref = Faccpedi.coddoc
        AND Almcmov.nroref = Faccpedi.nroped
        AND Almcmov.tipmov = "S"
        AND Almcmov.flgest <> 'A':
        FOR EACH Almdmov WHERE Almdmov.CodCia = Almcmov.CodCia 
            AND  Almdmov.CodAlm = Almcmov.CodAlm 
            AND  Almdmov.TipMov = Almcmov.TipMov 
            AND  Almdmov.CodMov = Almcmov.CodMov 
            AND  Almdmov.NroSer = Almcmov.NroSer 
            AND  Almdmov.NroDoc = Almcmov.NroDoc :
            ASSIGN R-ROWID = ROWID(Almdmov).
            RUN alm/almacstk (R-ROWID).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN ERROR.
            /* RHC 30.03.04 REACTIVAMOS RUTINA */
            RUN alm/almacpr1 (R-ROWID, "D").
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN ERROR.
            DELETE Almdmov.
        END.
        ASSIGN 
            Almcmov.FlgEst = 'A'
            Almcmov.Observ = "      A   N   U   L   A   D   O       "
            Almcmov.usuario = S-USER-ID
            Almcmov.FchAnu = TODAY.
    END.
    /* Extornamos Ingresos x Transferencias */
    FOR EACH Almcmov WHERE Almcmov.codcia = Faccpedi.codcia
        AND Almcmov.codref = Faccpedi.coddoc
        AND Almcmov.nroref = Faccpedi.nroped
        AND Almcmov.tipmov = "I"
        AND Almcmov.flgest <> 'A':
        FOR EACH Almdmov WHERE Almdmov.CodCia = Almcmov.CodCia 
            AND  Almdmov.CodAlm = Almcmov.CodAlm 
            AND  Almdmov.TipMov = Almcmov.TipMov 
            AND  Almdmov.CodMov = Almcmov.CodMov 
            AND  Almdmov.NroSer = Almcmov.NroSer 
            AND  Almdmov.NroDoc = Almcmov.NroDoc :
            ASSIGN R-ROWID = ROWID(Almdmov).
            RUN ALM\ALMDCSTK (R-ROWID).   /* Descarga del Almacen POR INGRESOS */
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN ERROR.
            /*
            RUN ALM\ALMACPR1 (R-ROWID,"D").
            RUN ALM\ALMACPR2 (R-ROWID,"D").
            */
            /* RHC 03.04.04 REACTIVAMOS KARDEX POR ALMACEN */
            RUN alm/almacpr1 (R-ROWID, 'D').
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN ERROR.
            DELETE Almdmov.
        END.
        ASSIGN 
            Almcmov.FlgEst = 'A'
            Almcmov.Observ = "      A   N   U   L   A   D   O       "
            Almcmov.usuario = S-USER-ID
            Almcmov.FchAnu = TODAY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


