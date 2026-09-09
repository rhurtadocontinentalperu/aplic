/*DEFINE VARIABLE lOpe AS CHARACTER INITIAL "005,058,059,065,070,071,075,076,080" .*/
DEFINE VARIABLE lOpe AS CHARACTER INITIAL "060,002".
    
FOR EACH cb-cmov WHERE codcia = 001
    AND periodo = 2015
    AND nromes = 12
    AND LOOKUP (codope, lOpe ) > 0 
    /*AND nroast < '000600'*/ :
    
    FOR EACH cb-dmov OF cb-cmov:
        DELETE cb-dmov.
    END.
    
    DELETE cb-cmov.
    /*DISPLAY nroast.*/
    PAUSE 0.
END.


