&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : registroventas.p
    Purpose     : Genera un registro en la tabla wmigrv

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       : SOLO COMPROBANTES QUE MODIFICAN STOCK
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF INPUT PARAMETER pRowid AS ROWID.
DEF INPUT PARAMETER pTipo AS CHAR.


DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR cb-codcia AS INT.

FIND Ccbcdocu WHERE ROWID(Ccbcdocu) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE Ccbcdocu THEN RETURN.

IF LOOKUP(pTipo, 'I,D') = 0 THEN RETURN.

IF LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL,TCK') = 0 THEN RETURN.
IF Ccbcdocu.imptot <= 0 THEN RETURN.
IF Ccbcdocu.fchdoc = ? THEN RETURN.
IF LOOKUP(CcbCdocu.TpoFac, 'A,S') > 0 THEN RETURN.
IF Ccbcdocu.flgest = "A" THEN RETURN.

FIND gn-clie WHERE gn-clie.codcia = cl-codcia
    AND gn-clie.codcli = ccbcdocu.codcli
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-clie THEN RETURN.

FIND cb-cfgg WHERE cb-cfgg.CodCia = cb-codcia 
    AND cb-cfgg.Codcfg = 'R02' NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-cfgg THEN RETURN.

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
         HEIGHT             = 5.04
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF VAR x-codcta AS CHAR.
DEF VAR x-codigv AS CHAR.
DEF VAR x-ctadto AS CHAR.
DEF VAR x-ctaisc AS CHAR.
DEF VAR x-ctaigv AS CHAR.
DEF VAR x-fchvto AS DATE.
DEF VAR x-secuencia AS INT.

DEF VAR lwCorre AS CHARACTER.

FIND TabDistr WHERE TabDistr.CodDepto = gn-clie.coddep
    AND TabDistr.CodProvi = gn-clie.codprov
    AND TabDistr.CodDistr = gn-clie.coddist
    NO-LOCK NO-ERROR.

FIND FIRST Facdocum OF Ccbcdocu NO-LOCK NO-ERROR.

FIND Cb-cfgrv WHERE Cb-cfgrv.Codcia = Ccbcdocu.Codcia 
    AND Cb-cfgrv.CodDiv = Ccbcdocu.Coddiv 
    AND Cb-cfgrv.Coddoc = Ccbcdocu.Coddoc 
    AND Cb-cfgrv.Fmapgo = Ccbcdocu.Fmapgo 
    AND Cb-cfgrv.Codmon = Ccbcdocu.Codmon 
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Cb-cfgrv OR Cb-cfgrv.Codcta = "" 
    THEN x-codcta = (IF ccbcdocu.codmon = 1 THEN FacDocum.CodCta[1] ELSE FacDocum.CodCta[2]).
    ELSE x-codcta = Cb-cfgrv.codcta.

ASSIGN
    x-ctaisc = cb-cfgg.codcta[2] 
    x-ctaigv = cb-cfgg.codcta[3]
    x-ctadto = cb-cfgg.codcta[10]
    x-fchvto = (IF ccbcdocu.fchvto < ccbcdocu.fchdoc THEN ccbcdocu.fchdoc ELSE ccbcdocu.fchvto).

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETRY ON STOP UNDO, RETRY:
    /* BLOQUEAMOS Sí o Sí el correlativo */
    FIND wmigcorr WHERE wmigcorr.Proceso = "RV"
        AND wmigcorr.Periodo = YEAR(Ccbcdocu.fchdoc)
        AND wmigcorr.Mes = MONTH(Ccbcdocu.fchdoc)
        EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF NOT AVAILABLE wmigcorr THEN DO:
        IF NOT LOCKED wmigcorr THEN DO:
            /* CREAMOS EL CONTROL */
            CREATE wmigcorr.
            ASSIGN
                wmigcorr.Correlativo = 1
                wmigcorr.Mes = MONTH(Ccbcdocu.fchdoc)
                wmigcorr.Periodo = YEAR(Ccbcdocu.fchdoc)
                wmigcorr.Proceso = "RV".
        END.
        ELSE UNDO, RETRY.
    END.
    /* Barremos el detalle */
    x-Secuencia = 1.
    FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK:
        CREATE wmigdventas.
        ASSIGN
            wmigdventas.FlagFecha = DATETIME(TODAY, MTIME)
            wmigdventas.FlagTipo = pTipo
            wmigdventas.FlagUsuario = s-user-id
            lwcorre = STRING(wmigcorr.Periodo, '9999') + STRING(wmigcorr.Mes, '99') + 
                    STRING(wmigcorr.Correlativo, '999999').
        ASSIGN
            lwCorre = SUBSTRING(lwCorre,3).
        ASSIGN
            wmigdventas.correlativo = lwCorre
            wmigdventas.secuencia = x-secuencia
            x-secuencia = x-secuencia + 1.
        ASSIGN
            wmigdventas.CodRef = Ccbcdocu.codref
            wmigdventas.PtoRef = INTEGER(SUBSTRING(Ccbcdocu.nroref,1,3))
            wmigdventas.FchRef = YEAR(Ccbcdocu.fchdoc) * 10000 + MONTH(Ccbcdocu.fchdoc) * 100 + DAY(Ccbcdocu.fchdoc)
            wmigdventas.HorRef = INTEGER(REPLACE(CcbCDocu.HorCie, ':', ''))
            wmigdventas.CodVen = Ccbcdocu.codven
            wmigdventas.CodCli = (IF gn-clie.codant = '' THEN SUBSTRING(gn-clie.codcli,1,10) ELSE gn-clie.codant)
            wmigdventas.NomRef = Ccbcdocu.nomcli
            wmigdventas.FmaPgo = Ccbcdocu.fmapgo.
        /* IMPORTES */
        IF Ccbcdocu.codmon = 1 THEN
            ASSIGN
            wmigdventas.ValVtaAfeMn = Ccbcdocu.ImpVta
            wmigdventas.ValVtaInaMn = Ccbcdocu.ImpExo
            wmigdventas.ImpDto1Mn = Ccbcdocu.ImpDto
            wmigdventas.ImpDto2Mn = 0
            wmigdventas.ImpIgvMn = Ccbcdocu.ImpIgv
            wmigdventas.ImpImp2Mn = 0
            wmigdventas.ImpImp3Mn = 0
            wmigdventas.PreVtaMn = Ccbcdocu.ImpTot.
        ELSE ASSIGN
            wmigdventas.ValVtaAfeMe = Ccbcdocu.ImpVta
            wmigdventas.ValVtaInaMe = Ccbcdocu.ImpExo
            wmigdventas.ImpDto1Me = Ccbcdocu.ImpDto
            wmigdventas.ImpDto2Me = 0
            wmigdventas.ImpIgvMe = Ccbcdocu.ImpIgv
            wmigdventas.ImpImp2Me = 0
            wmigdventas.ImpImp3Me = 0
            /*wmigdventas.PreVtaMe = Ccbcdocu.ImpTot*/.
        CASE ccbcdocu.coddoc:
            WHEN 'FAC' THEN wmigdventas.coddoc = "FC".
            WHEN 'BOL' THEN wmigdventas.coddoc = "BV".
            WHEN 'TCK' THEN wmigdventas.coddoc = "TK".
            WHEN 'LET' THEN wmigdventas.coddoc = "LT".
            WHEN 'N/C' THEN wmigdventas.coddoc = "NC".
            WHEN 'N/D' THEN wmigdventas.coddoc = "ND".
            WHEN 'CHQ' THEN wmigdventas.coddoc = "CD".
        END CASE.
        ASSIGN
            wmigdventas.LugEnt = Ccbcdocu.lugent
            wmigdventas.RucCli = Ccbcdocu.ruccli
            wmigdventas.Distrito = ''
            wmigdventas.DocIde = (IF ccbcdocu.codcli BEGINS '2' THEN "RU" ELSE "")
            wmigdventas.NroIde = (IF ccbcdocu.codcli BEGINS '2' THEN gn-clie.ruc ELSE SUBSTRING(gn-clie.codcli, 3, 8)).
        ASSIGN
            wmigdventas.NomCli = SUBSTRING (gn-clie.nomcli, 1, 40)
            wmigdventas.DirCli = (IF gn-clie.dircli <> '' THEN SUBSTRING (gn-clie.dircli, 1, 40) ELSE 'LIMA')
            wmigdventas.DistrCli = (IF AVAILABLE TabDistr THEN SUBSTRING (TabDistr.NomDistr, 1, 40) ELSE 'LIMA')
            wmigdventas.TpoCli = (IF ccbcdocu.codcli BEGINS '2' THEN "PJ" ELSE "NI").
        ASSIGN
            wmigdventas.codmon = (IF ccbcdocu.codmon = 1 THEN 00 ELSE 01)
            wmigdventas.ref4   = Ccbcdocu.nroref.
        IF SUBSTRING(gn-clie.codcli,1,10) = "1111111111" THEN wmigdventas.codcli = "VARIOS".
        /* COMIENZA EL DETALLE */
        ASSIGN
            wmigdventas.CodAlm = ccbddocu.almdes
            wmigdventas.TipDoc = wmigdventas.coddoc
            wmigdventas.SerFacBol = INTEGER(SUBSTRING(Ccbcdocu.nrodoc,1,3))
            wmigdventas.NroFacBol = INTEGER(SUBSTRING(Ccbcdocu.nrodoc,3))
            wmigdventas.FchFac = YEAR(Ccbcdocu.fchdoc) * 10000 + MONTH(Ccbcdocu.fchdoc) * 100 + DAY(Ccbcdocu.fchdoc)
            wmigdventas.HorFac = INTEGER(REPLACE(CcbCDocu.HorCie, ':', ''))
            wmigdventas.CodMat = Ccbddocu.codmat
            wmigdventas.CanDes = Ccbddocu.candes
            wmigdventas.Factor = Ccbddocu.factor
            wmigdventas.PreUni = Ccbddocu.preuni.
        IF Ccbcdocu.codmon = 1 THEN
            ASSIGN
            wmigdventas.LinImpDto1Mn = Ccbddocu.impdto
            wmigdventas.LinImpDto2Mn = 0
            wmigdventas.LinImpIgvMn = Ccbddocu.impigv
            wmigdventas.LinImpImp2Mn = 0
            wmigdventas.LinImpImp3Mn = 0
            wmigdventas.LinImpLinMn = Ccbddocu.implin
            wmigdventas.LinValVtaAfeMn = (IF Ccbddocu.aftigv = YES THEN Ccbddocu.implin - Ccbddocu.impigv ELSE 0)
            wmigdventas.LinValVtaInaMn = (IF Ccbddocu.aftigv = NO THEN Ccbddocu.implin ELSE 0).
        IF Ccbcdocu.codmon = 2 THEN
            ASSIGN
            wmigdventas.LinImpDto1Me = Ccbddocu.impdto
            wmigdventas.LinImpDto2Me = 0
            wmigdventas.LinImpIgvMe = Ccbddocu.impigv
            wmigdventas.LinImpImp2Me = 0
            wmigdventas.LinImpImp3Me = 0
            wmigdventas.LinImpLinMe = Ccbddocu.implin
            wmigdventas.LinValVtaAfeMe = (IF Ccbddocu.aftigv = YES THEN Ccbddocu.implin - Ccbddocu.impigv ELSE 0)
            wmigdventas.LinValVtaInaMe = (IF Ccbddocu.aftigv = NO THEN Ccbddocu.implin ELSE 0).
        ASSIGN
            wmigdventas.LinPorDto = STRING(TRUNCATE(CcbDDocu.Por_Dsctos[1] * 100, 0), '99999') +
                                    STRING(TRUNCATE(CcbDDocu.Por_Dsctos[3] * 100, 0), '99999').
    END.
    ASSIGN
        wmigcorr.Correlativo = wmigcorr.Correlativo +  1.
    IF AVAILABLE(wmigcorr) THEN RELEASE wmigcorr.
    IF AVAILABLE(wmigdventas)   THEN RELEASE wmigdventas.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


