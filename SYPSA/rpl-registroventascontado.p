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

/* RHC 17/07/2012 SE VA A HACER MEDIANTE UN BATCH EN LINUX */
RETURN.
/* ******************************************************* */

DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR cb-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.

FIND Ccbcierr WHERE ROWID(Ccbcierr) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE Ccbcierr THEN RETURN.

IF LOOKUP(pTipo, 'I,D') = 0 THEN RETURN.

DEFINE TEMP-TABLE t-wmigrv LIKE wmigrv.

FIND cb-cfgg WHERE cb-cfgg.CodCia = cb-codcia 
    AND cb-cfgg.Codcfg = 'R02' NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-cfgg THEN DO:
    MESSAGE 'NO está configurado las cuentas R02' SKIP
        'Proceso abortado'
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.

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


/* BARREMOS los I/C por MOSTRADOR */
EMPTY TEMP-TABLE t-wmigrv.
FOR EACH Ccbccaja NO-LOCK WHERE Ccbccaja.codcia = Ccbcierr.codcia
        AND Ccbccaja.flgcie = "C"
        AND Ccbccaja.fchcie = Ccbcierr.fchcie
        AND Ccbccaja.horcie = Ccbcierr.horcie
        AND Ccbccaja.usuario = Ccbcierr.usuario
        AND Ccbccaja.tipo = "MOSTRADOR"
        AND Ccbccaja.flgest <> "A",
        EACH Ccbdcaja OF Ccbccaja NO-LOCK,
        FIRST Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = Ccbdcaja.codcia
        AND Ccbcdocu.coddiv = Ccbccaja.coddiv
        AND Ccbcdocu.coddoc = Ccbdcaja.codref
        AND Ccbcdocu.nrodoc = Ccbdcaja.nroref,
        FIRST Facdocum OF Ccbcdocu NO-LOCK,
        FIRST gn-clie NO-LOCK WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = ccbcdocu.codcli:
    /* FILTRO DEL DOCUMENTO */
    IF LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL,TCK') = 0 THEN NEXT.
    IF LOOKUP(Ccbcdocu.coddoc, 'BOL,TCK') > 0 AND Ccbcdocu.flgest = "A" THEN NEXT.
    IF Ccbcdocu.imptot <= 0 THEN NEXT.
    IF Ccbcdocu.fchdoc = ? THEN NEXT.
    IF Ccbcdocu.fchdoc < 07/01/2012 THEN NEXT.
    IF Ccbcdocu.Tipo <> "MOSTRADOR" THEN NEXT.
    /* FIN DE FILTRO */
    RUN Carga-FAC-BOL.
END.

RUN Transferir-Asiento.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Carga-FAC-BOL) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-FAC-BOL Procedure 
PROCEDURE Carga-FAC-BOL :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-codcta AS CHAR.
DEF VAR x-codigv AS CHAR.
DEF VAR x-ctadto AS CHAR.
DEF VAR x-ctaisc AS CHAR.
DEF VAR x-ctaigv AS CHAR.
DEF VAR x-fchvto AS DATE.
DEF VAR x-coddoc AS CHAR.
DEF VAR x-nrodoc AS CHAR.
DEF VAR x-codcli AS CHAR.
DEF VAR x-codmon AS INT.
DEF VAR x-fchdoc AS INT.

DEFINE VAR x-detalle AS LOGICAL NO-UNDO.
DEFINE VAR x-cco     AS CHAR    NO-UNDO.

FIND TabDistr WHERE TabDistr.CodDepto = gn-clie.coddep
    AND TabDistr.CodProvi = gn-clie.codprov
    AND TabDistr.CodDistr = gn-clie.coddist
    NO-LOCK NO-ERROR.
FIND Cb-cfgrv WHERE Cb-cfgrv.Codcia = Ccbcdocu.Codcia 
    AND Cb-cfgrv.CodDiv = Ccbcdocu.Coddiv 
    AND Cb-cfgrv.Coddoc = Ccbcdocu.Coddoc 
    AND Cb-cfgrv.Fmapgo = Ccbcdocu.Fmapgo 
    AND Cb-cfgrv.Codmon = Ccbcdocu.Codmon 
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Cb-cfgrv OR Cb-cfgrv.Codcta = "" 
    THEN ASSIGN
            x-detalle = YES
            x-codcta = (IF ccbcdocu.codmon = 1 THEN FacDocum.CodCta[1] ELSE FacDocum.CodCta[2]).
    ELSE ASSIGN
            x-detalle = Cb-cfgrv.Detalle
            x-codcta = Cb-cfgrv.codcta.
ASSIGN
    x-ctaisc = cb-cfgg.codcta[2] 
    x-ctaigv = cb-cfgg.codcta[3]
    x-ctadto = cb-cfgg.codcta[10]
    x-fchvto = (IF ccbcdocu.fchvto < ccbcdocu.fchdoc THEN ccbcdocu.fchdoc ELSE ccbcdocu.fchvto)
    x-coddoc = Ccbcdocu.coddoc
    x-nrodoc = Ccbcdocu.nrodoc
    x-codcli = Ccbcdocu.codcli
    x-codmon = (IF ccbcdocu.codmon = 1 THEN 00 ELSE 01)
    x-fchdoc = YEAR(ccbcdocu.fchdoc) * 10000 + MONTH(ccbcdocu.fchdoc) * 100 + DAY(ccbcdocu.fchdoc).
CASE ccbcdocu.coddoc:
    WHEN 'FAC' THEN x-coddoc = "FC".
    WHEN 'BOL' THEN x-coddoc = "BV".
    WHEN 'TCK' THEN x-coddoc = "TK".
    WHEN 'LET' THEN x-coddoc = "LT".
    WHEN 'N/C' THEN x-coddoc = "NC".
    WHEN 'N/D' THEN x-coddoc = "ND".
    WHEN 'CHQ' THEN x-coddoc = "CD".
END CASE.
IF x-Detalle = NO THEN DO:
    /* UN SOLO NUMERO DE DOCUMENTO (SIN DETALLE) */
    ASSIGN
        X-NRODOC = SUBSTRING(Ccbcdocu.Nrodoc,1,3) + "111111"
        X-CODCLI = '1111111111'.
END.
ELSE DO:
    x-codcli = (IF gn-clie.codant = '' THEN SUBSTRING(gn-clie.codcli,1,10) ELSE gn-clie.codant).
END.
IF Ccbcdocu.FlgEst = "A" THEN x-codcta = (IF Ccbcdocu.Coddoc = "FAC" THEN "12122100" ELSE "12121140").

FIND T-WMIGRV WHERE T-WMIGRV.wvtdoc = x-coddoc
    AND T-WMIGRV.wvndoc = x-nrodoc
    AND T-WMIGRV.wvmone = x-codmon
    AND T-WMIGRV.wvcpvt = x-codcta
    AND T-WMIGRV.wvfech = x-FchDoc
    NO-ERROR.
IF NOT AVAILABLE T-WMIGRV THEN CREATE T-WMIGRV.
ASSIGN
    T-WMIGRV.FlagTipo = "I"
    T-WMIGRV.FlagUsuario = s-user-id.
ASSIGN
    T-WMIGRV.wsecue = 0001
    T-WMIGRV.wvejer = YEAR(ccbcdocu.fchdoc)
    T-WMIGRV.wvperi = MONTH(ccbcdocu.fchdoc)
    T-WMIGRV.wvtdoc = x-CodDoc
    T-WMIGRV.wvndoc = x-NroDoc
    T-WMIGRV.wvfech = x-FchDoc
    T-WMIGRV.wvccli = x-codcli
    T-WMIGRV.wvclie = SUBSTRING (gn-clie.nomcli, 1, 40)
    T-WMIGRV.wvcdir = (IF gn-clie.dircli <> '' THEN SUBSTRING (gn-clie.dircli, 1, 40) ELSE 'LIMA')
    T-WMIGRV.wvcdis = (IF AVAILABLE TabDistr THEN SUBSTRING (TabDistr.NomDistr, 1, 40) ELSE 'LIMA')
    T-WMIGRV.wvref3 = (IF ccbcdocu.codcli BEGINS '2' THEN "PJ" ELSE "NI")
    T-WMIGRV.wvtido = (IF ccbcdocu.codcli BEGINS '2' THEN "RU" ELSE "")
    T-WMIGRV.wvnudo = (IF ccbcdocu.codcli BEGINS '2' THEN gn-clie.ruc ELSE SUBSTRING(gn-clie.codcli, 3, 8))
    T-WMIGRV.wvmone = x-codmon
    T-WMIGRV.wvtcam = 0.00.            /* ccbcdocu.tpocmb. */
IF Ccbcdocu.flgest = "A" THEN DO:       /* ANULADO */
    ASSIGN
        T-WMIGRV.wvfepr = YEAR(TODAY) * 10000 + MONTH(TODAY) * 100 + DAY(TODAY)
        T-WMIGRV.wvfeve = YEAR(x-fchvto) * 10000 + MONTH(x-fchvto) * 100 + DAY(x-fchvto)
        T-WMIGRV.wvruc = ccbcdocu.ruccli
        T-WMIGRV.wvndom = (IF T-WMIGRV.wvruc = '' THEN "N" ELSE (IF T-WMIGRV.wvref3 = "PJ" THEN "S" ELSE "N"))
        T-WMIGRV.wvcpag = "888"         /* ccbcdocu.fmapgo */
        T-WMIGRV.wvsitu = "99"        /* ANULADO */
        T-WMIGRV.wvcost = "9999999"
        T-WMIGRV.wvcven = ccbcdocu.codven
        T-WMIGRV.wvacti = ccbcdocu.coddiv
        T-WMIGRV.wvnbco = ''  /* ver ticketeras */
        T-WMIGRV.wvusin = ccbcdocu.usuario
        T-WMIGRV.wvfein = YEAR(TODAY) * 10000 + MONTH(TODAY) * 100 + DAY(TODAY).
    RETURN.
END.
IF ccbcdocu.impbrt > 0 
    THEN ASSIGN
            T-WMIGRV.wvvalv = T-WMIGRV.wvvalv + CcbCDocu.ImpBrt
            T-WMIGRV.wvcval = cb-cfgg.codcta[5]
            T-WMIGRV.wvmval = (IF ccbcdocu.coddoc = "N/C" THEN "C" ELSE "A").
IF ccbcdocu.impexo > 0 
    THEN ASSIGN
            T-WMIGRV.wvvali = T-WMIGRV.wvvali + ccbcdocu.impexo
            T-WMIGRV.wvcvai = cb-cfgg.codcta[6]
            T-WMIGRV.wvmvai = ( IF ccbcdocu.coddoc = "N/C" THEN "C" ELSE "A" ).
IF ccbcdocu.impdto > 0 
    THEN ASSIGN
            T-WMIGRV.wvdsct = T-WMIGRV.wvdsct + ccbcdocu.impdto
            T-WMIGRV.wvcdsc = x-ctadto
            T-WMIGRV.wvmdsc = (IF ccbcdocu.coddoc = "N/C" THEN "A" ELSE "C").
IF ccbcdocu.impigv > 0 
    THEN ASSIGN
            T-WMIGRV.wvigv = T-WMIGRV.wvigv + ccbcdocu.impigv
            T-WMIGRV.wvcigv = x-ctaigv
            T-WMIGRV.wvmigv = (IF ccbcdocu.coddoc = "N/C" THEN "C" ELSE "A").
ASSIGN
    T-WMIGRV.wvpvta = T-WMIGRV.wvpvta + ccbcdocu.imptot
    T-WMIGRV.wvcpvt = x-codcta
    T-WMIGRV.wvmpvt = (IF ccbcdocu.coddoc = "N/C" THEN "A" ELSE "C").
IF ccbcdocu.coddoc = 'N/C' OR ccbcdocu.coddoc = 'N/D' THEN DO:
    CASE ccbcdocu.codref:
        WHEN 'FAC' THEN T-WMIGRV.wvtref = "FC".
        WHEN 'BOL' THEN T-WMIGRV.wvtref = "BV".
        WHEN 'TCK' THEN T-WMIGRV.wvtref = "TK".
        WHEN 'LET' THEN T-WMIGRV.wvtref = "LT".
        WHEN 'N/C' THEN T-WMIGRV.wvtref = "NC".
        WHEN 'N/D' THEN T-WMIGRV.wvtref = "ND".
        WHEN 'CHQ' THEN T-WMIGRV.wvtref = "CD".
    END CASE.
    ASSIGN
        T-WMIGRV.wvnref = ccbcdocu.nroref.
END.
ELSE DO:
    IF Ccbcdocu.codped = "PED" 
        THEN ASSIGN
                T-WMIGRV.wvtref = "PD"
                T-WMIGRV.wvnref = Ccbcdocu.nroped.
END.
ASSIGN
    T-WMIGRV.wvfepr = YEAR(TODAY) * 10000 + MONTH(TODAY) * 100 + DAY(TODAY)
    T-WMIGRV.wvfeve = YEAR(x-fchvto) * 10000 + MONTH(x-fchvto) * 100 + DAY(x-fchvto)
    T-WMIGRV.wvruc = ccbcdocu.ruccli
    T-WMIGRV.wvndom = (IF T-WMIGRV.wvruc = '' THEN "N" ELSE (IF T-WMIGRV.wvref3 = "PJ" THEN "S" ELSE "N"))
    T-WMIGRV.wvcpag = "888"         /*ccbcdocu.fmapgo*/
    T-WMIGRV.wvsitu = "02"        /* Graba en Cuentas por Cobrar */
    T-WMIGRV.wvcost = "9999999"
    T-WMIGRV.wvcven = ccbcdocu.codven
    T-WMIGRV.wvacti = ccbcdocu.coddiv
    T-WMIGRV.wvnbco = ''  /* ver ticketeras */
    T-WMIGRV.wvusin = ccbcdocu.usuario
    T-WMIGRV.wvfein = YEAR(TODAY) * 10000 + MONTH(TODAY) * 100 + DAY(TODAY).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Transferir-Asiento) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Transferir-Asiento Procedure 
PROCEDURE Transferir-Asiento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* BLOQUEAMOS Sí o Sí el correlativo */
REPEAT:
  FIND wmigcorr WHERE wmigcorr.Proceso = "RV"
      AND wmigcorr.Periodo = YEAR(Ccbcierr.fchcie)
      AND wmigcorr.Mes = MONTH(Ccbcierr.fchcie)
      EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
  IF NOT AVAILABLE wmigcorr THEN DO:
      IF NOT LOCKED wmigcorr THEN DO:
          /* CREAMOS EL CONTROL */
          CREATE wmigcorr.
          ASSIGN
              wmigcorr.Correlativo = 1
              wmigcorr.Mes = MONTH(Ccbcierr.fchcie)
              wmigcorr.Periodo = YEAR(Ccbcierr.fchcie)
              wmigcorr.Proceso = "RV".
          LEAVE.
      END.
      ELSE UNDO, RETRY.
  END.
  LEAVE.
END.
FOR EACH T-WMIGRV NO-LOCK:
  CREATE RPL-WMIGRV.
  BUFFER-COPY T-WMIGRV
      TO RPL-WMIGRV
      ASSIGN
      rpl-wmigrv.coddiv = s-coddiv
      rpl-wmigrv.flgest = "N"
      rpl-wmigrv.twcorre = STRING(wmigcorr.Periodo, '9999') + STRING(wmigcorr.Mes, '99') + 
                      STRING(wmigcorr.Correlativo, '9999')
      RPL-WMIGRV.FlagFecha = DATETIME(TODAY, MTIME)
      RPL-WMIGRV.FlagTipo = pTipo
      RPL-WMIGRV.FlagUsuario = s-user-id
      RPL-WMIGRV.wcorre = STRING(wmigcorr.Periodo, '9999') + STRING(wmigcorr.Mes, '99') + 
                      STRING(wmigcorr.Correlativo, '9999')
      RPL-WMIGRV.wsecue = 0001
      RPL-WMIGRV.wvejer = wmigcorr.Periodo
      RPL-WMIGRV.wvperi = wmigcorr.Mes.
  ASSIGN
    wmigcorr.Correlativo = wmigcorr.Correlativo +  1.
END.
IF AVAILABLE(wmigcorr) THEN RELEASE wmigcorr.
IF AVAILABLE(RPL-WMIGRV)   THEN RELEASE RPL-WMIGRV.
EMPTY TEMP-TABLE T-WMIGRV.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

