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
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF INPUT PARAMETER pRowid AS ROWID.
DEF INPUT PARAMETER pTipo AS CHAR.
DEF INPUT PARAMETER pConti AS LOGICAL.

DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR cb-codcia AS INT.

FIND Ccbcdocu WHERE ROWID(Ccbcdocu) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE Ccbcdocu THEN RETURN.

IF LOOKUP(pTipo, 'I,D') = 0 THEN RETURN.

IF LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL,N/C,N/D') = 0 THEN RETURN.
IF Ccbcdocu.imptot < 0 THEN RETURN.
IF Ccbcdocu.fchdoc = ? THEN RETURN.
IF Ccbcdocu.Tipo = "MOSTRADOR" THEN RETURN. /* Por compatibilidad */
IF Ccbcdocu.TpoFac = "CO" THEN RETURN.      /* Nueva version */

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

IF pConti = YES THEN DO :
    /*MESSAGE 'CONTI' VIEW-AS ALERT-BOX ERROR.*/
    RUN proc_conti.
END.
ELSE DO:
    /*MESSAGE 'CISSAC' VIEW-AS ALERT-BOX ERROR.*/
    RUN proc_cissac.
END.
         


/*{aplic/sypsa/carga-fac-bol-credito.i}.*/

/*
DEF VAR x-codcta AS CHAR.
DEF VAR x-codigv AS CHAR.
DEF VAR x-ctadto AS CHAR.
DEF VAR x-ctaisc AS CHAR.
DEF VAR x-ctaigv AS CHAR.
DEF VAR x-fchvto AS DATE.

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
    CREATE WMIGRV.
    ASSIGN
        wmigrv.FlagFecha = DATETIME(TODAY, MTIME)
        wmigrv.FlagTipo = pTipo
        wmigrv.FlagUsuario = s-user-id.

    /* Iman 26 Jul 2012 */
    lwcorre = STRING(wmigcorr.Periodo, '9999') + STRING(wmigcorr.Mes, '99') + 
                    STRING(wmigcorr.Correlativo, '999999').
    lwCorre = SUBSTRING(lwCorre,3).
    /* Iman 26 Kul 2012 */

    ASSIGN
        /* Iman 26 Jul 2012 */
        wmigrv.wcorre = lwCorre
        /* Iman 26 Jul 2012 */
        wmigrv.wsecue = 0001
        wmigrv.wvejer = YEAR(ccbcdocu.fchdoc)
        wmigrv.wvperi = MONTH(ccbcdocu.fchdoc).
    CASE ccbcdocu.coddoc:
        WHEN 'FAC' THEN wmigrv.wvtdoc = "FC".
        WHEN 'BOL' THEN wmigrv.wvtdoc = "BV".
        WHEN 'TCK' THEN wmigrv.wvtdoc = "TK".
        WHEN 'LET' THEN wmigrv.wvtdoc = "LT".
        WHEN 'N/C' THEN wmigrv.wvtdoc = "NC".
        WHEN 'N/D' THEN wmigrv.wvtdoc = "ND".
        WHEN 'CHQ' THEN wmigrv.wvtdoc = "CD".
    END CASE.
    ASSIGN
        wmigrv.wvndoc = ccbcdocu.nrodoc
        wmigrv.wvfech = YEAR(ccbcdocu.fchdoc) * 10000 + MONTH(ccbcdocu.fchdoc) * 100 + DAY(ccbcdocu.fchdoc)
        wmigrv.wvccli = (IF gn-clie.codant = '' THEN SUBSTRING(gn-clie.codcli,1,10) ELSE gn-clie.codant)
        wmigrv.wvclie = SUBSTRING (gn-clie.nomcli, 1, 40)
        wmigrv.wvcdir = (IF gn-clie.dircli <> '' THEN SUBSTRING (gn-clie.dircli, 1, 40) ELSE 'LIMA')
        wmigrv.wvcdis = (IF AVAILABLE TabDistr THEN SUBSTRING (TabDistr.NomDistr, 1, 40) ELSE 'LIMA')
        wmigrv.wvref3 = (IF ccbcdocu.codcli BEGINS '2' THEN "PJ" ELSE "NI")
        wmigrv.wvtido = (IF ccbcdocu.codcli BEGINS '2' THEN "RU" ELSE "")
        wmigrv.wvnudo = (IF ccbcdocu.codcli BEGINS '2' THEN gn-clie.ruc ELSE SUBSTRING(gn-clie.codcli, 3, 8))
        /*wmigrv.wvref2*/
        wmigrv.wvmone = (IF ccbcdocu.codmon = 1 THEN 00 ELSE 01)
        wmigrv.wvtcam = 0.00.            /* ccbcdocu.tpocmb. */

    /* Iman 26 Jul 2012 */
    IF  SUBSTRING(gn-clie.codcli,1,10) = "1111111111" THEN DO:
        ASSIGN wmigrv.wvclie = "VARIOS".
    END.
    /* Iman 26 Jul 2012 */

    /* RHC 03/08/2012 DOCUMENTOS ANULADOS */
    IF Ccbcdocu.flgest = "A" THEN DO:       /* ANULADO */
        ASSIGN
            WMIGRV.wvfepr = YEAR(TODAY) * 10000 + MONTH(TODAY) * 100 + DAY(TODAY)
            WMIGRV.wvfeve = YEAR(x-fchvto) * 10000 + MONTH(x-fchvto) * 100 + DAY(x-fchvto)
            WMIGRV.wvruc = ccbcdocu.ruccli
            WMIGRV.wvndom = (IF WMIGRV.wvruc = '' THEN "N" ELSE (IF WMIGRV.wvref3 = "PJ" THEN "S" ELSE "N"))
            WMIGRV.wvcpag = "888"         /* ccbcdocu.fmapgo */
            WMIGRV.wvsitu = "99"        /* ANULADO */
            WMIGRV.wvcost = "9999999"
            WMIGRV.wvcven = ccbcdocu.codven
            WMIGRV.wvacti = ccbcdocu.coddiv
            WMIGRV.wvnbco = ''  /* ver ticketeras */
            WMIGRV.wvusin = STRING(ccbcdocu.usuario,"x(10)")
            WMIGRV.wvfein = YEAR(TODAY) * 10000 + MONTH(TODAY) * 100 + DAY(TODAY).
        ASSIGN
            wmigcorr.Correlativo = wmigcorr.Correlativo +  1.
        IF AVAILABLE(wmigcorr) THEN RELEASE wmigcorr.
        IF AVAILABLE(wmigrv)   THEN RELEASE wmigrv.
        LEAVE PRINCIPAL.
    END.
    /* ********************************** */
    IF ccbcdocu.impbrt > 0 
        THEN ASSIGN
                wmigrv.wvvalv = CcbCDocu.ImpBrt
                wmigrv.wvcval = cb-cfgg.codcta[5]
                wmigrv.wvmval = (IF ccbcdocu.coddoc = "N/C" THEN "C" ELSE "A").
    IF ccbcdocu.impexo > 0 
        THEN ASSIGN
                wmigrv.wvvali = ccbcdocu.impexo
                wmigrv.wvcvai = cb-cfgg.codcta[6]
                wmigrv.wvmvai = ( IF ccbcdocu.coddoc = "N/C" THEN "C" ELSE "A" ).
    IF ccbcdocu.impdto > 0 
        THEN ASSIGN
                wmigrv.wvdsct = ccbcdocu.impdto
                wmigrv.wvcdsc = x-ctadto
                wmigrv.wvmdsc = (IF ccbcdocu.coddoc = "N/C" THEN "A" ELSE "C").
    IF ccbcdocu.impigv > 0 
        THEN ASSIGN
                wmigrv.wvigv = ccbcdocu.impigv
                wmigrv.wvcigv = x-ctaigv
                wmigrv.wvmigv = (IF ccbcdocu.coddoc = "N/C" THEN "C" ELSE "A").
    ASSIGN
        wmigrv.wvpvta = ccbcdocu.imptot
        wmigrv.wvcpvt = x-codcta
        wmigrv.wvmpvt = (IF ccbcdocu.coddoc = "N/C" THEN "A" ELSE "C").
    IF ccbcdocu.coddoc = 'N/C' OR ccbcdocu.coddoc = 'N/D' THEN DO:
        CASE ccbcdocu.codref:
            WHEN 'FAC' THEN wmigrv.wvtref = "FC".
            WHEN 'BOL' THEN wmigrv.wvtref = "BV".
            WHEN 'TCK' THEN wmigrv.wvtref = "TK".
            WHEN 'LET' THEN wmigrv.wvtref = "LT".
            WHEN 'N/C' THEN wmigrv.wvtref = "NC".
            WHEN 'N/D' THEN wmigrv.wvtref = "ND".
            WHEN 'CHQ' THEN wmigrv.wvtref = "CD".
        END CASE.
        ASSIGN
            wmigrv.wvnref = ccbcdocu.nroref.
    END.
    ELSE DO:
        IF Ccbcdocu.codped = "PED" 
            THEN ASSIGN
                    wmigrv.wvtref = "PD"
                    wmigrv.wvnref = Ccbcdocu.nroped.
    END.
    ASSIGN
        wmigrv.wvfepr = YEAR(TODAY) * 10000 + MONTH(TODAY) * 100 + DAY(TODAY)
        wmigrv.wvfeve = YEAR(x-fchvto) * 10000 + MONTH(x-fchvto) * 100 + DAY(x-fchvto)
        wmigrv.wvruc = ccbcdocu.ruccli
        wmigrv.wvndom = (IF wmigrv.wvruc = '' THEN "N" ELSE (IF wmigrv.wvref3 = "PJ" THEN "S" ELSE "N"))
        wmigrv.wvcpag = ccbcdocu.fmapgo
        wmigrv.wvsitu = "02"        /* Graba en Cuentas por Cobrar */
        wmigrv.wvcost = "9999999"
        wmigrv.wvcven = ccbcdocu.codven
        wmigrv.wvacti = ccbcdocu.coddiv
        wmigrv.wvnbco = ''  /* ver ticketeras */
        wmigrv.wvusin = string(ccbcdocu.usuario,"X(10)")
        wmigrv.wvfein = YEAR(TODAY) * 10000 + MONTH(TODAY) * 100 + DAY(TODAY).
    IF Ccbcdocu.FmaPgo = "900"      /* Trasnferencia Gratuita */
        THEN ASSIGN
                wmigrv.wvsitu = "01"
                wmigrv.wvcpag = "999".
    ASSIGN
        wmigcorr.Correlativo = wmigcorr.Correlativo +  1.
    IF AVAILABLE(wmigcorr) THEN RELEASE wmigcorr.
    IF AVAILABLE(wmigrv)   THEN RELEASE wmigrv.
END.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-proc_cissac) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_cissac Procedure 
PROCEDURE proc_cissac :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
{aplic/sypsa/carga-fac-bol-credito-cissac.i}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-proc_conti) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_conti Procedure 
PROCEDURE proc_conti :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{aplic/sypsa/carga-fac-bol-credito.i}.
              
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

