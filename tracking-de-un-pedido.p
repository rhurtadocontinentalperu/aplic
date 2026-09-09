FOR EACH vtadtrkped WHERE codcia = 1
    AND coddoc = 'ped'
    AND nroped = '001045295':
    DISPLAY
        coddiv
        codubic
        flgsit
        codref FORMAT 'x(3)'
        nroref FORMAT 'x(9)'
        libre_c01 FORMAT 'x(3)'
        libre_c02 FORMAT 'x(9)'
        fechai
        fechat
        WITH STREAM-IO NO-BOX NO-LABELS WIDTH 200.

END.
