def var x-cant as dec.
for each ccbddocu where
    codcia = 1 and 
    coddiv = '00011' and
        lookup(coddoc,'fac,bol,(n/c)') > 0 and
            fchdoc >= date(01,01,2003) and
            fchdoc <= date(31,12,2003)
            break by codmat
            no-lock :
        if first-of(codmat)
            then x-cant = 0.
            x-cant = x-cant + candes.
        if last-of(codmat)
            then do:
            display codmat x-cant.
    end.
    end.
end.
    
