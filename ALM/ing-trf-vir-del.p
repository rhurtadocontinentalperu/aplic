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
         HEIGHT             = 4
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
DEF BUFFER DMOV FOR Almdmov.

DEF VAR R-ROWID AS ROWID NO-UNDO.

DEF SHARED VAR s-user-id AS CHAR.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND Almcmov WHERE ROWID(Almcmov) = pRowid NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almcmov THEN RETURN 'ADM-ERROR'.
    /* Cabecera */
    r-Rowid = ?.
    FOR EACH CMOV USE-INDEX Almc04 WHERE CMOV.codcia = Almcmov.codcia
        AND CMOV.codalm = pCodAlm
        AND CMOV.tipmov = "I"
        AND CMOV.codmov = Almcmov.codmov
        AND CMOV.nroser = 000
        AND CMOV.almdes = Almcmov.codalm
        BY CMOV.FchDoc DESC:
        IF INTEGER(SUBSTRING(CMOV.NroRf1,1,3)) = Almcmov.NroSer
            AND INTEGER(SUBSTRING(CMOV.NroRf1,4)) = Almcmov.NroDoc 
            THEN DO:
            r-Rowid = ROWID(CMOV).
            LEAVE.
        END.
    END.
    IF r-Rowid = ? THEN DO:
        MESSAGE 'No se ha podido eliminar el ingreso por transferencia del almacén' pCodAlm SKIP
            'Proceso abortado' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    FIND CMOV WHERE ROWID(CMOV) = r-Rowid EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:                                                              
        MESSAGE 'No se ha podido eliminar el ingreso por transferencia del almacén' pCodAlm SKIP 
            'Proceso abortado' VIEW-AS ALERT-BOX ERROR.                                         
        RETURN 'ADM-ERROR'.                                                                     
    END.                                                                                        

    ASSIGN 
        CMOV.FlgEst = 'A'
        CMOV.Observ = "      A   N   U   L   A   D   O       "
        CMOV.Usuario = S-USER-ID.
    FOR EACH DMOV OF CMOV:
        ASSIGN R-ROWID = ROWID(DMOV).
        RUN ALM\ALMDCSTK (R-ROWID).   /* Descarga del Almacen POR INGRESOS */
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        /* RHC 03.04.04 REACTIVAMOS KARDEX POR ALMACEN */
        RUN alm/almacpr1 (R-ROWID, 'D').
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        DELETE DMOV.
    END.
    RELEASE CMOV.
    RELEASE DMOV.
    IF AVAILABLE(Almmmate) THEN RELEASE Almmmate.
END.
RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


