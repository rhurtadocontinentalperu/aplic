DEF STREAM cab.
DEF STREAM det.

/*DEFINE VARIABLE lOpe AS CHARACTER INITIAL "002,005,058,059,060,065,070,071,075,076,080" .*/

/*
    001 : Entrada de Fondos
    059 : Salidas de Fondos    
    092 : Rendicion de Gastos
    002 : Pagos Bancarios
    061 : Canje Documentos (Pagos)
    060 : Compras    
*/

DEFINE VARIABLE lOpe AS CHARACTER INITIAL "059,002,061,060".

OUTPUT STREAM cab TO C:\Ciman\Atenciones\Contabilidad\cb-cmov.d.
OUTPUT STREAM det TO C:\Ciman\Atenciones\Contabilidad\cb-dmov.d.

FOR EACH cb-cmov WHERE codcia = 001
    AND periodo = 2015
    AND (nromes = 12)
    /*AND codope = '060'*/
    AND LOOKUP (codope, lOpe ) > 0 :
    EXPORT STREAM cab cb-cmov.
    
    FOR EACH cb-dmov OF cb-cmov:
        EXPORT STREAM det cb-dmov.
    END.
    
END.

/*
FOR EACH cb-cmov WHERE codcia = 001
    AND periodo = 2014
    AND (nromes = 12)
    AND codope = '059'
    AND nroast = '000423' :
    /*EXPORT STREAM cab cb-cmov.*/
    
    FOR EACH cb-dmov OF cb-cmov:
        EXPORT STREAM det cb-dmov.
    END.
    
END.
*/
OUTPUT STREAM cab CLOSE.
OUTPUT STREAM det CLOSE.

