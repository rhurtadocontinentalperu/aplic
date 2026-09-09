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
DEF BUFFER CDOCU FOR Ccbcdocu.

/* GENERAMOS CONTROL DE PERCEPCIONES POR COMPROBANTES (PRC) */
DEF INPUT PARAMETER pRowid AS ROWID.

/* ********************************************************************* */
/* ******************************** FILTROS **************************** */
/* ********************************************************************* */
FIND Ccbcdocu WHERE ROWID(Ccbcdocu) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE Ccbcdocu THEN RETURN.
IF LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL,TCK') = 0 THEN RETURN.
IF Ccbcdocu.flgest = "A" THEN RETURN.
IF LOOKUP(CcbCdocu.TpoFac, 'A,S') > 0 THEN RETURN.
/*IF LOOKUP(Ccbcdocu.fmapgo, '000,001,002') > 0 THEN RETURN.*/
FIND FIRST CDOCU WHERE CDOCU.codcia = Ccbcdocu.codcia
    AND CDOCU.coddiv = Ccbcdocu.coddiv
    AND CDOCU.coddoc = "PRC"
    AND CDOCU.codref = Ccbcdocu.coddoc
    AND CDOCU.nroref = Ccbcdocu.nrodoc
    NO-LOCK NO-ERROR.
IF AVAILABLE CDOCU THEN RETURN.
/* Acumulamos las percepciones */
DEF VAR x-ImpTot LIKE Ccbcdocu.imptot NO-UNDO.
x-ImpTot = 0.
FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK:
    x-ImpTot = x-ImpTot + CcbDDocu.ImpDcto_Adelanto[5].
END.
IF x-ImpTot <= 0 THEN RETURN.
/* Verificamos control de correlativos */
DEF VAR s-coddoc AS CHAR INIT "PRC" NO-UNDO.
FIND FIRST Faccorre WHERE FacCorre.CodCia = Ccbcdocu.codcia
    AND FacCorre.CodDiv = Ccbcdocu.coddiv
    AND FacCorre.CodDoc = s-coddoc
    AND FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccorre THEN DO:
    MESSAGE 'NO existe el control de correlativos para el documento' s-coddoc SKIP
        'Para la división' Ccbcdocu.coddiv
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
/* ********************************************************************* */

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
         HEIGHT             = 4.5
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEF VAR x-NroDoc AS INT NO-UNDO.

DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    FIND CURRENT Faccorre EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'Correlativo del documento' s-coddoc 'bloqueado por otro usuario'
            VIEW-AS ALERT-BOX ERROR.
        RETURN ERROR.
    END.
    ASSIGN
        x-NroDoc = Faccorre.correlativo.
    REPEAT:
        IF NOT CAN-FIND(FIRST CDOCU WHERE CDOCU.codcia = Ccbcdocu.codcia
                        AND CDOCU.coddiv = Ccbcdocu.coddiv
                        AND CDOCU.coddoc = s-coddoc
                        AND CDOCU.nrodoc = STRING(Faccorre.nroser, '999') + STRING(x-NroDoc, '999999')
                        NO-LOCK)
            THEN LEAVE.
        x-NroDoc = x-NroDoc + 1.
    END.
    CREATE CDOCU.
    ASSIGN
        CDOCU.codcia = Ccbcdocu.codcia
        CDOCU.coddiv = Ccbcdocu.coddiv
        CDOCU.coddoc = s-coddoc
        CDOCU.nrodoc = STRING(Faccorre.nroser, '999') + STRING(x-NroDoc, '999999')
        CDOCU.tipo   = Ccbcdocu.tipo        /* CREDITO o MOSTRADOR */
        CDOCU.codref = Ccbcdocu.coddoc
        CDOCU.nroref = Ccbcdocu.nrodoc
        CDOCU.fchdoc = Ccbcdocu.fchdoc
        CDOCU.fchvto = Ccbcdocu.fchdoc
        CDOCU.codcli = Ccbcdocu.codcli
        CDOCU.nomcli = Ccbcdocu.nomcli
        CDOCU.usuario = Ccbcdocu.usuario
        CDOCU.imptot = x-ImpTot
        CDOCU.sdoact = x-ImpTot
        CDOCU.flgest = "X".     /* En trámite */
    ASSIGN
        Faccorre.correlativo = x-NroDoc + 1.
    RELEASE CDOCU.
    RELEASE faccorre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


