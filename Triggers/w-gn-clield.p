TRIGGER PROCEDURE FOR WRITE OF Gn-ClieD.

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
FIND FIRST gn-clie OF gn-clieD NO-LOCK NO-ERROR.
IF AVAILABLE gn-clie THEN cCodDiv = gn-clie.coddiv.

FIND FIRST vtatabla WHERE vtatabla.codcia = 1 AND vtatabla.tabla = cTabla AND
                            vtatabla.llave_c1 = cllave_c1 AND vtatabla.llave_c2 = cllave_c2 AND
                            vtatabla.llave_c3 = cLlave_c3 NO-LOCK NO-ERROR.
IF AVAILABLE vtatabla /*AND cCodDiv = vtatabla.llave_c5*/ THEN DO:
    IF NOT (TRUE <> (vtatabla.llave_c4 > "")) THEN DO:
        cURL = TRIM(vtatabla.llave_c4).
        /*cURL = cURL + "/registerdeliverylocation?CodCli=" + TRIM(gn-clied.codcli)+ "&sede=" + TRIM(gn-clied.sede).*/
        cURL = cURL + "/customer/registerdeliverylocationpendingupdate2riqra?codclie=" + TRIM(gn-clied.codcli)+ "&sede=" + TRIM(gn-clied.sede).
        
        RUN lib/http-get-contenido.r(cURL,output v-result,output v-response,output v-content).
    END.
END.

/*http://127.0.0.1:9000/synchronizeriqra/registerdeliverylocation?CodCli=20100038146&sede=%40%40%40*/

/* ************************************************************************************ */
/* 06/02/2026 RUTINAS PARA EL SAP */
/* ************************************************************************************ */
/* CONTROL SAP */
&SCOPED-DEFINE SAP_ENABLE YES

&IF {&SAP_ENABLE} &THEN
DEFINE SHARED VAR s-user-id AS CHAR.
{sap/interface_sap.i &input_table=gn-clied}
&ENDIF
/* ************************************************************************************ */
/* ************************************************************************************ */
