
DEFINE VAR x-DBname AS CHAR.
DEFINE VAR x-LDname AS CHAR.
DEFINE VAR x-IP     AS CHAR.
DEFINE VAR x-PORT   AS CHAR.
DEFINE VAR x-User   AS CHAR.
DEFINE VAR x-Pass   AS CHAR.

DEFINE VAR s-codcia AS INT INIT 1. 

DEFINE VAR x-conexion-ok AS LOG.
             
x-user = 'admin'.
FIND FIRST integral.factabla WHERE integral.factabla.codcia = s-codcia AND
                    integral.factabla.tabla = 'TDAS-UTILEX' AND 
                    integral.factabla.codigo = '00501' NO-LOCK NO-ERROR.

MESSAGE "Aquiiii".

IF AVAILABLE factabla THEN DO:
    x-DBname = "integral".
    x-LDname = "DBTDA".  /* + TRIM(factabla.codigo). */
    x-ip = TRIM(factabla.campo-c[1]).
    x-port = TRIM(factabla.campo-c[2]).
    x-Pass = TRIM(factabla.campo-c[3]).

    x-conexion-ok = NO.

    RUN lib/p-connect-db.p(INPUT x-DBname, INPUT x-LDname, INPUT x-ip, 
                         INPUT x-port, INPUT x-user, INPUT x-pass, OUTPUT x-conexion-ok).

    IF x-conexion-ok = YES THEN DO:
        RUN vtamin/w-vales-consumidos.w.
    END.
    ELSE DO:
        MESSAGE "Nose puede conectar a la base de datos " SKIP
                "Server " + x-ip + " puerto " + x-port SKIP
                "Por favor comuniquese con el area de soporte".
    END.

END.
ELSE DO:
    MESSAGE "No existe configiracion del servidor de Utilex".
END.


