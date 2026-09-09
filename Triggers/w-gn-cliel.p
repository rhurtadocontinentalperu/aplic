TRIGGER PROCEDURE FOR WRITE OF Gn-ClieL.

DEF VAR k AS INT NO-UNDO.
DEF VAR x-LCSdoDiv LIKE gn-cliel.LCSdoDiv NO-UNDO.

x-LCSdoDiv = 0.
DO  k = 1 TO 20:
    x-LCSdoDiv = x-LCSdoDiv + Gn-ClieL.LCImpDiv[k]. 
END.
ASSIGN gn-cliel.LCSdoDiv = Gn-ClieL.ImpLC - x-LCSdoDiv.

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

cCodDiv = "*99*".
FIND FIRST gn-clie OF gn-clieL NO-LOCK NO-ERROR.
IF AVAILABLE gn-clie THEN cCodDiv = gn-clie.coddiv.

FIND FIRST vtatabla WHERE vtatabla.codcia = 1 AND vtatabla.tabla = cTabla AND
                            vtatabla.llave_c1 = cllave_c1 AND vtatabla.llave_c2 = cllave_c2 AND
                            vtatabla.llave_c3 = cLlave_c3 NO-LOCK NO-ERROR.
IF AVAILABLE vtatabla /*AND vtatabla.llave_c5 = cCodDiv*/ THEN DO:
    IF NOT (TRUE <> (vtatabla.llave_c4 > "")) THEN DO:
        cURL = TRIM(vtatabla.llave_c4).
        /*cURL = cURL + "/registercreditlinetosynchronizeriqra?CodCli=" + TRIM(gn-cliel.codcli).*/
        cURL = cURL + "/customer/registerchangescreditline2synchronizeriqra?codcli=" + TRIM(gn-cliel.codcli).

        RUN lib/http-get-contenido.r(cURL,output v-result,output v-response,output v-content).
    END.
END.


