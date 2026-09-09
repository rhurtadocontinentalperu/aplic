def buffer b-dmov for cb-dmov.
for each cb-dmov where codcia = 1 and codope = '054'
    and periodo = 2004 and nromes >= 10
    and coddoc = '03' and codcta = '121202'
    and codaux <> '11111111':
    find first b-dmov where b-dmov.codcia = 1 and b-dmov.codope = '062'
        and b-dmov.periodo = 2004 and b-dmov.nromes >= 0 and b-dmov.nromes < 10
        and b-dmov.coddoc = '03' and b-dmov.codcta = '121202'
        and b-dmov.nrodoc = cb-dmov.nrodoc
        no-lock no-error.
    if available b-dmov and b-dmov.codaux <> cb-dmov.codaux
    then do:
        display cb-dmov.codaux cb-dmov.coddoc cb-dmov.nrodoc b-dmov.codaux.
        cb-dmov.codaux = b-dmov.codaux.
    end.
end.
    
