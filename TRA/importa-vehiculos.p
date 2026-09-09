DEF VAR x-linea AS CHAR.
INPUT FROM d:\tmp\vehiculos.prn.
DEF VAR x-codpro LIKE gn-vehic.CodPro .
DEF VAR x-nompro AS CHAR.
DEF VAR x-placa LIKE gn-vehic.placa.
DEF VAR x-marca LIKE gn-vehic.Marca .
DEF VAR x-carga AS DEC.
DEF VAR x-libre_d01 AS DEC.
DEF VAR x-libre_c02 AS CHAR.
DEF VAR x-libre_c05 AS CHAR INIT 'SI'.

REPEAT :
    IMPORT UNFORMATTED x-linea.
    IF x-linea = '' THEN LEAVE.
    ASSIGN
        x-placa = SUBSTRING(x-linea,1,10)
        x-marca = SUBSTRING(x-linea,11,20)
        x-carga = DECIMAL(SUBSTRING(x-linea,31,10))
        x-libre_d01 = DECIMAL(SUBSTRING(x-linea,41,10))
        x-libre_c02 = SUBSTRING( x-linea,51,10)
        x-codpro = SUBSTRING(x-linea,61,15)
        x-nompro = SUBSTRING(x-linea,76).
    FIND gn-vehic WHERE codcia = 1 AND placa = x-placa EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-vehic THEN CREATE gn-vehic.
    ASSIGN
        gn-vehic.CodCia = 001
        gn-vehic.placa = x-placa
        gn-vehic.Marca = x-marca
        gn-vehic.Carga = x-carga
        gn-vehic.Libre_d01 = x-libre_d01
        gn-vehic.Libre_c02 = x-libre_c02
        gn-vehic.Libre_c05 = x-libre_c05.
    IF x-codpro <> '0' THEN DO:
        FIND gn-prov WHERE gn-prov.codcia = 000 AND
            gn-prov.codpro = x-codpro EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE gn-prov THEN DO:
            ASSIGN
                gn-vehic.codpro = x-codpro
                gn-prov.nompro = x-nompro.
        END.
    END.
END.
