TRIGGER PROCEDURE FOR WRITE OF Gn-Clie.

DEF SHARED VAR s-user-id AS CHAR.

FIND FIRST gn-cliecyg OF gn-clie NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-cliecyg THEN DO:
    CREATE gn-cliecyg.
    BUFFER-COPY gn-clie 
        EXCEPT gn-clie.ApeMat gn-clie.ApePat gn-clie.Nombre
        TO gn-cliecyg NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DELETE gn-cliecyg.
    RELEASE gn-cliecyg.
END.

/* CONTROL SAP */
&SCOPED-DEFINE SAP_ENABLE YES 

/* 1ro. Carga del GN-CLIE */
IF NEW gn-clie THEN DO:
    ASSIGN
        gn-clie.FlagFecha = STRING(DATETIME(TODAY, MTIME), '99/99/9999 HH:MM:SS')
        gn-clie.FlagMigracion = "N"
        gn-clie.FlagTipo      = "I"
        gn-clie.FlagUsuario   = s-user-id
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN ERROR.
END.
ELSE DO:
    ASSIGN
        gn-clie.FlagFecha = STRING(DATETIME(TODAY, MTIME), '99/99/9999 HH:MM:SS')
        gn-clie.FlagMigracion = "N"
        gn-clie.FlagTipo      = "U"
        gn-clie.FlagUsuario   = s-user-id.
END.

/* 2do. Sincronización RIQRA */
/* Ic - 13Set2023, Sincronizacion RIQRA */
DEFINE VAR cTabla AS CHAR INIT "CONFIG-RIQRA" NO-UNDO.
DEFINE VAR cLlave_c1 AS CHAR INIT "SINCRONIZACION" NO-UNDO.
DEFINE VAR cLlave_c2 AS CHAR INIT "URL" NO-UNDO.
DEFINE VAR cLlave_c3 AS CHAR INIT "" NO-UNDO.

DEFINE VAR cCodDiv AS CHAR INIT "" NO-UNDO.
DEFINE VAR cURL AS CHAR INIT "" NO-UNDO.

/* El contenido de la web */
define var v-result as char no-undo.
define var v-response as LONGCHAR no-undo.
define var v-content as LONGCHAR no-undo.

cCodDiv = gn-clie.coddiv.
IF cCodDiv = ? THEN cCodDiv = "".

FIND FIRST vtatabla WHERE vtatabla.codcia = 1 AND vtatabla.tabla = cTabla AND
                            vtatabla.llave_c1 = cllave_c1 AND vtatabla.llave_c2 = cllave_c2 AND
                            vtatabla.llave_c3 = cLlave_c3 NO-LOCK NO-ERROR.
IF AVAILABLE vtatabla THEN DO:
    IF NOT (TRUE <> (vtatabla.llave_c4 > "")) THEN DO:
        cURL = TRIM(vtatabla.llave_c4).

        cURL = cURL + "/customer/pendingupdate2riqra?codclie=" + TRIM(gn-clie.codcli) + "&coddiv=" + TRIM(cCodDiv).

        RUN lib/http-get-contenido.r(cURL,output v-result,output v-response,output v-content).
    END.
END.

/* 3ro. Carga GN-CLIED */
/* RHC 31/10/18 Se crea un registro en gn-clied automaticamente */
FIND FIRST gn-clied OF gn-clie WHERE gn-clied.sede = "@@@" NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-clied THEN DO:
    CREATE gn-clied.
    BUFFER-COPY gn-clie TO gn-clied
        ASSIGN
        Gn-ClieD.DomFiscal = YES
        Gn-ClieD.Sede = "@@@"   /* Valor que no se puede anular */
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN UNDO, RETURN ERROR.
    IF gn-clie.SwCargaSunat = "S" THEN  Gn-ClieD.SwSedeSunat = "S".
    FIND TabDistr WHERE TabDistr.CodDepto = Gn-ClieD.CodDept AND
        TabDistr.CodProvi = Gn-ClieD.CodProv AND
        TabDistr.CodDistr = Gn-ClieD.CodDist
        NO-LOCK NO-ERROR.
    IF AVAILABLE TabDistr THEN DO:
        ASSIGN
            Gn-ClieD.Codpos = TabDistr.CodPos NO-ERROR.
    END.

    &IF {&SAP_ENABLE} &THEN
        /* 03/03/2026: Creamos un registro para SAP */
        DEF BUFFER bgn-clied FOR gn-clied.
        CREATE bgn-clied.
        BUFFER-COPY gn-clied TO bgn-clied ASSIGN bgn-clied.Sede = "ALM" bgn-clied.DomFiscal = NO. /* Valor que no se puede anular */
    &ENDIF

    RELEASE gn-clied.
END.
/* ************************************************************** */

/* Parche */
IF gn-clie.FchIng <> ? AND gn-clie.FchAct = ? THEN gn-clie.FchAct = gn-clie.FchIng.
